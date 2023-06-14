<%@ WebHandler Language="C#" Class="R07Controller" %>

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

public class R07Controller : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string rtnValue = "獲取數據失敗";
        string funcName = context.Request["funcName"];
        string lh_user = context.Request["lh_user"];
        string IP = context.Request["IP"];
        string order = context.Request["order"];
        string user = context.Request["user"];
        string step = context.Request["step"];
        string box = context.Request["box"];
        string BOX_ID = context.Request["BOX_ID"];
        string REJECTED_QTY = context.Request["REJECTED_QTY"];
        string SHENYU = context.Request["SHENYU"];
        string innum = context.Request["innum"];
        switch (funcName)
        {
            case "getip":
                rtnValue = getip();
                break;
            case "getorder":
                rtnValue = getorder();
                break;
                case "getordernum":
                rtnValue = getordernum(order, user,SHENYU, innum);
                break;
                case "getstep":
                rtnValue = getstep(order);
                break;
                case "inserttmpbox":
                rtnValue = inserttmpbox(user,order, step, box);
                break;
                case "show":
                rtnValue = show(user);
                break;
                case "delete":
                rtnValue = del(BOX_ID, user, REJECTED_QTY);
                break;
                case "deletetmp":
                rtnValue = deltmp( user);
                break;
                case "insert":
                rtnValue = insert(user, step, SHENYU, innum);
                break;
                
        }
        context.Response.Write(rtnValue);
    }
    private string insert(string user, string step, string SHENYU, string innum)
    {
        string rtn = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sql = "SELECT * FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP='" + ip + "' AND CREATE_USER='" + user + "'";
        DataTable dtRework = PubClass.getdatatableMES(sql);
        if (dtRework.Rows.Count==0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表中無數據，不可結箱\"}]";
            return rtn;
        }
        if (int.Parse(SHENYU) < int.Parse(innum))
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"剩餘下線量小於列表中的刷入量,無法進行下線!!\"}]";
            return rtn;
        }
        string ddlWok = dtRework.Rows[0]["ORDER_NO"].ToString();
        
        string sql1 = "SELECT PROCESS_NAME FROM SD_BASE_PROCEPRODUCT WHERE PRODUCT_ID =(SELECT PRODUCT_ID FROM SD_OP_WORKORDER WHERE ORDER_NO='" + ddlWok + "')";
        DataTable dt_list = PubClass.getdatatableMES(sql1);
        string PROCESS_NAME = dt_list.Rows[0]["PROCESS_NAME"].ToString();

        string sqlstep1 = "SELECT * FROM   SD_BASE_PROCESS WHERE PROCESS_NAME='" + PROCESS_NAME + "'AND STEP_ID='" + step + "'";
        DataTable dtstep1 = PubClass.getdatatableMES(sqlstep1);
        string STEP_ORDER = dtstep1.Rows[0]["PROCESS_ID"].ToString();
        
        string sqlBrwFlag = "SELECT BRW_FLAG FROM SD_BASE_MOTYPE WHERE MOTYPE IN (SELECT MOTYPE FROM SD_OP_WORKORDER WHERE ORDER_NO='" + ddlWok + "')";
        DataTable dtBrwFlag = PubClass.getdatatableMES(sqlBrwFlag);
        string strBrwFlag = dtBrwFlag.Rows[0]["BRW_FLAG"].ToString();
        
        string sqlOrderQty = "SELECT ORDER_NO,PRODUCT_ID,MODESC,SITE ,MO_TYPE FROM SD_OP_WORKORDER WHERE ORDER_NO = '" + ddlWok + "'";
        DataTable dtOrderQty = PubClass.getdatatableMES(sqlOrderQty);
        string strProductId = dtOrderQty.Rows[0]["PRODUCT_ID"].ToString();
        string strMoDesc = dtOrderQty.Rows[0]["MODESC"].ToString();
        string SITE = dtOrderQty.Rows[0]["SITE"].ToString();
        string MO_TYPE = dtOrderQty.Rows[0]["MO_TYPE"].ToString();


        List<string> lists = new List<string>();
        string sqldate = "SELECT TO_CHAR(SYSDATE,'yyyymmdd') FROM DUAL";
        DataTable dtdata = PubClass.getdatatableMES(sqldate);
        string newlotid = dtdata.Rows[0][0].ToString();
        string m = "";
        string sqlcheck = " SELECT LPAD(SEQ_LOTID.NEXTVAL,4,'0') FROM DUAL";
        DataTable dtcheck = PubClass.getdatatableMES(sqlcheck);
        if (dtcheck.Rows[0][0].ToString() != "")
        {
            m = dtcheck.Rows[0][0].ToString();
        }
        else
        {
       
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"系LOT號生成異常，請聯繫IT!!\"}]";
            return rtn;
        }
        newlotid = "T" + newlotid + "-" + m;
        string sqlal2 = "SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID = '" + newlotid + "'";
        DataTable dtal2 = PubClass.getdatatableMES(sqlal2);
        if(dtal2.Rows.Count==0)
        {
            string sqlsysid = "SELECT SEQ_LOTSYSID.NEXTVAL FROM DUAL";
            DataTable dtsysid = PubClass.getdatatableMES(sqlsysid);
            string sysid = dtsysid.Rows[0][0].ToString();
            string sqlnifiid = "SELECT SEQ_LOTOPERMSG.NEXTVAL FROM DUAL";
            DataTable dtnifiid = PubClass.getdatatableMES(sqlnifiid);
            string nifiid = dtnifiid.Rows[0][0].ToString();
            string sql_LOTINFO = @"INSERT INTO SD_OP_LOTINFO (LOT_ID,ORDER_NO,PRODUCT_ID,PROCESS_NAME,STEP_CURRENTID,STEP_CURRENT,LOT_STATUS,LOT_STARTQTY,LOT_QTY,LINE_ID,WORKCENTER,CREATE_USER) 
                        SELECT '" + newlotid + "','" + ddlWok + "',PRODUCT_ID,'" + PROCESS_NAME + "','" + STEP_ORDER + "','" + step + "','C',SUM(REJECTED_QTY),SUM(REJECTED_QTY),'CUT','SLMES','" + user + "' FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP = '" + ip + "'AND CREATE_USER = '" + user + "'GROUP BY PRODUCT_ID";
            string sql_LOTWKP = @"INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID, SYSID, STEP_ID,STEPM_ID, EQP_ID, OUSER,CREATE_USER,IN_QTY,OUT_QTY, PASSCOUNT ,LINEID, MO, MO_FLAG1, MO_FLAG2, MO_FLAG3, MO_BRWFLAG,NIFIID,LOTSTATUS)
                                VALUES('" + newlotid + "','" + sysid + "','" + step + "','" + step + "','" + step + "','" + user + "','" + user + "','" + innum + "','" + innum + "','1','CUT','" + ddlWok + "','" + SITE + "', '" + MO_TYPE + "', '" + strMoDesc + "', '" + strBrwFlag + "','" + nifiid + "','C')";

            string sql_RUNCARD = @"INSERT INTO SD_OP_RUNCARD (LOT_ID,PRODUCT_ID,LOT_STARTQTY,STEP_ID,STEP_CURRENTID,CREATE_USER,CREATE_DATE,IS_OFFLINE,ORDER_NO,PROCESS_NAME,ISOFF_LINE,IP_ADDR)
                        VALUES('" + newlotid + "','" + strProductId + "','" + innum + "','" + step + "','1','" + user + "',SYSDATE,'N','" + ddlWok + "','" + PROCESS_NAME + "','N','" + ip + "')";
            string sql_MONUM = @"UPDATE SD_OP_WORKORDER SET QUANTITY_CREATED = QUANTITY_CREATED + " + int.Parse(innum) + "  WHERE ORDER_NO ='" + ddlWok + "'";
            string sql_DELET = @"DELETE FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP = '" + ip + "'AND CREATE_USER = '" + user + "'";
            string sql_DELET1 = @"UPDATE SD_OP_REJECTEDMAIN SET FLAG='N'WHERE REJECTED_ID IN( SELECT DISTINCT REJECTED_ID FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP = '" + ip + "'AND CREATE_USER = '" + user + "')";
            lists.Add(sql_LOTINFO); lists.Add(sql_LOTWKP); lists.Add(sql_RUNCARD); lists.Add(sql_MONUM); lists.Add(sql_DELET); 
        }
        string mes = PubClass.excuteOts(lists);
        if (mes == "操作成功")
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + newlotid + "\"}]";
            return rtn;
        }
        else
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"下線失敗,請聯繫IT!\"}]";

            return rtn;
        }
 
    }
    private string deltmp( string user)
    {
        string str_loginhost = ""; string rtn = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sql = "DELETE FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP='" + ip + "' AND CREATE_USER='" + user + "'";
        PubClass.getdatatablenoreturnMES(sql);
        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"OK!\"}]";
        return rtn;
    }
    private string del(string BOX_ID, string user, string REJECTED_QTY)
    {
        string str_loginhost = ""; string rtn = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sql = "DELETE FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP='" + ip + "' AND CREATE_USER='" + user + "' AND BOX_ID='" + BOX_ID + "'AND REJECTED_QTY='" + REJECTED_QTY + "'";
        PubClass.getdatatablenoreturnMES(sql);

        string reWork = "SELECT * FROM SD_TMP_REWORK WHERE ADDR_IP='" + ip + "' AND CREATE_USER='" + user + "'";
        DataTable dtRework = PubClass.getdatatableMES(reWork);
        string NUM = dtRework.Rows.Count.ToString();
        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"" + NUM + "\"}]";
        return rtn;
    }
    private string show(string user)
    {
        string Ip = HttpContext.Current.Request.UserHostAddress.ToString();

        string sql = @"SELECT * FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP='" + Ip + "' AND CREATE_USER='" + user + "' ORDER BY CREATE_DATE DESC ";
        DataTable dt = PubClass.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    private string getip()
    {
        string Ip = HttpContext.Current.Request.UserHostAddress.ToString();
        string rtn = "[{\"IP\":\"" + Ip + "\"}]";
        return rtn;
    }
    private string getorder()
    {
        string rtn = "";
        string sql = "select order_no from sd_op_workorder where is_closed = 'N' and workcenter='JOAN' and id_order ='01'and motype in ('ZBTS','ZMPC','ZPRF') and quantity_created<quantity  order by order_no";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string getordernum(string order, string user, string SHENYU, string innum)
    {
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string rtn = ""; string ordernum = ""; string PRODUCTID = ""; string num1 = ""; string shenyu = "";
        string sqlorder = "SELECT * FROM SD_OP_WORKORDER WHERE ORDER_NO='" + order + "'";
        DataTable dtorder = PubClass.getdatatableMES(sqlorder);
        if(dtorder.Rows.Count>0)
        {
            ordernum = dtorder.Rows[0]["QUANTITY"].ToString();
            PRODUCTID = dtorder.Rows[0]["PRODUCT_ID"].ToString();
            num1 = dtorder.Rows[0]["QUANTITY_CREATED"].ToString();
            shenyu = (int.Parse(ordernum) - int.Parse(num1)).ToString();
        }
        else
        {
            ordernum = "0";
            PRODUCTID = "0";
            num1 = "0";
            shenyu = "0";
        }        
        string SHUARU = "";
        string reWork1 = "SELECT * FROM SD_TMP_REJECTEDWORK WHERE ORDER_NO='" + order + "' AND ADDR_IP='" + ip + "'AND CREATE_USER='" + user + "'";
        DataTable dtRework1 = PubClass.getdatatableMES(reWork1);
        if (dtRework1.Rows.Count > 0)
        {
            string reWork12 = "SELECT sum(REJECTED_QTY)REJECTED_QTY FROM SD_TMP_REJECTEDWORK WHERE ORDER_NO='" + order + "' AND ADDR_IP='" + ip + "'AND CREATE_USER='" + user + "'";
            DataTable dtRework12 = PubClass.getdatatableMES(reWork12);
            SHUARU = dtRework12.Rows[0]["REJECTED_QTY"].ToString();
        }
        else
        {
            SHUARU = "0";
        }
        rtn = "[{\"ERR_CODE\":\"Y\",\"ORDERNUM\":\"" + ordernum + "\",\"PRODUCTID\":\"" + PRODUCTID + "\",\"SHENYU\":\"" + shenyu + "\",\"SHUARU\":\"" + SHUARU + "\"}]";
        return rtn;
    }
    private string getstep(string order)
    {
        string rtn = ""; string TMP = "";
        string sql2 = "SELECT A.*,C.* FROM SD_BASE_CODEWITHPRODUCT A, SD_OP_WORKORDER B,SD_BASE_PROCEPRODUCT C WHERE A.PRODUCT_ID=B.PRODUCT_ID AND A.PRODUCT_ID=C.PRODUCT_ID AND  B.ORDER_NO='" + order + "'";
        DataTable dt2 = PubClass.getdatatableMES(sql2);

        string sql = @"SELECT DISTINCT A.STEP_ID||':'||A.STEP_DESC STEP_NAME,A.STEP_ORDER,A.STEP_ID FROM SD_BASE_STEP A,(SELECT DISTINCT STEP_ID,PROCESS_NAME FROM SD_BASE_STEPM) B  ,SD_BASE_OFFLINE c  
        WHERE A.STEP_ID=B.STEP_ID AND C.STEP_ID=A.STEP_ID AND C.ORDER_NO='" + order + "'  AND C.FLAG='Y'  ORDER BY STEP_ORDER";
        DataTable dt = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
      private string inserttmpbox(string user, string order, string step, string box)
    {
        string rtn = "";
        string ip = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
        string sqlm12 = "SELECT * FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID ='" + box + "' AND FLAG='Y'";
        DataTable dtm12 = PubClass.getdatatableMES(sqlm12);
        if (dtm12.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"此箱號異常，請聯繫IT,謝謝!\"}]";
            return rtn;
        }
        string sqlx2 = "SELECT * FROM SD_TMP_REJECTEDWORK WHERE BOX_ID='" + box + "'";
        DataTable dtx2 = PubClass.getdatatableMES(sqlx2);
        if (dtx2.Rows.Count > 0)
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"箱中已存在于臨時表中!!\"}]";
            return rtn;
        }
        string sqlx21 = "SELECT * FROM SD_TMP_REJECTEDWORK WHERE ADDR_IP='" + ip + "' AND CREATE_USER='" + user + "'";
        DataTable dtx21 = PubClass.getdatatableMES(sqlx21);
        if (dtx21.Rows.Count > 0)
        {
           if(order!=dtx21.Rows[0]["ORDER_NO"].ToString())
           {
               rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"刷入工單與臨時表工單不同，不可刷入!\"}]";
               return rtn;
           }
           if (step != dtx21.Rows[0]["STEP_ID"].ToString())
           {
               rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"刷入站點與臨時表站點不同，不可刷入!\"}]";
               return rtn;
           }
        }
        string txtQty = "";
        string sqlinsert = @"INSERT INTO SD_TMP_REJECTEDWORK (PRODUCT_ID,STEP_ID,CREATE_USER,ADDR_IP,ORDER_NO,BOX_ID,CREATE_DATE,REJECTED_QTY)SELECT LH_ID,'" + step + "','" + user + "','" + ip + "','" + order + "',REJECTED_ID,SYSDATE,REJECTED_QTY FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID ='" + box + "'";
        PubClass.getdatatablenoreturnMES(sqlinsert);
        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"OK\"}]";
        return rtn;
       
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}