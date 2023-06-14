<%@ WebHandler Language="C#" Class="Q02Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Data.OracleClient;
using System.IO;
using System.Net;
using System.Reflection;
using System.Collections.Generic;

public class Q02Controller : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string ip = context.Request["ip"];
        string lotid = context.Request["lotid"];
        string user = context.Request["user"];
        switch (funcName)
        {
            case "getip":
                rtnValue = getip();
                break;
            case "getlotnum":
                rtnValue = getlotnum(lotid);
                break;
            case "check":
                rtnValue = check(lotid);
                break;
            case "show":
                rtnValue = show(lotid);
                break;
            case "insert":
                rtnValue = insert(lotid,user);
                break;
        }
        context.Response.Write(rtnValue);
    }

    private string getip()
    {
        string HostName = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string rtn = "[{\"IP\":\"" + HostName + "\"}]";
        return rtn;
    }

    private string getlotnum(string lotid)
    {
        string rtn = ""; string flag = "N"; string msgshow = "";
        DataTable returndt = new DataTable();
        string sql = @"SELECT NVL(SUM(IN_QTY),'0') TOTAL FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "' AND FLAG='Y'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (int.Parse(dt.Rows[0][0].ToString()) > 0)
        {
            msgshow = dt.Rows[0][0].ToString();
        }
        else
        {
            msgshow = "0";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        flag = "Y";
        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
        return rtn;
    }
    private string check(string lotid)
    {
        string rtn = ""; string flag = "N"; string msgshow = "";
        DataTable returndt = new DataTable();
        if (lotid == "" || lotid == string.Empty)
        {
            msgshow = "請輸入批號!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        string tmp_lot = "SELECT ELOT_ID, LOT_ID,IN_QTY FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "' AND FLAG='Y'";
        DataTable dttmp_lot = PubClass.getdatatableMES(tmp_lot);
        if (dttmp_lot.Rows.Count == 0)
        {
            msgshow = "批號有誤，請確認!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }

        string str_lot = "SELECT LOT_ID FROM SD_OP_LOTINFO WHERE IS_QC = 'N' AND LOT_ID IN (SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID = '" + lotid + "')";
        DataTable dt_lot = PubClass.getdatatableMES(str_lot);
        if (dt_lot.Rows.Count == 0)
        {
            msgshow = "此批号已点收，请确认!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }

        flag = "Y"; msgshow = "OK!";
        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
        return rtn;
    }
    private string show(string lotid)
    {
        string rtn = ""; string flag = "N"; string msgshow = "";
        DataTable returndt = new DataTable();
        string sql = @"SELECT ELOT_ID,LOT_ID,IN_QTY FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "' AND FLAG='Y'";
        DataTable dt = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    private string insert(string lotid, string user)
    {
        
        
        string rtn = ""; string flag = "N"; string msgshow = "";
        DataTable returndt = new DataTable();
        string tmp_lot = "SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "' AND FLAG='Y'";
        DataTable dttmp_lot = PubClass.getdatatableMES(tmp_lot);
        string sql_user = "SELECT USER_ID FROM SD_OP_USER WHERE USER_LIMIT LIKE '%TJO006%' AND USER_ID='" + user + "'";
        DataTable dt_user = PubClass.getdatatableMES(sql_user);
        if (dt_user.Rows.Count == 0)
        {
            msgshow = user + "無點收權限!!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        if (dttmp_lot.Rows.Count > 0)
        {
            for (int i = 0; i < dttmp_lot.Rows.Count; i++)
            {
                string tmp_aql1 = "SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID='" + dttmp_lot.Rows[i]["LOT_ID"].ToString() + "'";
                DataTable dt_tmp1 = PubClass.getdatatableMES(tmp_aql1);
                if (dt_tmp1.Rows.Count > 0)
                {
                    string lot_status = dt_tmp1.Rows[0]["lot_status"].ToString();
                    if (lot_status == "H")
                    {
                        msgshow = "Runcard號為" + dt_tmp1.Rows[0]["LOT_ID"].ToString() + "已被Hold，不可點收!";
                        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                        return rtn;
                    }
                    else if (lot_status == "U")
                    {
                        msgshow = "Runcard號為" + dt_tmp1.Rows[0]["LOT_ID"].ToString() + "已取消產線作業，不可點收!";
                        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                        return rtn;
                    }
                    else if (lot_status == "P")
                    {
                        msgshow = "Runcard號為" + dt_tmp1.Rows[0]["LOT_ID"].ToString() + "已完成包裝作業，不可點收!";
                        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                        return rtn;
                    }
                }
                string currentlotid = dttmp_lot.Rows[i]["LOT_ID"].ToString();
                string sqlsysid = "SELECT SEQ_LOTSYSID.NEXTVAL FROM DUAL";
                DataTable dtsysid = PubClass.getdatatableMES(sqlsysid);
                string sysid = dtsysid.Rows[0][0].ToString();
                string sqlnifiid = "SELECT SEQ_LOTOPERMSG.NEXTVAL FROM DUAL";
                DataTable dtnifiid = PubClass.getdatatableMES(sqlnifiid);
                string nifiid = dtnifiid.Rows[0][0].ToString();
                
                DataTable brw = PubClass.getdatatableMES("select * from SD_OP_LOTINFO  where lot_id = '" + currentlotid + "'");
                
                DataTable work = PubClass.getdatatableMES("select * from sd_op_workorder where order_no = '"+brw.Rows[0]["ORDER_NO"].ToString()+"'");
                
                DataTable type = PubClass.getdatatableMES("select BRW_FLAG from sd_base_motype where motype ='" + work.Rows[0]["MOTYPE"] + "'");
                
                PubClass.getdatatableMES("INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID, SYSID,STEP_ID, STEPM_ID,EQP_ID,OUSER,  CREATE_USER,IN_QTY,OUT_QTY,   PASSCOUNT ,LINEID, MO, MO_FLAG1, MO_FLAG2, MO_FLAG3, MO_BRWFLAG,NIFIID,LOTSTATUS) VALUES('" + brw.Rows[0]["LOT_ID"] + "','" + sysid + "','OQC01','OQC01','NULL','" + user + "','" + user + "','" + brw.Rows[0]["LOT_QTY"] + "','" + brw.Rows[0]["LOT_QTY"] + "','1','" + brw.Rows[0]["LINE_ID"] + "','" + brw.Rows[0]["ORDER_NO"] + "','" + work.Rows[0]["SITE"] + "', '" + work.Rows[0]["MO_TYPE"] + "', '" + work.Rows[0]["MODESC"] + "', '" + type.Rows[0]["BRW_FLAG"] + "','" + nifiid + "','R')"); 

                
            }

            OracleConnection con = PubClass.dbconMES();
            OracleTransaction ots;
            con.Open();
            ots = con.BeginTransaction();
            try
            {
                
                OracleCommand cmd2 = new OracleCommand("UPDATE SD_OP_LOTINFO SET IS_QC='Y' WHERE LOT_ID IN(SELECT LOT_ID FROM SD_OP_ELOT WHERE ELOT_ID='" + lotid + "' AND FLAG='Y' ) AND IS_QC='N'", con);

                string sql = @"INSERT INTO SD_HIS_MESWORK(PRODUCT_CODECELL,REMARK,CREATE_USER,CREATE_DATE) VALUES ('" + lotid + @"','OQC點收','" + user + "',SYSDATE)";
                DataTable tl0 = PubClass.getdatatableMES(sql);
                
                cmd2.Transaction = ots;
                cmd2.ExecuteNonQuery();
                ots.Commit();
                //ots.Rollback();
                con.Close();
            }
            catch
            {
                ots.Rollback();
                con.Close();
                msgshow = "程序異常，請聯繫IT!";
                rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                return rtn;
            }
        }
        msgshow = "OQC點收作業已完成"; flag = "Y";
        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
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