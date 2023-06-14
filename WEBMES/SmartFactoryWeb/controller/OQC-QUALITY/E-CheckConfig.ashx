<%@ WebHandler Language="C#" Class="ECheckConfig" %>

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

public class ECheckConfig : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string Processname = context.Request["Processname"];
        string CheckPoint = context.Request["CheckPoint"];
        string Floor = context.Request["Floor"];
        string Upper = context.Request["Upper"];
        string Unit = context.Request["Unit"];
        string ModelName = context.Request["ModelName"];
        string PROCESS_NAME = context.Request["PROCESS_NAME"];
        string ITEM = context.Request["ITEM"];
        string MODEL_NAME = context.Request["MODEL_NAME"];
        string NUMID = context.Request["NUMID"];
        string file = context.Request["Path"];
        string Cqp = context.Request["Cqp"];
        string Template = context.Request["Template"];
        switch (funcName)
        {
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(user,Processname,CheckPoint,Floor,Upper,Unit,ModelName,Cqp,Template);
                break;
            case "show":
                rtnValue = show(Processname,CheckPoint,Floor,Upper,Unit,ModelName,Cqp,Template);
                break;
            case "del":
                rtnValue = del(PROCESS_NAME, ITEM,MODEL_NAME, user,Cqp,Template);
                break;
            case "UpdateTemplateInfo":
                rtnValue = UpdateTemplateInfo(user,Processname,CheckPoint,Floor,Upper,Unit,ModelName,NUMID,Cqp,Template);
                break;
            case "excel":
                rtnValue = uploadFile(user,context);
                break;
             case "table":
                rtnValue = getTable(Processname,CheckPoint,Floor,Upper,Unit,ModelName,Cqp,Template);
                break;
        }
        context.Response.Write(rtnValue);
    }



    private static string uploadFile(string user,HttpContext context)
    {
        try
        {
            string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

            DataTable dt = PubClass.getdatatableMES(sSQL);
            string userEmpId=dt.Rows[0][0].ToString();
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
                        string Processname = worksheet.Cells[L, 0].ToString();//
                        string CheckPoint = worksheet.Cells[L, 1].ToString();
                        string Upper = worksheet.Cells[L, 2].ToString();
                        string Floor = worksheet.Cells[L, 3].ToString();
                        string Unit = worksheet.Cells[L, 4].ToString();
                        string ModelName = worksheet.Cells[L, 5].ToString();
                        string Cqp = worksheet.Cells[L, 6].ToString();
                        string Template = worksheet.Cells[L, 7].ToString();
                        string FALG = "N";string FALG1 = "N";
                        try
                        {
                            int.Parse(Floor);FALG = "Y";
                        }
                        catch
                        {
                            FALG = "N";
                        }
                        try
                        {
                            int.Parse(Upper); FALG1 = "Y";
                        }
                        catch
                        {
                            FALG = "N";
                        }
                        if(FALG=="Y"&&FALG1== "Y")
                        {
                            if(int.Parse(Floor)>int.Parse(Upper))
                            {
                                return "NG,第"+L+"行管控上限不可小于管控下限!";
                            }
                        }
                        if(FALG=="Y"&&FALG1== "N")
                        {
                            return "NG,第"+L+"行管控上下限需均为数字";
                        }
                        if(FALG=="N"&&FALG1== "Y")
                        {
                            return "NG,第"+L+"行管控上下限需均为数字!";
                        }
                        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE PROCESS_NAME='{Processname}' AND MODEL_NAME='{ModelName}'AND CHECK_POINT='{CheckPoint}' AND CQP='{Cqp}'AND TEMPLATE='{Template}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if(dt.Rows.Count > 0)
                        {
                            return "NG,第"+L+"行机种,制程,检查项目已存在";
                        }
                        sSQL = $"SELECT * FROM SAJET.SYS_MODEL WHERE MODEL_NAME='{ModelName}' AND ENABLED='Y'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if(dt.Rows.Count == 0)
                        {
                            return "NG,第"+L+"行" + ModelName + "机种不存在";
                        }
                        sSQL = $"SELECT * FROM SAJET.SYS_PROCESS WHERE PROCESS_NAME='{Processname}'AND ENABLED='Y'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if(dt.Rows.Count == 0)
                        {
                            return "NG,第"+L+"行" + Processname + "制程不存在";
                        }
                        if(mylist.Contains(Processname+ModelName+CheckPoint))
                        {
                            return "NG,第"+L+"行存在机种制程检查项目重复数据!";
                        }
                        else
                        {
                            mylist.Add(Processname + ModelName + CheckPoint);
                        }
                    }
                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                       string Processname = worksheet.Cells[L, 0].ToString();//
                        string CheckPoint = worksheet.Cells[L, 1].ToString();
                        string Upper = worksheet.Cells[L, 2].ToString();
                        string Floor = worksheet.Cells[L, 3].ToString();
                        string Unit = worksheet.Cells[L, 4].ToString();
                        string ModelName = worksheet.Cells[L, 5].ToString();
                        string Cqp = worksheet.Cells[L, 6].ToString();
                        string Template = worksheet.Cells[L, 7].ToString();
                        string recordID = Guid.NewGuid().ToString().ToUpper();
                        string NUMBER_ID = "1";
                        sSQL = "SELECT * FROM SAJET.SYS_ECHECK_CONFIG";
                        dt = PubClass.getdatatableMES(sSQL);
                        if(dt.Rows.Count > 0)
                        {
                            sSQL = "SELECT MAX(NUMBER_ID)+1 FROM SAJET.SYS_ECHECK_CONFIG";
                            dt = PubClass.getdatatableMES(sSQL);
                            NUMBER_ID = dt.Rows[0][0].ToString();
                        }
                        string ITEM = "1";
                        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE PROCESS_NAME='{Processname}' AND MODEL_NAME='{ModelName}' AND CQP='{Cqp}' AND TEMPLATE='{Template}'";
                        dt = PubClass.getdatatableMES(sSQL);
                        if(dt.Rows.Count > 0)
                        {
                            sSQL = $"SELECT MAX(ITEM)+1 FROM SAJET.SYS_ECHECK_CONFIG WHERE PROCESS_NAME='{Processname}' AND MODEL_NAME='{ModelName}'AND CQP='{Cqp}'AND TEMPLATE='{Template}'";
                            dt = PubClass.getdatatableMES(sSQL);
                            ITEM = dt.Rows[0][0].ToString();
                        }
                        sSQL = $@"INSERT INTO SAJET.SYS_ECHECK_CONFIG
                        (NUMBER_ID, PROCESS_NAME, ITEM, CHECK_POINT, UPPER, FLOOR,UNIT,MODEL_NAME,CREATE_USERID,CREATE_DATE,UPDATE_USERID,UPDATE_DATE,UUID,CQP,TEMPLATE)
                        VALUES(
                        '{NUMBER_ID}', '{Processname}','{ITEM}', '{CheckPoint}', {Upper},'{Floor}','{Unit}','{ModelName}','{userEmpId}',SYSDATE,'','','{recordID}','{Cqp}','{Template}')";
                        PubClass.getdatatablenoreturnMES(sSQL);
                        sSQL = $@"INSERT INTO SAJET.SYS_HT_ECHECK_CONFIG SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE  UUID='{recordID}'";
                        PubClass.getdatatablenoreturnMES(sSQL);
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


    public class VMSN
    {
        public string MODEL_NAME { get; set; }
        public string PROJECT_NAME { get; set; }
    }
    List<VMSN> sns = new List<VMSN>();

    private string del(string PROCESS_NAME,string ITEM,string MODEL_NAME,string user,string Cqp,string Template)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE PROCESS_NAME='{PROCESS_NAME}' AND MODEL_NAME='{MODEL_NAME}' AND ITEM='{ITEM}' AND CQP='{Cqp}'AND TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);

        string UUID=dt.Rows[0]["UUID"].ToString();
        sSQL = $@"UPDATE SAJET.SYS_ECHECK_CONFIG SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE UUID='{UUID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO SAJET.SYS_HT_ECHECK_CONFIG SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE  UUID='{UUID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"DELETE FROM  SAJET.SYS_ECHECK_CONFIG WHERE  UUID='{UUID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功\"}]";
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

    public string UpdateTemplateInfo(string user,string Processname,string CheckPoint,string Floor,string Upper,string Unit,string ModelName,string NUMID,string Cqp,string Template)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        string FALG = "N";string FALG1 = "N";
        try
        {
            int.Parse(Floor);
            FALG = "Y";
        }
        catch
        {
            FALG = "N";
        }
        try
        {
            int.Parse(Upper);
            FALG1 = "Y";
        }
        catch
        {
            FALG = "N";
        }
        if(FALG=="Y"&&FALG1== "Y")
        {
            if(int.Parse(Floor)>int.Parse(Upper))
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"管控上限不可小于管控下限!\"}]";
            }
        }
        if(FALG=="Y"&&FALG1== "N")
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"管控上下限需均为数字!\"}]";
        }
        if(FALG=="N"&&FALG1== "Y")
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"管控上下限需均为数字!\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_MODEL WHERE MODEL_NAME='{ModelName}' AND ENABLED='Y'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + ModelName + "机种不存在!\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_PROCESS WHERE PROCESS_NAME='{Processname}'AND ENABLED='Y'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + Processname + "制程不存在!\"}]";
        }
        sSQL = $@"UPDATE  SAJET.SYS_ECHECK_CONFIG SET PROCESS_NAME='{Processname}',CQP='{Cqp}',CHECK_POINT='{CheckPoint}',UPPER='{Upper}',FLOOR='{Floor}',UNIT='{Unit}',MODEL_NAME='{ModelName}',TEMPLATE='{Template}',UPDATE_DATE=SYSDATE,UPDATE_USERID='{userEmpId}' WHERE UUID='{NUMID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO SAJET.SYS_HT_ECHECK_CONFIG SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE  UUID='{NUMID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"修改成功!\"}]";
    }

    public string addTemplateInfo(string user,string Processname,string CheckPoint,string Floor,string Upper,string Unit,string ModelName,string Cqp,string Template)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }

        string FALG = "N";string FALG1 = "N";
        try
        {
            int.Parse(Floor);
            FALG = "Y";
        }
        catch
        {
            FALG = "N";
        }
        try
        {
            int.Parse(Upper);
            FALG1 = "Y";
        }
        catch
        {
            FALG = "N";
        }
        if(FALG=="Y"&&FALG1== "Y")
        {
            if(int.Parse(Floor)>int.Parse(Upper))
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"管控上限不可小于管控下限!\"}]";
            }
        }
        if(FALG=="Y"&&FALG1== "N")
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"管控上下限需均为数字!\"}]";
        }
        if(FALG=="N"&&FALG1== "Y")
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"管控上下限需均为数字!\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE PROCESS_NAME='{Processname}' AND MODEL_NAME='{ModelName}'AND CHECK_POINT='{CheckPoint}' AND CQP='{Cqp}'AND TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"机种,制程,检查项目已存在!\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_MODEL WHERE MODEL_NAME='{ModelName}' AND ENABLED='Y'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + ModelName + "机种不存在!\"}]";
        }
        sSQL = $"SELECT * FROM SAJET.SYS_PROCESS WHERE PROCESS_NAME='{Processname}'AND ENABLED='Y'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + Processname + "制程不存在!\"}]";
        }
        string recordID = Guid.NewGuid().ToString().ToUpper();
        string NUMBER_ID = "1";
        sSQL = "SELECT * FROM SAJET.SYS_ECHECK_CONFIG";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count > 0)
        {
            sSQL = "SELECT MAX(NUMBER_ID)+1 FROM SAJET.SYS_ECHECK_CONFIG";
            dt = PubClass.getdatatableMES(sSQL);
            NUMBER_ID = dt.Rows[0][0].ToString();
        }
        string ITEM = "1";
        sSQL = $"SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE PROCESS_NAME='{Processname}' AND MODEL_NAME='{ModelName}' AND CQP='{Cqp}'AND TEMPLATE='{Template}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count > 0)
        {
            sSQL = $"SELECT MAX(ITEM)+1 FROM SAJET.SYS_ECHECK_CONFIG WHERE PROCESS_NAME='{Processname}' AND MODEL_NAME='{ModelName}'AND CQP='{Cqp}'AND TEMPLATE='{Template}'";
            dt = PubClass.getdatatableMES(sSQL);
            ITEM = dt.Rows[0][0].ToString();
        }
        sSQL = $@"INSERT INTO SAJET.SYS_ECHECK_CONFIG
                        (NUMBER_ID, PROCESS_NAME, ITEM, CHECK_POINT, UPPER, FLOOR,UNIT,MODEL_NAME,CREATE_USERID,CREATE_DATE,UPDATE_USERID,UPDATE_DATE,UUID,CQP,TEMPLATE)
                        VALUES(
                        '{NUMBER_ID}', '{Processname}','{ITEM}', '{CheckPoint}', {Upper},'{Floor}','{Unit}','{ModelName}','{userEmpId}',SYSDATE,'','','{recordID}','{Cqp}','{Template}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO SAJET.SYS_HT_ECHECK_CONFIG SELECT * FROM SAJET.SYS_ECHECK_CONFIG WHERE  UUID='{recordID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }

    private string getTable(string Processname,string CheckPoint,string Floor,string Upper,string Unit,string ModelName,string Cqp,string Template)
    {
                string sql = "";
        if(Processname!=""&& Processname!=null&& Processname!="null")
        {
            sql = sql + " AND A.PROCESS_NAME ='" + Processname + "'";
        }
        if(Cqp!=""&& Cqp!=null&& Cqp!="null")
        {
            sql = sql + " AND A.CQP ='" + Cqp + "'";
        }
        if(Template!=""&& Template!=null&& Template!="null")
        {
            sql = sql + " AND A.TEMPLATE ='" + Template + "'";
        }
        if(CheckPoint!=""&& CheckPoint!=null&& CheckPoint!="null")
        {
            sql = sql + " AND A.CHECK_POINT ='" + CheckPoint + "'";
        }
        if(Floor!=""&& Floor!=null&& Floor!="null")
        {
            sql = sql + " AND A.FLOOR ='" + Floor + "'";
        }
        if(Upper!=""&& Upper!=null&& Upper!="null")
        {
            sql = sql + " AND A.UPPER ='" + Upper + "'";
        }
        if(Unit!=""&& Unit!=null&& Unit!="null")
        {
            sql = sql + " AND A.UNIT ='" + Unit + "'";
        }
        if(ModelName!=""&& ModelName!=null&& ModelName!="null")
        {
            sql = sql + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        string sSQL = $@"SELECT A.TEMPLATE,A.CQP,A.NUMBER_ID,A.PROCESS_NAME,A.ITEM,A.CHECK_POINT,A.UPPER,A.FLOOR,A.UNIT,A.MODEL_NAME,A.UUID,A.CREATE_DATE,B.EMP_NAME,C.EMP_NAME AS EMP_NAME1 ,A.UPDATE_DATE FROM SAJET.SYS_ECHECK_CONFIG  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE A.CREATE_USERID=B.EMP_ID(+) AND A.UPDATE_USERID=C.EMP_ID(+)"+sql+" ORDER BY NUMBER_ID";
        DataTable dt = PubClass.getdatatable(sSQL);
        string rtnValue = JsonConvert.SerializeObject(dt);
        return rtnValue;
    }


    public string show(string Processname,string CheckPoint,string Floor,string Upper,string Unit,string ModelName,string Cqp,string Template)
    {
        string sql = "";
        if(Processname!=""&& Processname!=null)
        {
            sql = sql + " AND A.PROCESS_NAME ='" + Processname + "'";
        }
        if(Cqp!=""&& Cqp!=null)
        {
            sql = sql + " AND A.CQP ='" + Cqp + "'";
        }
        if(Template!=""&& Template!=null)
        {
            sql = sql + " AND A.TEMPLATE ='" + Template + "'";
        }
        if(CheckPoint!=""&& CheckPoint!=null)
        {
            sql = sql + " AND A.CHECK_POINT ='" + CheckPoint + "'";
        }
        if(Floor!=""&& Floor!=null)
        {
            sql = sql + " AND A.FLOOR ='" + Floor + "'";
        }
        if(Upper!=""&& Upper!=null)
        {
            sql = sql + " AND A.UPPER ='" + Upper + "'";
        }
        if(Unit!=""&& Unit!=null)
        {
            sql = sql + " AND A.UNIT ='" + Unit + "'";
        }
        if(ModelName!=""&& ModelName!=null)
        {
            sql = sql + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        string sSQL = $@"SELECT A.TEMPLATE,A.CQP,A.NUMBER_ID,A.PROCESS_NAME,A.ITEM,A.CHECK_POINT,A.UPPER,A.FLOOR,A.UNIT,A.MODEL_NAME,A.UUID,A.CREATE_DATE,B.EMP_NAME,C.EMP_NAME AS EMP_NAME1 ,A.UPDATE_DATE FROM SAJET.SYS_ECHECK_CONFIG  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE A.CREATE_USERID=B.EMP_ID(+) AND A.UPDATE_USERID=C.EMP_ID(+)"+sql+" ORDER BY NUMBER_ID";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}