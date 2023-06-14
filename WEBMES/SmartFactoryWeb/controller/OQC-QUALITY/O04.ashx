<%@ WebHandler Language="C#" Class="O20" %>
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
public class O20 : IHttpHandler
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
        string REMARK = context.Request["REMARK"];
        string JJ = context.Request["JJ"];
        string isAutoAssy = context.Request["isAutoAssy"] == "true" ? "Y" : "N";
        switch (funcName)
        {
            case "excel":
                rtnValue = uploadFile(DN_NO, user, context);
                break;
            case "GetDate1":
                rtnValue = GetDate1();
                break;
            case "GetTitle":
                rtnValue = GetTitle(DN_NO);
                break;
            case "GetTitleNO":
                rtnValue = GetTitleNO(DN_NO);
                break;
            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowDnno":
                rtnValue = ShowDnno(Template, user, PdlineName, datetimepicker, dataType);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            //case "GetProcess":
            //    rtnValue = GetProcess(PdlineName);
            //    break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "show":
                rtnValue = show(Template, DN_NO, datetimepicker, dataType);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(Template, user, PdlineName, datetimepicker, dataType);
                break;
            case "GetQTY":
                rtnValue = GetQTY(Template);
                break;
            case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(DN_NO, REMARK, user, ID, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8, Type9, Type10, Type11, Type12, Type13, Type14, Type15, Type16, Type17, Type18, Type19, Type20, isAutoAssy);
                break;
            case "UpdateTemplateInfo11":
                rtnValue = UpdateTemplateInfo11(DN_NO, REMARK, user, ID, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8, Type9, Type10, Type11, Type12, Type13, Type14, Type15, Type16, Type17, Type18, Type19, Type20, isAutoAssy);
                break;
            case "GetLabel":
                rtnValue = GetLabel(DN_NO);
                break;
            case "GetDnnoType":
                rtnValue = GetDnnoType(DN_NO);
                break;
            case "Commit":
                rtnValue = Commit(DN_NO, user);
                break;


        }
        context.Response.Write(rtnValue);
    }
    private static string uploadFile(string DN_NO, string user, HttpContext context)
    {
        try
        {
            string Flag = "";
            string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

            DataTable dt = PubClass.getdatatableMES(sSQL);
            string userEmpId = dt.Rows[0][0].ToString();
            sSQL = $@"SELECT * FROM SAJET.G_ECHECK_BASE WHERE DN_NO ='{DN_NO}'";
            dt = PubClass.getdatatableMES(sSQL);
            if (dt.Rows.Count == 0)
            {
                return "NG,此单号不存在!";
            }
            string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
            DataTable dt1 = PubClass.getdatatableMES(sSQL1);
            string TEMPLATE = dt1.Rows[0]["TEMPLATE"].ToString();
            sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE='点检人权限'";
            dt1 = PubClass.getdatatableMES(sSQL1);
            if (dt1.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有点检权限\"}]";
            }
            sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE NUMBER_ID IN(SELECT NUMBER_ID FROM SAJET.G_ECHECK_BASE WHERE DN_NO ='{DN_NO}')";
            dt = PubClass.getdatatableMES(sSQL);
            if (dt.Rows.Count == 0)
            {
                return "NG,此模板未维护标题!";
            }
            int qty = dt.Rows.Count;
            if (context.Request.Files.Count > 0)
            {
                string filePath = context.Server.MapPath("../Data/");
                //如不存在,则创建对应文件夹
                if (!System.IO.Directory.Exists(filePath))
                {
                    System.IO.Directory.CreateDirectory(filePath);
                }
                HttpFileCollection files = context.Request.Files;
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    string fname = filePath + file.FileName;
                    file.SaveAs(fname);

                    FileStream fileStream = new FileStream(fname, FileMode.Open);
                    Workbook workbook = Workbook.Load(fileStream);
                    Worksheet worksheet = workbook.Worksheets[0];
                    var mylist = new List<string>();
                    mylist.Clear();
                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        decimal num = 0;
                        decimal num1 = 0;
                        string Type1 = ""; string Type2 = ""; string Type3 = ""; string Type4 = ""; string Type5 = ""; string Type6 = ""; string Type7 = ""; string Type8 = ""; string Type9 = ""; string Type10 = ""; string Type11 = "";
                        string Type12 = ""; string Type13 = ""; string Type14 = ""; string Type15 = ""; string Type16 = ""; string Type17 = ""; string Type18 = ""; string Type19 = ""; string Type20 = "";
                        string sql = ""; string Log = "";
                        for (int J = 0; J < qty; J++)
                        {
                            if (J == 0)
                            {
                                Type1 = worksheet.Cells[L, 0].ToString();
                            }
                            else
                            {
                                if (J == 1)
                                {
                                    Type2 = worksheet.Cells[L, 1].ToString();
                                }
                                else
                                {
                                    if (J == 2)
                                    {
                                        Type3 = worksheet.Cells[L, 2].ToString();
                                    }
                                    else
                                    {
                                        if (J == 3)
                                        {
                                            Type4 = worksheet.Cells[L, 3].ToString();
                                        }
                                        else
                                        {
                                            if (J == 4)
                                            {
                                                Type5 = worksheet.Cells[L, 4].ToString();
                                                decimal.TryParse(Type5, out num);
                                            }
                                            else
                                            {
                                                if (J == 5)
                                                {
                                                    Type6 = worksheet.Cells[L, 5].ToString();
                                                    decimal.TryParse(Type6, out num1);
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
                                                }
                                                else
                                                {
                                                    if (J == 6)
                                                    {
                                                        Type7 = worksheet.Cells[L, 6].ToString();
                                                    }
                                                    else
                                                    {
                                                        if (J == 7)
                                                        {
                                                            Type8 = worksheet.Cells[L, 7].ToString();
                                                            if (Flag == "N")
                                                            {
                                                                if (Type8 != "" && Type8 != null && Type8 != "null")
                                                                {
                                                                    if (Type8 == "OK" || Type8 == "NG" || Type8.Length > 5)
                                                                    {

                                                                    }
                                                                    else
                                                                    {

                                                                        return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                    }
                                                                }
                                                            }
                                                            if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                            {
                                                                decimal num2 = 0;
                                                                if (Type8 != "" && Type8 != null && Type8 != "null")
                                                                {
                                                                    decimal.TryParse(Type8, out num2);
                                                                    if (num2 == 0)
                                                                    {
                                                                        return "NG,第" + L + "行输入值不为数字";
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        else
                                                        {
                                                            if (J == 8)
                                                            {
                                                                Type9 = worksheet.Cells[L, 8].ToString();
                                                                if (Flag == "N")
                                                                {
                                                                    if (Type9 != "" && Type9 != null && Type9 != "null")
                                                                    {
                                                                        if (Type9 == "OK" || Type9 == "NG" || Type9.Length > 5)
                                                                        {

                                                                        }
                                                                        else
                                                                        {
                                                                            return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                        }
                                                                    }
                                                                }
                                                                if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                {
                                                                    decimal num2 = 0;
                                                                    if (Type9 != "" && Type9 != null && Type9 != "null")
                                                                    {
                                                                        decimal.TryParse(Type9, out num2);
                                                                        if (num2 == 0)
                                                                        {
                                                                            return "NG,第" + L + "行输入值不为数字";
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                            else
                                                            {
                                                                if (J == 9)
                                                                {
                                                                    Type10 = worksheet.Cells[L, 9].ToString();
                                                                    if (Flag == "N")
                                                                    {
                                                                        if (Type10 != "" && Type10 != null && Type10 != "null")
                                                                        {
                                                                            if (Type10 == "OK" || Type10 == "NG" || Type10.Length > 5)
                                                                            {

                                                                            }
                                                                            else
                                                                            {
                                                                                return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                            }
                                                                        }
                                                                    }
                                                                    if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                    {
                                                                        decimal num2 = 0;
                                                                        if (Type10 != "" && Type10 != null && Type10 != "null")
                                                                        {
                                                                            decimal.TryParse(Type10, out num2);
                                                                            if (num2 == 0)
                                                                            {
                                                                                return "NG,第" + L + "行输入值不为数字";
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    if (J == 10)
                                                                    {
                                                                        Type11 = worksheet.Cells[L, 10].ToString();
                                                                        if (Flag == "N")
                                                                        {
                                                                            if (Type11 != "" && Type11 != null && Type11 != "null")
                                                                            {
                                                                                if (Type11 == "OK" || Type11 == "NG" || Type11.Length > 5)
                                                                                {

                                                                                }
                                                                                else
                                                                                {
                                                                                    return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                }
                                                                            }
                                                                        }
                                                                        if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                        {
                                                                            decimal num2 = 0;
                                                                            if (Type11 != "" && Type11 != null && Type11 != "null")
                                                                            {
                                                                                decimal.TryParse(Type11, out num2);
                                                                                if (num2 == 0)
                                                                                {
                                                                                    return "NG,第" + L + "行输入值不为数字";
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                    else
                                                                    {
                                                                        if (J == 11)
                                                                        {
                                                                            Type12 = worksheet.Cells[L, 11].ToString();
                                                                            if (Flag == "N")
                                                                            {
                                                                                if (Type12 != "" && Type12 != null && Type12 != "null")
                                                                                {
                                                                                    if (Type12 == "OK" || Type12 == "NG" || Type12.Length > 5)
                                                                                    {

                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                    }
                                                                                }
                                                                            }
                                                                            if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                            {
                                                                                decimal num2 = 0;
                                                                                if (Type12 != "" && Type12 != null && Type12 != "null")
                                                                                {
                                                                                    decimal.TryParse(Type12, out num2);
                                                                                    if (num2 == 0)
                                                                                    {
                                                                                        return "NG,第" + L + "行输入值不为数字";
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                        else
                                                                        {
                                                                            if (J == 12)
                                                                            {
                                                                                Type13 = worksheet.Cells[L, 12].ToString();
                                                                                if (Flag == "N")
                                                                                {
                                                                                    if (Type13 != "" && Type13 != null && Type13 != "null")
                                                                                    {
                                                                                        if (Type13 == "OK" || Type13 == "NG" || Type13.Length > 5)
                                                                                        {

                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                        }
                                                                                    }
                                                                                }
                                                                                if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                {
                                                                                    decimal num2 = 0;
                                                                                    if (Type13 != "" && Type13 != null && Type13 != "null")
                                                                                    {
                                                                                        decimal.TryParse(Type13, out num2);
                                                                                        if (num2 == 0)
                                                                                        {
                                                                                            return "NG,第" + L + "行输入值不为数字";
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                            else
                                                                            {
                                                                                if (J == 13)
                                                                                {
                                                                                    Type14 = worksheet.Cells[L, 13].ToString();
                                                                                    if (Flag == "N")
                                                                                    {
                                                                                        if (Type14 != "" && Type14 != null && Type14 != "null")
                                                                                        {
                                                                                            if (Type14 == "OK" || Type14 == "NG" || Type14.Length > 5)
                                                                                            {

                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                    {
                                                                                        decimal num2 = 0;
                                                                                        if (Type14 != "" && Type14 != null && Type14 != "null")
                                                                                        {
                                                                                            decimal.TryParse(Type14, out num2);
                                                                                            if (num2 == 0)
                                                                                            {
                                                                                                return "NG,第" + L + "行输入值不为数字";
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                                else
                                                                                {
                                                                                    if (J == 14)
                                                                                    {
                                                                                        Type15 = worksheet.Cells[L, 14].ToString();
                                                                                        if (Flag == "N")
                                                                                        {
                                                                                            if (Type15 != "" && Type15 != null && Type15 != "null")
                                                                                            {
                                                                                                if (Type15 == "OK" || Type15 == "NG" || Type15.Length > 5)
                                                                                                {

                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                        {
                                                                                            decimal num2 = 0;
                                                                                            if (Type15 != "" && Type15 != null && Type15 != "null")
                                                                                            {
                                                                                                decimal.TryParse(Type15, out num2);
                                                                                                if (num2 == 0)
                                                                                                {
                                                                                                    return "NG,第" + L + "行输入值不为数字";
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        if (J == 15)
                                                                                        {
                                                                                            Type16 = worksheet.Cells[L, 15].ToString();
                                                                                            if (Flag == "N")
                                                                                            {
                                                                                                if (Type16 != "" && Type16 != null && Type16 != "null")
                                                                                                {
                                                                                                    if (Type16 == "OK" || Type16 == "NG" || Type16.Length > 5)
                                                                                                    {

                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                            if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                            {
                                                                                                decimal num2 = 0;
                                                                                                if (Type16 != "" && Type16 != null && Type16 != "null")
                                                                                                {
                                                                                                    decimal.TryParse(Type16, out num2);
                                                                                                    if (num2 == 0)
                                                                                                    {
                                                                                                        return "NG,第" + L + "行输入值不为数字";
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        else
                                                                                        {
                                                                                            if (J == 16)
                                                                                            {
                                                                                                Type17 = worksheet.Cells[L, 16].ToString();
                                                                                                if (Flag == "N")
                                                                                                {
                                                                                                    if (Type17 != "" && Type17 != null && Type17 != "null")
                                                                                                    {
                                                                                                        if (Type17 == "OK" || Type17 == "NG" || Type17.Length > 5)
                                                                                                        {

                                                                                                        }
                                                                                                        else
                                                                                                        {
                                                                                                            return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                                {
                                                                                                    decimal num2 = 0;
                                                                                                    if (Type17 != "" && Type17 != null && Type17 != "null")
                                                                                                    {
                                                                                                        decimal.TryParse(Type17, out num2);
                                                                                                        if (num2 == 0)
                                                                                                        {
                                                                                                            return "NG,第" + L + "行输入值不为数字";
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                if (J == 17)
                                                                                                {
                                                                                                    Type18 = worksheet.Cells[L, 17].ToString();
                                                                                                    if (Flag == "N")
                                                                                                    {
                                                                                                        if (Type18 != "" && Type18 != null && Type18 != "null")
                                                                                                        {
                                                                                                            if (Type18 == "OK" || Type18 == "NG" || Type18.Length > 5)
                                                                                                            {

                                                                                                            }
                                                                                                            else
                                                                                                            {
                                                                                                                return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                    if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                                    {
                                                                                                        decimal num2 = 0;
                                                                                                        if (Type18 != "" && Type18 != null && Type18 != "null")
                                                                                                        {
                                                                                                            decimal.TryParse(Type18, out num2);
                                                                                                            if (num2 == 0)
                                                                                                            {
                                                                                                                return "NG,第" + L + "行输入值不为数字";
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    if (J == 18)
                                                                                                    {
                                                                                                        Type19 = worksheet.Cells[L, 18].ToString();
                                                                                                        if (Flag == "N")
                                                                                                        {
                                                                                                            if (Type19 != "" && Type19 != null && Type19 != "null")
                                                                                                            {
                                                                                                                if (Type19 == "OK" || Type19 == "NG" || Type19.Length > 5)
                                                                                                                {

                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                        if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                                        {
                                                                                                            decimal num2 = 0;
                                                                                                            if (Type19 != "" && Type19 != null && Type19 != "null")
                                                                                                            {
                                                                                                                decimal.TryParse(Type19, out num2);
                                                                                                                if (num2 == 0)
                                                                                                                {
                                                                                                                    return "NG,第" + L + "行输入值不为数字";
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                    else
                                                                                                    {
                                                                                                        if (J == 19)
                                                                                                        {
                                                                                                            Type20 = worksheet.Cells[L, 19].ToString();
                                                                                                            if (Flag == "N")
                                                                                                            {
                                                                                                                if (Type20 != "" && Type20 != null && Type20 != "null")
                                                                                                                {
                                                                                                                    if (Type20 == "OK" || Type20 == "NG" || Type20.Length > 5)
                                                                                                                    {

                                                                                                                    }
                                                                                                                    else
                                                                                                                    {
                                                                                                                        return "NG,第" + L + "行输入值请输入OK或者NG";
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                            if (Flag == "Y" || Flag == "D" || Flag == "L")
                                                                                                            {
                                                                                                                decimal num2 = 0;
                                                                                                                if (Type20 != "" && Type20 != null && Type20 != "null")
                                                                                                                {
                                                                                                                    decimal.TryParse(Type20, out num2);
                                                                                                                    if (num2 == 0)
                                                                                                                    {
                                                                                                                        return "NG,第" + L + "行输入值不为数字";

                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }

                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }

                            }
                        }
                    }


                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        decimal num = 0;
                        decimal num1 = 0;
                        string Type1 = ""; string Type2 = ""; string Type3 = ""; string Type4 = ""; string Type5 = ""; string Type6 = ""; string Type7 = ""; string Type8 = ""; string Type9 = ""; string Type10 = ""; string Type11 = "";
                        string Type12 = ""; string Type13 = ""; string Type14 = ""; string Type15 = ""; string Type16 = ""; string Type17 = ""; string Type18 = ""; string Type19 = ""; string Type20 = "";
                        string sql = ""; string Log = "";
                        for (int J = 0; J < qty; J++)
                        {
                            if (J == 0)
                            {
                                Type1 = worksheet.Cells[L, 0].ToString();
                            }
                            if (J == 1)
                            {
                                Type2 = worksheet.Cells[L, 1].ToString();
                            }
                            if (J == 2)
                            {
                                Type3 = worksheet.Cells[L, 2].ToString();
                            }
                            if (J == 3)
                            {
                                Type4 = worksheet.Cells[L, 3].ToString();

                            }
                            if (J == 4)
                            {
                                Type5 = worksheet.Cells[L, 4].ToString();

                            }
                            if (J == 5)
                            {
                                Type6 = worksheet.Cells[L, 5].ToString();

                            }
                            if (J == 6)
                            {
                                Type7 = worksheet.Cells[L, 6].ToString();
                            }
                            if (J == 7)
                            {
                                Type8 = worksheet.Cells[L, 7].ToString();
                                sql += " TYPE8='" + Type8 + "'" + ',';

                            }
                            if (J == 8)
                            {
                                Type9 = worksheet.Cells[L, 8].ToString();
                                sql += " TYPE9='" + Type9 + "'" + ',';
                            }
                            if (J == 9)
                            {
                                Type10 = worksheet.Cells[L, 9].ToString();
                                sql += " TYPE10='" + Type10 + "'" + ',';
                            }
                            if (J == 10)
                            {
                                Type11 = worksheet.Cells[L, 10].ToString();
                                sql += " TYPE11='" + Type11 + "'" + ',';
                            }
                            if (J == 11)
                            {
                                Type12 = worksheet.Cells[L, 11].ToString();
                                sql += " TYPE12='" + Type12 + "'" + ',';
                            }
                            if (J == 12)
                            {
                                Type13 = worksheet.Cells[L, 12].ToString();
                                sql += " TYPE13='" + Type13 + "'" + ',';
                            }
                            if (J == 13)
                            {
                                Type14 = worksheet.Cells[L, 13].ToString();
                                sql += " TYPE14='" + Type14 + "'" + ',';
                            }
                            if (J == 14)
                            {
                                Type15 = worksheet.Cells[L, 14].ToString();
                                sql += " TYPE15='" + Type15 + "'" + ',';
                            }
                            if (J == 15)
                            {
                                Type16 = worksheet.Cells[L, 15].ToString();
                                sql += " TYPE16='" + Type16 + "'" + ',';
                            }
                            if (J == 16)
                            {
                                Type17 = worksheet.Cells[L, 16].ToString();
                                sql += " TYPE17='" + Type17 + "'" + ',';
                            }
                            if (J == 17)
                            {
                                Type18 = worksheet.Cells[L, 17].ToString();
                                sql += " TYPE18='" + Type18 + "'" + ',';
                            }
                            if (J == 18)
                            {
                                Type19 = worksheet.Cells[L, 18].ToString();
                                sql += " TYPE19='" + Type19 + "'" + ',';
                            }
                            if (J == 19)
                            {
                                Type20 = worksheet.Cells[L, 19].ToString();
                                sql += " TYPE20='" + Type20 + "'" + ',';
                            }
                        }
                        string SQL = $@"UPDATE  SAJET.SYS_ECHECK_BASE SET {sql} ,CREATE_DATE=SYSDATE WHERE DN_NO='{DN_NO}' AND TYPE1='{Type1}'AND  TYPE2='{Type2}'AND TYPE3='{Type3}' AND TYPE4='{Type4}',";
                        PubClass.getdatatablenoreturnMES(sSQL);

                    }
                    fileStream.Close();
                    File.Delete(fname);
                }
            }
        }

        catch (Exception ex)
        {
            return "NG,离线上传失败";

        }

        return "NG,离线上传OK";


    }










    public string UpdateTemplateInfo11(string DN_NO, string REMARK, string user, string ID, string Type1, string Type2, string Type3, string Type4, string Type5, string Type6, string Type7, string Type8, string Type9, string Type10, string Type11, string Type12, string Type13, string Type14, string Type15, string Type16, string Type17, string Type18, string Type19, string Type20, string isAutoAssy)
    {
        string Flag = "N"; string QtyFlag = "N";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        string TEMPLATE = dt1.Rows[0]["TEMPLATE"].ToString();
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE='点检人权限'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if (dt1.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有点检权限\"}]";
        }
        if (isAutoAssy == "Y")
        {
            sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}'AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_TYPE='FACA人权限' AND EMAIL IS NOT NULL";
            dt1 = PubClass.getdatatableMES(sSQL1);
            if (dt1.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该类型没有维护FACA人员\"}]";
            }
        }

        string sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}' AND DN_STATUS='任务审核'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,当前单号已提交至审核,不可继续填写!\"}]";
        }
        decimal num = 0;
        decimal num1 = 0;
        decimal.TryParse(Type5, out num);
        decimal.TryParse(Type6, out num1);
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

        if (Flag == "N")
        {
            if (Type8 != "" && Type8 != null && Type8 != "null")
            {
                if (Type8 == "OK" || Type8 == "NG" || Type8.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type9 != "" && Type9 != null && Type9 != "null")
            {
                if (Type9 == "OK" || Type9 == "NG" || Type9.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type10 != "" && Type10 != null && Type10 != "null")
            {
                if (Type10 == "OK" || Type10 == "NG" || Type10.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type11 != "" && Type11 != null && Type11 != "null")
            {
                if (Type11 == "OK" || Type11 == "NG" || Type11.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type12 != "" && Type12 != null && Type12 != "null")
            {
                if (Type12 == "OK" || Type12 == "NG" || Type12.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type13 != "" && Type13 != null && Type13 != "null")
            {
                if (Type13 == "OK" || Type13 == "NG" || Type13.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type14 != "" && Type14 != null && Type14 != "null")
            {
                if (Type14 == "OK" || Type14 == "NG" || Type14.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type15 != "" && Type15 != null && Type15 != "null")
            {
                if (Type15 == "OK" || Type15 == "NG" || Type15.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type16 != "" && Type16 != null && Type16 != "null")
            {
                if (Type16 == "OK" || Type16 == "NG" || Type16.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type17 != "" && Type17 != null && Type17 != "null")
            {
                if (Type17 == "OK" || Type17 == "NG" || Type17.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type18 != "" && Type18 != null && Type18 != "null")
            {
                if (Type18 == "OK" || Type18 == "NG" || Type18.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type19 != "" && Type19 != null && Type19 != "null")
            {
                if (Type19 == "OK" || Type19 == "NG" || Type19.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type20 != "" && Type20 != null && Type20 != "null")
            {
                if (Type20 == "OK" || Type20 == "NG" || Type20.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
        }



        if (Flag == "Y" || Flag == "D" || Flag == "L")
        {
            decimal num2 = 0;
            if (Type8 != "" && Type8 != null && Type8 != "null")
            {
                decimal.TryParse(Type8, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type8)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type8)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type9 != "" && Type9 != null && Type9 != "null")
            {
                decimal.TryParse(Type9, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type9)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type9)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type10 != "" && Type10 != null && Type10 != "null")
            {
                decimal.TryParse(Type10, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type10)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type10)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type11 != "" && Type11 != null && Type11 != "null")
            {
                decimal.TryParse(Type11, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type11)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type11)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type12 != "" && Type12 != null && Type12 != "null")
            {
                decimal.TryParse(Type12, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type12)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type12)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type13 != "" && Type13 != null && Type13 != "null")
            {
                decimal.TryParse(Type13, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type13)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type13)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type14 != "" && Type14 != null && Type14 != "null")
            {
                decimal.TryParse(Type14, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type14)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type14)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type15 != "" && Type15 != null && Type15 != "null")
            {
                decimal.TryParse(Type15, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if (Convert.ToDouble(Type15) <= Convert.ToDouble(Type5) || Convert.ToDouble(Type15) >= Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type16 != "" && Type16 != null && Type16 != "null")
            {
                decimal.TryParse(Type16, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type16)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type16)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type17 != "" && Type17 != null && Type17 != "null")
            {
                decimal.TryParse(Type17, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type17)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type17)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type18 != "" && Type18 != null && Type18 != "null")
            {
                decimal.TryParse(Type18, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type18)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type18)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type19 != "" && Type19 != null && Type19 != "null")
            {
                decimal.TryParse(Type19, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type19)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type19)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
            if (Type20 != "" && Type20 != null && Type20 != "null")
            {
                decimal.TryParse(Type20, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                //if(Convert.ToDouble(Type20)<=Convert.ToDouble(Type5)||Convert.ToDouble(Type20)>=Convert.ToDouble(Type6))
                //{
                //    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                //}
            }
        }
        sSQL = $@"UPDATE SAJET.G_ECHECK_BASE SET REMARK='{REMARK}',TYPE1='{Type1}',TYPE2='{Type2}',TYPE3='{Type3}',TYPE4='{Type4}',TYPE5='{Type5}',TYPE6='{Type6}',TYPE7='{Type7}',TYPE8='{Type8}',TYPE9='{Type9}',TYPE10='{Type10}',
        TYPE11='{Type11}',TYPE12='{Type12}',TYPE13='{Type13}',TYPE14='{Type14}',TYPE15='{Type15}',TYPE16='{Type16}',TYPE17='{Type17}',TYPE18='{Type18}',TYPE19='{Type19}',TYPE20='{Type20}',CREATE_DATE=SYSDATE,CREATE_EMPID='{userEmpId}',FATYPE='{isAutoAssy}',LOG_TYPE='Y' WHERE ID='{ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"UPDATE SAJET.SYS_ECHECK_TEMPLATE_MODEL  SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO  SAJET.SYS_HT_ECHECK_TEMPLATE_MODEL SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        #region
        if (isAutoAssy == "Y")
        {
            ////MailUtils m = new MailUtils();
            string Email = "";
            sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_TYPE='FACA人权限'";
            dt1 = PubClass.getdatatableMES(sSQL1);
            if (dt1.Rows.Count > 0)
            {
                for (int i = 0; i <= dt1.Rows.Count - 1; i++)
                {
                    Email = Email + dt1.Rows[i]["EMAIL"].ToString() + ";";
                }
                Email = Email.Substring(0, Email.Length - 1);
                sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{TEMPLATE}' ORDER BY SEQ";
                dt = PubClass.getdatatableMES(sSQL);
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
                string titleMessage = $@"<table border='1' style='width:80%;text-align:center;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 17px;'>
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
                Send(DN_NO + "单号异常,存在须填写FACA项目，请及时填写", Email, "Wenjian.Ma@luxshare-ict.com", "E-CheckFACA邮件提醒" + " - " + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), mailMessage);
            }
        }
        #endregion




        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,维护OK!\"}]";
    }
    public string UpdateTemplateInfo1(string DN_NO, string REMARK, string user, string ID, string Type1, string Type2, string Type3, string Type4, string Type5, string Type6, string Type7, string Type8, string Type9, string Type10, string Type11, string Type12, string Type13, string Type14, string Type15, string Type16, string Type17, string Type18, string Type19, string Type20, string isAutoAssy)
    {
        string Flag = "N"; string QtyFlag = "N";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        string TEMPLATE = dt1.Rows[0]["TEMPLATE"].ToString();
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE='点检人权限'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if (dt1.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有点检权限\"}]";
        }
        if (isAutoAssy == "Y")
        {
            sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_TYPE='FACA人权限' AND EMAIL IS NOT NULL";
            dt1 = PubClass.getdatatableMES(sSQL1);
            if (dt1.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该类型没有维护FACA人员\"}]";
            }
        }




        string sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}' AND DN_STATUS='任务审核'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,当前单号已提交至审核,不可继续填写!\"}]";
        }
        decimal num = 0;
        decimal num1 = 0;
        decimal.TryParse(Type5, out num);
        decimal.TryParse(Type6, out num1);
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
        if (Flag == "N")
        {
            if (Type8 != "" && Type8 != null && Type8 != "null")
            {
                if (Type8 == "OK" || Type8 == "NG" || Type8.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type9 != "" && Type9 != null && Type9 != "null")
            {
                if (Type9 == "OK" || Type9 == "NG" || Type9.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type10 != "" && Type10 != null && Type10 != "null")
            {
                if (Type10 == "OK" || Type10 == "NG" || Type10.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type11 != "" && Type11 != null && Type11 != "null")
            {
                if (Type11 == "OK" || Type11 == "NG" || Type11.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type12 != "" && Type12 != null && Type12 != "null")
            {
                if (Type12 == "OK" || Type12 == "NG" || Type12.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type13 != "" && Type13 != null && Type13 != "null")
            {
                if (Type13 == "OK" || Type13 == "NG" || Type13.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type14 != "" && Type14 != null && Type14 != "null")
            {
                if (Type14 == "OK" || Type14 == "NG" || Type14.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type15 != "" && Type15 != null && Type15 != "null")
            {
                if (Type15 == "OK" || Type15 == "NG" || Type15.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type16 != "" && Type16 != null && Type16 != "null")
            {
                if (Type16 == "OK" || Type16 == "NG" || Type16.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type17 != "" && Type17 != null && Type17 != "null")
            {
                if (Type17 == "OK" || Type17 == "NG" || Type17.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type18 != "" && Type18 != null && Type18 != "null")
            {
                if (Type18 == "OK" || Type18 == "NG" || Type18.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type19 != "" && Type19 != null && Type19 != "null")
            {
                if (Type19 == "OK" || Type19 == "NG" || Type19.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
            if (Type20 != "" && Type20 != null && Type20 != "null")
            {
                if (Type20 == "OK" || Type20 == "NG" || Type20.Length > 5)
                {

                }
                else
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值请输入OK或者NG!\"}]";
                }
            }
        }

        if (Flag == "D")
        {
            decimal num2 = 0;
            if (Type8 != "" && Type8 != null && Type8 != "null")
            {
                decimal.TryParse(Type8, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type8) <= Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type9 != "" && Type9 != null && Type9 != "null")
            {
                decimal.TryParse(Type9, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type9) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type10 != "" && Type10 != null && Type10 != "null")
            {
                decimal.TryParse(Type10, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type10) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type11 != "" && Type11 != null && Type11 != "null")
            {
                decimal.TryParse(Type11, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type11) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type12 != "" && Type12 != null && Type12 != "null")
            {
                decimal.TryParse(Type12, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type12) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type13 != "" && Type13 != null && Type13 != "null")
            {
                decimal.TryParse(Type13, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type13) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type14 != "" && Type14 != null && Type14 != "null")
            {
                decimal.TryParse(Type14, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type14) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type15 != "" && Type15 != null && Type15 != "null")
            {
                decimal.TryParse(Type15, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type15) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type16 != "" && Type16 != null && Type16 != "null")
            {
                decimal.TryParse(Type16, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type16) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type17 != "" && Type17 != null && Type17 != "null")
            {
                decimal.TryParse(Type17, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type17) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type18 != "" && Type18 != null && Type18 != "null")
            {
                decimal.TryParse(Type18, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type18) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type19 != "" && Type19 != null && Type19 != "null")
            {
                decimal.TryParse(Type19, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type19) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type20 != "" && Type20 != null && Type20 != "null")
            {
                decimal.TryParse(Type20, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type20) < Convert.ToDouble(Type5))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
        }

        if (Flag == "L")
        {
            decimal num2 = 0;
            if (Type8 != "" && Type8 != null && Type8 != "null")
            {
                decimal.TryParse(Type8, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type8) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type9 != "" && Type9 != null && Type9 != "null")
            {
                decimal.TryParse(Type9, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type9) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type10 != "" && Type10 != null && Type10 != "null")
            {
                decimal.TryParse(Type10, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type10) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type11 != "" && Type11 != null && Type11 != "null")
            {
                decimal.TryParse(Type11, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type11) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type12 != "" && Type12 != null && Type12 != "null")
            {
                decimal.TryParse(Type12, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type12) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type13 != "" && Type13 != null && Type13 != "null")
            {
                decimal.TryParse(Type13, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type13) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type14 != "" && Type14 != null && Type14 != "null")
            {
                decimal.TryParse(Type14, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type14) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type15 != "" && Type15 != null && Type15 != "null")
            {
                decimal.TryParse(Type15, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type15) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type16 != "" && Type16 != null && Type16 != "null")
            {
                decimal.TryParse(Type16, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type16) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type17 != "" && Type17 != null && Type17 != "null")
            {
                decimal.TryParse(Type17, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type17) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type18 != "" && Type18 != null && Type18 != "null")
            {
                decimal.TryParse(Type18, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type18) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type19 != "" && Type19 != null && Type19 != "null")
            {
                decimal.TryParse(Type19, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type19) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type20 != "" && Type20 != null && Type20 != "null")
            {
                decimal.TryParse(Type20, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type20) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
        }



        if (Flag == "Y")
        {
            decimal num2 = 0;
            if (Type8 != "" && Type8 != null && Type8 != "null")
            {
                decimal.TryParse(Type8, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type8) < Convert.ToDouble(Type5) || Convert.ToDouble(Type8) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type9 != "" && Type9 != null && Type9 != "null")
            {
                decimal.TryParse(Type9, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type9) < Convert.ToDouble(Type5) || Convert.ToDouble(Type9) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type10 != "" && Type10 != null && Type10 != "null")
            {
                decimal.TryParse(Type10, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type10) < Convert.ToDouble(Type5) || Convert.ToDouble(Type10) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type11 != "" && Type11 != null && Type11 != "null")
            {
                decimal.TryParse(Type11, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type11) < Convert.ToDouble(Type5) || Convert.ToDouble(Type11) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type12 != "" && Type12 != null && Type12 != "null")
            {
                decimal.TryParse(Type12, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type12) < Convert.ToDouble(Type5) || Convert.ToDouble(Type12) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type13 != "" && Type13 != null && Type13 != "null")
            {
                decimal.TryParse(Type13, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type13) < Convert.ToDouble(Type5) || Convert.ToDouble(Type13) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type14 != "" && Type14 != null && Type14 != "null")
            {
                decimal.TryParse(Type14, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type14) < Convert.ToDouble(Type5) || Convert.ToDouble(Type14) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type15 != "" && Type15 != null && Type15 != "null")
            {
                decimal.TryParse(Type15, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type15) < Convert.ToDouble(Type5) || Convert.ToDouble(Type15) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type16 != "" && Type16 != null && Type16 != "null")
            {
                decimal.TryParse(Type16, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type16) < Convert.ToDouble(Type5) || Convert.ToDouble(Type16) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type17 != "" && Type17 != null && Type17 != "null")
            {
                decimal.TryParse(Type17, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type17) < Convert.ToDouble(Type5) || Convert.ToDouble(Type17) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type18 != "" && Type18 != null && Type18 != "null")
            {
                decimal.TryParse(Type18, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type18) < Convert.ToDouble(Type5) || Convert.ToDouble(Type18) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type19 != "" && Type19 != null && Type19 != "null")
            {
                decimal.TryParse(Type19, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type19) < Convert.ToDouble(Type5) || Convert.ToDouble(Type19) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
            if (Type20 != "" && Type20 != null && Type20 != "null")
            {
                decimal.TryParse(Type20, out num2);
                if (num2 == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不为数字!\"}]";
                }
                if (Convert.ToDouble(Type20) < Convert.ToDouble(Type5) || Convert.ToDouble(Type20) > Convert.ToDouble(Type6))
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,输入值不在允许范围内!\"}]";
                }
            }
        }
        sSQL = $@"UPDATE SAJET.G_ECHECK_BASE SET REMARK='{REMARK}',TYPE1='{Type1}',TYPE2='{Type2}',TYPE3='{Type3}',TYPE4='{Type4}',TYPE5='{Type5}',TYPE6='{Type6}',TYPE7='{Type7}',TYPE8='{Type8}',TYPE9='{Type9}',TYPE10='{Type10}',
        TYPE11='{Type11}',TYPE12='{Type12}',TYPE13='{Type13}',TYPE14='{Type14}',TYPE15='{Type15}',TYPE16='{Type16}',TYPE17='{Type17}',TYPE18='{Type18}',TYPE19='{Type19}',TYPE20='{Type20}',CREATE_DATE=SYSDATE,CREATE_EMPID='{userEmpId}',FATYPE='{isAutoAssy}',LOG_TYPE='Y' WHERE ID='{ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"UPDATE SAJET.SYS_ECHECK_TEMPLATE_MODEL  SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO  SAJET.SYS_HT_ECHECK_TEMPLATE_MODEL SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        #region
        //if(isAutoAssy=="Y")
        //{
        //    ////MailUtils m = new MailUtils();
        //    string Email = "";
        //    sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}'AND MODEL_NAME='{dt1.Rows[0]["MODEL_NAME"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_TYPE='FACA人权限'";
        //    dt1 = PubClass.getdatatableMES(sSQL1);
        //    if(dt1.Rows.Count>0)
        //    {
        //        for (int i = 0; i <= dt1.Rows.Count - 1; i++)
        //        {
        //            Email = Email + dt1.Rows[i]["EMAIL"].ToString() + ";";
        //        }
        //        Email = Email.Substring(0,Email.Length-1);
        //        sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{TEMPLATE}' ORDER BY SEQ";
        //        dt = PubClass.getdatatableMES(sSQL);
        //        int QTY = dt.Rows.Count;

        //        string mailMessage = $@"<!DOCTYPE html>
        //                            <html>

        //                            <head>
        //                                <title></title>
        //                                <meta charset='utf-8'>
        //                            </head>

        //                            <body>
        //                                <p>以下内容自动发送，请勿直接回复，谢谢。</p>
        //                                <p></p>
        //                                <p>";
        //        string titleMessage = $@"<table border='1' style='width:80%;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 17px;'>
        //                           <tr style='background-color:#a8cc44;color: cornsilk;'>";
        //        titleMessage += $@"<td style='width: 10%;'>单号</td>";
        //        for (int i = 0; i < dt.Rows.Count; i++)
        //        {
        //            titleMessage += $@"<td style='width: 5%;'>{dt.Rows[i]["TITLE"]}</td>";
        //        }
        //        titleMessage += "</tr>";
        //        string detailMessage = $@"";
        //        sSQL = $@"SELECT * FROM SAJET.G_ECHECK_BASE  WHERE ID='{ID}'";
        //        dt = PubClass.getdatatableMES(sSQL);
        //        for (int i = 0; i < dt.Rows.Count; i++)
        //        {
        //            detailMessage += $@"<tr style='font-size:13px;'>";
        //            detailMessage += $@"<td>{dt.Rows[i][dt.Columns[0].ColumnName]}</td>";
        //            for (int j = 2; j < QTY+2; j++)
        //            {
        //                detailMessage += $@"<td>{dt.Rows[i][dt.Columns[j].ColumnName]}</td>";
        //            }
        //            detailMessage += $@"</tr>";
        //        }

        //        string endMessage = $@"</table>
        //                            </ p >
        //                    </ body >

        //                    </ html > ";

        //        mailMessage = mailMessage + titleMessage + detailMessage + endMessage;
        //        Send(DN_NO+"单号异常,存在须填写FACA项目，请及时填写", Email, "Wenjian.Ma@luxshare-ict.com", "E-CheckFACA邮件提醒"+" - "+DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), mailMessage);
        //    }
        //}
        #endregion




        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,维护OK!\"}]";
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


            MyProperty.Body = senderName + body + "(链接地址:http://10.32.15.59:9002/)";
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

        string titleMessage = $@"<table border='1' style='width:100%;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 17px;'>
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



    public string Commit(string DN_NO, string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }

        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE='点检人权限'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if (dt1.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有点检权限\"}]";
        }



        string sSQL = $@"UPDATE SAJET.SYS_ECHECK_TEMPLATE_MODEL  SET DN_STATUS='任务审核',UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO  SAJET.SYS_HT_ECHECK_TEMPLATE_MODEL SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,任务提交审核成功!\"}]";
    }


    public string GetDate()
    {
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\"}]";
    }
    public string GetDate1()
    {
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'HH24') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);

        //return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"06\"}]";


        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\"}]";
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
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,此模板未维护标题!\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows.Count + "\"}]";
    }
    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT PDLINE_NAME FROM  SAJET.SYS_ECHECK_POWER_BASE) AND PDLINE_NAME LIKE'" + JJ + "%'ORDER BY PDLINE_NAME ";
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
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT PDLINE_NAME FROM  SAJET.SYS_ECHECK_POWER_BASE)  ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetTitle(string DN_NO)
    {
        string sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE NUMBER_ID IN(SELECT NUMBER_ID FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}') ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetTitleNO(string DN_NO)
    {
        string sSQL = $@" SELECT * FROM SAJET.G_ECHECK_BASE WHERE DN_NO='{DN_NO}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowDnno(string Template, string user, string PdlineName, string datetimepicker, string dataType)
    {
        string sql = "";

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
        string sSQL = $@"SELECT TO_CHAR(SYSDATE-1,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        string StartDate = dt.Rows[0][0].ToString();
        string YEAR_DATE = DateTime.Now.ToString("yyyy-MM-dd");
        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL  WHERE DN_STATUS IN('任务填写','任务退回')" + sql + "";
        dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG ORDER BY  TEMPLATE";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string Template, string DN_NO, string datetimepicker, string dataType)
    {
        string sql = "";
        string sSQL = $@"SELECT B.REMARK,B.DRI_DATE,E.EMP_NAME AS EMP_NAME1,B.RESULT,B.FA,B.CA,A.TEMPLATE,B.ID,B.DN_NO,C.YEAR_DATE,C.CLASS,B.TYPE1,B.TYPE2,B.TYPE3, B.TYPE4,B.TYPE5,B.TYPE6,B.TYPE7,B.TYPE8,B.TYPE9,B.TYPE10,B.TYPE11,B.TYPE12,B.TYPE13,B.TYPE14,B.TYPE15,B.TYPE16,B.TYPE17,B.TYPE18,B.TYPE19,B.TYPE20,B.CREATE_DATE,D.EMP_NAME FROM SAJET.SYS_ECHECK_TEMPLATE_CONFIG A ,SAJET.G_ECHECK_BASE B,SAJET.SYS_ECHECK_TEMPLATE_MODEL C,SAJET.SYS_EMP D,SAJET.SYS_EMP E
WHERE A.NUMBER_ID=B.NUMBER_ID
AND A.NUMBER_ID=C.NUMBER_ID
AND B.DN_NO=C.DN_NO  AND B.DN_NO ='" + DN_NO + "' AND B.CREATE_EMPID=D.EMP_ID(+) AND B.DRI_EMPID=E.EMP_ID(+)  ORDER BY B.SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string addTemplateInfo(string Template, string user, string PdlineName, string datetimepicker, string dataType)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }

        sSQL = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{Template}' AND PDLINE_NAME='{PdlineName}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE='点检人权限'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有点检权限\"}]";
        }




        sSQL = $"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE TEMPLATE='{Template}' AND PDLINE_NAME='{PdlineName}' AND YEAR_DATE='{datetimepicker}' AND CLASS='{dataType}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前日期任务已存在\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前模板还未维护标题信息,不可新增任务\"}]";
        }
        string Number_id = dt.Rows[0]["Number_id"].ToString();
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_BASE WHERE NUMBER_ID='{Number_id}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前模板还对应标题还未维护详细信息，不可新增任务\"}]";
        }
        string DN_NO = "DJ" + DateTime.Now.ToString("yyyyMMddHHmmssfff");
        sSQL = $"INSERT INTO SAJET.SYS_ECHECK_TEMPLATE_MODEL(DN_NO,YEAR_DATE,CLASS,NUMBER_ID,PDLINE_NAME,TEMPLATE,CREATE_USERID,CREATE_DATE,DN_STATUS)VALUES('{DN_NO}','{datetimepicker}','{dataType}','{Number_id}','{PdlineName}','{Template}','{userEmpId}',SYSDATE,'任务填写')";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_ECHECK_TEMPLATE_MODEL SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE NUMBER_ID='{Number_id}' AND DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"SELECT * FROM  SAJET.SYS_ECHECK_BASE  WHERE NUMBER_ID='{Number_id}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            for (int i = 0; i <= dt.Rows.Count - 1; i++)
            {
                string TYPE1 = dt.Rows[i]["TYPE1"].ToString();
                string TYPE2 = dt.Rows[i]["TYPE2"].ToString();
                string TYPE3 = dt.Rows[i]["TYPE3"].ToString();
                string TYPE4 = dt.Rows[i]["TYPE4"].ToString();
                string TYPE5 = dt.Rows[i]["TYPE5"].ToString();
                string TYPE6 = dt.Rows[i]["TYPE6"].ToString();
                string TYPE7 = dt.Rows[i]["TYPE7"].ToString();
                string TYPE8 = dt.Rows[i]["TYPE8"].ToString();
                string TYPE9 = dt.Rows[i]["TYPE9"].ToString();
                string TYPE10 = dt.Rows[i]["TYPE10"].ToString();
                string TYPE11 = dt.Rows[i]["TYPE11"].ToString();
                string TYPE12 = dt.Rows[i]["TYPE12"].ToString();
                string TYPE13 = dt.Rows[i]["TYPE13"].ToString();
                string TYPE14 = dt.Rows[i]["TYPE14"].ToString();
                string TYPE15 = dt.Rows[i]["TYPE15"].ToString();
                string TYPE16 = dt.Rows[i]["TYPE16"].ToString();
                string TYPE17 = dt.Rows[i]["TYPE17"].ToString();
                string TYPE18 = dt.Rows[i]["TYPE18"].ToString();
                string TYPE19 = dt.Rows[i]["TYPE19"].ToString();
                string TYPE20 = dt.Rows[i]["TYPE20"].ToString();
                string ID = Guid.NewGuid().ToString().ToUpper();
                string SEQ = dt.Rows[i]["SEQ"].ToString();
                sSQL = $"INSERT INTO SAJET.G_ECHECK_BASE(SEQ,NUMBER_ID,DN_NO,TYPE1,TYPE2,TYPE3,TYPE4,TYPE5,TYPE6,TYPE7,TYPE8,TYPE9,TYPE10,TYPE11,TYPE12,TYPE13,TYPE14,TYPE15,TYPE16,TYPE17,TYPE18,TYPE19,TYPE20,CREATE_DATE,CREATE_EMPID,ID)VALUES" +
                $" ( '{SEQ}','{Number_id}','{DN_NO}','{TYPE1}','{TYPE2}','{TYPE3}','{TYPE4}','{TYPE5}','{TYPE6}','{TYPE7}','{TYPE8}','{TYPE9}','{TYPE10}','{TYPE11}','{TYPE12}','{TYPE13}','{TYPE14}','{TYPE15}','{TYPE16}','{TYPE17}','{TYPE18}','{TYPE19}','{TYPE20}',SYSDATE,'{userEmpId}','{ID}')";
                PubClass.getdatatablenoreturnMES(sSQL);
            }
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + DN_NO + "\"}]";
    }
    public string del(string NUMBER_ID, string user, string Template, string PdlineName, string ModelName, string DN_NO)
    {
        string sSQL = ""; DataTable dt;
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