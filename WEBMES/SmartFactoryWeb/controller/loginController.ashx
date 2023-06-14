<%@ WebHandler Language="C#" Class="loginController" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using DataHelper;
public class loginController : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string password = context.Request["password"];
        string empNo = context.Request["empNo"];
        switch (funcName)
        {
            case "login":
                //TODO GetParams
                rtnValue = login(user, password);
                break;
            case "getPrivilege":
                //TODO GetParams
                //string str_rule = get(user);
                //rtnValue = getTree("TTTTTT", str_rule, user);
                rtnValue = getTreeByUserNo(user);
                break;
            case "getEmpInfoByEmpId":
                rtnValue = getEmpInfoByEmpNo(empNo, user);
                break;

        }
        context.Response.Write(rtnValue);
    }

    //登录
    private string login(string user, string password)
    {
        string sql = $@"SELECT *
                        FROM SAJET.SYS_EMP SE 
                        WHERE EMP_NO = '{user}'
                        AND PASSWD = SAJET.password.encrypt('{password}')";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = "";
        if (dt.Rows.Count > 0)
        {
            rtn = "success";
        }
        else
        {
            rtn = "用户名或密码错误";
        }
        rtn = JsonConvert.SerializeObject(rtn);
        return rtn;
    }

    public string getEmpInfoByEmpNo(string empNo, string user)
    {
        try
        {
            string sSQL = $@"SELECT EMP_NAME,EMAIL
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{empNo}'
                            AND ENABLED = 'Y'";

            DataTable dt = PubClass.getdatatableMES(sSQL);

            if (dt.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"工号信息不存在,请检查！\"}]";
            }

            if (dt.Rows.Count > 1)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"工号对应信息有" + dt.Rows.Count + "笔,请检查！\"}]";
            }

            string email = dt.Rows[0]["EMAIL"].ToString();

            if (email.Length == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"责任人账号Email 未维护,请在MES系统中维护！\"}]";
            }

            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0]["EMP_NAME"] + "\"}]";
        }
        catch
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"操作失敗！\"}]";
        }
    }

    /// <summary>
    /// 获取
    /// </summary>
    /// <param name="User_ID"></param>
    /// <returns></returns>
    public string get(string User_ID)
    {
        string str_rule = "";
        //User_ID = Request.Params[0].ToString();

        string sSQL = $@"SELECT *
                        FROM SAJET.SYS_EMP SE 
                        WHERE EMP_NO = '{User_ID}'
                        AND ENABLED = 'Y'";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count > 0)
        {
            string str_temp = dt.Rows[0]["User_Limit"].ToString();
            if (str_temp == "admin")
            {
                dt = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE SUBSTR(TREEID,4,3)<>'001' AND MES3_USE = 'Y'");
                foreach (DataRow dbrow in dt.Rows)
                {
                    str_rule = str_rule + ",'" + dbrow["treeID"].ToString() + "'";
                }
                str_rule = str_rule.Substring(1);
            }
            else if (str_temp == "administrator")
            {
                dt = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE MES3_USE = 'Y'");
                foreach (DataRow dbrow in dt.Rows)
                {
                    str_rule = str_rule + ",'" + dbrow["treeID"].ToString() + "'";
                }
                str_rule = str_rule.Substring(1);
            }
            else
            {
                str_rule = "'" + str_temp.Replace(";", "','") + "'";
                dt = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE MES3_USE = 'Y' AND TREEID IN (" + str_rule + ")");
                str_rule = "";
                foreach (DataRow dbrow in dt.Rows)
                {
                    str_rule = str_rule + ",'" + dbrow["treeID"].ToString() + "'";
                }
                str_rule = str_rule.Substring(1);
            }
        }
        else
        {

        }
        return str_rule;
    }

    //根据权限获取列表 
    public string getTreeByUserNo(string user)
    {
        string str = "";

        string empSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";
        DataTable empdt = PubClass.getdatatableMES(empSQL);

        if (empdt.Rows.Count == 0)
        {
            return "当前账号信息不存在,请检查!";
        }

        string userId = empdt.Rows[0]["EMP_ID"].ToString();

        #region
        //string sSQL = $@"SELECT
        //                     DISTINCT nvl(C.PROGRAM_CN, C.PROGRAM) SHOWNAME,
        //                     EXE_FILENAME,
        //                     C.PROGRAM,
        //                     C.FUN_TYPE_IDX
        //                    FROM
        //                     SAJET.SYS_ROLE_PRIVILEGE A,
        //                     SAJET.SYS_ROLE_EMP B,
        //                     SAJET.SYS_PROGRAM_NAME C,
        //                     SAJET.SYS_PROGRAM_FUN_NAME D
        //                    WHERE
        //                     A.ROLE_ID = B.ROLE_ID
        //                     AND B.EMP_ID = {userId}
        //                     AND A.PROGRAM = C.PROGRAM
        //                     AND A.PROGRAM = D.PROGRAM
        //                     AND A.FUNCTION = D.FUNCTION
        //                     AND D.WEB_FLAG = 'N'
        //                     AND D.DLL_FILENAME IS NOT NULL
        //                     AND C.ENABLED = 'Y'
        //                     AND D.ENABLED = 'Y'
        //                    UNION
        //                    SELECT
        //                     nvl(C.PROGRAM_CN, C.PROGRAM) SHOWNAME,
        //                     EXE_FILENAME,
        //                     C.PROGRAM,
        //                     C.FUN_TYPE_IDX
        //                    FROM
        //                     SAJET.SYS_EMP_PRIVILEGE A,
        //                     SAJET.SYS_PROGRAM_NAME C,
        //                     SAJET.SYS_PROGRAM_FUN_NAME D
        //                    WHERE
        //                     A.PROGRAM = C.PROGRAM
        //                     AND A.EMP_ID = {userId}
        //                     AND A.FUNCTION = D.FUNCTION
        //                     AND D.WEB_FLAG = 'N'
        //                     AND D.DLL_FILENAME IS NOT NULL
        //                     AND C.ENABLED = 'Y'
        //                     AND D.ENABLED = 'Y'
        //                    UNION
        //                    SELECT
        //                     DISTINCT nvl(C.PROGRAM_CN, C.PROGRAM) SHOWNAME,
        //                     EXE_FILENAME,
        //                     C.PROGRAM,
        //                     C.FUN_TYPE_IDX
        //                    FROM
        //                     sajet.sys_program_name C,
        //                     sajet.sys_base_param e
        //                    WHERE
        //                     c.program_type = '2'
        //                     AND c.enabled = 'Y'
        //                     AND c.program = e.program
        //                     AND EXISTS (
        //                     SELECT
        //                      DISTINCT b.REPORT_TYPE_ID
        //                     FROM
        //                      sajet.sys_cust_report b,
        //                      sajet.SYS_CUST_REPORT_TYPE d
        //                     WHERE
        //                      b.enabled = 'Y'
        //                      AND b.REPORT_TYPE_ID = d.REPORT_TYPE_ID MINUS
        //                      SELECT
        //                       DISTINCT b.REPORT_TYPE_ID
        //                      FROM
        //                       sajet.sys_cust_report_privilege a,
        //                       sajet.sys_cust_report b,
        //                       sajet.SYS_CUST_REPORT_TYPE d
        //                      WHERE
        //                       a.report_type_id = b.report_type_id
        //                       AND b.enabled = 'Y'
        //                       AND b.REPORT_TYPE_ID = d.REPORT_TYPE_ID
        //                       AND exception_flag = 0 MINUS
        //                       SELECT
        //                        DISTINCT b.REPORT_TYPE_ID
        //                       FROM
        //                        sajet.sys_cust_report_privilege a,
        //                        sajet.sys_cust_report b,
        //                        sajet.SYS_CUST_REPORT_TYPE d,
        //                        sajet.sys_role c
        //                       WHERE
        //                        a.report_type_id = b.report_type_id
        //                        AND b.enabled = 'Y'
        //                        AND a.role_id = c.role_id(+)
        //                        AND b.REPORT_TYPE_ID = d.REPORT_TYPE_ID
        //                        AND a.role_id IN (
        //                        SELECT
        //                         role_id
        //                        FROM
        //                         sajet.sys_role_emp
        //                        WHERE
        //                         emp_id = {userId})
        //                        AND exception_flag = 1 MINUS
        //                        SELECT
        //                         DISTINCT b.REPORT_TYPE_ID
        //                        FROM
        //                         sajet.sys_cust_report_privilege a,
        //                         sajet.sys_cust_report b,
        //                         sajet.SYS_CUST_REPORT_TYPE d
        //                        WHERE
        //                         a.report_id = b.report_id
        //                         AND b.enabled = 'Y'
        //                         AND b.REPORT_TYPE_ID = d.REPORT_TYPE_ID
        //                         AND exception_flag = 0 MINUS
        //                         SELECT
        //                          DISTINCT b.REPORT_TYPE_ID
        //                         FROM
        //                          sajet.sys_cust_report_privilege a,
        //                          sajet.sys_cust_report b,
        //                          sajet.SYS_CUST_REPORT_TYPE d,
        //                          sajet.sys_role c
        //                         WHERE
        //                          a.report_id = b.report_id
        //                          AND b.enabled = 'Y'
        //                          AND a.role_id = c.role_id(+)
        //                          AND b.REPORT_TYPE_ID = d.REPORT_TYPE_ID
        //                          AND a.role_id IN (
        //                          SELECT
        //                           role_id
        //                          FROM
        //                           sajet.sys_role_emp
        //                          WHERE
        //                           emp_id = {userId})
        //                          AND exception_flag = 1
        //                        UNION
        //                         SELECT
        //                          DISTINCT b.REPORT_TYPE_ID
        //                         FROM
        //                          sajet.sys_cust_report_privilege a,
        //                          sajet.sys_cust_report b,
        //                          sajet.SYS_CUST_REPORT_TYPE d,
        //                          sajet.sys_role c
        //                         WHERE
        //                          a.report_type_id(+) = b.report_type_id
        //                          AND b.enabled = 'Y'
        //                          AND a.role_id = c.role_id(+)
        //                          AND b.REPORT_TYPE_ID = d.REPORT_TYPE_ID
        //                          AND a.role_id IN (
        //                          SELECT
        //                           role_id
        //                          FROM
        //                           sajet.sys_role_emp
        //                          WHERE
        //                           emp_id = {userId})
        //                          AND exception_flag = 0
        //                        UNION
        //                         SELECT
        //                          DISTINCT b.REPORT_TYPE_ID
        //                         FROM
        //                          sajet.sys_cust_report_privilege a,
        //                          sajet.sys_cust_report b,
        //                          sajet.SYS_CUST_REPORT_TYPE d,
        //                          sajet.sys_role c
        //                         WHERE
        //                          a.report_id(+) = b.report_id
        //                          AND b.enabled = 'Y'
        //                          AND a.role_id = c.role_id(+)
        //                          AND b.REPORT_TYPE_ID = d.REPORT_TYPE_ID
        //                          AND a.role_id IN (
        //                          SELECT
        //                           role_id
        //                          FROM
        //                           sajet.sys_role_emp
        //                          WHERE
        //                           emp_id = {userId})
        //                          AND exception_flag = 0)
        //                    ORDER BY
        //                     FUN_TYPE_IDX,
        //                     SHOWNAME";
        #endregion

        string sSQL = $@"SELECT
	                            DISTINCT nvl(C.PROGRAM_CN, C.PROGRAM) SHOWNAME,
	                            EXE_FILENAME,
	                            C.PROGRAM,
	                            C.FUN_TYPE_IDX
                            FROM
	                            SAJET.SYS_ROLE_PRIVILEGE A,
	                            SAJET.SYS_ROLE_EMP B,
	                            SAJET.SYS_PROGRAM_NAME C,
	                            SAJET.SYS_PROGRAM_FUN_NAME D
                            WHERE
	                            A.ROLE_ID = B.ROLE_ID
	                            AND B.EMP_ID = {userId}
	                            AND A.PROGRAM = C.PROGRAM
	                            AND A.PROGRAM = D.PROGRAM
	                            AND A.FUNCTION = D.FUNCTION
	                            AND D.WEB_FLAG = 'Y'
	                            AND D.DLL_FILENAME IS NOT NULL
	                            AND C.ENABLED = 'Y'
	                            AND D.ENABLED = 'Y' 
                            ORDER BY C.FUN_TYPE_IDX";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        int wtLen = dt.Rows.Count;//header black-bg
        str += " <section class='sidebar'>";
        str += " <ul class='sidebar-menu' data-widget='tree'>";
        for (int i = 0; i < wtLen; i++)
        {
            string tid = dt.Rows[i]["PROGRAM"].ToString();
            string tna = dt.Rows[i]["SHOWNAME"].ToString();
            string treelevel = "1";//dt.Rows[i]["PROGRAM"].ToString();
            string css = "";
            if (treelevel == "1")
            {
                css = "fa fa-cube";
            }
            str += "<li class='treeview'>";
            str += "<a href='javascript:void(0)' data-toggle='collapse' class='collapsed'>";
            str += "<i class='" + css + "'></i>" + "<span>" + tna + "</span>";
            str += "<span class='pull-right-container'>";
            str += "<i class='fa fa-angle-left pull-right'></i>";
            str += "</span>";
            str += "</a>";
            str += "<ul class='treeview-menu' >";

            string detailSQL = $@"SELECT
	                                DISTINCT nvl(C.FUN_TYPE_CN, C.FUN_TYPE) FUN_TYPE,
	                                nvl(C.FUN_CN, C.FUNCTION) SHOWNAME,
	                                C.DLL_FILENAME,
	                                C.FUN_PARAM,
	                                C.FORM_NAME,
	                                C.FUNCTION,
	                                C.FUN_TYPE_IDX FUN_TYPE_IDX,
	                                C.FUN_IDX FUN_IDX,
                                    C.DLL_FILENAME
                                FROM
	                                SAJET.SYS_ROLE_PRIVILEGE A,
	                                SAJET.SYS_ROLE_EMP B,
	                                SAJET.SYS_PROGRAM_FUN_NAME C
                                WHERE
	                                A.ROLE_ID = B.ROLE_ID
	                                AND B.EMP_ID = {userId}
	                                AND A.PROGRAM = '{tid}'
	                                AND A.PROGRAM = C.PROGRAM
	                                AND A.FUNCTION = C.FUNCTION
	                                AND C.DLL_FILENAME IS NOT NULL
	                                AND c.ENABLED = 'Y'
	                                AND web_flag = 'Y' 
                                ORDER BY
	                                FUN_TYPE_IDX,
	                                FUN_IDX";

            DataTable dtkid1 = PubClass.getdatatableMES(detailSQL);

            int wtLen1 = dtkid1.Rows.Count;

            //二级目录
            //for (int k=0;k< wtLen1;k++)
            //{
            //    string tid1 = dtkid1.Rows[k]["FUNCTION"].ToString();
            //    string tna1 = dtkid1.Rows[k]["SHOWNAME"].ToString();
            //    string funType = dtkid1.Rows[k]["FUN_TYPE"].ToString();
            //    string TREENAME = dtkid1.Rows[k]["SHOWNAME"].ToString();
            //    string TREEID = dtkid1.Rows[k]["FUNCTION"].ToString();
            //    string url = dtkid1.Rows[k]["DLL_FILENAME"].ToString();

            //    str += $@"<li><a href='javascript:void(0)' class='myLeftMenu' data='{url}'>" + TREENAME + "</a></li>";
            //}

            List<string> funTypeList = new List<string>();

            for (int k = 0; k < wtLen1; k++)
            {
                string tid1 = dtkid1.Rows[k]["FUNCTION"].ToString();
                string tna1 = dtkid1.Rows[k]["SHOWNAME"].ToString();
                string funType = dtkid1.Rows[k]["FUN_TYPE"].ToString();
                string url = dtkid1.Rows[k]["DLL_FILENAME"].ToString();

                DataRow[] funRows = dtkid1.Select($@"FUN_TYPE = '{funType}'");

                if (funTypeList.Contains(funType))
                {
                    continue;
                }

                funTypeList.Add(funType);

                string treelevel1 = "";

                if (funRows.Length >= 1)
                {
                    treelevel1 = "2";
                }

                string css1 = "";
                if (treelevel == "2")
                {
                    css1 = "fa fa-cube";
                }
                if (funRows.Length >= 1)
                {
                    str += "<li class='treeview'>";
                    str += "<a href='javascript:void(0)' data-toggle='collapse' class='collapsed'>";

                    if (funRows.Length > 0)
                    {
                        str += ("<i class='" + css1 + "'></i>" + "<span>" + funType + "</span>");
                    }
                    else
                    {
                        str += ("<i class='" + css1 + "'></i>" + "<span>" + tna1 + "</span>");

                    }


                    str += "<span class='pull-right-container'>";
                    str += "<i class='fa fa-angle-left pull-right'></i>";
                    str += "</span>";
                    str += "</a>";
                    str += "<ul class='treeview-menu' >";
                }
                //DataTable dt2 = PubClass.getdatatableMES("SELECT COUNT(*) FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid1 + "' AND TREEID IN (" + "" + ")  AND MES3_LINKID IS NOT NULL AND MES3_USE = 'Y' ORDER BY TREEID");
                //int rsyyh1 = Convert.ToInt32(dt2.Rows[0][0].ToString());
                //DataTable dt22 = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid1 + "' AND TREEID IN (" + "" + ")  AND MES3_LINKID IS NOT NULL AND MES3_USE = 'Y' ORDER BY TREEID");
                if (funRows.Length > 0)
                {
                    for (int l = 0; l < funRows.Length; l++)
                    {
                        //string url = "http://www.baidu.com";//dt22.Rows[l]["MES3_LINKID"].ToString(); URL

                        string TREENAME = funRows[l]["SHOWNAME"].ToString();
                        string TREEID = funRows[l]["FUNCTION"].ToString();
                        string Turl = funRows[l]["DLL_FILENAME"].ToString();
                        str += $@"<li><a href='javascript:void(0)' class='myLeftMenu' data='{Turl}'>" + TREENAME + "</a></li>";
                    }
                }
                if (funRows.Length >= 1)
                {
                    str += "</ul></li>";
                }
                //}
                //DataTable dt1 = PubClass.getdatatableMES("SELECT COUNT(*) FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid + "' AND TREEID IN (" + "" + ") AND TREEID NOT IN('TJO00W','TJO00X','TJO00Z','TJO00B1','TJO00B2','TJO00B3','TJO00B4','TJO00C1','TJO00C2','TJO00C3','TJO00C4') AND MES3_USE = 'Y' ORDER BY TREEID");
                //int rslen = Convert.ToInt32(dt1.Rows[0][0].ToString());
                //DataTable dt11 = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid + "' AND TREEID IN (" + "" + ") AND TREEID NOT IN('TJO00W','TJO00X','TJO00Z','TJO00B1','TJO00B2','TJO00B3','TJO00B4','TJO00C1','TJO00C2','TJO00C3','TJO00C4') AND MES3_USE = 'Y' ORDER BY TREEID");
                //if (funRows.Length > 0)
                //{
                //    for (int j = 0; j < funRows.Length; j++)
                //    {
                //        string url = "";//dt11.Rows[j]["MES3_LINKID"].ToString();

                //        string TREENAME = dt11.Rows[j]["SHOWNAME"].ToString();
                //        string TREEID = dt11.Rows[j]["FUNCTION"].ToString();
                //        str += "<li><a href='javascript:void(0)' class='myLeftMenu' data='" + url + "'>" + TREENAME + "</a></li>";
                //    }
                //    //continue;
            }
            str += "</ul></li>";
        }
        str += "</ul></section>";
        str = JsonConvert.SerializeObject(str);
        return str;
    }

    //根据权限获取列表 
    public string getTree(string fid, string str_rule, string user)
    {
        string str = "";
        string User_ID = user;
        DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + fid + "' AND TREEID IN (" + str_rule + ") ORDER BY TREEID");
        int wtLen = dt.Rows.Count;//header black-bg
        str += " <section class='sidebar'>";
        str += " <ul class='sidebar-menu' data-widget='tree'>";
        for (int i = 0; i < wtLen; i++)
        {
            string tid = dt.Rows[i]["treeID"].ToString();
            string tna = dt.Rows[i]["treeName"].ToString();
            string treelevel = dt.Rows[i]["treelevel"].ToString();
            string css = "";
            if (treelevel == "1")
            {
                css = "fa fa-cube";
            }
            str += "<li class='treeview'>";
            str += "<a href='javascript:void(0)' data-toggle='collapse' class='collapsed'>";
            str += "<i class='" + css + "'></i>" + "<span>" + tna + "</span>";
            str += "<span class='pull-right-container'>";
            str += "<i class='fa fa-angle-left pull-right'></i>";
            str += "</span>";
            str += "</a>";
            str += "<ul class='treeview-menu' >";

            DataTable dtkid1 = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE FARTHERID IN('" + tid + "') AND TREEID IN (" + str_rule + ",'TJO00B1','TJO00B2','TJO00B3','TJO00B4','TJO00C1','TJO00C2','TJO00C3','TJO00C4') AND MES3_LINKID IS NULL AND MES3_USE = 'Y' ORDER BY TREEID");
            int wtLen1 = dtkid1.Rows.Count;
            for (int k = 0; k < wtLen1; k++)
            {
                string tid1 = dtkid1.Rows[k]["treeID"].ToString();
                string tna1 = dtkid1.Rows[k]["treeName"].ToString();
                string treelevel1 = dtkid1.Rows[k]["treelevel"].ToString();
                string css1 = "";
                if (treelevel == "2")
                {
                    css = "fa fa-cube";
                }
                str += "<li class='treeview'>";
                str += "<a href='javascript:void(0)' data-toggle='collapse' class='collapsed'>";
                str += "<i class='" + css1 + "'></i>" + "<span>" + tna1 + "</span>";
                str += "<span class='pull-right-container'>";
                str += "<i class='fa fa-angle-left pull-right'></i>";
                str += "</span>";
                str += "</a>";
                str += "<ul class='treeview-menu' >";
                DataTable dt2 = PubClass.getdatatableMES("SELECT COUNT(*) FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid1 + "' AND TREEID IN (" + str_rule + ")  AND MES3_LINKID IS NOT NULL AND MES3_USE = 'Y' ORDER BY TREEID");
                int rsyyh1 = Convert.ToInt32(dt2.Rows[0][0].ToString());
                DataTable dt22 = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid1 + "' AND TREEID IN (" + str_rule + ")  AND MES3_LINKID IS NOT NULL AND MES3_USE = 'Y' ORDER BY TREEID");
                if (rsyyh1 > 0)
                {
                    for (int l = 0; l < dt22.Rows.Count; l++)
                    {
                        string url = dt22.Rows[l]["MES3_LINKID"].ToString();

                        string TREENAME = dt22.Rows[l]["TREENAME"].ToString();
                        string TREEID = dt22.Rows[l]["TREEID"].ToString();
                        str += "<li><a href='javascript:void(0)' class='myLeftMenu' data='" + url + "'>" + TREENAME + "</a></li>";
                    }
                    //continue;
                }
                str += "</ul></li>";
            }
            DataTable dt1 = PubClass.getdatatableMES("SELECT COUNT(*) FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid + "' AND TREEID IN (" + str_rule + ") AND TREEID NOT IN('TJO00W','TJO00X','TJO00Z','TJO00B1','TJO00B2','TJO00B3','TJO00B4','TJO00C1','TJO00C2','TJO00C3','TJO00C4') AND MES3_USE = 'Y' ORDER BY TREEID");
            int rslen = Convert.ToInt32(dt1.Rows[0][0].ToString());
            DataTable dt11 = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE WHERE FARTHERID ='" + tid + "' AND TREEID IN (" + str_rule + ") AND TREEID NOT IN('TJO00W','TJO00X','TJO00Z','TJO00B1','TJO00B2','TJO00B3','TJO00B4','TJO00C1','TJO00C2','TJO00C3','TJO00C4') AND MES3_USE = 'Y' ORDER BY TREEID");
            if (rslen > 0)
            {
                for (int j = 0; j < dt11.Rows.Count; j++)
                {
                    string url = dt11.Rows[j]["MES3_LINKID"].ToString();

                    string TREENAME = dt11.Rows[j]["TREENAME"].ToString();
                    string TREEID = dt11.Rows[j]["TREEID"].ToString();
                    str += "<li><a href='javascript:void(0)' class='myLeftMenu' data='" + url + "'>" + TREENAME + "</a></li>";
                }
                //continue;
            }
            str += "</ul></li>";
        }
        str += "</ul></section>";
        str = JsonConvert.SerializeObject(str);
        return str;
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}