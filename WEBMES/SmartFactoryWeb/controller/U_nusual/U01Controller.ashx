<%@ WebHandler Language="C#" Class="U01Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Data.OracleClient;

public class U01Controller : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string lotid = context.Request["lotid"];
        string user = context.Request["user"];
        string ip = context.Request["ip"];
        string pageid = context.Request["pageid"];
        string lotnum = context.Request["lotnum"];
        string step = context.Request["step"];
        string rb2 = context.Request["rb2"];
        string remark = context.Request["remark"];

        switch (funcName)
        {
            case "getip":
                rtnValue = getip();
                break;
            case "getpage":
                rtnValue = getpage(pageid);
                break;
            case "getlotnum":
                rtnValue = getlotnum(lotid);
                break;
            case "keylottmp":
                rtnValue = keylottmpin(pageid, lotid, user, lotnum);
                break;
            case "show":
                rtnValue = show(pageid);
                break;
            case "getqtyy":
                rtnValue = getqtyy(user, pageid);
                break;
            case "delete":
                rtnValue = delete(lotid, pageid);
                break;
            case "clearall":
                rtnValue = clearall(pageid);
                break;
            case "lotinsert":
                rtnValue = chailot(pageid, user, lotid, remark, step, rb2);
                break;
        }
        context.Response.Write(rtnValue);
    }

    private string getqtyy(string user, string guid)
    {
        string flag = "N"; string msg = ""; string qtyy = ""; string rtn = "";
        string sqlqty = "select SUM(LOTNUM)qtyy from  SD_TMP_BREAKLOT where create_user='" + user + "' and addr_ip='" + GETIP() + "' AND GUID='" + guid + "'";
        DataTable sqlqty1 = PubClass.getdatatableMES(sqlqty);
        qtyy = sqlqty1.Rows[0]["qtyy"].ToString();
        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\",\"QTYY\":\"" + qtyy + "\"}]";
        return rtn;
    }

    private string getip()
    {
        string HostName = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string rtn = "[{\"IP\":\"" + HostName + "\"}]";
        return rtn;
    }
    private string GETIP()
    {
        string HostName = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        return HostName;
    }
    private string getpage(string pageid)
    {
        string lotid = "NA";
        string sqllot = "select DISTINCT LOT_ID from  SD_TMP_BREAKLOT where addr_ip='" + GETIP() + "' AND GUID='" + pageid + "'";
        DataTable dtlot = PubClass.getdatatableMES(sqllot);
        if (dtlot.Rows.Count > 0)
        {
            lotid = dtlot.Rows[0]["LOT_ID"].ToString();
        }
        string rtn = "[{\"LOTID\":\"" + lotid + "\"}]";
        return rtn;
    }
    private string getlotnum(string lotid)
    {
        string rtn = "";
        string flag = "Y"; string msg = "OK"; string LOTSTATUS = ""; string LOTQTY = ""; string STEP = ""; string MO = "";
        if (lotid == "")
        {
            flag = "N";
            msg = "lot_id欄目不能為空";
        }
        else
        {
            string sql = "SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID='" + lotid + "'";
            DataTable dt = PubClass.getdatatableMES(sql);
            if (dt.Rows.Count > 0)
            {
                if (dt.Rows[0]["LOT_STATUS"].ToString() == "H")
                {
                    flag = "N";
                    msg = "此LOT為HOLD狀態，無法進行此操作！";
                }
                if (dt.Rows[0]["LOT_STATUS"].ToString() == "U")
                {
                    flag = "N";
                    msg = "此LOT已取消产线作业，無法進行此操作！";
                }
                if (dt.Rows[0]["STEP_CURRENT"].ToString().ToUpper() == "OQC01" && dt.Rows[0]["IS_QC"].ToString().ToUpper() == "Y")
                {
                    flag = "N";
                    msg = "此LOT在OQC站且已点收，不能進行拆批！";
                }
                if (dt.Rows[0]["STEP_CURRENT"].ToString().ToUpper() == "OQC02" && dt.Rows[0]["IS_QC"].ToString().ToUpper() == "Y")
                {
                    flag = "N";
                    msg = "此LOT在OQC站且已点收，不能進行拆批！";
                }
                if (dt.Rows[0]["IS_LOCK"].ToString() == "Y")
                {
                    flag = "N";
                    msg = "此LOT正在過帳，不能進行拆批，請確認！";
                }

                DataTable dtelot = PubClass.getdatatableMES("SELECT * FROM SD_OP_ELOT WHERE LOT_ID='" + lotid + "'AND FLAG='Y'");
                if (dtelot.Rows.Count > 0)
                {
                    flag = "N";
                    msg = "此LOT还未拆除大批号，不能進行拆批，請確認！";
                }
                LOTSTATUS = dt.Rows[0]["LOT_STATUS"].ToString();
                LOTQTY = dt.Rows[0]["LOT_QTY"].ToString();
                STEP = dt.Rows[0]["STEP_CURRENT"].ToString();
                MO = dt.Rows[0]["ORDER_NO"].ToString();
            }
            else
            {
                flag = "N";
                msg = "未發現此runcard,請聯繫IT";
            }
        }
        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\",\"LOTQTY\":\"" + LOTQTY + "\",\"STEP\":\"" + STEP + "\",\"MO\":\"" + MO + "\"}]";
        return rtn;
    }

    private string keylottmpin(string guid, string lot_id, string user, string lotnum)
    {
        string rtn = "";
        string flag = "Y";
        string msg = "";
        string uid = guid;
        lotnum = lotnum.Trim();
        if (lotnum == "" && flag == "Y")
        {
            flag = "N";
            msg = "請刷入產品數量!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            return rtn;
        }

        string sql = "SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID='" + lot_id + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["LOT_STATUS"].ToString() == "H")
            {
                flag = "N";
                msg = "此LOT為HOLD狀態，無法進行此操作！";
                return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            }
            if (dt.Rows[0]["LOT_STATUS"].ToString() == "U")
            {
                flag = "N";
                msg = "此LOT已取消产线作业，無法進行此操作！";
                return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            }
            if (dt.Rows[0]["STEP_CURRENT"].ToString().ToUpper() == "OQC01" && dt.Rows[0]["IS_QC"].ToString().ToUpper() == "Y")
            {
                flag = "N";
                msg = "此LOT在OQC站且已点收，不能進行拆批！";
                return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            }
            if (dt.Rows[0]["STEP_CURRENT"].ToString().ToUpper() == "OQC02" && dt.Rows[0]["IS_QC"].ToString().ToUpper() == "Y")
            {
                flag = "N";
                msg = "此LOT在OQC站且已点收，不能進行拆批！";
                return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            }
            if (dt.Rows[0]["IS_LOCK"].ToString() == "Y")
            {
                flag = "N";
                msg = "此LOT正在過帳，不能進行拆批，請確認！";
                return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            }

            DataTable dtelot = PubClass.getdatatableMES("SELECT * FROM SD_OP_ELOT WHERE LOT_ID='" + lot_id + "'AND FLAG='Y'");
            if (dtelot.Rows.Count > 0)
            {
                flag = "N";
                msg = "此LOT还未拆除大批号，不能進行拆批，請確認！";
                return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            }
        }
        else
        {
            flag = "N";
            msg = "未發現此runcard,請聯繫IT";
            return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
        }

        string sqlchip = "SELECT A.ORDER_NO,B.CODE_ID, ARY_LOT,BRW_FLAG,LOT_QTY FROM SD_OP_LOTINFO A,SD_BASE_CODEWITHPRODUCT B WHERE A.LOT_ID='" + lot_id + "' AND A.PRODUCT_ID=B.PRODUCT_ID";
        DataTable dtchip = PubClass.getdatatableMES(sqlchip);
        if (dtchip.Rows.Count == 0)
        {
            flag = "N";
            msg = "該lot所屬料號不存在,請確認~";
            return rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
        }
        try
        {
            int.Parse(lotnum);
        }
        catch
        {
            flag = "N";
            msg = "拆批數請輸入數字~";
            rtn = rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            return rtn;
        }
        if (int.Parse(dtchip.Rows[0]["LOT_QTY"].ToString()) <= int.Parse(lotnum))
        {
            flag = "N";
            msg = "拆批數量不能大於或等於原批號";
            rtn = rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            return rtn;
        }

        string sql2 = "SELECT * FROM SD_TMP_BREAKLOT WHERE LOT_ID='" + lot_id + "' AND guid='" + guid + "'";
        DataTable dt2 = PubClass.getdatatableMES(sql2);
        if (dt2.Rows.Count > 0 && flag == "Y")
        {
            flag = "N";
            msg = "此批號已刷入!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
            return rtn;
        }

        string sqlinsert = "insert into SD_TMP_BREAKLOT (lot_id,lotnum,create_user,create_time,addr_ip,arraylot,GUID) values ('" + lot_id + "','" + lotnum + "','" + user + "',sysdate,'" + GETIP() + "','" + dtchip.Rows[0]["ARY_LOT"].ToString() + "','" + guid + "')";
        PubClass.getdatatablenoreturnMES(sqlinsert);
        flag = "Y";
        msg = "OK";
        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
        return rtn;
    }

    private string show(string guid)
    {
        string rtn = "";
        string sql = "SELECT * FROM SD_TMP_BREAKLOT WHERE ADDR_IP='" + GETIP() + "' AND GUID='" + guid + "' ORDER BY CREATE_TIME DESC";
        DataTable dt = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    private string delete(string LOT_ID, string GUID)
    {
        string rtn = "";
        string sql = "DELETE FROM SD_TMP_BREAKLOT WHERE LOT_ID='" + LOT_ID + "' AND GUID='" + GUID + "' AND ADDR_IP='" + GETIP() + "'";
        PubClass.getdatatablenoreturnMES(sql);
        rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"OK\"}]";
        return rtn;
    }
    private string clearall(string guid)
    {
        string rtn = "";
        string sql = "DELETE FROM SD_TMP_BREAKLOT WHERE ADDR_IP='" + GETIP() + "' AND GUID='" + guid + "'";
        PubClass.getdatatablenoreturnMES(sql);
        rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"OK\"}]";
        return rtn;
    }

    private string chailot(string guid, string user, string lotid, string remark, string step, string rb2)
    {
        string rtn = "";
        string flag = "Y";
        string msg = "OK";
        string tmpnum = ""; string newlot_id = "";
        string str_arylot = "";

        DataTable dtlot = PubClass.getdatatableMES("select ary_lot from sd_op_lotinfo where lot_id = '" + lotid + "'");
        if (dtlot.Rows.Count > 0)
        {
            str_arylot = dtlot.Rows[0][0].ToString();
        }

        string sql11 = @"select * from SD_TMP_BREAKLOT a where a.addr_ip='" + GETIP() + "' and a.lot_id='" + lotid + "' AND A.GUID='" + guid + "'";
        DataTable dt11 = PubClass.getdatatableMES(sql11);
        if (dt11.Rows.Count == 0)
        {
            return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"刷入的產品lot和實際不符，不可拆批！\"}]";
        }

        OracleConnection con = PubClass.dbconMES();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();
        string sql = "SELECT * FROM SD_TMP_BREAKLOT where addr_ip='" + GETIP() + "' and lot_id='" + lotid + "' AND GUID='" + guid + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        string sqlnn = "select * from sd_op_lotinfo where lot_id='" + lotid + "'";
        DataTable dtnn = PubClass.getdatatableMES(sqlnn);
        string line_id = "";
        string step_id = "";
        string brw_flag = "";
        string order = "";
        int newcount = 0, oldcount = 0;
        try
        {
            newcount = int.Parse(dt.Rows[0]["lotnum"].ToString());
            oldcount = int.Parse(dtnn.Rows[0]["LOT_QTY"].ToString());
        }
        catch
        {
            return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"拆批批號數量有異常,請確認！\"}]";
        }
        if (dtnn.Rows.Count > 0)
        {
            if (dtnn.Rows[0]["is_lock"].ToString() == "Y")
            {
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT正在過帳，不能進行拆批，請確認！\"}]";
            }
            line_id = dtnn.Rows[0]["line_id"].ToString();
            step_id = dtnn.Rows[0]["step_current"].ToString();
            brw_flag = dtnn.Rows[0]["brw_flag"].ToString();
            order = dtnn.Rows[0]["ORDER_NO"].ToString();
            if (dtnn.Rows[0]["lot_status"].ToString() == "H")
            {
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT為HOLD狀態，無法進行此操作！\"}]";
            }
            if (dtnn.Rows[0]["lot_status"].ToString() == "U")
            {
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT已取消产线作业，無法進行此操作！\"}]";
            }
            if (dtnn.Rows[0]["step_current"].ToString().ToUpper() == "OQC01" && dtnn.Rows[0]["is_qc"].ToString().ToUpper() == "Y")
            {
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT在OQC站且已点收，不能進行拆批！\"}]";
            }
            if (dtnn.Rows[0]["step_current"].ToString().ToUpper() == "OQC02" && dtnn.Rows[0]["is_qc"].ToString().ToUpper() == "Y")
            {
                flag = "N"; msg = "此LOT在OQC站且已点收，不能進行拆批！";
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT在OQC站且已点收，不能進行拆批\"}]";
            }
            if (dtnn.Rows[0]["is_lock"].ToString() == "Y")
            {
                flag = "N"; msg = "此LOT正在過帳，不能進行拆批，請確認！";
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT正在過帳，不能進行拆批，請確認！\"}]";
            }
            DataTable dtelot = PubClass.getdatatableMES("select * from SD_OP_ELOT where lot_id='" + lotid + "'and flag='Y'");
            if (dtelot.Rows.Count > 0)
            {
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"此LOT还未拆除大批号，不能進行拆批，請確認！\"}]";
            }
        }
        //獲取機種信息
        string codeid = "";
        string getpro = "SELECT * FROM SD_OP_WORKORDER WHERE ORDER_NO='" + order + "' AND IS_CLOSED='N' ";
        DataTable dtPro = PubClass.getdatatableMES(getpro);
        if (dtPro.Rows.Count > 0)
        {
            codeid = dtPro.Rows[0]["MO_TYPE"].ToString();
        }

        string sqlll = "SELECT SEQ_LOTSYSID.NEXTVAL  sysid FROM DUAL";
        DataTable dtll = PubClass.getdatatableMES(sqlll);
        int sysid = 0;
        if (dtll.Rows.Count > 0)
        {
            sysid = int.Parse(dtll.Rows[0]["sysid"].ToString());
        }
        if (dt.Rows.Count > 0)
        {
            //string sqltmpnum = "SELECT INTTOH10(MRLOT_SEQENCE.NEXTVAL ,4) FROM DUAL";
            //DataTable dttmpnum = PubClass.getdatatableMES(sqltmpnum);
            //tmpnum = dttmpnum.Rows[0][0].ToString();
            //sqltmpnum = "SELECT 'K'||TO_CHAR(SYSDATE,'ymmdd')||'" + tmpnum + "' FROM DUAL";
            //dttmpnum = PubClass.getdatatableMES(sqltmpnum);
            //tmpnum = dttmpnum.Rows[0][0].ToString();
            //string sqlnew = "select * from sd_op_lotinfo where lot_id = '" + tmpnum + "'";
            //DataTable dtnew = PubClass.getdatatableMES(sqlnew);
            //if (dtnew.Rows.Count > 0)
            //{
            //    return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"批号生成错误，请联系IT！\"}]";
            //}
            //else
            //{
            //    newlot_id = tmpnum;
            //}

            if (lotid.Contains("."))//判斷拆批的批號是否已經是子批
            {
                int cnt = lotid.IndexOf('.');
                newlot_id = lotid.Substring(0, cnt + 1);
            }
            else
            {
                newlot_id = lotid + ".";
            }
            string sqlnew = "select * from sd_op_lotinfo where lot_id like '" + newlot_id + "%'";
            DataTable dtnew = PubClass.getdatatableMES(sqlnew);
            if (dtnew.Rows.Count > 0)
            {
                int tmp1 = dtnew.Rows.Count;
                tmp1 = tmp1 + 1;
                string sqltmp = "select INTTOH10(" + tmp1 + ",3) from dual";
                DataTable dtsqltmp = PubClass.getdatatableMES(sqltmp);
                string tmp = dtsqltmp.Rows[0][0].ToString();
                newlot_id = newlot_id + tmp;
            }
            else
            {
                newlot_id = newlot_id + "001";
            }
            try
            {
                OracleCommand cmd1 = new OracleCommand("update sd_op_lotinfo set lot_qty=lot_qty-" + newcount + ",modify_user='" + user + "',modify_date=sysdate where lot_id='" + lotid + "'", con);
                //20181129 
                OracleCommand cmd2 = new OracleCommand(@"insert into sd_op_lotinfo 
                                                         (lot_id, order_no, product_id, create_date, process_name, step_currentid, step_current, step_lastid, step_last, lot_status, lot_startqty, lot_qty, pa_qty, line_id, workcenter, modify_user, modify_date, create_user, is_lock, lock_cpu, brw_flag, is_qc, is_fqc, ary_lot) 
                                                         select '" + newlot_id + "', order_no, product_id, create_date, process_name, step_currentid, step_current, step_lastid, step_last, lot_status, lot_startqty, '" + newcount + "', pa_qty, line_id, workcenter, modify_user, modify_date, create_user, is_lock, lock_cpu, brw_flag, is_qc, is_fqc, ary_lot  from sd_op_lotinfo where lot_id='" + lotid + "'", con);

                OracleCommand cmd3 = new OracleCommand("insert into sd_his_lotopermsg (lot_id,sysid,step_id,eqp_id,ouser,create_user,in_qty,out_qty,stepm_id,PASSCOUNT,lineid) select lot_id," + sysid + ",step_current,'','" + user + "','" + user + "',lot_qty+" + newcount + ",lot_qty,step_current,'1',line_id from sd_op_lotinfo where lot_id='" + lotid + "'", con);
                OracleCommand cmd4 = new OracleCommand("insert into sd_op_runcard (lot_id,product_id,lot_startqty,step_id,step_currentid,create_user,create_date,order_no,process_name) select '" + newlot_id + "',product_id," + newcount + ",step_current,step_currentid,'" + user + "',sysdate,order_no,process_name from sd_op_lotinfo where lot_id='" + newlot_id + "'", con);
                OracleCommand cmd5 = new OracleCommand("delete from SD_TMP_BREAKLOT where addr_ip='" + GETIP() + "' and lot_id='" + lotid + "' AND GUID='" + guid + "'", con);
                ////yfy  2014/01/27 
                OracleCommand cmd6 = new OracleCommand("update SD_OP_ELOT set in_qty=in_qty-" + newcount + " where lot_id='" + lotid + "' and create_time=(select max(create_time) from SD_OP_ELOT where lot_id='" + lotid + "')", con);
                ////20140817
                OracleCommand cmd7 = new OracleCommand("insert into sd_his_qline(lot_id, line_id) select '" + newlot_id + "', line_id from sd_his_qline where lot_id = '" + lotid + "'", con);



                cmd1.Transaction = ots;
                cmd2.Transaction = ots;
                cmd3.Transaction = ots;
                cmd4.Transaction = ots;
                cmd5.Transaction = ots;
                cmd6.Transaction = ots;
                cmd7.Transaction = ots;
                cmd1.ExecuteNonQuery();
                cmd2.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                cmd4.ExecuteNonQuery();
                cmd5.ExecuteNonQuery();
                cmd6.ExecuteNonQuery();
                cmd7.ExecuteNonQuery();
            }
            catch
            {
                ots.Rollback();
                con.Close();
                return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"操作失敗請聯繫IT！\"}]";

            }
            ots.Commit();
            //ots.Rollback();
            con.Close();
            return rtn = "[{\"FLAG\":\"Y\",\"MSG\":\"" + newlot_id + "\"}]";
        }
        else
        {
            return rtn = "[{\"FLAG\":\"N\",\"MSG\":\"請刷入產品條碼\"}]";
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