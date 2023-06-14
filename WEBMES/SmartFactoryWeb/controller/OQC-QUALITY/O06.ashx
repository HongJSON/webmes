<%@ WebHandler Language="C#" Class="O06" %>
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

public class O06 : IHttpHandler
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
        string CHECK_TYPE = context.Request["CHECK_TYPE"];
        string Emp = context.Request["EMP_NAME1"];
        switch (funcName)
        {
            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "show":
                rtnValue = show(Template,PdlineName,CHECK_TYPE);
                break;
            case "del":
                rtnValue = del(Template,PdlineName,CHECK_TYPE,Emp);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(user,Template,PdlineName,CHECK_TYPE,Emp);
                break;


        }
        context.Response.Write(rtnValue);
    }
    public string addTemplateInfo(string user,string Template,string PdlineName,string CHECK_TYPE,string Emp)
    {
        string userEmpId = getEmpIdByNo(user);string Emial = "";
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        string sSQL = $"SELECT * FROM  SAJET.SYS_EMP WHERE EMP_NO='{Emp}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"需维护人员工号在MES中不存在\"}]";
        }
        string EMP_ID=dt.Rows[0]["EMP_ID"].ToString();
        if(CHECK_TYPE=="FACA人权限"||CHECK_TYPE=="点检人FACA权限")
        {
            Emial = dt.Rows[0]["EMAIL"].ToString();
            if(dt.Rows[0]["EMAIL"].ToString()==string.Empty)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该需开通权限人员未维护邮件地址\"}]";
            }
        }

        sSQL = $"SELECT *   FROM SAJET.SYS_ECHECK_POWER_BASE  WHERE TEMPLATE='{Template}'AND PDLINE_NAME='{PdlineName}' AND CHECK_TYPE='{CHECK_TYPE}' AND CHECK_EMPID='{EMP_ID}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此人员权限已存在\"}]";
        }
        if(CHECK_TYPE=="FACA人权限"||CHECK_TYPE=="点检人FACA权限")
        {
            sSQL = $"INSERT INTO SAJET.SYS_ECHECK_POWER_BASE(TEMPLATE,PDLINE_NAME,CHECK_TYPE,CHECK_EMPID,CREATE_USERID,CREATE_DATE,EMAIL)VALUES('{Template}','{PdlineName}','{CHECK_TYPE}','{EMP_ID}','{userEmpId}',SYSDATE,'{Emial}')";
            PubClass.getdatatablenoreturnMES(sSQL);
        }
        else
        {
            sSQL = $"INSERT INTO SAJET.SYS_ECHECK_POWER_BASE(TEMPLATE,PDLINE_NAME,CHECK_TYPE,CHECK_EMPID,CREATE_USERID,CREATE_DATE)VALUES('{Template}','{PdlineName}','{CHECK_TYPE}','{EMP_ID}','{userEmpId}',SYSDATE)";
            PubClass.getdatatablenoreturnMES(sSQL);
        }

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";

    }



    public string del(string Template,string PdlineName,string CHECK_TYPE,string EMP_NAME1)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNAME(EMP_NAME1);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"DELETE FROM SAJET.SYS_ECHECK_POWER_BASE  WHERE TEMPLATE='{Template}'AND PDLINE_NAME='{PdlineName}' AND CHECK_TYPE='{CHECK_TYPE}' AND CHECK_EMPID='{userEmpId}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功!\"}]";
    }
    public string show(string Template,string PdlineName,string CHECK_TYPE)
    {
        string sql = "";
        if(Template!=""&& Template!=null&& Template!="null")
        {
            sql = sql + " AND A.TEMPLATE ='" + Template + "'";
        }
        if(CHECK_TYPE!=""&& CHECK_TYPE!=null&& CHECK_TYPE!="null")
        {
            sql = sql + " AND A.CHECK_TYPE ='" + CHECK_TYPE + "'";
        }
        if(PdlineName!=""&& PdlineName!=null&& PdlineName!="null")
        {
            sql = sql + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        string sSQL = $@"SELECT A.TEMPLATE,A.PDLINE_NAME,A.CHECK_TYPE,B.EMP_NAME,C.EMP_NAME AS EMP_NAME1,A.EMAIL,A.CREATE_DATE FROM SAJET.SYS_ECHECK_POWER_BASE A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE A.CREATE_USERID=B.EMP_ID(+) AND A.CHECK_EMPID=C.EMP_ID "+sql+" ORDER BY CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'  AND PDLINE_NAME LIKE'"+JJ+"%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG ORDER BY  TEMPLATE";
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