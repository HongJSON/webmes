<%@ WebHandler Language="C#" Class="O09" %>
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
using System.Net.Mail;
public class O09 : IHttpHandler
{
    public MailMessage MyProperty { get; set; }
    private SmtpClient smtp = new SmtpClient();
    public SmtpClient Smtp
    {
        get { return smtp; }
        set { smtp = value; }
    }

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
        //string ProcessName = context.Request["ProcessName"];
        string datetimepicker = context.Request["datetimepicker"];
        string dataType = context.Request["dataType"];
        string DN_NO = context.Request["DN_NO"];
        string ID = context.Request["ID"];
        string Date = context.Request["Date"];
        string Datew = context.Request["Datew"];
        string Model = context.Request["Model"];
        string wf = context.Request["wf"];
        string Pdline = context.Request["Pdline"];
        string Class = context.Request["Class"];
        string Terminal = context.Request["Terminal"];
        string Abnormal = context.Request["Abnormal"];
        string Analysis = context.Request["Analysis"];
        string Improvement = context.Request["Improvement"];
        string Category= context.Request["Category"];
        string Person = context.Request["Person"];
        string Director = context.Request["Director"];
        string StartTime = context.Request["StartTime"];
        string FinishTime = context.Request["FinishTime"];
        string Followup = context.Request["Followup"];
        string Status = context.Request["Status"];
        string Auditors = context.Request["Auditors"];
        string JJ = context.Request["JJ"];
        string USERTYPE = context.Request["USERTYPE"];
        switch (funcName)
        {

            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowDnno":
                rtnValue = ShowDnno(Template,user,PdlineName,datetimepicker,dataType);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "show":
                rtnValue = show(datetimepicker,dataType,PdlineName,Template);
                break;





        }
        context.Response.Write(rtnValue);
    }




    public string GetDate()
    {
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+dt.Rows[0][0].ToString()+"\"}]";
    }




    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT PDLINE_NAME FROM  SAJET.SYS_ECHECK_POWER_BASE) AND PDLINE_NAME LIKE'"+JJ+"%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }





  public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT PDLINE_NAME FROM  SAJET.SYS_ECHECK_POWER_BASE)ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowDnno(string Template,string user,string PdlineName,string datetimepicker,string dataType)
    {
        string sql = "";

        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }

        if (Template != "" && Template != null && Template != "null")
        {
            sql = sql + " AND TEMPLATE ='" + Template + "'";
        }
        if (datetimepicker != "" && datetimepicker != null && datetimepicker != "null")
        {
            sql = sql + " AND YEAR_DATE ='" + datetimepicker + "'";
        }
        if (dataType != "" && dataType != null && dataType != "null" && dataType != "--请选择--")
        {
            sql = sql + " AND CLASS ='" + dataType + "'";
        }
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND PDLINE_NAME ='" + PdlineName + "'";
        }
        //if(ProcessName!=""&& ProcessName!=null&& ProcessName!="null")
        //{
        //    sql = sql + " AND PROCESS_NAME ='" + ProcessName + "'";
        //}
        //string sSQL = $@"SELECT TO_CHAR(SYSDATE-1,'YYYY-MM-DD') FROM DUAL";
        //DataTable dt = PubClass.getdatatableMES(sSQL);
        //string StartDate=dt.Rows[0][0].ToString();
        //string YEAR_DATE = DateTime.Now.ToString("yyyy-MM-dd");
        string sSQL = $@"SELECT DISTINCT DN_NO FROM SAJET.G_ECHECK_BASE  WHERE NUMBER_ID IN(SELECT NUMBER_ID FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE (PDLINE_NAME,TEMPLATE) IN(SELECT PDLINE_NAME,TEMPLATE FROM SAJET.SYS_ECHECK_POWER_BASE WHERE CHECK_EMPID='{userEmpId}'AND CHECK_TYPE IN('FACA人权限','点检人FACA权限'))) AND FATYPE='Y' AND LOG_TYPE='Y'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG ORDER BY  TEMPLATE";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string datetimepicker,string dataType,string PdlineName,string Template)
    {
        string sql = "";

        if (Template != "" && Template != null && Template != "null")
        {
            sql = sql + " AND B.TEMPLATE ='" + Template + "'";
        }

        if (datetimepicker != "" && datetimepicker != null && datetimepicker != "null")
        {
            sql = sql + " AND B.YEAR_DATE ='" + datetimepicker + "'";
        }
        if (dataType != "" && dataType != null && dataType != "null" && dataType != "--请选择--")
        {
            sql = sql + " AND B.CLASS ='" + dataType + "'";
        }
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND B.PDLINE_NAME ='" + PdlineName + "'";
        }
       string sSQL = $@"SELECT A.DN_NO,A.DATED,A.DATEW,A.MODEL,A.WF,A.PDLINE,A.TERMINAL,A.ABNORMAL,A.ANALYSIS,A.IMPROVEMENT,A.CATEGORY,A.PERSON,A.DIRECTOR,A.STARTTIME,A.FINISHTIME,A.FOLLOWUP,A.STATUS,A.AUDITORS FROM SAJET.G_ECHECK_FACA A,SAJET.SYS_ECHECK_TEMPLATE_MODEL B
        WHERE A.DN_NO=B.DN_NO " +sql+"";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }



    public string getEmpIdByNo2(string user)
    {
        string sSQL = $@"SELECT EMP_NAME 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "";
        }
        return dt.Rows[0]["EMP_NAME"].ToString();
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