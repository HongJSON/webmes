<%@ WebHandler Language="C#" Class="R02Controller" %>

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
using MesRepository;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient;
using System.IO;
using System.Collections.Generic;

public class R02Controller : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = "獲取數據失敗";
        string funcName = context.Request["funcName"];
        string Ip = HttpContext.Current.Request.UserHostAddress.ToString();
        string boxid = context.Request["boxid"];
        string item = context.Request["item"];
        string userid = context.Request["userid"];
        string REJECTED_ID = context.Request["REJECTED_ID"];
        string PRODUCT_ID = context.Request["PRODUCT_ID"];
        switch (funcName)
        {
            case "add":
                rtnValue = add(userid, Ip, boxid, item);
                break;
            case "show":
                rtnValue = show(Ip, userid);
                break;
            case "btn_delPro":
                rtnValue = btn_delPro(REJECTED_ID, PRODUCT_ID,Ip, userid);
                break;
            case "clear":
                rtnValue = clear(Ip, userid);
                break;
            case "btn_Click":
                rtnValue = btn_Click(Ip, userid, item);
                break;
        }
        context.Response.Write(rtnValue);
    }
    private string add(string userid, string Ip, string boxid, string item)
    {
        string SQL1 = "SELECT * FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "' AND REJECTED_ID='" + boxid + "'";
        DataTable DTSQL = PubClass.getdatatableMES(SQL1);
        if(DTSQL.Rows.Count>0)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此箱號已刷入臨時表，不可重複刷入，謝謝!\"}";
        }
        string sql = "SELECT * FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID='" + boxid + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if(dt.Rows.Count==0)
        {
            return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此箱號不存在或不屬於所選擇拆箱類型!\"}";
        }
        else
        {
            string SqlBreak = "SELECT * FROM SD_OP_REJECTEDMAIN WHERE FLAG='N'  AND REJECTED_ID='" + boxid + "'";
            DataTable DtBreak = PubClass.getdatatableMES(SqlBreak);
            if(DtBreak.Rows.Count>0)
            {
                return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此箱中產品已拆箱!\"}";
            }
            string sqlAdd = "INSERT INTO SD_TMP_R39(ORDER_NO,REJECTED_ID,PRODUCT_ID,RJ_QTY,STORE_LOC,IP_ADDR,RECEIVE_USER,RECEIVE_DATE) SELECT ORDER_NO,REJECTED_ID,LH_ID,REJECTED_QTY,STORELOC,'" + Ip + @"','" + userid + @"',SYSDATE FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID ='" + boxid + @"'";
            DataTable dtAdd = PubClass.getdatatableMES(sqlAdd);
        }
        return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"刷入成功!\"}";
    }
    private string show(string Ip, string userid)
    {
        string rtn = "";
        string sqlmo = "SELECT ORDER_NO,REJECTED_ID,PRODUCT_ID,RJ_QTY,STORE_LOC FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "' ORDER BY  RECEIVE_DATE DESC";
        DataTable cpn1 = PubClass.getdatatableMES(sqlmo);
        rtn = JsonConvert.SerializeObject(cpn1);
        return rtn;
    }
    private string btn_delPro(string REJECTED_ID, string PRODUCT_ID, string Ip, string userid)
    {
        string sqlAdd = "DELETE FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "'AND REJECTED_ID ='" + REJECTED_ID + @"'AND PRODUCT_ID ='" + PRODUCT_ID + @"' ";
        DataTable dtAdd = PubClass.getdatatableMES(sqlAdd);
        return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"刪除成功!\"}";
    }
    private string clear(string Ip, string userid)
    {
        string sqlAdd = "DELETE FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "'";
        DataTable dtAdd = PubClass.getdatatableMES(sqlAdd);
        return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"刪除成功!\"}";
    }
    private string btn_Click(string Ip, string userid, string item)
    {
        string str_flag = "";
        string machineName = HttpContext.Current.Request.UserHostName;
        machineName = System.Net.Dns.Resolve(machineName).HostName;
        string[] strArray1 = machineName.Split('.');
        machineName = strArray1[0].ToString();
        string HostName = machineName.ToUpper();
        string sqlHost = "SELECT * FROM SD_TMP_PCMEMORY WHERE  TREEID ='TJO00C' AND PC_ID='" + HostName + "'";
        DataTable dtHost = PubClass.getdatatableMES(sqlHost);
        if(dtHost.Rows.Count==0)
        {
            return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此电脑采编无作业权限，維修室聯繫Vicky!\"}";
        }
        string sqlTMP = "SELECT * FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "'";
        DataTable dtTMP = PubClass.getdatatableMES(sqlTMP);
        if (dtTMP.Rows.Count == 0)
        {
            return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"請先刷入需拆箱箱號，謝謝!\"}";  
        }
        string SQLCHECK = " select*  FROM SD_OP_REPAIRMOCHECK  WHERE ORDER_NO NOT IN (SELECT ORDER_NO FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "')";
        DataTable dtCHECK = PubClass.getdatatableMES(SQLCHECK);
        if(dtCHECK.Rows.Count>0)
        {
            return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此箱號數據異常，請聯繫IT!\"}";  
        }
        

        string SQLPID1 = "SELECT DISTINCT ORDER_NO FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "'";
        DataTable dtPID1 = PubClass.getdatatableMES(SQLPID1);
        for (int i = 0; i < dtPID1.Rows.Count; i++)
        {
            string ORDERNO = dtPID1.Rows[i]["ORDER_NO"].ToString();
            string SQLMO = "SELECT SUM(RJ_QTY)QTY FROM SD_TMP_R39 WHERE ORDER_NO='" + ORDERNO + "' AND IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "'";
            DataTable DTSQLMO = PubClass.getdatatableMES(SQLMO);
            string qtynum = DTSQLMO.Rows[i]["QTY"].ToString();
            string SQLMO1 = "SELECT * FROM SD_OP_REPAIRMOCHECK WHERE ORDER_NO='" + ORDERNO + "'";
            DataTable DTSQLMO1 = PubClass.getdatatableMES(SQLMO1);
            string qtynoqty = DTSQLMO1.Rows[i]["INQTY"].ToString();
            string shenyu = (int.Parse(qtynoqty) - int.Parse(qtynum)).ToString();
            string sqlpincim1 = "UPDATE SD_OP_REPAIRMOCHECK SET INQTY ='" + shenyu + "'WHERE ORDER_NO='" + ORDERNO + "'";
            PubClass.getdatatablenoreturnMES(sqlpincim1);
            string SQLMO2 = "SELECT * FROM SD_OP_REPAIRMOUNCHECK WHERE ORDER_NO='" + ORDERNO + "'";
            DataTable DTSQLMO2 = PubClass.getdatatableMES(SQLMO2);
            if(DTSQLMO2.Rows.Count==0)
            {
                string sqlmo = "INSERT INTO SD_OP_REPAIRMOUNCHECK(order_no,inqty)VALUES('" + ORDERNO + "','" +qtynum+ "')";
                PubClass.getdatatablenoreturnMES(sqlmo);
            }
            else
            {
                string sqlmo = "UPDATE SD_OP_REPAIRMOUNCHECK SET INQTY =INQTY+" + qtynum + " WHERE ORDER_NO='" + ORDERNO + "'";
                PubClass.getdatatablenoreturnMES(sqlmo);
            }
            
            
            
            
        }    
       OracleConnection con = PubClass.dbconMES();
       OracleTransaction ots;
       con.Open();
       ots = con.BeginTransaction();
       try
       {
           OracleCommand cmd1 = new OracleCommand(@"UPDATE SD_OP_REJECTEDMAIN SET FLAG='N',RECEIVE_USER='" + userid + "',RECEIVE_DATE=SYSDATE WHERE REJECTED_ID IN(SELECT REJECTED_ID FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "')", con);
           cmd1.Transaction = ots; cmd1.ExecuteNonQuery();
           ots.Commit();
           con.Close();
           string sqlAdd = "DELETE FROM SD_TMP_R39 WHERE IP_ADDR='" + Ip + "'AND RECEIVE_USER='" + userid + "'";
           DataTable dtAdd = PubClass.getdatatableMES(sqlAdd);
           return "{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"拆箱成功!\"}";
       }
       catch
       {
           ots.Rollback();
           con.Close();
           return "{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"拆箱失敗!\"}";
       }  
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}