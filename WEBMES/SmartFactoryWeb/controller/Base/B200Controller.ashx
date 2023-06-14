<%@ WebHandler Language="C#" Class="B200Controller" %>

using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Security;
using System.Web.UI;
using System.Drawing.Text;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient;
using System.IO;

public class B200Controller : IHttpHandler
{
    
    public void ProcessRequest (HttpContext context) 
    {
         context.Response.ContentType = "text/plain";
        
        string rtnValue = "獲取數據失敗";
        string funcName = context.Request["funcName"];
        string lh_user = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper().Replace("CIM\\", "").Replace("WKSCN\\", "");
        string Ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string Fab = System.Configuration.ConfigurationManager.AppSettings["Fab"].ToString();

        string Text1 = context.Request["Text1"];
        string Text2 = context.Request["Text2"];
        string Text3 = context.Request["Text3"];
        string str1 = context.Request["str1"];
        string msg = context.Request["msg"];
        switch (funcName)
        {
      
            case "showtemp":
                rtnValue = showtemp();
                break;
            case "selectuser":
                rtnValue = selectuser(Text1);
                break;
            case "selectqx":
                rtnValue = selectqx(Text1);
                break;
            case "edit":
                rtnValue = edit(Text1, Text2, Text3, str1, lh_user, msg);
                break;
        }
        context.Response.Write(rtnValue);
    }

    //全部权限信息
    private string showtemp()
    {
        string sql = "SELECT DISTINCT TREEID,TREENAME FROM SD_BASE_LIMITTREE WHERE MES3_USE ='Y' AND MES3_LINKID IS NOT NULL AND TREEID  NOT IN('TJO0001'） ORDER BY TREENAME";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    //根据工号获取人员信息
    private string selectuser(string user)
    {
        string rtn = "";
        string NAME_IN_CHINESE = "";
        string MI = "";
        string sql = "SELECT * FROM SD_OP_USER WHERE USER_ID='" + user.ToUpper() + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count == 0)
        {

            string sqlrepairtype = "SELECT NAME_IN_CHINESE FROM SD_CAT_HRS WHERE USER_ID = '" + user.ToUpper() + "'";
            DataTable dtrepairtype = PubClass.getdatatableMES(sqlrepairtype);

            if (dtrepairtype.Rows.Count == 0)
            {

                rtn = "此工單不存在請確認！";
            }
            else
            {

                NAME_IN_CHINESE = dtrepairtype.Rows[0][0].ToString();
                MI = "";
                rtn = "[{\"NAME_IN_CHINESE\":\"" + NAME_IN_CHINESE + "\",\"MI\":\"" + MI + "\"}]";
                return rtn;
            }

        }
        else
        {

            NAME_IN_CHINESE = dt.Rows[0]["USER_NAME"].ToString();
            MI = dt.Rows[0]["USER_PWD"].ToString();
            rtn = "[{\"NAME_IN_CHINESE\":\"" + NAME_IN_CHINESE + "\",\"MI\":\"" + MI + "\"}]";
            return rtn;
        }
        return rtn;
    }
    //根据工号获取权限信息
    private string selectqx(string user)
    {
        string rtn = "";
        string sql = "SELECT USER_LIMIT FROM SD_OP_USER WHERE USER_ID='" + user.ToUpper() + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count > 0)
        {
            string str_rule = dt.Rows[0][0].ToString();
            if (str_rule == "administrator")
            {
                rtn = "administrator";
            }
            else
            {
                string[] str_ll = str_rule.Split(';');
                for (int i = 0; i < str_ll.Length; i++)
                {
                    str_rule = str_ll[i].ToString();
                    DataTable dt1 = PubClass.getdatatableMES("SELECT * FROM SD_BASE_LIMITTREE3 WHERE TREEID='" + str_rule + "'  AND MES3_LINKID IS NOT NULL");
                    if (dt1.Rows.Count > 0)
                    {
                        rtn = rtn + str_rule + ";";
                    }
                }
            }
        }
        return rtn;
    }

    //根据工号获取权限信息2
    private string edit(string TxtID, string TxtName, string TxtPwd, string str, string lh_user, string msg)
    {
        string rtn = "";
        string sql = "";
        str = str.Substring(0, str.Length - 1);
        string[] str_ll = str.Split(';');
        for (int i = 0; i < str_ll.Length; i++)
        {
            sql = "SELECT distinct fartherid FROM SD_BASE_LIMITTREE  WHERE TREEID ='" + str_ll[i] + "'";
            DataTable dt = PubClass.getdatatableMES(sql);
            str = str + ";" + dt.Rows[0][0].ToString();
        }
        
        string sql1 = "SELECT * FROM SD_OP_USER WHERE USER_ID='" + TxtID + "' AND WORKCENTER='JOAN'";
        if (msg == "true")
        {
            if (PubClass.getdatatableMES(sql1).Rows.Count > 0)
            {

                rtn = "此人員已存在，請點更新！";
            }
            else
            {
                PubClass.getdatatablenoreturnMES("INSERT INTO SD_OP_USER(USER_ID,USER_NAME,USER_PWD,USER_LIMIT,WORKCENTER,CREATE_USER,CREATE_DATE) values('" + TxtID + "','" + TxtName + "','" + TxtPwd + "','" + str + "','JOAN','" + lh_user + "',SYSDATE)");
                rtn = "人員信息添加成功！";
            }
        }
        else
        {
            if (PubClass.getdatatableMES(sql1).Rows.Count == 0)
            {

                rtn = "此人員不存在，請點新增！";
            }
            else
            {
                if (TxtPwd == "")
                {
                    rtn = "密碼不能為空！";
                }
                else
                {
                    
                    
                    PubClass.getdatatablenoreturnMES("UPDATE SD_OP_USER SET USER_NAME='" + TxtName + "',USER_PWD='" + TxtPwd + "',USER_LIMIT='" + str + "',MODIFY_USER='" + lh_user + "',MODIFY_DATE=SYSDATE WHERE USER_ID='" + TxtID + "' AND WORKCENTER='JOAN'");
                    rtn = "人員信息更新成功！";
                }


            }
        }
        return rtn;
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}