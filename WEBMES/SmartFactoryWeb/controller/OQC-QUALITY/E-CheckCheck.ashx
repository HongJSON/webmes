<%@ WebHandler Language="C#" Class="ECheckCheck" %>
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

public class ECheckCheck : IHttpHandler
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
        string ModelName = context.Request["ModelName"];
        string PROCESS_NAME = context.Request["PROCESS_NAME"];
        string ITEM = context.Request["ITEM"];
        string MODEL_NAME = context.Request["MODEL_NAME"];
        string NUMID = context.Request["NUMID"];
        string file = context.Request["Path"];
        string Cqp = context.Request["Cqp"];
        string Template = context.Request["Template"];
        string time6 = context.Request["time6"];
        string time5 = context.Request["time5"];
        string time4 = context.Request["time4"];
        string time3 = context.Request["time3"];
        string time2 = context.Request["time2"];
        string time1 = context.Request["time1"];
        string didian = context.Request["didian"];
        string jianchayuanyuan = context.Request["jianchayuanyuan"];
        string banbie = context.Request["banbie"];
        string liaohao = context.Request["liaohao"];
        string gongdan = context.Request["gongdan"];
        string datetimepicker1 = context.Request["datetimepicker1"];
        string datetimepicker = context.Request["datetimepicker"];
        string Upper = context.Request["Upper"];
        string Unit = context.Request["Unit"];
        string Floor = context.Request["Floor"];


        switch (funcName)
        {
            case "show":
                rtnValue = show(Processname,CheckPoint,ModelName,Cqp,Template,datetimepicker);
                break;
            case "ShowModel":
                rtnValue = ShowModel();
                break;
            case "GetTemplate":
                rtnValue = GetTemplate(ModelName);
                break;
            case "GetCqp":
                rtnValue = GetCqp(ModelName,Template);
                break;
            case "GetProcess":
                rtnValue = GetProcess(ModelName,Template,Cqp);
                break;
            case "GetPoint":
                rtnValue = GetPoint(ModelName,Template,Cqp,PROCESS_NAME);
                break;
            case "CheckPoint":
                rtnValue = CheckPointN(ModelName,Template,Cqp,PROCESS_NAME,CheckPoint);
                break;
            case "insertNew":
                rtnValue = insertNew(time6,time5,time4,time3,time2,time1,didian,jianchayuanyuan,banbie,liaohao,gongdan,datetimepicker1,user,Processname,CheckPoint, Floor,Upper,Unit, ModelName,Cqp,Template);
                break;
            case "insertNew1":
                rtnValue = insertNew1(time6,time5,time4,time3,time2,time1,didian,jianchayuanyuan,banbie,liaohao,gongdan,datetimepicker1,user,Processname,CheckPoint, Floor,Upper,Unit, ModelName,Cqp,Template);
                break;
        }
        context.Response.Write(rtnValue);
    }
    public string ShowModel()
    {
        string sSQL = $@"SELECT DISTINCT MODEL_NAME FROM SAJET.SYS_ECHECK_CONFIG  ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string GetTemplate(string ModelName)
    {
        string sSQL = $@"SELECT DISTINCT TEMPLATE FROM SAJET.SYS_ECHECK_CONFIG WHERE MODEL_NAME ='{ModelName}'  ORDER BY TEMPLATE ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetCqp(string ModelName,string Template)
    {
        string sSQL = $@"SELECT DISTINCT CQP FROM SAJET.SYS_ECHECK_CONFIG WHERE MODEL_NAME ='{ModelName}' AND TEMPLATE='{Template}'  ORDER BY CQP";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetProcess(string ModelName,string Template,string Cqp)
    {
        string sSQL = $@"SELECT DISTINCT PROCESS_NAME FROM SAJET.SYS_ECHECK_CONFIG WHERE MODEL_NAME ='{ModelName}' AND TEMPLATE='{Template}'AND CQP='{Cqp}'  ORDER BY PROCESS_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetPoint(string ModelName,string Template,string Cqp,string PROCESS_NAME)
    {
        string sSQL = $@"SELECT DISTINCT CHECK_POINT FROM SAJET.SYS_ECHECK_CONFIG WHERE MODEL_NAME ='{ModelName}' AND TEMPLATE='{Template}'AND CQP='{Cqp}'AND PROCESS_NAME='{PROCESS_NAME}'  ORDER BY CHECK_POINT";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string CheckPointN(string ModelName,string Template,string Cqp,string PROCESS_NAME,string CheckPoint)
    {
        string sSQL = $@"SELECT FLOOR,UPPER,UNIT FROM SAJET.SYS_ECHECK_CONFIG WHERE MODEL_NAME ='{ModelName}' AND TEMPLATE='{Template}'AND CQP='{Cqp}'AND PROCESS_NAME='{PROCESS_NAME}'AND CHECK_POINT='{CheckPoint}' ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return "[{\"ERR_CODE\":\""+dt.Rows[0]["UPPER"].ToString()+"\",\"ERR_MSG\":\""+dt.Rows[0]["FLOOR"].ToString()+"\",\"ERR_MSG1\":\""+dt.Rows[0]["UNIT"].ToString()+"\"}]";
    }
    public string insertNew(string time6,string time5,string time4,string time3,string time2,string time1,string didian,string jianchayuanyuan,string banbie,string liaohao,string gongdan,string datetimepicker1,string user,string Processname,string CheckPoint,string  Floor,string Upper,string Unit,string ModelName,string Cqp,string Template)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo("12650378");
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"SELECT * FROM SAJET.G_ECHECK_RESULT WHERE YEAR_DATE='{datetimepicker1}'AND MODEL_NAME='{ModelName}'AND PROCESS_NAME='{Processname}' AND TEMPLATE='{Template}'AND CQP='{Cqp}'AND CHECK_POINT='{CheckPoint}'AND CLASS_TYPE='{banbie}'";
        dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\""+datetimepicker1+"所对应数据已新增过！\"}]";
        }
        sSQL = $"INSERT INTO SAJET.G_ECHECK_RESULT(YEAR_DATE,MODEL_NAME,PROCESS_NAME,TEMPLATE,CQP,CHECK_POINT,UPPER,FLOOR,WORK_ORDER,PART_NO,CLASS_TYPE,CHECK_USER,PLACE,TIME1,TIME2,TIME3,TIME4,TIME5,TIME6,UNIT,CREATE_USERID,CREATE_DATE)" +
               $"VALUES('{datetimepicker1}','{ModelName}','{Processname}','{Template}','{Cqp}','{CheckPoint}','{Upper}','{Floor}'," +
               $"'{gongdan}','{liaohao}','{banbie}','{jianchayuanyuan}','{didian}','{time1}','{time2}','{time3}','{time4}','{time5}','{time6}','{Unit}','{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"增加成功\"}]";
    }
    public string insertNew1(string time6,string time5,string time4,string time3,string time2,string time1,string didian,string jianchayuanyuan,string banbie,string liaohao,string gongdan,string datetimepicker1,string user,string Processname,string CheckPoint,string  Floor,string Upper,string Unit,string ModelName,string Cqp,string Template)
    {
        string sSQL = "";DataTable dt;
        string userEmpId = getEmpIdByNo("12650378");
        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }
        sSQL = $"UPDATE SAJET.G_ECHECK_RESULT SET WORK_ORDER='{gongdan}',PART_NO='{liaohao}',CHECK_USER='{jianchayuanyuan}',PLACE='{didian}'," +
            $"TIME1='{time1}',TIME2='{time2}',TIME3='{time3}',TIME4='{time4}',TIME5='{time5}',TIME6='{time6}'   WHERE YEAR_DATE='{datetimepicker1}'AND MODEL_NAME='{ModelName}'AND PROCESS_NAME='{Processname}' AND TEMPLATE='{Template}'AND CQP='{Cqp}'AND CHECK_POINT='{CheckPoint}'AND CLASS_TYPE='{banbie}'";
        PubClass.getdatatablenoreturnMES(sSQL);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"编辑成功\"}]";
    }




    public string show(string Processname,string CheckPoint,string ModelName,string Cqp,string Template,string datetimepicker)
    {
        string sql = "";
        if(Template!=""&& Template!=null&& Template!="null")
        {
            sql = sql + " AND A.TEMPLATE_POINT ='" + Template + "'";
        }
        if(ModelName!=""&& ModelName!=null&& ModelName!="null")
        {
            sql = sql + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        if(Cqp!=""&& Cqp!=null&& Cqp!="null")
        {
            sql = sql + " AND A.CQP ='" + Cqp + "'";
        }
        if(Processname!=""&& Processname!=null&& Processname!="null")
        {
            sql = sql + " AND A.PROCESS_NAME ='" + Processname + "'";
        }
        if(datetimepicker!=""&& datetimepicker!=null&& datetimepicker!="null")
        {
            sql = sql + " AND A.YEAR_DATE ='" + datetimepicker + "'";
        }
        if(CheckPoint!=""&& CheckPoint!=null&& CheckPoint!="null")
        {
            sql = sql + " AND A.CHECK_POINT ='" + CheckPoint + "'";
        }
        string sSQL = $@"SELECT A.MODEL_NAME,A.PROCESS_NAME,A.TEMPLATE,A.CQP,A.CHECK_POINT,A.UPPER, A.FLOOR,A.UNIT,A.YEAR_DATE,
			 A.CLASS_TYPE,A.WORK_ORDER,A.PART_NO,A.CHECK_USER,A.PLACE,A.TIME1,A.TIME2,A.TIME3,A.TIME4,A.TIME5,
			 A.TIME6,B.EMP_NAME,A.CREATE_DATE FROM SAJET.G_ECHECK_RESULT A,SAJET.SYS_EMP B
                WHERE A.CREATE_USERID=B.EMP_ID(+)"+sql+" ORDER BY A.CREATE_DATE DESC";
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