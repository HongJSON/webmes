<%@ WebHandler Language="C#" Class="E05" %>
using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using ExcelLibrary;
using System.Security;
using System.Web.UI;
using System.Drawing.Text;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient;
using System.IO;
using ExcelLibrary.SpreadSheet;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Net.Cache;
using System.Diagnostics;
using System.Linq;


public class E05 : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string Template = context.Request["Template"];
        string NUMBER_ID = context.Request["NUMBER_ID"];
        string PdlineName = context.Request["PdlineName"];
        string JJ = context.Request["JJ"];
        string BuName = context.Request["BuName"];
        string ProcessName = context.Request["ProcessName"];
        switch (funcName)
        {
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "ShowBuName":
                rtnValue = ShowBuName();
                break;
            case "ShowProcess":
                rtnValue = ShowProcess(PdlineName);
                break;
            case "show":
                rtnValue = show(Template, PdlineName, BuName, ProcessName);
                break;
            case "del":
                rtnValue = del(Template, PdlineName, BuName, ProcessName, user);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(user, Template, PdlineName, BuName, ProcessName);
                break;


        }
        context.Response.Write(rtnValue);
    }
    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'  AND PDLINE_NAME LIKE'" + JJ + "%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_CHECK_TEMPLATE_CONFIG WHERE TELETYPE='模板' ORDER BY  TEMPLATE";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowBuName()
    {
        string sSQL = $@"SELECT SECTON_NAME FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='1' ORDER BY SECTON_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowProcess(string PdlineName)
    {
        string SSQL = "SELECT DISTINCT B.PROCESS_NAME FROM SAJET.SYS_TERMINAL A ,SAJET.SYS_PROCESS B,SAJET.SYS_PDLINE C WHERE C.PDLINE_NAME = '" + PdlineName + "'AND A.PROCESS_ID = B.PROCESS_ID AND A.PDLINE_ID=C.PDLINE_ID ";
        DataTable dt = PubClass.getdatatableMES(SSQL);
        return JsonConvert.SerializeObject(dt);
    }






    public string addTemplateInfo(string user, string Template, string PdlineName, string BuName, string ProcessName)
    {
        string userEmpId = getEmpIdByNo(user); string Emial = "";
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查\"}]";

        }


        string sSQL = $"SELECT *   FROM SAJET.SYS_CHECK_POWER_BASE  WHERE TEMPLATE='{Template}'AND PDLINE_NAME='{PdlineName}'  AND PROCESS_NAME='{ProcessName}' AND SECTON_NAME='{BuName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此权限已存在\"}]";
        }

        sSQL = $"INSERT INTO SAJET.SYS_CHECK_POWER_BASE(TEMPLATE,PDLINE_NAME,PROCESS_NAME,SECTON_NAME,CREATE_USERID,CREATE_DATE)VALUES('{Template}','{PdlineName}','{ProcessName}','{BuName}','{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_POWER_BASE(TEMPLATE,PDLINE_NAME,PROCESS_NAME,SECTON_NAME,CREATE_USERID,CREATE_DATE)VALUES('{Template}','{PdlineName}','{ProcessName}','{BuName}','{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(sSQL);




        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";

    }



    public string del(string Template, string PdlineName, string BuName, string ProcessName, string user)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";

        }
        sSQL = $"UPDATE  SAJET.SYS_CHECK_POWER_BASE   SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE TEMPLATE='{Template}'AND PDLINE_NAME='{PdlineName}' AND PROCESS_NAME='{ProcessName}' AND SECTON_NAME='{BuName}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO  SAJET.SYS_HT_CHECK_POWER_BASE SELECT* FROM  SAJET.SYS_CHECK_POWER_BASE WHERE TEMPLATE='{Template}'AND PDLINE_NAME='{PdlineName}' AND PROCESS_NAME='{ProcessName}' AND SECTON_NAME='{BuName}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM  SAJET.SYS_CHECK_POWER_BASE WHERE TEMPLATE='{Template}'AND PDLINE_NAME='{PdlineName}' AND PROCESS_NAME='{ProcessName}' AND SECTON_NAME='{BuName}'";
        PubClass.getdatatablenoreturnMES(sSQL);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功!\"}]";
    }
    public string show(string Template, string PdlineName, string BuName, string ProcessName)
    {
        string sql = "";
        if (Template != "" && Template != null && Template != "null")
        {
            sql = sql + " AND A.TEMPLATE ='" + Template + "'";
        }
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (BuName != "" && BuName != null && BuName != "null")
        {
            sql = sql + " AND A.SECTON_NAME ='" + BuName + "'";
        }
        if (ProcessName != "" && ProcessName != null && ProcessName != "null")
        {
            sql = sql + " AND A.PROCESS_NAME ='" + ProcessName + "'";
        }
        string sSQL = $@"SELECT A.TEMPLATE,A.PDLINE_NAME,A.SECTON_NAME,A.PROCESS_NAME,B.EMP_NAME,A.CREATE_DATE FROM SAJET.SYS_CHECK_POWER_BASE A,SAJET.SYS_EMP B WHERE A.CREATE_USERID=B.EMP_ID(+) " + sql + " ORDER BY CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }




    public string getEmpIdByNo(string user)
    {
        string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "";
        }
        return dt.Rows[0]["EMP_ID"].ToString();
    }
    public string getEmpIdByNAME(string user)
    {
        string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NAME = '{user}'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "";
        }
        return dt.Rows[0]["EMP_ID"].ToString();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}