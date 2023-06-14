<%@ WebHandler Language="C#" Class="O03" %>
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

public class O03 : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string Template = context.Request["Template"];
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
        string Type11= context.Request["Type11"];
        string Type12 = context.Request["Type12"];
        string Type13 = context.Request["Type13"];
        string Type14 = context.Request["Type14"];
        string Type15 = context.Request["Type15"];
        string Type16 = context.Request["Type16"];
        string Type17 = context.Request["Type17"];
        string Type18 = context.Request["Type18"];
        string Type19 = context.Request["Type19"];
        string Type20 = context.Request["Type20"];
        switch (funcName)
        {
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "GetType":
                rtnValue = GetType(Template);
                break;
            case "GetQTY":
                rtnValue = GetQTY(Template);
                break;
            case "GetLabel":
                rtnValue = GetLabel(Template);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(user,Template,Type1,Type2,Type3,Type4,Type5,Type6,Type7,Type8,Type9,Type10,Type11,Type12,Type13,Type14,Type15,Type16,Type17,Type18,Type19,Type20);
                break;
            case "delete":
                rtnValue = delete(user,Template,Type1,Type2,Type3,Type4,Type5,Type6,Type7,Type8,Type9,Type10,Type11,Type12,Type13,Type14,Type15,Type16,Type17,Type18,Type19,Type20);
                break;
            case "excel":
                rtnValue = uploadFile(Template,user,context);
                break;

        }
        context.Response.Write(rtnValue);
    }



    private static string uploadFile(string Template,string user,HttpContext context)
    {
        string SEQ = "";
        try
        {
            string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

            DataTable dt = PubClass.getdatatableMES(sSQL);
            string userEmpId=dt.Rows[0][0].ToString();
            sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{Template}' ORDER BY SEQ";
            dt = PubClass.getdatatableMES(sSQL);
            if(dt.Rows.Count==0)
            {
                return "NG,此模板未维护标题!";
            }
            int qty = dt.Rows.Count;
            sSQL = $@"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG  WHERE  TEMPLATE='{Template}'";
            dt = PubClass.getdatatableMES(sSQL);
            string NUMBER_ID=dt.Rows[0]["NUMBER_ID"].ToString();
            if (context.Request.Files.Count > 0)
            {
                string filePath = context.Server.MapPath("../Data/");
                //如不存在,则创建对应文件夹
                if (!System.IO.Directory.Exists(filePath))
                {
                    System.IO.Directory.CreateDirectory(filePath);
                }
                HttpFileCollection files = context.Request.Files;
                //批量上传时使用
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
                        string Type1 = ""; string Type2 = ""; string Type3= ""; string Type4 = ""; string Type5 = ""; string Type6 = ""; string Type7 = ""; string Type8 = ""; string Type9 = ""; string Type10 = ""; string Type11 = "";
                        string Type12 = ""; string Type13 = ""; string Type14 = ""; string Type15 = ""; string Type16 = ""; string Type17 = ""; string Type18 = ""; string Type19 = ""; string Type20 = "";
                        string sql = "";string Log = "";
                        for(int J = 0; J < qty; J++)
                        {
                            if(J==0)
                            {
                                Type1 = worksheet.Cells[L, 0].ToString();
                            }
                            if(J==1)
                            {
                                Type2 = worksheet.Cells[L, 1].ToString();
                            }if(J==2)
                            {
                                Type3 = worksheet.Cells[L, 2].ToString();
                            }if(J==3)
                            {
                                Type4 = worksheet.Cells[L, 3].ToString();

                            }if(J==4)
                            {  Type5 = worksheet.Cells[L, 4].ToString();

                            }if(J==5)
                            {
                                Type6 = worksheet.Cells[L, 5].ToString();
                            }if(J==6)
                            {
                                Type7 = worksheet.Cells[L, 6].ToString();
                            }if(J==7)
                            {
                                Type8 = worksheet.Cells[L, 7].ToString();
                            }if(J==8)
                            {
                                Type9 = worksheet.Cells[L, 8].ToString();
                            }if(J==9)
                            {
                                Type10 = worksheet.Cells[L, 9].ToString();
                            }if(J==10)
                            {
                                Type11 = worksheet.Cells[L, 10].ToString();
                            }if(J==11)
                            {
                                Type12 = worksheet.Cells[L, 11].ToString();
                            }if(J==12)
                            {
                                Type13 = worksheet.Cells[L, 12].ToString();
                            }if(J==13)
                            {
                                Type14 = worksheet.Cells[L, 13].ToString();
                            }if(J==14)
                            {
                                Type15 = worksheet.Cells[L, 14].ToString();
                            }if(J==15)
                            {
                                Type16 = worksheet.Cells[L, 15].ToString();
                            }if(J==16)
                            {
                                Type17 = worksheet.Cells[L, 16].ToString();
                            }if(J==17)
                            {
                                Type18 = worksheet.Cells[L, 17].ToString();
                            }if(J==18)
                            {
                                Type19 = worksheet.Cells[L, 18].ToString();
                            }if(J==19)
                            {
                                Type20 = worksheet.Cells[L, 19].ToString();
                            }
                        }
                        if(Type1!=""&& Type1!=null&& Type1!="null")
                        {
                            sql = sql + " AND TYPE1 ='" + Type1 + "'";
                            Log = Log + Type1;
                        }
                        if(Type2!=""&& Type2!=null&& Type2!="null")
                        {
                            sql = sql + " AND TYPE2 ='" + Type2 + "'";
                            Log = Log + Type2;
                        }
                        if(Type3!=""&& Type3!=null&& Type3!="null")
                        {
                            sql = sql + " AND TYPE3 ='" + Type3 + "'";
                            Log = Log + Type3;
                        }
                        if(Type4!=""&& Type4!=null&& Type4!="null")
                        {
                            sql = sql + " AND TYPE4 ='" + Type4 + "'";
                            Log = Log + Type4;
                        }
                        if(Type5!=""&& Type5!=null&& Type5!="null")
                        {
                            sql = sql + " AND TYPE5 ='" + Type5 + "'";
                            Log = Log + Type5;
                        }
                        if(Type6!=""&& Type6!=null&& Type6!="null")
                        {
                            sql = sql + " AND TYPE6 ='" + Type6 + "'";
                            Log = Log + Type6;
                        }
                        if(Type7!=""&& Type7!=null&& Type7!="null")
                        {
                            sql = sql + " AND TYPE7 ='" + Type7 + "'";
                            Log = Log + Type7;
                        }
                        if(Type8!=""&& Type8!=null&& Type8!="null")
                        {
                            sql = sql + " AND TYPE8 ='" + Type8 + "'";
                            Log = Log + Type8;
                        }
                        if(Type9!=""&& Type9!=null&& Type9!="null")
                        {
                            sql = sql + " AND TYPE9 ='" + Type9 + "'";
                            Log = Log + Type9;
                        }
                        if(Type10!=""&& Type10!=null&& Type10!="null")
                        {
                            sql = sql + " AND TYPE10 ='" + Type10 + "'";
                            Log = Log + Type10;
                        }
                        if(Type11!=""&& Type11!=null&& Type11!="null")
                        {
                            sql = sql + " AND TYPE11 ='" + Type11 + "'";
                            Log = Log + Type11;
                        }
                        if(Type12!=""&& Type12!=null&& Type12!="null")
                        {
                            sql = sql + " AND TYPE12 ='" + Type12 + "'";
                            Log = Log + Type12;
                        }
                        if(Type13!=""&& Type13!=null&& Type13!="null")
                        {
                            sql = sql + " AND TYPE13 ='" + Type13 + "'";
                            Log = Log + Type13;
                        }
                        if(Type14!=""&& Type14!=null&& Type14!="null")
                        {
                            sql = sql + " AND TYPE14 ='" + Type14 + "'";
                            Log = Log + Type14;
                        }
                        if(Type15!=""&& Type15!=null&& Type15!="null")
                        {
                            sql = sql + " AND TYPE15 ='" + Type15 + "'";
                            Log = Log + Type5;
                        }
                        if(Type16!=""&& Type16!=null&& Type16!="null")
                        {
                            sql = sql + " AND TYPE16 ='" + Type16 + "'";
                            Log = Log + Type6;
                        }
                        if(Type17!=""&& Type17!=null&& Type17!="null")
                        {
                            sql = sql + " AND TYPE17 ='" + Type17 + "'";
                            Log = Log + Type7;
                        }
                        if(Type18!=""&& Type18!=null&& Type18!="null")
                        {
                            sql = sql + " AND TYPE18 ='" + Type18 + "'";
                            Log = Log + Type8;
                        }
                        if(Type19!=""&& Type19!=null&& Type19!="null")
                        {
                            sql = sql + " AND TYPE19 ='" + Type19 + "'";
                            Log = Log + Type9;
                        }
                        if(Type20!=""&& Type20!=null&& Type20!="null")
                        {
                            sql = sql + " AND TYPE20 ='" + Type20 + "'";
                            Log = Log + Type20;
                        }
                        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_BASE WHERE NUMBER_ID='{NUMBER_ID}'"+sql+"";
                        dt = PubClass.getdatatableMES(sSQL);
                        if(dt.Rows.Count>0)
                        {
                            return "NG,第"+L+"行数据重复!";
                        }
                        if(mylist.Contains(Log))
                        {
                            return "NG,第"+L+"行存在重复数据!";
                        }
                        else
                        {
                            mylist.Add(Log);
                        }
                    }
                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        string Type1 = ""; string Type2 = ""; string Type3= ""; string Type4 = ""; string Type5 = ""; string Type6 = ""; string Type7 = ""; string Type8 = ""; string Type9 = ""; string Type10 = ""; string Type11 = "";
                        string Type12 = ""; string Type13 = ""; string Type14 = ""; string Type15 = ""; string Type16 = ""; string Type17 = ""; string Type18 = ""; string Type19 = ""; string Type20 = "";
                        string sql = "";string Log = "";
                        for(int J = 0; J < qty; J++)
                        {
                            if(J==0)
                            {
                                Type1 = worksheet.Cells[L, 0].ToString();
                            }
                            if(J==1)
                            {
                                Type2 = worksheet.Cells[L, 1].ToString();
                            }if(J==2)
                            {
                                Type3 = worksheet.Cells[L, 2].ToString();
                            }if(J==3)
                            {
                                Type4 = worksheet.Cells[L, 3].ToString();

                            }if(J==4)
                            {  Type5 = worksheet.Cells[L, 4].ToString();

                            }if(J==5)
                            {
                                Type6 = worksheet.Cells[L, 5].ToString();
                            }if(J==6)
                            {
                                Type7 = worksheet.Cells[L, 6].ToString();
                            }if(J==7)
                            {
                                Type8 = worksheet.Cells[L, 7].ToString();
                            }if(J==8)
                            {
                                Type9 = worksheet.Cells[L, 8].ToString();
                            }if(J==9)
                            {
                                Type10 = worksheet.Cells[L, 9].ToString();
                            }if(J==10)
                            {
                                Type11 = worksheet.Cells[L, 10].ToString();
                            }if(J==11)
                            {
                                Type12 = worksheet.Cells[L, 11].ToString();
                            }if(J==12)
                            {
                                Type13 = worksheet.Cells[L, 12].ToString();
                            }if(J==13)
                            {
                                Type14 = worksheet.Cells[L, 13].ToString();
                            }if(J==14)
                            {
                                Type15 = worksheet.Cells[L, 14].ToString();
                            }if(J==15)
                            {
                                Type16 = worksheet.Cells[L, 15].ToString();
                            }if(J==16)
                            {
                                Type17 = worksheet.Cells[L, 16].ToString();
                            }if(J==17)
                            {
                                Type18 = worksheet.Cells[L, 17].ToString();
                            }if(J==18)
                            {
                                Type19 = worksheet.Cells[L, 18].ToString();
                            }if(J==19)
                            {
                                Type20 = worksheet.Cells[L, 19].ToString();
                            }
                        }
                        string SQL = $"SELECT NVL(MAX(SEQ),0)+1 FROM SAJET.SYS_ECHECK_BASE WHERE NUMBER_ID='{NUMBER_ID}'";
                        DataTable dtseq = PubClass.getdatatableMES(SQL);
                        SEQ=dtseq.Rows[0][0].ToString();


                        if(Type3!=""&& Type3!=null&& Type3!="null")
                        {
                        sSQL = $"INSERT INTO SAJET.SYS_ECHECK_BASE(SEQ,CREATE_DATE,CREATE_EMPID,NUMBER_ID,TYPE1,TYPE2,TYPE3,TYPE4,TYPE5,TYPE6,TYPE7,TYPE8,TYPE9,TYPE10,TYPE11,TYPE12,TYPE13,TYPE14,TYPE15,TYPE16,TYPE17,TYPE18,TYPE19,TYPE20)VALUES" +
                        $"('{SEQ}',SYSDATE,'{userEmpId}','{NUMBER_ID}','{Type1}','{Type2}','{Type3}','{Type4}','{Type5}','{Type6}','{Type7}','{Type8}','{Type9}','{Type10}','{Type11}','{Type12}','{Type13}','{Type14}','{Type15}','{Type16}','{Type17}','{Type18}','{Type19}','{Type20}')";
                        PubClass.getdatatablenoreturnMES(sSQL);
                        }
                    
                    }
                    fileStream.Close();
                    File.Delete(fname);
                }
            }
        }
        catch(Exception ex)
        {
            return "NG,批量上传失败";
        }

        return "OK,批量上传成功";

    }






    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG ORDER BY  TEMPLATE";
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
    public string GetLabel(string Template)
    {
        string sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{Template}' ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetType(string Template)
    {
        string sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{Template}' ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count==0)
        {
            return "NG,此模板未维护标题!";
        }
        sSQL = $@"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG  WHERE  TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        string NUMBER_ID=dt.Rows[0]["NUMBER_ID"].ToString();
        string TYPE = "";
        sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{Template}' ORDER BY SEQ";
        dt = PubClass.getdatatableMES(sSQL);
        int QTY = dt.Rows.Count;
        string titleMessage = $@"<table border='1' style='width:90%;text-align:center;text-align:left;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 18px;'><tr style='background-color:#0a8fbd;color: cornsilk;'>";
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            titleMessage += $@"<td>{dt.Rows[i]["TITLE"]}</td>";
        }






        //for (int i = 0; i <= dt.Rows.Count - 1; i++)
        //{
        //    string TYPE1=dt.Rows[i]["TITLE"].ToString();
        //    TYPE1="'" + TYPE1 + "' AS " + TYPE1 + ""+",";
        //    TYPE = TYPE + TYPE1;
        //}
        //TYPE = TYPE.Substring(0,TYPE.Length-1);
        //sSQL = $@"SELECT "+TYPE+" FROM DUAL ";
        //dt = PubClass.getdatatableMES(sSQL);






        //string titleMessage = $@"<table border='1' style='width:50%;text-align:center;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 13px;'><tr style='background-color:#0a8fbd;color: cornsilk;'>";
        //for (int i = 0; i < dt.Columns.Count; i++)
        //{
        //    titleMessage += $@"<td>{dt.Columns[i].ColumnName}</td>";
        //}
        titleMessage += "</tr>";
        string detailMessage = $@"";
        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_BASE  WHERE NUMBER_ID='{NUMBER_ID}' ORDER BY SEQ";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                detailMessage += $@"<tr style='font-size:14px;'>";
                for (int j = 1; j <= QTY; j++)
                {
                    detailMessage += $@"<td>{dt.Rows[i][dt.Columns[j].ColumnName]}</td>";
                }
            }
        }
        detailMessage += $@"</tr>";
        titleMessage = titleMessage.Trim(' ').Replace("\n", "") + detailMessage.Trim(' ').Replace("\n","") + " </table>";
        return titleMessage;
    }
    public string addTemplateInfo(string user,string Template,string Type1,string Type2,string Type3,string Type4,string Type5,string Type6,string Type7,string Type8,string Type9,string Type10,string Type11,string Type12,string Type13,string Type14,string Type15,string Type16,string Type17,string Type18,string Type19,string Type20)
    {
        string sSQL = "";DataTable dt;string sql = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $@"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG  WHERE  TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        string NUMBER_ID=dt.Rows[0]["NUMBER_ID"].ToString();
        if(Type1!=""&& Type1!=null&& Type1!="null")
        {
            sql = sql + " AND TYPE1 ='" + Type1 + "'";
        }
        if(Type2!=""&& Type2!=null&& Type2!="null")
        {
            sql = sql + " AND TYPE2 ='" + Type2 + "'";
        }
        if(Type3!=""&& Type3!=null&& Type3!="null")
        {
            sql = sql + " AND TYPE3 ='" + Type3 + "'";
        }
        if(Type4!=""&& Type4!=null&& Type4!="null")
        {
            sql = sql + " AND TYPE4 ='" + Type4 + "'";
        }
        if(Type5!=""&& Type5!=null&& Type5!="null")
        {
            sql = sql + " AND TYPE5 ='" + Type5 + "'";
        }
        if(Type6!=""&& Type6!=null&& Type6!="null")
        {
            sql = sql + " AND TYPE6 ='" + Type6 + "'";
        }
        if(Type7!=""&& Type7!=null&& Type7!="null")
        {
            sql = sql + " AND TYPE7 ='" + Type7 + "'";
        }
        if(Type8!=""&& Type8!=null&& Type8!="null")
        {
            sql = sql + " AND TYPE8 ='" + Type8 + "'";
        }
        if(Type9!=""&& Type9!=null&& Type9!="null")
        {
            sql = sql + " AND TYPE9 ='" + Type9 + "'";
        }
        if(Type10!=""&& Type10!=null&& Type10!="null")
        {
            sql = sql + " AND TYPE10 ='" + Type10 + "'";
        }
        if(Type11!=""&& Type11!=null&& Type11!="null")
        {
            sql = sql + " AND TYPE11 ='" + Type11 + "'";
        }
        if(Type12!=""&& Type12!=null&& Type12!="null")
        {
            sql = sql + " AND TYPE12 ='" + Type12 + "'";
        }
        if(Type13!=""&& Type13!=null&& Type13!="null")
        {
            sql = sql + " AND TYPE13 ='" + Type13 + "'";
        }
        if(Type14!=""&& Type14!=null&& Type14!="null")
        {
            sql = sql + " AND TYPE14 ='" + Type14 + "'";
        }
        if(Type15!=""&& Type15!=null&& Type15!="null")
        {
            sql = sql + " AND TYPE15 ='" + Type15 + "'";
        }
        if(Type16!=""&& Type16!=null&& Type16!="null")
        {
            sql = sql + " AND TYPE16 ='" + Type16 + "'";
        }
        if(Type17!=""&& Type17!=null&& Type17!="null")
        {
            sql = sql + " AND TYPE17 ='" + Type17 + "'";
        }
        if(Type18!=""&& Type18!=null&& Type18!="null")
        {
            sql = sql + " AND TYPE18 ='" + Type18 + "'";
        }
        if(Type19!=""&& Type19!=null&& Type19!="null")
        {
            sql = sql + " AND TYPE19 ='" + Type19 + "'";
        }
        if(Type20!=""&& Type20!=null&& Type20!="null")
        {
            sql = sql + " AND TYPE20 ='" + Type20 + "'";
        }
        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_BASE WHERE NUMBER_ID='{NUMBER_ID}'"+sql+"";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此信息已维护过!\"}]";
        }

        string SQL = $"SELECT NVL(MAX(SEQ),0)+1 FROM SAJET.SYS_ECHECK_BASE WHERE NUMBER_ID='{NUMBER_ID}'";
        DataTable dtseq = PubClass.getdatatableMES(SQL);
        string SEQ=dtseq.Rows[0][0].ToString();


        sSQL = $"INSERT INTO SAJET.SYS_ECHECK_BASE(SEQ,CREATE_DATE,CREATE_EMPID,NUMBER_ID,TYPE1,TYPE2,TYPE3,TYPE4,TYPE5,TYPE6,TYPE7,TYPE8,TYPE9,TYPE10,TYPE11,TYPE12,TYPE13,TYPE14,TYPE15,TYPE16,TYPE17,TYPE18,TYPE19,TYPE20)VALUES" +
            $"('{SEQ}',SYSDATE,'{userEmpId}','{NUMBER_ID}','{Type1}','{Type2}','{Type3}','{Type4}','{Type5}','{Type6}','{Type7}','{Type8}','{Type9}','{Type10}','{Type11}','{Type12}','{Type13}','{Type14}','{Type15}','{Type16}','{Type17}','{Type18}','{Type19}','{Type20}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"增加成功!\"}]";
    }


    public string delete(string user,string Template,string Type1,string Type2,string Type3,string Type4,string Type5,string Type6,string Type7,string Type8,string Type9,string Type10,string Type11,string Type12,string Type13,string Type14,string Type15,string Type16,string Type17,string Type18,string Type19,string Type20)
    {
        string sSQL = "";DataTable dt;string sql = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $@"SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG  WHERE  TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        string NUMBER_ID=dt.Rows[0]["NUMBER_ID"].ToString();
        if(Type1!=""&& Type1!=null&& Type1!="null")
        {
            sql = sql + " AND TYPE1 ='" + Type1 + "'";
        }
        if(Type2!=""&& Type2!=null&& Type2!="null")
        {
            sql = sql + " AND TYPE2 ='" + Type2 + "'";
        }
        if(Type3!=""&& Type3!=null&& Type3!="null")
        {
            sql = sql + " AND TYPE3 ='" + Type3 + "'";
        }
        if(Type4!=""&& Type4!=null&& Type4!="null")
        {
            sql = sql + " AND TYPE4 ='" + Type4 + "'";
        }
        if(Type5!=""&& Type5!=null&& Type5!="null")
        {
            sql = sql + " AND TYPE5 ='" + Type5 + "'";
        }
        if(Type6!=""&& Type6!=null&& Type6!="null")
        {
            sql = sql + " AND TYPE6 ='" + Type6 + "'";
        }
        if(Type7!=""&& Type7!=null&& Type7!="null")
        {
            sql = sql + " AND TYPE7 ='" + Type7 + "'";
        }
        if(Type8!=""&& Type8!=null&& Type8!="null")
        {
            sql = sql + " AND TYPE8 ='" + Type8 + "'";
        }
        if(Type9!=""&& Type9!=null&& Type9!="null")
        {
            sql = sql + " AND TYPE9 ='" + Type9 + "'";
        }
        if(Type10!=""&& Type10!=null&& Type10!="null")
        {
            sql = sql + " AND TYPE10 ='" + Type10 + "'";
        }
        if(Type11!=""&& Type11!=null&& Type11!="null")
        {
            sql = sql + " AND TYPE11 ='" + Type11 + "'";
        }
        if(Type12!=""&& Type12!=null&& Type12!="null")
        {
            sql = sql + " AND TYPE12 ='" + Type12 + "'";
        }
        if(Type13!=""&& Type13!=null&& Type13!="null")
        {
            sql = sql + " AND TYPE13 ='" + Type13 + "'";
        }
        if(Type14!=""&& Type14!=null&& Type14!="null")
        {
            sql = sql + " AND TYPE14 ='" + Type14 + "'";
        }
        if(Type15!=""&& Type15!=null&& Type15!="null")
        {
            sql = sql + " AND TYPE15 ='" + Type15 + "'";
        }
        if(Type16!=""&& Type16!=null&& Type16!="null")
        {
            sql = sql + " AND TYPE16 ='" + Type16 + "'";
        }
        if(Type17!=""&& Type17!=null&& Type17!="null")
        {
            sql = sql + " AND TYPE17 ='" + Type17 + "'";
        }
        if(Type18!=""&& Type18!=null&& Type18!="null")
        {
            sql = sql + " AND TYPE18 ='" + Type18 + "'";
        }
        if(Type19!=""&& Type19!=null&& Type19!="null")
        {
            sql = sql + " AND TYPE19 ='" + Type19 + "'";
        }
        if(Type20!=""&& Type20!=null&& Type20!="null")
        {
            sql = sql + " AND TYPE20 ='" + Type20 + "'";
        }
        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_BASE WHERE NUMBER_ID='{NUMBER_ID}'"+sql+"";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此信息不存在!\"}]";
        }
        sSQL = $"DELETE FROM SAJET.SYS_ECHECK_BASE WHERE NUMBER_ID='{NUMBER_ID}'"+sql+"";
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