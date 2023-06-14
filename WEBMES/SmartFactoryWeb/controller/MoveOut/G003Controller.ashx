<%@ WebHandler Language="C#" Class="G003Controller" %>

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

public class G003Controller : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string user = context.Request["user"];
        string funcName = context.Request["funcName"];
        string ddl_fa = context.Request["ddl_fa"];
        string ddl_f = context.Request["ddl_f"];
        string ddlWok = context.Request["ddlWok"];
        string strProductId = context.Request["strProductId"];
        string sheet_id = context.Request["sheet_id"];
        string group_id = context.Request["group_id"];
        string TextBox1 = context.Request["TextBox1"];
        string ddl_eqp = context.Request["ddl_eqp"];
        string SSEI01 = context.Request["SSEI01"];
        string SSEI21 = context.Request["SSEI21"];
        string lotnum = context.Request["lotnum"];
        string userid = context.Request["userid"];
        string arylot = context.Request["arylot"];
        switch (funcName)
        {
            case "getIP":
                rtnValue = GetIP();
                break;
            case "select_GetMotype":
                rtnValue = select_GetMotype();
                break;
            case "select_GetSite":
                rtnValue = select_GetSite();
                break;
            case "select_GetAryLot":
                rtnValue = select_GetAryLot();
                break;
            case "select_ddleqp":
                rtnValue = select_ddleqp(ddl_fa);
                break;
            case "select_GetWok":
                rtnValue = select_GetWok(ddl_fa, ddl_f);
                break;
            case "select_ddlWok":
                rtnValue = select_ddlWok(ddlWok);
                break;
            case "select_getAryLotNum":
                rtnValue = select_getAryLotNum(arylot);
                break;
            case "select_sheet_id":
                rtnValue = select_sheet_id(strProductId);
                break;
            case "select_ddlProcess":
                rtnValue = select_ddlProcess(ddlWok);
                break;
            case "btn_offline":
                rtnValue = btn_offline(ddlWok, sheet_id, lotnum, ddl_f, ddl_fa, ddl_eqp, arylot, userid);
                break;
        }
        context.Response.Write(rtnValue);
    }
    // 获取下拉框
    private string select_GetSite()
    {
        string rtn = "";
        string sql = "SELECT DISTINCT SITE FROM SD_OP_WORKORDER WHERE IS_CLOSED = 'N' ORDER BY SITE";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_GetAryLot()
    {
        string rtn = "";
        string sql = "SELECT ARY_LOT FROM SD_OP_ARYLOT WHERE FLAG ='Y' AND QUANTITY<>QUANTITY_CREATED ORDER BY CREATE_DATE";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_GetMotype()
    {
        string rtn = "";
        string sql = "SELECT DISTINCT MO_TYPE FROM SD_OP_WORKORDER WHERE IS_CLOSED = 'N' ORDER BY MO_TYPE";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_ddleqp(string ddl_fa)
    {
        string rtn = "";
        string sql = "SELECT DISTINCT EQP_ID FROM SD_BASE_EQP WHERE EQP_STATION ='" + ddl_fa + "' ORDER BY EQP_ID";

        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_GetWok(string ddl_fa, string ddl_f)
    {
        string rtn = "";
        string sql = "select order_no,GROUP_ID from sd_op_workorder where is_closed = 'N' and workcenter='JOAN' and id_order ='01'and motype in ('ZBTS','ZMPC','ZPRF') and quantity_created<quantity and site ='" + ddl_fa + "' and product_id in (select product_id from sd_base_codewithproduct where code_id='" + ddl_f + "' AND IS_HL='N') order by order_no";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_ddlWok(string ddlWok)
    {
        string rtn = "";
        string sql = " SELECT ORDER_NO, QUANTITY, QUANTITY-QUANTITY_CREATED LEFTQUANTITYS, PRODUCT_ID FROM SD_OP_WORKORDER WHERE ORDER_NO = '" + ddlWok + "'";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_getAryLotNum(string arylot)
    {
        string rtn = "";
        string sql = " SELECT QUANTITY-QUANTITY_CREATED ARYLOTNUM FROM SD_OP_ARYLOT WHERE ARY_LOT = '" + arylot + "'";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_sheet_id(string strProductId)
    {
        string rtn = "";
        string sql = "SELECT CODE_JB FROM SD_BASE_CODEWITHPRODUCT WHERE PRODUCT_ID ='" + strProductId + "'";

        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string select_ddlProcess(string ddlWok)
    {
        string rtn = "";
        string sql = "SELECT PROCESS_NAME FROM SD_BASE_PROCEPRODUCT WHERE PRODUCT_ID =(SELECT PRODUCT_ID FROM SD_OP_WORKORDER WHERE ORDER_NO='" + ddlWok + "')";
        DataTable dt_list = PubClass.getdatatableMES(sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }

    private string btn_offline(string ddlWok, string sheet_id, string lotnum, string ddl_f, string ddl_fa, string ddl_eqp, string arylot, string userid)
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
        if (lotnum == "0" || lotnum == "" || lotnum == "null" || lotnum == "NULL")
        {
            rtn = "請輸入正確的下線數量!";
            return rtn;
        }
        //剩餘下線量
        List<string> lists = new List<string>();
        string sqlOrderQty = "SELECT ORDER_NO, QUANTITY, QUANTITY-QUANTITY_CREATED LEFTQUANTITYS, PRODUCT_ID,MODESC FROM SD_OP_WORKORDER WHERE ORDER_NO = '" + ddlWok + "'";
        DataTable dtOrderQty = PubClass.getdatatableMES(sqlOrderQty);
        string strProductId = dtOrderQty.Rows[0]["PRODUCT_ID"].ToString();
        string strMoDesc = dtOrderQty.Rows[0]["MODESC"].ToString();
        string sqlBrwFlag = "SELECT BRW_FLAG FROM SD_BASE_MOTYPE WHERE MOTYPE IN (SELECT MOTYPE FROM SD_OP_WORKORDER WHERE ORDER_NO='" + ddlWok + "')";
        DataTable dtBrwFlag = PubClass.getdatatableMES(sqlBrwFlag);
        string strBrwFlag = dtBrwFlag.Rows[0]["BRW_FLAG"].ToString();
        string sqlProcessName = @"SELECT PROCESS_NAME FROM SD_BASE_PROCEPRODUCT WHERE PRODUCT_ID = (SELECT PRODUCT_ID FROM SD_OP_WORKORDER WHERE ORDER_NO ='" + ddlWok + "')";
        DataTable dtProcessName = PubClass.getdatatableMES(sqlProcessName);
        if (dtProcessName.Rows.Count == 0)
        {
            rtn = "'" + ddlWok + "找不到流程'";
            return rtn;
        }
        string strProcessName = dtProcessName.Rows[0][0].ToString();
        int intOrderQty = int.Parse(dtOrderQty.Rows[0]["QUANTITY"].ToString());
        int intLeftQuantitys = int.Parse(dtOrderQty.Rows[0]["LEFTQUANTITYS"].ToString());

        if (int.Parse(lotnum) > intLeftQuantitys)
        {
            rtn = "工單剩餘下線量不足,請確認!";
            return rtn;
        }
        if (intLeftQuantitys < 0)
        {
            rtn = "工單剩餘下線量已小於0，請聯繫IT與生管!";
            return rtn;
        }
        string sqlAryLotQty = "SELECT QUANTITY-QUANTITY_CREATED ARYLOTNUM FROM SD_OP_ARYLOT WHERE ARY_LOT = '" + arylot + "'";
        DataTable dtAryLotQty = PubClass.getdatatableMES(sqlAryLotQty);
        int ARYLOTNUM = int.Parse(dtAryLotQty.Rows[0]["ARYLOTNUM"].ToString());
        if (int.Parse(lotnum) > ARYLOTNUM)
        {
            rtn = "大隊LOT剩餘下線量不足,請確認!";
            return rtn;
        }
        if (ARYLOTNUM < 0)
        {
            rtn = "大隊LOT剩餘下線量已小於0,請確認!";
            return rtn;
        }
        
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
            rtn = "系LOT號生成異常，請聯繫IT!";
            return rtn;
        }
        newlotid = "T" + newlotid +"-"+ m;        
        string sqlstep1 = "SELECT STEP_ID FROM  SD_BASE_STEPM WHERE PROCESS_NAME='" + strProcessName + "' AND STEP_ORDER='1'";
        DataTable dtstep1 = PubClass.getdatatableMES(sqlstep1);
        string strStepCurrent = dtstep1.Rows[0][0].ToString();
        string sqlal2 = "SELECT * FROM SD_OP_LOTINFO WHERE LOT_ID = '" + newlotid + "'";
        DataTable dtal2 = PubClass.getdatatableMES(sqlal2);
        if (dtal2.Rows.Count == 0)
        {
            string sqlsysid = "SELECT SEQ_LOTSYSID.NEXTVAL FROM DUAL";
            DataTable dtsysid = PubClass.getdatatableMES(sqlsysid);
            string sysid = dtsysid.Rows[0][0].ToString();
            string sqlnifiid = "SELECT SEQ_LOTOPERMSG.NEXTVAL FROM DUAL";
            DataTable dtnifiid = PubClass.getdatatableMES(sqlnifiid);
            string nifiid = dtnifiid.Rows[0][0].ToString();
            string sql_LOTINFO = @"INSERT INTO SD_OP_LOTINFO (LOT_ID,ORDER_NO,PRODUCT_ID,PROCESS_NAME,STEP_CURRENTID,STEP_CURRENT,LOT_STATUS,LOT_STARTQTY,LOT_QTY,LINE_ID,WORKCENTER,CREATE_USER,ARY_LOT) 
                        SELECT '" + newlotid + "','" + ddlWok + "','" + strProductId + "','" + strProcessName + "','1','" + strStepCurrent + "','C','" + lotnum + "','" + lotnum + "','CUT','SLMES','" + userid + "','" + arylot + "' FROM DUAL";
            string sql_LOTWKP = @"INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID, SYSID, STEP_ID,STEPM_ID, EQP_ID, OUSER,CREATE_USER,IN_QTY,OUT_QTY, PASSCOUNT ,LINEID, MO, MO_FLAG1, MO_FLAG2, MO_FLAG3, MO_BRWFLAG,NIFIID,LOTSTATUS)
                                VALUES('" + newlotid + "','" + sysid + "','" + strStepCurrent + "','" + strStepCurrent + "','" + ddl_eqp + "','" + userid + "','" + userid + "','" + lotnum + "','" + lotnum + "','1','CUT','" + ddlWok + "','" + ddl_fa + "', '" + ddl_f + "', '" + strMoDesc + "', '" + strBrwFlag + "','" + nifiid + "','C')";

            string sql_RUNCARD = @"INSERT INTO SD_OP_RUNCARD (LOT_ID,PRODUCT_ID,LOT_STARTQTY,STEP_ID,STEP_CURRENTID,CREATE_USER,CREATE_DATE,IS_OFFLINE,ORDER_NO,PROCESS_NAME,ISOFF_LINE,IP_ADDR)
                        VALUES('" + newlotid + "','" + strProductId + "','" + lotnum + "','" + strStepCurrent + "','1','" + userid + "',SYSDATE,'N','" + ddlWok + "','" + strProcessName + "','N','" + str_loginhost + "')";
            string sql_MONUM = @"UPDATE SD_OP_WORKORDER SET QUANTITY_CREATED = QUANTITY_CREATED + " + int.Parse(lotnum) + "  WHERE ORDER_NO ='" + ddlWok + "'";
            string sql_ARYLOTNUM = @"UPDATE SD_OP_ARYLOT SET QUANTITY_CREATED = QUANTITY_CREATED + " + int.Parse(lotnum) + "  WHERE ARY_LOT ='" + arylot + "'";
            lists.Add(sql_LOTINFO); lists.Add(sql_LOTWKP); lists.Add(sql_RUNCARD); lists.Add(sql_MONUM); lists.Add(sql_ARYLOTNUM);
        }
        string mes = PubClass.excuteOts(lists);
        if (mes == "操作成功")
        {
            rtn = "下線成功" + newlotid + "";
            return rtn;
        }
        else
        {
            rtn = "下線失敗,請聯繫IT!";
            return rtn;
        }
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