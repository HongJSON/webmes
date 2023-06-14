<%@ WebHandler Language="C#" Class="P01Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Collections.Generic;

public class P01Controller : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        string rtnValue = string.Empty;
        context.Response.ContentType = "text/plain";
        string funcName = context.Request["funcName"];
        string lot_id = context.Request["lot_id"];
        string user = context.Request["user"];
        int box_qty = Convert.ToInt32(context.Request["box_qty"]);
        switch (funcName)
        {
            case "getIP":
                rtnValue = GetIP();
                break;
            case "checkLotInfo":
                rtnValue = CheckLotInfo(lot_id, box_qty, user);
                break;
            case "showTmp":
                rtnValue = ShowTmp();
                break;
            case "clearTmp":
                rtnValue = ClearTmp();
                break;
            case "getBoxQty":
                rtnValue = GetBoxQty().ToString();
                break;
            case "addBox":
                rtnValue = AddBox(box_qty, user);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public static string GetIP()
    {
        try
        {
            string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString().ToUpper();
            return ip;
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    private static string CheckLotInfo(string lot_id, int box_qty, string user)
    {
        string sqlCheck = "SELECT * FROM SD_TMP_PACK WHERE LOT_ID = '" + lot_id + "'";
        DataTable dtCheck = PubClass.getdatatableMES(sqlCheck);
        if (dtCheck.Rows.Count > 0)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]已被刷入!\"}";
        }
        string sqlLot = "SELECT A.LOT_ID,A.ORDER_NO,A.PRODUCT_ID,STEP_CURRENT,B.MO_TYPE,LOT_STATUS,A.LOT_QTY,IS_LOCK,LOCK_CPU,A.ARY_LOT FROM SD_OP_LOTINFO A LEFT JOIN SD_OP_WORKORDER B ON A.ORDER_NO = B.ORDER_NO WHERE LOT_ID = '" + lot_id + "'";
        DataTable dtLot = PubClass.getdatatableMES(sqlLot);
        if (dtLot.Rows.Count == 0)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]不存在!\"}";
        }
        string sqlCheckDADUILOT = @"SELECT DISTINCT ARY_LOT FROM SD_OP_LOTINFO WHERE LOT_ID IN(
        SELECT LOT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + @"' UNION ALL 
        SELECT '" + dtLot.Rows[0]["ARY_LOT"].ToString() + "' LOT_ID FROM DUAL)";
        DataTable dtCheckDADUILOT = PubClass.getdatatableMES(sqlCheckDADUILOT);
        if (dtCheckDADUILOT.Rows.Count > 2)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]的大隊LOT與臨時表中大隊LOT超出混箱數量!\"}";
        }

        int lotqty = Convert.ToInt32(dtLot.Rows[0]["LOT_QTY"].ToString());
        string order_no = dtLot.Rows[0]["ORDER_NO"].ToString();
        string step_current = dtLot.Rows[0]["STEP_CURRENT"].ToString();
        string mo_type = dtLot.Rows[0]["MO_TYPE"].ToString();
        string lot_status = dtLot.Rows[0]["LOT_STATUS"].ToString();
        string is_lock = dtLot.Rows[0]["IS_LOCK"].ToString();
        string lock_cpu = dtLot.Rows[0]["LOCK_CPU"].ToString();
        string product_id = dtLot.Rows[0]["PRODUCT_ID"].ToString();
        if (step_current != "PA")
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]當前站點為[" + step_current + "]，不可包裝!\"}";
        }
        if (lot_status != "F")
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]當前狀態為[" + lot_status + "]，不為F包裝已點收，不可包裝!\"}";
        }
        if (is_lock != "N")
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]已被[" + lock_cpu + "]鎖定!\"}";
        }
        if (lotqty == 0)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]數量為0!\"}";
        }
        int totalQty = CheckTotalQty();
        if (totalQty >= box_qty)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"已滿箱，請勿再刷入LOT!\"}";
        }
        //Check 大隊LOT是否一致
        string sqlTmpDaDui = "SELECT DISTINCT ARY_LOT FROM SD_OP_LOTINFO WHERE LOT_ID IN(SELECT LOT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "' UNION SELECT '" + lot_id + "' FROM DUAL)";
        DataTable dtTmpDaDui = PubClass.getdatatableMES(sqlTmpDaDui);
        if (dtTmpDaDui.Rows.Count > 1)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]大隊LOT與臨時表中大隊LOT不一致!\"}";
        }

        string sqlTmps = "SELECT DISTINCT ORDER_NO,PRODUCT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "'";
        DataTable dtTmps = PubClass.getdatatableMES(sqlTmps);
        if (dtTmps.Rows.Count > 0)
        {
            if (product_id != dtTmps.Rows[0]["PRODUCT_ID"].ToString())
            {
                return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批號[" + lot_id + "]料號[" + product_id + "]與臨時表中料號不一致!\"}";
            }
        }
        string sqlUpdate = "UPDATE SD_OP_LOTINFO SET IS_LOCK = 'Y',LOCK_CPU = '" + GetIP() + "' WHERE LOT_ID = '" + lot_id + "'";
        PubClass.getdatatablenoreturnMES(sqlUpdate);
        int remainingQty = (totalQty + lotqty) >= box_qty ? totalQty + lotqty - box_qty : 0;
        string insertSql = "INSERT INTO SD_TMP_PACK(LOT_ID,ORDER_NO,PRODUCT_ID,QUANTITY,REMAINING_QTY,CREATE_USER,IP_ADDR) VALUES('" + lot_id + "','" + order_no + "','" + product_id + "'," + lotqty + "," + remainingQty + ",'" + user + "','" + GetIP() + "')";
        PubClass.getdatatablenoreturnMES(insertSql);
        return "{\"ERR_CODE\":\"N\",\"DATA\":{\"ORDER_NO\":\"" + order_no + "\",\"PRODUCT_ID\":\"" + product_id + "\",\"MO_TYPE\":\"" + mo_type + "\"}}";
    }

    private static string ShowTmp()
    {
        string sql = "SELECT LOT_ID,ORDER_NO,PRODUCT_ID,QUANTITY,REMAINING_QTY,QUANTITY-REMAINING_QTY PA_QTY,CREATE_USER,CREATE_DATE FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "' ORDER BY CREATE_DATE ASC";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }

    private static string ClearTmp()
    {
        string sqlLock = "UPDATE SD_OP_LOTINFO SET IS_LOCK = 'N',LOCK_CPU = NULL WHERE LOT_ID IN (SELECT LOT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "')";
        string sql = "DELETE FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "'";
        try
        {
            PubClass.getdatatablenoreturnMES(sqlLock);
            PubClass.getdatatablenoreturnMES(sql);
            return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"刪除成功!\"}";
        }
        catch (Exception ex)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + ex.Message + "!\"}";
        }
    }

    private static string AddBox(int box_qty, string user)
    {
        string sql = "SELECT DISTINCT PRODUCT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count != 1)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表中料號不一致!\"}";
        }
        string product_id = dt.Rows[0]["PRODUCT_ID"].ToString();
        int totalQty = CheckTotalQty();
        if (totalQty > box_qty)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"結箱數量不對，結箱數量為[" + totalQty + "],滿箱數量為[" + box_qty + "]!\"}";
        }
        string sqlCheckDADUILOT = @"SELECT DISTINCT ARY_LOT FROM SD_OP_LOTINFO WHERE LOT_ID IN(SELECT LOT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + @"')";
        DataTable dtCheckDADUILOT = PubClass.getdatatableMES(sqlCheckDADUILOT);
        if (dtCheckDADUILOT.Rows.Count > 2)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表中大隊LOT超出混箱數量!\"}";
        }

        List<string> sqlList = new List<string>();
        string sqlLot = "SELECT LOT_ID,PRODUCT_ID,CREATE_USER,QUANTITY,REMAINING_QTY FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "' AND REMAINING_QTY > 0";
        DataTable dtLot = PubClass.getdatatableMES(sqlLot);
        if (dtLot.Rows.Count > 0)
        {
            string remaining_qty = dtLot.Rows[0]["REMAINING_QTY"].ToString();
            string quantity = dtLot.Rows[0]["QUANTITY"].ToString();
            int pa_qty = Convert.ToInt32(quantity) - Convert.ToInt32(remaining_qty);
            string lot_id = dtLot.Rows[0]["LOT_ID"].ToString();
            //  更新有結餘LOT數量
            sqlList.Add("UPDATE SD_OP_LOTINFO SET LOT_QTY = " + remaining_qty + ",PA_QTY = (" + pa_qty + " + PA_QTY) WHERE LOT_ID = '" + lot_id + "'");
        }
        //  更新已包完LOT的狀態為P：已包裝(有結餘的LOT狀態不變)
        sqlList.Add("UPDATE SD_OP_LOTINFO SET LOT_STATUS = 'P',LOT_QTY = 0,PA_QTY = (LOT_QTY + PA_QTY) WHERE LOT_ID IN (SELECT LOT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "' AND REMAINING_QTY = 0)");
        string yyyyMMdd = "", SEQ = "";
        DataTable dtm = PubClass.getdatatableMES("SELECT TO_CHAR(SYSDATE,'yyyyMMdd') FROM DUAL");
        yyyyMMdd = dtm.Rows[0][0].ToString();
        DataTable dtBoxSeq = PubClass.getdatatableMES("SELECT LPAD(SEQ_BOXID.NEXTVAL,4,'0') FROM DUAL");
        SEQ = dtBoxSeq.Rows[0][0].ToString();
        string str_boxid = "HL" + yyyyMMdd + SEQ;
        //  箱號資料錄入
        sqlList.Add("INSERT INTO SD_OP_BOXDETAIL(BOX_ID,LOT_ID,ORDER_NO,PRODUCT_ID,QUANTITY) SELECT '" + str_boxid + "',LOT_ID,ORDER_NO,PRODUCT_ID,QUANTITY - REMAINING_QTY FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "'");
        sqlList.Add("INSERT INTO SD_OP_BOXMAIN(BOX_ID,PRODUCT_ID,WORK_SITE,QUANTITY,CREATE_USER) SELECT '" + str_boxid + "','" + product_id + "',1," + box_qty + ",'" + user + "' FROM DUAL");
        DataTable dtSeq = PubClass.getdatatableMES("SELECT SEQ_LOTSYSID.NEXTVAL FROM DUAL");
        string sysid = dtSeq.Rows[0][0].ToString();
        //  錄入過賬信息
        sqlList.Add(@"INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID,SYSID,STEP_ID,STEPM_ID,EQP_ID,OUSER,CREATE_USER,IN_QTY,OUT_QTY,LINEID,MO,MO_FLAG1,MO_FLAG2,MO_FLAG3,MO_BRWFLAG,NIFIID,LOTSTATUS)
        SELECT LOT_ID," + sysid + ",'PA','PA','NULL','" + user + "','" + user + "',A.QUANTITY - REMAINING_QTY,A.QUANTITY - REMAINING_QTY,'NULL',A.ORDER_NO,B.SITE,B.MO_TYPE,B.MODESC,'N',SEQ_LOTOPERMSG.NEXTVAL,'P' FROM SD_TMP_PACK A LEFT JOIN SD_OP_WORKORDER B ON A.ORDER_NO = B.ORDER_NO WHERE IP_ADDR = '" + GetIP() + "'");
        //  解除LOT鎖定
        sqlList.Add("UPDATE SD_OP_LOTINFO SET IS_LOCK = 'N' WHERE LOT_ID IN (SELECT LOT_ID FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "')");
        string strReturn = PubClass.excuteOts(sqlList);
        if (strReturn != "操作成功")
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"操作失敗!\"}";
        }
        ClearTmp();
        return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"操作成功!\",\"DATA\":{\"BOX_ID\":\"" + str_boxid + "\"}}";
    }

    private static int CheckTotalQty()
    {
        string sql = "SELECT DECODE(SUM(QUANTITY) - SUM(REMAINING_QTY),NULL,0,SUM(QUANTITY) - SUM(REMAINING_QTY)) QTY FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        return Convert.ToInt32(dt.Rows[0]["QTY"].ToString());
    }

    private static int GetBoxQty()
    {
        string sql = "SELECT DISTINCT BOX_QTY FROM SD_TMP_PACK WHERE IP_ADDR = '" + GetIP() + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count == 0)
        {
            return 60;
        }
        return Convert.ToInt32(dt.Rows[0]["BOX_QTY"].ToString());
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}