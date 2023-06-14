<%@ WebHandler Language="C#" Class="B005Controller" %>

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

public class B005Controller : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString(); 
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string ary_lot = context.Request["ary_lot"];
        string quantity = context.Request["quantity"];
        string site = context.Request["site"];
        string step = context.Request["step"];
        string line = context.Request["line"];
        string eqp = context.Request["eqp"];
        string desc = context.Request["desc"];
        string pos = context.Request["pos"];
        switch (funcName)
        {
            case "show":
                rtnValue = show();
                break;
            case "search":
                rtnValue = search(ary_lot);
                break;
            case "confirm":
                rtnValue = confirm(ary_lot, quantity, user);
                break;
            case "del":
                rtnValue = del(ary_lot, user);
                break;
        }
        context.Response.Write(rtnValue);
    }

    private string search(string ary_lot)
    {

        string sql = "SELECT ARY_LOT,FLAG,QUANTITY,QUANTITY_CREATED,CREATE_USER,CREATE_DATE FROM SD_OP_ARYLOT WHERE ARY_LOT = '" + ary_lot + "' ORDER BY FLAG DESC";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }


    private string confirm(string ary_lot, string quantity, string user)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR！\"}]";
        int intResult = quantity.IndexOf(".");
        if (intResult > -1)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"輸入數量包含小數點，請確認！\"}]";
            return rtn;
        }
        int arylotnum = Convert.ToInt32(quantity);
        try
        {
            string sqlcheck = @"SELECT * FROM SD_OP_ARYLOT WHERE ARY_LOT = '" + ary_lot + "'";
            DataTable dtcheck = PubClass.getdatatableMES(sqlcheck);
            if (dtcheck.Rows.Count == 0)
            {
                string sql = @"INSERT INTO SD_OP_ARYLOT (ARY_LOT,FLAG,QUANTITY,QUANTITY_CREATED,CREATE_USER,CREATE_DATE) values ('" + ary_lot + "','Y'," + arylotnum + ",0,'" + user + "',SYSDATE)";
                PubClass.getdatatablenoreturnMES(sql);
                rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功\"}]";
            }
            else
            {
                string oldqty = dtcheck.Rows[0]["quantity"].ToString();
                if (int.Parse(dtcheck.Rows[0]["quantity"].ToString()) <= int.Parse(quantity))
                {
                    string sqly = "UPDATE SD_OP_ARYLOT SET FLAG ='Y',QUANTITY = " + int.Parse(quantity) + ",CREATE_USER = '" + user + "',CREATE_DATE =SYSDATE WHERE ARY_LOT='" + ary_lot + "'";
                    PubClass.getdatatablenoreturnMES(sqly);
                    rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功\"}]";
                }
                else
                {
                    rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"輸入數量比此大對LOT之前數量少，請確認！\"}]";
                }
            }
            
        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"操作失敗！\"}]";
            return rtn;
        }
        return rtn;
    }

    private string del(string ary_lot,string user)
    {
        string rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"ERROR！\"}]";

        string sqlcheck = @"SELECT * FROM SD_OP_ARYLOT WHERE ARY_LOT = '" + ary_lot + "' AND FLAG ='Y'";
        DataTable dtcheck = PubClass.getdatatableMES(sqlcheck);
        if (dtcheck.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此大對LOT已關閉，請確認！\"}]";
        }
        try
        {
            string sql = "UPDATE SD_OP_ARYLOT SET FLAG = 'N',CREATE_USER = '" + user + "',CREATE_DATE = SYSDATE WHERE FLAG ='Y' AND ARY_LOT = '" + ary_lot + "'";
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
        string sql123 = @"SELECT ARY_LOT,FLAG,QUANTITY,QUANTITY_CREATED,CREATE_USER,CREATE_DATE FROM SD_OP_ARYLOT ORDER BY FLAG DESC";
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