<%@ WebHandler Language="C#" Class="B06Controller" %>

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

public class B06Controller : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString(); 
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string site = context.Request["site"];
        string step = context.Request["step"];
        string line = context.Request["line"];
        string eqp = context.Request["eqp"];
        string desc = context.Request["desc"];
        string pos = context.Request["pos"];
        switch (funcName)
        {
            case "getLine":
                rtnValue = getLine();
                break;
            case "getStep":
                rtnValue = getStep();
                break;
            case "show":
                rtnValue = show();
                break;
            case "search":
                rtnValue = search(step, line, site);
                break;
            case "confirm":
                rtnValue = confirm(step, line, site, user, eqp, desc,pos);
                break;
            case "del":
                rtnValue = del(eqp, line);
                break;
        }
        context.Response.Write(rtnValue);
    }

    private string getLine()
    {
        string sql = "select line_code from sd_base_line where line_code is not null";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }

    private string getStep()
    {
        string sql = "select STEP_ID,STEP_ID||':'||STEP_DESC STEP_DESC from sd_base_step where workcenter='SLMES' order by STEP_ID";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }

    private string search(string step, string line, string site)
    {

        string sql = "select eqp_id,step_id,line_id,eqp_station,eqp_desc from sd_base_eqp where 1=1";
        if (step != "")
        {
            sql += " and step_id='" + step + "'";
        }
        if (line != "")
        {
            sql += "and line_id='" + line + "'";
        }
        else
        {
            if (site == "B棟")
            {
                sql += "and line_id in (select line_code  from sd_base_line where line_code like 'B%')";
            }
        }
        if (site != "")
        {
            sql += "and eqp_station='" + site + "'";
        }
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }


    private string confirm(string step, string line, string site, string user, string eqp, string desc,string pos)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR！\"}]";

        if (pos == "")
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"請選擇設備保管地點\"}]";
            return rtn;
        }
        if (step == "" || line == "" || eqp == "" || site == "")
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"輸入信息錯誤，請檢查\"}]";
            return rtn;
        }

        try
        {
            if (pos == "產線設備")
            {
                string sql = "insert into sd_base_eqp (step_id,line_id,create_date,create_user,eqp_id,eqp_desc,EQP_STATION) values ('" + step + "','" + line + "',sysdate,'" + user + "','" + eqp + "','" + desc + "','" + site + "')";
                PubClass.getdatatablenoreturnMES(sql);
            }
            else if (pos == "保管場所")
            {
                string sql = "insert into sd_base_eqp (step_id,line_id,create_date,create_user,eqp_id,eqp_desc,is_storage,EQP_STATION) values ('" + step + "','" + line + "',sysdate,'" + user + "','" + eqp + "','" + desc + "',1,'" + site + "')";
                PubClass.getdatatablenoreturnMES(sql);
            }
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功\"}]";
        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"操作失敗！\"}]";
            return rtn;
        }
        

        return rtn;
    }

    private string del(string eqp, string line)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR！\"}]";


        try
        {
            string sql = "delete from sd_base_eqp where eqp_id='" + eqp + "' AND LINE_ID='" +line + "'";
            PubClass.getdatatablenoreturnMES(sql);
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"刪除成功\"}]";
        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"操作失敗！\"}]";
            return rtn;
        }


        return rtn;
    }
    public string show()
    {
        string sql123 = @"select LINE_ID,STEP_ID,EQP_ID,EQP_DESC,EQP_STATION from sd_base_eqp order by line_id asc";
        DataTable dt_show = PubClass.getdatatableMES(sql123);

        return JsonConvert.SerializeObject(dt_show);
    }
  
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}