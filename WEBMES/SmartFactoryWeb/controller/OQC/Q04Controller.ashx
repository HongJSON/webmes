<%@ WebHandler Language="C#" Class="Q04Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Data.OracleClient;
using System.IO;
using System.Net;
using System.Reflection;
using System.Collections.Generic;

public class Q04Controller : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string ip = context.Request["ip"];
        string lotid = context.Request["lotid"];
        string user = context.Request["user"];
        string ouser = context.Request["ouser"];
        string mo_type = context.Request["mo_type"];
        string ngremark = context.Request["ngremark"];
        string ngnum = context.Request["ngnum"];
        string ngcodeid = context.Request["ngcodeid"];
        string checknum = context.Request["checknum"];
        string lotnum = context.Request["lotnum"];
        string ddltype = context.Request["ddltype"];
        string productcode = context.Request["productcode"];
        string stepid = context.Request["stepid"];
        string nglot = context.Request["nglot"];
        string mlotnum = context.Request["mlotnum"];
        switch (funcName)
        {
            case "getip":
                rtnValue = getip();
                break;
            case "getngcodeid":
                rtnValue = getngcodeid(stepid);
                break;
            case "getngNewcodeid":
                rtnValue = getngNewcodeid(mo_type,stepid);
                break;
            case "checklot":
                rtnValue = checklot(lotid,stepid);
                break;
            case "show":
                rtnValue = show(lotid);
                break;
            case "insertNgtmp":
                rtnValue = insertNgtmp(ngnum, lotid, ngremark, ngcodeid,lotnum,ddltype,checknum,nglot,mlotnum);
                break;
            case "checkOK":
                rtnValue = checkOK(lotnum,lotid, user, ouser, checknum, ddltype,stepid);
                break;
            case "checkNgLot":
                rtnValue = checkNgLot(lotid, nglot);
                break;          
            case "checkouser":
                rtnValue = checkouser(ouser);
                break;
            case "del":
                rtnValue = del(lotid, ngcodeid, ngnum);
                break;
        }
        context.Response.Write(rtnValue);
    }
    private string checkNgLot(string lotid, string nglot)
    {
        string rtn = "";
        string getLotNum = @"select LOT_QTY from sd_op_lotinfo where lot_id='" + nglot + "' and lot_id in(select lot_id from sd_op_elot where Elot_id='" + lotid + "')";
        DataTable dt = PubClass.getdatatableMES(getLotNum);
        if (dt.Rows.Count > 0)
        {
            rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"" + dt.Rows[0]["LOT_QTY"] + "\"}]";
            return rtn;
        }
        rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此lot号数据异常，请核实！\"}]";
        return rtn;
    }

    private string getip()
    {
        string HostName = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string rtn = "[{\"IP\":\"" + HostName + "\"}]";
        return rtn;
    }
    private string getngcodeid(string stepid)
    {
        string rtn = "";
        DataTable returndt = new DataTable();
        string sql = @"SELECT REASON_CODE CODE_ID,REASON_CODE||':'||REASON_NAME CODE_NAME  FROM SD_BASE_OQNGCODE WHERE STEP_ID='"+stepid+"' ORDER BY ID_ORDER";
        DataTable dt = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string del(string lotid, string ngcodeid, string ngnum)
    {
        string rtn = "[{\"FLAG\":\"N\",\"MSG\":\"ERROR\"}]";
        try
        {
            string sql = "delete from SD_TMP_OQCNG where LOT_ID='" + lotid + "' AND ERROR_CODE='" + ngcodeid+ "' AND NG_NUM='" + ngnum + "'";
            PubClass.getdatatablenoreturnMES(sql);
            rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"success\"}]";
        }
        catch
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"刪除失敗\"}]";
        }
        return rtn;
    }
    private string checkouser(string ouser)
    {
        string rtn = "";
        DataTable returndt = new DataTable();
        ouser = ouser.ToUpper().Trim();
        DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_CAT_HRS WHERE USER_ID='" + ouser + "'");
        if (GetUser(ouser) != "")
        {
            ouser = GetUser(ouser);
        }
        else
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"未找到此用戶\"}]";
            return rtn;
        }
        rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"" + ouser + "\"}]";
        return rtn;
    }
    private string GetUser(string User_ID)//获取人員基本信息
    {
        string User = "";
        DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_CAT_HRS WHERE USER_ID='" + User_ID + "'");
        if (dt.Rows.Count > 0)
        {
            User = User_ID + ":" + dt.Rows[0]["name_in_chinese"].ToString();
        }
        return User;
    }

    private string getngNewcodeid(string mo_type,string stepid)
    {
        string rtn = "";
        DataTable returndt = new DataTable();
        string sql = @"SELECT A.CODE_ID CODE_ID,A.CODE_ID ||':'||A.CODE_NAME CODE_NAME FROM  SD_BASE_CODSTEP B ,SD_BASE_CODE A WHERE A.CODE_ID=B.CODE_ID AND B.STEP_ID='" + stepid + "' and CODE_PRODUCT='" + mo_type + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string checklot(string lotid,string stepid)
    {
        string rtn = ""; string mo_type = "";
        DataTable returndt = new DataTable();
        lotid = lotid.ToUpper().Trim();

        int qty = 0;
       
        string sqlmmk1 = "SELECT IS_LOCK FROM LOCK_TYPE WHERE TYPE_NAME='OQCM' AND LOT_ID='" + lotid + "'";
        DataTable dtmmk1 = PubClass.getdatatableMES(sqlmmk1);
        if (dtmmk1.Rows.Count > 0)
        {
            string LNGV = "true";
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT正在過賬中，請稍等\",\"LNGV\":\"" + LNGV + "\"}]";
            return rtn;
        }
        string lot_tmp = "SELECT LOT_ID,PRODUCT_ID FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "' AND FLAG='Y'";
        DataTable dtlot_tmp = PubClass.getdatatableMES(lot_tmp);
        if (dtlot_tmp.Rows.Count > 0)
        {
            string ProductId = dtlot_tmp.Rows[0]["PRODUCT_ID"].ToString();
            DataTable dtcodestep = PubClass.getdatatableMES("SELECT CODE_ID FROM SD_BASE_CODEWITHPRODUCT WHERE PRODUCT_ID='" + ProductId + "'");
            if (dtcodestep.Rows.Count > 0)
            {
                string CODEID = dtcodestep.Rows[0]["CODE_ID"].ToString();               
                mo_type = CODEID;
            }
            for (int m = 0; m < dtlot_tmp.Rows.Count; m++)
            {
                DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID='" + dtlot_tmp.Rows[m]["lot_id"].ToString() + "'");
                if (dt.Rows.Count > 0)
                {
                    string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();                 
                    if (dt.Rows[0]["LOT_STATUS"].ToString() != "W" && dt.Rows[0]["LOT_STATUS"].ToString() != "C")
                    {
                        rtn = "[{\"FLAG\":\"N\",\"MSG\":\"批號:" + dt.Rows[0]["lot_id"].ToString() + "产品状态不正常!\"}]";
                        return rtn;
                    }
                    if ((dt.Rows[0]["IS_LOCK"].ToString() == "Y") && (ip != dt.Rows[0]["LOCK_CPU"].ToString()))
                    {
                        rtn = "[{\"FLAG\":\"N\",\"MSG\":\"批號:" + dt.Rows[0]["lot_id"].ToString() + "已被" + dt.Rows[0]["lock_cpu"].ToString() + "锁定!\"}]";
                        return rtn;
                    }
                    if (dt.Rows[0]["STEP_CURRENT"].ToString() != ""+stepid+"")
                    {
                        rtn = "[{\"FLAG\":\"N\",\"MSG\":\"批號:" + dt.Rows[0]["lot_id"].ToString() + "當前站為" + dt.Rows[0]["step_current"].ToString() + "!\"}]";
                        return rtn;
                    }
                    if (dt.Rows[0]["IS_QC"].ToString() != "Y")
                    {
                        rtn = "[{\"FLAG\":\"N\",\"MSG\":\"批號:" + dt.Rows[0]["lot_id"].ToString() + "還未點收，請先點收再過賬!\"}]";
                        return rtn;
                    }
                    qty += Convert.ToInt32(dt.Rows[0]["Lot_Qty"].ToString());

                    PubClass.getdatatablenoreturnMES("UPDATE SD_OP_LOTINFO SET IS_LOCK='Y',LOCK_CPU='" + ip + "' WHERE LOT_ID = '" + lotid + "'");
                }
                else
                {
                    rtn = "[{\"FLAG\":\"N\",\"MSG\":\"沒有找到此批號\"}]";
                    return rtn;
                }
            }
        }
        else
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"沒有找到此大批號\"}]";
            return rtn;
        }
        rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"OK\",\"QTY\":\"" + qty + "\",\"mo_type\":\"" + mo_type + "\"}]";
        return rtn;
    }
    private string insertNgtmp(string ngnum, string lotid, string ngremark, string ngcodeid, string lotnum, string ddltype, string checknum, string nglot, string mlotnum)
    {
        string rtn = "";

        string sql = "select CASE     WHEN SUM(NG_NUM) IS NULL THEN 0    ELSE SUM(NG_NUM) END AS NG_NUM from  SD_TMP_OQCNG where LOT_ID='" + nglot + "'";
        DataTable dt_num = PubClass.getdatatableMES(sql);
        int sum = Convert.ToInt32(dt_num.Rows[0]["NG_NUM"].ToString()) + Convert.ToInt32(ngnum);
        DataTable returndt = new DataTable();
        // 若选择抽检
        if (ddltype == "2")
        {
            // 数量 <抽检数量 报错
            if (Convert.ToInt32(mlotnum) < Convert.ToInt32(checknum))
            {
                rtn = "[{\"FLAG\":\"N\",\"MSG\":\"抽检数量大于数量，请核实!\"}]";
                return rtn;
            }
            // 不良数量总和 >抽检数量 报错
            if (sum > Convert.ToInt32(checknum))
            {
                rtn = "[{\"FLAG\":\"N\",\"MSG\":\"不良数量总和大于抽检数量，请核实!\"}]";
                return rtn;
            }
        }
        // 不良数量总和>数量 报错
        if (sum > Convert.ToInt32(mlotnum))
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"不良数量总和大于lot数量，请核实!\"}]";
            return rtn;
        }


        //yfy 2014/01/24

        string product = ngnum;

        DataTable dt = PubClass.getdatatableMES("SELECT A1.*,A2.LINE_ID FROM SD_OP_ELOT A1,SD_OP_LOTINFO A2 WHERE A1.LOT_ID=A2.LOT_ID AND A1.ELOT_ID='" + lotid + "' AND A1.LOT_ID='" + nglot + "'");
        if (dt.Rows.Count == 0)
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"沒有找到此產品!\"}]";
            return rtn;
        }
        string ProductId = dt.Rows[0]["PRODUCT_ID"].ToString();
        string CODEID = null;
        DataTable dtcodestep = PubClass.getdatatableMES("SELECT CODE_ID FROM SD_BASE_CODEWITHPRODUCT WHERE PRODUCT_ID='" + ProductId + "'");
        if (dtcodestep.Rows.Count > 0)
        {
            CODEID = dtcodestep.Rows[0]["CODE_ID"].ToString();
            //if (CODEID == "F60")
            //{
            //    CODEID = "F50";
            //}
        }

        string sqlmm1 = "SELECT * FROM SD_OP_ELOT WHERE LOT_ID='" + nglot + "' and Elot_id='" + lotid + "'";
        DataTable dtmm1 = PubClass.getdatatableMES(sqlmm1);
        if (dtmm1.Rows.Count == 0)
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此產品所屬LOT，不存在這個大批次中!\"}]";
            return rtn;
        }
        if (dtmm1.Rows[0]["elot_id"].ToString() != lotid)
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此產品不在這些批號中!\"}]";
            return rtn;
        }

        DataTable dt1 = PubClass.getdatatableMES("SELECT * FROM SD_TMP_OQCNG WHERE ERROR_CODE='" + ngcodeid + "'  AND lot_id='" + nglot + "'");
        if (dt1.Rows.Count > 0)
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此不良代码数量已输入，请确认!\"}]";
            return rtn;
        }
        //jay 20131027

        PubClass.getdatatablenoreturnMES(@"INSERT INTO SD_TMP_OQCNG(ELOT_ID,LOT_ID,ERROR_CODE,NG_NUM,LINE_ID,REMARK) VALUES('" + lotid + "','" + nglot + "','" + ngcodeid + "','" + ngnum + "','" + dt.Rows[0]["Line_id"].ToString() + "','" + ngremark + "')");

        rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"OK!\"}]";
        return rtn;
    }  
    private string show(string lotid)
    {
        string rtn = "";
        DataTable returndt = new DataTable();
        string sql = @"SELECT A1.LOT_ID,A1.NG_NUM,A1.ERROR_CODE||':'||A2.CODE_NAME ERROR_CODE FROM SD_TMP_OQCNG A1,SD_BASE_CODE A2 
                       WHERE A2.CODE_ID=A1.ERROR_CODE AND A1.ELOT_ID='" + lotid + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string checkOK(string lotnum,string lotid, string user, string ouser, string checknum, string ddltype,string stepid)
    {
        string rtn = "";      
       
        string SqlCheckStepCurrent = "SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID IN (SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID ='" + lotid + "')";
        DataTable dtCheckStepCurrent = PubClass.getdatatableMES(SqlCheckStepCurrent);
        if (dtCheckStepCurrent.Rows.Count > 0)
        {
            for (int i = 0; i < dtCheckStepCurrent.Rows.Count; i++)
            {
                if (dtCheckStepCurrent.Rows[i]["step_current"].ToString() != ""+stepid+"")
                {
                    rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此批<" + dtCheckStepCurrent.Rows[i]["LOT_ID"].ToString() + ">當前站為:" + dtCheckStepCurrent.Rows[i]["step_current"].ToString() + ",無法進行過帳!!\"}]";
                    return rtn;
                }
            }
        }
        else
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此大LOT沒有對應的小LOT,請確認!\"}]";
            return rtn;
        } 
        string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");

        if (ddltype == "0")
        {
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"請選擇檢驗類別!\"}]";
            return rtn;
        }
        if (ddltype == "2")
        {
            if (checknum == "")
            {
                rtn = "[{\"FLAG\":\"checknum\",\"MSG\":\"請輸入抽檢數量!\"}]";
                return rtn;
            }
            else
            {
                long check_qty = long.Parse(checknum.Trim().ToString());
                long all_qty = long.Parse(lotnum.Trim().ToString());
                if (all_qty < check_qty)
                {
                    rtn = "[{\"FLAG\":\"checknum\",\"MSG\":\"抽檢數量不可大於總數量，請確認!\"}]";
                    return rtn;
                }
            }
        }       
        string sql = "SELECT TO_CHAR(CREATE_TIME,'yyyy-MM-dd hh24:mm' ) FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count == 0)
        {
            rtn = "[{\"FLAG\":\"Nglot\",\"MSG\":\"此LOT不存在!\"}]";
            return rtn;
        }
        if (ouser.IndexOf(":") == -1)
        {
            rtn = "[{\"FLAG\":\"Nguser\",\"MSG\":\"人員key入不正確!\"}]";
            return rtn;
        }
        string sqlmmk1 = "SELECT IS_LOCK FROM LOCK_TYPE WHERE TYPE_NAME='OQCM' AND LOT_ID='" + lotid + "'";
        DataTable dtmmk1 = PubClass.getdatatableMES(sqlmmk1);
        if (dtmmk1.Rows.Count == 0)
        {
            string sqlup1 = "INSERT INTO LOCK_TYPE (TYPE_NAME,IS_LOCK,LOT_ID) VALUES ('OQCM','Y','" + lotid + "')";
            PubClass.getdatatablenoreturnMES(sqlup1);
        }
        else
        {
            rtn = "[{\"FLAG\":\"LNG\",\"MSG\":\"該lot已經鎖定,請先解鎖或等待他人作業完成!\"}]";
            return rtn;
        }
        ouser = ouser.Remove(ouser.IndexOf(":"));
        string MsgResult = "";
        OracleConnection con = PubClass.dbconMES();
        con.Open();
        try
        {
            OracleCommand cmd1 = new OracleCommand("P_OQC_D", con);
            cmd1.CommandType = CommandType.StoredProcedure;
            OracleParameter par1 = new OracleParameter("ELOTID", OracleType.VarChar, 50);
            par1.Direction = ParameterDirection.Input;
            par1.Value = lotid;//F0T13V-003
            OracleParameter par3 = new OracleParameter("OUSER", OracleType.VarChar, 20);
            par3.Direction = ParameterDirection.Input;
            par3.Value = ouser;//O19120001
            OracleParameter par4 = new OracleParameter("LUSER", OracleType.VarChar, 20);
            par4.Direction = ParameterDirection.Input;
            par4.Value = user;//O19120001
            OracleParameter par7 = new OracleParameter("LEQP", OracleType.VarChar, 20);
            par7.Direction = ParameterDirection.Input;
            par7.Value = "";//"33"
            OracleParameter par15 = new OracleParameter("DDL_TYPE", OracleType.VarChar, 10);
            par15.Direction = ParameterDirection.Input;
            par15.Value = ddltype;//1
            //OracleParameter par16 = new OracleParameter("QTY", OracleType.VarChar, 20);
            //par16.Direction = ParameterDirection.Input;
            //par16.Value = checknum;//""
            OracleParameter par17 = new OracleParameter("MsgResult", OracleType.VarChar, 500);
            par17.Direction = ParameterDirection.Output;
                        
            cmd1.Parameters.Add(par1);
            cmd1.Parameters.Add(par3);
            cmd1.Parameters.Add(par4);
            cmd1.Parameters.Add(par7);
            cmd1.Parameters.Add(par15);
            cmd1.Parameters.Add(par17);

            cmd1.ExecuteNonQuery();
            con.Close();
            MsgResult = par17.Value.ToString();
            MsgResult = MsgResult.Replace("\"", "");
            MsgResult = MsgResult.Replace("\n", "");
            if (MsgResult.Substring(0, 1).ToString() != "R" && MsgResult.Substring(0, 2) != "NG")
            {
                rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"過帳成功!\"}]";
            }
            else
            {
                rtn = "[{\"FLAG\":\"N\",\"MSG\":\"" + MsgResult + "!\"}]";
            }
        }
        catch(Exception ex)
        {
            MsgResult = ex.ToString();
            con.Close();
            rtn = "[{\"FLAG\":\"N\",\"MSG\":\"" + MsgResult + "!\"}]";
        }
        PubClass.getdatatablenoreturnMES("UPDATE SD_OP_LOTINFO SET IS_LOCK='N' WHERE LOT_ID IN (SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "')");
        string sqlup2 = " DELETE FROM LOCK_TYPE WHERE TYPE_NAME='OQCM' AND LOT_ID='" + lotid + "'";
        PubClass.getdatatablenoreturnMES(sqlup2);

        return rtn;

    }  
   

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}