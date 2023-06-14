<%@ WebHandler Language="C#" Class="O02" %>
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

public class O02 : IHttpHandler
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
        string Title = context.Request["Title"];
        string BIAOTI1 = context.Request["BIAOTI1"];
        switch (funcName)
        {
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "show":
                rtnValue = show(Template,Title);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(Template,user,Title);
                break;
            case "del":
                rtnValue = del(NUMBER_ID,user,Template,Title);
                break;
             case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(BIAOTI1,user,Template,Title);
                break;
        }
        context.Response.Write(rtnValue);
    }
    public string UpdateTemplateInfo1(string BIAOTI1,string user,string Template,string Title)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL = $@"UPDATE SAJET.SYS_ECHECK_TEMPLATE_TITLE SET TITLE='{BIAOTI1}',UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE TEMPLATE='{Template}' AND TITLE='{Title}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,修改成功\"}]";
    }









    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG ORDER BY  TEMPLATE";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string Template,string Title)
    {
        string sql = "";
        if(Title!=""&& Title!=null&& Title!="null")
        {
            sql = sql + " AND A.TITLE ='" + Title + "'";
        }
        if(Template!=""&& Template!=null&& Template!="null")
        {
            sql = sql + " AND A.TEMPLATE ='" + Template + "'";
        }
        string sSQL = $@"SELECT A.NUMBER_ID,A.TEMPLATE,A.TITLE,A.CREATE_DATE,B.EMP_NAME,A.UPDATE_DATE,C.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE 
                       A.CREATE_USERID=B.EMP_ID(+)
                       AND A.UPDATE_USERID=C.EMP_ID(+)"+sql+" ORDER BY A.CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string addTemplateInfo(string Template,string user,string Title)
    {
        string sSQL = "";DataTable dt;string TYPE = "TYPE";string SEQ = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE='{Template}'AND TITLE='{Title}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"标题模板对应关系已存在\"}]";
        }
        sSQL = $"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG WHERE TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        string  Number_id=dt.Rows[0]["NUMBER_ID"].ToString();

        sSQL = $"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count==0)
        {
            TYPE = "TYPE1";
            SEQ = "1";

        }
        else
        {
            sSQL = $"SELECT SUBSTR(MAX(TYPE),5,1)+1 FROM  SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE='{Template}'";
            dt = PubClass.getdatatableMES(sSQL);
            TYPE = TYPE+dt.Rows[0][0].ToString();
            SEQ=dt.Rows[0][0].ToString();
        }
        sSQL = $"INSERT INTO SAJET.SYS_ECHECK_TEMPLATE_TITLE(SEQ,TYPE,TITLE,NUMBER_ID,TEMPLATE,CREATE_USERID,CREATE_DATE)VALUES('{SEQ}','{TYPE}','{Title}','{Number_id}','{Template}','{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_ECHECK_TEMPLATE_TITLE SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE NUMBER_ID='{Number_id}'AND TITLE='{Title}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }

    public string del(string NUMBER_ID,string user,string Template,string Title)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE NUMBER_ID='{NUMBER_ID}'AND TITLE='{Title}'";
        dt = PubClass.getdatatableMES(sSQL);
        string SEQ=dt.Rows[0]["SEQ"].ToString();
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE NUMBER_ID='{NUMBER_ID}'AND TEMPLATE='{Template}'AND SEQ>{SEQ}";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                int SEQ1=int.Parse(dt.Rows[i]["SEQ"].ToString())-1;
                string TITLE1=dt.Rows[i]["TITLE"].ToString();
                string TYPE = "TYPE" + SEQ1;
                sSQL = $"UPDATE SAJET.SYS_ECHECK_TEMPLATE_TITLE SET TYPE='{TYPE}',SEQ='{SEQ1}' WHERE NUMBER_ID='{NUMBER_ID}'AND TITLE='{TITLE1}'AND TEMPLATE='{Template}'";
                PubClass.getdatatablenoreturnMES(sSQL);
            }
        }

        sSQL = $"UPDATE SAJET.SYS_ECHECK_TEMPLATE_TITLE SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE NUMBER_ID='{NUMBER_ID}'AND TITLE='{Title}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_ECHECK_TEMPLATE_TITLE SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE NUMBER_ID='{NUMBER_ID}'AND TITLE='{Title}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE NUMBER_ID='{NUMBER_ID}'AND TITLE='{Title}'";
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