<%@ WebHandler Language="C#" Class="Q01Controller" %>

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

public class Q01Controller : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string user = context.Request["user"];
        string funcName = context.Request["funcName"];
        string lotid = context.Request["lotid"];
        string elot = context.Request["elot"];
        switch (funcName)
        {
            case "getIP":
                rtnValue = GetIP();
                break;
            case "GetCnt":
                rtnValue = GetCnt();
                break;
            case "getAUTH_USER":
                rtnValue = GetAUTH_USER();
                break;
            case "check":
                rtnValue = Check(lotid, user);
                break;
            case "show":
                rtnValue = Show();
                break;
            case "addELot":
                rtnValue = AddELot();
                break;
            case "saveELot":
                rtnValue = SaveELot(elot, user);
                break;
            case "clearTmp":
                rtnValue = ClearTmp();
                break;
            case "deleteRow":
                rtnValue = DeleteRow(lotid);
                break;
        }
        context.Response.Write(rtnValue);
    }
    //获取IP
    public static string GetIP()
    {
        try
        {
            string ip = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
            return ip;
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
//获取数量
    public static string GetCnt()
    {
        try
        {
            string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
            str_loginhost = str_loginhost.Replace("WKSCN\\", "");
            string sql1 = "SELECT * FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "'";
            DataTable dt1 = PubClass.getdatatableMES(sql1);
            int cnt=dt1.Rows.Count;
            string var2 = cnt.ToString();
            return var2;
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }
    //获取当前用户
    public static string GetAUTH_USER()
    {
        try
        {
            string user = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
            return user;
        }
        catch (Exception ex)
        {
            return ex.Message;
        }
    }

    private string Check(string lotid, string user)
    {
        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");
        string sql1 = "SELECT * FROM SD_TMP_ELOT WHERE LOT_ID='" + lotid + "'";
        DataTable dt1 = PubClass.getdatatableMES(sql1);
        if (dt1.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此產品已在列表中!\"}]";
        }
        string sqltmp = "SELECT * FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "'";
        DataTable dttmp = PubClass.getdatatableMES(sqltmp);
        string tmp = "";
        string tmp_line = "";
        string tmp_order_no = "";
        string tmp_step = "";
        string sql2 = "SELECT * FROM SD_OP_ELOT WHERE LOT_ID='" + lotid + "'";
        DataTable dt2 = PubClass.getdatatableMES(sql2);
        if (dt2.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批已經結批,請確認!\"}]";
        }
        DataTable dt = PubClass.getdatatableMES("SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID='" + lotid + "'");
        if (dt.Rows.Count > 0)
                {
                    string step_id = dt.Rows[0]["step_current"].ToString();
                    int in_qty = int.Parse(dt.Rows[0]["lot_qty"].ToString());
                    string product_id = dt.Rows[0]["product_id"].ToString();
                    string line_id = dt.Rows[0]["line_id"].ToString();
                    string order_no = dt.Rows[0]["order_no"].ToString();
                    if (dttmp.Rows.Count > 0)
                    {
                        tmp = dttmp.Rows[0]["product_id"].ToString();
                        tmp_line = dttmp.Rows[0]["line_id"].ToString();
                        tmp_order_no = dttmp.Rows[0]["order_no"].ToString();
                        DataTable dtstep = PubClass.getdatatableMES("SELECT DISTINCT STEP_CURRENT FROM SD_OP_LOTINFO WHERE LOT_ID IN (SELECT LOT_ID FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "')");
                        if (dtstep.Rows.Count > 1)
                        {
                            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"臨時表中存在不同站點LOT 請清空重刷!\"}]";
                        }
                        else
                        {
                            tmp_step = dtstep.Rows[0]["step_current"].ToString();
                        }
                    }
                    else
                    {
                        tmp = dt.Rows[0]["product_id"].ToString();
                        tmp_line = dt.Rows[0]["line_id"].ToString();
                        tmp_order_no = dt.Rows[0]["order_no"].ToString();
                        tmp_step = dt.Rows[0]["step_current"].ToString();
                    }
                            if (tmp != product_id)
                            {
                                return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批在幾種與列表中幾種不同，請確認!\"}]";
                            }
                            if (tmp_line != line_id)
                            {
                                return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批所屬線別與列表中的線別不同，請確認!\"}]";
                            }
                            if (tmp_step != step_id)
                            {
                                return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批所在站點與列表中的站點不同，請確認!\"}]";
                            }
                            if ("OQC01" != step_id)
                            {
                                    return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批在" + step_id + "站!\"}]";
                            }
                            if ((dt.Rows[0]["is_lock"].ToString() == "Y") && (str_loginhost != dt.Rows[0]["lock_cpu"].ToString()))
                            {
                                return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批已被" + dt.Rows[0]["lock_cpu"].ToString() + "锁定!\"}]";
                            }
                    //卡控正常和重工工單批號不可以混批 By  Arthur
                    string reworksql = "SELECT DISTINCT  DECODE(C.MOTYPE,'ZBTS','N','ZMPC','N','ZBTO','N','ZBTL','Y','ZMPR','Y','ZMPD','Y','ZRMA','Y',C.MOTYPE)REWORK FROM SD_TMP_ELOT A,SD_OP_LOTINFO B,SD_OP_WORKORDER C WHERE A.LOT_ID=B.LOT_ID AND B.ORDER_NO=C.ORDER_NO AND ADDR_IP='" + str_loginhost + "'";
                    DataTable reworkdt = PubClass.getdatatableMES(reworksql);
                    if (reworkdt.Rows.Count > 1)
                    {
                        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"臨時表中存在重工工單和正常工單混批現象，請清空重新結大批!\"}]";
                    }
                    else if (reworkdt.Rows.Count == 1)
                    {
                        string checksql = "SELECT  DISTINCT  DECODE(B.MOTYPE,'ZBTS','N','ZMPC','N','ZBTO','N','ZBTL','Y','ZMPR','Y','ZMPD','Y','ZRMA','Y',B.MOTYPE)REWORK FROM SD_OP_LOTINFO A,SD_OP_WORKORDER B WHERE A.ORDER_NO=B.ORDER_NO AND A.LOT_ID='" + lotid + "'";
                        DataTable checkdt = PubClass.getdatatableMES(checksql);
                        if (checkdt.Rows.Count == 0)
                        {
                            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批號信息或工單信息異常!\"}]";
                        }
                        else
                        {
                            if (reworkdt.Rows[0][0].ToString() != checkdt.Rows[0][0].ToString())
                            {
                                if (reworkdt.Rows[0][0].ToString() == "Y")
                                {
                                    return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批號為重工工單，臨時表中為正常工單，不可混批!\"}]";
                                }
                                else
                                {
                                    return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此批號為正常工單，臨時表中為重工工單，不可混批!\"}]";
                                }
                            }
                        }
                    }
                    string sqlinsert = "insert into sd_tmp_elot (lot_id,in_qty,create_user,addr_ip,product_id,line_id,order_no) values ('" + lotid + "'," + in_qty + ",'" + user + "','" + str_loginhost + "','" + product_id + "','" + line_id + "','" + order_no + "')";
                    PubClass.getdatatablenoreturnMES(sqlinsert);
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"Check成功!\"}]";
                }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"沒有找到此批號!\"}]";
    }

    private string Show()
    {
        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");
        
        string sql = "SELECT * FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "'";
       
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }

    private string AddELot()
    {
        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");
        //str_loginhost = "B_LM904";
        string sql = "SELECT * FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "'";
        DataTable dt = PubClass.getdatatableMES(sql);

        string sql1 = "SELECT DISTINCT STEP_CURRENT ,PROCESS_NAME,LINE_ID  FROM SD_OP_LOTINFO WHERE LOT_ID IN (SELECT LOT_ID FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "')";
        DataTable dt1 = PubClass.getdatatableMES(sql1);
        OracleConnection con = PubClass.dbconMES();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();
        if (dt.Rows.Count > 0)
        {
            string sqltmp = "select substr(to_char(sysdate,'yMMdd'),0,1) A,substr(to_char(sysdate,'yyMMdd'),3,2) B,substr(to_char(sysdate,'yyMMdd'),5,2) C from dual";
            DataTable dttmp = PubClass.getdatatableMES(sqltmp);
            string A = dttmp.Rows[0]["A"].ToString();
            string B = dttmp.Rows[0]["B"].ToString();
            string C = dttmp.Rows[0]["C"].ToString();
            string line_id = dt1.Rows[0]["line_id"].ToString();
            if (line_id == "NULL" || line_id == "") {
                line_id = "6";
            }
            if (line_id.Substring(0, 1) == "B" || line_id.Substring(0, 1) == "A")
            {
                line_id = (10 + int.Parse(line_id.Substring(1, line_id.Length - 1))).ToString();
            }
            if (line_id.Substring(0, 1) == "F" || line_id.Substring(0, 2) == "HL")
            {
                line_id = (10 + int.Parse(line_id.Substring(3, line_id.Length - 3))).ToString();
            }
            string sqlx1 = "select inttoh25('" + line_id + "',1) line_01,'" + A + "' y_01,INTTOH16('" + B + "',1) m_01,inttoV32('" + C + "',1) r_01 from dual";
            DataTable dtx1 = PubClass.getdatatableMES(sqlx1);
            string elot_id = "F0" + dtx1.Rows[0]["line_01"].ToString() + dtx1.Rows[0]["y_01"].ToString() + dtx1.Rows[0]["m_01"].ToString() + dtx1.Rows[0]["r_01"].ToString() + "-";
            string sqlx2 = "select max(substr(elot_id,8,3)) sysid from sd_op_elot where elot_id like '" + elot_id + "%'";
            DataTable dtx2 = PubClass.getdatatableMES(sqlx2);
            int sysid = 1;
            if (dtx2.Rows.Count > 0)
            {
                string sqlx4 = "select h10toint('" + dtx2.Rows[0]["sysid"].ToString() + "') from dual";
                DataTable dtx4 = PubClass.getdatatableMES(sqlx4);
                sysid = int.Parse(dtx4.Rows[0][0].ToString());
                sysid = sysid + 1;
            }
            string sqlx3 = "select inttoh10(" + sysid + ",3) from dual";
            DataTable dtx3 = PubClass.getdatatableMES(sqlx3);
            elot_id = elot_id + dtx3.Rows[0][0].ToString();
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + elot_id + "\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"請輸入產品!\"}]";
    }

    private string SaveELot(string elot, string user)
    {
        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");

        string sql1 = "SELECT DISTINCT STEP_CURRENT ,PROCESS_NAME FROM SD_OP_LOTINFO WHERE LOT_ID IN (SELECT LOT_ID FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "')";
        DataTable dt1 = PubClass.getdatatableMES(sql1);
        OracleConnection con = PubClass.dbconMES();
        OracleTransaction ots;
        
        con.Open();
        ots = con.BeginTransaction();
        try
        {
            OracleCommand cmd1 = new OracleCommand("insert into sd_op_elot (elot_id,lot_id,in_qty,create_time,create_user,product_id,order_no,line_id) select '" + elot + "',lot_id,in_qty,sysdate,'" + user + "',product_id,order_no,line_id from sd_tmp_elot where addr_ip='" + str_loginhost + "'", con);
            OracleCommand cmd2 = new OracleCommand("update sd_op_lotinfo set is_fqc='Y' where lot_id in (select lot_id from sd_tmp_elot where addr_ip='" + str_loginhost + "')", con);
            OracleCommand cmd4 = new OracleCommand("delete from sd_tmp_elot where addr_ip='" + str_loginhost + "'", con);
            cmd1.Transaction = ots;
            cmd2.Transaction = ots;
            cmd4.Transaction = ots;
            cmd1.ExecuteNonQuery();
            cmd2.ExecuteNonQuery();
            cmd4.ExecuteNonQuery();
        }
            
        catch
        {
            ots.Rollback();
            con.Close();
            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"結批出錯!\"}]";
        }
        ots.Commit();
        string lot_id = "";
        string sql2 = "SELECT * FROM sd_op_elot  WHERE ELOT_ID='" + elot + "' ";
        DataTable dt2 = PubClass.getdatatableMES(sql2);
        for (int i = 0; i < dt2.Rows.Count; i++)
        {
            lot_id = dt2.Rows[i]["LOT_ID"] + "";
            string sqlsysid = "SELECT SEQ_LOTSYSID.NEXTVAL FROM DUAL";
            DataTable dtsysid = PubClass.getdatatableMES(sqlsysid);
            string sysid = dtsysid.Rows[0][0].ToString();

            string sqlnifiid = "SELECT SEQ_LOTOPERMSG.NEXTVAL FROM DUAL";
            DataTable dtnifiid = PubClass.getdatatableMES(sqlnifiid);
            string nifiid = dtnifiid.Rows[0][0].ToString();
            DataTable brw = PubClass.getdatatableMES("select * from SD_OP_LOTINFO  where lot_id = '" + lot_id + "'");
            //select * from sd_op_workorder where order_no = '000000000001'
            DataTable work = PubClass.getdatatableMES("select * from sd_op_workorder where order_no = '" + brw.Rows[0]["ORDER_NO"].ToString() + "'");

            DataTable type = PubClass.getdatatableMES("select BRW_FLAG from sd_base_motype where motype ='" + work.Rows[0]["MOTYPE"] + "'");
            PubClass.getdatatableMES("INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID, SYSID,STEP_ID, STEPM_ID,EQP_ID,OUSER,  CREATE_USER,IN_QTY,OUT_QTY,   PASSCOUNT ,LINEID, MO, MO_FLAG1, MO_FLAG2, MO_FLAG3, MO_BRWFLAG,NIFIID,LOTSTATUS) VALUES('" + brw.Rows[0]["LOT_ID"] + "','" + sysid + "','OQC01','OQC01','NULL','" + user + "','" + user + "','" + brw.Rows[0]["LOT_QTY"] + "','" + brw.Rows[0]["LOT_QTY"] + "','1','" + brw.Rows[0]["LINE_ID"] + "','" + brw.Rows[0]["ORDER_NO"] + "','" + work.Rows[0]["SITE"] + "', '" + work.Rows[0]["MO_TYPE"] + "', '" + work.Rows[0]["MODESC"] + "', '" + type.Rows[0]["BRW_FLAG"] + "','" + nifiid + "','C')");
        }
          
           con.Close();
        return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"結批成功!\"}]";
        
        
        
    }

    private string ClearTmp()
    {
        string str_loginhost = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        str_loginhost = str_loginhost.Replace("WKSCN\\", "");//CIM\F2-09_FQCM
        string sql = "DELETE FROM SD_TMP_ELOT WHERE ADDR_IP='" + str_loginhost + "'";
        PubClass.getdatatablenoreturnMES(sql);
        return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表已清空!\"}]";
    }

    private string DeleteRow(string lotid)
    {
        string sql = "DELETE FROM SD_TMP_ELOT WHERE LOT_ID='" + lotid + "'";
        PubClass.getdatatablenoreturnMES(sql);
        return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表已刪除" + lotid + "!\"}]";
    }
    
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}