<%@ WebHandler Language="C#" Class="E06" %>
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


public class E06 : IHttpHandler
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
        string NUMBER_ID = context.Request["NUMBER_ID"];
        string PdlineName = context.Request["PdlineName"];
        string JJ = context.Request["JJ"];
        string BuName = context.Request["BuName"];
        string ProcessName = context.Request["ProcessName"];
        string Section_Name = context.Request["Section_Name"];
        string datetimepicker = context.Request["datetimepicker"];
        string dataType = context.Request["dataType"];
        string ProjectName = context.Request["ProjectName"];
        string type = context.Request["type"];
        string DnNo = context.Request["DnNo"];
        string ID = context.Request["ID"];
        string Type1 = context.Request["Type1"];
        string Type2 = context.Request["Type2"];
        string Type3 = context.Request["Type3"];
        string Type4 = context.Request["Type4"];
        string Type5 = context.Request["Type5"];
        string Type6 = context.Request["Type6"];
        string Type7 = context.Request["Type7"];
        string Type8 = context.Request["Type8"];
        string Type9 = context.Request["Type9"];
        string Type10 = context.Request["Type10"];
        string Type11 = context.Request["Type11"];
        string Type12 = context.Request["Type12"];
        string Type13 = context.Request["Type13"];
        string Type14 = context.Request["Type14"];
        string Type15 = context.Request["Type15"];
        string Type16 = context.Request["Type16"];
        string Type17 = context.Request["Type17"];
        string Type18 = context.Request["Type18"];
        string Type19 = context.Request["Type19"];
        string Type20 = context.Request["Type20"];
        string Pro = context.Request["Pro"];
        string Remark = context.Request["Remark"];
        string TemplateQty = context.Request["TemplateQty"];
        string isAutoAssy = context.Request["isAutoAssy"] == "true" ? "Y" : "N";
        string ModelName = context.Request["ModelName"];
        string Check_Name = context.Request["Check_Name"];
        string Check_No = context.Request["Check_No"];
        string Check_Item = context.Request["Check_Item"];
        string Check_Qty = context.Request["Check_Qty"];
        string Upper = context.Request["Upper"];
        string Floor = context.Request["Floor"];
        string Unit = context.Request["Unit"];
        string Label = context.Request["Label"];
        string ProjectNo = context.Request["ProjectNo"];

        switch (funcName)
        {

            case "ShowProject":
                rtnValue = ShowProject(PdlineName, ModelName);
                break;
            case "ShowLabel":
                rtnValue = ShowLabel(Label);
                break;
            case "ShowProject1":
                rtnValue = ShowProject1(Label);
                break;

            case "ShowBuNo":
                rtnValue = ShowBuNo(user);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "ShowProcess":
                rtnValue = ShowProcess(PdlineName);
                break;
            case "ShowModel":
                rtnValue = ShowModel(PdlineName);
                break;
            //case "ShowProject":
            //    rtnValue = ShowProject(ProcessName, PdlineName, Section_Name);
            //    break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "ShowTemplateData":
                rtnValue = ShowTemplateData(ProjectNo, ProjectName, PdlineName, ModelName);
                break;
            case "GetProcess":
                rtnValue = GetProcess(ProjectNo, ModelName, type, user, datetimepicker, dataType, PdlineName, Section_Name, ProjectName);
                break;
            case "show":
                rtnValue = show(DnNo, Section_Name);
                break;
            case "UpdateTemplateInfo1L":
                rtnValue = UpdateTemplateInfoL(ProjectNo, PdlineName, ModelName, Remark, Section_Name, isAutoAssy, TemplateQty, Pro, DnNo, user, ID, Type1, Type2, Type3, Type4, Type5, Check_No, Check_Name, Check_Item, Unit, Check_Qty, Upper, Floor);
                break;
            case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo(ProjectNo, PdlineName, ModelName, Remark, Section_Name, isAutoAssy, TemplateQty, Pro, DnNo, user, ID, Type1, Type2, Type3, Type4, Type5, Check_No, Check_Name, Check_Item, Unit, Check_Qty, Upper, Floor);
                break;
            case "Save":
                rtnValue = Save(TemplateQty, Pro, DnNo, user, ID, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8, Type9, Type10, Type11, Type12, Check_No, Check_Name, Check_Item, Unit, Check_Qty, Upper, Floor);
                break;

        }
        context.Response.Write(rtnValue);
    }
    public string UpdateTemplateInfo(string ProjectNo, string PdlineName, string Model_name, string Remark, string Section_Name, string isAutoAssy, string TemplateQty, string Pro, string DN_NO, string user, string ID, string Type1, string Type2, string Type3, string Type4, string Type5, string Check_No, string Check_Name, string Check_Item, string Unit, string Check_Qty, string Upper, string Floor)
    {
        string RESULT = "OK";
        decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0; string Flag = "N"; string SQLTIME = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{Pro}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();
        decimal.TryParse(Upper, out num); if (num != 0) { MAX = double.Parse(Upper); }
        decimal.TryParse(Floor, out num1); if (num1 != 0) { MIN = double.Parse(Floor); }
        if (num == 0 && num1 != 0)
        {
            Flag = "L";
        }
        if (num != 0 && num1 == 0)
        {
            Flag = "D";
        }
        if (num == 0 && num1 == 0)
        {
            Flag = "N";
        }
        if (num != 0 && num1 != 0)
        {
            Flag = "Y";
        }
        string SQLtime = $"SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE WORK_NO='{DN_NO}' AND NUMBER_ID='{ID}'";
        DataTable checktime = PubClass.getdatatableMES(SQLtime);
        if (checktime.Rows[0]["TYPE1"].ToString() == string.Empty || checktime.Rows[0]["TYPE1"].ToString() == "/")
        {
            if (Type1 != string.Empty && Type1 != "/")
            {
                SQLTIME += ",TYPE1_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE2"].ToString() == string.Empty || checktime.Rows[0]["TYPE2"].ToString() == "/")
        {
            if (Type2 != string.Empty && Type2 != "/")
            {
                SQLTIME += ",TYPE2_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE3"].ToString() == string.Empty || checktime.Rows[0]["TYPE3"].ToString() == "/")
        {
            if (Type3 != string.Empty && Type3 != "/")
            {
                SQLTIME += ",TYPE3_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE4"].ToString() == string.Empty || checktime.Rows[0]["TYPE4"].ToString() == "/")
        {
            if (Type4 != string.Empty && Type4 != "/")
            {
                SQLTIME += ",TYPE4_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE5"].ToString() == string.Empty || checktime.Rows[0]["TYPE5"].ToString() == "/")
        {
            if (Type5 != string.Empty && Type5 != "/")
            {
                SQLTIME += ",TYPE5_TIME=SYSDATE";
            }
        }

        decimal num2 = 0; decimal num3 = 0;
        if (Type1 != "NA" && Type1 != "N/A" && Type1 != "" && Type1 != "/" && Type1 != null)
        {
            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type1.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type1.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {

                    if (Type1.Split('/')[K] == "NG")
                    {
                        RESULT = "NG";
                    }
                    if (Flag == "N") { if (Type1.Split('/')[K] == "OK" || Type1.Split('/')[K] == "NG") { if (Type1.Split('/')[K] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type1.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type1.Split('/')[K]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type1.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type1.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type1.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type1.Split('/')[K]) > MAX || Convert.ToDouble(Type1.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                }
            }
            else
            {
                if (Type1.Split('/')[0] == "NG")
                {
                    RESULT = "NG";
                }
                if (Flag == "N") { if (Type1.Split('/')[0] == "OK" || Type1.Split('/')[0] == "NG") { if (Type1.Split('/')[0] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type1.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type1.Split('/')[0]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type1.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type1.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type1.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type1.Split('/')[0]) > MAX || Convert.ToDouble(Type1.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
            }
        }

        num2 = 0; num3 = 0;
        if (Type2 != "NA" && Type2 != "N/A" && Type2 != "" && Type2 != "/" && Type2 != null)
        {
            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type2.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type2.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Type2.Split('/')[K] == "NG")
                    {
                        RESULT = "NG";
                    }
                    if (Flag == "N") { if (Type2.Split('/')[K] == "OK" || Type2.Split('/')[K] == "NG") { if (Type2.Split('/')[K] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type2.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type2.Split('/')[K]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type2.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type2.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type2.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type2.Split('/')[K]) > MAX || Convert.ToDouble(Type2.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                }
            }
            else
            {
                if (Type2.Split('/')[0] == "NG")
                {
                    RESULT = "NG";
                }
                if (Flag == "N") { if (Type2.Split('/')[0] == "OK" || Type2.Split('/')[0] == "NG") { if (Type2.Split('/')[0] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type2.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type2.Split('/')[0]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type2.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type2.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type2.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type2.Split('/')[0]) > MAX || Convert.ToDouble(Type2.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
            }
        }
        num2 = 0; num3 = 0;
        if (Type3 != "NA" && Type3 != "N/A" && Type3 != "" && Type3 != "/" && Type3 != null)
        {
            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type3.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type3.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Type3.Split('/')[K] == "NG")
                    {
                        RESULT = "NG";
                    }
                    if (Flag == "N") { if (Type3.Split('/')[K] == "OK" || Type3.Split('/')[K] == "NG") { if (Type3.Split('/')[K] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type3.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type3.Split('/')[K]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type3.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type3.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type3.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type3.Split('/')[K]) > MAX || Convert.ToDouble(Type3.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                }
            }
            else
            {
                if (Type3.Split('/')[0] == "NG")
                {
                    RESULT = "NG";
                }
                if (Flag == "N") { if (Type3.Split('/')[0] == "OK" || Type3.Split('/')[0] == "NG") { if (Type3.Split('/')[0] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type3.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type3.Split('/')[0]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type3.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type3.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type3.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type3.Split('/')[0]) > MAX || Convert.ToDouble(Type3.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
            }
        }
        num2 = 0; num3 = 0;

        if (Type4 != "NA" && Type4 != "N/A" && Type4 != "" && Type4 != "/" && Type4 != null)
        {
            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type4.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type4.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Type4.Split('/')[K] == "NG")
                    {
                        RESULT = "NG";
                    }
                    if (Flag == "N") { if (Type4.Split('/')[K] == "OK" || Type4.Split('/')[K] == "NG") { if (Type4.Split('/')[K] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type4.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type4.Split('/')[K]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type4.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type4.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type4.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type4.Split('/')[K]) > MAX || Convert.ToDouble(Type4.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                }
            }
            else
            {
                if (Type4.Split('/')[0] == "NG")
                {
                    RESULT = "NG";
                }
                if (Flag == "N") { if (Type4.Split('/')[0] == "OK" || Type4.Split('/')[0] == "NG") { if (Type4.Split('/')[0] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type4.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type4.Split('/')[0]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type4.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type4.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type4.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type4.Split('/')[0]) > MAX || Convert.ToDouble(Type4.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
            }
        }
        num2 = 0; num3 = 0;
        if (Type5 != "NA" && Type5 != "N/A" && Type5 != "" && Type5 != "/" && Type5 != null)
        {
            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type5.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type5.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Type5.Split('/')[K] == "NG")
                    {
                        RESULT = "NG";
                    }
                    if (Flag == "N") { if (Type5.Split('/')[K] == "OK" || Type5.Split('/')[K] == "NG") { if (Type5.Split('/')[K] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type5.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type5.Split('/')[K]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type5.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type5.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type5.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type5.Split('/')[K]) > MAX || Convert.ToDouble(Type5.Split('/')[K]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                }
            }
            else
            {
                if (Type5.Split('/')[0] == "NG")
                {
                    RESULT = "NG";
                }
                if (Flag == "N") { if (Type5.Split('/')[0] == "OK" || Type5.Split('/')[0] == "NG") { if (Type5.Split('/')[0] == "NG") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值为NG,请确认!\"}]"; } } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type5.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type5.Split('/')[0]) > MAX) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type5.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type5.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type5.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } if (Convert.ToDouble(Type5.Split('/')[0]) > MAX || Convert.ToDouble(Type5.Split('/')[0]) < MIN) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]"; } }
            }
        }
        if (isAutoAssy == "Y")
        {
            string Email = "";
            string SQL = $"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='2'AND STATUS='异常'";
            DataTable dt1 = PubClass.getdatatableMES(SQL);
            if (dt1.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,异常回复未维护异常收件人!\"}]";
            }
        }






        sSQL = $@"UPDATE SAJET.G_CHECK_WORK_BASE_INFO SET RESULT='{RESULT}', REMARK='{Remark}'" + SQLTIME + ",TYPE1='" + Type1 + "',TYPE2='" + Type2 + "',TYPE3='" + Type3 + "',TYPE4='" + Type4 + "',TYPE5='" + Type5 + "',UPDATE_DATE=SYSDATE,UPDATE_EMPID='" + userEmpId + "' WHERE WORK_NO='" + DN_NO + "' AND NUMBER_ID='" + ID + "'";
        PubClass.getdatatablenoreturnMES(sSQL);
        if (isAutoAssy == "Y")
        {
            string Email = "";
            string SQL = $"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='2'AND STATUS='异常'";
            DataTable dt1 = PubClass.getdatatableMES(SQL);
            if (dt1.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,异常回复未维护异常收件人!\"}]";
            }
            SQL = $"SELECT * FROM  SAJET.G_CHECK_FACA WHERE WORK_NO='{DN_NO}' AND NUMBER_ID='{ID}'";
            dt1 = PubClass.getdatatableMES(SQL);
            if (dt1.Rows.Count == 0)
            {
                string sSQL1 = $"SELECT * FROM  SAJET.SYS_EMP WHERE EMP_ID IN(SELECT EMP_ID FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE  CHECK_TYPE='2'AND STATUS='异常')AND EMAIL IS NOT NULL";
                dt1 = PubClass.getdatatableMES(sSQL1);
                if (dt1.Rows.Count > 0)
                {
                    for (int i = 0; i <= dt1.Rows.Count - 1; i++)
                    {
                        Email = Email + dt1.Rows[i]["EMAIL"].ToString() + ";";
                    }
                    Email = Email.Substring(0, Email.Length - 1);

                    sSQL = "SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO  WHERE WORK_NO='" + DN_NO + "' AND NUMBER_ID='" + ID + "'";
                    dt = PubClass.getdatatableMES(sSQL);




                    string mailMessage = $@"<!DOCTYPE html>
                                    <html>
                                    <head>
                                        <title></title>
                                        <meta charset=''utf-8''>
                                    </head>

                                    <body>
                                        <p>以下内容自动发送，请勿直接回复，谢谢。</p>
                                        <p></p>
                                        <p>";
                    string titleMessage = $@"<table border=''1'' style=''width:80%;text-align:center;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 17px;''>
                                   <tr style=''background-color:#a8cc44;color: cornsilk;''>";
                    titleMessage += $@"<td style=''width: 10%;''>单号</td><td style=''width: 10%;''>机种</td><td style=''width: 10%;''>工站项目</td><td style=''width: 10%;''>点检制程</td><td style=''width: 10%;''>事项序号</td><td style=''width: 10%;''>点检制程名称</td><td style=''width: 10%;''>检查事项</td><td style=''width: 10%;''>抽检频率</td><td style=''width: 10%;''>抽检数量</td><td style=''width: 10%;''>点检上限</td><td style=''width: 10%;''>点检下限</td>";
                    if (dt.Rows[0]["WORK_TYPE"].ToString() == "白班")
                    {
                        titleMessage += $@"<td style=''width: 10%;''>08:00-10:00</td><td style=''width: 10%;''>10:00-12:00</td><td style=''width: 10%;''>13:00-15:00</td><td style=''width: 10%;''>15:00-17:00</td><td style=''width: 10%;''>17:00-19:00</td>";
                    }
                    else
                    {
                        titleMessage += $@"<td style=''width: 10%;''>20:00-22:00</td><td style=''width: 10%;''>22:00-24:00</td><td style=''width: 10%;''>01:00-03:00</td><td style=''width: 10%;''>03:00-05:00</td><td style=''width: 10%;''>05:00-07:00</td>";

                    }
                    titleMessage += "</tr>";

                    string detailMessage = $@"";
                    sSQL = "SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE  WORK_NO='" + DN_NO + "' AND NUMBER_ID='" + ID + "'";
                    dt = PubClass.getdatatableMES(sSQL);
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        detailMessage += $@"<tr style=''font-size:13px;''>";
                        detailMessage += $@"<td>{dt.Rows[0]["WORK_NO"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["MODEL_NAME"].ToString()}</td>";

                        detailMessage += $@"<td>{dt.Rows[0]["PROJECT_NO"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["PROJECT_NAME"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["CHECK_NO"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["CHECK_NAME"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["CHECK_ITEM"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["FREQUENCY"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["CHECK_QTY"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["UPPER"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["FLOOR"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["TYPE1"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["TYPE2"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["TYPE3"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["TYPE4"].ToString()}</td>";
                        detailMessage += $@"<td>{dt.Rows[0]["TYPE5"].ToString()}</td>";
                        detailMessage += $@"</tr>";
                    }

                    string endMessage = $@"</table>
                                    </ p >
                            </body>

                            </html> ";

                    mailMessage = mailMessage + titleMessage + detailMessage + endMessage;
                    string SUBJECT = DN_NO + "单号异常,存在须填写FACA项目，请及时填写";
                    sSQL = "SELECT NVL(MAX(ID),0)+1 FROM SAJET.G_MAIL_CONTENT";
                    dt = PubClass.getdatatableMES(sSQL);
                    sSQL = "INSERT INTO SAJET.G_MAIL_CONTENT(ID,MAILFROM,MAILTO,CC,SUBJECT,BODY,INSERTTIME,INSERTUSER)VALUES('" + dt.Rows[0][0].ToString() + "','KS-BU17.MES@luxshare-ict.com','" + Email + "','Wenjian.Ma@luxshare-ict.com','" + SUBJECT + "','" + mailMessage + "',SYSDATE,'')";
                    PubClass.getdatatablenoreturnMES(sSQL);
                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,异常回复未维护异常收件人邮箱!\"}]";
                }
                sSQL = $@"INSERT INTO  SAJET.G_CHECK_FACA(MODEL,WORK_NO,NUMBER_ID,CREATE_DATE,CREATE_USERID,ENABLED)VALUES('{Model_name}','{DN_NO}','{ID}',SYSDATE,'{userEmpId}','Y')";
                PubClass.getdatatablenoreturnMES(sSQL);
            }
        }

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,点检成功!\"}]";
    }
    public string UpdateTemplateInfoL(string ProjectNo, string PdlineName, string ModelName, string Remark, string Section_Name, string isAutoAssy, string TemplateQty, string Pro, string DN_NO, string user, string ID, string Type1, string Type2, string Type3, string Type4, string Type5, string Check_No, string Check_Name, string Check_Item, string Unit, string Check_Qty, string Upper, string Floor)
    {
        decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0; string Flag = "N"; string SQLTIME = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{Pro}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();
        decimal.TryParse(Upper, out num); if (num != 0) { MAX = double.Parse(Upper); }
        decimal.TryParse(Floor, out num1); if (num1 != 0) { MIN = double.Parse(Floor); }
        if (num == 0 && num1 != 0)
        {
            Flag = "L";
        }
        if (num != 0 && num1 == 0)
        {
            Flag = "D";
        }
        if (num == 0 && num1 == 0)
        {
            Flag = "N";
        }
        if (num != 0 && num1 != 0)
        {
            Flag = "Y";
        }
        string SQLtime = $"SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE WORK_NO='{DN_NO}' AND NUMBER_ID='{ID}'";
        DataTable checktime = PubClass.getdatatableMES(SQLtime);
        if (checktime.Rows[0]["TYPE1"].ToString() == string.Empty || checktime.Rows[0]["TYPE1"].ToString() == "/")
        {
            if (Type1 != string.Empty && Type1 != "/")
            {
                SQLTIME += ",TYPE1_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE2"].ToString() == string.Empty || checktime.Rows[0]["TYPE2"].ToString() == "/")
        {
            if (Type2 != string.Empty && Type2 != "/")
            {
                SQLTIME += ",TYPE2_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE3"].ToString() == string.Empty || checktime.Rows[0]["TYPE3"].ToString() == "/")
        {
            if (Type3 != string.Empty && Type3 != "/")
            {
                SQLTIME += ",TYPE3_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE4"].ToString() == string.Empty || checktime.Rows[0]["TYPE4"].ToString() == "/")
        {
            if (Type4 != string.Empty && Type4 != "/")
            {
                SQLTIME += ",TYPE4_TIME=SYSDATE";
            }
        }
        if (checktime.Rows[0]["TYPE5"].ToString() == string.Empty || checktime.Rows[0]["TYPE5"].ToString() == "/")
        {
            if (Type5 != string.Empty && Type5 != "/")
            {
                SQLTIME += ",TYPE5_TIME=SYSDATE";
            }
        }
        decimal num2 = 0; decimal num3 = 0;
        if (Type1 != "NA" && Type1 != "N/A" && Type1 != "" && Type1 != "/" && Type1 != null)
        {
            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type1.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type1.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Flag == "N") { if (Type1.Split('/')[K] == "OK" || Type1.Split('/')[K] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type1.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type1.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type1.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                }
            }
            else
            {
                if (Flag == "N") { if (Type1.Split('/')[0] == "OK" || Type1.Split('/')[0] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type1.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type1.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type1.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
            }
        }

        num2 = 0; num3 = 0;
        if (Type2 != "NA" && Type2 != "N/A" && Type2 != "" && Type2 != "/" && Type2 != null)
        {

            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type2.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type2.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Flag == "N") { if (Type2.Split('/')[K] == "OK" || Type2.Split('/')[K] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type2.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type2.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type2.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                }
            }
            else
            {
                if (Flag == "N") { if (Type2.Split('/')[0] == "OK" || Type1.Split('/')[0] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type2.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type2.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type2.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
            }
        }
        num2 = 0; num3 = 0;
        if (Type3 != "NA" && Type3 != "N/A" && Type3 != "" && Type3 != "/" && Type3 != null)
        {

            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type3.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type3.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Flag == "N") { if (Type3.Split('/')[K] == "OK" || Type3.Split('/')[K] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type3.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type3.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type3.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                }
            }
            else
            {
                if (Flag == "N") { if (Type3.Split('/')[0] == "OK" || Type3.Split('/')[0] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type3.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type3.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type3.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
            }
        }
        num2 = 0; num3 = 0;

        if (Type4 != "NA" && Type4 != "N/A" && Type4 != "" && Type4 != "/" && Type4 != null)
        {

            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type4.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type4.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Flag == "N") { if (Type4.Split('/')[K] == "OK" || Type4.Split('/')[K] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type4.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type4.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type4.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                }
            }
            else
            {
                if (Flag == "N") { if (Type4.Split('/')[0] == "OK" || Type4.Split('/')[0] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type4.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type4.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type4.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
            }
        }
        num2 = 0; num3 = 0;
        if (Type5 != "NA" && Type5 != "N/A" && Type5 != "" && Type5 != "/" && Type5 != null)
        {
            decimal.TryParse(Check_Qty, out num3);
            if (num3 != 0)
            {
                if (!Type5.Contains('/'))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                if (Type5.Split('/').Length != int.Parse(Check_Qty))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值未用/隔开!\"}]";
                }
                for (int K = 0; K <= int.Parse(Check_Qty) - 1; K++)
                {
                    if (Flag == "N") { if (Type5.Split('/')[K] == "OK" || Type5.Split('/')[K] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                    if (Flag == "D") { decimal.TryParse(Type5.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "L") { decimal.TryParse(Type5.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                    if (Flag == "Y") { decimal.TryParse(Type5.Split('/')[K], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                }
            }
            else
            {
                if (Flag == "N") { if (Type5.Split('/')[0] == "OK" || Type5.Split('/')[0] == "NG") { } else { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]"; } }
                if (Flag == "D") { decimal.TryParse(Type5.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "L") { decimal.TryParse(Type5.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
                if (Flag == "Y") { decimal.TryParse(Type5.Split('/')[0], out num2); if (num2 == 0) { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]"; } }
            }
        }
        string Email = "";

        string SQL = $"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='2'AND STATUS='异常'";
        DataTable dt1 = PubClass.getdatatableMES(SQL);
        if (dt1.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,异常回复未维护异常收件人!\"}]";
        }


        sSQL = "UPDATE SAJET.G_CHECK_WORK_BASE_INFO SET  RESULT='NG',REMARK='" + Remark + "'" + SQLTIME + ",TYPE1='" + Type1 + "',TYPE2='" + Type2 + "',TYPE3='" + Type3 + "',TYPE4='" + Type4 + "',TYPE5='" + Type5 + "',UPDATE_DATE=SYSDATE,UPDATE_EMPID='" + userEmpId + "' WHERE WORK_NO='" + DN_NO + "' AND NUMBER_ID='" + ID + "'";
        PubClass.getdatatablenoreturnMES(sSQL);

        SQL = $"SELECT * FROM  SAJET.G_CHECK_FACA WHERE WORK_NO='{DN_NO}' AND NUMBER_ID='{ID}'";
        dt1 = PubClass.getdatatableMES(SQL);
        if (dt1.Rows.Count == 0)
        {
            string sSQL1 = $"SELECT * FROM  SAJET.SYS_EMP WHERE EMP_ID IN(SELECT EMP_ID FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE  CHECK_TYPE='2'AND STATUS='异常')AND EMAIL IS NOT NULL";
            dt1 = PubClass.getdatatableMES(sSQL1);
            if (dt1.Rows.Count > 0)
            {
                for (int i = 0; i <= dt1.Rows.Count - 1; i++)
                {
                    Email = Email + dt1.Rows[i]["EMAIL"].ToString() + ";";
                }
                Email = Email.Substring(0, Email.Length - 1);

                sSQL = "SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO  WHERE WORK_NO='" + DN_NO + "' AND NUMBER_ID='" + ID + "'";
                dt = PubClass.getdatatableMES(sSQL);




                string mailMessage = $@"<!DOCTYPE html>
                                    <html>
                                    <head>
                                        <title></title>
                                        <meta charset=''utf-8''>
                                    </head>

                                    <body>
                                        <p>以下内容自动发送，请勿直接回复，谢谢。</p>
                                        <p></p>
                                        <p>";
                string titleMessage = $@"<table border=''1'' style=''width:80%;text-align:center;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 17px;''>
                                   <tr style=''background-color:#a8cc44;color: cornsilk;''>";
                titleMessage += $@"<td style=''width: 10%;''>单号</td><td style=''width: 10%;''>机种</td><td style=''width: 10%;''>工站项目</td><td style=''width: 10%;''>点检制程</td><td style=''width: 10%;''>事项序号</td><td style=''width: 10%;''>点检制程名称</td><td style=''width: 10%;''>检查事项</td><td style=''width: 10%;''>抽检频率</td><td style=''width: 10%;''>抽检数量</td><td style=''width: 10%;''>点检上限</td><td style=''width: 10%;''>点检下限</td>";
                if (dt.Rows[0]["WORK_TYPE"].ToString() == "白班")
                {
                    titleMessage += $@"<td style=''width: 10%;''>08:00-10:00</td><td style=''width: 10%;''>10:00-12:00</td><td style=''width: 10%;''>13:00-15:00</td><td style=''width: 10%;''>15:00-17:00</td><td style=''width: 10%;''>17:00-19:00</td>";
                }
                else
                {
                    titleMessage += $@"<td style=''width: 10%;''>20:00-22:00</td><td style=''width: 10%;''>22:00-24:00</td><td style=''width: 10%;''>01:00-03:00</td><td style=''width: 10%;''>03:00-05:00</td><td style=''width: 10%;''>05:00-07:00</td>";

                }
                titleMessage += "</tr>";

                string detailMessage = $@"";
                sSQL = "SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE  WORK_NO='" + DN_NO + "' AND NUMBER_ID='" + ID + "'";
                dt = PubClass.getdatatableMES(sSQL);
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    detailMessage += $@"<tr style=''font-size:13px;''>";
                    detailMessage += $@"<td>{dt.Rows[0]["WORK_NO"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["MODEL_NAME"].ToString()}</td>";

                    detailMessage += $@"<td>{dt.Rows[0]["PROJECT_NO"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["PROJECT_NAME"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["CHECK_NO"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["CHECK_NAME"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["CHECK_ITEM"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["FREQUENCY"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["CHECK_QTY"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["UPPER"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["FLOOR"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["TYPE1"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["TYPE2"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["TYPE3"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["TYPE4"].ToString()}</td>";
                    detailMessage += $@"<td>{dt.Rows[0]["TYPE5"].ToString()}</td>";
                    detailMessage += $@"</tr>";
                }

                string endMessage = $@"</table>
                                    </ p >
                            </body>

                            </html> ";

                mailMessage = mailMessage + titleMessage + detailMessage + endMessage;
                string SUBJECT = DN_NO + "单号异常,存在须填写FACA项目，请及时填写";
                sSQL = "SELECT NVL(MAX(ID),0)+1 FROM SAJET.G_MAIL_CONTENT";
                dt = PubClass.getdatatableMES(sSQL);
                sSQL = "INSERT INTO SAJET.G_MAIL_CONTENT(ID,MAILFROM,MAILTO,CC,SUBJECT,BODY,INSERTTIME,INSERTUSER)VALUES('" + dt.Rows[0][0].ToString() + "','KS-BU17.MES@luxshare-ict.com','" + Email + "','Wenjian.Ma@luxshare-ict.com','" + SUBJECT + "','" + mailMessage + "',SYSDATE,'')";
                PubClass.getdatatablenoreturnMES(sSQL);
            }
            else
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,异常回复未维护异常收件人邮箱!\"}]";
            }
            sSQL = $@"INSERT INTO  SAJET.G_CHECK_FACA(MODEL,WORK_NO,NUMBER_ID,CREATE_DATE,CREATE_USERID,ENABLED)VALUES('{ModelName}','{DN_NO}','{ID}',SYSDATE,'{userEmpId}','Y')";
            PubClass.getdatatablenoreturnMES(sSQL);
        }
        //sSQL = $@"INSERT INTO SAJET.G_CHECK_WORK_BASE_INFO_HT SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE WORK_NO='{DN_NO}' AND NUMBER_ID='{ID}'";
        //PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,点检成功!\"}]";
    }


    public string ShowLabel(string Label)
    {
        if (!Label.Contains("|"))
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,线体机种制程请用|区分!\"}]";
        }
        string[] LabelName = Label.Split('|');
        if (LabelName.Length != 3)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,刷入条码根据|区分不为三条数据!\"}]";
        }
        string PDLINE_NAME = LabelName[0];
        string MODEL_NAME = LabelName[1];
        string PROJECT_NO = LabelName[2];
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME='{PDLINE_NAME}' AND PDLINE_NAME IN(SELECT DISTINCT PDLINE_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE ) ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此线体未在配置中维护\"}]";
        }
        sSQL = $@"SELECT * FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PDLINE_NAME='{PDLINE_NAME}' AND MODEL_NAME='{MODEL_NAME}' AND PROJECT_NO='{PROJECT_NO}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"线体加机种未绑定点检制程事项\"}]";
        }
        Label = PDLINE_NAME + "|" + MODEL_NAME + "|" + PROJECT_NO + "|" + dt.Rows[0]["PROJECT_NAME"].ToString();

        //return JsonConvert.SerializeObject(dt);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + Label + "\"}]";
    }


    public string ShowProject1(string Label)
    {

        string[] LabelName = Label.Split('|');

        string PDLINE_NAME = LabelName[0];
        string MODEL_NAME = LabelName[1];
        string sSQL = $@"SELECT DISTINCT PROJECT_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PDLINE_NAME='{PDLINE_NAME}' AND MODEL_NAME='{MODEL_NAME}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);



        return JsonConvert.SerializeObject(dt);

    }
    public string ShowProject(string PdlineName, string ModelName)
    {
        string sSQL = $@"SELECT DISTINCT PROJECT_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }



    public string ShowModel(string PdlineName)
    {
        string sSQL = $@"SELECT DISTINCT MODEL_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PDLINE_NAME='{PdlineName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string Save(string TemplateQty, string Pro, string DN_NO, string user, string ID, string Type1, string Type2, string Type3, string Type4, string Type5, string Type6, string Type7, string Type8, string Type9, string Type10, string Type11, string Type12, string Check_No, string Check_Name, string Check_Item, string Unit, string Check_Qty, string Upper, string Floor)
    {
        decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0; string Flag = "N";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{Pro}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();


        for (int L = 0; L <= int.Parse(TemplateQty); L++)
        {
            decimal num2 = 0;
            if (L == 1)
            {
                if (Type1 == "" || Type1 == "N/A" || Type1 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 2)
            {
                if (Type2 == "" || Type2 == "N/A" || Type2 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 3)
            {
                if (Type3 == "" || Type3 == "N/A" || Type3 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 4)
            {
                if (Type4 == "" || Type4 == "N/A" || Type4 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 5)
            {
                if (Type5 == "" || Type5 == "N/A" || Type5 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 6)
            {
                if (Type6 == "" || Type6 == "N/A" || Type6 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 7)
            {
                if (Type7 == "" || Type7 == "N/A" || Type7 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 8)
            {
                if (Type8 == "" || Type8 == "N/A" || Type8 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 9)
            {
                if (Type9 == "" || Type9 == "N/A" || Type9 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 10)
            {
                if (Type10 == "" || Type10 == "N/A" || Type10 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 11)
            {
                if (Type11 == "" || Type11 == "N/A" || Type11 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }
            if (L == 12)
            {
                if (Type12 == "" || Type12 == "N/A" || Type12 == "NA") { return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,未填写完整，不允许提交!\"}]"; }
                continue;
            }

        }
        sSQL = $@"UPDATE SAJET.G_CHECK_WORK_BASE_INFO SET SAVE_DATE=SYSDATE,SAVE_EMPID='{userEmpId}',ENABLED='N' WHERE WORK_NO='{DN_NO}' AND NUMBER_ID='{ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,提交成功!\"}]";
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
            MyProperty.From = new MailAddress("KS-BU17.MES@luxshare-ict.com", "");// "KS-BU17.MES@luxshare-ict.com"
            Smtp.Credentials = new System.Net.NetworkCredential("KS-BU17.MES@luxshare-ict.com", "Luxsh@re,20723");//("KS-BU17.MES@luxshare-ict.com", "Luxsh@re,20723");
            MyProperty.Subject = subject;
            MyProperty.SubjectEncoding = Encoding.UTF8;
            MyProperty.IsBodyHtml = true;//是否为HTML
                                         //MyProperty.Body = body + "(平台地址:http://10.32.15.59:9001/)"; //邮件内容


            MyProperty.Body = senderName + body + "(链接地址:http://10.32.15.59:8003/)";
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
            SendEmail();
        }
        finally
        {
            this.MyProperty.Dispose();
            //this.Smtp.Dispose(); 
        }
    }
    public string GetProcess(string ProjectNo, string ModelName, string type, string user, string datetimepicker, string dataType, string PdlineName, string Section_Name, string ProjectName)
    {
        string WORK_NO = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查\"}]";

        }
        string SQL = $"SELECT * FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{Section_Name}'AND STATUS ='{type}'";
        DataTable dt = PubClass.getdatatableMES(SQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员所在部门无" + type + "权限\"}]";
        }
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此点检制程不存在\"}]";
        }
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();

        SQL = $"SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE WORK_DATE='{datetimepicker}'  AND PROJECT_NAME='{ProjectName}'AND WORK_TYPE='{dataType}'AND PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROJECT_NO='{ProjectNo}'";
        dt = PubClass.getdatatableMES(SQL);
        if (dt.Rows.Count == 0)
        {

            WORK_NO = "DJ" + DateTime.Now.ToString("yyyy-MM-dd-HHssffff");
            SQL = $@"SELECT * FROM  SAJET.SYS_ECHECK_PROJECT_BASE  WHERE  PROJECT_ID='{PROJECT_ID}'";
            dt = PubClass.getdatatableMES(SQL);
            if (dt.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此标题未维护点检事项\"}]";
            }
            //SQL = $"INSERT INTO SAJET.G_CHECK_WORK_BASE(WORK_NO,WORK_DATE,WORK_TYPE,PDLINE_NAME,PROJECT_NAME,ENABLED,CREATE_USERID,CREATE_DATE,MODEL_NAME,PROJECT_NO)" +
            // $"VALUES('{WORK_NO}','{datetimepicker}','{dataType}','{PdlineName}','{ProjectName}','Y','{userEmpId}',SYSDATE,'{ModelName}','{ProjectNo}')";
            //PubClass.getdatatablenoreturnMES(SQL);

            SQL = $"SELECT* FROM SAJET.SYS_ECHECK_PROJECT_BASE WHERE PROJECT_ID='{PROJECT_ID}'";
            dt = PubClass.getdatatableMES(SQL);
            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                string UNIT = ""; string CHECK_QTY = ""; string UPPER = ""; string FLOOR = ""; string FREQUENCY = "";
                string NUMBER_ID = dt.Rows[i]["NUMBER_ID"].ToString();
                string CHECK_NO = dt.Rows[i]["CHECK_NO"].ToString();
                string CHECK_NAME = dt.Rows[i]["CHECK_NAME"].ToString();
                string CHECK_ITEM = dt.Rows[i]["CHECK_ITEM"].ToString();
                string SECTION_NAME = dt.Rows[i]["SECTION_NAME"].ToString();
                SQL = $"SELECT* FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_ID='{PROJECT_ID}'  AND PDLINE_NAME='{PdlineName}' AND CHECK_NAME='{CHECK_NAME}' AND CHECK_ITEM='{CHECK_ITEM}' AND MODEL_NAME='{ModelName}'AND CHECK_NO='{CHECK_NO}' AND PROJECT_NO='{ProjectNo}'";
                DataTable dt1 = PubClass.getdatatableMES(SQL);
                if (dt1.Rows.Count > 0)
                {
                    UNIT = dt1.Rows[0]["UNIT"].ToString();
                    CHECK_QTY = dt1.Rows[0]["CHECK_QTY"].ToString();
                    UPPER = dt1.Rows[0]["UPPER"].ToString();
                    FLOOR = dt1.Rows[0]["FLOOR"].ToString();
                    FREQUENCY = dt1.Rows[0]["FREQUENCY"].ToString();
                    if (FREQUENCY == "2")
                    {
                        SQL = $"INSERT INTO SAJET.G_CHECK_WORK_BASE_INFO(WORK_DATE,WORK_TYPE,SECTION_NAME,WORK_NO,PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CHECK_QTY,UPPER,FLOOR,NUMBER_ID,MODEL_NAME,ENABLED,CREATE_DATE,CREATE_EMPID,CHECK_NO,PROJECT_NO)" +
                             $"SELECT '{datetimepicker}','{dataType}','{SECTION_NAME}','{WORK_NO}','{PROJECT_ID}','{ProjectName}','{PdlineName}','{FREQUENCY}','{CHECK_NAME}','{CHECK_ITEM}','{UNIT}','{CHECK_QTY}','{UPPER}','{FLOOR}','{NUMBER_ID}','{ModelName}','Y',SYSDATE,'{userEmpId}','{CHECK_NO}','{ProjectNo}' FROM DUAL";
                        PubClass.getdatatablenoreturnMES(SQL);
                    }
                    if (FREQUENCY == "4")
                    {
                        SQL = $"INSERT INTO SAJET.G_CHECK_WORK_BASE_INFO(WORK_DATE,WORK_TYPE,SECTION_NAME,WORK_NO,PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CHECK_QTY,UPPER,FLOOR,NUMBER_ID,MODEL_NAME,ENABLED,CREATE_DATE,CREATE_EMPID,CHECK_NO,PROJECT_NO,TYPE2,TYPE4)" +
                             $"SELECT '{datetimepicker}','{dataType}','{SECTION_NAME}','{WORK_NO}','{PROJECT_ID}','{ProjectName}','{PdlineName}','{FREQUENCY}','{CHECK_NAME}','{CHECK_ITEM}','{UNIT}','{CHECK_QTY}','{UPPER}','{FLOOR}','{NUMBER_ID}','{ModelName}','Y',SYSDATE,'{userEmpId}','{CHECK_NO}','{ProjectNo}','/','/' FROM DUAL";
                        PubClass.getdatatablenoreturnMES(SQL);
                    }
                    if (FREQUENCY == "12")
                    {
                        SQL = $"INSERT INTO SAJET.G_CHECK_WORK_BASE_INFO(WORK_DATE,WORK_TYPE,SECTION_NAME,WORK_NO,PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CHECK_QTY,UPPER,FLOOR,NUMBER_ID,MODEL_NAME,ENABLED,CREATE_DATE,CREATE_EMPID,CHECK_NO,PROJECT_NO,TYPE2,TYPE3,TYPE4,TYPE5)" +
                             $"SELECT '{datetimepicker}','{dataType}','{SECTION_NAME}','{WORK_NO}','{PROJECT_ID}','{ProjectName}','{PdlineName}','{FREQUENCY}','{CHECK_NAME}','{CHECK_ITEM}','{UNIT}','{CHECK_QTY}','{UPPER}','{FLOOR}','{NUMBER_ID}','{ModelName}','Y',SYSDATE,'{userEmpId}','{CHECK_NO}','{ProjectNo}','/','/','/','/' FROM DUAL";
                        PubClass.getdatatablenoreturnMES(SQL);
                    }
                }
            }
        }
        else
        {

            WORK_NO = dt.Rows[0]["WORK_NO"].ToString();
            SQL = $@"SELECT * FROM  SAJET.SYS_ECHECK_PROJECT_BASE  WHERE  PROJECT_ID='{PROJECT_ID}'";
            dt = PubClass.getdatatableMES(SQL);
            if (dt.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此标题未维护点检事项\"}]";
            }

            SQL = $"SELECT* FROM SAJET.SYS_ECHECK_PROJECT_BASE WHERE PROJECT_ID='{PROJECT_ID}' ";
            dt = PubClass.getdatatableMES(SQL);
            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                string UNIT = ""; string CHECK_QTY = ""; string UPPER = ""; string FLOOR = ""; string FREQUENCY = "";
                string NUMBER_ID = dt.Rows[i]["NUMBER_ID"].ToString();
                string CHECK_NO = dt.Rows[i]["CHECK_NO"].ToString();
                string CHECK_NAME = dt.Rows[i]["CHECK_NAME"].ToString();
                string CHECK_ITEM = dt.Rows[i]["CHECK_ITEM"].ToString();
                string SECTION_NAME = dt.Rows[i]["SECTION_NAME"].ToString();
                SQL = $"SELECT* FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_ID='{PROJECT_ID}'  AND PDLINE_NAME='{PdlineName}' AND CHECK_NAME='{CHECK_NAME}' AND CHECK_ITEM='{CHECK_ITEM}' AND MODEL_NAME='{ModelName}'AND PROJECT_NO='{ProjectNo}'";
                DataTable dt1 = PubClass.getdatatableMES(SQL);
                if (dt1.Rows.Count > 0)
                {
                    UNIT = dt1.Rows[0]["UNIT"].ToString();
                    CHECK_QTY = dt1.Rows[0]["CHECK_QTY"].ToString();
                    UPPER = dt1.Rows[0]["UPPER"].ToString();
                    FLOOR = dt1.Rows[0]["FLOOR"].ToString();
                    FREQUENCY = dt1.Rows[0]["FREQUENCY"].ToString();
                    SQL = $"SELECT* FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE WORK_NO='{WORK_NO}'  AND NUMBER_ID='{NUMBER_ID}'AND PROJECT_NO='{ProjectNo}'";
                    dt1 = PubClass.getdatatableMES(SQL);
                    if (dt1.Rows.Count == 0)
                    {
                        if (FREQUENCY == "2")
                        {
                            SQL = $"INSERT INTO SAJET.G_CHECK_WORK_BASE_INFO(WORK_DATE,WORK_TYPE,SECTION_NAME,WORK_NO,PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CHECK_QTY,UPPER,FLOOR,NUMBER_ID,MODEL_NAME,ENABLED,CREATE_DATE,CREATE_EMPID,CHECK_NO,PROJECT_NO)" +
                                 $"SELECT '{datetimepicker}','{dataType}','{SECTION_NAME}','{WORK_NO}','{PROJECT_ID}','{ProjectName}','{PdlineName}','{FREQUENCY}','{CHECK_NAME}','{CHECK_ITEM}','{UNIT}','{CHECK_QTY}','{UPPER}','{FLOOR}','{NUMBER_ID}','{ModelName}','Y',SYSDATE,'{userEmpId}','{CHECK_NO}','{ProjectNo}' FROM DUAL";
                            PubClass.getdatatablenoreturnMES(SQL);
                        }
                        if (FREQUENCY == "4")
                        {
                            SQL = $"INSERT INTO SAJET.G_CHECK_WORK_BASE_INFO(WORK_DATE,WORK_TYPE,SECTION_NAME,WORK_NO,PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CHECK_QTY,UPPER,FLOOR,NUMBER_ID,MODEL_NAME,ENABLED,CREATE_DATE,CREATE_EMPID,CHECK_NO,PROJECT_NO,TYPE2,TYPE4)" +
                                 $"SELECT '{datetimepicker}','{dataType}','{SECTION_NAME}','{WORK_NO}','{PROJECT_ID}','{ProjectName}','{PdlineName}','{FREQUENCY}','{CHECK_NAME}','{CHECK_ITEM}','{UNIT}','{CHECK_QTY}','{UPPER}','{FLOOR}','{NUMBER_ID}','{ModelName}','Y',SYSDATE,'{userEmpId}','{CHECK_NO}','{ProjectNo}','/','/' FROM DUAL";
                            PubClass.getdatatablenoreturnMES(SQL);
                        }
                        if (FREQUENCY == "12")
                        {
                            SQL = $"INSERT INTO SAJET.G_CHECK_WORK_BASE_INFO(WORK_DATE,WORK_TYPE,SECTION_NAME,WORK_NO,PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CHECK_QTY,UPPER,FLOOR,NUMBER_ID,MODEL_NAME,ENABLED,CREATE_DATE,CREATE_EMPID,CHECK_NO,PROJECT_NO,TYPE2,TYPE3,TYPE4,TYPE5)" +
                                 $"SELECT '{datetimepicker}','{dataType}','{SECTION_NAME}','{WORK_NO}','{PROJECT_ID}','{ProjectName}','{PdlineName}','{FREQUENCY}','{CHECK_NAME}','{CHECK_ITEM}','{UNIT}','{CHECK_QTY}','{UPPER}','{FLOOR}','{NUMBER_ID}','{ModelName}','Y',SYSDATE,'{userEmpId}','{CHECK_NO}','{ProjectNo}','/','/','/','/' FROM DUAL";
                            PubClass.getdatatablenoreturnMES(SQL);
                        }
                    }
                }
            }
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + WORK_NO + "\"}]";
    }
    public string show(string DN_NO, string Section_Name)
    {
        string SQL = $"SELECT * FROM SAJET.G_CHECK_WORK_BASE_INFO WHERE WORK_NO='{DN_NO}' AND SECTION_NAME IN('ALL','{Section_Name}')AND  ENABLED='Y' ORDER BY CHECK_NO";
        DataTable dt = PubClass.getdatatableMES(SQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowBuNo(string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查\"}]";

        }
        string sSQL = $@"SELECT SECTON_NAME,STATUS FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE   EMP_ID='{userEmpId}'AND CHECK_TYPE='2' ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此人员未维护部门信息,请检查\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\",\"ERR_SN\":\"" + dt.Rows[0][1].ToString() + "\"}]";
    }
    public string ShowTemplateData(string ProjectNo, string ProjectName, string PdlineName, string ModelName)
    {
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,制程名称不存在!\"}]";
        }
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();

        sSQL = $@"SELECT DISTINCT FREQUENCY FROM   SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_NAME='{ProjectName}'AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}'AND PROJECT_NO='{ProjectNo}'";
        dt = PubClass.getdatatableMES(sSQL);

        sSQL = $@"SELECT CHECK_TIME FROM  SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{PROJECT_ID}' AND  FREQUENCY='{dt.Rows[0][0].ToString()}'ORDER BY SEQ";
        dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);

    }
    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT DISTINCT PDLINE_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE ) ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'AND PDLINE_NAME IN(SELECT DISTINCT PDLINE_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE )  AND PDLINE_NAME LIKE'" + JJ + "%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_CHECK_TEMPLATE_CONFIG  ORDER BY  TEMPLATE";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowProcess(string PdlineName)
    {
        string SSQL = "SELECT DISTINCT B.PROCESS_NAME FROM SAJET.SYS_TERMINAL A ,SAJET.SYS_PROCESS B,SAJET.SYS_PDLINE C WHERE C.PDLINE_NAME = '" + PdlineName + "'AND A.PROCESS_ID = B.PROCESS_ID AND A.PDLINE_ID=C.PDLINE_ID ";
        DataTable dt = PubClass.getdatatableMES(SSQL);
        return JsonConvert.SerializeObject(dt);
    }
    //public string ShowProject(string ProcessName, string PdlineName, string Section_Name, string Template)
    //{
    //    string SSQL = $"SELECT PROJECT_NAME FROM SAJET.SYS_TEMPLATE_CONFIG WHERE TEMPLATE='{Template}'ORDER BY SEQ";
    //    DataTable dt = PubClass.getdatatableMES(SSQL);
    //    return JsonConvert.SerializeObject(dt);
    //}
    public string GetDate()
    {
        string TIME; string DATE;
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD'),TO_CHAR(SYSDATE,'HH24'),TO_CHAR(SYSDATE-1,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (int.Parse(dt.Rows[0][1].ToString()) >= 08 && int.Parse(dt.Rows[0][1].ToString()) < 20)
        {
            TIME = "白班";
            DATE = dt.Rows[0][0].ToString();

        }
        else
        {
            TIME = "夜班";
            DATE = dt.Rows[0][2].ToString();
        }
        return "[{\"ERR_CODE\":\"" + TIME + "\",\"ERR_MSG\":\"" + DATE + "\",\"ERR_TIME\":\"" + dt.Rows[0][1].ToString() + "\"}]";
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