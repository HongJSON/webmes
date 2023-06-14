<%@ WebHandler Language="C#" Class="E04" %>
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

public class E04 : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string Project_Name = context.Request["Project_Name"];
        string Check_No = context.Request["Check_No"];
        string Check_Name = context.Request["Check_Name"];
        string Check_Item = context.Request["Check_Item"];
        string Section_Name = context.Request["Section_Name"];
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
                rtnValue = addTemplateInfo(Section_Name, user, Project_Name, Check_No, Check_Name, Check_Item);
                break;
            case "del":
                rtnValue = delete(NUMBER_ID, user);
                break;
            case "ShowBuName":
                rtnValue = ShowBuName();
                break;
            case "excel":
                rtnValue = uploadFile(user, context);
                break;


        }
        context.Response.Write(rtnValue);
    }
    public string ShowBuName()
    {
        string sSQL = $@"SELECT SECTON_NAME FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='1' ORDER BY SECTON_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
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
            sql = sql + " AND B.PROJECT_NAME ='" + Project_Name + "'";
        }

        string sSQL = $@"SELECT A.NUMBER_ID,A.PROJECT_ID,B.PROJECT_NAME,A.CHECK_NO,A.CHECK_NAME,A.CHECK_ITEM,A.SECTION_NAME,C.EMP_NAME,D.EMP_NAME AS EMP_NAME1,A.CREATE_DATE,A.UPDATE_DATE FROM SAJET.SYS_ECHECK_PROJECT_BASE A,SAJET.SYS_CHECK_PROJECT_CONFIG B,SAJET.SYS_EMP C,SAJET.SYS_EMP D
                  WHERE A.PROJECT_ID=B.PROJECT_ID
                  AND A.CREATE_EMPID=C.EMP_ID(+)
                  AND A.UPDATE_EMPID=D.EMP_ID(+)" + sql + "  ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    private static string uploadFile(string user, HttpContext context)
    {
        string SEQ = ""; DataTable dt; decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0;
        string LType1 = ""; string LType2 = ""; string LType3 = ""; string LType4 = ""; string LType5 = ""; string LType6 = ""; string LType7 = ""; string LType8 = ""; string LType9 = ""; string LType10 = "";
        string LType11 = ""; string LType12 = ""; string LType13 = ""; string LType14 = ""; string LType15 = ""; string LType16 = ""; string LType17 = ""; string LType18 = ""; string LType19 = ""; string LType20 = "";
        try
        {
            string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

            dt = PubClass.getdatatableMES(sSQL);
            string userEmpId = dt.Rows[0][0].ToString();
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
                        string Section_Name = worksheet.Cells[L, 0].ToString();
                        string Project_Name = worksheet.Cells[L, 1].ToString();
                        string Check_No = worksheet.Cells[L, 2].ToString();
                        string Check_Name = worksheet.Cells[L, 3].ToString();
                        string Check_Item = worksheet.Cells[L, 4].ToString();

                        if (mylist.Contains(Section_Name + Project_Name + Check_No + Check_Name + Check_Item))
                        {
                            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,第" + L + "行存在重复数据!\"}]";

                        }
                        else
                        {
                            mylist.Add(Section_Name + Project_Name + Check_No + Check_Name + Check_Item);
                        }
                        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{Project_Name}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,第" + L + "行制程名称不存在!\"}]";
                        }
                        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();

                        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='1' AND SECTON_NAME='{Section_Name}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,第" + L + "行部门信息不存在!\"}]";
                        }


                        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_PROJECT_BASE  WHERE PROJECT_ID='{PROJECT_ID}' AND CHECK_NO='{Check_No}'AND CHECK_NAME='{Check_Name}'AND CHECK_ITEM='{Check_Item}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count > 0)
                        {
                            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,第" + L + "行事项已维护过!\"}]";
                        }

                    }
                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        string Section_Name = worksheet.Cells[L, 0].ToString();
                        string Project_Name = worksheet.Cells[L, 1].ToString();
                        string Check_No = worksheet.Cells[L, 2].ToString();
                        string Check_Name = worksheet.Cells[L, 3].ToString();
                        string Check_Item = worksheet.Cells[L, 4].ToString();

               
                        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{Project_Name}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,第" + L + "行制程名称不存在!\"}]";
                        }
                        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();

                        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='1' AND SECTON_NAME='{Section_Name}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,第" + L + "行部门信息不存在!\"}]";
                        }


                        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_PROJECT_BASE  WHERE PROJECT_ID='{PROJECT_ID}' AND CHECK_NO='{Check_No}'AND CHECK_NAME='{Check_Name}'AND CHECK_ITEM='{Check_Item}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count > 0)
                        {
                            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,第" + L + "行事项已维护过!\"}]";
                        }
                        string Number_id = Guid.NewGuid().ToString().ToUpper();

                        sSQL = $"INSERT INTO SAJET.SYS_ECHECK_PROJECT_BASE(SECTION_NAME,NUMBER_ID,PROJECT_ID,CHECK_NO,CHECK_NAME,CHECK_ITEM,CREATE_DATE,CREATE_EMPID)VALUES" +
                            $"('{Section_Name}','{Number_id}','{PROJECT_ID}','{Check_No}','{Check_Name}','{Check_Item}',SYSDATE,'{userEmpId}')";
                        PubClass.getdatatablenoreturnMES(sSQL);
                        sSQL = $"INSERT INTO SAJET.SYS_HT_ECHECK_PROJECT_BASE(SECTION_NAME,NUMBER_ID,PROJECT_ID,CHECK_NO,CHECK_NAME,CHECK_ITEM,CREATE_DATE,CREATE_EMPID)VALUES" +
                        $"('{Section_Name}','{Number_id}','{PROJECT_ID}','{Check_No}','{Check_Name}','{Check_Item}',SYSDATE,'{userEmpId}')";
                        PubClass.getdatatablenoreturnMES(sSQL);

                    }
                    fileStream.Close();
                    File.Delete(fname);
                }
            }
        }
        catch (Exception ex)
        {
            return "NG,批量上传失败";
        }

        return "OK,批量上传成功";

    }
    public string addTemplateInfo(string Section_Name, string user, string Project_Name, string Check_No, string Check_Name, string Check_Item)
    {
        string sSQL = ""; DataTable dt; string sql = ""; decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0;
        string LType1 = ""; string LType2 = ""; string LType3 = ""; string LType4 = ""; string LType5 = ""; string LType6 = ""; string LType7 = ""; string LType8 = ""; string LType9 = ""; string LType10 = "";
        string LType11 = ""; string LType12 = ""; string LType13 = ""; string LType14 = ""; string LType15 = ""; string LType16 = ""; string LType17 = ""; string LType18 = ""; string LType19 = ""; string LType20 = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在，请检查!\"}]";

        }
        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{Project_Name}'";
        dt = PubClass.getdatatableMES(sSQL);
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();

        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_PROJECT_BASE  WHERE PROJECT_ID='{PROJECT_ID}' AND CHECK_NO='{Check_No}'AND CHECK_NAME='{Check_Name}'AND CHECK_ITEM='{Check_Item}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此检查事项已维护过，不可重复维护!\"}]";
        }
        string Number_id = Guid.NewGuid().ToString().ToUpper();

        sSQL = $"INSERT INTO SAJET.SYS_ECHECK_PROJECT_BASE(SECTION_NAME,NUMBER_ID,PROJECT_ID,CHECK_NO,CHECK_NAME,CHECK_ITEM,CREATE_DATE,CREATE_EMPID)VALUES" +
            $"('{Section_Name}','{Number_id}','{PROJECT_ID}','{Check_No}','{Check_Name}','{Check_Item}',SYSDATE,'{userEmpId}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_ECHECK_PROJECT_BASE(SECTION_NAME,NUMBER_ID,PROJECT_ID,CHECK_NO,CHECK_NAME,CHECK_ITEM,CREATE_DATE,CREATE_EMPID)VALUES" +
        $"('{Section_Name}','{Number_id}','{PROJECT_ID}','{Check_No}','{Check_Name}','{Check_Item}',SYSDATE,'{userEmpId}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }

    public string delete(string NUMBER_ID, string user)
    {
        string sSQL = ""; DataTable dt; string sql = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";

        }
        sSQL = $"UPDATE  SAJET.SYS_ECHECK_PROJECT_BASE SET UPDATE_DATE=SYSDATE,UPDATE_EMPID='{userEmpId}' WHERE  NUMBER_ID='{NUMBER_ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO  SAJET.SYS_HT_ECHECK_PROJECT_BASE SELECT * FROM SAJET.SYS_ECHECK_PROJECT_BASE WHERE  NUMBER_ID='{NUMBER_ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM    SAJET.SYS_ECHECK_PROJECT_BASE WHERE  NUMBER_ID='{NUMBER_ID}'";
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