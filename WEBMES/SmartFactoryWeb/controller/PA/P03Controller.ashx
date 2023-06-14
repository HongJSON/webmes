<%@ WebHandler Language="C#" Class="P03Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Collections.Generic;

public class P03Controller : IHttpHandler
{
    public void ProcessRequest (HttpContext context) {
        string rtnValue = string.Empty;
        context.Response.ContentType = "text/plain";
        string funcName = context.Request["funcName"];
        string elot_id = context.Request["elot_id"];
        string user = context.Request["user"];
        switch (funcName)
        {
            case "getIP":
                rtnValue = GetIP();
                break;
            case "PAReceive":
                rtnValue = PAReceive(elot_id, user);
                break;
            case "insertTmp":
                rtnValue = InsertTmp(elot_id);
                break;
            case "showTmp":
                rtnValue = ShowTmp(elot_id);
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

    private string PAReceive(string elot_id, string user)
    {
        string sqlLot = "SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID = '" + elot_id + "' AND IN_QTY > 0 AND FLAG  = 'Y'";
        DataTable dtLot = PubClass.getdatatableMES(sqlLot);
        if (dtLot.Rows.Count > 0)
        {
            List<string> sqlList = new List<string>();
            for (int i = 0; i < dtLot.Rows.Count; i++)
            {
                string lot_id = dtLot.Rows[i]["LOT_ID"].ToString();
                string sqlLotQty = "SELECT LOT_QTY FROM SD_OP_LOTINFO WHERE LOT_ID = '" + lot_id + "'";
                DataTable dtLotQty = PubClass.getdatatableMES(sqlLotQty);
                int lot_qty = 0;
                if (dtLotQty.Rows.Count == 0)
                {
                    return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"未找到此LOT[" + lot_id + "]信息，請檢查LOT是否正常！\"}";
                } else
                {
                    lot_qty = Convert.ToInt32(dtLotQty.Rows[0][0].ToString());
                    if (lot_qty <= 0) {
                        return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此LOT[" + lot_id + "]數量異常，請聯繫IT！\"}";
                    } else
                    {
                        //  插入PA點收信息
                        sqlList.Add(@"INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID,SYSID,STEP_ID,STEPM_ID,EQP_ID,OUSER,CREATE_USER,IN_QTY,OUT_QTY,LINEID,MO,MO_FLAG1,MO_FLAG2,MO_FLAG3,MO_BRWFLAG,NIFIID,LOTSTATUS) 
                        SELECT A.LOT_ID,SEQ_LOTSYSID.NEXTVAL,'PA','PA','NULL','" + user + "','" + user + "',A.LOT_QTY,A.LOT_QTY,A.LINE_ID,A.ORDER_NO,B.SITE,B.MO_TYPE,B.MODESC,'N',SEQ_LOTOPERMSG.NEXTVAL,'R' FROM SD_OP_LOTINFO A LEFT JOIN SD_OP_WORKORDER B ON A.ORDER_NO = B.ORDER_NO WHERE A.LOT_ID = '" + lot_id + "'");
                        sqlList.Add("UPDATE SD_OP_LOTINFO SET LOT_STATUS = 'F' WHERE LOT_ID = '" + lot_id + "'");
                    }

                }
            }
            string strReturn = PubClass.excuteOts(sqlList);
            if (strReturn != "操作成功")
            {
                return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"點收失敗，請聯繫IT！\"}";
            } else
            {
                return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"點收成功！\"}";
            }
        } else
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"請刷入正確的Elot號！\"}";
        }
    }

    private string ShowTmp(string elot_id)
    {
        string sql = "SELECT LOT_ID,PRODUCT_ID,CASE LOT_STATUS WHEN 'W' THEN '未點收' WHEN 'F' THEN '已點收' ELSE '異常' END PA_FLAG FROM SD_OP_LOTINFO WHERE LOT_ID IN (SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID='" + elot_id + "' AND FLAG='Y')";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }

    private string InsertTmp(string elot_id)
    {
        int qty = 0;
        string sqlPAFlag = "SELECT DISTINCT LOT_STATUS FROM SD_OP_LOTINFO WHERE LOT_ID IN (SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID ='" + elot_id + "')";
        DataTable dtPAFlag = PubClass.getdatatableMES(sqlPAFlag);
        if (dtPAFlag.Rows.Count == 1 && dtPAFlag.Rows[0][0].ToString() == "P")
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此大批號下小批已全部點收！\"}";
        }
        string sqlLot = "SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID = '" + elot_id + "' AND IN_QTY > 0 AND FLAG = 'Y'";
        DataTable dtLot = PubClass.getdatatableMES(sqlLot);
        if (dtLot.Rows.Count > 0)
        {
            for (int i = 0; i < dtLot.Rows.Count; i++)
            {
                string lot_id = dtLot.Rows[i]["LOT_ID"].ToString();
                string sqlLotinfo = "SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID = '" + lot_id + "'";
                DataTable dtLotinfo = PubClass.getdatatableMES(sqlLotinfo);
                if (dtLotinfo.Rows[0]["STEP_CURRENT"].ToString() != "PA")
                {
                    return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此大批號下所屬小批[" + lot_id + "]不在PA站點！\"}";
                }
                if (dtLotinfo.Rows[0]["LOT_STATUS"].ToString() != "W")
                {
                    return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此大批號下所屬小批[" + lot_id + "]狀態不為W，不可點收！\"}";
                }
                qty += Convert.ToInt32(dtLotinfo.Rows[0]["LOT_QTY"].ToString());
            }
            return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + qty + "\"}";
        } else
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"請刷入正確的Elot號\"}";
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}