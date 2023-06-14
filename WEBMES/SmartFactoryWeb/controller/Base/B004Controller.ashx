<%@ WebHandler Language="C#" Class="B004Controller" %>

using System;
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

public class B004Controller : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString(); 
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string reasoncode = context.Request["reasoncode"].ToUpper();
        string remark = context.Request["remark"];
        string ecode = context.Request["ecode"];
        switch (funcName)
        {
            case "add":
                rtnValue = add(user, reasoncode, remark, ecode);
                break;
            case "update":
                rtnValue = update(user,reasoncode,remark,ecode);
                break;
            case "show":
                rtnValue = show(reasoncode);
                break;
            case "del":
                rtnValue = del(reasoncode);
                break;
            case "change":
                rtnValue = change(reasoncode);
                break;
        }
        context.Response.Write(rtnValue);
    }

    private string update(string user, string reasoncode, string remark, string ecode)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR!\"}]";
        try
        {
            string sql = @"UPDATE SD_BASE_CODE SET CODE_NAME='" + remark + "',CREATE_USER='" + user + "',CREATE_TIME=SYSDATE,CODE_SIM='" + ecode + "' WHERE CODE_ID='" + reasoncode + "'";
            PubClass.getdatatablenoreturnMES(sql);
        }
        catch (Exception ex){
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + ex.ToString() + "\"}]";
        }
        rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"更新成功!\"}]";
        return rtn;

    }
    private string change(string reasoncode)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR!\"}]";
        DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_BASE_CODE WHERE CODE_ID='" + reasoncode + "'");
        if (dt.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"無資料請確認!\"}]";
            return rtn;
        }
        try
        {
            string sql1 = "";
            if (dt.Rows[0]["flag_1"].ToString() == "Y")
            {
                sql1 = "UPDATE SD_BASE_CODE SET FLAG_1='N' WHERE  CODE_ID='" + reasoncode + "'";
            }
            else
            {
                sql1 = "UPDATE SD_BASE_CODE SET FLAG_1='Y' WHERE  CODE_ID='" + reasoncode + "'";
            }
            PubClass.getdatatablenoreturnMES(sql1);
        }
        catch (Exception ex)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"切換失敗!\"}]";
        }
        rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"切換成功!\"}]";
        return rtn;

    }
    private string add(string user, string reasoncode, string remark, string ecode)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR!\"}]";

        DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_BASE_CODE WHERE CODE_ID='" + reasoncode + "'");
        if (dt.Rows.Count > 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此不良代碼已存在，請確認!\"}]";
            return rtn;
        }
        else
        {
            try
            {
                PubClass.getdatatablenoreturnMES("INSERT INTO SD_BASE_CODE (CODE_ID,CODE_NAME,CREATE_USER,CREATE_TIME,WORKCENTER,CODE_SIM,FLAG_1) VALUES('" + reasoncode + "','" + remark + "','" + user + "',SYSDATE,'JOAN','" + ecode + "','Y')");
            }
            catch
            {
                rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"資料添加失敗!\"}]";
                return rtn;
            }
        }
        rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功!\"}]";
        return rtn;

    }
    private string show(string reasoncode)
    {
        string sql = "";
        if (reasoncode == "")
        {
            sql = "SELECT CODE_ID,CODE_NAME,CODE_SIM FROM SD_BASE_CODE WHERE FLAG='Y' AND FLAG_1='Y' ORDER BY CODE_ID";
        }
        else
        {
            sql = "SELECT CODE_ID,CODE_NAME,CODE_SIM FROM SD_BASE_CODE WHERE FLAG_1='Y' AND CODE_ID='" + reasoncode + "'";
        }
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;

    }

    protected string del(string reasoncode)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR!\"}]";
        try
        {
            string sql = "DELETE FROM SD_BASE_CODE WHERE CODE_ID='" + reasoncode + "'";
            PubClass.getdatatablenoreturnMES(sql);
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"刪除成功!\"}]";
        }
        catch (Exception ex)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"刪除失敗!\"}]";
        }
        return rtn;
    }

  
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}