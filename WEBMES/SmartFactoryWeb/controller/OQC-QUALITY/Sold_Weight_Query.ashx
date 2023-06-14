<%@ WebHandler Language="C#" Class="Sold_Weight_Query" %>
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


public class Sold_Weight_Query : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string PdlineName = context.Request["PdlineName"];
        string Pstage = context.Request["Pstage"];
        string Ptool = context.Request["Ptool"];
        string Presult = context.Request["Presult"];
        string Startdatetimepicker = context.Request["Startdatetimepicker"];
        string Enddatetimepicker = context.Request["Enddatetimepicker"];
                    string JJ = context.Request["JJ"];



        switch (funcName)
        {
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "show":
                rtnValue = show(PdlineName, Pstage, Ptool, Presult, Startdatetimepicker, Enddatetimepicker);
                break;

        }
        context.Response.Write(rtnValue);
    }
    public string show(string PdlineName, string Pstage, string Ptool, string Presult, string Startdatetimepicker, string Enddatetimepicker)
    {
        string sql = "";
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (Pstage != "" && Pstage != null && Pstage != "null")
        {
            sql = sql + " AND A.STAGE_NAME ='" + Pstage + "'";
        }
        if (Ptool != "" && Ptool != null && Ptool != "null")
        {
            sql = sql + " AND A.TOOLSN ='" + Ptool + "'";
        }
        if (Presult != "" && Presult != null && Presult != "null" && Presult != "--请选择--")
        {
            sql = sql + " AND A.RESULT  ='" + Presult + "'";
        }
        string sSQL = $@"SELECT A.TOOLSN, A.PDLINE_NAME,A.STAGE_NAME,NVL(A.WEIGHT,0) AS WEIGHT,NVL(A.TOOLSN_WEIGHT, 0) AS TOOLSN_WEIGHT,
                        TRUNC((NVL(A.SOLE_WEIGHT,0)*D.MULTIPLE/A.REMARK),3)AS SOLE_WEIGHT, A.MAX_WEIGHT,A.MIN_WEIGHT,
                        A.REMARK,A.RESULT, B.EMP_NAME,A.CREATE_TIME
                        FROM SAJET.G_SOLDTOOL_WEIGHT A, SAJET.SYS_EMP B, SAJET.G_BOX_WEIGHT C,SAJET.G_SOLD_WEIGHT_BASE D
                        WHERE 1 = 1 AND A.CREATE_USERID = B.EMP_ID AND A.PDLINE_NAME=D.PDLINE AND A.STAGE_NAME=D.STAGE
                        AND A.TOOLSN = C.BOX_NO(+){sql} AND A.CREATE_TIME BETWEEN TO_DATE('{Startdatetimepicker}','YYYY-MM-DD')AND TO_DATE('{Enddatetimepicker}','YYYY-MM-DD') ORDER BY A.CREATE_TIME";
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