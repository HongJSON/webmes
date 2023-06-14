<%@ WebHandler Language="C#" Class="E01" %>
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

public class E01 : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string Template = context.Request["Template"];
        string SECTON_NAME = context.Request["SECTON_NAME"];
        string Bu = context.Request["Bu"];
        string BuNo = context.Request["BuNo"];
        string EMP_NO = context.Request["EMP_NO"];
        string BuName = context.Request["BuName"];
        string Type = context.Request["Type"];
        string STATUS = context.Request["STATUS"];

        switch (funcName)
        {
            case "ShowBu":
                rtnValue = ShowBu(Bu);
                break;
            case "ShowBuName":
                rtnValue = ShowBuName(BuName, BuNo, Type);
                break;
            case "addBuNo":
                rtnValue = addBuNo(BuName, BuNo, user, Type);
                break;
            case "addBu":
                rtnValue = addBu(Bu, user);
                break;
            case "DelSection":
                rtnValue = DelSection(SECTON_NAME, user);
                break;
            case "DelSectionNo":
                rtnValue = DelSectionNo(SECTON_NAME, EMP_NO, user, STATUS);
                break;
            case "ShowSECTON_NAME":
                rtnValue = ShowSECTON_NAME();
                break;
        }
        context.Response.Write(rtnValue);
    }
    public string ShowSECTON_NAME()
    {
        string sSQL = $@"SELECT SECTON_NAME FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE CHECK_TYPE='1'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowBu(string Bu)
    {
        string sql = "";
        if (Bu != "" && Bu != null && Bu != "null")
        {
            sql = sql + " AND A.SECTON_NAME ='" + Bu + "'";
        }
        string sSQL = $@"SELECT A.SECTON_NAME,A.CREATE_DATE,B.EMP_NAME,A.UPDATE_DATE,C.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_CHECK_SECTOR_CONFIG  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE 
                       A.CREATE_USERID=B.EMP_ID(+)
                       AND A.UPDATE_USERID=C.EMP_ID(+) AND CHECK_TYPE='1'" + sql + " ORDER BY A.CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowBuName(string BuName, string BuNo, string ShowType)
    {
        string sql = "";
        if (BuName != "" && BuName != null && BuName != "null")
        {
            sql = sql + " AND A.SECTON_NAME ='" + BuName + "'";
        }
        if (BuNo != "" && BuNo != null && BuNo != "null")
        {
            sql = sql + " AND D.EMP_NO ='" + BuNo + "'";
        }
        if (ShowType != "" && ShowType != null && ShowType != "null" && ShowType != "--请选择--")
        {
            sql = sql + " AND A.STATUS ='" + ShowType + "'";
        }
        string sSQL = $@"SELECT A.SECTON_NAME,A.STATUS,D.EMP_NO,D.EMP_NAME,A.CREATE_DATE,B.EMP_NAME,A.UPDATE_DATE,C.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_CHECK_SECTOR_CONFIG  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C,SAJET.SYS_EMP D WHERE 
                       A.CREATE_USERID=B.EMP_ID(+)
                       AND A.UPDATE_USERID=C.EMP_ID(+) AND A.EMP_ID=D.EMP_ID(+) AND CHECK_TYPE='2'" + sql + " ORDER BY A.CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string addBuNo(string BuName, string BuNo, string user, string Type)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";
        }
        string userEmpId1 = getEmpIdByNo(BuNo);
        if (userEmpId1.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";

        }
        sSQL = $"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE   EMP_ID='{userEmpId1}'AND CHECK_TYPE='2' AND SECTON_NAME NOT IN('{BuName}')";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此人员在其他部门当中,不可加入其他部门\"}]";
        }

        sSQL = $"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{BuName}' AND EMP_ID='{userEmpId1}'AND CHECK_TYPE='2'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此部门名称人员信息已存在\"}]";
        }
        string Number_id = Guid.NewGuid().ToString().ToUpper();
        sSQL = $"INSERT INTO SAJET.SYS_CHECK_SECTOR_CONFIG(SECTON_NAME,EMP_ID,CREATE_USERID,CREATE_DATE,CHECK_TYPE,STATUS)VALUES('{BuName}','{userEmpId1}','{userEmpId}',SYSDATE,'2','{Type}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_SECTOR_CONFIG(SECTON_NAME,EMP_ID,CREATE_USERID,CREATE_DATE,CHECK_TYPE,STATUS)VALUES('{BuName}','{userEmpId1}','{userEmpId}',SYSDATE,'2','{Type}')";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }

    public string addBu(string Bu, string user)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";
        }

        sSQL = $"SELECT * FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{Bu}'AND CHECK_TYPE='1'";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + Bu + "此部门名称已存在\"}]";
        }
        string Number_id = Guid.NewGuid().ToString().ToUpper();
        sSQL = $"INSERT INTO SAJET.SYS_CHECK_SECTOR_CONFIG(SECTON_NAME,CREATE_USERID,CREATE_DATE,CHECK_TYPE)VALUES('{Bu}','{userEmpId}',SYSDATE,'1')";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_SECTOR_CONFIG(SECTON_NAME,CREATE_USERID,CREATE_DATE,CHECK_TYPE)VALUES('{Bu}','{userEmpId}',SYSDATE,'1')";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
    }
    public string DelSection(string SECTON_NAME, string user)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";
        }
        sSQL = $"UPDATE SAJET.SYS_CHECK_SECTOR_CONFIG SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE SECTON_NAME='{SECTON_NAME}'AND CHECK_TYPE='1'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_SECTOR_CONFIG SELECT * FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{SECTON_NAME}'AND CHECK_TYPE='1'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{SECTON_NAME}'AND CHECK_TYPE='1'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"UPDATE SAJET.SYS_CHECK_SECTOR_CONFIG SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE SECTON_NAME='{SECTON_NAME}'AND CHECK_TYPE='2'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_SECTOR_CONFIG SELECT * FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{SECTON_NAME}'AND CHECK_TYPE='2'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{SECTON_NAME}'AND CHECK_TYPE='2'";
        PubClass.getdatatablenoreturnMES(sSQL);


        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功!\"}]";
    }
    public string DelSectionNo(string SECTON_NAME, string EMP_NO, string user, string STATUS)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";
        }
        string userEmpId1 = getEmpIdByNo(EMP_NO);
        if (userEmpId1.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";
        }
        sSQL = $"UPDATE SAJET.SYS_CHECK_SECTOR_CONFIG SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE SECTON_NAME='{SECTON_NAME}'AND EMP_ID='{userEmpId1}'AND CHECK_TYPE='2'AND STATUS='{STATUS}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"INSERT INTO SAJET.SYS_HT_CHECK_SECTOR_CONFIG SELECT * FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{SECTON_NAME}'AND EMP_ID='{userEmpId1}'AND CHECK_TYPE='2'AND STATUS='{STATUS}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $"DELETE FROM SAJET.SYS_CHECK_SECTOR_CONFIG WHERE SECTON_NAME='{SECTON_NAME}'AND EMP_ID='{userEmpId1}'AND CHECK_TYPE='2'AND STATUS='{STATUS}'";
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
    public string getEmpIdByNo1(string user)
    {
        string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NAME = '{user}'";

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