<%@ WebHandler Language="C#" Class="O07" %>
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
public class O07 : IHttpHandler
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
        string ModelName = context.Request["ModelName"];
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
            case "ShowModel":
                rtnValue = ShowModel();
                break;
            case "ShowModelJJ":
                rtnValue = ShowModelJJ(JJ);
                break;
            case "GetType":
                rtnValue = GetType(DN_NO,user);
                break;

            case "GetUserType":
                rtnValue = GetUserType(DN_NO,user);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowDnno":
                rtnValue = ShowDnno(user);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "GetTypeDn":
                rtnValue = GetTypeDn(DN_NO,user,ID);
                break;
            case "defete":
                rtnValue = Getdelete(DN_NO,user,ID);
                break;
            case "GetLabel":
                rtnValue = GetLabel(DN_NO);
                break;
            case "GetQTY":
                rtnValue = GetQTY(Template);
                break;
            case "show":
                rtnValue = show(Template,DN_NO,datetimepicker,dataType);
                break;
            case "GetDnnoType":
                rtnValue = GetDnnoType(DN_NO);
                break;
            //case "GetProcess":
            //    rtnValue = GetProcess(PdlineName);
            //    break;
            case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(USERTYPE,DN_NO,user,ID,Date,Datew,Model,wf,Pdline,Class,Terminal,Abnormal,Analysis,Improvement,Category,Person,Director,StartTime,FinishTime,Followup,Status,Auditors);
                break;




        }
        context.Response.Write(rtnValue);
    }



    public string GetTypeDn(string DN_NO,string user,String ID)
    {
        string Flag = "N";string QtyFlag = "N";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }


        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}'AND MODEL_NAME='{dt1.Rows[0]["MODEL_NAME"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE IN('FACA人权限')";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if(dt1.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有FACA权限\"}]";
        }
        sSQL1 = $"SELECT * FROM  SAJET.G_ECHECK_FACA WHERE DN_NO='{DN_NO}'AND ID='{ID}'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if(dt1.Rows.Count==0)
        {
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该单号点检人还未填写\"}]";
            }
        }
        return "[{\"ERR_CODE\":\"N\",\"WF\":\"" + dt1.Rows[0]["WF"].ToString() + "\",\"ABNORMAL\":\"" + dt1.Rows[0]["ABNORMAL"].ToString() + "\",\"PERSON\":\"" + dt1.Rows[0]["PERSON"].ToString() + "\",\"DIRECTOR\":\"" + dt1.Rows[0]["DIRECTOR"].ToString() + "\",\"FINISHTIME\":\"" + dt1.Rows[0]["FINISHTIME"].ToString() + "\",\"CATEGORY\":\"" + dt1.Rows[0]["CATEGORY"].ToString() + "\",\"FOLLOWUP\":\"" + dt1.Rows[0]["FOLLOWUP"].ToString() + "\",\"STATUS\":\"" + dt1.Rows[0]["STATUS"].ToString() + "\",\"AUDITORS\":\"" + dt1.Rows[0]["AUDITORS"].ToString() + "\"}]";
    }
    public string GetDate()
    {
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+dt.Rows[0][0].ToString()+"\"}]";
    }
    public string GetType(string DN_NO,string user)
    {

        string userEmpNAME = getEmpIdByNo2(user);
        string sSQL1 = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        string DATE = dt1.Rows[0][0].ToString();
        sSQL1 = $@"SELECT TO_CHAR (SYSDATE, 'IW')FROM DUAL";
        dt1 = PubClass.getdatatableMES(sSQL1);
        string WEEKDATE ='W'+dt1.Rows[0][0].ToString();
        sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        string MODEL_NAME = dt1.Rows[0]["MODEL_NAME"].ToString();
        string PDLINE_NAME = dt1.Rows[0]["PDLINE_NAME"].ToString();
        string rtn = "[{\"MODEL_NAME\":\"" + MODEL_NAME + "\",\"PDLINE_NAME\":\"" + PDLINE_NAME + "\",\"DATE\":\"" + DATE + "\",\"USEREMPNAME\":\"" + userEmpNAME + "\",\"WEEKDATE\":\"" + WEEKDATE + "\"}]";
        return rtn;

    }
    public string GetUserType(string DN_NO,string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}'AND MODEL_NAME='{dt1.Rows[0]["MODEL_NAME"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE IN('FACA人权限','点检人FACA权限')";
        dt1 = PubClass.getdatatableMES(sSQL1);
        string rtn = "[{\"USERTYPE\":\"" + dt1.Rows[0]["CHECK_TYPE"].ToString() + "\"}]";
        return rtn;
    }

    public string UpdateTemplateInfo1(string USERTYPE,string DN_NO,string user,string ID,string Date,string Datew,string Model,string wf,string Pdline,string Class,string Terminal,string Abnormal,string Analysis,string Improvement,string Category,string Person,string Director,string StartTime,string FinishTime,string Followup,string Status,string Auditors)
    {
        string Flag = "N";string QtyFlag = "N";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }

        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}'AND MODEL_NAME='{dt1.Rows[0]["MODEL_NAME"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE IN('FACA人权限','点检人FACA权限')";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if(dt1.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有FACA权限\"}]";
        }
        if(USERTYPE=="点检人FACA权限")
        {
            if(Date==string.Empty||Datew==string.Empty||Model==string.Empty||wf==string.Empty||Pdline==string.Empty||Class==string.Empty||Terminal==string.Empty||Abnormal==string.Empty||Category==string.Empty||Person==string.Empty||Director==string.Empty||FinishTime==string.Empty||Followup==string.Empty||Status==string.Empty)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,请将数据填写完整!\"}]";
            }
            sSQL1 = $"SELECT * FROM  SAJET.G_ECHECK_FACA WHERE DN_NO='{DN_NO}'AND ID='{ID}'";
            dt1 = PubClass.getdatatableMES(sSQL1);
            if(dt1.Rows.Count==0)
            {
                string  sSQL3 = $@"INSERT INTO SAJET.G_ECHECK_FACA(DN_NO,ID,DATED,DATEW,MODEL,WF,PDLINE,CLASS,TERMINAL,ABNORMAL,CATEGORY,PERSON,DIRECTOR,FINISHTIME,FOLLOWUP,STATUS,AUDITORS,CREATE_DATE,CREATE_USERID)
               VALUES('{DN_NO}','{ID}','{Date}','{Datew}','{Model}','{wf}','{Pdline}','{Class}','{Terminal}','{Abnormal}','{Category}','{Person}','{Director}','{FinishTime}','{Followup}','{Status}','{Auditors}',SYSDATE,'{userEmpId}')";
                PubClass.getdatatablenoreturnMES(sSQL3);
            }
            else
            {
                string sSQL = $@"UPDATE SAJET.G_ECHECK_FACA SET DATED='{Date}',DATEW='{Datew}',WF='{wf}',ABNORMAL='{Abnormal}',CATEGORY='{Category}',PERSON='{Person}',DIRECTOR='{Director}',FINISHTIME='{FinishTime}',FOLLOWUP='{Followup}',STATUS='{Status}',AUDITORS='{Auditors}',CREATE_DATE=SYSDATE,CREATE_USERID='{userEmpId}'WHERE ID='{ID}'";
                PubClass.getdatatablenoreturnMES(sSQL);            }
        }
        if(USERTYPE=="FACA人权限")
        {
            if(Improvement==string.Empty||StartTime==string.Empty||Analysis==string.Empty)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,请将数据填写完整!\"}]";
            }
            string sSQL = $@"UPDATE SAJET.G_ECHECK_BASE SET FATYPE='N'WHERE ID='{ID}'";
            PubClass.getdatatablenoreturnMES(sSQL);

            sSQL = $@"UPDATE SAJET.G_ECHECK_FACA SET Improvement='{Improvement}',StartTime='{StartTime}',Analysis='{Analysis}'WHERE ID='{ID}'";
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
            Send(DN_NO + "单号被驳回,请确认", Email, "Wenjian.Ma@luxshare-ict.com", "E-CheckFACA邮件提醒" + " - " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), mailMessage);
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,驳回成功!\"}]";

    }




    public void Send(string senderName, string EmailTo, string EmailCc, string subject, string body)
    {
        try
        {

            string[] MailToArray = EmailTo.Split(';');
            string[] MailCcArray = EmailCc.Split(';');
            MyProperty = new MailMessage();
            Smtp.Host = "10.41.3.22";
            Smtp.Port = 25;
            MyProperty.From = new MailAddress("KS-BU17.MES@luxshare-ict.com", senderName);// "KS-BU17.MES@luxshare-ict.com"
            Smtp.Credentials = new System.Net.NetworkCredential("KS-BU17.MES@luxshare-ict.com", "Luxsh@re,20723");//("KS-BU17.MES@luxshare-ict.com", "Luxsh@re,20723");
            MyProperty.Subject = subject;
            MyProperty.SubjectEncoding = Encoding.UTF8;
            MyProperty.IsBodyHtml = true;//是否为HTML
            MyProperty.Body = body + "(平台地址:http://10.32.15.59:9001/)"; //邮件内容
            for (int i = 0; i < MailToArray.Length; i++)
            {
                MyProperty.To.Add(MailToArray[i]);
            }
            for (int i = 0; i < MailCcArray.Length; i++)
            {
                MyProperty.CC.Add(MailCcArray[i]);
            }
            MyProperty.Priority = MailPriority.High; //设置邮箱优先等级
            Smtp.DeliveryMethod = SmtpDeliveryMethod.Network;//设置邮件发送方式
            SendEmail();
        }
        catch (Exception ex)
        {
        }

    }
    public void SendEmail()
    {
        try
        {
            this.smtp.Send(this.MyProperty);
            //this.smtp.SendAsync(this.mail.From, this.mail.To, this.mail.Subject, this.mail.Body);
        }
        catch (Exception e)
        {

        }
        finally
        {
            this.MyProperty.Dispose();
            //this.Smtp.Dispose(); 
        }
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
        if(dt.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+dt.Rows[0][0].ToString()+"\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"N/A\"}]";
    }


    public string GetLabel(string DN_NO)
    {
        string sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE  IN(SELECT TEMPLATE FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}') ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetQTY(string Template)
    {
        string sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{Template}' ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,此模板未维护标题!\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+dt.Rows.Count+"\"}]";
    }
    public string ShowModel()
    {
        string sSQL = $@"SELECT MODEL_NAME FROM SAJET.SYS_MODEL WHERE ENABLED='Y'ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowModelJJ(string JJ)
    {
        string sSQL = @"SELECT MODEL_NAME FROM SAJET.SYS_MODEL WHERE ENABLED='Y' AND MODEL_NAME LIKE'"+JJ+"%'ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }



    //public string GetProcess(string PdlineName)
    //{
    //    string sSQL = $@"Select DISTINCT B.PROCESS_NAME "
    //           + " From SAJET.SYS_TERMINAL A "
    //           + "     ,SAJET.SYS_PROCESS B "
    //           + "     ,SAJET.SYS_STAGE C "
    //           + "     ,SAJET.SYS_PDLINE D "
    //           + "     ,SAJET.SYS_OPERATE_TYPE E "
    //           + " Where D.PDLINE_NAME = '" + PdlineName + "' "
    //           + " AND A.PROCESS_ID = B.PROCESS_ID "
    //           + " AND B.OPERATE_ID = E.OPERATE_ID "
    //           + " AND A.STAGE_ID = C.STAGE_ID "
    //           + " AND A.PDLINE_ID = D.PDLINE_ID  ORDER BY B.PROCESS_NAME";
    //    DataTable dt = PubClass.getdatatableMES(sSQL);
    //    return JsonConvert.SerializeObject(dt);
    //}


    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowDnno(string user)
    {
        string sql = "";

        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }

        //if(Template!=""&& Template!=null&& Template!="null")
        //{
        //    sql = sql + " AND TEMPLATE ='" + Template + "'";
        //}
        //if(ModelName!=""&& ModelName!=null&& ModelName!="null")
        //{
        //    sql = sql + " AND MODEL_NAME ='" + ModelName + "'";
        //}
        //if(datetimepicker!=""&& datetimepicker!=null&& datetimepicker!="null")
        //{
        //    sql = sql + " AND YEAR_DATE ='" + datetimepicker + "'";
        //}
        //if(dataType!=""&& dataType!=null&& dataType!="null"&& dataType!="--请选择--")
        //{
        //    sql = sql + " AND CLASS ='" + dataType + "'";
        //}
        //if(PdlineName!=""&& PdlineName!=null&& PdlineName!="null")
        //{
        //    sql = sql + " AND PDLINE_NAME ='" + PdlineName + "'";
        //}
        //if(ProcessName!=""&& ProcessName!=null&& ProcessName!="null")
        //{
        //    sql = sql + " AND PROCESS_NAME ='" + ProcessName + "'";
        //}
        //string sSQL = $@"SELECT TO_CHAR(SYSDATE-1,'YYYY-MM-DD') FROM DUAL";
        //DataTable dt = PubClass.getdatatableMES(sSQL);
        //string StartDate=dt.Rows[0][0].ToString();
        //string YEAR_DATE = DateTime.Now.ToString("yyyy-MM-dd");
        string sSQL = $@"SELECT DISTINCT DN_NO FROM SAJET.G_ECHECK_BASE  WHERE NUMBER_ID IN(SELECT NUMBER_ID FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE (MODEL_NAME,PDLINE_NAME,TEMPLATE) IN(SELECT MODEL_NAME,PDLINE_NAME,TEMPLATE FROM SAJET.SYS_ECHECK_POWER_BASE WHERE CHECK_EMPID='{userEmpId}'AND CHECK_TYPE IN('FACA人权限','点检人FACA权限'))) AND FATYPE='Y' AND LOG_TYPE='Y'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG ORDER BY  TEMPLATE";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string Template,string DN_NO,string datetimepicker,string dataType)
    {
        string sql = "";
        string sSQL = $@"SELECT B.REMARK,B.DRI_DATE,E.EMP_NAME AS EMP_NAME1,B.RESULT,B.FA,B.CA,A.TEMPLATE,B.ID,B.DN_NO,C.YEAR_DATE,C.CLASS,B.TYPE1,B.TYPE2,B.TYPE3,B.TYPE4,B.TYPE5,B.TYPE6,B.TYPE7,B.TYPE8,B.TYPE9,B.TYPE10,B.TYPE11,B.TYPE12,B.TYPE13,B.TYPE14,B.TYPE15,B.TYPE16,B.TYPE17,B.TYPE18,B.TYPE19,B.TYPE20,B.CREATE_DATE,D.EMP_NAME FROM SAJET.SYS_ECHECK_TEMPLATE_CONFIG A ,SAJET.G_ECHECK_BASE B,SAJET.SYS_ECHECK_TEMPLATE_MODEL C,SAJET.SYS_EMP D,SAJET.SYS_EMP E
WHERE A.NUMBER_ID=B.NUMBER_ID
AND A.NUMBER_ID=C.NUMBER_ID
AND B.DN_NO=C.DN_NO  AND B.DN_NO ='" + DN_NO + "' AND B.FATYPE='Y' AND B.LOG_TYPE='Y' AND B.CREATE_EMPID=D.EMP_ID(+) AND B.DRI_EMPID=E.EMP_ID(+)  ORDER BY B.SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string del(string NUMBER_ID,string user,string Template,string PdlineName,string ModelName,string DN_NO)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"UPDATE SAJET.SYS_ECHECK_TEMPLATE_MODEL SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE TEMPLATE='{Template}'AND NUMBER_ID='{NUMBER_ID}' AND DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_ECHECK_TEMPLATE_MODEL SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE NUMBER_ID='{NUMBER_ID}'AND DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE NUMBER_ID='{NUMBER_ID}'AND DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功!\"}]";
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