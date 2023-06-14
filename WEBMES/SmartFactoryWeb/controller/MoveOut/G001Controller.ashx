<%@ WebHandler Language="C#" Class="G04Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.ComponentModel;
using System.ComponentModel.Design;
using System.ComponentModel.Design.Serialization;



public class G04Controller : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string step = context.Request["step"];
        string stepm = context.Request["stepm"];
        string pname = context.Request["pname"];
        string line = context.Request["line"];
        string CBLINE = context.Request["CBLINE"];
        string user = context.Request["user"];
        string eqp = context.Request["eqp"];
        switch (funcName)
        {
            case "table":
                rtnValue = gettable(user);
                break;
            case "getnum":
                rtnValue = getnum(user, pname);
                break;
            case "getstep":
                rtnValue = getAD();
                break;
            case "getstepm":
                rtnValue = GetStepm(step, pname);
                break;
            case "geteqp":
                rtnValue = GetEqp(stepm, line, CBLINE);
                break;
            case "getkey":
                rtnValue = BtnUser(user, stepm, eqp , pname, step, line);
                break;
            case "show":
                rtnValue = Show(pname, step, eqp, stepm,line);
                break;
            case "delete":
                rtnValue = delete(step, eqp, user);
                break;
            case "update":
                rtnValue = update(step, eqp, user);
                break;
            case "getdatatime":
                rtnValue = getdatatime();
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string gettable(string user)
    {
        string sqlstr = @"SELECT A1.STEP_ID,A1.EQP_ID,A1.USER_ID||':'||A1.USER_NAME USER_ID,TO_CHAR(ONLINE_TIME,'yyyy-mm-dd hh24:mi:ss') ONLINE_TIME FROM SD_OP_ONLINEUSER A1,SD_BASE_STEPM A2 
                        WHERE A1.STEP_ID=A2.STEPM_ID  AND A1.FLAG='Y'  
                        AND USER_ID='" + user + @"'
                        ORDER BY STEP_ID,EQP_ID,USER_ID";
        DataTable dt = PubClass.getdatatableMES(sqlstr);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    public string getnum(string user, string pname)
    {
        string sqlstr = @"SELECT COUNT(*) NUM FROM SD_OP_ONLINEUSER A1,SD_BASE_STEPM A2 
                        WHERE A1.STEP_ID=A2.STEPM_ID  AND A1.FLAG='Y'  
                        AND USER_ID='" + user + "'AND A2.PROCESS_NAME='" + pname + @"'
                        ORDER BY A1.STEP_ID,EQP_ID,USER_ID";
        DataTable dt = PubClass.getdatatableMES(sqlstr);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    public string getAD()
    {
        string rtn;
        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("CIM\\", "");
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");
        //str_loginhost = "F1-01_CELL";
        //if (HttpContext.Current.IsDebuggingEnabled)
        //{
        //    str_loginhost = "[{\"USER_ID\":\"F1-01_CELL\"}]";
        //}
        rtn = "[{\"STEP_ID\":\"" + str_loginhost + "\"}]";
        return rtn;
    }

    private string GetStepm(string step, string pname)//獲取小站點信息
    {
        string tmp = "";
        string sqlstr = "";

        switch (pname)
        {
            default:
                tmp = " AND A1.PROCESS_NAME IN ('" + pname + "')";
                break;
        }
        sqlstr = "SELECT DISTINCT A1.STEPM_ID,A1.STEPM_ID||':'||A2.STEP_DESC STEPM_NAME FROM SD_BASE_STEPM A1,SD_BASE_STEP A2 WHERE A1.STEPM_ID=A2.STEP_ID AND A1.STEP_ID='" + step + "' " + tmp + " ORDER BY A1.STEPM_ID";
        DataTable dt = PubClass.getdatatableMES(sqlstr);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    private string GetEqp(string STEPM, string LINE, string CBLINE)//獲取機台信息
    {
        DataTable dt = new DataTable();
        if (STEPM != "")
        {
            string strsql = "SELECT EQP_ID FROM SD_BASE_EQP WHERE STEP_ID='" + STEPM + "' AND LINE_ID='" + LINE + "' ORDER BY EQP_ID";
            if (CBLINE == "true")
            {
                strsql = "SELECT EQP_ID FROM SD_BASE_EQP WHERE STEP_ID='" + STEPM + "' AND LINE_ID<>'" + LINE + "'  ORDER BY EQP_ID";
            }
            dt = PubClass.getdatatableMES(strsql);
            if (dt.Rows.Count == 0)
            {
                strsql = "SELECT 'NULL' EQP_ID FROM DUAL";
                dt = PubClass.getdatatableMES(strsql);
            }
            //  注釋掉的  , 根據指定站點 設定    指定 站點 如無機台信息 機台信息  為   NOEQP   alert('未維護該線體對應機台信息');
            //if (STEPM != "BLAT" && STEPM != "116PRT" && STEPM != "LST" && STEPM != "BPV" && STEPM != "DLM" && STEPM != "FQCM")
            //{
            //    if (dt.Rows.Count == 0)
            //    {
            //        strsql = "SELECT 'NULL' EQP_ID FROM DUAL";
            //        dt = PubClass.getdatatableMES(strsql);
            //    }
            //}
            //else
            //{
            //    if (dt.Rows.Count == 0)
            //    {
            //        strsql = "SELECT 'NOEQP' EQP_ID FROM DUAL";
            //        dt = PubClass.getdatatableMES(strsql);
            //    }
            //}
        }
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    private string Show(string pname, string step, string eqp,string stepm,string line)//获取人員上線信息
    {
        string sqlstr = "";
        string tmp = "";
        //string line = "";
        //DataTable dtline = PubClass.getdatatableMES("SELECT LINE_ID FROM SD_BASE_EQP WHERE STEP_ID='" + stepm + "' AND EQP_ID='" + eqp + "'");
        //if (dtline.Rows.Count > 0)
        //{
        //    line = dtline.Rows[0][0].ToString();
        //}
        switch (pname)
        {
            default:
                tmp = " AND A2.PROCESS_NAME IN ('" + pname + "')";
                break;
        }
        sqlstr = "SELECT A1.STEP_ID STEP_ID,A1.EQP_ID EQP_ID,A1.USER_ID||':'||A1.USER_NAME USER_ID,TO_CHAR(ONLINE_TIME,'YYYY-MM-DD HH24:MI:SS') ONLINE_TIME FROM SD_OP_ONLINEUSER A1,SD_BASE_STEPM A2 WHERE A1.STEP_ID=A2.STEPM_ID AND A1.LINE_ID='" + line + "' AND A1.FLAG='Y' AND  A2.STEP_ID='" + step + "' " + tmp + "  ORDER BY STEP_ID,EQP_ID,USER_ID";
        DataTable dt = PubClass.getdatatableMES(sqlstr);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    private string BtnUser(string TxtUser, string DdlStepm, string DdlEqp , string pname, string step, string line)//获取人員上線信息
    {
        string rtn = "";

        //string line = "";
        //DataTable dtline = PubClass.getdatatableMES("SELECT LINE_ID FROM SD_BASE_EQP WHERE STEP_ID='" + DdlStepm + "' AND EQP_ID='" + DdlEqp + "'");
        //if (dtline.Rows.Count > 0)
        //{
        //    line = dtline.Rows[0][0].ToString();
        //}
        DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_OP_ONLINEUSER WHERE LINE_ID='" + line + "' AND STEP_ID='" + DdlStepm + "' AND EQP_ID='" + DdlEqp + "' AND USER_ID='" + TxtUser + "' AND FLAG='Y'");
        DataTable dt1 = PubClass.getdatatableMES("SELECT * FROM SD_CAT_HRS WHERE USER_ID='" + TxtUser + "'");

        if (dt1.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"人員工號不存在\"}]";
            return rtn;
        }
        else if (DdlStepm == "")
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"請選擇小站點\"}]";
            return rtn;
        }
        else if (DdlEqp == "")
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"請選擇小線體\"}]";
            return rtn;
        }
        else if (pname == "")
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"請選擇流程\"}]";
            return rtn;
        }
        else
        {
            string step1 = DdlStepm;
            string step2 = step;
            string A = "";
            //  特定站點技能不達標  先去掉
            //if (step2 == "FQCM" || step2 == "FQCD" || step2 == "VSFOM" || step2 == "119PRT" || step2 == "79PRT" || step2 == "75PRT" || step2 == "48PRT")
            //{
            //    if (step1 == "BLA" || step1 == "BLS" || step1 == "FQCD" || step1 == "FQCM")
            //    {
            //        string sqCh = "SELECT STEPM_ID  FROM  SD_OP_USERMAIN   WHERE USER_ID ='" + TxtUser + "'  AND  WORK_WORK='YES' AND FLAG='Y'";
            //        DataTable dtCh = PubClass.getdatatableMES(sqCh);
            //        if (dtCh.Rows.Count != 0)
            //        {
            //            string usp = dtCh.Rows[0]["STEPM_ID"].ToString();
            //            if (usp == "MDL目檢")
            //            {
            //                if (step1 != "FQCM")
            //                {
            //                    rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"技能不達標，不可上線，如有疑問，請聯繫包裝的陳琦!!\"}]";
            //                    return rtn;
            //                }
            //            }
            //            else if (usp == "MDL電檢")
            //            {
            //                if (step1 != "FQCD")
            //                {
            //                    rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"技能不達標，不可上線，如有疑問，請聯繫包裝的陳琦!!\"}]";
            //                    return rtn;
            //                }
            //            }
            //            else//虛焊
            //            {
            //                if (step1 != "BLA" && step1 != "BLS")
            //                {
            //                    rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"技能不達標，不可上線，如有疑問，請聯繫包裝的陳琦!!\"}]";
            //                    return rtn;
            //                }
            //            }
            //        }
            //        else
            //        {
            //            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此工號在此站點不可作業，如有疑問，請聯繫包裝的陳琦!\"}]";
            //            return rtn;
            //        }
            //    }
            //}
            if (A == "")
            {
                string SQL = "";
                if (dt.Rows.Count > 0)
                {
                    SQL = "UPDATE SD_OP_ONLINEUSER SET ONLINE_TIME=SYSDATE WHERE LINE_ID='" + line + "' AND STEP_ID='" + DdlStepm + "' AND EQP_ID='" + DdlEqp + "' AND USER_ID='" + TxtUser + "' AND FLAG='Y'";
                    PubClass.getdatatableMES(SQL);
                }
                else
                {
                    SQL = "INSERT INTO SD_OP_ONLINEUSER(LINE_ID,STEP_ID,EQP_ID,USER_ID,USER_NAME,ONLINE_TIME,FLAG) SELECT '" + line + "','" + DdlStepm + "','" + DdlEqp + "','" + TxtUser + "',NAME_IN_CHINESE,SYSDATE,'Y' FROM SD_CAT_HRS WHERE USER_ID='" + TxtUser + "' AND FLAG = 'Y'";
                    PubClass.getdatatableMES(SQL);
                }
                rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"添加OK\"}]";
                return rtn;
            }
        }
        return rtn;
    }

    private string delete(string step, string eqp, string user)//获取人員上線信息
    {
        string rtn = "";
        user = user.Substring(0, user.IndexOf(":"));
        string SQL = "UPDATE SD_OP_ONLINEUSER SET FLAG='N' WHERE  STEP_ID='" + step + "' AND EQP_ID='" + eqp + "' AND USER_ID='" + user + "' AND FLAG='Y'";
        PubClass.getdatatableMES(SQL);
        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"刪除OK\"}]";
        return rtn;
    }
    private string update(string step, string eqp, string user)//获取人員上線信息
    {
        string rtn = "";
        user = user.Substring(0, user.IndexOf(":"));
        string SQL = "UPDATE SD_OP_ONLINEUSER SET ONLINE_TIME=SYSDATE WHERE  STEP_ID='" + step + "' AND EQP_ID='" + eqp + "' AND USER_ID='" + user + "' AND FLAG='Y'";
        PubClass.getdatatableMES(SQL);
        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"更新OK\"}]";
        return rtn;
    }

    private string getdatatime()//获取人員上線信息
    {
        string rtn = "";
        string SQL = "SELECT TO_CHAR(SYSDATE-(10/24),'yyyyMMddHH24miss')TIME FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(SQL);
        rtn = JsonConvert.SerializeObject(dt);
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