<%@ WebHandler Language="C#" Class="R06Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections.Generic;
using DataHelper;
using ExcelLibrary.SpreadSheet;
using System.IO;
using System.Text.RegularExpressions;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Data.OleDb;
using System.Data.OracleClient;
using System.Drawing.Printing;
using System.Windows.Forms;
using System.Drawing;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.HSSF.UserModel;

public class R06Controller : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string user = context.Request["user"];
        string funcName = context.Request["funcName"];
        string ddl_mo = context.Request["ddl_mo"];
        string ddl_halfpart = context.Request["ddl_halfpart"];
        string info = context.Request["info"];
        string ddl_monum = context.Request["ddl_monum"];
        string ddl_halfpartid = context.Request["ddl_halfpartid"];
        string type = context.Request["type"];
        string ddl_storeloc = context.Request["ddl_storeloc"];
        string repairtype = context.Request["repairtype"];
        string rejectednum = context.Request["rejectednum"];
        string userid = context.Request["userid"];
        string ORDER_NO = context.Request["ORDER_NO"];
        string REJECTED_QTY = context.Request["REJECTED_QTY"];
        switch (funcName)
        {
            case "getIP":
                rtnValue = GetIP();
                break;
            case "select_GetMo":
                rtnValue = select_GetMo();
                break;
            case "select_GetHalfPart":
                rtnValue = select_GetHalfPart();
                break;
            case "select_GetHalfPartId":
                rtnValue = select_GetHalfPartId(ddl_mo,ddl_halfpart);
                break;
            case "rowDelete":
                rtnValue = rowDelete(ORDER_NO, userid, REJECTED_QTY);
                break;
            case "show":
                rtnValue = show(userid, str_loginhost);
                break;
            case "select_GetStoreLoc":
                rtnValue = select_GetStoreLoc(info);
                break;
            case "select_getMoNum":
                rtnValue = select_getMoNum(ddl_mo);
                break;
            case "btn_offline":
                rtnValue = btn_offline(ddl_mo, ddl_monum, ddl_halfpart, ddl_halfpartid, type, ddl_storeloc, repairtype, rejectednum, userid);
                break;
            case "btn_tmp":
                rtnValue = btn_tmp(ddl_mo, ddl_monum, ddl_halfpart, ddl_halfpartid, type, ddl_storeloc, repairtype, rejectednum, userid, str_loginhost);
                break;
        }
        context.Response.Write(rtnValue);
    }

    private string rowDelete(string ORDER_NO, string userid, string REJECTED_QTY)
    {

        string sql = "SELECT * FROM SD_OP_REPAIRMOUNCHECK WHERE ORDER_NO='" + ORDER_NO + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if(dt.Rows.Count==0)
        {
            string sql23 = @"INSERT INTO SD_OP_REPAIRMOUNCHECK (ORDER_NO,INQTY)VALUES('" + ORDER_NO + "','" + REJECTED_QTY + "')";
            DataTable dtAdd3 = PubClass.getdatatableMES(sql23);
        }
        else
        {
            string sql231 = @"UPDATE SD_OP_REPAIRMOUNCHECK SET INQTY=INQTY+" + REJECTED_QTY + " WHERE ORDER_NO='" + ORDER_NO + "'";
            DataTable dtAdd31 = PubClass.getdatatableMES(sql231);
        }
        string sql2313 = @"DELETE FROM TEMP_REJECTEDMAIN WHERE ORDER_NO='" + ORDER_NO + "'AND REJECTED_QTY='" + REJECTED_QTY + "'AND CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "'";
        DataTable dtAdd313 = PubClass.getdatatableMES(sql2313);
        return "{\"FLAG\":\"N\",\"MSG\":\"已刪除!\"}";
    }
    private string show(string userid, string str_loginhost)
    {
        string sql = "select  ORDER_NO,LH_ID,STORELOC,REJECTED_QTY,REPAIRTYPE,STATUS,TYPEID,CREATE_USER FROM TEMP_REJECTEDMAIN WHERE CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }
    // 获取下拉框
    private string select_GetHalfPart()
    {
        string rtn = "";
        string sql = "SELECT DISTINCT HALFPART FROM SD_BASE_REPAIRTYPE WHERE PAGE = 'ALL' AND  FLAG = 'Y' ORDER BY HALFPART";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_GetMo()
    {
        string rtn = "";
        string sql = "SELECT ORDER_NO,SUBSTR(ORDER_NO,5,8) SHOWMO FROM SD_OP_REPAIRMOUNCHECK  ORDER BY ORDER_NO";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_getMoNum(string ddl_mo)
    {
        string rtn = ""; int ngnum; int checknum;int monum;
        string sql_checknum = @"SELECT INQTY FROM SD_OP_REPAIRMOUNCHECK WHERE ORDER_NO ='" + ddl_mo + "'"; 
        DataTable dt_checknum = PubClass.getdatatableMES(sql_checknum);
        if (dt_checknum.Rows.Count > 0)
        {
            checknum = int.Parse(dt_checknum.Rows[0]["INQTY"].ToString());
        }
        else
        {
            checknum = 0;
        }
        string sql = "SELECT '" + checknum + "' MONUM FROM DUAL";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_GetHalfPartId(string ddl_mo, string ddl_halfpart)
    {
        string rtn = "";
        string sql = "SELECT HALFPARTID FROM SD_BASE_ORDERPART WHERE FLAG ='1' AND MO='" + ddl_mo + "' AND HALFPART='" + ddl_halfpart + "'";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_GetStoreLoc(string info)
    {
        string rtn = "";
        string sql = "SELECT LOC FROM SD_BASE_REPAIRTYPE WHERE FLAG ='Y' AND PAGE ='STORELOC' AND TYPEID ='" + info + "'";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }

    private string btn_offline(string ddl_mo, string ddl_monum, string ddl_halfpart, string ddl_halfpartid, string type, string ddl_storeloc, string repairtype, string rejectednum, string userid)
    {
        string rtn = "";
        //獲取IP信息
        string lbluser = "";
        string user = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        string ip = HttpContext.Current.Request.ServerVariables.Get("Remote_Addr").ToString();
        if (!string.IsNullOrEmpty(PubClass.getLoginUser(ip, user).ToString()))
        {
            lbluser = PubClass.getLoginUser(ip, user).ToString();
        }
        else
        {
            rtn = "[{\"ERR_CODE\":\"IP\"}]";//無此電腦信息，請聯繫IT
            return rtn;
        }
        //lbluser = HttpContext.Current.Request.Params[0].ToString();
        user = user.Replace("WKSCN\\", "");
        user = user.Replace("CIM\\", "");

        string sql_checknum = "SELECT * FROM TEMP_REJECTEDMAIN WHERE CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "'";
        DataTable dt_checknum = PubClass.getdatatableMES(sql_checknum);
        if(dt_checknum.Rows.Count==0)
        {
            rtn = "臨時表為空，不可結箱!";
            return rtn;
        }
        //生成箱號
        string sqldate = "SELECT TO_CHAR(SYSDATE,'yyyymmdd') FROM DUAL";
        DataTable dtdata = PubClass.getdatatableMES(sqldate);
        string newrejectedid = dtdata.Rows[0][0].ToString();
        string m = "";
        string sqlcheck = " SELECT LPAD(SEQ_REJECTEDID.NEXTVAL,4,'0') FROM DUAL";
        DataTable dtcheck = PubClass.getdatatableMES(sqlcheck);
        if (dtcheck.Rows[0][0].ToString() != "")
        {
            m = dtcheck.Rows[0][0].ToString();
        }
        else
        {
            rtn = "退庫箱號生成異常，請聯繫IT!";
            return rtn;
        }
        newrejectedid = "H" + newrejectedid + "-" + m;
        string sqlal2 = "SELECT * FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID = '" + newrejectedid + "'";
        DataTable dtal2 = PubClass.getdatatableMES(sqlal2);
        if (dtal2.Rows.Count == 0)
        {
            string sql2 = @"INSERT INTO SD_OP_REJECTEDMAIN(REJECTED_ID,LH_ID,CREATE_USER,CREATE_DATE,STORELOC,PRINT_TIMES,REJECTED_QTY,FLAG,ORDER_NO,REPAIRTYPE,STATUS,TYPEID,PAGE)
                            SELECT '" + newrejectedid + @"',LH_ID,'" + userid + @"',SYSDATE,STORELOC,'0',SUM(REJECTED_QTY)QTY,'Y',ORDER_NO,REPAIRTYPE,STATUS,TYPEID,'R06'FROM  TEMP_REJECTEDMAIN 
                            WHERE CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "' GROUP BY LH_ID,STORELOC,ORDER_NO,REPAIRTYPE,STATUS,TYPEID";
            DataTable sql231 = PubClass.getdatatableMES(sql2);
            string sql2313 = @"DELETE FROM TEMP_REJECTEDMAIN WHERE  CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "'";
            DataTable dtAdd313 = PubClass.getdatatableMES(sql2313);
        }
        else
        {
            rtn = "此箱號：" + newrejectedid + " 已存在,請聯繫IT!";
            return rtn;
        }
            rtn = "結箱成功" + newrejectedid + "";
            return rtn;
    }
    private string btn_tmp(string ddl_mo, string ddl_monum, string ddl_halfpart, string ddl_halfpartid, string type, string ddl_storeloc, string repairtype, string rejectednum, string userid, string str_loginhost)
    {
        string rtn = "";
        if (rejectednum == "0" || rejectednum == "" || rejectednum == "null" || rejectednum == "NULL")
        {
            rtn = "請輸入正確的結箱數量!";
            return rtn;
        }
        if (ddl_monum == "0" || ddl_monum == "")
        {
            rtn = "剩餘結箱數量異常!";
            return rtn;
        }
        if (ddl_halfpartid == "")
        {
            rtn = "請先維護工單狀態對應的半品料號!";
            return rtn;
        }
        string sql_ngnum0 = @"SELECT * FROM TEMP_REJECTEDMAIN WHERE CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "'";
        DataTable dt_ngnum0 = PubClass.getdatatableMES(sql_ngnum0);
        if(dt_ngnum0.Rows.Count>0)
        {
            if(ddl_halfpartid!=dt_ngnum0.Rows[0]["LH_ID"].ToString())
            {
                rtn = "輸入料號與臨時表中料號不一致，不可刷入!";
                return rtn;
            }
        }
        if (int.Parse(ddl_monum) < int.Parse(rejectednum))
        {
            rtn = "刷入數量大於工單剩餘數量";
            return rtn;
        }
        //int REJECTED_QTY;
        //string sql_ngnum03 = @"SELECT * FROM TEMP_REJECTEDMAIN WHERE CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "'AND ORDER_NO='" + ddl_mo + "'";
        //DataTable dt_ngnum03 = PubClass.getdatatableMES(sql_ngnum03);
        //if(dt_ngnum03.Rows.Count>0)
        //{
        //    string sql_ngnum04 = @"SELECT SUM(REJECTED_QTY)REJECT_QTY FROM TEMP_REJECTEDMAIN WHERE CREATE_USER ='" + userid + "' AND IP='" + str_loginhost + "'AND ORDER_NO='" + ddl_mo + "'";
        //    DataTable dt_ngnum04 = PubClass.getdatatableMES(sql_ngnum04);
        //    REJECTED_QTY = int.Parse(dt_ngnum04.Rows[0]["REJECT_QTY"].ToString());
        //    if(int.Parse(ddl_monum)<(REJECTED_QTY+int.Parse(rejectednum)))
        //    {
        //        rtn = "刷入數量大於工單剩餘數量";
        //        return rtn;
        //    }
        //}            
        //else
        //{
        //}
     
        string sql2 = @"INSERT INTO TEMP_REJECTEDMAIN(LH_ID,CREATE_USER,CREATE_DATE,STORELOC,REJECTED_QTY,ORDER_NO,REPAIRTYPE,STATUS,TYPEID,PAGE,IP)
                        VALUES('" + ddl_halfpartid + "','" + userid + "',SYSDATE,'" + ddl_storeloc + "','" + rejectednum + "','" + ddl_mo + "','" + repairtype + "','" + ddl_halfpart + "','" + type + "','R06','" + str_loginhost + "')";
        DataTable dtAdd = PubClass.getdatatableMES(sql2);
        if (int.Parse(ddl_monum) > int.Parse(rejectednum))
        {
            string sql23 = @"UPDATE SD_OP_REPAIRMOUNCHECK SET INQTY=INQTY-" + rejectednum + " WHERE ORDER_NO='" + ddl_mo + "'";
            DataTable dtAdd3 = PubClass.getdatatableMES(sql23);
        }
        else if (int.Parse(ddl_monum) == int.Parse(rejectednum))
        {
            string sql231 = @"DELETE FROM SD_OP_REPAIRMOUNCHECK WHERE ORDER_NO='" + ddl_mo + "'";
            DataTable dtAdd31 = PubClass.getdatatableMES(sql231);
        } 
        rtn = "刷入成功";
        return rtn;
    }
    
    public static string GetIP()
    {
        try
        {
            string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString().ToUpper();
            return ip;
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}