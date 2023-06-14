<%@ WebHandler Language="C#" Class="OEEDownTime" %>
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

public class OEEDownTime : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string ModelName = context.Request["ModelName"];
        string PdlineName = context.Request["PdlineName"];
        string ProcessName = context.Request["ProcessName"];
        string datetimepicker = context.Request["datetimepicker"];
        string WorkTime = context.Request["WorkTime"];
        string Dreason = context.Request["Dreason"];
        string Dstoptime = context.Request["Dstoptime"];
        string Dclass = context.Request["Dclass"];
        string NUMBER_ID = context.Request["NUMBER_ID"];

        switch (funcName)
        {
            case "GetModel":
                rtnValue = GetModel();
                break;
            case "ShowPdline":
                rtnValue = ShowPdline(ModelName);
                break;
            case "ShowProcess":
                rtnValue = ShowProcess(ModelName, PdlineName);
                break;
            case "ShowDreason":
                rtnValue = ShowDreason(ModelName, PdlineName, ProcessName);
                break;
            case "ShowClass":
                rtnValue = ShowClass(Dreason, ModelName, PdlineName, ProcessName);
                break;
            case "addDownTime":
                rtnValue = addDownTime(user, ModelName, PdlineName, ProcessName, datetimepicker, WorkTime, Dreason, Dstoptime, Dclass);
                break;
            case "show":
                rtnValue = show();
                break;
            case "QueryShow":
                rtnValue = QueryShow(ModelName, PdlineName, ProcessName, datetimepicker, WorkTime, Dreason, Dstoptime, Dclass);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "del":
                rtnValue = del(user, NUMBER_ID);
                break;
            case "UpdateDownTime":
                rtnValue = UpdateDownTime(datetimepicker, WorkTime, ModelName, PdlineName, ProcessName, user, NUMBER_ID, Dreason, Dstoptime, Dclass);
                break;
        }
        context.Response.Write(rtnValue);
    }
    public string GetDate()
    {
        string TIME = "";
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD'),TO_CHAR(SYSDATE,'HH24') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);

        return "[{\"ERR_CODE\":\"" + dt.Rows[0][1].ToString() + "\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\"}]";
    }
    public string UpdateDownTime(string datetimepicker, string WorkTime, string ModelName, string PdlineName, string ProcessName, string user, string NUMBER_ID, string Dreason, string Dstoptime, string Dclass)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        try
        {
            int.Parse(Dstoptime);
        }
        catch
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,DownTime时间请输入数字!\"}]";
        }
        if (int.Parse(Dstoptime) <= 0 || int.Parse(Dstoptime) > 60)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,DownTime时间不可小于0或者大于60!\"}]";

        }
        string SQL = $"SELECT * FROM SAJET.SYS_MODEL WHERE MODEL_NAME='{ModelName}'";
        DataTable dt = PubClass.getdatatableMES(SQL);
        string MODEL_ID = dt.Rows[0]["MODEL_ID"].ToString();
        SQL = $"SELECT * FROM SAJET.SYS_PDLINE WHERE PDLINE_NAME='{PdlineName}'";
        dt = PubClass.getdatatableMES(SQL);
        string PDLINE_ID = dt.Rows[0]["PDLINE_ID"].ToString();
        SQL = $"SELECT * FROM SAJET.SYS_PROCESS WHERE PROCESS_NAME='{ProcessName}'";
        dt = PubClass.getdatatableMES(SQL);
        string PROCESS_ID = dt.Rows[0]["PROCESS_ID"].ToString();

        SQL = $"SELECT * FROM SAJET.SYS_DOWNTIME_OEE WHERE MODEL_ID='{MODEL_ID}'AND PDLINE_ID='{PDLINE_ID}'AND PROCESS_ID='{PROCESS_ID}' AND WORK_DATE='{datetimepicker}'AND WORK_TIME='{WorkTime}'AND NUMBER_ID NOT IN('{NUMBER_ID}')";
        dt = PubClass.getdatatableMES(SQL);
        if (dt.Rows.Count > 0)
        {
            SQL = $"SELECT SUM(STOP_TIME) FROM SAJET.SYS_DOWNTIME_OEE WHERE MODEL_ID='{MODEL_ID}'AND PDLINE_ID='{PDLINE_ID}'AND PROCESS_ID='{PROCESS_ID}' AND WORK_DATE='{datetimepicker}'AND WORK_TIME='{WorkTime}' AND NUMBER_ID NOT IN('{NUMBER_ID}')";
            dt = PubClass.getdatatableMES(SQL);
            if (int.Parse(dt.Rows[0][0].ToString()) + int.Parse(Dstoptime) > 60)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,DownTime时间加上之前DownTime时间大于60分钟!\"}]";
            }
        }
        SQL = $"UPDATE SAJET.SYS_DOWNTIME_OEE SET UPDATE_TIME=SYSDATE,UPDATE_USERID='{userEmpId}',REASON='{Dreason}',STOP_TIME='{Dstoptime}',CLASS='{Dclass}' WHERE NUMBER_ID='{NUMBER_ID}'";
        PubClass.getdatatablenoreturnMES(SQL);

        SQL = $@"INSERT INTO  SAJET.SYS_HT_DOWNTIME_OEE SELECT *FROM SAJET.SYS_DOWNTIME_OEE WHERE NUMBER_ID='{NUMBER_ID}' ";
        PubClass.getdatatablenoreturnMES(SQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,修改成功!\"}]";
    }



    public string del(string user, string NUMBER_ID)
    {

        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string SQL = $"UPDATE SAJET.SYS_DOWNTIME_OEE SET UPDATE_TIME=SYSDATE,UPDATE_USERID='{userEmpId}' WHERE NUMBER_ID='{NUMBER_ID}'";
        PubClass.getdatatablenoreturnMES(SQL);
        SQL = $@"INSERT INTO  SAJET.SYS_HT_DOWNTIME_OEE SELECT *FROM SAJET.SYS_DOWNTIME_OEE WHERE NUMBER_ID='{NUMBER_ID}' ";
        PubClass.getdatatablenoreturnMES(SQL);

        SQL = $@"DELETE FROM SAJET.SYS_DOWNTIME_OEE WHERE NUMBER_ID='{NUMBER_ID}' ";
        PubClass.getdatatablenoreturnMES(SQL);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,删除!\"}]";
    }
    public string GetModel()
    {
        string sql = "";
        string sSQL = $@"SELECT  DISTINCT MODEL_NAME FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS WHERE ENABLED='Y'ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdline(string ModelName)
    {
        string sql = "";
        string sSQL = $@"SELECT  DISTINCT PDLINE_NAME FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS WHERE MODEL_NAME='{ModelName}'AND ENABLED='Y'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowProcess(string ModelName, string PdlineName)
    {
        string sql = "";
        string sSQL = $@"SELECT  DISTINCT PROCESS_NAME FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}'AND ENABLED='Y'ORDER BY PROCESS_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowDreason(string ModelName, string PdlineName, string ProcessName)
    {
        string sql = "";
        string sSQL = $@"SELECT  DISTINCT REASON FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}'AND PROCESS_NAME='{ProcessName}' AND  ENABLED='Y'ORDER BY REASON ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowClass(string Dreason, string ModelName, string PdlineName, string ProcessName)
    {
        string sql = "";
        string sSQL = $@"SELECT  DISTINCT CLASS FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}'AND PROCESS_NAME='{ProcessName}'AND REASON='{Dreason}'AND ENABLED='Y'ORDER BY CLASS ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowProcess(string PdlineName)
    {
        string sSQL = $@"Select DISTINCT B.PROCESS_NAME "
               + " From SAJET.SYS_TERMINAL A "
               + "     ,SAJET.SYS_PROCESS B "
               + "     ,SAJET.SYS_STAGE C "
               + "     ,SAJET.SYS_PDLINE D "
               + "     ,SAJET.SYS_OPERATE_TYPE E "
               + " Where D.PDLINE_NAME = '" + PdlineName + "' "
               + " AND A.PROCESS_ID = B.PROCESS_ID "
               + " AND B.OPERATE_ID = E.OPERATE_ID "
               + " AND A.STAGE_ID = C.STAGE_ID "
               + " AND A.PDLINE_ID = D.PDLINE_ID  ORDER BY B.PROCESS_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string addDownTime(string user, string ModelName, string PdlineName, string ProcessName, string datetimepicker, string WorkTime, string Dreason, string Dstoptime, string Dclass)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        try
        {
            int.Parse(Dstoptime);
        }
        catch
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,DownTime时间请输入数字!\"}]";
        }
        if (int.Parse(Dstoptime) <= 0 || int.Parse(Dstoptime) > 60)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,DownTime时间不可小于0或者大于60!\"}]";

        }
        string SQL = $"SELECT * FROM SAJET.SYS_MODEL WHERE MODEL_NAME='{ModelName}'";
        DataTable dt = PubClass.getdatatableMES(SQL);
        string MODEL_ID = dt.Rows[0]["MODEL_ID"].ToString();
        SQL = $"SELECT * FROM SAJET.SYS_PDLINE WHERE PDLINE_NAME='{PdlineName}'";
        dt = PubClass.getdatatableMES(SQL);
        string PDLINE_ID = dt.Rows[0]["PDLINE_ID"].ToString();
        SQL = $"SELECT * FROM SAJET.SYS_PROCESS WHERE PROCESS_NAME='{ProcessName}'";
        dt = PubClass.getdatatableMES(SQL);
        string PROCESS_ID = dt.Rows[0]["PROCESS_ID"].ToString();

        SQL = $"SELECT * FROM SAJET.SYS_DOWNTIME_OEE WHERE MODEL_ID='{MODEL_ID}'AND PDLINE_ID='{PDLINE_ID}'AND PROCESS_ID='{PROCESS_ID}' AND WORK_DATE='{datetimepicker}'AND WORK_TIME='{WorkTime}'";
        dt = PubClass.getdatatableMES(SQL);
        if (dt.Rows.Count > 0)
        {
            SQL = $"SELECT SUM(STOP_TIME) FROM SAJET.SYS_DOWNTIME_OEE WHERE MODEL_ID='{MODEL_ID}'AND PDLINE_ID='{PDLINE_ID}'AND PROCESS_ID='{PROCESS_ID}' AND WORK_DATE='{datetimepicker}'AND WORK_TIME='{WorkTime}'";
            dt = PubClass.getdatatableMES(SQL);
            if (int.Parse(dt.Rows[0][0].ToString()) + int.Parse(Dstoptime) > 60)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,DownTime时间加上之前DownTime时间大于60分钟!\"}]";
            }
        }
        string Number_id = Guid.NewGuid().ToString().ToUpper();

        datetimepicker = datetimepicker.Replace("-", "");

        SQL = $@"INSERT INTO  SAJET.SYS_DOWNTIME_OEE(MODEL_ID,PDLINE_ID,PROCESS_ID,WORK_DATE,WORK_TIME,REASON,STOP_TIME,CLASS,ENABLED,CREATE_TIME,CREATE_USERID,NUMBER_ID)VALUES
                ('{MODEL_ID}','{PDLINE_ID}','{PROCESS_ID}','{datetimepicker}','{WorkTime}','{Dreason}','{Dstoptime}','{Dclass}','Y',SYSDATE,'{userEmpId}','{Number_id}')";
        PubClass.getdatatablenoreturnMES(SQL);
        SQL = $@"INSERT INTO  SAJET.SYS_HT_DOWNTIME_OEE(MODEL_ID,PDLINE_ID,PROCESS_ID,WORK_DATE,WORK_TIME,REASON,STOP_TIME,CLASS,ENABLED,CREATE_TIME,CREATE_USERID,NUMBER_ID)VALUES
                ('{MODEL_ID}','{PDLINE_ID}','{PROCESS_ID}','{datetimepicker}','{WorkTime}','{Dreason}','{Dstoptime}','{Dclass}','Y',SYSDATE,'{userEmpId}','{Number_id}')";
        PubClass.getdatatablenoreturnMES(SQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,添加成功!\"}]";
    }
    public string show()
    {
        string sSQL = $@"SELECT A.NUMBER_ID,A.MODEL_ID,A.PDLINE_ID,A.PROCESS_ID,B.MODEL_NAME,C.PDLINE_NAME,D.PROCESS_NAME,A.WORK_DATE,A.WORK_TIME,A.REASON,A.STOP_TIME,A.CLASS,A.CREATE_TIME,E.EMP_NAME,A.UPDATE_TIME,F.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_DOWNTIME_OEE A,SAJET.SYS_MODEL B,SAJET.SYS_PDLINE C,SAJET.SYS_PROCESS D,SAJET.SYS_EMP E,SAJET.SYS_EMP F
                        WHERE A.MODEL_ID=B.MODEL_ID
                        AND A.PDLINE_ID=C.PDLINE_ID
                        AND A.PROCESS_ID=D.PROCESS_ID
                        AND A.CREATE_USERID=E.EMP_ID(+)
                        AND A.UPDATE_USERID=F.EMP_ID(+)
                        AND A.ENABLED='Y' ORDER BY A.CREATE_TIME DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string QueryShow(string ModelName, string PdlineName, string ProcessName, string datetimepicker, string WorkTime, string Dreason, string Dstoptime, string Dclass)
    {
        string sql = "";
        if (ModelName != "" && ModelName != null && ModelName != "null")
        {
            sql = sql + " AND B.MODEL_NAME ='" + ModelName + "'";
        }
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND C.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (ProcessName != "" && ProcessName != null && ProcessName != "null")
        {
            sql = sql + " AND D.PROCESS_NAME ='" + ProcessName + "'";
        }
        if (datetimepicker != "" && datetimepicker != null && datetimepicker != "null")
        {
            datetimepicker = datetimepicker.Replace("-", "");
            sql = sql + " AND A.WORK_DATE ='" + datetimepicker + "'";
        }
        if (WorkTime != "" && WorkTime != null && WorkTime != "null")
        {
            sql = sql + " AND A.WORK_TIME ='" + WorkTime + "'";
        }
        if (Dreason != "" && Dreason != null && Dreason != "null")
        {
            sql = sql + " AND A.REASON ='" + Dreason + "'";
        }
        if (Dstoptime != "" && Dstoptime != null && Dstoptime != "null")
        {
            sql = sql + " AND A.STOP_TIME ='" + Dstoptime + "'";
        }
        if (Dclass != "" && Dclass != null && Dclass != "null")
        {
            sql = sql + " AND A.CLASS ='" + Dclass + "'";
        }
        string sSQL = $@"SELECT A.NUMBER_ID,A.MODEL_ID,A.PDLINE_ID,A.PROCESS_ID,B.MODEL_NAME,C.PDLINE_NAME,D.PROCESS_NAME,A.WORK_DATE,A.WORK_TIME,A.REASON,A.STOP_TIME,A.CLASS,A.CREATE_TIME,E.EMP_NAME,A.UPDATE_TIME,F.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_DOWNTIME_OEE A,SAJET.SYS_MODEL B,SAJET.SYS_PDLINE C,SAJET.SYS_PROCESS D,SAJET.SYS_EMP E,SAJET.SYS_EMP F
                        WHERE A.MODEL_ID=B.MODEL_ID
                        AND A.PDLINE_ID=C.PDLINE_ID
                        AND A.PROCESS_ID=D.PROCESS_ID
                        AND A.CREATE_USERID=E.EMP_ID(+)
                        AND A.UPDATE_USERID=F.EMP_ID(+)
                        AND A.ENABLED='Y' " + sql + " ORDER BY A.CREATE_TIME DESC";
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