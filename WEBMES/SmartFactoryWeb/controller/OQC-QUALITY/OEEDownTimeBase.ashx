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
                rtnValue = GetModel(ModelName);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline(PdlineName);
                break;
            case "ShowProcess":
                rtnValue = ShowProcess(PdlineName);
                break;

            case "addDownTime":
                rtnValue = addDownTime(user, ModelName, PdlineName, ProcessName, Dreason, Dclass);
                break;
            case "show":
                rtnValue = show();
                break;
            case "QueryShow":
                rtnValue = QueryShow(ModelName, PdlineName, ProcessName, Dreason, Dclass);
                break;
            case "del":
                rtnValue = del(user, ModelName, PdlineName, ProcessName, Dreason, Dclass);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string GetModel(string ModelName)
    {
        string sql = "";
        if (ModelName != "" && ModelName != null && ModelName != "null")
        {
            sql = sql + " AND MODEL_NAME  LIKE '" + ModelName + "%'";
        }
        string sSQL = $@"SELECT  MODEL_NAME FROM SAJET.SYS_MODEL WHERE   ENABLED='Y'" + sql + "  ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdline(string PdlineName)
    {
        string sql = "";
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND PDLINE_NAME  LIKE '" + PdlineName + "%'";
        }
        string sSQL = $@"SELECT  DISTINCT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE  ENABLED='Y' " + sql + " ORDER BY PDLINE_NAME ";
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

    public string del(string user, string ModelName, string PdlineName, string ProcessName, string Dreason, string Dclass)
    {

        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }

        string SQL = $@"UPDATE SAJET.SYS_DOWNTIME_PROCESS_CLASS  SET ENABLED='DE',UPDATE_TIME=SYSDATE,UPDATE_USERID='{userEmpId}' WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}'AND PROCESS_NAME='{ProcessName}' AND REASON='{Dreason}'AND CLASS='{Dclass}' ";
        PubClass.getdatatablenoreturnMES(SQL);



        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,删除!\"}]";
    }


    public string addDownTime(string user, string ModelName, string PdlineName, string ProcessName, string Dreason, string Dclass)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
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

        SQL = $"SELECT * FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}'AND PROCESS_NAME='{ProcessName}' AND REASON='{Dreason}'AND CLASS='{Dclass}'";
        dt = PubClass.getdatatableMES(SQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,此配置已存在,请检查!\"}]";
        }


        SQL = $@"INSERT INTO  SAJET.SYS_DOWNTIME_PROCESS_CLASS(MODEL_NAME,PDLINE_NAME,PROCESS_NAME,REASON,CLASS,ENABLED,CREATE_TIME,CREATE_USERID)VALUES
                ('{ModelName}','{PdlineName}','{ProcessName}','{Dreason}','{Dclass}','Y',SYSDATE,'{userEmpId}')";
        PubClass.getdatatablenoreturnMES(SQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,添加成功!\"}]";
    }
    public string show()
    {
        string sSQL = $@"SELECT A.MODEL_NAME,A.PDLINE_NAME,A.PROCESS_NAME,A.REASON,A.CLASS,A.CREATE_TIME,E.EMP_NAME,A.UPDATE_TIME,F.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS A,SAJET.SYS_EMP E,SAJET.SYS_EMP F
                        WHERE A.CREATE_USERID=E.EMP_ID(+)
                        AND A.UPDATE_USERID=F.EMP_ID(+)
                        AND A.ENABLED='Y' ORDER BY A.CREATE_TIME DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string QueryShow(string ModelName, string PdlineName, string ProcessName, string Dreason, string Dclass)
    {
        string sql = "";
        if (ModelName != "" && ModelName != null && ModelName != "null")
        {
            sql = sql + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (ProcessName != "" && ProcessName != null && ProcessName != "null")
        {
            sql = sql + " AND A.PROCESS_NAME ='" + ProcessName + "'";
        }

        if (Dreason != "" && Dreason != null && Dreason != "null")
        {
            sql = sql + " AND A.REASON ='" + Dreason + "'";
        }
        if (Dclass != "" && Dclass != null && Dclass != "null")
        {
            sql = sql + " AND A.CLASS ='" + Dclass + "'";
        }
        string sSQL = $@"SELECT A.MODEL_NAME,A.PDLINE_NAME,A.PROCESS_NAME,A.REASON,A.CLASS,A.CREATE_TIME,E.EMP_NAME,A.UPDATE_TIME,F.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_DOWNTIME_PROCESS_CLASS A,SAJET.SYS_EMP E,SAJET.SYS_EMP F
                        WHERE A.CREATE_USERID=E.EMP_ID(+)
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