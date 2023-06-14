<%@ WebHandler Language="C#" Class="E03" %>
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

public class E03 : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string Template = context.Request["Template"];
       
        string Title = context.Request["Title"];
        string BIAOTI1 = context.Request["BIAOTI1"];
        string TitleType = context.Request["TitleType"];
        string TITLE_TYPE = context.Request["TITLE_TYPE"];
        string TemplateCopy = context.Request["TemplateCopy"];


         string Project_Name = context.Request["Project_Name"];
         string Check_Time = context.Request["Check_Time"];
         string Frequency = context.Request["Frequency"];
         string NUMBER_ID = context.Request["NUMBER_ID"];



        switch (funcName)
        {
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "show":
                rtnValue = show(Project_Name);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(Project_Name, user, Check_Time, Frequency);
                break;
            case "del":
                rtnValue = del(NUMBER_ID, user, Check_Time, Frequency);
                break;
            case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(BIAOTI1, user, Template, Title, TITLE_TYPE);
                break;
            case "excel":
                rtnValue = uploadFile(user, context);
                break;
        }
        context.Response.Write(rtnValue);
    }
    private static string uploadFile(string user, HttpContext context)
    {
        try
        {
            string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

            DataTable dt = PubClass.getdatatableMES(sSQL);
            if (dt.Rows.Count == 0)
            {
                return "用户信息不存在,请检查!";
            }
            string userEmpId = dt.Rows[0][0].ToString();
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
                    int P = worksheet.Cells.LastColIndex + 1;
                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        string Number_id;
                        string Project_Name = worksheet.Cells[L, 0].ToString();
                        string SQL = $"SELECT * FROM SAJET.SYS_CHECK_PROJECT_CONFIG WHERE PROJECT_NAME='{Project_Name}'";
                        dt = PubClass.getdatatableMES(SQL);
                        if (dt.Rows.Count == 0)
                        {
                            Number_id = Guid.NewGuid().ToString().ToUpper();
                            sSQL = $"INSERT INTO SAJET.SYS_CHECK_PROJECT_CONFIG(PROJECT_ID,PROJECT_NAME,CREATE_USERID,CREATE_DATE)VALUES('{Number_id}','{Project_Name}','{userEmpId}',SYSDATE)";
                            PubClass.getdatatablenoreturnMES(sSQL);
                            sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_PROJECT_CONFIG SELECT * FROM SAJET.SYS_CHECK_PROJECT_CONFIG WHERE PROJECT_ID='{Number_id}'";
                        }
                        else
                        {
                            Number_id = dt.Rows[0]["PROJECT_ID"].ToString();
                        }

                        for (int Q = 1; Q < P; Q++)
                        {
                            string title = worksheet.Cells[1, Q].ToString().Split('/')[0];
                            string titleTYPE = worksheet.Cells[1, Q].ToString().Split('/')[1];
                            SQL = $"SELECT * FROM SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{Number_id}' AND CHECK_TIME='{title}' AND FREQUENCY='{titleTYPE}'";
                            dt = PubClass.getdatatableMES(SQL);
                            if (dt.Rows.Count == 0)
                            {
                                sSQL = $"SELECT NVL(MAX(SEQ),0)+1 FROM  SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{Number_id}'";
                                dt = PubClass.getdatatableMES(sSQL);
                                string SEQ = dt.Rows[0][0].ToString();
                                sSQL = $"INSERT INTO SAJET.SYS_CHECK_PROJECT_TITLE(SEQ,CHECK_TIME,FREQUENCY,PROJECT_ID,PROJECT_NAME,CREATE_USERID,CREATE_DATE)VALUES('{SEQ}','{title}','{titleTYPE}','{Number_id}','{Project_Name}','{userEmpId}',SYSDATE)";
                                PubClass.getdatatablenoreturnMES(sSQL);
                                sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_PROJECT_TITLE SELECT * FROM SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{Number_id}'AND CHECK_TIME='{title}' AND FREQUENCY='{titleTYPE}'";
                                PubClass.getdatatablenoreturnMES(sSQL);
                            }
                        }
                    }
                }
            }
        }
        catch
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"上传失败!\"}]";

        }
        return "OK,批量上传成功";
    }
    public string UpdateTemplateInfo1(string BIAOTI1, string user, string Template, string Title, string TITLE_TYPE)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL = $@"UPDATE SAJET.SYS_CHECK_TEMPLATE_TITLE SET TITLE='{BIAOTI1}',UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE PROJECT_NAME='{Template}' AND TITLE='{Title}'AND TITLE_TYPE='{TITLE_TYPE}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,修改成功\"}]";
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT PROJECT_NAME FROM  SAJET.SYS_CHECK_PROJECT_CONFIG ORDER BY  PROJECT_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string Project_Name)
    {
        string sql = "";
        if (Project_Name != "" && Project_Name != null && Project_Name != "null")
        {
            sql = sql + " AND A.PROJECT_NAME ='" + Project_Name + "'";
        }
        string sSQL = $@"SELECT A.PROJECT_ID,A.CHECK_TIME,A.PROJECT_NAME,A.FREQUENCY,A.CREATE_DATE,B.EMP_NAME,A.UPDATE_DATE,C.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_CHECK_PROJECT_TITLE  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE 
                       A.CREATE_USERID=B.EMP_ID(+)
                       AND A.UPDATE_USERID=C.EMP_ID(+)" + sql + " ORDER BY A.SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }



    public string addTemplateInfo(string Project_Name,string user,string Check_Time,string Frequency)
    {
        string sSQL = ""; DataTable dt; string TYPE = "TYPE"; string SEQ = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
         if (!Check_Time.Contains("-"))
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,时间范围错误,例如：08:00-12:00!\"}]";
            }

        sSQL = $"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_NAME='{Project_Name}'AND CHECK_TIME='{Check_Time}'AND FREQUENCY='{Frequency}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"制程名称对应时间范围已维护过\"}]";
        }
        sSQL = $"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG WHERE PROJECT_NAME='{Project_Name}'";
        dt = PubClass.getdatatableMES(sSQL);
        string Number_id = dt.Rows[0]["PROJECT_ID"].ToString();
        sSQL = $"SELECT NVL(MAX(SEQ),0)+1 FROM  SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{Number_id}'";
        dt = PubClass.getdatatableMES(sSQL);
        SEQ = dt.Rows[0][0].ToString();

        sSQL = $"INSERT INTO SAJET.SYS_CHECK_PROJECT_TITLE(SEQ,CHECK_TIME,FREQUENCY,PROJECT_ID,PROJECT_NAME,CREATE_USERID,CREATE_DATE)VALUES('{SEQ}','{Check_Time}','{Frequency}','{Number_id}','{Project_Name}','{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_PROJECT_TITLE SELECT * FROM SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{Number_id}'AND CHECK_TIME='{Check_Time}' AND FREQUENCY='{Frequency}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }

    public string del(string NUMBER_ID,string user,string Check_Time,string Frequency)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";

        }
        sSQL = $"UPDATE SAJET.SYS_CHECK_PROJECT_TITLE SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE PROJECT_ID='{NUMBER_ID}'AND CHECK_TIME='{Check_Time}'AND FREQUENCY='{Frequency}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_PROJECT_TITLE SELECT * FROM SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{NUMBER_ID}'AND CHECK_TIME='{Check_Time}'AND FREQUENCY='{Frequency}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{NUMBER_ID}'AND CHECK_TIME='{Check_Time}'AND FREQUENCY='{Frequency}'";
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