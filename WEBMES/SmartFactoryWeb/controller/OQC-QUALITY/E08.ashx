<%@ WebHandler Language="C#" Class="E08" %>
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
public class E08 : IHttpHandler
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
        string ModelName = context.Request["ModelName"];
        string PdlineName = context.Request["PdlineName"];
        //string ProcessName = context.Request["ProcessName"];
        string datetimepicker = context.Request["datetimepicker"];
        string dataType = context.Request["dataType"];
        string DN_NO = context.Request["DN_NO"];
        string DnNo = context.Request["DnNo"];
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
        string Category = context.Request["Category"];
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
            case "ShowDnno":
                rtnValue = ShowDnno(user);
                break;

            case "GetType":
                rtnValue = GetType();
                break;

            case "GetUserType":
                rtnValue = GetUserType(DN_NO, user);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;

            case "GetTypeDn":
                rtnValue = GetTypeDn(DN_NO, user, ID);
                break;
            case "defete":
                rtnValue = Getdelete(DN_NO, user, ID);
                break;
            case "show":
                rtnValue = show(DnNo);
                break;
            case "GetDnnoType":
                rtnValue = GetDnnoType(DN_NO);
                break;

            case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(USERTYPE, DN_NO, user, ID, Date, Datew, wf, Pdline, Class, Terminal, Abnormal, Analysis, Improvement, Category, Person, Director, StartTime, FinishTime, Followup, Status, Auditors);
                break;
            case "ShowBuNo":
                rtnValue = ShowBuNo(user);
                break;
            case "ShowTemplateData":
                rtnValue = ShowTemplateData(DN_NO);
                break;




        }
        context.Response.Write(rtnValue);
    }

    public string ShowDnno(string user)
    {
        string sql = "";

        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        string sSQL = $@"SELECT DISTINCT WORK_NO FROM SAJET.G_CHECK_FACA  WHERE ENABLED='Y'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowBuNo(string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查\"}]";

        }
        string sSQL = $@"SELECT SECTON_NAME FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE   EMP_ID='{userEmpId}'AND CHECK_TYPE='2' ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此人员未维护部门信息,请检查\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\"}]";
    }
    public string ShowTemplateData(string DN_NO)
    {
        string sSQL = $@"SELECT * FROM  SAJET.G_CHECK_WORK_BASE   WHERE  WORK_NO='{DN_NO}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);

        string PROJECT_NAME = dt.Rows[0]["PROJECT_NAME"].ToString();
                string ModelName = dt.Rows[0]["MODEL_NAME"].ToString();
        string PdlineName = dt.Rows[0]["PDLINE_NAME"].ToString();

           sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG WHERE   PROJECT_NAME='{PROJECT_NAME}'";
         dt = PubClass.getdatatableMES(sSQL);
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();


        sSQL = $@"SELECT DISTINCT FREQUENCY FROM   SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_NAME='{PROJECT_NAME}'AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}'";
        dt = PubClass.getdatatableMES(sSQL);

        sSQL = $@"SELECT CHECK_TIME FROM  SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{PROJECT_ID}' AND  FREQUENCY='{dt.Rows[0][0].ToString()}'ORDER BY SEQ";
        dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);


    }
    public string show(string DN_NO)
    {
        string SQL = $"SELECT A.PDLINE_NAME,A.PROJECT_NAME,A.WORK_DATE,A.WORK_TYPE,A.PROJECT_NAME ,B.* FROM SAJET.G_CHECK_WORK_BASE A,SAJET.G_CHECK_WORK_BASE_INFO B,SAJET.G_CHECK_FACA C WHERE A.WORK_NO='{DN_NO}' AND A.WORK_NO=B.WORK_NO AND B.WORK_NO=C.WORK_NO AND B.NUMBER_ID=C.NUMBER_ID   AND B.ENABLED='Y' AND C.ENABLED='Y'";
        DataTable dt = PubClass.getdatatableMES(SQL);
        return JsonConvert.SerializeObject(dt);
    }





    public string GetTypeDn(string DN_NO, string user, string ID)
    {
        string Flag = "N"; string QtyFlag = "N";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL1 = $"SELECT * FROM  SAJET.G_CHECK_FACA WHERE WORK_NO='{DN_NO}'AND NUMBER_ID='{ID}' AND DATEW IS NULL";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        if (dt1.Rows.Count > 0)
        {
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该单号点检人还未填写\"}]";
            }
        }


        sSQL1 = $"SELECT * FROM  SAJET.G_CHECK_FACA WHERE WORK_NO='{DN_NO}'AND NUMBER_ID='{ID}'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        return "[{\"ERR_CODE\":\"N\",\"WF\":\"" + dt1.Rows[0]["WF"].ToString() + "\",\"ABNORMAL\":\"" + dt1.Rows[0]["ABNORMAL"].ToString() + "\",\"PERSON\":\"" + dt1.Rows[0]["PERSON"].ToString() + "\",\"DIRECTOR\":\"" + dt1.Rows[0]["DIRECTOR"].ToString() + "\",\"FINISHTIME\":\"" + dt1.Rows[0]["FINISHTIME"].ToString() + "\",\"CATEGORY\":\"" + dt1.Rows[0]["CATEGORY"].ToString() + "\",\"FOLLOWUP\":\"" + dt1.Rows[0]["FOLLOWUP"].ToString() + "\",\"STATUS\":\"" + dt1.Rows[0]["STATUS"].ToString() + "\",\"AUDITORS\":\"" + dt1.Rows[0]["AUDITORS"].ToString() + "\"}]";
    }
    public string GetDate()
    {
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\"}]";
    }
    public string GetType()
    {

        String sSQL1 = $@"SELECT TO_CHAR (SYSDATE, 'IW')FROM DUAL";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        string WEEKDATE = 'W' + dt1.Rows[0][0].ToString();

        string rtn = "[{\"WEEKDATE\":\"" + WEEKDATE + "\"}]";
        return rtn;

    }
    public string GetUserType(string DN_NO, string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }

        string sSQL1 = $"SELECT * FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE EMP_ID='{userEmpId}' AND CHECK_TYPE='2'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        string rtn = "[{\"USERTYPE\":\"" + dt1.Rows[0]["STATUS"].ToString() + "\"}]";
        return rtn;
    }

    public string UpdateTemplateInfo1(string USERTYPE, string DN_NO, string user, string ID, string Date, string Datew,string wf, string Pdline, string Class, string Terminal, string Abnormal, string Analysis, string Improvement, string Category, string Person, string Director, string StartTime, string FinishTime, string Followup, string Status, string Auditors)
    {
        string Flag = "N"; string QtyFlag = "N";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }

        string sSQL1 = $" SELECT * FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE EMP_ID='{userEmpId}' AND CHECK_TYPE='2'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        if (dt1.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有权限\"}]";
        }
        if (USERTYPE == "点检")
        {
            if (Date == string.Empty || Datew == string.Empty || wf == string.Empty || Pdline == string.Empty || Class == string.Empty || Terminal == string.Empty || Abnormal == string.Empty || Category == string.Empty || Person == string.Empty || Director == string.Empty || FinishTime == string.Empty || Followup == string.Empty || Status == string.Empty)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,请将数据填写完整!\"}]";
            }
            string sSQL = $@"UPDATE SAJET.G_CHECK_FACA SET DATED='{Date}',DATEW='{Datew}',WF='{wf}',ABNORMAL='{Abnormal}',CATEGORY='{Category}',PERSON='{Person}',DIRECTOR='{Director}',FINISHTIME='{FinishTime}',FOLLOWUP='{Followup}',STATUS='{Status}',AUDITORS='{Auditors}',UPDATE_DATE=SYSDATE,UPDATE_USERID='{userEmpId}'WHERE WORK_NO='{DN_NO}' AND  NUMBER_ID='{ID}'";
            PubClass.getdatatablenoreturnMES(sSQL);
        }
        if (USERTYPE == "异常")
        {
            if (Improvement == string.Empty || StartTime == string.Empty || Analysis == string.Empty)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,请将数据填写完整!\"}]";
            }
            string sSQL = $@"UPDATE SAJET.G_CHECK_FACA SET Improvement='{Improvement}',StartTime='{StartTime}',Analysis='{Analysis}',ENABLED='N'WHERE  WORK_NO='{DN_NO}' AND  NUMBER_ID='{ID}'";
            PubClass.getdatatablenoreturnMES(sSQL);
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,维护FACA OK!\"}]";
    }


    public string Getdelete(string DN_NO, string user, string ID)
    {


        ////MailUtils m = new MailUtils();
        string Email = "";
        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}'AND MODEL_NAME='{dt1.Rows[0]["MODEL_NAME"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_TYPE='点检人FACA权限'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if (dt1.Rows.Count > 0)
        {
            for (int i = 0; i <= dt1.Rows.Count - 1; i++)
            {
                Email = Email + dt1.Rows[i]["EMAIL"].ToString() + ";";
            }
            Email = Email.Substring(0, Email.Length - 1);
            string sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{dt1.Rows[0]["TEMPLATE"].ToString()}' ORDER BY SEQ";
            DataTable dt = PubClass.getdatatableMES(sSQL);
            int QTY = dt.Rows.Count;

            string mailMessage = $@"<!DOCTYPE html>
                                    <html>

                                    <head>
                                        <title></title>
                                        <meta charset='utf-8'>
                                    </head>

                                    <body>
                                        <p>以下内容自动发送，请勿直接回复，谢谢。</p>
                                        <p></p>
                                        <p>";
            string titleMessage = $@"<table border='1' style='width:80%;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 17px;'>
                                   <tr style='background-color:#a8cc44;color: cornsilk;'>";
            titleMessage += $@"<td style='width: 10%;'>单号</td>";
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                titleMessage += $@"<td style='width: 5%;'>{dt.Rows[i]["TITLE"]}</td>";
            }
            titleMessage += "</tr>";
            string detailMessage = $@"";
            sSQL = $@"SELECT * FROM SAJET.G_ECHECK_BASE  WHERE ID='{ID}'";
            dt = PubClass.getdatatableMES(sSQL);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                detailMessage += $@"<tr style='font-size:13px;'>";
                detailMessage += $@"<td>{dt.Rows[i][dt.Columns[0].ColumnName]}</td>";
                for (int j = 2; j < QTY + 2; j++)
                {
                    detailMessage += $@"<td>{dt.Rows[i][dt.Columns[j].ColumnName]}</td>";
                }
                detailMessage += $@"</tr>";
            }

            string endMessage = $@"</table>
                                    </ p >
                            </ body >

                            </ html > ";

            mailMessage = mailMessage + titleMessage + detailMessage + endMessage;
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,驳回成功!\"}]";

    }





    private string getMailContent(DataTable sqlData, string sendderName)
    {
        string mailMessage = $@"<!DOCTYPE html>
                                    <html>

                                    <head>
                                        <title></title>
                                        <meta charset='utf-8'>
                                    </head>

                                    <body>
                                        <p>以下内容为 {sendderName} 自动发送，请勿直接回复，谢谢。</p>
                                        <p></p>
                                        <p>";

        string titleMessage = $@"<table border='1' style='width:100%;text-align:center;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 17px;'>
                                   <tr style='background-color:#a8cc44;color: cornsilk;'>";

        for (int i = 0; i < sqlData.Columns.Count; i++)
        {
            titleMessage += $@"<td style='width: 10%;'>{sqlData.Columns[i].ColumnName}</td>";
        }

        titleMessage += "</tr>";

        string detailMessage = $@"";

        for (int i = 0; i < sqlData.Rows.Count; i++)
        {
            detailMessage += $@"<tr style='font-size:13px;'>";

            for (int j = 0; j < sqlData.Columns.Count; j++)
            {
                detailMessage += $@"<td>{sqlData.Rows[i][sqlData.Columns[j].ColumnName]}</td>";
            }

            detailMessage += $@"</tr>";
        }

        string endMessage = $@"</table>
                                    </ p >
                            </ body >

                            </ html > ";

        mailMessage = mailMessage + titleMessage + detailMessage + endMessage;

        return mailMessage;
    }







    public string GetDnnoType(string DN_NO)
    {
        string sSQL = $@"SELECT DN_STATUS FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL  WHERE DN_NO='{DN_NO}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"N/A\"}]";
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