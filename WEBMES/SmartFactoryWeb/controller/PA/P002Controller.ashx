<%@ WebHandler Language="C#" Class="P002Controller" %>

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

public class P002Controller : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string cbstroc = context.Request["cbstroc"];
        string boxid = context.Request["boxid"];
        string ddlstroc = context.Request["ddlstroc"];
        string user = context.Request["user"];
        string ip = context.Request["ip"];
        string storeid = context.Request["storeid"];
        switch (funcName)
        {
            case "getip":
                rtnValue = getip();
                break;
            case "inserttmp":
                rtnValue = inserttmp(boxid, cbstroc, ddlstroc);
                break;
            case "getboxnum":
                rtnValue = getboxnum();
                break;
            case "show":
                rtnValue = show();
                break;
            case "deltmpone":
                rtnValue = deltmpone(boxid);
                break;
            case "deltmpall":
                rtnValue = deltmpall();
                break;
            case "STOREIN":
                rtnValue = STOREIN(user);
                break;
            case "printstore":
                rtnValue = printstore(storeid, user);
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
    private string getboxnum()
    {
        string flag = "Y"; string msg = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sql = "SELECT DISTINCT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER = '" + ip + "'";
        DataTable dt1 = PubClass.getdatatableMES(sql);
        msg = dt1.Rows.Count.ToString();
        string rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
        return rtn;
    }

    private string printstore(string storeid, string user)
    {
        storeid = storeid.Trim();
        string msg = ""; string flag = "Y"; string rtn = "";
        string HostName = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sql = "SELECT ORDER_NO AS 工單,PN AS 機種,CPN AS 客戶料號,SUM(QUANTITY) AS 數量,STORAGE AS 倉位 FROM SD_OP_STORE WHERE STORE_ID='" + storeid + "' GROUP BY ORDER_NO,PN,CPN,STORAGE";
        DataTable dt = PubClass.getdatatableMES(sql);
        string sql1 = "SELECT NAME_IN_CHINESE FROM SD_CAT_HRS WHERE USER_ID = '" + user + "'";
        DataTable dt1 = PubClass.getdatatableMES(sql1);
        string name = "";
        if (dt1.Rows.Count == 0)
        {
            flag = "N";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"人員不存在\"}]";
            return rtn;

        } if (dt.Rows.Count == 0)
        {
            flag = "N";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"棧板單不存在,請確認~\"}]";
            return rtn;
        }
        string sqlboxnum = "select sum(quantity) from sd_op_boxdetail where box_id in(select box_id from sd_op_store where store_id='" + storeid + "')";
        DataTable dtboxnum = PubClass.getdatatableMES(sqlboxnum);
        DataTable dtstorenum = PubClass.getdatatableMES("select sum(quantity) from sd_op_store where store_id='" + storeid + "'");
        if (dtboxnum.Rows[0][0].ToString() != dtstorenum.Rows[0][0].ToString())
        {
            flag = "N";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"棧板單数量不正确,請確認~\"}]";
            return rtn;
        }
        name = dt1.Rows[0]["NAME_IN_CHINESE"].ToString();

        //序號 工單 機種 客戶料號 倉位 單位 数量 
        string str100p = "style=\"font-size: 20px;width:100px;text-align:center; margin: 0px 0px 0px 20px;\"";
        string str220p = "style=\"font-size: 20px;width:220px;text-align:center; margin: 0px 0px 0px 20px;\"";
        string strcenter = "style=\"font-size: 20px;text-align:center;\"";
        string str = "<tr>";
        str += " <td " + str100p + ">序號</td>";
        str += " <td " + str220p + ">工單</td>";
        str += " <td " + str220p + ">機種</td>";
       // str += " <td " + str220p + ">客戶料號</td>";
        str += " <td " + str100p + ">倉位</td>";
        str += " <td " + str100p + ">單位</td>";
        str += " <td " + str100p + ">數量</td>";
        str += " </tr>";
        int num = 0;
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            int no = i + 1; num += int.Parse(dt.Rows[i]["數量"].ToString());
            str += " <tr>";
            str += " <td " + strcenter + ">" + no.ToString() + "</td>";
            str += " <td " + strcenter + ">" + dt.Rows[i]["工單"].ToString() + "</td>";
            str += " <td " + strcenter + ">" + dt.Rows[i]["機種"].ToString() + "</td>";
           // str += " <td " + strcenter + ">" + dt.Rows[i]["客戶料號"].ToString() + "</td>";
            str += " <td " + strcenter + ">" + dt.Rows[i]["倉位"].ToString() + "</td>";
            str += " <td " + strcenter + ">PCS</td>";
            str += " <td " + strcenter + ">" + dt.Rows[i]["數量"].ToString() + "</td>";
            str += " </tr>";
        }
        str += "<tr>";
        str += " <td " + strcenter + ">合計:</td>";
        str += " <td></td>";
        str += " <td></td>";
        //str += " <td></td>";
        str += " <td></td>";
        str += " <td></td>";
        str += " <td " + strcenter + ">" + num.ToString() + "</td>";
        str += " </tr>";
        msg = str;
        //DataTable dt2 = PubClass.getdatatableMES("SELECT '" + flag + "' FLAG,'" + msg + "'MSG  FROM DUAL");
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    private string deltmpone(string boxid)
    {
        string flag = "Y"; string msg = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sql = "DELETE FROM SD_TMP_STORE WHERE CREATE_USER = '" + ip + "' AND BOX_ID='" + boxid + "'";
        PubClass.getdatatablenoreturnMES(sql);
        msg = "OK";
        string rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msg + "\"}]";
        return rtn;
    }

    private string deltmpall()
    {
        string flag = "Y"; string msgshow = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sql = "DELETE FROM SD_TMP_STORE WHERE CREATE_USER = '" + ip + "'";
        PubClass.getdatatablenoreturnMES(sql);
        msgshow = "OK";
        string rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
        return rtn;
    }

    private string inserttmp(string boxid, string cbstroc, string ddlstroc)
    {
        string LabMsg = "";
        if (boxid.Length >= 14)
        {
            boxid = boxid.Substring(0, 14);
        }
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string flag = "N"; string rtn = ""; string msgshow = ""; string CG_CODE = ""; string BL_CODE = ""; string store_kk = "";
        string order_no = "";
        string product_id = "";
       
       
        string sql = "SELECT * FROM SD_OP_BOXMAIN WHERE BOX_ID = '" + boxid + "' AND FLAG = 'Y'";
        DataTable dt1 = PubClass.getdatatableMES(sql);
        if (dt1.Rows.Count == 0)
        {
            msgshow = "沒有找到此箱號,請確認!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        DataTable dtCheckupn = PubClass.getdatatableMES(@"SELECT distinct PRODUCT_ID FROM SD_OP_BOXDETAIL WHERE BOX_ID = '" + boxid + @"'");
        if (dtCheckupn.Rows.Count > 1)
        {
            msgshow = "此箱中混有不同機種產品，請拆箱重包!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        else
        {
            product_id = dtCheckupn.Rows[0][0].ToString(); 
        }
        
       
        
        

        //包裝稱重卡控
        //string weigth = @"SELECT * FROM SD_OP_BOXMAIN WHERE BOX_ID='" + boxid + "'";
        //DataTable dtwei = PubClass.getdatatableMES(weigth);
        //if (string.IsNullOrEmpty(dtwei.Rows[0]["weigth"].ToString()))
        //{
        //    msgshow = "此箱" + boxid + "沒有進行包裝稱重，請聯繫包裝!";
        //    rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
        //    return rtn;
        //}
        
      

        
        DataTable dt2 = PubClass.getdatatableMES("SELECT * FROM SD_TMP_STORE WHERE BOX_ID = '" + boxid + "'");
        if (dt2.Rows.Count != 0)
        {
            msgshow = "此箱號已經存在列表中,請選擇其他箱號";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        dt2 = PubClass.getdatatableMES("SELECT * FROM SD_OP_STORE WHERE FLAG='Y' AND BOX_ID='" + boxid + "'");
        if (dt2.Rows.Count != 0)
        {
            msgshow = "此箱號已經入庫!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        sql = @"SELECT * FROM SD_OP_WORKORDER WHERE ORDER_NO IN (SELECT DISTINCT ORDER_NO FROM SD_OP_BOXDETAIL WHERE BOX_ID = '" + boxid + @"')";
        DataTable dt3 = PubClass.getdatatableMES(sql);
        if (dt3.Rows.Count > 0)
        {
            if (dt3.Rows[0]["IS_CLOSED"].ToString() == "Y")
            {
                LabMsg = "刷入箱號含已結案工單<'" + dt3.Rows[0]["order_no"].ToString() + "'>, 請注意~~";
            }
        }
        order_no = dt3.Rows[0]["ORDER_NO"].ToString();
        string STORAGE = "NULL";
        if (cbstroc == "true")
        {
            STORAGE = ddlstroc;
        }
        else
        {
            STORAGE = dt3.Rows[0]["STORAGELOC"].ToString();
        }
        
        
       
        // 临时表数据检查
        DataTable dttmp = PubClass.getdatatableMES("SELECT * FROM SD_TMP_STORE  WHERE CREATE_USER = '" + ip + "'");
        if (dttmp.Rows.Count > 0)
        {
           

            if (dttmp.Rows[0]["product_id"].ToString() != product_id)
            {
                msgshow = "產品與列表中紀錄不為同一機種,不能入庫!";
                rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                return rtn;
            }
            if (dttmp.Rows[0]["storage"].ToString() != STORAGE)
            {
                msgshow = "產品與列表中紀錄不為同一倉別,不能入庫!";
                rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                return rtn;
            }
        }

       
        if (cbstroc == "true")
        {
            sql = @"SELECT A1.BOX_ID,A2.PRODUCT_ID,A1.CPN_ID,A2.ORDER_NO,SUM(A2.QUANTITY) QTY,'" + ip + @"','" + ddlstroc + @"' FROM SD_OP_BOXMAIN A1,SD_OP_BOXDETAIL A2,SD_OP_WORKORDER A3
                            WHERE A1.BOX_ID=A2.BOX_ID AND A2.ORDER_NO=A3.ORDER_NO(+) AND A1.BOX_ID='" + boxid + "' AND A1.FLAG='Y' GROUP BY A1.BOX_ID,A2.PRODUCT_ID,A1.CPN_ID,A2.ORDER_NO,A3.STORAGELOC";
        }
        else
        {
            sql = @"SELECT A1.BOX_ID,A2.PRODUCT_ID,A1.CPN_ID,A2.ORDER_NO,SUM(A2.QUANTITY) QTY,'" + ip + @"',A3.STORAGELOC FROM SD_OP_BOXMAIN A1,SD_OP_BOXDETAIL A2,SD_OP_WORKORDER A3
                            WHERE A1.BOX_ID=A2.BOX_ID AND A2.ORDER_NO=A3.ORDER_NO(+) AND A1.BOX_ID='" + boxid + "' AND A1.FLAG='Y' GROUP BY A1.BOX_ID,A2.PRODUCT_ID,A1.CPN_ID,A2.ORDER_NO,A3.STORAGELOC";
        }
        string str = "INSERT INTO SD_TMP_STORE(BOX_ID,PRODUCT_ID,CPN,ORDER_NO,QUANTITY,CREATE_USER,STORAGE) " + sql;
        PubClass.getdatatablenoreturnMES(str);
        flag = "Y";
        msgshow = LabMsg;
        msgshow = msgshow.Replace("\t", "");
        msgshow = msgshow.Replace("\n", "");
        msgshow = msgshow.Replace("\r", "");
        rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\",\"STORE_KK\":\"" + store_kk + "\"}]";
        return rtn;
    }

    private string STOREIN(string user)
    {
        string str_num = string.Empty;
        string flag = "N"; string rtn = ""; string msgshow = ""; //string CG_CODE = ""; string BL_CODE = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sqltmp = @"SELECT * FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "'";
        DataTable dttmp = PubClass.getdatatableMES(sqltmp);
        if (dttmp.Rows.Count == 0)
        {
            msgshow = "箱號編碼不能為空，請先輸入后回車";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        string sqltmp1 = @"SELECT * FROM SD_OP_STORE WHERE BOX_ID IN(SELECT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "') AND FLAG='Y'";
        DataTable dttmp1 = PubClass.getdatatableMES(sqltmp);
        if (dttmp1.Rows.Count == 0)
        {
            msgshow = "臨時表存在已結箱號，請先清空后輸入";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
        string sqlbox7 = @"SELECT DISTINCT PRODUCT_ID FROM SD_TMP_STORE WHERE  CREATE_USER='" + ip + "'";
        DataTable dtbox7 = PubClass.getdatatableMES(sqlbox7);
        if (dtbox7.Rows.Count > 1)
        {
            msgshow = "臨時表中存在兩個及以上料號 不可結棧板 請確認！";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }

        if (!string.IsNullOrEmpty(PubClass.getLoginUser(ip, user).ToString()))
        {
            ip = PubClass.getLoginUser(ip, user).ToString();
        }
        else
        {
            msgshow = "無電腦信息,請聯繫IT!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }

        string Store_ID = "";

        try
        {
            DataTable dtmm = PubClass.getdatatableMES("SELECT INTTOH16(" + DateTime.Now.Month.ToString() + ",1) FROM DUAL");
            string mm = dtmm.Rows[0][0].ToString();

            DataTable dtdd = PubClass.getdatatableMES("SELECT INTTOH32(" + DateTime.Now.Day.ToString() + ",1) FROM DUAL");
            string dd = dtdd.Rows[0][0].ToString();
            //  檢查 LOCK_TYPE
            string sqlmmk1 = "SELECT IS_LOCK FROM LOCK_TYPE WHERE  TYPE_NAME='STOREIN' AND LOT_ID='" + ip + "'";
            DataTable dtmmk1 = PubClass.getdatatableMES(sqlmmk1);
            if (dtmmk1.Rows.Count > 0)
            {
                msgshow = "你的棧板單號正在生成中,請稍後";
                rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                return rtn;
            }
            //end  檢查 LOCK_TYPE
            string sqldouble = "SELECT * FROM SD_OP_BOXMAIN WHERE BOX_ID IN (SELECT DISTINCT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER = '" + ip + "') AND FLAG = 'N'";
            DataTable dtdouble = PubClass.getdatatableMES(sqldouble);
            if (dtdouble.Rows.Count > 0)
            {
                msgshow = "有箱號被拆箱,請確認!";
                rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                return rtn;
            }
            string sqlsys = " SELECT SEQ_LOTSYSID.NEXTVAL  FROM DUAL";
            DataTable dtsys = PubClass.getdatatableMES(sqlsys);
            string sysid = dtsys.Rows[0][0].ToString();
            Store_ID = "WOK-" + System.DateTime.Now.Year.ToString().Substring(3, 1) + mm + dd + "S";
            string sqlcheck = " SELECT LPAD(SEQ_STOREID.NEXTVAL,4,'0') FROM DUAL";
            DataTable dtcheck = PubClass.getdatatableMES(sqlcheck);
            if (dtcheck.Rows[0][0].ToString() != "")
            {
                str_num = dtcheck.Rows[0][0].ToString();
            }
            else
            {
                msgshow = "系統單號生成異常，請聯繫IT";
                rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                return rtn;
            }
            Store_ID = Store_ID + str_num;

            string sqlup1 = "INSERT INTO LOCK_TYPE (TYPE_NAME,IS_LOCK,LOT_ID) VALUES ('STOREIN','Y','" + ip + "')";
            PubClass.getdatatablenoreturnMES(sqlup1);
            OracleConnection con = PubClass.dbconMES();
            OracleTransaction ots;
            con.Open();
            ots = con.BeginTransaction();

            try
            {
                
                string sqll=@"INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID, SYSID, STEP_ID,STEPM_ID, EQP_ID, OUSER,CREATE_USER,IN_QTY,OUT_QTY, PASSCOUNT ,LINEID, MO, MO_FLAG1, MO_FLAG2, MO_FLAG3, MO_BRWFLAG, NIFIID,LOTSTATUS )                       
                SELECT  A.LOT_ID,'" + sysid + "','SN','SN','NULL','" + user + "','" + user + @"',A.QUANTITY,A.QUANTITY,'1','NULL',A.ORDER_NO,B.SITE,B.MO_TYPE,B.MODESC,C.BRW_FLAG,SEQ_LOTOPERMSG.NEXTVAL,'P'  FROM SD_OP_BOXDETAIL A,
                SD_OP_WORKORDER B,SD_BASE_MOTYPE C WHERE A.ORDER_NO=B.ORDER_NO AND A.BOX_ID IN(SELECT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "') AND C.MOTYPE=B.MOTYPE";
//                OracleCommand cmd7 = new OracleCommand(@"DELETE FROM SD_OP_STOREMAIN WHERE STORE_ID IN (SELECT STORE_ID  FROM SD_OP_STORE 
//                                                         WHERE BOX_ID IN(SELECT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "') AND STORE_ID <>'" + Store_ID + "')", con);
//                OracleCommand cmd8 = new OracleCommand("DELETE FROM SD_OP_STORE WHERE BOX_ID IN (SELECT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "') AND STORE_ID <>'" + Store_ID + "'", con);
                //OracleCommand cmd0 = new OracleCommand("UPDATE SD_OP_STORE SET FLAG='N' WHERE BOX_ID IN (SELECT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER ='" + ip + "')", con);
                OracleCommand cmd1 = new OracleCommand("INSERT INTO SD_OP_STORE(STORE_ID,BOX_ID,ORDER_NO,PN,CPN,QUANTITY,CREATE_USER,STORAGE) SELECT '" + Store_ID + "',BOX_ID,ORDER_NO,PRODUCT_ID,CPN,QUANTITY,'" + user + "',STORAGE FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "'", con);
                OracleCommand cmd2 = new OracleCommand("INSERT INTO SD_OP_STOREMAIN(PRODUCT_ID,QUANTITY,CREATE_USER,STORE_ID,STORGE) SELECT PRODUCT_ID,SUM(QUANTITY),'" + user + "','" + Store_ID + "',STORAGE FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "' GROUP BY PRODUCT_ID,STORAGE", con);
               // OracleCommand cmd4 = new OracleCommand("INSERT INTO SD_HIS_STORELINK(REJECTED_ID,CREATE_USER,CREATE_DATE) SELECT '" + Store_ID + "','" + user + "',SYSDATE FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "'", con);
                //OracleCommand cmd5 = new OracleCommand("UPDATE SD_OP_PRODUCTSTATUS SET PRODUCT_STATUS='O' WHERE (ORDER_NO,PRODUCT_CODECELL) IN (SELECT ORDER_NO,PRODUCT_CODECELL FROM SD_OP_BOXDETAIL WHERE  BOX_ID IN (SELECT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "') AND FLAG='Y')", con);
                OracleCommand cmd6 = new OracleCommand("UPDATE SD_OP_BOXDETAIL SET IS_STORE='Y' WHERE BOX_ID IN (SELECT BOX_ID FROM SD_TMP_STORE WHERE CREATE_USER='" + ip + "') AND FLAG='Y'", con);
                OracleCommand cmd4 = new OracleCommand(sqll,con);
                OracleCommand cmd3 = new OracleCommand("DELETE FROM SD_TMP_STORE WHERE CREATE_USER = '" + ip + "'", con);
                
                //cmd7.Transaction = ots;
                //cmd8.Transaction = ots;
                cmd1.Transaction = ots;
                cmd2.Transaction = ots;
               // cmd4.Transaction = ots;
               // cmd5.Transaction = ots;
                cmd6.Transaction = ots;
                cmd4.Transaction = ots;
                cmd3.Transaction = ots;
        
                //cmd7.ExecuteNonQuery();
                //cmd8.ExecuteNonQuery();
                cmd1.ExecuteNonQuery();
                cmd2.ExecuteNonQuery();
               // cmd4.ExecuteNonQuery();
               // cmd5.ExecuteNonQuery();
                cmd6.ExecuteNonQuery();
                cmd4.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                //ots.Rollback();
                ots.Commit();
                con.Close();
            }
            catch
            {
                ots.Rollback();
                con.Close();
                msgshow = "入庫出錯!";
                rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
                return rtn;
            }
            finally
            {
                string sqlDELOCK = "DELETE FROM LOCK_TYPE WHERE TYPE_NAME='STOREIN'AND LOT_ID='" + ip + "'";
                PubClass.getdatatablenoreturnMES(sqlDELOCK);
            }
            flag = "Y"; msgshow = "入庫成功!";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\",\"STOREID\":\"" + Store_ID + "\"}]";
            return rtn;
        }
        catch
        {
            msgshow = "入庫出錯,請稍後再試";
            rtn = "[{\"FLAG\":\"" + flag + "\",\"MSG\":\"" + msgshow + "\"}]";
            return rtn;
        }
    }
    private string show()
    {
        string rtn = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        DataTable dt1 = PubClass.getdatatableMES("SELECT BOX_ID,PRODUCT_ID,ORDER_NO,QUANTITY,STORAGE FROM SD_TMP_STORE WHERE CREATE_USER = '" + ip + "'");
        rtn = JsonConvert.SerializeObject(dt1);
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