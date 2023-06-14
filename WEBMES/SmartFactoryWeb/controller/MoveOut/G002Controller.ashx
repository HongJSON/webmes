<%@ WebHandler Language="C#" Class="G002Controller" %>


using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Text;
using System.Data.OracleClient;
using System.IO;

public class G002Controller : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        //context.Response.Write("Hello World");
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string lotId = "";
        string stepId = "";
        string stepmid = "";
        string lineid = "";
        string eqpId = "";
        string operUser = "";
        string orderNo = "";
        string oper = "";
        string strUser = "";
        string codeId = "";
        switch (funcName)
        {
            case "getAD":
                rtnValue = getAD();
                break;
            case "tableOperMsg":
                lotId = context.Request["Lotid"];
                stepId = context.Request["stepId"];
                rtnValue = getTableOpermsg(lotId, stepId);
                break;
            case "tableNgmsg":
                //TODO GetParams
                lotId = context.Request["Lotid"];
                stepId = context.Request["stepId"];
                rtnValue = getTableNgmsg(lotId, stepId);
                break;
            case "getLotInformation":
                //TODO GetParams
                lotId = context.Request["Lotid"];
                rtnValue = getLotInformation(lotId);
                break;
            case "getStepm":
                lotId = context.Request["Lotid"];
                stepId = context.Request["Stepid"];
                rtnValue = getStepm(lotId, stepId);
                break;
            case "getStepmNext":
                lotId = context.Request["Lotid"];
                stepId = context.Request["Stepid"];
                stepmid = context.Request["Stepmid"];
                rtnValue = getStepmNext(lotId, stepId, stepmid);
                break;
            case "getLine":
                lotId = context.Request["Lotid"];
                stepmid = context.Request["Stepmid"];
                rtnValue = getLine(lotId, stepmid);
                break;
            case "getEQP":
                stepmid = context.Request["Stepmid"];
                lineid = context.Request["Lineid"];
                rtnValue = getEQP(stepmid, lineid);
                break;
            case "delTmpNgmsg":
                lotId = context.Request["Lotid"];
                stepmid = context.Request["Stepmid"];
                string errorcode = context.Request["Errorcode"];
                rtnValue = delTmpNgmsg(lotId, stepmid, errorcode);
                break;
            case "delTmpOper":
                lotId = context.Request["Lotid"];
                stepmid = context.Request["Stepmid"];
                eqpId = context.Request["eqpId"];
                operUser = context.Request["ouser"];
                rtnValue = delTmpOper(lotId, stepmid, eqpId, operUser);
                break;
            case "getMaterial":
                stepmid = context.Request["Stepmid"];
                rtnValue = getMaterial(stepmid);
                break;
            case "getMaterialOne":
                lotId = context.Request["Lotid"];
                stepId = context.Request["Stepid"];
                rtnValue = getMaterialOne(lotId, stepId);
                break;
            case "getOperUser":
                stepmid = context.Request["Stepmid"];
                eqpId = context.Request["eqpId"];
                lineid = context.Request["Lineid"];
                rtnValue = getOperUser(lineid, eqpId, stepmid);
                break;
            //case "getJijieOrder":
            //    orderNo = context.Request["orderNo"];
            //    rtnValue = getJijieOrder(orderNo);
            //    break;
            case "OperUserInsert":
               lotId = context.Request["Lotid"];
                eqpId = context.Request["eqpId"];
                oper = context.Request["oper"];
                stepId = context.Request["Stepid"];
                stepmid = context.Request["Stepmid"];
                string str_material1 = context.Request["material1"];
                string str_materialitem1 = context.Request["materialitem1"];
                string str_materialitem1s = context.Request["materialitem1s"];
                string str_material2 = context.Request["material2"];
                string str_materialitem2 = context.Request["materialitem2"];
                string str_materialitem2s = context.Request["materialitem2s"];
                string str_material3 = context.Request["material3"];
                string str_materialitem3 = context.Request["materialitem3"];
                string str_materialitem3s = context.Request["materialitem3s"];
                string str_material4 = context.Request["material4"];
                string str_materialitem4 = context.Request["materialitem4"];
                string str_materialitem4s = context.Request["materialitem4s"];

                rtnValue = OperUserInsert(lotId, eqpId, oper, stepId, stepmid,
                    str_material1, str_materialitem1, str_materialitem1s, str_material2, str_materialitem2, str_materialitem2s,
                    str_material3, str_materialitem3, str_materialitem3s, str_material4, str_materialitem4, str_materialitem4s);
                break;
            case "getErrorCode":
                lotId = context.Request["Lotid"];
                stepmid = context.Request["Stepmid"];
                orderNo = context.Request["orderNo"];
                rtnValue = getErrorCode(lotId, stepmid, orderNo);
                break;
            case "NgmsgInsert":
                lotId = context.Request["Lotid"];
                stepId = context.Request["Stepid"];
                stepmid = context.Request["Stepmid"];
                string Ngnum = context.Request["Ngnum"];
                string Errorcode = context.Request["Errorcode"];
                string strRemark = context.Request["strRemark"];
                strUser = context.Request["strUser"];
                rtnValue = NgmsgInsert(lotId, stepId, stepmid, Ngnum, Errorcode, strRemark, strUser);
                break;
            case "BtnMoveout":
                lotId = context.Request["Lotid"];
                stepId = context.Request["Stepid"];
                strUser = context.Request["strUser"];
                codeId = context.Request["codeId"];
                orderNo = context.Request["orderNo"];
                rtnValue = BtnMoveout(lotId, stepId, strUser, codeId, orderNo);
                break;
        }
        context.Response.Write(rtnValue);

    }

 

    private string getAD()
    {
        string rtn;
        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("CIM\\", "");
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");
        rtn = "[{\"USER_ID\":\"" + str_loginhost + "\"}]";
        
        if (HttpContext.Current.IsDebuggingEnabled)
        {
            rtn = "[{\"USER_ID\":\"F1-01_CELL\"}]";
        }

        return rtn;
    }

    private string getTableOpermsg(string str_Lot, string stepId)
    {
        string sql = "SELECT STEPM_ID,EQP_ID,OUSER||':'||NAME_IN_CHINESE OUSER FROM SD_TMP_OPERMSG,SD_CAT_HRS WHERE USER_ID=OUSER AND LOT_ID='" + str_Lot + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string getTableNgmsg(string str_Lot, string stepId)
    {
        string sql = "SELECT A1.LOT_ID,A1.STEPM_ID,A1.NGQTY,A1.REASON_CODE||':'||A2.CODE_NAME ERROR_CODE FROM SD_TMP_LOTNGMSG A1,SD_BASE_CODE A2 WHERE A2.CODE_ID=A1.REASON_CODE AND LOT_ID='" + str_Lot + "' ORDER BY A1.STEPM_ID DESC";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string getMaterial(string stepmId)
    {
        string sql = "SELECT ITEM_TYPE FROM SD_BASE_STEPMATERIAL WHERE STEPM_ID='" + stepmId + "' ORDER BY ORDER_BY";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string getMaterialOne(string str_Lot, string stepId)
    {
        string rtn = "";
        string sql1 = @"SELECT A2.STEPM_ID FROM SD_OP_LOTINFO A1, SD_BASE_STEPM A2
                 WHERE A1.PROCESS_NAME = A2.PROCESS_NAME AND A1.LOT_ID = '" + str_Lot + @"' AND A2.STEP_ID = '" + stepId + @"' ORDER BY A2.STEP_ORDER";
        DataTable dt1 = PubClass.getdatatableMES(sql1);
        if (dt1.Rows.Count >= 1)
        {
            string sql = "SELECT ITEM_TYPE FROM SD_BASE_STEPMATERIAL WHERE STEPM_ID='" + dt1.Rows[0][0].ToString() + "' ORDER BY ORDER_BY";
            DataTable dt = PubClass.getdatatableMES(sql);
            rtn = JsonConvert.SerializeObject(dt);
        }
        return rtn;
    }

    private string getErrorCode(string str_lot, string stepmId, string orderno)
    {
        string CODE_PRODUCT = "";
        string sqlorder = @"SELECT MO_TYPE FROM SD_OP_WORKORDER WHERE ORDER_NO IN(SELECT ORDER_NO FROM SD_OP_LOTINFO WHERE LOT_ID='" + str_lot + "')";
        DataTable dtorder = PubClass.getdatatableMES(sqlorder);

        CODE_PRODUCT = dtorder.Rows[0][0].ToString();
        string sql = @"SELECT A1.STEPM_ID, A2.STEP_DESC FROM SD_BASE_STEPM A1, SD_BASE_STEP A2 
                       WHERE PROCESS_NAME = (SELECT PROCESS_NAME FROM SD_OP_LOTINFO WHERE LOT_ID = '" + str_lot + @"') 
                       AND A1.STEP_ID=(SELECT STEP_CURRENT FROM SD_OP_LOTINFO WHERE LOT_ID = '" + str_lot + @"')
                       AND A1.STEPM_ID = A2.STEP_ID ORDER BY A1.STEP_ORDER";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (stepmId == "null" || stepmId.ToString().Length == 0)
        {
            if (dt.Rows.Count > 0)
            {
                stepmId = dt.Rows[0]["STEPM_ID"].ToString();
            }
        }
        string sqlCode = "";

        sqlCode = "SELECT  DISTINCT A2.CODE_ID,A2.CODE_ID||':'||A2.CODE_NAME CODE_NAME FROM SD_BASE_CODSTEP A1,SD_BASE_CODE A2 WHERE A1.CODE_ID=A2.CODE_ID  ";
        if (stepmId.ToString().Length > 0 && stepmId.ToString() != "null")
        {
            sqlCode += "AND A1.STEP_ID='" + stepmId + "' AND A2.FLAG='Y' AND  A1.CODE_PRODUCT='" + CODE_PRODUCT + "' AND  NVL(CODE_TYPE1,0)='0' ORDER BY A2.CODE_ID";
        }
        else
        {
            sqlCode += "AND A2.FLAG='Y' AND  A1.CODE_PRODUCT='" + CODE_PRODUCT + "' AND  NVL(CODE_TYPE1,0)='0' ORDER BY A2.CODE_ID";
        }



        DataTable dtcode = PubClass.getdatatableMES(sqlCode);
        string rtn = JsonConvert.SerializeObject(dtcode);
        return rtn;
    }

    private string getLotInformation(string str_Lot)
    {
        string rtn;


        string sql = @"SELECT B1.* , 'N' ERR_CODE FROM (
                        SELECT A1.LOT_ID, A1.PRODUCT_ID, A1.LOT_STATUS,A1.ORDER_NO ,A1.STEP_CURRENT, A1.IS_LOCK, A1.LOCK_CPU , A2.ID_ORDER, A2.MODESC, A2.MOTYPE , A1.LOT_QTY, A1.PROCESS_NAME,
                        A1.CREATE_DATE, TO_CHAR(A2.DUE_DATE,'yyyyMMdd') DUE_DATE, TO_CHAR(A2.REALWORK_DATE,'yyyyMMdd') REALWORK_DATE,
                        A2.MO_TYPE
                        FROM SD_OP_LOTINFO A1,SD_OP_WORKORDER A2 
                        WHERE A1.ORDER_NO=A2.ORDER_NO AND LOT_ID='" + str_Lot + @"') B1";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count > 0)
        {
            string lot_stepcurrent = dt.Rows[0]["STEP_CURRENT"].ToString();
            string lot_modesc = dt.Rows[0]["MODESC"].ToString();
            string lot_motype = dt.Rows[0]["MOTYPE"].ToString();
            string lot_status = dt.Rows[0]["LOT_STATUS"].ToString();


            if (dt.Rows[0]["LOT_QTY"].ToString() == "0")
            {
                rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此LOT數量已為0，無需過賬!\"}]";
                return rtn;
            }

            //刪除遺留臨時數據
            PubClass.getdatatablenoreturnMES("DELETE FROM SD_TMP_LOTNGMSG WHERE LOT_ID='" + str_Lot + "'");
            PubClass.getdatatablenoreturnMES("DELETE FROM SD_TMP_OPERMSG WHERE LOT_ID='" + str_Lot + "'");

        }
        else
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"沒有找到此批號资料!\"}]";
            return rtn;
        }


        rtn = JsonConvert.SerializeObject(dt);

        return rtn;
    }



    private string OperUserInsert(string lotId, string eqpId, string oper, string stepId, string stepmid,string str_material1, string str_materialitem1, string str_materialitem1s, string str_material2, string str_materialitem2, string str_materialitem2s,
                    string str_material3, string str_materialitem3, string str_materialitem3s, string str_material4, string str_materialitem4, string str_materialitem4s)
    {
        string rtn;
        DataTable dtlot = PubClass.getdatatableMES("SELECT PROCESS_NAME FROM SD_OP_LOTINFO WHERE LOT_ID = '" + lotId + "'");
        if (dtlot.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"沒有找到此批號资料!\"}]";
            return rtn;
        }
        
        oper = oper.Split(':')[0].ToString();
        DataTable dtoper = PubClass.getdatatableMES("SELECT * FROM SD_CAT_HRS WHERE USER_ID = '" + oper + "'");
        if (dtoper.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此人員信息丟失，請聯繫IT!\"}]";
            return rtn;
        }

        DataTable dtlotoper = PubClass.getdatatableMES("SELECT * FROM SD_TMP_OPERMSG WHERE LOT_ID='" + lotId + "' AND STEPM_ID='" + stepmid + "'");
        if (dtlotoper.Rows.Count > 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"列表中已有此lot此小站點紀錄!\"}]";
            return rtn;
        }

        DataTable dtlotoper2 = PubClass.getdatatableMES("SELECT * FROM SD_TMP_OPERMSG WHERE LOT_ID='" + lotId + "' AND EQP_ID='" + eqpId + "' AND OUSER='" + oper + "' AND STEP_ID='" + stepId + "' AND STEPM_ID='" + stepmid + "'");
        if (dtlotoper2.Rows.Count > 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"列表中已有此筆紀錄!\"}]";
            return rtn;
        }

        PubClass.getdatatablenoreturnMES(@"INSERT INTO SD_TMP_OPERMSG(LOT_ID,EQP_ID,OUSER,STEP_ID,STEPM_ID,PASSCOUNT,MATERIAL_TYPE1,MATERIAL_LOT11,MATERIAL_LOT12,MATERIAL_TYPE2,MATERIAL_LOT21,MATERIAL_LOT22,MATERIAL_TYPE3,MATERIAL_LOT31,MATERIAL_LOT32,MATERIAL_TYPE4,MATERIAL_LOT41,MATERIAL_LOT42) 
                    VALUES('" + lotId + "','" + eqpId + "','" + oper + "','" + stepId + "','" + stepmid + "',1,'" + str_material1 + @"',
             '" + str_materialitem1 + "','" + str_materialitem1s + "','" + str_material2 + "','" + str_materialitem2 + "','" + str_materialitem2s + "','" + str_material3 + "','" + str_materialitem3 + "','" + str_materialitem3s + "','" + str_material4 + "','" + str_materialitem4 + "','" + str_materialitem4s + "')");

        rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"資料錄入成功\"}]";
        return rtn;

    }


    private string NgmsgInsert(string lotId, string stepId, string stepmid, string Ngnum, string Errorcode,  string strRemark, string strUser)
    {
        string rtn;
        string CheckMsg = Ngnum + "," + lotId + "," + stepId + "," + stepmid + "," + Errorcode + ",";

        try
        {
            Convert.ToInt32(Ngnum);
        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"不良數量請輸入數字!\"}]";
            return rtn;
        }


        string sqlcheck1X = "SELECT F_MOVENG('" + CheckMsg + "','" + strUser + "') VARCHECKRE  FROM DUAL";
        DataTable dtCheckMsg1 = PubClass.getdatatableMES(sqlcheck1X);
        if (dtCheckMsg1.Rows[0][0].ToString().Length >= 4)
        {
            string chipid = "";
            if (dtCheckMsg1.Rows[0][0].ToString().Substring(0, 4) != "PASS")
            {
                rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"存在異常,原因" + dtCheckMsg1.Rows[0][0].ToString() + "!\"}]";
                return rtn;
            }
            else
            {
                string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
                str_loginhost = str_loginhost.Replace("CIM\\", "");
                str_loginhost = str_loginhost.Replace("WKSCN\\", "");
                
                PubClass.getdatatablenoreturnMES("INSERT INTO SD_TMP_LOTNGMSG(LOT_ID,REASON_CODE,STEPM_ID,NGQTY,REMARK,IP_ADDR) VALUES('" + lotId + "','" + Errorcode + "','" + stepmid + "','" + Ngnum + "','" + strRemark + "','" + str_loginhost + "')");

                rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"資料錄入成功\"}]";
                return rtn;
            }
        }
        else
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"存在異常,原因" + dtCheckMsg1.Rows[0][0].ToString() + "!\"}]";
            return rtn;
        }

    }

    private string getStepm(string str_lot, string stepId)
    {
        string sql = @" SELECT A1.STEPM_ID, A2.STEP_DESC FROM SD_BASE_STEPM A1, SD_BASE_STEP A2 
              WHERE PROCESS_NAME = (SELECT PROCESS_NAME FROM SD_OP_LOTINFO WHERE LOT_ID = '" + str_lot + @"') AND A1.STEP_ID = '" + stepId + @"'
              AND A1.STEPM_ID = A2.STEP_ID ORDER BY A1.STEP_ORDER ";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string getStepmNext(string str_lot, string stepId, string stepmId)
    {
        string rtn = "";
        string sql = @"SELECT MIN(STEP_ORDER) STEP_ORDER FROM SD_BASE_STEPM WHERE PROCESS_NAME = (SELECT PROCESS_NAME FROM SD_OP_LOTINFO WHERE LOT_ID = '" + str_lot + @"') AND STEP_ID = '" + stepId + @"'
                AND STEP_ORDER > (SELECT STEP_ORDER FROM SD_BASE_STEPM WHERE PROCESS_NAME = (SELECT PROCESS_NAME FROM SD_OP_LOTINFO WHERE LOT_ID = '" + str_lot + @"') AND STEP_ID = '" + stepId + @"' AND STEPM_ID = '" + stepmId + @"')";
        DataTable dtstepmorder = PubClass.getdatatableMES(sql);
        if (dtstepmorder.Rows.Count > 0)
        {
            DataTable dtstepm = PubClass.getdatatableMES("SELECT STEPM_ID FROM SD_BASE_STEPM WHERE PROCESS_NAME = (SELECT PROCESS_NAME FROM SD_OP_LOTINFO WHERE LOT_ID = '" + str_lot + @"') AND STEP_ID = '" + stepId + @"' AND STEP_ORDER = '" + dtstepmorder.Rows[0][0].ToString() + "'");
            if (dtstepm.Rows.Count > 0)
            {
                rtn = "[{\"STEPM_ID\":\"" + dtstepm.Rows[0][0].ToString() + "\"}]";
            }

        }
        return rtn;
    }

    private string getLine(string str_lot, string stepmId)
    {
        string sql = @"SELECT LINE_CODE FROM SD_BASE_LINE WHERE LINE_CODE LIKE 'F%' GROUP BY LINE_CODE ORDER BY LINE_CODE";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string getEQP(string stepmId, string lineId)
    {
        string sql = @"SELECT EQP_ID FROM SD_BASE_EQP WHERE STEP_ID='" + stepmId + "' AND (LINE_ID='" + lineId + "' OR LINE_ID='NULL' OR LINE_ID='NULL1') ORDER BY EQP_ID";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count > 0)
        {
            string rtn = JsonConvert.SerializeObject(dt);
            return rtn;
        }
        else
        {
            string rtn = "[{\"EQP_ID\":\"NULL\"}]";
            return rtn;
        }
    }

    private string getOperUser(string LineId, string EqpId, string stepmId)
    {
        string sql = "SELECT USER_ID,USER_ID||':'||USER_NAME USER_NAME FROM SD_OP_ONLINEUSER WHERE LINE_ID='" + LineId + "' AND STEP_ID='" + stepmId + "' AND EQP_ID='" + EqpId + "' AND ONLINE_TIME+INTERVAL '12' HOUR>SYSDATE AND FLAG='Y'";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    private string delTmpNgmsg(string str_lot, string stepmId, string errorcode)
    {
        errorcode = errorcode.Split(':')[0].ToString();
        string sql = @"DELETE FROM SD_TMP_LOTNGMSG WHERE LOT_ID = '" + str_lot + "'AND STEPM_ID='" + stepmId + "' AND REASON_CODE='"+ errorcode +"'";
        PubClass.getdatatablenoreturnMES(sql);

        return JsonConvert.SerializeObject("success");
    }

    private string delTmpOper(string str_lot, string stepmId, string eqpId, string operUser)
    {
        string[] str_l = operUser.Split(':');
        string sql = @"DELETE FROM SD_TMP_OPERMSG WHERE LOT_ID = '" + str_lot + "'AND STEPM_ID='" + stepmId + "' AND EQP_ID ='" + eqpId + "' AND OUSER = '" + str_l[0].ToString() + "'";
        PubClass.getdatatablenoreturnMES(sql);

        return JsonConvert.SerializeObject("success");
    }


    private string BtnMoveout(string str_lot, string stepId, string strUser, string strCode, string orderNo)
    {
        string rtn = "";
        DataTable dtoper = PubClass.getdatatableMES("SELECT * FROM SD_TMP_OPERMSG WHERE LOT_ID='" + str_lot + "'");
        if (dtoper.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"請先鍵入實際操作者信息!\"}]";
            return rtn;
        }
        DataTable dtstep = PubClass.getdatatableMES("SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID='" + str_lot + "'");
        if (dtstep.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"找不到此批號!\"}]";
            return rtn;
        }
        if (dtstep.Rows[0]["step_current"].ToString() != stepId)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批目前在" + dtstep.Rows[0]["step_current"].ToString() + "站!\"}]";
            return rtn;
        }


        string sqlmo = "SELECT * FROM SD_OP_WORKORDER WHERE ORDER_NO IN(SELECT ORDER_NO FROM SD_OP_LOTINFO WHERE LOT_ID='" + str_lot + "')";
        DataTable dtmo = PubClass.getdatatableMES(sqlmo);
        string strtype = dtmo.Rows[0]["MOTYPE"].ToString();
        
        
        
        
        
        string str_Y = System.DateTime.Now.Year.ToString().Substring(2, 2);
        string str_M = System.DateTime.Now.Month.ToString();

        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("CIM\\", "");
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");

        string lotlock = "UPDATE SD_OP_LOTINFO SET IS_LOCK ='Y', LOCK_CPU = '" + str_loginhost + "' WHERE LOT_ID = '" + str_lot + "'";
        PubClass.getdatatablenoreturnMES(lotlock);

        ////str_loginhost = "F1-01_MTP1";
        //string step_id = str_loginhost;

        string[] strArray1 = str_loginhost.Split('_');
        //step_id = strArray1[0].ToString();
        string line = strArray1[0].ToString();

        string sqlmmk1 = "SELECT IS_LOCK FROM LOCK_TYPE WHERE TYPE_NAME='MOVEOUT' AND LOT_ID='" + str_lot + "'";
        DataTable dtmmk1 = PubClass.getdatatableMES(sqlmmk1);
        if (dtmmk1.Rows.Count == 0)
        {
            string sqlup1 = "INSERT INTO LOCK_TYPE (TYPE_NAME,IS_LOCK,LOT_ID) VALUES ('MOVEOUT','Y','" + str_lot + "')";
            PubClass.getdatatablenoreturnMES(sqlup1);
        }
        else
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此批正在過賬中,請稍後\"}]";
            return rtn;
        }

        string MsgResult = "";
        OracleConnection con = PubClass.dbconMES();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();
        try
        {
            OracleCommand cmd1 = new OracleCommand("P_MOVEOUT", con);
            cmd1.CommandType = CommandType.StoredProcedure;
            OracleParameter par1 = new OracleParameter("LotID", OracleType.VarChar, 50);
            par1.Direction = ParameterDirection.Input;
            par1.Value = str_lot;
            OracleParameter par2 = new OracleParameter("opuser", OracleType.VarChar, 50);
            par2.Direction = ParameterDirection.Input;
            par2.Value = strUser;
            OracleParameter par4 = new OracleParameter("lineid", OracleType.VarChar, 50);
            par4.Direction = ParameterDirection.Input;
            par4.Value = line;
            OracleParameter par3 = new OracleParameter("MsgResult", OracleType.VarChar, 500);
            par3.Direction = ParameterDirection.Output;

            cmd1.Parameters.Add(par1);
            cmd1.Parameters.Add(par2);
            cmd1.Parameters.Add(par3);
            cmd1.Parameters.Add(par4);

            cmd1.Transaction = ots;
            cmd1.ExecuteNonQuery();
            ots.Commit();
            //ots.Rollback();
            con.Close();
            MsgResult = par3.Value.ToString();
        }
        catch
        {
            ots.Rollback();
            con.Close();
            MsgResult = "NG:過帳失敗！";
        }

        if (MsgResult.Substring(0, 2) != "NG")
        {
            PubClass.getdatatablenoreturnMES("UPDATE SD_OP_LOTINFO SET IS_LOCK='N' WHERE LOT_ID='" + str_lot + "'");
            string sqlup2 = "DELETE FROM LOCK_TYPE WHERE TYPE_NAME='MOVEOUT' AND LOT_ID='" + str_lot + "'";
            PubClass.getdatatablenoreturnMES(sqlup2);

        }
        else
        {
            PubClass.getdatatablenoreturnMES("UPDATE SD_OP_LOTINFO SET IS_LOCK='N' WHERE LOT_ID='" + str_lot + "'");
            string sqlup2 = "DELETE FROM LOCK_TYPE WHERE TYPE_NAME='MOVEOUT' AND LOT_ID='" + str_lot + "'";
            PubClass.getdatatablenoreturnMES(sqlup2);
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + MsgResult.Substring(2) + "\"}]";
            return rtn;
        }

        rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬成功!\"}]";
        return rtn;
    }


}