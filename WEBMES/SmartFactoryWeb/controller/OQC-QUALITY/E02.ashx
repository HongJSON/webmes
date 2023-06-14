<%@ WebHandler Language="C#" Class="E02" %>
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

public class E02 : IHttpHandler
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
        string PROJECT_NAME = context.Request["PROJECT_NAME"];
        string PROJECT_ID = context.Request["PROJECT_ID"];
        string Project_Name = context.Request["Project_Name"];

        switch (funcName)
        {
            case "show":
                rtnValue = show(Template);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(Project_Name, user);
                break;
            case "del":
                rtnValue = del(NUMBER_ID, user, Project_Name);
                break;
        }
        context.Response.Write(rtnValue);
    }


    public string show(string Project_Name)
    {
        string sql = "";
        if (Project_Name != "" && Project_Name != null && Project_Name != "null")
        {
            sql = sql + " AND A.PROJECT_NAME ='" + Project_Name + "'";
        }
        string sSQL = $@"SELECT A.PROJECT_ID,A.PROJECT_NAME,A.CREATE_DATE,B.EMP_NAME,A.UPDATE_DATE,C.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_CHECK_PROJECT_CONFIG  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE 
                       A.CREATE_USERID=B.EMP_ID(+)
                       AND A.UPDATE_USERID=C.EMP_ID(+)" + sql + " ORDER BY A.CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string addTemplateInfo(string Project_Name, string user)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG WHERE PROJECT_NAME='{Project_Name}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + Project_Name + "此制程名称已存在\"}]";
        }
        string Number_id = Guid.NewGuid().ToString().ToUpper();
        sSQL = $"INSERT INTO SAJET.SYS_CHECK_PROJECT_CONFIG(PROJECT_ID,PROJECT_NAME,CREATE_USERID,CREATE_DATE)VALUES('{Number_id}','{Project_Name}','{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_PROJECT_CONFIG SELECT * FROM SAJET.SYS_CHECK_PROJECT_CONFIG WHERE PROJECT_ID='{Number_id}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }
    public string del(string NUMBER_ID, string user, string Template)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"UPDATE SAJET.SYS_CHECK_PROJECT_CONFIG SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE PROJECT_ID='{NUMBER_ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_PROJECT_CONFIG SELECT * FROM SAJET.SYS_CHECK_PROJECT_CONFIG WHERE PROJECT_ID='{NUMBER_ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM SAJET.SYS_CHECK_PROJECT_CONFIG WHERE PROJECT_ID='{NUMBER_ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功!\"}]";
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

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}