<%@ WebHandler Language="C#" Class="Gold_Sample_Query" %>
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


public class Gold_Sample_Query : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string PdlineName = context.Request["PdlineName"];
        string WorkOrder = context.Request["WorkOrder"];
        string TerminalName = context.Request["TerminalName"];
        string Shift = context.Request["Shift"];

        string Startdatetimepicker = context.Request["Startdatetimepicker"];
        string Enddatetimepicker = context.Request["Enddatetimepicker"];
        string JJ = context.Request["JJ"];
        string ProcessName = context.Request["ProcessName"];


        switch (funcName)
        {
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowProcess":
                rtnValue = ShowProcess(PdlineName);
                break;
            case "ShowTerminal":
                rtnValue = ShowTerminal(PdlineName, ProcessName);
                break;
            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "show":
                rtnValue = show(Shift, PdlineName, WorkOrder, ProcessName, TerminalName, Startdatetimepicker, Enddatetimepicker);
                break;

        }
        context.Response.Write(rtnValue);
    }
    public string ShowProcess(string PdlineName)
    {
        string SSQL = "SELECT DISTINCT B.PROCESS_NAME FROM SAJET.SYS_TERMINAL A ,SAJET.SYS_PROCESS B,SAJET.SYS_PDLINE C WHERE C.PDLINE_NAME = '" + PdlineName + "'AND A.PROCESS_ID = B.PROCESS_ID AND A.PDLINE_ID=C.PDLINE_ID AND A.ENABLED='Y'AND B.ENABLED='Y'AND C.ENABLED='Y' ";
        DataTable dt = PubClass.getdatatableMES(SSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTerminal(string PdlineName, string ProcessName)
    {
        string SSQL = "SELECT DISTINCT B.PROCESS_NAME FROM SAJET.SYS_TERMINAL A ,SAJET.SYS_PROCESS B,SAJET.SYS_PDLINE C WHERE C.PDLINE_NAME = '" + PdlineName + "' AND B.PROCESS_NAME='" + ProcessName + "' AND A.PROCESS_ID = B.PROCESS_ID AND A.PDLINE_ID=C.PDLINE_ID AND A.ENABLED='Y'AND B.ENABLED='Y'AND C.ENABLED='Y' ";
        DataTable dt = PubClass.getdatatableMES(SSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string Shift, string PdlineName, string WorkOrder, string ProcessName, string TerminalName, string Startdatetimepicker, string Enddatetimepicker)
    {
        string sql = "";
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND D.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (ProcessName != "" && ProcessName != null && ProcessName != "null")
        {
            sql = sql + " AND C.PROCESS_NAME ='" + ProcessName + "'";
        }
        if (TerminalName != "" && TerminalName != null && TerminalName != "null")
        {
            sql = sql + " AND B.TERMINAL_NAME ='" + TerminalName + "'";
        }
        if (WorkOrder != "" && WorkOrder != null && WorkOrder != "null")
        {
            sql = sql + " AND A.WORK_ORDER ='" + WorkOrder + "'";
        }
        if (Shift != "" && Shift != null && Shift != "null" && Shift != "--请选择--")
        {
            sql = sql + " AND A.SHIFT  ='" + Shift + "'";
        }
        string sSQL = $@"SELECT A.WORK_ORDER,A.SERIAL_NUMBER,D.PDLINE_NAME,C.PROCESS_NAME,B.TERMINAL_NAME, CASE WHEN A.CURRENT_STATUS='0' THEN 'PASS' WHEN A.CURRENT_STATUS='1' THEN 'FAIL' END CURRENT_STATUS,A.CREATE_TIME,A.PASS_SEQ,A.END_TYPE,A.STATUS,A.SHIFT FROM SAJET.G_GOLDENSAMPLE_TRAVEL A,SAJET.SYS_TERMINAL B,SAJET.SYS_PROCESS C,SAJET.SYS_PDLINE D
                        WHERE A.TERMINAL_ID=B.TERMINAL_ID
                        AND B.PROCESS_ID=C.PROCESS_ID
                        AND B.PDLINE_ID=D.PDLINE_ID {sql}
                        AND A.CREATE_TIME BETWEEN TO_DATE('{Startdatetimepicker}','YYYY-MM-DD')AND TO_DATE('{Enddatetimepicker}','YYYY-MM-DD')
                        ORDER BY A.CREATE_TIME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME LIKE'" + JJ + "%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetDate()
    {
        string sSQL = $@"SELECT TO_CHAR(SYSDATE-1,'YYYY-MM-DD'),TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return "[{\"ERR_CODE\":\"" + dt.Rows[0][0].ToString() + "\",\"ERR_MSG\":\"" + dt.Rows[0][1].ToString() + "\"}]";
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