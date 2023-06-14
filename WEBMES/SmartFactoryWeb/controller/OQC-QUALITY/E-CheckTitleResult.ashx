<%@ WebHandler Language="C#" Class="B06Controller" %>

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

public class B06Controller : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
         string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string ModelName = context.Request["ModelName"];
        string PdlineName = context.Request["PdlineName"];
        string Template = context.Request["Template"];
        string Title = context.Request["Title"];
        string datetimepicker = context.Request["datetimepicker"];
        string Result = context.Request["Result"];
        string MODEL_NAME = context.Request["MODEL_NAME"];
        string PDLINE_NAME = context.Request["PDLINE_NAME"];
        string TEMPLATE_POINT = context.Request["TEMPLATE_POINT"];
        string TERINTIME = context.Request["TERINTIME"];

        switch (funcName)
        {
            case "ShowModel":
                rtnValue = ShowModel();
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "GetTemplate":
                rtnValue = GetTemplate(ModelName,PdlineName);
                break;
             case "GetTitle":
                rtnValue = GetTitle(ModelName,PdlineName,Template);
                break;
            case "InsertTemplateInfo":
                rtnValue = InsertTemplateInfo(user,ModelName,PdlineName,Template,Title,datetimepicker,Result);
                break;
            case "show":
                rtnValue = show(ModelName,PdlineName,Template,Title,datetimepicker,Result);
                break;
            case "del":
                rtnValue = del(MODEL_NAME,PDLINE_NAME,TEMPLATE_POINT,Title,user,TERINTIME);
                break;

        }
        context.Response.Write(rtnValue);
    }

    private string del(string MODEL_NAME,string PDLINE_NAME,string TEMPLATE_POINT,string TITLE,string user,string TERINTIME)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $@"UPDATE SAJET.SYS_ECHECK_TEMPLATERESULT SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE MODEL_NAME='{MODEL_NAME}' AND  PDLINE_NAME='{PDLINE_NAME}' AND TEMPLATE_POINT='{TEMPLATE_POINT}' AND TITLE='{TITLE}'AND TERINTIME='{TERINTIME}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO SAJET.SYS_HT_ECHECK_TEMPLATERESULT SELECT * FROM SAJET.SYS_ECHECK_TEMPLATERESULT WHERE  MODEL_NAME='{MODEL_NAME}' AND  PDLINE_NAME='{PDLINE_NAME}' AND TEMPLATE_POINT='{TEMPLATE_POINT}' AND TITLE='{TITLE}'AND TERINTIME='{TERINTIME}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"DELETE FROM  SAJET.SYS_ECHECK_TEMPLATERESULT WHERE  MODEL_NAME='{MODEL_NAME}' AND  PDLINE_NAME='{PDLINE_NAME}' AND TEMPLATE_POINT='{TEMPLATE_POINT}' AND TITLE='{TITLE}'AND TERINTIME='{TERINTIME}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功\"}]";
    }

    private string show(string ModelName,string PdlineName,string Template,string Title,string datetimepicker,string Result)
    {
        string sql = "";
        if(Template!=""&& Template!=null&& Template!="null")
        {
            sql = sql + " AND A.TEMPLATE_POINT ='" + Template + "'";
        }
        if(ModelName!=""&& ModelName!=null&& ModelName!="null")
        {
            sql = sql + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        if(PdlineName!=""&& PdlineName!=null&& PdlineName!="null")
        {
            sql = sql + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if(Title!=""&& Title!=null&& Title!="null")
        {
            sql = sql + " AND A.TITLE ='" + Title + "'";
        }
        if(datetimepicker!=""&& datetimepicker!=null&& datetimepicker!="null")
        {
            sql = sql + " AND A.TERINTIME ='" + datetimepicker + "'";
        }
        if(Result!=""&& Result!=null&& Result!="null")
        {
            sql = sql + " AND A.RESULT_STATUS ='" + Result + "'";
        }
        string sSQL = $@"SELECT A.NUMBER_ID,A.MODEL_NAME,A.PDLINE_NAME,A.TEMPLATE_POINT,A.TITLE AS TITLE1,A.RESULT_STATUS,A.DN_NO,A.TERINTIME,A.CREATE_DATE,B.EMP_NAME,C.EMP_NAME AS EMP_NAME1 ,A.UPDATE_DATE FROM SAJET.SYS_ECHECK_TEMPLATERESULT  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE A.CREATE_USERID=B.EMP_ID(+) AND A.UPDATE_USERID=C.EMP_ID(+)"+sql+" ORDER BY CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    private string InsertTemplateInfo(string user,string ModelName,string PdlineName,string Template,string Title,string datetimepicker,string Result)
    {
        string sSQL = "";DataTable dt;string UUID;string DN_NO;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATERESULT WHERE MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND TEMPLATE_POINT='{Template}' AND TITLE='{Title}' AND TERINTIME='{datetimepicker}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前日期资料已维护过，不可重复维护\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATERESULT WHERE MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND TEMPLATE_POINT='{Template}' AND TITLE='{Title}' AND TERINTIME='{datetimepicker}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            DN_NO=dt.Rows[0]["DN_NO"].ToString();
        }
        else
        {
            DN_NO= DateTime.Now.ToString("yyMMddhhmmssff");
        }
        sSQL = $@"SELECT NUMBER_ID FROM  SAJET.SYS_ECHECK_TEMPLATE  WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}' AND TEMPLATE_POINT ='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        string Number_id=dt.Rows[0]["NUMBER_ID"].ToString();

        sSQL = $@"INSERT INTO SAJET.SYS_ECHECK_TEMPLATERESULT(NUMBER_ID,MODEL_NAME,PDLINE_NAME,TEMPLATE_POINT,TITLE,RESULT_STATUS,DN_NO,TERINTIME,CREATE_USERID,CREATE_DATE)
                  VALUES('{Number_id}','{ModelName}','{PdlineName}','{Template}','{Title}','{Result}','{DN_NO}','{datetimepicker}','{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(sSQL);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
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


    public string ShowModel()
    {
        string sSQL = $@"SELECT MODEL_NAME FROM SAJET.SYS_MODEL WHERE ENABLED='Y'ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetTemplate(string ModelName,string PdlineName)
    {

        string sSQL = $@"SELECT DISTINCT TEMPLATE_POINT FROM  SAJET.SYS_ECHECK_TEMPLATE  WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}'ORDER BY  TEMPLATE_POINT ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
         return JsonConvert.SerializeObject(dt);


    }
    public string GetTitle(string ModelName,string PdlineName,string Template)
    {
        string sSQL = $@"SELECT   TITLE FROM  SAJET.SYS_ECHECK_TEMPLATE  WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}' AND TEMPLATE_POINT ='{Template}'ORDER BY  CREATE_DATE DESC ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}