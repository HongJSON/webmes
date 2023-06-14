<%@ WebHandler Language="C#" Class="ServerIp_Base" %>
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

public class ServerIp_Base : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string LNUMBER_ID = context.Request["LNUMBER_ID"];
        string LFUN = context.Request["LFUN"];
        string LFUN_DES = context.Request["LFUN_DES"];
        string LGROUPING = context.Request["LGROUPING"];
        string LPriority = context.Request["LPriority"];
        string LServerName = context.Request["LServerName"];
        string LSystemname = context.Request["LSystemname"];
        string LIP = context.Request["LIP"];
        string LCPU = context.Request["LCPU"];
        string Lmemory = context.Request["Lmemory"];
        string LHard_disk_space = context.Request["LHard_disk_space"];
        string Lapplicant = context.Request["Lapplicant"];
        string Lmanager = context.Request["Lmanager"];
        string LApplicant_department = context.Request["LApplicant_department"];
        string LApplication_time = context.Request["LApplication_time"];
        string LMaturity_time = context.Request["LMaturity_time"];
        string Lfounder = context.Request["Lfounder"];
        string LRemote_account = context.Request["LRemote_account"];
        string LRemote_PASSWORD = context.Request["LRemote_PASSWORD"];
        string LLogin_account = context.Request["LLogin_account"];
        string LLogin_PASSWORD = context.Request["LLogin_PASSWORD"];
        string LRemark1 = context.Request["LRemark1"];
        string LRemark2 = context.Request["LRemark2"];


        switch (funcName)
        {

            case "show":
                rtnValue = show(LFUN,LFUN_DES,LIP);
                break;
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(LRemark2,LRemark1,LLogin_PASSWORD,LLogin_account,LRemote_PASSWORD,LRemote_account,Lfounder,LMaturity_time,LNUMBER_ID, user, LFUN, LFUN_DES, LGROUPING, LPriority, LServerName, LSystemname, LIP, LCPU, Lmemory, LHard_disk_space, Lapplicant, Lmanager, LApplicant_department, LApplication_time);
                break;
            case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(LRemark2,LRemark1,LLogin_PASSWORD,LLogin_account,LRemote_PASSWORD,LRemote_account,Lfounder,LMaturity_time,LNUMBER_ID, user, LFUN, LFUN_DES, LGROUPING, LPriority, LServerName, LSystemname, LIP, LCPU, Lmemory, LHard_disk_space, Lapplicant, Lmanager, LApplicant_department, LApplication_time);
                break;
            case "del":
                rtnValue = del(LIP, user);
                break;
            case "ShowDown":
                rtnValue = ShowDown();
                break;


        }
        context.Response.Write(rtnValue);
    }

    public string ShowDown()
    {
        string SQL = $"SELECT * FROM SAJET.SYS_SERVER_BASE";string LOG51 = "";
        DataTable dt = PubClass.getdatatableMES(SQL);
        string tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1>";

        string LOG1 = $"<tr style=text-align:center><td >编号</td><td >服务器功能</td><td >功能</td><td >分组</td><td >顺序</td><td >虚拟机名称</td><td >系统名称</td><td >IP地址</td><td >CPU</td><td >内存</td><td >硬盘空间</td><td >申请人</td><td >管理人</td><td >申请人部门</td><td >申请时间</td><td >到期时间</td><td >创建人</td><td >远程账户</td><td >密码</td><td >管理员</td><td >密码</td><td >备注1</td><td >备注2</td></tr>";
        for (int K = 0; K <= dt.Rows.Count - 1; K++)
        {
            LOG51 += $"<tr style=text-align:center><td >{dt.Rows[K][0].ToString()}</td><td >{dt.Rows[K][1].ToString()}</td><td >{dt.Rows[K][2].ToString()}</td><td >{dt.Rows[K][3].ToString()}</td><td >{dt.Rows[K][4].ToString()}</td><td >{dt.Rows[K][5].ToString()}</td><td >{dt.Rows[K][6].ToString()}</td><td >{dt.Rows[K][7].ToString()}</td><td >{dt.Rows[K][8].ToString()}</td><td >{dt.Rows[K][9].ToString()}</td><td >{dt.Rows[K][10].ToString()}</td><td >{dt.Rows[K][11].ToString()}</td><td >{dt.Rows[K][12].ToString()}</td><td >{dt.Rows[K][13].ToString()}</td><td >{dt.Rows[K][14].ToString()}</td><td >{dt.Rows[K][15].ToString()}</td><td >{dt.Rows[K][16].ToString()}</td><td >{dt.Rows[K][17].ToString()}</td><td >{dt.Rows[K][18].ToString()}</td><td >{dt.Rows[K][19].ToString()}</td><td >{dt.Rows[K][20].ToString()}</td><td >{dt.Rows[K][21].ToString()}</td><td >{dt.Rows[K][22].ToString()}</td></tr>";
        }
        tableHtml +=LOG1+LOG51+ "</table></body></html>";
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + tableHtml+ "\"}]";
    }



    public string addTemplateInfo(string LRemark2,string LRemark1,string LLogin_PASSWORD,string LLogin_account,string LRemote_PASSWORD,string LRemote_account,string Lfounder,string LMaturity_time,string LNUMBER_ID,string user,string LFUN,string LFUN_DES,string LGROUPING,string LPriority,string LServerName,string LSystemname,string LIP,string LCPU,string Lmemory,string LHard_disk_space,string Lapplicant,string Lmanager,string LApplicant_department,string LApplication_time)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string SQL = $"SELECT * FROM SAJET.SYS_SERVER_BASE WHERE IP='{LIP}'";
        DataTable dt = PubClass.getdatatableMES(SQL);
        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,IP已存在,请检查!\"}]";
        }
        string LNumber_id = Guid.NewGuid().ToString().ToUpper();
        SQL = $"INSERT INTO SAJET.SYS_SERVER_BASE(NUMBER_ID,FUN,FUN_DES,GROUPING,PRIORITY,SERVERNAME,SYSTEMNAME,IP,CPU,MEMORY,HARD_DISK_SPACE,APPLICANT,MANAGER,APPLICANT_DEPARTMENT,APPLICATION_TIME,MATURITY_TIME,FOUNDER,REMOTE_ACCOUNT,REMOTE_PASSWORD,LOGIN_ACCOUNT,LOGIN_PASSWORD,REMARK1,REMARK2,CREATE_DATE,CREATE_USERID,UPDATE_DATE)" +
              $"VALUES('{LNUMBER_ID}','{LFUN}','{LFUN_DES}','{LGROUPING}','{LPriority}','{LServerName}','{LSystemname}','{LIP}','{LCPU}','{Lmemory}','{LHard_disk_space}','{Lapplicant}','{Lmanager}','{LApplicant_department}','{LApplication_time}','{LMaturity_time}','{Lfounder}','{LRemote_account}','{LRemote_PASSWORD}','{LLogin_account}','{LLogin_PASSWORD}','{LRemark1}','{LRemark2}',SYSDATE,'{userEmpId}',SYSDATE)";
        PubClass.getdatatablenoreturnMES(SQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,已添加!\"}]";
    }
    public string UpdateTemplateInfo1(string LRemark2,string LRemark1,string LLogin_PASSWORD,string LLogin_account,string LRemote_PASSWORD,string LRemote_account,string Lfounder,string LMaturity_time,string LNUMBER_ID,string user,string LFUN,string LFUN_DES,string LGROUPING,string LPriority,string LServerName,string LSystemname,string LIP,string LCPU,string Lmemory,string LHard_disk_space,string Lapplicant,string Lmanager,string LApplicant_department,string LApplication_time)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string SQL = $"UPDATE SAJET.SYS_SERVER_BASE SET MATURITY_TIME='{LMaturity_time}',REMARK2='{LRemark2}', FOUNDER='{Lfounder}', REMOTE_ACCOUNT='{LRemote_account}', REMOTE_PASSWORD='{LRemote_PASSWORD}', LOGIN_ACCOUNT='{LLogin_account}', LOGIN_PASSWORD='{LLogin_PASSWORD}',REMARK1='{LRemark1}',NUMBER_ID='{LNUMBER_ID}',FUN='{LFUN}',FUN_DES='{LFUN_DES}',GROUPING='{LGROUPING}',PRIORITY='{LPriority}',SERVERNAME='{LServerName}',SYSTEMNAME='{LSystemname}',CPU='{LCPU}',MEMORY='{Lmemory}',HARD_DISK_SPACE='{LHard_disk_space}',APPLICANT='{Lapplicant}',MANAGER='{Lmanager}',APPLICANT_DEPARTMENT='{LApplicant_department}',APPLICATION_TIME='{LApplication_time}',UPDATE_DATE=SYSDATE,UPDATE_USERID='{userEmpId}' WHERE IP='{LIP}'";
        PubClass.getdatatablenoreturnMES(SQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,修改成功!\"}]";
    }
    public string show(string LFUN,string LFUN_DES,string LIP)
    {
        string sql = "";
        if (LFUN != "" && LFUN != null && LFUN != "null")
        {
            sql = sql + " AND A.FUN ='" + LFUN + "'";
        }
        if (LFUN_DES != "" && LFUN_DES != null && LFUN_DES != "null")
        {
            sql = sql + " AND A.FUN_DES ='" + LFUN_DES + "'";
        }
        if (LIP != "" && LIP != null && LIP != "null")
        {
            sql = sql + " AND A.IP ='" + LIP + "'";
        }
        string sSQL = $@"SELECT A.NUMBER_ID,A.FUN,A.FUN_DES,A.GROUPING,A.PRIORITY,A.SERVERNAME,A.SYSTEMNAME,A.IP,A.CPU,A.MEMORY,A.HARD_DISK_SPACE,A.APPLICANT,A.MANAGER,A.APPLICANT_DEPARTMENT,A.APPLICATION_TIME,A.MATURITY_TIME,A.FOUNDER,A.REMOTE_ACCOUNT,A.REMOTE_PASSWORD,A.LOGIN_ACCOUNT,A.LOGIN_PASSWORD,A.REMARK1,A.REMARK2,A.CREATE_DATE,B.EMP_NAME,A.UPDATE_DATE,C.EMP_NAME AS EMP_NAME1 FROM SAJET.SYS_SERVER_BASE  A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE 
                       A.CREATE_USERID=B.EMP_ID(+)
                       AND A.UPDATE_USERID=C.EMP_ID(+)" + sql + " ORDER BY A.UPDATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string del(string LP, string user)
    {
        string sSQL = ""; DataTable dt;
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查!\"}]";

        }
        sSQL = $"DELETE  FROM SAJET.SYS_SERVER_BASE WHERE IP='{LP}'";
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