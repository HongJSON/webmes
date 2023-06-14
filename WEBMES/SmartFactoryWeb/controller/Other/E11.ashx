<%@ WebHandler Language="C#" Class="E11" %>
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


public class E11 : IHttpHandler
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
        string Type2 = context.Request["Type2"];
        string Type3 = context.Request["Type3"];
        string Type4 = context.Request["Type4"];
        string Type5 = context.Request["Type5"];
        string Type6 = context.Request["Type6"];
        string Type7 = context.Request["Type7"];
        string ProjectName = context.Request["ProjectName"];
        string JJMo = context.Request["JJMo"];
        string ModelName = context.Request["ModelName"];
        string isAutoAssy = context.Request["isAutoAssy"] == "true" ? "Y" : "N";
        string Check_Name = context.Request["Check_Name"];
        string Frequency = context.Request["Frequency"];
        string Check_Item = context.Request["Check_Item"];
        string Check_Qty = context.Request["Check_Qty"];
        string Upper = context.Request["Upper"];
        string Floor = context.Request["Floor"];
        string Unit = context.Request["Unit"];
        switch (funcName)
        {
            case "ShowModelJJ":
                rtnValue = ShowModelJJ(JJMo);
                break;
            case "ShowModel":
                rtnValue = ShowModel();
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
            case "GetProcess":
                rtnValue = GetProcess(ProjectName);
                break;
            case "GetProcessFrequency":
                rtnValue = GetProcessFrequency(ProjectName);
                break;
            case "GetProcessL":
                rtnValue = GetProcessL(ProjectName, Check_Name);
                break;
            case "Add":
                rtnValue = Add(isAutoAssy, ModelName, user, ProjectName, PdlineName, Frequency, Check_Name, Check_Item, Unit, Check_Qty, Upper, Floor);
                break;
            case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(isAutoAssy, ModelName, user, ProjectName, PdlineName, Frequency, Check_Name, Check_Item, Unit, Check_Qty, Upper, Floor);
                break;
            case "show":
                rtnValue = show(PdlineName, ProjectName, ModelName);
                break;
            case "del":
                rtnValue = del(ModelName, NUMBER_ID, user, ProjectName, PdlineName, Type2, Type3, Type5, Type6);
                break;
            case "excel":
                rtnValue = uploadFile(user, context);
                break;


        }
        context.Response.Write(rtnValue);
    }
    public string ShowModel()
    {
        string sSQL = $@"SELECT MODEL_NAME FROM SAJET.SYS_MODEL WHERE ENABLED='Y'ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowModelJJ(string JJ)
    {
        string sSQL = @"SELECT MODEL_NAME FROM SAJET.SYS_MODEL WHERE ENABLED='Y' AND MODEL_NAME LIKE'" + JJ + "%'ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    private static string uploadFile(string user, HttpContext context)
    {
        decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0;
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
                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        num = 0; num1 = 0; MAX = 0; MIN = 0;
                        string PdlineName = worksheet.Cells[L, 0].ToString();
                        string ModelName = worksheet.Cells[L, 1].ToString();
                        string ProjectName = worksheet.Cells[L, 2].ToString();
                        string Check_Name = worksheet.Cells[L, 3].ToString();
                        string Check_Item = worksheet.Cells[L, 4].ToString();
                        string Unit = worksheet.Cells[L, 5].ToString();
                        string Check_Qty = worksheet.Cells[L, 6].ToString();
                        string Upper = worksheet.Cells[L, 7].ToString();
                        string Floor = worksheet.Cells[L, 8].ToString();
                        string Frequency = worksheet.Cells[L, 9].ToString();
                        sSQL = $@"SELECT * FROM  SAJET.SYS_MODEL  WHERE  MODEL_NAME='{ModelName}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "第" + L + "行机种在MES中不存在";
                        }
                        sSQL = $@"SELECT * FROM  SAJET.SYS_PDLINE  WHERE  PDLINE_NAME='{PdlineName}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "第" + L + "行线体在MES中不存在";
                        }
                        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "第" + L + "行制程不存在";
                        }
                        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();

                        { decimal.TryParse(Upper, out num); if (num != 0) { MAX = double.Parse(Upper); } }
                        { decimal.TryParse(Floor, out num1); if (num1 != 0) { MIN = double.Parse(Floor); } }
                        if (num1 != 0 && num != 0)
                        {
                            if (MAX < MIN)
                            {
                                return "第" + L + "行上限数值小于下限数值";

                            }
                        }
                        sSQL = $"SELECT * FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_ID='{PROJECT_ID}' AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND CHECK_NAME='{Check_Name}'AND CHECK_ITEM='{Check_Item}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count > 0)
                        {
                            return "第" + L + "行此绑定信息已维护过";

                        }
                        sSQL = $"SELECT * FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE  MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}'AND  PROJECT_ID='{PROJECT_ID}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count > 0)
                        {

                            if (dt.Rows[0]["FREQUENCY"].ToString() != Frequency)
                            {
                                return "第" + L + "行机种线体制程已有其他频率信息";
                            }

                        }
                    }
                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        string PdlineName = worksheet.Cells[L, 0].ToString();
                        string ModelName = worksheet.Cells[L, 1].ToString();
                        string ProjectName = worksheet.Cells[L, 2].ToString();
                        string Check_Name = worksheet.Cells[L, 3].ToString();
                        string Check_Item = worksheet.Cells[L, 4].ToString();
                        string Unit = worksheet.Cells[L, 5].ToString();
                        string Check_Qty = worksheet.Cells[L, 6].ToString();
                        string Upper = worksheet.Cells[L, 7].ToString();
                        string Floor = worksheet.Cells[L, 8].ToString();
                        string Frequency = worksheet.Cells[L, 9].ToString();

                        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if (dt.Rows.Count == 0)
                        {
                            return "第" + L + "行制程不存在";
                        }
                        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();
                        sSQL = $"INSERT INTO SAJET.SYS_PROJECT_MODEL_BASE(PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CREATE_DATE,CREATE_EMPID,MODEL_NAME,CHECK_QTY,UPPER,FLOOR)" +
                        $"VALUES('{PROJECT_ID}','{ProjectName}','{PdlineName}','{Frequency}','{Check_Name}','{Check_Item}','{Unit}',SYSDATE,'{userEmpId}','{ModelName}','{Check_Qty}','{Upper}','{Floor}')";
                        PubClass.getdatatablenoreturnMES(sSQL);
                        sSQL = $"INSERT INTO SAJET.SYS_HT_PROJECT_MODEL_BASE(PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CREATE_DATE,CREATE_EMPID,MODEL_NAME,CHECK_QTY,UPPER,FLOOR)" +
                            $"VALUES('{PROJECT_ID}','{ProjectName}','{PdlineName}','{Frequency}','{Check_Name}','{Check_Item}','{Unit}',SYSDATE,'{userEmpId}','{ModelName}','{Check_Qty}','{Upper}','{Floor}')";
                        PubClass.getdatatablenoreturnMES(sSQL);
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



    public string del(string ModelName, string NUMBER_ID, string user, string ProjectName, string PdlineName, string Type2, string Type3, string Type5, string Type6)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        string sSQL = $"UPDATE SAJET.SYS_PROJECT_MODEL_BASE SET UPDATE_EMPID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE PROJECT_ID='{NUMBER_ID}' AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND  TYPE2='{Type2}' AND TYPE3='{Type3}'";
        PubClass.getdatatablenoreturnMES(sSQL);

        sSQL = $"INSERT INTO SAJET.SYS_HT_PROJECT_MODEL_BASE SELECT * FROM SAJET.SYS_PROJECT_PDLINE_BASE WHERE PROJECT_ID='{NUMBER_ID}' AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND  TYPE2='{Type2}' AND TYPE3='{Type3}'";
        PubClass.getdatatablenoreturnMES(sSQL);



        sSQL = $"DELETE FROM  SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_ID='{NUMBER_ID}'AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND  TYPE2='{Type2}' AND TYPE3='{Type3}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功!\"}]";
    }
    public string UpdateTemplateInfo1(string isAutoAssy, string ModelName, string user, string ProjectName, string PdlineName, string Frequency, string Check_Name, string Check_Item, string Unit, string Check_Qty, string Upper, string Floor)
    {
        decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0;
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"制程不存在\"}]";
        }
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();
        { decimal.TryParse(Upper, out num); if (num != 0) { MAX = double.Parse(Upper); } }
        { decimal.TryParse(Floor, out num1); if (num1 != 0) { MIN = double.Parse(Floor); } }
        if (num1 != 0 && num != 0)
        {
            if (MAX < MIN)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"上限数值小于下限数值!\"}]";
            }
        }

        sSQL = $"UPDATE SAJET.SYS_PROJECT_MODEL_BASE SET STATUS='{isAutoAssy}'WHERE PROJECT_ID='{PROJECT_ID}' AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}'";
        PubClass.getdatatablenoreturnMES(sSQL);

        sSQL = $"UPDATE SAJET.SYS_PROJECT_MODEL_BASE SET CHECK_QTY='{Check_Qty}',UPPER='{Upper}',FLOOR='{Floor}',Unit='{Unit}',UPDATE_EMPID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE PROJECT_ID='{PROJECT_ID}' AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND  CHECK_NAME='{Check_Name}' AND CHECK_ITEM='{Check_Item}'";
        PubClass.getdatatablenoreturnMES(sSQL);

        sSQL = $"INSERT INTO SAJET.SYS_HT_PROJECT_MODEL_BASE SELECT * FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_ID='{PROJECT_ID}' AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND  CHECK_NAME='{Check_Name}' AND CHECK_ITEM='{Check_Item}'";
        PubClass.getdatatablenoreturnMES(sSQL);


        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"修改成功!\"}]";
    }
    public string Add(string isAutoAssy, string ModelName, string user, string ProjectName, string PdlineName, string Frequency, string Check_Name, string Check_Item, string Unit, string Check_Qty, string Upper, string Floor)
    {
        decimal num = 0; decimal num1 = 0; double MAX = 0; double MIN = 0;
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"制程不存在\"}]";
        }
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();

        { decimal.TryParse(Upper, out num); if (num != 0) { MAX = double.Parse(Upper); } }
        { decimal.TryParse(Floor, out num1); if (num1 != 0) { MIN = double.Parse(Floor); } }
        if (num1 != 0 && num != 0)
        {
            if (MAX < MIN)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"上限数值小于下限数值!\"}]";
            }
        }
        sSQL = $"SELECT * FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE  MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND STATUS ='Y'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            if (isAutoAssy == "Y")
            {
                if (dt.Rows[0]["PROJECT_ID"].ToString() != PROJECT_ID)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"机种线体已有其他制程项目设为唯一标题信息!\"}]";
                }
            }
        }

        sSQL = $"SELECT * FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE  MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}'AND  PROJECT_ID='{PROJECT_ID}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {

            if (dt.Rows[0]["FREQUENCY"].ToString() != Frequency)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"机种线体制程已有其他频率信息!\"}]";
            }

        }


        sSQL = $"SELECT * FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PROJECT_ID='{PROJECT_ID}'AND MODEL_NAME='{ModelName}' AND PDLINE_NAME='{PdlineName}' AND CHECK_NAME='{Check_Name}'AND CHECK_ITEM='{Check_Item}'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此绑定信息已维护过\"}]";
        }
        sSQL = $"INSERT INTO SAJET.SYS_PROJECT_MODEL_BASE(PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CREATE_DATE,CREATE_EMPID,MODEL_NAME,CHECK_QTY,UPPER,FLOOR,STATUS)" +
            $"VALUES('{PROJECT_ID}','{ProjectName}','{PdlineName}','{Frequency}','{Check_Name}','{Check_Item}','{Unit}',SYSDATE,'{userEmpId}','{ModelName}','{Check_Qty}','{Upper}','{Floor}','{isAutoAssy}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_PROJECT_MODEL_BASE(PROJECT_ID,PROJECT_NAME,PDLINE_NAME,FREQUENCY,CHECK_NAME,CHECK_ITEM,UNIT,CREATE_DATE,CREATE_EMPID,MODEL_NAME,CHECK_QTY,UPPER,FLOOR,STATUS)" +
            $"VALUES('{PROJECT_ID}','{ProjectName}','{PdlineName}','{Frequency}','{Check_Name}','{Check_Item}','{Unit}',SYSDATE,'{userEmpId}','{ModelName}','{Check_Qty}','{Upper}','{Floor}','{isAutoAssy}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }
    public string GetProcess(string ProjectName)
    {
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此点检制程不存在\"}]";
        }
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();
        sSQL = $"SELECT DISTINCT CHECK_NAME FROM SAJET.SYS_ECHECK_PROJECT_BASE WHERE PROJECT_ID='{PROJECT_ID}'";
        dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetProcessFrequency(string ProjectName)
    {
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此点检制程不存在\"}]";
        }
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();
        sSQL = $"SELECT DISTINCT FREQUENCY FROM  SAJET.SYS_CHECK_PROJECT_TITLE WHERE PROJECT_ID='{PROJECT_ID}'";
        dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetProcessL(string ProjectName, string Check_Name)
    {
        string sSQL = $@"SELECT * FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  WHERE  PROJECT_NAME='{ProjectName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此点检制程不存在\"}]";
        }
        string PROJECT_ID = dt.Rows[0]["PROJECT_ID"].ToString();
        sSQL = $"SELECT DISTINCT CHECK_ITEM FROM SAJET.SYS_ECHECK_PROJECT_BASE WHERE PROJECT_ID='{PROJECT_ID}' AND CHECK_NAME='{Check_Name}' ORDER BY CHECK_NO";
        dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string show(string PdlineName, string ProjectName, string ModelName)
    {
        string sql = "";
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (ProjectName != "" && ProjectName != null && ProjectName != "null")
        {
            sql = sql + " AND A.PROJECT_NAME ='" + ProjectName + "'";
        }
        if (ModelName != "" && ModelName != null && ModelName != "null")
        {
            sql = sql + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
             string SQL = $"SELECT A.PROJECT_NO,A.CHECK_NO,A.STATUS,A.MODEL_NAME,A.PROJECT_ID,A.PROJECT_NAME,A.PDLINE_NAME,A.FREQUENCY,A.CHECK_NAME,A.CHECK_ITEM,A.UNIT,A.CHECK_QTY,A.UPPER,A.FLOOR,B.EMP_NAME,A.create_date,c.EMP_NAME AS EMP_NAME1,A.UPDATE_date FROM SAJET.SYS_HT_PROJECT_MODEL_BASE A,SAJET.SYS_EMP B,SAJET.SYS_EMP C " +
            $" WHERE A.create_empid=B.EMP_ID(+) AND A.UPDATE_empid=C.EMP_ID(+) " + sql + " ORDER BY CREATE_DATE";
        DataTable dt = PubClass.getdatatableMES(SQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'  ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME LIKE'" + JJ + "%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT PROJECT_NAME FROM  SAJET.SYS_CHECK_PROJECT_CONFIG  ORDER BY  PROJECT_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
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