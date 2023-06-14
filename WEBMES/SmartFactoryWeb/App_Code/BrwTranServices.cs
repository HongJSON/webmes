using System;
using System.Data;
using System.Web;
using Newtonsoft.Json;
using MesRepository;
using System.Windows.Forms;
using System.Data.OracleClient;

public class BrwTranServices
{
    static string Fab = System.Configuration.ConfigurationManager.AppSettings["Fab"].ToString();

    #region Base
    public static DataTable GetTime()
    {
        string sqltmp = @"SELECT TO_CHAR(SYSDATE,'yyyymmdd') FROM DUAL";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetLPAD()
    {
        string sqltmp = @"SELECT LPAD(REJECT_SEQENCE.NEXTVAL,4,'0') FROM DUAL";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetTimeYs()
    {
        string sqltmp = @"SELECT SYSDATE-3 DATEE FROM DUAL";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }
    #endregion
    #region J03
    public static DataTable GetBrwNgCodeName(string error)
    {
        string ngSql = "SELECT CODENAME  FROM BRWDEFFECTCODE WHERE PAGE='J03' AND DEFFECTCODE = '" + error + "'";
        DataTable dtcode = Repository.getdatatableMES(ngSql);
        return dtcode;
    }

    public static DataTable GetLongTime(string Lot)
    {
        string timeControl = "SELECT NVL(TO_CHAR(ROUND(SYSDATE-MAX(CREATEDATE),2)),0)  FROM BRWLOTOPERMSG WHERE LOTNO='" + Lot + "' AND ISPCS='N' AND STEPID IN('EPPROM清除','EPPROM清除1')";
        DataTable dtTimeC = Repository.getdatatableMES(timeControl);
        return dtTimeC;
    }

    public static string GetLotImformation(string step_current, string lotqty, string type, string order_no, string productid, string codejb, string gotodo, string codeid)
    {
        string sql1 = "select '" + step_current + "' STEP_CURRENT,'" + lotqty + "' LOT_QTY,'" + type + "' TYPE,'" + order_no + "' ORDER_NO,'" + productid + "' PRODUCTID,'" + codejb + "' CODEJB,'" + gotodo + "' GOTODO,'" + codeid + "' CODEID from dual";
        DataTable dtzz = Repository.getdatatableMES(sql1);
        string rtn = JsonConvert.SerializeObject(dtzz);
        return rtn;
    }
    public static DataTable GetISNG11(string lotId, string Ngchip)
    {
        string ngsql = "SELECT * FROM BRWLOTDETAIL WHERE  LOTNO ='" + lotId + "'AND  USN='" + Ngchip + "' AND   FLAG='Y'";
        DataTable dtstep = Repository.getdatatableMES(ngsql);
        return dtstep;
    }

    public static DataTable GetISNG(string stepId, string status, string motype, string codejb)
    {
        string ngsql = "SELECT * FROM BRWZPROCESS WHERE  STEPID ='" + stepId + "'AND  PRODUCTSTATUS='" + status + "' AND   CODEID='" + motype + "' AND GLASSTYPE='" + codejb + "'AND  ISDELETE='N'";
        DataTable dtstep = Repository.getdatatableMES(ngsql);
        return dtstep;
    }

    public static DataTable GetHaving(string chipid)
    {
        string strSQL = "SELECT * FROM BRWNGMSGTMP WHERE USN='" + chipid + "'";
        DataTable dt = Repository.getdatatableMES(strSQL);
        return dt;
    }
    public static DataTable GetNGChip(string lotId, string Ngchip)
    {
        string strSQL = "SELECT * FROM BRWDETAIL WHERE LOTNO='" + lotId + "'AND USN='" + Ngchip + "'";
        DataTable dt = Repository.getdatatableMES(strSQL);
        return dt;
    }
    public static DataTable GetHavingNG(string str_Lot, string stepId, string chipid)
    {
        string strSQL = "SELECT * FROM BRWDETAIL WHERE LOTNO='" + str_Lot + "' AND STEPMID='" + stepId + "' AND USN='" + chipid + "'";
        DataTable dtdt = Repository.getdatatableMES(strSQL);
        return dtdt;
    }

    public static bool NgCodeIN(string Lotno, string Usn, string Stepid, string Stepmid, string DeffectCode, string Remark, string Ip, String User, string Page,string eqpid,string duty)
    {
        Repository.getdatatablenoreturnMES(@"INSERT INTO brwngmsgtmp( lotno,usn,stepid,stepmid,defectcode,codename,remark,IP,createuser,createdate,workpage,eqpid,duty) 
                                     VALUES('" + Lotno + "','" + Usn + "','" + Stepid + "','" + Stepmid + "','" + DeffectCode + "','','" + Remark + "','" + Ip + "','" + User + "',sysdate,'" + Page + "','" + eqpid + "','"+ duty +"')");
        return true;
    }

    public static DataTable GetallNg(string gotodo, string stepId, string status, string motype, string codejb)
    {
        string allNg = "SELECT * FROM BRWZPROCESS WHERE  PROCESSNAME='" + gotodo + "' AND  STEPID ='" + stepId + "'AND  PRODUCTSTATUS='" + status + "' AND   CODEID='" + motype + "' AND GLASSTYPE='" + codejb + "' AND  ISALLNG='Y'";
        DataTable dtAll = Repository.getdatatableMES(allNg);
        return dtAll;
    }

    public static DataTable GetHis(string str_lot)
    {
        string strSQL = "SELECT * FROM BRWLOT WHERE LOTNO ='" + str_lot + "'";
        DataTable dtHis = Repository.getdatatableMES(strSQL);
        return dtHis;
    }

    public static DataTable GetCount(string str_lot)
    {
        string strSQL = "SELECT * FROM  BRWNGMSGTMP WHERE  LOTNO='" + str_lot + @"'";
        DataTable dtCount = Repository.getdatatableMES(strSQL);
        return dtCount;
    }
    public static DataTable GetCount1(string gotodo, string status, string motype, int SSS)
    {
        string strSQL = "";
        if (SSS == 100)
        {
            strSQL = "SELECT * FROM  BRWZPROCESS WHERE CODEID= '" + motype + @"' AND PROCESSNAME='" + gotodo + @"'AND PRODUCTSTATUS='" + status + @"'";

        }
        else
        {
            strSQL = "SELECT * FROM  BRWZPROCESS WHERE CODEID= '" + motype + @"' AND PROCESSNAME='" + gotodo + @"'AND PRODUCTSTATUS='" + status + @"'AND SEQ='" + SSS + @"'";

        }
        DataTable dtCount = Repository.getdatatableMES(strSQL);
        return dtCount;
    }

    public static DataTable GetWork(string Mo)
    {
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT ORDER_NO MO,MOTYPE,PRODUCT_ID UPN,CELL_COME GLASSTYPE,MO_TYPE CODEID FROM SD_OP_WORKORDER WHERE ORDER_NO='" + Mo + "'";
        }
        if (Fab == "Fab3")
        {
            strSQL = " SELECT A.MO,A.MOTYPE,A.UPN,'J1' AS GLASSTYPE,B.CODEID FROM SFCMO A LEFT JOIN SFCUPNINFO B ON A.UPN=B.UPN WHERE MO='" + Mo + "'";
        }
        DataTable dtcode = Repository.getdatatableMES(strSQL);
        return dtcode;
    }

    public static DataTable GetSysid()
    {
        string sqlxx2 = "SELECT WKP_SEQUENCE.NEXTVAL FROM DUAL";
        DataTable dtxx2 = Repository.getdatatableMES(sqlxx2);
        return dtxx2;
    }

    public static DataTable GetNGMSG(string str_Lot)
    {
        string sqlxx2 = "SELECT * FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "'";
        DataTable dtngqty = Repository.getdatatableMES(sqlxx2);
        return dtngqty;
    }

    public static DataTable GetChildLot(string gotodo, string stepId, string status, string motype, string codejb)
    {
        string childLot = "SELECT DISTINCT  CHILDPROCESS,CODEID FROM BRWZPROCESS WHERE  PROCESSNAME='" + gotodo + "' AND  STEPID ='" + stepId + "'AND  PRODUCTSTATUS='" + status + "' AND   CODEID='" + motype + "' AND GLASSTYPE='" + codejb + "' AND ISDELETE='N' ";//根据站点获取子流程和机种
        DataTable dtLot = Repository.getdatatableMES(childLot);
        return dtLot;
    }

    public static DataTable CheckLot(string childMlot)
    {
        string sqlnew = "SELECT * FROM BRWLOT WHERE LOTNO LIKE '" + childMlot + "%'";
        DataTable dtnew = Repository.getdatatableMES(sqlnew);
        return dtnew;
    }

    public static DataTable INTTOH10(int tmp1)
    {
        string sqltmp = "SELECT INTTOH10(" + tmp1 + ",3) FROM DUAL";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }
    public static DataTable childMlot(string childMlot)
    {
        string sqltmp = "SELECT LOTNO FROM BRWLOT WHERE LOTNO='" + childMlot + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }
    public static DataTable GetZPR(string project, string motype, string status, string codejb)
    {
        string getStep = "SELECT * FROM BRWZPROCESS WHERE  PROCESSNAME ='" + project + "' AND CODEID='" + motype + "' AND PRODUCTSTATUS='" + status + "' AND GLASSTYPE='" + codejb + "' ORDER BY SEQ";
        DataTable dtStep = Repository.getdatatableMES(getStep);
        return dtStep;
    }

    public static bool InBrwRun(string childMlot, string productid, string strUser, string order_no, string stepID, string project, string str_Lot, string PROCESSNAME, string IP)
    {

        try
        {

            Repository.getdatatablenoreturnMES("INSERT INTO BRWLOT (LOTNO,MO,PROCESSNAME,STEPCURRENT,STEPCURRENTID,CREATEUSER,CREATEDATE,IP,LOTQTY,RECEIVEFLAG) SELECT  '" + childMlot + "','" + order_no + "','" + project + "','" + stepID + "','1','" + strUser + "',SYSDATE,'" + IP + "',count(USN),'Y' FROM BRWNGMSGTMP WHERE  LOTNO='" + str_Lot + "'");
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static bool UPDBRWNG(string str_lot, string strUser, string IP)
    {

        try
        {

            Repository.getdatatablenoreturnMES("UPDATE BRWLOTDETAIL SET FLAG='N' WHERE USN IN(SELECT USN FROM BRWNGMSGTMP  WHERE CREATEUSER='" + strUser + "' AND LOTNO='" + str_lot + "')AND LOTNO='" + str_lot + "'");
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static bool InSertBRWNG(string str_Lot)
    {
        try
        {

            Repository.getdatatablenoreturnMES("INSERT INTO BRWNGMSG (LOTNO, USN, DEFECTCODE,STEPID, STEPMID,CREATEUSER,REMARK,DUTY)  SELECT LOTNO , USN, DEFECTCODE, STEPID, STEPMID,CREATEUSER,REMARK,DUTY FROM BRWNGMSGTMP WHERE LOTNO = '" + str_Lot + "' ");
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static bool DelBRWNG(string str_Lot)
    {
        try
        {

            Repository.getdatatablenoreturnMES("DELETE FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "'");
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static string MoveOut(string str_Lot, string stepId, string strUser, string order_no, int sysid, int in_qty, int out_qty, int ng, int SSS, string SEQ, int process_id)
    {
        string rtn = "";
        try
        {
            string cmd1 = @"INSERT INTO BRWLOTOPERMSG (LOTNO,SYSID,STEPID,STEPMID,EQPID,INTIME,OUTTIME,CREATEUSER,INQTY,OUTQTY,ISPCS) SELECT '" + str_Lot + "', '" + sysid + "',  '" + stepId + "', '" + stepId + "', '" + process_id + "', sysdate, sysdate, '" + strUser + "', '" + in_qty + "', '" + out_qty + "','N' FROM DUAL";
            string cmd2 = @"INSERT INTO BRWDETAIL(SYSID, LOTNO, PRODUCTCODE, REASONCODE,STEPID, STEPMID, USN,REMARK,CREATEUSER,CREATEDATE,EQPID,DUTY) SELECT " + sysid + ", '" + str_Lot + "' , USN, defectcode, STEPID, STEPMID, USN,REMARK,CREATEUSER,CREATEDATE,EQPID,DUTY FROM BRWNGMSGTMP WHERE LOTNO = '" + str_Lot + "'";
            string cmd4 = @"UPDATE BRWLOT SET LOTQTY=LOTQTY-" + ng + " ,STEPCURRENTID='" + SSS + "',STEPCURRENT='" + SEQ + "'WHERE LOTNO='" + str_Lot + "'";
            string cmd6 = @"UPDATE BRWUSNINFO A SET A.NEWDEFFECTCODE=(SELECT DISTINCT B.DEFECTCODE FROM BRWNGMSGTMP B WHERE A.USN=B.USN ) WHERE (USN) IN(SELECT USN FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "') AND MO='" + order_no + "'";

            Repository.getdatatablenoreturnMES(cmd1);
            Repository.getdatatablenoreturnMES(cmd2);
            Repository.getdatatablenoreturnMES(cmd4);
            Repository.getdatatablenoreturnMES(cmd6);

            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬成功\"}]";
            return rtn;
        }
        catch
        {

            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static string CreateChild(string str_Lot, string strUser, string motype, string productid, string order_no, string childMlot)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"INSERT INTO BRWLOTDETAIL(LOTNO,USN,FLAG) SELECT '" + childMlot + "',USN,'Y' FROM  BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "'";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"小Lot創建失敗\"}]";
            return rtn;

        }
        return rtn;
    }
    #endregion
    #region R14

    public static DataTable GetCommenCreate(string ChipId)
    {
        string sqltmp = @"select DISTINCT A.REJECTED_ID,A.ITEM_TYPE,nvl(A.REMARK_CODE,'NULL')REMARK_CODE,B.LH_ID,B.STORELOC,A.ORDER_NO,A.CREATE_DATE  from Sd_Op_Rejected a
                          left join sd_op_rejectedmain b on a.rejected_id = b.rejected_id
                          where (a.product_codecell,a.create_date) in (select product_codecell,max(create_date) from sd_op_rejected
                          where product_codecell  = '" + ChipId + "' group by product_codecell)";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetTmpCreate(string user)
    {
        string sqltmp = @"SELECT DISTINCT ORDER_NO,ITEM_TYPE,PRODUCT_ID,nvl(REMARK_CODE,'NULL') REMARK_CODE,REJECTED_ID FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER='" + user + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetWorkorder(string order_no)
    {
        string sqltmp = @"select * from sd_op_workorder where order_no='" + order_no + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetLOC(string user)
    {
        string sqltmp = @"SELECT STORELOC FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID IN(SELECT REJECTED_ID FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER ='" + user + "')";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetCommonGroup(string rejected_id)
    {
        string sqltmp = @"SELECT CODE_TYPE FROM SD_OP_REPAIRREJECT WHERE (PRODUCT_TYPE,PRODUCT_STATUS,REASON_CODE,STORE_LOC) IN(
SELECT D.MO_TYPE,A.ITEM_TYPE,CASE WHEN B.REASON_CODE IS NOT NULL THEN B.REASON_CODE ELSE C.REASON_CODE END REASON_CODE,B.STORELOC 
FROM SD_OP_REJECTED A,SD_OP_REJECTEDMAIN B,SD_OP_BRWINFO C,SD_OP_WORKORDER D WHERE A.ORDER_NO=D.ORDER_NO
AND A.PRODUCT_CODECELL=C.PRODUCT_CODECELL AND A.ORDER_NO=C.ORDER_NO AND A.REJECTED_ID='" + rejected_id + "' AND B.REJECTED_ID=A.REJECTED_ID)";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetTmpGroup(string user)
    {
        string sqltmp = @"SELECT CODE_TYPE FROM SD_OP_REPAIRREJECT WHERE (PRODUCT_TYPE,PRODUCT_STATUS,REASON_CODE,STORE_LOC) IN(
SELECT D.MO_TYPE,A.ITEM_TYPE,CASE WHEN B.REASON_CODE IS NOT NULL THEN B.REASON_CODE ELSE C.REASON_CODE END REASON_CODE,B.STORELOC 
FROM SD_OP_REJECTED A,SD_OP_REJECTEDMAIN B,SD_OP_BRWINFO C,SD_OP_WORKORDER D WHERE A.ORDER_NO=D.ORDER_NO
AND A.PRODUCT_CODECELL=C.PRODUCT_CODECELL AND A.ORDER_NO=C.ORDER_NO AND A.REJECTED_ID IN(SELECT REJECTED_ID FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER ='" + user + "') AND B.REJECTED_ID=A.REJECTED_ID)";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetProZB(string ChipId)
    {
        string sqltmp = @"SELECT * FROM SD_OP_WORKORDER WHERE ORDER_NO IN (SELECT ORDER_NO FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + ChipId + "') AND MO_TYPE='ZMPD'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetProZb(string ChipId)
    {
        string sqltmp = @"select get_zebie('" + ChipId + "') from dual";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetChipProcess(string ChipId)
    {
        string sqltmp = @"SELECT DISTINCT NVL(C.PROCESS_NAME,'NULL') PROCESS_NAME,NVL(F.ZEBIE,'NULL')ZEBIE
FROM sd_op_lotproduct A,SD_OP_BRWRUNCARD C,SD_HIS_BRWLOTPRODUCT D,SD_HIS_EDITORDERINFO F
WHERE  C.LOT_ID=D.BLOT_ID AND A.PRODUCT_CODECELL=D.PRODUCT_CODECELL AND A.ORDER_NO=D.ORDER_NO and ZEBIE is not null
AND A.product_codecell='" + ChipId + "' AND A.ORDER_NO=F.ORDER_NO";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetCHProcess(string ChipId)
    {
        string sqltmp = @"SELECT DISTINCT B.MO_TYPE,A.PRODUCT_ID,e.ITEM3,NVL(C.PROCESS_NAME,'NULL') PROCESS_NAME,NVL(F.ZEBIE,'NULL')ZEBIE
FROM sd_op_lotproduct A,SD_OP_WORKORDER B,SD_OP_BRWRUNCARD C,SD_HIS_BRWLOTPRODUCT D,SD_HIS_EDITORDERINFO F,SD_OP_rejected e
WHERE A.ORDER_NO=B.ORDER_NO AND C.LOT_ID=D.BLOT_ID AND A.PRODUCT_CODECELL=D.PRODUCT_CODECELL AND A.ORDER_NO=D.ORDER_NO and ZEBIE is not null
AND A.product_codecell='" + ChipId + "' AND A.ORDER_NO=F.ORDER_NO and a.product_codecell=e.product_codecell and a.order_no=e.order_no";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetTmpProcess(string user)
    {
        string sqltmp = @"SELECT DISTINCT B.MO_TYPE,A.PRODUCT_ID,a.ITEM3,NVL(C.PROCESS_NAME,'NULL') PROCESS_NAME,NVL(F.ZEBIE,'NULL')ZEBIE
FROM SD_TMP_REPAIRREJECTED A,SD_OP_WORKORDER B,SD_OP_BRWRUNCARD C,SD_HIS_BRWLOTPRODUCT D,SD_HIS_EDITORDERINFO F
WHERE A.ORDER_NO=B.ORDER_NO AND C.LOT_ID=D.BLOT_ID AND A.PRODUCT_CODECELL=D.PRODUCT_CODECELL AND A.ORDER_NO=D.ORDER_NO and ZEBIE is not null
AND A.ORDER_NO=F.ORDER_NO and a.CREATE_USER='" + user + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable CheckMotypeType(string order, string order1)
    {
        string sqltmp = @"SELECT DISTINCT NVL(CELL_COME,'NULL'),MO_TYPE FROM SD_OP_WORKORDER WHERE ORDER_NO IN('" + order + "','" + order1 + "')";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable CheckStoreIn(string REJECTED_ID)
    {
        string sqltmp = @"SELECT * FROM WMSIOENTITY@WOKLMS WHERE STATUS=2 AND CARTONID ='" + REJECTED_ID + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable Checkcodetype(string rejected_id)
    {
        string sqltmp = @"SELECT CODE_TYPE FROM SD_OP_REPAIRREJECT WHERE (PRODUCT_TYPE,PRODUCT_STATUS,REASON_CODE,STORE_LOC) IN(
SELECT D.MO_TYPE,A.ITEM_TYPE,CASE WHEN B.REASON_CODE IS NOT NULL THEN B.REASON_CODE ELSE C.REASON_CODE END REASON_CODE,B.STORELOC 
FROM SD_OP_REJECTED A,SD_OP_REJECTEDMAIN B,SD_OP_BRWINFO C,SD_OP_WORKORDER D WHERE A.ORDER_NO=D.ORDER_NO
AND A.PRODUCT_CODECELL=C.PRODUCT_CODECELL AND A.ORDER_NO=C.ORDER_NO AND A.REJECTED_ID='" + rejected_id + "' AND B.REJECTED_ID=A.REJECTED_ID)";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetTempRe(string rejected_id)
    {
        string sqltmp = "SELECT * FROM SD_TMP_REPAIRREJECTED WHERE REJECTED_ID ='" + rejected_id + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }


    public static DataTable CheckStore(string rejected_id)
    {
        string sqltmp = "SELECT * FROM WMSIOENTITY@WOKLMS WHERE STATUS=2 AND CARTONID ='" + rejected_id + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static string InsertTmp(string rejected_id, string user, string type)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"INSERT INTO SD_TMP_REPAIRREJECTED (REJECTED_ID,ORDER_NO,PRODUCT_CODE,CREATE_USER,CREATE_DATE,ITEM_TYPE,WORKCENTER,PRODUCT_CODECELL,CODE_ID,ITEM3,REMARK_CODE,PRODUCT_ID,CODE_TYPE,REPAIR_TYPE,SN_TYPE)
SELECT A.REJECTED_ID,A.ORDER_NO,A.PRODUCT_CODE,'" + user + @"',SYSDATE,A.ITEM_TYPE,A.WORKCENTER,A.PRODUCT_CODECELL,A.CODE_ID,A.ITEM3,A.REMARK_CODE,B.LH_ID ,'" + type + @"','',''
FROM SD_OP_REJECTED A,SD_OP_REJECTEDMAIN B WHERE B.REJECTED_ID='" + rejected_id + @"' AND A.REJECTED_ID=B.REJECTED_ID";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"主箱號入臨時表失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static string InsertTemp(string REJECTED_ID, string ORDER_NO, string rejected_id, string user, string ITEM_TYPE, string REMARK_CODE, string LH_ID, string type, string ChipId)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"INSERT INTO SD_TMP_REPAIRREJECTED (REJECTED_ID,ORDER_NO,PRODUCT_CODE,CREATE_USER,CREATE_DATE,ITEM_TYPE,WORKCENTER,PRODUCT_CODECELL,CODE_ID,ITEM3,REMARK_CODE,PRODUCT_ID,CODE_TYPE,REPAIR_TYPE,SN_TYPE) 
                          VALUES('" + REJECTED_ID + @"','" + ORDER_NO + @"','" + rejected_id + @"',
                          '" + user + @"',SYSDATE,'" + ITEM_TYPE + @"','JOAN','" + ChipId + @"','0','" + ITEM_TYPE + @"','" + REMARK_CODE + @"','" + LH_ID + @"','" + type + @"','','')";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"主箱號入臨時表失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static DataTable GetTempUser(string user)
    {
        string sqltmp = @"SELECT * FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER='" + user + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetRemain(string rejected_id)
    {
        string sqltmp = @"SELECT * FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID = '" + rejected_id + "'";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static DataTable GetTempCount(string user)
    {
        string sqltmp = @"SELECT REJECTED_ID, COUNT(*) CC FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER ='" + user + "' GROUP BY REJECTED_ID";
        DataTable dtsqltmp = Repository.getdatatableMES(sqltmp);
        return dtsqltmp;
    }

    public static string CreatBox(string rejected_id, string user, string backid, string LH_ID, string STORELOC, string WORK_TYPE, string CODE_2, string code_type, string repair_type, string sn_type, int qty)
    {
        string rtn = "";
        try
        {
            string cmd1 = @"DELETE SD_OP_REJECTEDMAIN WHERE REJECTED_ID = '" + rejected_id + "'";
            Repository.getdatatablenoreturnMES(cmd1);
            string cmd2 = @"INSERT INTO SD_HIS_MESWORK(PRODUCT_CODECELL,REMARK,ORDER_NO,CREATE_USER,CREATE_DATE,PRODUCT_STATUS)
                SELECT PRODUCT_CODECELL,'合箱作業','" + backid + "','" + user + "',SYSDATE ,REJECTED_ID FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER='" + user + "'";
            Repository.getdatatablenoreturnMES(cmd2);
            string cmd3 = @"UPDATE SD_OP_REJECTED SET REJECTED_ID ='" + backid + @"', CREATE_USER ='" + user + @"',CREATE_DATE= SYSDATE
                WHERE (PRODUCT_CODECELL,ORDER_NO,REJECTED_ID) IN (SELECT PRODUCT_CODECELL,ORDER_NO,REJECTED_ID FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER = '" + user + "')";
            Repository.getdatatablenoreturnMES(cmd3);
            string cmd4 = @"INSERT INTO SD_OP_REJECTEDMAIN(REJECTED_ID,LH_ID,CREATE_USER,CREATE_DATE,WORKCENTER,STORELOC,WORK_TYPE,CODE_2,REJECTED_QTY,CODE_TYPE,REPAIR_TYPE,SN_TYPE) VALUES('" + backid + "','" + LH_ID + "','" + user + "',SYSDATE,'JOAN','" + STORELOC + "','" + WORK_TYPE + "','" + CODE_2 + "','" + qty + "','" + code_type + "','" + repair_type + "','" + sn_type + "')";
            Repository.getdatatablenoreturnMES(cmd4);
            string cmd5 = @"INSERT INTO SD_HIS_REJECTEDLINK(rejected_id,create_user,create_date,site)SELECT '" + backid + "',CREATE_USER,SYSDATE,SITE FROM SD_HIS_REJECTEDLINK WHERE rejected_id='" + rejected_id + "'";
            Repository.getdatatablenoreturnMES(cmd5);
            string cmd6 = @"INSERT INTO SD_HIS_WEIGHTLOG(REJECTED_ID,CODE_ID,PRODUCT_STATUS,COUNTNUM,CODE_JB)
        SELECT '" + backid + @"', ITEM3,B.MO_TYPE,COUNT(A.PRODUCT_CODECELL),C.CODE_JB FROM 
        SD_OP_REJECTED A,SD_OP_WORKORDER B,SD_BASE_CODEWITHPRODUCT C WHERE A.ORDER_NO=B.ORDER_NO AND B.PRODUCT_ID=C.PRODUCT_ID AND  A.REJECTED_ID='" + backid + "' GROUP BY ITEM3,B.MO_TYPE,C.CODE_JB";
            Repository.getdatatablenoreturnMES(cmd6);
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"操作成功\"}]";
            return rtn;
        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"主箱號入臨時表失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static string UpReMain(string rejected_id, int qty)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"UPDATE SD_OP_REJECTEDMAIN SET REJECTED_QTY = REJECTED_QTY - " + qty + " WHERE REJECTED_ID = '" + rejected_id + "'";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"更新失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    #endregion
    #region X03/X04/X10//R29
    public static DataTable CheckLock(string ip)
    {
        string sqlmmk1 = "select is_lock from LOCK_TYPE where is_lock='Y' and  type_name='BLREJECT' and lot_id='" + ip + "'";
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }

    public static string UpLock(string ip)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"insert into LOCK_TYPE (type_name,is_lock,lot_id) values ('BLREJECT','N','" + ip + "')";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"上鎖失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static string DelLock(string ip)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"delete from LOCK_TYPE where lot_id='" + ip + "'AND TYPE_NAME='BLREJECT'";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"解鎖失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static DataTable CheckTrans(string code133_17)
    {
        string sqlmmk1 = "SELECT * FROM MELON_ALLIE_TRANS@MELONMACHINE WHERE USN = '" + code133_17 + "' ORDER BY CREATE_DATE DESC";
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }

    public static DataTable GetCGSLPMATERIAL(string LH, string page)
    {
        string sqlmmk1 = "";
        if (Fab == "Fab1/2")
        {
            sqlmmk1 = "SELECT DISTINCT CODEID AS MO_TYPE,COLOR,UPN AS LH FROM BRWCGMATERIAL WHERE UPN='" + LH + "' AND WORKPAGE='" + page + "'";
        }
        if (Fab == "Fab3")
        {
            sqlmmk1 = "SELECT DISTINCT CODEID AS MO_TYPE,COLOR,UPN AS LH FROM BRWCGMATERIAL WHERE UPN='" + LH + "' AND WORKPAGE='" + page + "'";
        }
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }

    public static DataTable GetSubCG(string product_cg)
    {
        string sqlmmk1 = "SELECT SUBSTR('" + product_cg + "',12,4) FROM DUAL";
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }

    public static DataTable GetFCGTYPE(string type, string page)
    {
        string sqlmmk1 = "SELECT MO_TYPE,MO_COLOR,SUBSTR_CODE FROM SD_TMP_FCGTYPE WHERE SUBSTR_CODE='" + type + "' AND FLAG='" + page + "'";
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }

    public static DataTable GetMelon(string LH)
    {
        string sqlmmk1 = "SELECT * FROM SD_BASE_CGSLPMATERIAL WHERE LH='" + LH + "' AND MO_TYPE in('Melon','Melon2')";
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }

    public static DataTable GetLH(string page)
    {
        string sqlmmk1 = "";
        if (Fab == "Fab1/2")
        {
            sqlmmk1 = "SELECT DISTINCT UPN AS LH FROM BRWCGMATERIAL WHERE WORKPAGE='" + page + "' ORDER BY LH";
        }
        if (Fab == "Fab3")
        {
            sqlmmk1 = "SELECT DISTINCT UPN AS LH FROM BRWCGMATERIAL WHERE UPN IN(SELECT MATERIAL FROM SFCMATERIALINFO)AND WORKPAGE='" + page + "' ORDER BY LH";
        }

        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }

    public static DataTable GetTmpTable(string ip, string user, string page)
    {
        string sql = "SELECT * FROM BRWREJECTEDTMP WHERE  CREATEUSER='" + user + "'  AND WORKPAGE='" + page + "' ORDER BY CREATEDATE DESC";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static bool DelALL(string ip, string user, string page)
    {
        try
        {

            Repository.getdatatablenoreturnMES("DELETE BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER='" + user + "' AND WORKPAGE='" + page + "'");
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static bool DelPCS(string ip, string product_cg, string page)
    {
        try
        {

            Repository.getdatatablenoreturnMES("DELETE FROM BRWREJECTEDTMP WHERE USN = '" + product_cg + "' AND IP = '" + ip + "' AND WORKPAGE='" + page + "' ");
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static DataTable GetLO(string page)
    {
        string sqlmmk1 = "";
        if (Fab == "Fab1/2")
        {
            sqlmmk1 = "SELECT LOC,LOCNAME||'-'||LOC LOCNAME FROM BRWZJLOC WHERE WORKPAGE='" + page + "' ORDER BY LOC";
        }
        if (Fab == "Fab3")
        {
            sqlmmk1 = "SELECT LOC,LOCNAME||'-'||LOC LOCNAME FROM BRWZJLOC WHERE WORKPAGE='" + page + "' ORDER BY LOC";
        }
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }
    #endregion
    #region X03
    //X03
    public static DataTable GetDisCG(string ip, string user, string page)
    {
        string sql = "SELECT DISTINCT UPN,LOTNO FROM BRWREJECTEDTMP WHERE IP='" + ip + "'  AND CREATEUSER='" + user + "' AND WORKPAGE='" + page + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetDisPro(string ip, string user, string page, string basepage)
    {
        string sql = @"SELECT DISTINCT MAKER FROM BRWCGMATERIAL WHERE UPN IN(
SELECT DISTINCT UPN FROM BRWREJECTEDTMP 
WHERE IP='" + ip + "'  AND CREATEUSER='" + user + "'  AND WORKPAGE='" + page + "') AND WORKPAGE='" + basepage + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable CheckReSerove(string backid, string page)
    {
        string sql = "SELECT * FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + backid + "' AND WORKPAGE='" + page + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static string InFCGReject(string backid, string loc, string ip, string user, string page, string LH)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"INSERT INTO BRWREJECTED(USN,CREATEUSER,REJECTEDID,MO,STATUS,CREATEDATE,ISDELETE) 
SELECT USN,CREATEUSER,'" + backid + "','" + LH + "',LOTNO,SYSDATE,'N' FROM BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER='" + user + "' AND WORKPAGE='" + page + "'";
            Repository.getdatatablenoreturnMES(cmd3);

            string cmd4 = @"INSERT INTO BRWREJECTEDMAIN(REJECTEDID,HALFPARTID,LOC,CREATEUSER,CREATEDATE,WORKPAGE) 
SELECT '" + backid + "','" + LH + "','" + loc + "',CREATEUSER,SYSDATE,WORKPAGE FROM BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER='" + user + "' AND WORKPAGE='" + page + "'";
            Repository.getdatatablenoreturnMES(cmd4);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"打包失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static string DelFogRe(string user, string cancelbox, string page)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"DELETE BRWREJECTEDMAIN WHERE REJECTEDID='" + cancelbox + "'  AND WORKPAGE='" + page + "'";
            Repository.getdatatablenoreturnMES(cmd3);
            string cmd4 = @"UPDATE BRWREJECTED SET ISDELETE = 'Y',CREATEDATE = SYSDATE,CREAETUSER = '" + user + "' WHERE REJECTEDID='" + cancelbox + "'";
            Repository.getdatatablenoreturnMES(cmd4);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"取消箱號失敗\"}]";
            return rtn;

        }
        return rtn;
    }

    public static DataTable CheckCGSerove(string product_cg, string page)
    {
        string sql = "SELECT * FROM BRWREJECTED  WHERE  USN='" + product_cg + "' AND ISDELETE='N'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable CheckTmpSerove(string product_cg, string page)
    {
        string sql = "SELECT *  FROM BRWREJECTEDTMP  WHERE  USN ='" + product_cg + "'  AND WORKPAGE='" + page + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable CheckMelonYN(string ip, string user, string page)
    {
        string sql = "SELECT * FROM BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER='" + user + "'  AND WORKPAGE='" + page + "' AND LENGTH(USN)!=133 AND LENGTH(USN)!=141";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetTmpMO(string ip, string user, string page)
    {
        string sql = "SELECT DISTINCT SUBSTR(USN,0,3) CODE3,UPN FROM BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER='" + user + "'  AND WORKPAGE='" + page + "' AND LENGTH(USN) in (133,141)";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetTmpUPN(string ip, string user, string page)
    {
        string sql = "SELECT DISTINCT UPN FROM BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER='" + user + "'  AND WORKPAGE='=" + page + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable CheckCGSLPMATERIAL(string ip, string user, string page, string LH, string basepage)
    {
        string sql = @"SELECT DISTINCT F_TYPE FROM SD_BASE_CGSLPMATERIAL WHERE LH IN(
SELECT DISTINCT A.PRODUCT_ID FROM(
SELECT PRODUCT_ID FROM SD_TMP_FCGREJECTED
WHERE IP_ADDR='" + ip + "' AND CREATE_USER='" + user + @"'  AND P_NO='" + page + @"'
UNION ALL
SELECT '" + LH + "' PRODUCT_ID FROM DUAL) A) AND P_NO='" + basepage + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static string InTmpFCG(string product_cg, string user, string ip, string code, string codema,string lh, string page)
    {
        string rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"刷入成功\"}]";
        try
        {
            string cmd3 = @"INSERT INTO BRWREJECTEDTMP(USN,CREATEUSER,CREATEDATE,IP,CODEID,UPN,WORKPAGE,HALFPARTID)
VALUES('" + product_cg + "','" + user + "',sysdate,'" + ip + "','" + code + "','" + codema + "','" + page + "','" + lh + "')";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"刷入失敗\"}]";
            return rtn;

        }
        return rtn;
    }
    #endregion
    #region X04
    public static string InweightLog(string backid, string user, string ip, string page)
    {
        string rtn = "";
        try
        {
            string cmd3 = @"INSERT INTO SD_HIS_WEIGHTLOG(REJECTED_ID,CODE_ID,PRODUCT_STATUS,COUNTNUM,CODE_JB)
SELECT '" + backid + "', 'NA',LOTNO,COUNT(USN),'NA' FROM BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER = '" + user + "' AND WORKPAGE='" + page + "' GROUP BY LOTNO";

            Repository.getdatatablenoreturnMES(cmd3);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"刷入失敗\"}]";
            return rtn;

        }
        return rtn;
    }
    #endregion
    #region R29
    public static string checkBNG(string idname, string chipID, string ipAddr, string userid)
    {
        string msgPRT = "NA";
        string checktmpB = "";
        string checktmp = "";
        string is_f56 = "SELECT DISTINCT B.MO_TYPE FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.ORDER_NO=B.ORDER_NO AND A.PRODUCT_CODECELL='" + chipID + "'AND  B.ORDER_NO NOT IN ('000029317011','000029317010','000029317007','000029317008','000091655843','000091675972','000091675973','000091675974','000091675975')";
        DataTable dt_f56 = Repository.getdatatableMES(is_f56);
        if (dt_f56.Rows.Count > 0)
        {
            string codeID = dt_f56.Rows[0][0].ToString();
            if (codeID == "F56" || codeID == "F54")
            {
                if (idname.ToString() == "R06" || idname.ToString() == "R20")
                {
                    checktmp = "SELECT *  FROM  sd_tmp_brwreceive WHERE  user_ip='" + ipAddr + "'";
                    checktmpB = @"SELECT *  FROM  sd_tmp_brwreceive WHERE PRODUCT_CODECELL IN( SELECT A.SN FROM SD_TMP_BERRCODE A,SD_OP_LOTPRODUCT B,SD_OP_WORKORDER C
 WHERE A.SN=B.PRODUCT_CODECELL AND A.FLAG='Y' AND B.ORDER_NO=C.ORDER_NO AND C.MO_TYPE='" + codeID + "') AND user_ip='" + ipAddr + "'";

                }
                if (idname.ToString() == "R08" || idname.ToString() == "R31" || idname.ToString() == "R33" || idname.ToString() == "R37" || idname.ToString() == "R40")
                {
                    checktmp = "SELECT * FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'";
                    checktmpB = @"SELECT *  FROM  SD_TMP_BRWTOMA WHERE PRODUCT_CODECELL IN( SELECT A.SN FROM SD_TMP_BERRCODE A,SD_OP_LOTPRODUCT B,SD_OP_WORKORDER C
 WHERE A.SN=B.PRODUCT_CODECELL AND A.FLAG='Y' AND B.ORDER_NO=C.ORDER_NO AND C.MO_TYPE='" + codeID + "') AND IP_ADDR='" + ipAddr + "'";
                }
                if (idname.ToString() == "R13" || idname.ToString() == "R38")
                {
                    checktmp = @"SELECT* FROM SD_TMP_REJECTED WHERE IP_ADDR='" + ipAddr + "' AND CREATE_USER='" + userid + "' ";
                    checktmpB = @"SELECT *  FROM  SD_TMP_REJECTED WHERE PRODUCT_CODECELL IN( SELECT A.SN FROM SD_TMP_BERRCODE A,SD_OP_LOTPRODUCT B,SD_OP_WORKORDER C
 WHERE A.SN=B.PRODUCT_CODECELL AND A.FLAG='Y' AND B.ORDER_NO=C.ORDER_NO AND C.MO_TYPE='" + codeID + "') AND IP_ADDR='" + ipAddr + "' AND CREATE_USER='" + userid + "'";
                }
                if (idname.ToString() == "R15")
                {
                    checktmp = "SELECT *  FROM  SD_TMP_BRWRECEIVE_CHAI  WHERE  USER_IP='" + ipAddr + "'";
                    checktmpB = @"SELECT *  FROM  SD_TMP_BRWRECEIVE_CHAI  WHERE PRODUCT_CODECELL IN( SELECT A.SN FROM SD_TMP_BERRCODE A,SD_OP_LOTPRODUCT B,SD_OP_WORKORDER C
 WHERE A.SN=B.PRODUCT_CODECELL AND A.FLAG='Y' AND B.ORDER_NO=C.ORDER_NO AND C.MO_TYPE='" + codeID + "') AND USER_IP='" + ipAddr + "'";
                }
                if (idname.ToString() == "R22")
                {
                    checktmp = "select* from SD_TMP_BRWREJECTEDRECEIVE where IP_ADDR='" + ipAddr + "'";
                    checktmpB = @"SELECT *  FROM  SD_TMP_BRWREJECTEDRECEIVE WHERE PRODUCT_CODECELL IN( SELECT A.SN FROM SD_TMP_BERRCODE A,SD_OP_LOTPRODUCT B,SD_OP_WORKORDER C
 WHERE A.SN=B.PRODUCT_CODECELL AND A.FLAG='Y' AND B.ORDER_NO=C.ORDER_NO AND C.MO_TYPE='" + codeID + "') AND IP_ADDR='" + ipAddr + "'";
                }
                if (idname.ToString() == "R26")
                {
                    checktmp = @"SELECT * FROM SD_TMP_BLOTRECEIVE WHERE CREATE_USER='" + ipAddr + "'";
                    checktmpB = @"SELECT *  FROM  SD_TMP_BLOTRECEIVE WHERE PRODUCT_CODECELL IN( SELECT A.SN FROM SD_TMP_BERRCODE A,SD_OP_LOTPRODUCT B,SD_OP_WORKORDER C
 WHERE A.SN=B.PRODUCT_CODECELL AND A.FLAG='Y' AND B.ORDER_NO=C.ORDER_NO AND C.MO_TYPE='" + codeID + "') AND CREATE_USER='" + ipAddr + "'";
                }
                if (idname.ToString() == "R29")
                {
                    checktmp = @"SELECT * FROM SD_TMP_BLREJECTED WHERE IP_ADDR='" + ipAddr + "' ";
                    checktmpB = @"SELECT *  FROM  SD_TMP_BLREJECTED WHERE PRODUCT_CODECELL IN( SELECT A.SN FROM SD_TMP_BERRCODE A,SD_OP_LOTPRODUCT B,SD_OP_WORKORDER C
 WHERE A.SN=B.PRODUCT_CODECELL AND A.FLAG='Y' AND B.ORDER_NO=C.ORDER_NO AND C.MO_TYPE='" + codeID + "') AND IP_ADDR='" + ipAddr + "'";
                }

                DataTable dtchecktmp = Repository.getdatatableMES(checktmp);
                DataTable dtchecktmpB = Repository.getdatatableMES(checktmpB);
                string checksn = "SELECT SN FROM SD_TMP_BERRCODE WHERE FLAG='Y' AND SN='" + chipID + "'";
                DataTable dtchecksn = Repository.getdatatableMES(checksn);
                if (dtchecktmp.Rows.Count > 0)
                {
                    if (dtchecktmpB.Rows.Count > 0)
                    {
                        if (dtchecksn.Rows.Count == 0)
                        {
                            msgPRT = "臨時表中為B類不良品需要單獨打包點收，請確認！";
                        }
                    }
                    else
                    {
                        if (dtchecksn.Rows.Count > 0)
                        {
                            msgPRT = "該產品為B類不良品需要單獨打包點收，請確認！";
                        }
                    }
                }
            }
        }
        return msgPRT;
    }

    public static string[] CheckSign(string type, string sn)
    {
        string[] result = { "", "" };
        string result1 = "NA";
        string result2 = "NA";
        string sqlcodeid = @"SELECT A.MO_TYPE FROM SD_OP_WORKORDER A,SD_OP_LOTPRODUCT B WHERE A.ORDER_NO=B.ORDER_NO AND B.PRODUCT_CODECELL='" + sn + @"'";
        DataTable dtcodeid = Repository.getdatatableMES(sqlcodeid);
        if (type == "B")
        {
            if (dtcodeid.Rows[0][0].ToString() != "F56")
            {
                result1 = "NA";
                string sqlbl = "SELECT PRODUCT_BL FROM SD_HIS_BLOTPRODUCTLABEL WHERE PRODUCT_CODECELL='" + sn + "' AND PRODUCT_BL<>'NULL'";
                DataTable dtbl = Repository.getdatatableMES(sqlbl);
                if (dtbl.Rows.Count > 0)
                {
                    string strbl = dtbl.Rows[0][0].ToString();
                    strbl = strbl.Substring(strbl.Length - 43);
                    if (dtcodeid.Rows[0][0].ToString() == "F62")
                    {
                        string bl13 = strbl.Substring(12, 1);
                        string bl17 = strbl.Substring(16, 1);
                        string bl22 = strbl.Substring(21, 1);
                        string bl32 = strbl.Substring(31, 1);
                        if (bl13 == "T" && bl17 == "H" && bl22 == "F" && bl32 == "2")
                        {
                            result1 = "A10353110";
                        }
                        else if (bl13 == "M" && bl17 == "H" && bl22 == "F" && bl32 == "2")
                        {
                            result1 = "A10331410";
                        }
                        else if (bl13 == "T" && bl17 == "H" && bl22 == "F" && bl32 == "1")
                        {
                            result1 = "A10461700";
                        }
                        else if (bl13 == "N" && bl17 == "H" && bl22 == "F" && bl32 == "1")
                        {
                            result1 = "A10461300";
                        }
                        else if (bl13 == "B" && bl17 == "G" && (bl22 == "M" || bl22 == "J") && bl32 == "1")
                        {
                            result1 = "A10353110";
                        }
                    }
                    if (dtcodeid.Rows[0][0].ToString() == "F64")
                    {
                        string bl11 = strbl.Substring(10, 1);
                        string bl17 = strbl.Substring(16, 1);
                        string bl22 = strbl.Substring(21, 1);
                        string bl32 = strbl.Substring(31, 1);
                        if (bl11 == "A" && bl17 == "H" && (bl22 == "M" || bl22 == "J") && bl32 == "2")
                        {
                            result1 = "A10515600";
                        }
                        if (bl11 == "A" && bl17 == "H" && bl22 == "F" && bl32 == "2")
                        {
                            result1 = "A10516000";
                        }
                        if (bl11 == "A" && bl17 == "G" && bl22 == "F" && bl32 == "1")
                        {
                            result1 = "A10516600";
                        }
                        if (bl11 == "A" && bl17 == "H" && bl22 == "F" && bl32 == "1")
                        {
                            result1 = "A10516400";
                        }
                        if (bl11 == "B" && bl17 == "G" && (bl22 == "M" || bl22 == "J") && bl32 == "1")
                        {
                            result1 = "A10515800";
                        }
                        if (bl11 == "B" && bl17 == "H" && bl22 == "F" && bl32 == "1")
                        {
                            result1 = "A10533100";
                        }
                        if (bl11 == "A" && bl17 == "G" && bl22 == "F" && bl32 == "2")
                        {
                            result1 = "A10543300";
                        }
                        if (bl11 == "A" && bl17 == "G" && (bl22 == "M" || bl22 == "J") && bl32 == "2")
                        {
                            result1 = "A10515800";
                        }
                    }
                    if (dtcodeid.Rows[0][0].ToString() == "F54")
                    {
                        string bl14 = strbl.Substring(13, 1);
                        string bl22 = strbl.Substring(21, 1);
                        string bl30 = strbl.Substring(29, 1);
                        string bl32 = strbl.Substring(31, 1);
                        if ((bl14 == "A" || bl14 == "B") && bl22 == "M" && bl30 == "M" && bl32 == "2")
                        {
                            result1 = "A10512000";
                        }
                        if ((bl14 == "E" || bl14 == "F") && bl22 == "M" && bl30 == "M" && bl32 == "2")
                        {
                            result1 = "A10512100";
                        }
                        if ((bl14 == "A" || bl14 == "B") && bl22 == "M" && bl30 == "M" && bl32 == "1")
                        {
                            result1 = "A10512200";
                        }
                        if ((bl14 == "E" || bl14 == "F") && bl22 == "M" && bl30 == "M" && bl32 == "1")
                        {
                            result1 = "A10512300";
                        }
                        if ((bl14 == "A" || bl14 == "B") && bl22 == "F" && bl30 == "S" && bl32 == "2")
                        {
                            result1 = "A10512400";
                        }
                        if ((bl14 == "E" || bl14 == "F") && bl22 == "F" && bl30 == "S" && bl32 == "2")
                        {
                            result1 = "A10512500";
                        }
                        if ((bl14 == "A" || bl14 == "B") && bl22 == "F" && bl30 == "Z" && bl32 == "1")
                        {
                            result1 = "A10512600";
                        }
                        if ((bl14 == "E" || bl14 == "F") && bl22 == "F" && bl30 == "Z" && bl32 == "1")
                        {
                            result1 = "A10512700";
                        }
                        if ((bl14 == "A" || bl14 == "B") && bl22 == "F" && bl30 == "Z" && bl32 == "2")
                        {
                            result1 = "A10513000";
                        }
                        if ((bl14 == "E" || bl14 == "F") && bl22 == "F" && bl30 == "Z" && bl32 == "2")
                        {
                            result1 = "A10513100";
                        }
                    }
                    if (result1 == "NA")
                    {
                        string bid1 = "SELECT * FROM SD_OP_PRODUCTSTATUS A,SD_OP_WORKORDER B WHERE A.ORDER_NO=B.ORDER_NO AND B.ID_ORDER IN ('03','03-3') AND A.PRODUCT_CODECELL='" + sn + "'";
                        DataTable dtpid3 = Repository.getdatatableMES(bid1);
                        string order_no = "";
                        if (dtpid3.Rows.Count > 0)
                        {
                            order_no = dtpid3.Rows[0]["ORDER_NO"].ToString();
                        }
                        string sqlfpc = @"SELECT A1.PART_ID FROM SD_OP_AUXPARTS A1, SD_BASE_SLPMATERIAL A2 WHERE A1.ORDER_NO = '" + order_no + @"' AND 
                A1.PART_ID =A2.CPN AND A2.DESCRIPTION = 'BL'";
                        DataTable dtfpc = Repository.getdatatableMES(sqlfpc);
                        if (dtfpc.Rows.Count > 0)
                        {
                            result1 = dtfpc.Rows[0][0].ToString();
                        }
                        else
                        {
                            result1 = "NG05:未找到79位印字單體發料料號";
                        }
                    }
                }
            }
            else
            {
                string bid1 = "SELECT * FROM SD_OP_PRODUCTSTATUS A,SD_OP_WORKORDER B WHERE A.ORDER_NO=B.ORDER_NO AND B.ID_ORDER IN ('03','03-3') AND A.PRODUCT_CODECELL='" + sn + "'";
                DataTable dtpid3 = Repository.getdatatableMES(bid1);
                string order_no = "";
                if (dtpid3.Rows.Count > 0)
                {
                    order_no = dtpid3.Rows[0]["ORDER_NO"].ToString();
                }
                string sqlfpc = @"SELECT A1.PART_ID FROM SD_OP_AUXPARTS A1, SD_BASE_SLPMATERIAL A2 WHERE A1.ORDER_NO = '" + order_no + @"' AND 
                A1.PART_ID =A2.CPN AND A2.DESCRIPTION = 'BL'";
                DataTable dtfpc = Repository.getdatatableMES(sqlfpc);
                if (dtfpc.Rows.Count > 0)
                {
                    result1 = dtfpc.Rows[0][0].ToString();
                }
                else
                {
                    result1 = "NG05:未找到79位印字單體發料料號";
                }
            }
        }
        result[0] = result1;
        result[1] = result2;
        return result;
    }

    public static DataTable CheckMelonold(string ip, string user, string page)
    {
        string sql = "SELECT * FROM  BRWREJECTEDTMP WHERE IP='" + ip + "' AND CREATEUSER='" + user + "'  AND WORKPAGE='=" + page + "' AND LENGTH(USN)=36 AND SUBSTR(USN,26,1)='0'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetChip(string product_bl, string Fab)
    {
        string sql = "";
        if (Fab == "Fab1/2")
        {
            if (product_bl.Length == 48 || product_bl.Length == 75 || product_bl.Length == 79 || product_bl.Length == 116)
            {
                sql = "SELECT DISTINCT PRODUCT_CODECELL FROM SD_HIS_BLOTPRODUCTLABEL WHERE PRODUCT_BL='" + product_bl + "'";
            }
            else if (product_bl.Length == 8 || product_bl.Length == 26 || product_bl.Length == 28)
            {
                sql = "SELECT DISTINCT PRODUCT_CODECELL FROM SD_HIS_BLOTPRODUCTLABEL WHERE PRODUCT_FPC='" + product_bl + "'";
            }
            else
            {
                sql = "SELECT DISTINCT PRODUCT_CODECELL FROM SD_HIS_BLOTPRODUCTLABEL WHERE PRODUCT_FPC='" + product_bl + "'";
            }
        }
        if (Fab == "Fab3")
        {
            if (product_bl.Length == 48 || product_bl.Length == 75 || product_bl.Length == 79 || product_bl.Length == 116)
            {
                sql = "SELECT DISTINCT USN FROM SFCUSNPRODUCTLABEL WHERE PRODUCTLABEL='" + product_bl + "'";
            }
        }
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetCode(string strProductId)
    {
        string sql = "SELECT * FROM SD_BASE_CODEWITHPRODUCT WHERE PRODUCT_ID = '" + strProductId + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable Getcodeid1(string val12)
    {
        string sql = " SELECT * FROM SFCBLCODEID WHERE EEEE ='" + val12 + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable Getcodeid12(string ip)
    {
        string sql = " SELECT DISTINCT CODEID FROM BRWREJECTEDTMP WHERE IP ='" + ip + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetBL(string ip)
    {
        string sql = " SELECT DISTINCT SUBSTR(USN,30,1) FROM BRWREJECTEDTMP WHERE IP ='" + ip + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable getDanLH(string ip)
    {
        string sql = " SELECT DISTINCT HALFPARTID FROM BRWREJECTEDTMP WHERE IP ='" + ip + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable getproductid(string ip)
    {
        string sql = " SELECT DISTINCT UPN FROM BRWREJECTEDTMP WHERE IP ='" + ip + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable Getupn(string product_codecell)
    {
        string sql = " SELECT * FROM SFCUPNINFO WHERE UPN IN(SELECT UPN FROM SFCUSN WHERE USN='" + product_codecell + "')";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable LCM(string CODEID, string MATERIAL, string product_bl)
    {
        string val12 = product_bl.Substring(11,4);//12-15
        string val18 = product_bl.Substring(18,2);//19-20
        string val32 = product_bl.Substring(32, 1);//33
        string val36 = product_bl.Substring(36, 1);//37
        string sql = "SELECT *FROM SFCBLTOLCM WHERE CODEID='" + CODEID + "'AND BLU='" + MATERIAL + "'AND BL12='" + val12 + "'AND BL19='" + val18 + "'AND BL33='" + val32 + "'AND BL37='" + val36 + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable BLU(string codeid, string product_bl)
    {
        string sql2 = "";
        string sql = " SELECT * FROM SFCBLURULELOCATION WHERE CODEID='" + codeid + "'";
        DataTable dt1 = Repository.getdatatableMES(sql);
        string CHAR_LOCATION = dt1.Rows[0]["CHAR_LOCATION"].ToString();
        if(codeid=="F57")
        {
            string val37 ="1";//第37位 
            string val48 = "1";//第48位 
            string val50 = "1";//第50位 
            string val58 = "3";//第58位 
            string val666 = product_bl.Substring(36, 1) + "," + product_bl.Substring(47, 1) + "," + product_bl.Substring(49, 1) + "," + product_bl.Substring(57, 3);//第37位
            sql2 = "SELECT * FROM SFCBLUVALUETOMATERIAL WHERE CODEID='" + codeid + "'AND CHAR_VALUE='" + val666 + "'";
        }
        DataTable dt = Repository.getdatatableMES(sql2);
        return dt;
    }
    public static DataTable Getmater(string product_codecell)
    {
        string sql = "SELECT DISTINCT MATERIAL FROM SFCBLUVALUETOMATERIAL WHERE CODEID IN(  SELECT CODEID FROM SFCUPNINFO WHERE UPN IN(SELECT UPN FROM SFCUSN WHERE USN = '" + product_codecell + "'))";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetDanPr(string code26, string codeid, string code16, string code32)
    {
        string sql = "";
        if (code26 == "A")
        {
            sql = "SELECT PRODUCT_ID FROM SD_BASE_R29RULE WHERE CODE_ID = '" + codeid + "' AND CODE_26='" + code26 + "'";
        }
        else
        {
            sql = "SELECT PRODUCT_ID FROM SD_BASE_R29RULE WHERE CODE_ID = '" + codeid + "' AND CODE_16='" + code16 + "' AND CODE_26='" + code26 + "' AND CODE_32='" + code32 + "'";
        }
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetR29Model(string code21_23, string code)
    {
        string sql = "SELECT DISTINCT TYPE FROM SD_BASE_R29MODEL WHERE BL_MODEL='" + code21_23 + "' AND MO_TYPE = '" + code + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    #endregion
    #region J04

    public static DataTable CheckBrwNgMsg(string lotno, string usn)
    {
        string sqlinserttmp = "SELECT * FROM BRWNGMSG WHERE LOTNO='" + lotno + "' AND USN='" + usn + "'";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;
    }

    public static DataTable GetZpProcess(string codeid, string ProcessName)
    {
        string sqlinserttmp = "select * from BRWZPROCESS where codeid='" + codeid + "' and processname ='" + ProcessName + "' and workPage = 'J03' order by seq desc";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;
    }

    public static bool GetRejectIdTmp(string Mo, string Usn, string LotNo, string Upn, string HalfPartId, string StatusType, string StoreLoc, string User, string Ip, string StepFrom, string StepmFrom, string DeffectCode, string RealType)
    {
        try
        {
            string sqlrejectedidtmp = @"INSERT INTO BRWREJECTEDTMP(MO,USN,LOTNO,UPN,HALFPARTID,STATUS,LOC,CREATEUSER,IP,STEPFROM,STEPMFROM,DEFFECTCODE,REALTYPE,GROUPID,REPAIRTYPE,SNTYPE,CREATEDATE) values
                        ('" + Mo + "','" + Usn + "','" + LotNo + "','" + Upn + "','" + HalfPartId + "','" + StatusType + "','" + StoreLoc + "','" + User + "','" + Ip + "','" + StepFrom + "','" + StepmFrom + "','" + DeffectCode + "','" + RealType + "','','','',SYSDATE)";
            Repository.getdatatablenoreturnMES(sqlrejectedidtmp);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static string GetBaseRepairType(string Page, string description = null)
    {
        string Result = "";
        if (Page.Trim().Length == 0)
        {
            Result = JsonConvert.SerializeObject("退庫類型不可為空");
            return Result;
        }
        string sqlstring = "SELECT * FROM BRWBASETYPE WHERE WORKPAGE='" + Page + "'";
        if (description != null)
        {
            sqlstring = sqlstring + " AND DESCRIPTIONID='" + description + "'";
        }

        DataTable dtrjtype = Repository.getdatatableMES(sqlstring);
        Result = JsonConvert.SerializeObject(dtrjtype);
        return Result;
    }
    public static DataTable GetRejectedDate()
    {
        string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
        DataTable dtdata = Repository.getdatatableMES(sqldate);
        return dtdata;
    }
    public static DataTable GetRejectedSEQENCE()
    {
        string sqlcheck = "select lpad(REJECT_SEQENCE.nextval,4,'0') from dual";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        return dtcheck;
    }
    public static DataTable GetCheckRejectedMain(string RejectedId)
    {
        string sqlcheck = "select * from brwrejectedmain where rejectedid='" + RejectedId + "'";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        return dtcheck;
    }
    public static DataTable GetCheckRejected(string RejectedId, string Usn, string Mo)
    {
        string rtwhere = "";
        if (RejectedId != "NA")
        {
            rtwhere = rtwhere + "and REJECTEDID='" + RejectedId + "'";
        }
        if (Usn != "NA")
        {
            rtwhere = rtwhere + "and USN='" + Usn + "'";
        }
        if (Mo != "NA")
        {
            rtwhere = rtwhere + "and Mo='" + Mo + "'";
        }
        string sqlcheck = "SELECT * FROM BRWREJECTED WHERE 1=1 AND ISDELETE = 'N' " + rtwhere;
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        return dtcheck;
    }
    public static bool GetRejectId(string Ip, string User, string RejctedId)
    {
        try
        {
            string sqlrejectedid = @"INSERT INTO BRWREJECTED (REJECTEDID,USN,MO,STATUS,DEFFECTCODE,STEPFROM,CREATEUSER,CREATEDATE,ISDELETE) 
                            SELECT '" + RejctedId + "',USN,MO,STATUS,DEFFECTCODE,STEPFROM,'" + User + "',sysdate,'N' FROM BRWREJECTEDTMP WHERE IP='" + Ip + "'";
            Repository.getdatatablenoreturnMES(sqlrejectedid);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static bool GetRejectMain(string Ip, string User, string RejctedId, string FalfPartId, string StoreLoc, string realtype)
    {
        try
        {
            string sqlrejectedmain = @"INSERT INTO BRWREJECTEDMAIN (REJECTEDID,HALFPARTID,LOC,CREATEUSER,CREATEDATE,REALTYPE,CODETYPE,REPAIRTYPE,SNTYPE,WORKPAGE) 
        values ('" + RejctedId + "','" + FalfPartId + "','" + StoreLoc + "','" + User + "',sysdate,'" + realtype + "','CODETYPE','REPAIRTYPE','SNTYPE','J04')";
            Repository.getdatatablenoreturnMES(sqlrejectedmain);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static bool UpdateBrwUsnInfo(string Mo, string Usn)
    {
        try
        {
            string sqlrejectedmain = @"UPDATE BRWUSNINFO SET BRWFLAG='Y' WHERE BRWFLAG ='N' AND MO='" + Mo + "' AND USN='" + Usn + "'";
            Repository.getdatatablenoreturnMES(sqlrejectedmain);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static string GetRepairTypeByPage(string Page)
    {
        string sqlrepairtype = "SELECT DISTINCT REPAIRTYPE FROM BRWTYPE WHERE PAGE ='" + Page + "'";
        DataTable dtrepairtype = Repository.getdatatableMES(sqlrepairtype);
        string rtn = JsonConvert.SerializeObject(dtrepairtype);
        return rtn;
    }
    public static string GetRJTypeByPage(string Page)
    {
        string sqlrepairtype = "SELECT DISTINCT DESCRIPTIONNAME FROM BRWDESCRIPTION WHERE PAGE ='" + Page + "'";
        DataTable dtrepairtype = Repository.getdatatableMES(sqlrepairtype);
        string rtn = JsonConvert.SerializeObject(dtrepairtype);
        return rtn;
    }
    public static string GetStatusType()
    {
        string sqlrepairtype = "SELECT * FROM BRWSTATUS ORDER BY STATUSID";
        DataTable dtrepairtype = Repository.getdatatableMES(sqlrepairtype);
        string rtn = JsonConvert.SerializeObject(dtrepairtype);
        return rtn;
    }
    public static DataTable GetRepairTmpInfo(string Ip, string UserId, string Usn)
    {
        if (Usn == "NA")
        {
            string sqlinserttmp = "SELECT * FROM BRWREJECTEDTMP WHERE IP='" + Ip + "' AND CREATEUSER='" + UserId + "' ORDER BY CREATEDATE DESC";
            DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
            return dtinserttmp;
        }
        else
        {
            string sqlinserttmp = "SELECT * FROM BRWREJECTEDTMP WHERE USN='" + Usn + "'";
            DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
            return dtinserttmp;
        }

    }

    public static DataTable CheckReasonCode(string Ip, string UserId, string ReasonCode)
    {
        string sqlcheck = "SELECT * FROM BRWREJECTEDTMP WHERE IP='" + Ip + "' AND CREATEUSER='" + UserId + "' AND  DEFFECTCODE<>'" + ReasonCode + "'";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        return dtcheck;
    }

    //查詢是否在Q18復判
    public static DataTable GetDouCheckBySn(string Usn)
    {
        string sql_fp = @"SELECT * FROM BRWFUPAN WHERE USN ='" + Usn + "'";
        DataTable dt_fp = Repository.getdatatableMES(sql_fp);
        return dt_fp;
    }
    //刪除臨時表
    public static bool DeleteRepairTmpByUsn(string Usn, string Ip, string User)
    {
        try
        {
            if (Usn == "NA")
            {
                string sql = @"DELETE FROM BRWREJECTEDTMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "'";
                Repository.getdatatablenoreturnMES(sql);
                return true;
            }
            else
            {
                string sql = @"DELETE FROM BRWREJECTEDTMP WHERE USN ='" + Usn + "' AND CREATEUSER='" + User + "' AND IP='" + Ip + "'";
                Repository.getdatatablenoreturnMES(sql);
                return true;
            }
        }
        catch (Exception ex)
        {
            return false;
        }

    }
    public static DataTable GetCheckLockType(string IP)
    {
        string sqlmmk1 = "select is_lock from LOCK_TYPE where is_lock='Y' and  type_name='BRWTOMA' and lot_id='" + IP + "'";
        DataTable dtmmk1 = Repository.getdatatableMES(sqlmmk1);
        return dtmmk1;
    }
    public static bool GetDeleteLockType(string IP)
    {
        try
        {
            string sql = "delete from LOCK_TYPE where lot_id='" + IP + "'AND TYPE_NAME='BRWTOMA'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static DataTable GetBRWUsnInfo(string Usn, string Mo)
    {
        string sqlBrwinfo = "SELECT * FROM BRWUSNINFO WHERE USN='" + Usn + "' AND MO ='" + Mo + "' AND BRWFLAG='N' ORDER BY CREATEDATE DESC";
        DataTable dtBrwinfo = Repository.getdatatableMES(sqlBrwinfo);
        return dtBrwinfo;
    }
    public static DataTable GetBRWUsnNG(string Usn, string Mo)
    {
        string oldng = "";
        if (Fab == "Fab1/2")
        {
            oldng = "select product_codecell usn,reason_code defectcode,reason_relinecode newdefectcode,step_from stepfrom from sd_op_brwinfo where order_no ='" + Mo + "' and product_codecell='" + Usn + "'";
        }
        else if (Fab == "Fab3")
        {
            oldng = "SELECT usn,errorcode defectcode,raerrorcode newdefectcode,smallstage stepfrom FROM sfcusndefect where mo='" + Mo + "' and usn ='" + Usn + "'";
        }
        DataTable dtoldng = Repository.getdatatableMES(oldng);
        return dtoldng;
    }
    public static DataTable GetBRWUsnInfo1(string Usn)
    {
        string sqlBrwinfo = "SELECT * FROM BRWUSNINFO WHERE USN='" + Usn + "' AND BRWFLAG='N' ORDER BY CREATEDATE DESC";
        DataTable dtBrwinfo = Repository.getdatatableMES(sqlBrwinfo);
        return dtBrwinfo;
    }
    #endregion
    #region X02

    public static DataTable GetLotUsn(string Usn, string LotNo)
    {
        string sqlUsn = "select * from brwlotdetail where usn ='" + Usn + "' and lotno ='" + LotNo + "' and flag ='Y'";
        DataTable dtUsn = Repository.getdatatableMES(sqlUsn);
        return dtUsn;
    }

    public static DataTable GetUsn(string Usn)
    {
        string sqlUsn = "select * from brwlotdetail where usn ='" + Usn + "' and flag ='Y'";
        DataTable dtUsn = Repository.getdatatableMES(sqlUsn);
        return dtUsn;
    }

    public static DataTable GetNum(string Lot, string User, string Ip)
    {
        string sqlNum = "SELECT count(*) count FROM BRWNGMSGTMP WHERE  LOTNO='" + Lot + "' AND CREATEUSER = '" + User + "' AND IP='" + Ip + "'";
        DataTable dtNum = Repository.getdatatableMES(sqlNum);
        return dtNum;
    }

    public static string DeleteTmpBrwNgMsg(string Usn)
    {
        string sql = @"DELETE FROM BRWNGMSGTMP WHERE USN ='" + Usn + "'";
        Repository.getdatatablenoreturnMES(sql);
        return JsonConvert.SerializeObject("success");
    }
    public static string GetBrwNgCode(string Page)
    {
        string ngSql = "SELECT DEFFECTCODE CODE_ID,DEFFECTCODE||':'||CODENAME CODE_NAME FROM BRWDEFFECTCODE WHERE PAGE='" + Page + "' ORDER BY CODE_ID";
        DataTable dtcode = Repository.getdatatableMES(ngSql);
        string rtn = JsonConvert.SerializeObject(dtcode);
        return rtn;
    }

    public static DataTable GetBrwStepmId(string StepId, string CodeId, string Page)
    {
        string ngSql = "select stepid STEPID from brwzprocess where processname ='" + StepId + "' and codeid='" + CodeId + "' and workpage='" + Page + "' ORDER BY seq";
        DataTable dtcode = Repository.getdatatableMES(ngSql);
        //string rtn = JsonConvert.SerializeObject(dtcode);
        return dtcode;
    }


    public static DataTable GetBrwTmpNg(string Lot, string User, string Ip, string Usn, string StepmId)
    {
        string rtwhere = "";
        if (Lot != "NA")
        {
            rtwhere = rtwhere + "and LOTNO='" + Lot + "'";
        }
        if (User != "NA")
        {
            rtwhere = rtwhere + "and CREATEUSER='" + User + "'";
        }
        if (Ip != "NA")
        {
            rtwhere = rtwhere + "and IP='" + Ip + "'";
        }
        if (Usn != "NA")
        {
            rtwhere = rtwhere + "and USN='" + Usn + "'";
        }
        if (StepmId != "NA")
        {
            rtwhere = rtwhere + "and STEPMID='" + StepmId + "'";
        }
        string sql = "SELECT * FROM BRWNGMSGTMP WHERE 1=1 " + rtwhere + " ORDER BY CREATEDATE DESC";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetRuncard(string Lot)
    {
        string checkMlot = "SELECT MAX(B.ITEM) MAXITEM  FROM SD_OP_BRWRUNCARD A, SD_BASE_ZPROCESS B WHERE A.LOT_ID='" + Lot + "' AND A.PROCESS_NAME=B.BRWPROJECT";
        DataTable dtChecMlot = Repository.getdatatableMES(checkMlot);
        return dtChecMlot;
    }
    public static DataTable GetLotProcess(string Lot)
    {
        string blotProcess = "SELECT * FROM  SD_OP_LOTPROCESS WHERE B_LOT='" + Lot + "' order by PROCESS_ID desc";
        DataTable dtPeocess = Repository.getdatatableMES(blotProcess);
        return dtPeocess;
    }
    public static DataTable GetReceive(string Lot)
    {
        string sqlz = "SELECT A.LOT_ID,A.PRODUCT_ID,A.LOT_QTY,B.ORDER_NO,B.DUE_DATE,TO_CHAR(CREATE_DATE,'yyyyMMdd') CREATE_DATE,A.IS_OFFLINE FROM SD_OP_BRWRUNCARD A,SD_OP_WORKORDER B WHERE A.ORDER_NO=B.ORDER_NO AND A.LOT_ID='" + Lot + "'";
        DataTable dtz = Repository.getdatatableMES(sqlz);
        return dtz;
    }
    public static DataTable GetReceiveFlag(string Lot)
    {
        string sql2 = "SELECT * FROM BRWLOT WHERE LOTNO='" + Lot + "' AND RECEIVEFLAG='Y'";
        DataTable dt2 = Repository.getdatatableMES(sql2);
        return dt2;
    }

    public static DataTable GetNGPass(string Lot, string step_current)
    {
        string sqlHH = "SELECT * FROM BRWLOTOPERMSG WHERE LOTNO='" + Lot + "' AND STEPID='" + step_current + "'AND ISPCS='N'";
        DataTable dtsqlHH = Repository.getdatatableMES(sqlHH);
        return dtsqlHH;
    }

    public static string GetLotImformation(string step_current, string lotqty, string type, string order_no, string duedate, string productid, string codejb, string gotodo, string codeid)
    {
        string sql1 = "select '" + step_current + "' STEP_CURRENT,'" + lotqty + "' LOT_QTY,'" + type + "' TYPE,'" + order_no + "' ORDER_NO,'" + duedate + "' DUE_DATE,'" + productid + "' PRODUCTID,'" + codejb + "' CODEJB,'" + gotodo + "' GOTODO,'" + codeid + "' CODEID from dual";
        DataTable dtzz = Repository.getdatatableMES(sql1);
        string rtn = JsonConvert.SerializeObject(dtzz);
        return rtn;
    }


    public static bool NgCodeINX02(string Lotno, string Usn, string Stepid, string Stepmid, string DeffectCode, string Remark, string Ip, String User, string Page)
    {
        Repository.getdatatablenoreturnMES(@"INSERT INTO brwngmsgtmp( lotno,usn,stepid,stepmid,defectcode,codename,remark,IP,createuser,createdate,workpage) 
                                     VALUES('" + Lotno + "','" + Usn + "','" + Stepid + "','" + Stepmid + "','" + DeffectCode + "','','" + Remark + "','" + Ip + "','" + User + "',sysdate,'" + Page + "')");
        return true;
    }

    public static DataTable GetpROCESS(string Lot)
    {
        string sql2 = "SELECT B.* FROM BRWLOT A,BRWZPROCESS B WHERE A.PROCESSNAME = B.PROCESSNAME AND A.LOTNO='" + Lot + "'";
        DataTable dt2 = Repository.getdatatableMES(sql2);
        return dt2;
    }

    public static DataTable GetBrwRuncard(string Lot)
    {
        string sql = "SELECT * FROM BRWLOT  WHERE LOTNO='" + Lot + "' ORDER BY CREATEDATE DESC";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static OracleConnection dbcon()
    {
        OracleConnection con = new OracleConnection();
        if (Fab == "Fab1/2")
        {
            con = new OracleConnection("server=MESDB01;user id=JOAN;password=JOAN2013");
        }
        else if (Fab == "Fab3")
        {
            con = new OracleConnection("server=MES2DB01;user id=CIMOMES;password=CIMOMES");
        }
        return con;
    }

    public static bool InserBrwLotopermsg(string LotNo, string StepId, string StepmId, int EqpId, string User, int InQty, int OutQty, string Page)
    {
        string sql1 = @"INSERT INTO BRWLOTOPERMSG(LOTNO,STEPID,STEPMID,EQPID,CREATEUSER,CREATEDATE,INQTY,OUTQTY,WORKPAGE) 
                                        values('" + LotNo + "','" + StepId + "','" + StepmId + "','" + EqpId + "','" + User + "',sysdate,'" + InQty + "','" + OutQty + "','" + Page + "')";
        Repository.getdatatablenoreturnMES(sql1);
        return true;
    }

    public static bool InserBrwLotopermsgX02(string LotNo, string StepId, string User, int InQty, int OutQty, string Page)
    {
        string sql1 = @"INSERT INTO BRWLOTOPERMSG(LOTNO,STEPID,STEPMID,EQPID,CREATEUSER,CREATEDATE,INQTY,OUTQTY,WORKPAGE) SELECT '" + LotNo + "',PROCESSNAME,STEPID,SEQ,'" + User + "',sysdate,'" + InQty + "','" + OutQty + "','" + Page + "' FROM BRWZPROCESS WHERE PROCESSNAME='" + StepId + "'";
        Repository.getdatatablenoreturnMES(sql1);
        return true;
    }


    public static string MoveOutX02(string str_Lot, int NgQty, int StepCurrentId)
    {
        string rtn = "";
        OracleConnection con = dbcon();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();
        try
        {
            OracleCommand cmd1 = new OracleCommand("INSERT INTO BRWNGMSG (LOTNO, USN, DEFECTCODE,STEPID, STEPMID,CREATEUSER,REMARK,DUTY)  SELECT LOTNO , USN, DEFECTCODE, STEPID, STEPMID,CREATEUSER,REMARK,DUTY FROM BRWNGMSGTMP WHERE LOTNO = '" + str_Lot + "' ", con);

            OracleCommand cmd2 = new OracleCommand("UPDATE BRWLOT SET LOTQTY=LOTQTY-" + NgQty + ",STEPCURRENT='OQC',STEPCURRENTID='" + StepCurrentId + "' WHERE LOTNO ='" + str_Lot + "'", con);

            OracleCommand cmd3 = new OracleCommand("UPDATE BRWLOTDETAIL SET LOTNO='NULL',FLAG='N' WHERE LOTNO ='" + str_Lot + "' AND USN IN (SELECT USN FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "')", con);

            OracleCommand cmd4 = new OracleCommand("UPDATE BRWUSNINFO A SET A.NEWDEFFECTCODE=(SELECT DISTINCT B.DEFECTCODE FROM BRWNGMSGTMP B WHERE A.USN=B.USN ) WHERE (A.USN) IN(SELECT USN FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "')", con);

            OracleCommand cmd5 = new OracleCommand("DELETE FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "'", con);

            cmd1.Transaction = ots;
            cmd2.Transaction = ots;
            cmd3.Transaction = ots;
            cmd4.Transaction = ots;
            cmd5.Transaction = ots;
            cmd1.ExecuteNonQuery();
            cmd2.ExecuteNonQuery();
            cmd3.ExecuteNonQuery();
            cmd4.ExecuteNonQuery();
            cmd5.ExecuteNonQuery();
            ots.Commit();
            con.Close();
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬成功\"}]";
        }
        catch
        {
            ots.Rollback();
            con.Close();
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬失敗\"}]";
        }
        return rtn;
    }
    #endregion
    #region R53
    public static bool DelTmpR53(string RejectedId, string User, string Ip)
    {
        string rj = "";
        if (RejectedId != "NA")
        {
            rj = "and rejected_id = '" + RejectedId + "'";
        }
        string sqlrejectedmain = @"DELETE FROM SD_TMP_STORETOBRW WHERE CREATE_USER='" + User + "'AND IP_ADDR='" + Ip + "' " + rj;
        Repository.getdatatablenoreturnMES(sqlrejectedmain);
        return true;
    }

    public static DataTable GetTmpR53(string RejectedId, string User, string Ip)
    {
        string rj = "";
        if (RejectedId != "NA")
        {
            rj = "and rejected_id = '" + RejectedId + "'";
        }
        string sqlTmp = "SELECT * FROM SD_TMP_STORETOBRW WHERE CREATE_USER='" + User + "'AND IP_ADDR='" + Ip + "'" + rj;
        DataTable dtTmp = Repository.getdatatableMES(sqlTmp);
        return dtTmp;
    }

    public static DataTable GetTmpCountR53(string User, string Ip)
    {

        string sqlCountTmp = "SELECT COUNT(DISTINCT PRODUCT_CODECELL) COUNT FROM SD_TMP_STORETOBRW WHERE  CREATE_USER='" + User + "' AND IP_ADDR='" + Ip + "'";
        DataTable dtCountTmp = Repository.getdatatableMES(sqlCountTmp);
        return dtCountTmp;
    }

    public static DataTable GetBaseUserR53(string User)
    {

        string sqlCountTmp = "SELECT DISTINCT FLAG,USER_ID FROM SD_BASE_R53USER WHERE USER_ID ='" + User + "'";
        DataTable dtCountTmp = Repository.getdatatableMES(sqlCountTmp);
        return dtCountTmp;
    }

    public static DataTable GetRejectedR53(string RejectedId)
    {

        string sqlsn = @"SELECT * FROM (
                    SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_REJECTED WHERE REJECTED_ID='" + RejectedId + @"'
                    UNION ALL
                    SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_REJECTEDM107 WHERE REJECTED_ID='" + RejectedId + @"'
                    UNION ALL
                    SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_ORTREJECTED WHERE REJECTED_ID='" + RejectedId + @"'
                    UNION ALL
                    SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_IQCREJECTED WHERE REJECTED_ID='" + RejectedId + @"'
                    )";
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }

    public static DataTable GetShowInfoR53(string User, string Ip)
    {
        string sqlsn = @"SELECT DISTINCT A.ORDER_NO,A.REJECTED_ID,B.LH_ID,COUNT(A.REJECTED_ID) COUNT,A.CREATE_USER,A.USER_ID,A.CREATE_DATE FROM SD_TMP_STORETOBRW A ,(
        SELECT REJECTED_ID,LH_ID FROM SD_OP_REJECTEDMAIN 
        UNION SELECT REJECTED_ID,STORELOC LH_ID FROM SD_OP_REJECTEDM107MAIN 
        UNION SELECT REJECTED_ID,STORELOC LH_ID FROM SD_OP_ORTREJECTEDMAIN
        UNION SELECT REJECTED_ID,STORELOC LH_ID FROM SD_OP_IQCREJECTEDMAIN
        ) B WHERE A.REJECTED_ID=B.REJECTED_ID AND A.CREATE_USER='" + User + "' AND A.IP_ADDR='" + Ip + "' GROUP BY A.ORDER_NO,A.REJECTED_ID,B.LH_ID,A.CREATE_USER,A.USER_ID,A.CREATE_DATE";
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }

    public static bool InsertTmpR53(string RejectedId, string User, string Ip, string OrderNo, string SapNo)
    {

        string sqlinserttmp = @"INSERT INTO SD_TMP_STORETOBRW(REJECTED_ID,PRODUCT_CODECELL,IP_ADDR,CREATE_USER,CREATE_DATE,ORDER_NO,USER_ID,SAP_NO) 
                        SELECT REJECTED_ID,PRODUCT_CODECELL,'" + Ip + @"','" + User + @"',SYSDATE,'" + OrderNo + "','" + User + "','" + SapNo + @"' FROM (
                        SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_REJECTED WHERE REJECTED_ID='" + RejectedId + @"'
                        UNION ALL
                        SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_REJECTEDM107 WHERE REJECTED_ID='" + RejectedId + @"'
                        UNION ALL
                        SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_ORTREJECTED WHERE REJECTED_ID='" + RejectedId + @"'
                        UNION ALL
                        SELECT REJECTED_ID,PRODUCT_CODECELL FROM SD_OP_IQCREJECTED WHERE REJECTED_ID='" + RejectedId + @"'
)";
        Repository.getdatatablenoreturnMES(sqlinserttmp);
        return true;
    }


    public static bool InsertStoreToBRWR53(string User, string Ip)
    {
        string sqlinsertstoretobrw = @"INSERT INTO SD_OP_STORETOBRW (ORDER_NO,REJECTED_ID,PRODUCT_CODECELL,CREATE_USER,CREATE_DATE,USER_ID,SAP_NO)
        SELECT DISTINCT ORDER_NO,REJECTED_ID,PRODUCT_CODECELL,CREATE_USER,SYSDATE,USER_ID,SAP_NO FROM SD_TMP_STORETOBRW WHERE CREATE_USER='" + User + "'AND IP_ADDR='" + Ip + "'";
        Repository.getdatatablenoreturnMES(sqlinsertstoretobrw);
        return true;
    }

    public static DataTable GetStoreToBRWR53(string RejectedId)
    {
        string sqlsn = "SELECT * FROM SD_OP_STORETOBRW WHERE REJECTED_ID='" + RejectedId + "'";
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }

    public static bool DeleteStoreToBRWR53(string RejectedId)
    {
        string sqldeletestoretobrw = @"delete FROM SD_OP_STORETOBRW WHERE REJECTED_ID='" + RejectedId + "'";
        Repository.getdatatablenoreturnMES(sqldeletestoretobrw);
        return true;
    }

    #endregion
    #region Q08
    public static DataTable GetCheckReceiveTmp(string RejectedId, string Usn, string User, string Ip)
    {
        string rtwhere = "";
        if (RejectedId != "NA")
        {
            rtwhere = rtwhere + "and REJECTEDID='" + RejectedId + "'";
        }
        if (Usn != "NA")
        {
            rtwhere = rtwhere + "and USN='" + Usn + "'";
        }
        if (User != "NA")
        {
            rtwhere = rtwhere + "and CREATEUSER='" + User + "'";
        }
        if (Ip != "NA")
        {
            rtwhere = rtwhere + "and IP='" + Ip + "'";
        }
        string sqlsn = "select * from IQCRECEIVETMP where 1=1" + rtwhere + " ORDER BY CREATEDATE DESC";
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }

    public static DataTable GetCheckReceivenum(string User, string Ip, string type)
    {
        string sqlnum = "";
        if (type == "REJECTED")
        {
            sqlnum = "SELECT COUNT(REJECTEDID) FROM IQCRECEIVETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "' AND USN IS NULL ORDER BY CREATEDATE DESC";
        }
        if (type == "PCS")
        {
            sqlnum = "SELECT COUNT(USN) FROM IQCRECEIVETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "'  ORDER BY CREATEDATE DESC";
        }
        DataTable dtsn = Repository.getdatatableMES(sqlnum);
        return dtsn;
    }

    public static DataTable GetCheckReceive(string User, string Ip, string type)
    {
        string sqlnum = "";
        if (type == "REJECTED")
        {
            sqlnum = @"SELECT A.REJECTEDID,B.HALFPARTID,A.QTY FROM IQCRECEIVETMP A LEFT JOIN BRWREJECTEDMAIN B ON A.REJECTEDID=B.REJECTEDID WHERE A.CREATEUSER='" + User + "' AND A.IP='" + Ip + "' AND USN IS NULL ";
        }
        if (type == "PCS")
        {
            sqlnum = @"WITH A1 AS(
                        SELECT *FROM SD_HIS_NGMSG WHERE (CREATE_DATE,PRODUCT_CODECELL)IN(
                        SELECT MAX(CREATE_DATE),PRODUCT_CODECELL FROM SD_HIS_NGMSG 
                        WHERE PRODUCT_CODECELL IN(SELECT USN FROM IQCRECEIVETMP WHERE CREATEUSER='" + User + "' and ip='" + Ip + @"') 
                        GROUP BY PRODUCT_CODECELL ))
                        SELECT A.USN,A.REJECTEDID,B.DEFFECTCODE,A1.REASON_CODE FROM IQCRECEIVETMP A,BRWREJECTED B,A1 
                        WHERE A.USN=B.USN AND A.MO=B.MO AND B.USN=A1.PRODUCT_CODECELL AND A.CREATEUSER='" + User + "' AND A.IP='" + Ip + "'";
        }
        DataTable dtsn = Repository.getdatatableMES(sqlnum);
        return dtsn;
    }

    public static DataTable GetReCheck(string RejectedId, string Usn, string type)
    {
        string sqlnum = "";
        if (type == "REJECTED")
        {
            sqlnum = @"SELECT * FROM RECHECK WHERE USN IN (SELECT USN FROM BRWREJECTED WHERE ISDELETE ='N' AND REJECTEDID='" + RejectedId + "')";
        }
        if (type == "PCS")
        {
            sqlnum = @"SELECT * FROM RECHECK WHERE USN ='" + Usn + "'";
        }
        DataTable dtsn = Repository.getdatatableMES(sqlnum);
        return dtsn;
    }


    public static bool IqcTmpInsert(string Mo, string RejectedId, string Usn, string User, string Ip, string Qty)
    {
        Repository.getdatatablenoreturnMES("INSERT INTO IQCRECEIVETMP(MO,REJECTEDID,USN,CREATEUSER,CREATEDATE,IP,QTY) VALUES('" + Mo + "','" + RejectedId + "','" + Usn + "','" + User + "',SYSDATE,'" + Ip + "','" + Qty + "')");
        return true;
    }

    public static bool IqcTmpDelete(string User, string Ip)
    {
        Repository.getdatatablenoreturnMES("DELETE IQCRECEIVETMP WHERE CREATEUSER ='" + User + "' AND IP='" + Ip + "'");
        return true;
    }
    public static bool IqcReceiveUpdate(string User, string Ip)
    {
        Repository.getdatatablenoreturnMES("UPDATE BRWREJECTEDMAIN SET IQCFLAG='Y',IQCRECEIVEUSER='" + User + "',IQCRECEIVEDATE=sysdate where REJECTEDID IN(select REJECTEDID from IQCRECEIVETMP WHERE CREATEUSER ='" + User + "' AND IP='" + Ip + "')");
        return true;
    }


    #endregion
    #region R03
    ///获取料号
    public static string GetBrwcgupn(string Page)
    {
        string rtn = "";
        string sql1 = "SELECT  DISTINCT UPN FROM BRWCGMATERIAL WHERE WORKPAGE='" + Page + "'AND FLAG='Y'";
        DataTable dtrjtype = Repository.getdatatableMES(sql1);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    //获取料号颜色，厂商
    public static DataTable getbrwcgmaterial(string UPN)
    {
        string sql2 = "SELECT COLOR,MAKER,CODEID FROM BRWCGMATERIAL WHERE UPN ='" + UPN + "'AND FLAG='Y'AND WORKPAGE='R03'";
        DataTable dtinserttmp = Repository.getdatatableMES(sql2);
        return dtinserttmp;
    }
    //插入临时表
    public static DataTable getbrwcgtemp(string REJECTEDID, string UPN, string Ip, string lh_user, string COLOR, string MAKER, string MO)
    {
        string sql2 = "INSERT INTO BRWCGTMP SELECT A.REJECTEDID,A.USN,'" + UPN + "','" + COLOR + "','" + MAKER + "',B.CODETYPE,'" + Ip + "','" + lh_user + "','" + MO + "'FROM BRWREJECTED A,BRWREJECTEDMAIN B WHERE A.REJECTEDID='" + REJECTEDID + "' AND A.REJECTEDID=B.REJECTEDID";
        DataTable dt3 = Repository.getdatatableMES(sql2);
        return dt3;
    }
    public static DataTable getbrwcgtemp1(string USN, string UPN, string Ip, string lh_user, string COLOR, string MAKER, string CODEID)
    {
        string sql2 = "INSERT INTO BRWCGTMP (USN,UPN,COLOR,MAKER,CODEID,IP,USERID)VALUES ('" + USN + "','" + UPN + "','" + COLOR + "','" + MAKER + "','" + CODEID + "','" + Ip + "','" + lh_user + "')";
        DataTable dt3 = Repository.getdatatableMES(sql2);
        return dt3;
    }
    //查询临时表
    public static DataTable getbrwcggettemp(string Ip, string lh_user)
    {
        string sql12 = "SELECT usn,UPN,COLOR,MAKER,codeid,ip,userid from BRWCGTMP where ip='" + Ip + "' and userid= '" + lh_user + "'";
        DataTable dt31 = Repository.getdatatableMES(sql12);
        return dt31;
    }
    public static DataTable getbrwcggettemp1(string Ip, string lh_user)
    {
        string sql12 = "SELECT DISTINCT COLOR from BRWCGTMP where ip='" + Ip + "' and userid= '" + lh_user + "'";
        DataTable dt31 = Repository.getdatatableMES(sql12);
        return dt31;
    }
    public static DataTable getbrwcggettemp2(string Ip, string lh_user)
    {
        string sql12 = "SELECT DISTINCT CODEID from BRWCGTMP where ip='" + Ip + "' and userid= '" + lh_user + "'";
        DataTable dt31 = Repository.getdatatableMES(sql12);
        return dt31;
    }
    public static DataTable getbrwcggettemp3(string Ip, string lh_user)
    {
        string sql12 = "SELECT DISTINCT UPN from BRWCGTMP where ip='" + Ip + "' and userid= '" + lh_user + "'";
        DataTable dt31 = Repository.getdatatableMES(sql12);
        return dt31;
    }
    public static DataTable getbrwcggettemp6(string Ip, string lh_user)
    {
        string sql12 = "SELECT DISTINCT MAKER from BRWCGTMP where ip='" + Ip + "' and userid= '" + lh_user + "'";
        DataTable dt31 = Repository.getdatatableMES(sql12);
        return dt31;
    }
    //删除一列
    public static bool getbrwcgdel(string USN)
    {
        try
        {
            string sql = "DELETE FROM BRWCGTMP WHERE USN='" + USN + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    ///清空
    public static bool getbrwcgdeltmp(string Ip, string lh_user)
    {
        try
        {
            string sql = "DELETE FROM BRWCGTMP WHERE  IP = '" + Ip + "' AND USERID ='" + lh_user + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    //生成箱号
    public static string CreateBrwcg(string Ip, string lh_user)
    {
        string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
        DataTable dtdata = Repository.getdatatableMES(sqldate);
        string backid = dtdata.Rows[0][0].ToString();
        string m = "";
        string sqlcheck = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        if (dtcheck.Rows[0][0].ToString() != "")
        {
            m = dtcheck.Rows[0][0].ToString();
        }
        backid = "G" + backid + "-" + m;
        string sqlma = "SELECT * FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + backid + "'";
        DataTable dt = Repository.getdatatableMES(sqlma);
        if (dt.Rows.Count > 0)
        {
            string sqlserial = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
            DataTable dtserial = Repository.getdatatableMES(sqlserial);
            backid = "G" + backid + "-" + dtserial.Rows[0][0].ToString();
        }

        return backid;
    }
    //获取机种
    public static string CreateBrwcgcode(string Ip, string lh_user)
    {
        string sql55 = "SELECT DISTINCT CODEID FROM BRWCGTMP WHERE Ip='" + Ip + "' AND USERID ='" + lh_user + "'";
        DataTable dtdata1 = Repository.getdatatableMES(sql55);
        string CODEID = dtdata1.Rows[0][0].ToString();
        return CODEID;
    }
    ///获取流程
    public static string CreateBrwcgroute(string CODEID, string TEST, string Fab)
    {
        string ROUTE = "";
        if (Fab == "Fab3")
        {
            string sql55 = "SELECT DISTINCT LSTAGE FROM SFCREPAIRROUTE WHERE CODEID='" + CODEID + "' AND LSTAGEDESC ='" + TEST + "'";
            DataTable dtdata1 = Repository.getdatatableMES(sql55);
            ROUTE = dtdata1.Rows[0][0].ToString();
            ROUTE = ROUTE + "PE";
        }
        if (Fab == "Fab1/2")
        {
            string sql55 = "SELECT DISTINCT LSTAGE FROM SFCREPAIRROUTE WHERE CODEID='" + CODEID + "' AND LSTAGEDESC ='" + TEST + "'";
            DataTable dtdata1 = Repository.getdatatableMES(sql55);
            ROUTE = dtdata1.Rows[0][0].ToString();
            ROUTE = ROUTE + "PE";
        }

        return ROUTE;
    }
    public static bool InsertBrwcg(string REJECTEDID, string Ip, string lh_user, string count, string Fab, string TEST, string CODEID)
    {
        if (Fab == "Fab1/2")
        {
            if (CODEID == "Melon")
            {
                if (TEST == "CGS_Reuse")
                {
                    string sqlInsert = "INSERT INTO BRWLOT (LOTNO,PROCESSNAME,STEPCURRENT,STEPCURRENTID,CREATEUSER,CREATEDATE,IP,LOTQTY,RECEIVEFLAG,STATUS)VALUES ('" + REJECTEDID + "','" + TEST + "','CGS來料檢','1','" + lh_user + "',SYSDATE,'" + Ip + "','" + count + "','Y','" + CODEID + "')";
                    Repository.getdatatablenoreturnMES(sqlInsert);
                    string sqlInsertDetail = "INSERT INTO BRWLOTDETAIL SELECT  '" + REJECTEDID + "',USN,'Y'FROM BRWCGTMP WHERE Ip='" + Ip + "' AND USERID ='" + lh_user + "'";
                    Repository.getdatatablenoreturnMES(sqlInsertDetail);
                }
                if (TEST == "CGW-CGS清潔")
                {
                    string sqlInsert = "INSERT INTO BRWLOT (LOTNO,PROCESSNAME,STEPCURRENT,STEPCURRENTID,CREATEUSER,CREATEDATE,IP,LOTQTY,RECEIVEFLAG,STATUS)VALUES ('" + REJECTEDID + "','" + TEST + "','CGW來料檢','1','" + lh_user + "',SYSDATE,'" + Ip + "','" + count + "','Y','" + CODEID + "')";
                    Repository.getdatatablenoreturnMES(sqlInsert);
                    string sqlInsertDetail = "INSERT INTO BRWLOTDETAIL SELECT  '" + REJECTEDID + "',USN,'Y'FROM BRWCGTMP WHERE Ip='" + Ip + "' AND USERID ='" + lh_user + "'";
                    Repository.getdatatablenoreturnMES(sqlInsertDetail);
                }
            }
            else
            {
                string sqlInsert = "INSERT INTO BRWLOT (LOTNO,PROCESSNAME,STEPCURRENT,STEPCURRENTID,CREATEUSER,CREATEDATE,IP,LOTQTY,RECEIVEFLAG,STATUS)VALUES ('" + REJECTEDID + "','" + TEST + "','CG來料檢','1','" + lh_user + "',SYSDATE,'" + Ip + "','" + count + "','Y','" + CODEID + "')";
                Repository.getdatatablenoreturnMES(sqlInsert);
                string sqlInsertDetail = "INSERT INTO BRWLOTDETAIL SELECT  '" + REJECTEDID + "',USN,'Y'FROM BRWCGTMP WHERE Ip='" + Ip + "' AND USERID ='" + lh_user + "'";
                Repository.getdatatablenoreturnMES(sqlInsertDetail);
            }


        }
        if (Fab == "Fab3")
        {
            string sqlInsert = "INSERT INTO BRWLOT (LOTNO,PROCESSNAME,STEPCURRENT,STEPCURRENTID,CREATEUSER,CREATEDATE,IP,LOTQTY,RECEIVEFLAG,STATUS)VALUES ('" + REJECTEDID + "','" + TEST + "','来料检','1','" + lh_user + "',SYSDATE,'" + Ip + "','" + count + "','Y','" + CODEID + "')";
            Repository.getdatatablenoreturnMES(sqlInsert);
            string sqlInsertDetail = "INSERT INTO BRWLOTDETAIL SELECT  '" + REJECTEDID + "',USN,'Y'FROM BRWCGTMP WHERE Ip='" + Ip + "' AND USERID ='" + lh_user + "'";
            Repository.getdatatablenoreturnMES(sqlInsertDetail);
        }
        return true;
    }
    ///查询机种
    public static DataTable GetReworkTmpInfonewcodeid1(string USN)
    {
        string sqlinserttmpcodeid = "SELECT CODEID FROM BRWCGUSN  WHERE CGUSN='" + USN + "'";
        //string sqlinserttmpcodeid = "SELECT CODEID FROM SFCUPNINFO WHERE UPN IN(SELECT DISTINCT UPN FROM SFCCARTON WHERE CARTONID='" + product + "' )";
        DataTable dtinserttmpcodeid = Repository.getdatatableMES(sqlinserttmpcodeid);
        return dtinserttmpcodeid;

    }
    //箱号是否刷过
    public static DataTable GetBrwBycgOrReject(string REJECTEDID, string Usn)
    {
        string sql6 = "SELECT * FROM BRWCGTMP WHERE  USN='" + Usn + "'";
        DataTable dtss3 = Repository.getdatatableMES(sql6);
        return dtss3;
    }

    //临时表工单
    public static DataTable GetReworkTmpcgmo(string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        string sqlinserttmp = "SELECT DISTINCT MO FROM BRWCGTMP WHERE IP='" + Ip + "'AND USERID ='" + lh_user + "'";

        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    public static DataTable GetUPNCODE(string UPN, string Fab)
    {
        string sql3 = "";
        if (Fab == "Fab3")
        {
            sql3 = "SELECT CODEID FROM BRWCGMATERIAL WHERE UPN= '" + UPN + "' ";
        }
        if (Fab == "Fab1/2")
        {
            sql3 = "SELECT CODEID FROM BRWCGMATERIAL WHERE UPN= '" + UPN + "'";
        }
        DataTable dtss = Repository.getdatatableMES(sql3);
        return dtss;
    }
    #endregion
    #region R05
    //生成批号
    public static string CreateBrwLot(string lh_user)
    {
        //string rtn = "";
        string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
        DataTable dtdata = Repository.getdatatableMES(sqldate);
        string backid = dtdata.Rows[0][0].ToString();
        string m = "";
        string sqlcheck = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        if (dtcheck.Rows[0][0].ToString() != "")
        {
            m = dtcheck.Rows[0][0].ToString();
        }
        backid = "M" + backid + "-" + m;
        string sqlma = "SELECT * FROM BRWLOT WHERE LOTNO='" + backid + "'";
        DataTable dt = Repository.getdatatableMES(sqlma);
        if (dt.Rows.Count > 0)
        {
            string sqlserial = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
            DataTable dtserial = Repository.getdatatableMES(sqlserial);
            backid = "M" + backid + "-" + dtserial.Rows[0][0].ToString();
        }

        return backid;
    }
    //插入表中
    public static bool InsertBrwLot(string LotNo, string PROCESSNAME, string lh_user, string Ip, string Fab)
    {
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "INSERT INTO BRWLOT SELECT '" + LotNo + "',MO,'" + PROCESSNAME + "',STEPCURRENT,'1','" + lh_user + "',SYSDATE,'" + Ip + "',COUNT(USN),'Y','','' FROM BRWREWORKTMP WHERE USERID='" + lh_user + "' AND IP='" + Ip + "' GROUP BY MO,STEPCURRENT";
        }
        if (Fab == "Fab3")
        {
            strSQL = "INSERT INTO BRWLOT SELECT '" + LotNo + "',MO,'" + PROCESSNAME + "',STEPCURRENT,'1','" + lh_user + "',SYSDATE,'" + Ip + "',COUNT(USN),'Y','','' FROM BRWREWORKTMP WHERE USERID='" + lh_user + "' AND IP='" + Ip + "' GROUP BY MO,STEPCURRENT";
        }
        Repository.getdatatablenoreturnMES(strSQL);
        string sqlInsertDetail = "INSERT INTO BRWLOTDETAIL SELECT  '" + LotNo + "',USN,'Y' FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID ='" + lh_user + "'";
        Repository.getdatatablenoreturnMES(sqlInsertDetail);
        return true;
    }
    public static string getbrw1(string Ip, string lh_user)
    {
        string rtn = "";
        string sql1 = "SELECT * FROM BRWREJECTEDMAIN WHERE REJECTEDID IN(SELECT REJECTEDID FROM BRWREWORKTMP  WHERE IP = '" + Ip + "' AND USERID ='" + lh_user + "')";
        DataTable dtcheck = Repository.getdatatableMES(sql1);
        if (dtcheck.Rows.Count > 0)
        {
            string sql = "UPDATE BRWREJECTED SET ISDELETE ='Y' WHERE REJECTEDID IN(SELECT DISTINCT REJECTEDID FROM BRWREJECTEDMAIN WHERE REJECTEDID IN(SELECT REJECTEDID FROM BRWREWORKTMP  WHERE IP = '" + Ip + "' AND USERID ='" + lh_user + "'))";
            DataTable dt = Repository.getdatatableMES(sql);
        }
        return rtn;

    }
    //箱号是否存在
    public static DataTable GetReject(string Usn, string Fab)
    {
        string sql3 = "";
        if (Fab == "Fab3")
        {
            sql3 = "SELECT CGUSN FROM BRWCGUSN WHERE CGUSN= '" + Usn + "' UNION  ALL SELECT USN AS CGUSN FROM SFCSINGLECARTON WHERE USN='" + Usn + "'";
        }
        if (Fab == "Fab1/2")
        {
            sql3 = "SELECT CGUSN FROM BRWCGUSN WHERE CGUSN= '" + Usn + "' UNION  ALL SELECT 'X'AS CGUSN FROM DUAL";

        }
        DataTable dtss = Repository.getdatatableMES(sql3);
        return dtss;
    }
    //箱号是否刷过
    public static DataTable GetBrwTmpBySnOrReject(string RejectedId, string Usn)
    {
        string sql6 = "SELECT * FROM BRWREWORKTMP WHERE REJECTEDID='" + RejectedId + "' OR USN='" + Usn + "'";
        DataTable dtss3 = Repository.getdatatableMES(sql6);
        return dtss3;
    }
    public static string getprocessname(string CODEID, string glasstype, string errorcode, string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT DISTINCT   PROCESSNAME FROM BRWZPROCESS WHERE CODEID LIKE'%" + CODEID + "%' AND  PRODUCTSTATUS='成品'AND GLASSTYPE='" + glasstype + "'AND DEFFECTCODE LIKE '%" + errorcode + "%'AND ISDELETE ='N'";
        }
        if (Fab == "Fab3")
        {
            strSQL = "select DISTINCT  PROCESSNAME   from BRWZPROCESS where CODEID='" + CODEID + "'AND PRODUCTSTATUS='MP7.2'";
        }
        DataTable dt = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }
    public static string insertusninfo(string lh_user, string Ip, string LOTNO,string type)
    {
        ////成功刷入临时表
        string rtn = "";
        string sql = "INSERT INTO BRWUSNINFO SELECT DISTINCT MO,UPN,USN,'', '" + LOTNO + "', '" + lh_user + "',SYSDATE,'N','','','N',STEPCURRENT,STEPCURRENT,ERRORCODE,'','','','" + type + "',''FROM BRWREWORKTMP WHERE USERID='" + lh_user + "' AND IP='" + Ip + "' ";
        DataTable dt = Repository.getdatatableMES(sql);
        return rtn;
    }
    public static string insert(string product, string lh_user, string ip, string NEWUPN, string MO, string CODEID, string Fab, string errorcode, string glasstype, string stage)
    {

        ////成功刷入临时表
        string rtn = "";
        if (Fab == "Fab3")
        {
            string sql = "INSERT INTO BRWREWORKTMP (REJECTEDID,UPN,USN,USERID,IP,CODEID,MO,STEPCURRENT,ERRORCODE )SELECT  REJECTEDID,'" + NEWUPN + "', USN,'" + lh_user + "','" + ip + "','" + CODEID + "','" + MO + "','" + stage + "',DEFFECTCODE  FROM BRWREJECTED  WHERE REJECTEDID ='" + product + "' ";
            DataTable dt = Repository.getdatatableMES(sql);

        }
        if (Fab == "Fab1/2")
        {
            string sql2 = "INSERT INTO BRWREWORKTMP (REJECTEDID,UPN,USN,USERID,IP,CODEID,MO,STEPCURRENT,ERRORCODE )SELECT  REJECTEDID,'" + NEWUPN + "', USN,'" + lh_user + "','" + ip + "','" + CODEID + "','" + MO + "','" + stage + "',DEFFECTCODE  FROM BRWREJECTED  WHERE REJECTEDID ='" + product + "' ";
            DataTable dt2 = Repository.getdatatableMES(sql2);
            string sql3 = "INSERT INTO BRWREWORKTMP (REJECTEDID,UPN,USN,USERID,IP,CODEID,MO,STEPCURRENT,ERRORCODE )SELECT  REJECTED_ID,'" + NEWUPN + "', PRODUCT_CODECELL,'" + lh_user + "','" + ip + "','" + CODEID + "','" + MO + "','" + stage + "',REMARK_CODE  FROM SD_OP_REJECTED  WHERE REJECTED_ID ='" + product + "' ";
            DataTable dt3 = Repository.getdatatableMES(sql3);
        }
        return rtn;
    }
    //查询临时表
    public static DataTable GetReworkTmpInfo(string Ip, string lh_user)
    {

        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlinserttmp = "SELECT REJECTEDID,UPN,USN,USERID,CODEID,MO,STEPCURRENT FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID ='" + lh_user + "'";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    public static DataTable Gettempcount(string lh_user, string Ip)
    {

        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlinserttmp = "select * FROM BRWREWORKTMP WHERE USERID='" + lh_user + "' AND IP ='" + Ip + "'";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    //临时表料号
    public static DataTable GetReworkTmpInfoupn(string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        string sqlinserttmp = "SELECT DISTINCT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "'AND USERID ='" + lh_user + "'";

        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    ///临时表机种
    public static DataTable GetReworkTmpInfonewcodeid1(string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        string sqlinserttmp = "SELECT DISTINCT CODEID FROM BRWREWORKTMP WHERE IP='" + Ip + "'AND USERID ='" + lh_user + "'";

        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    ///查询半品料号
    public static DataTable GetReworkTmpInfonewupn(string product, string Fab)
    {
        string sqlinserttmp1 = "";
        if (Fab == "Fab3")
        {
            sqlinserttmp1 = "SELECT HALFPARTID FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "' UNION ALL SELECT SEMIUPN AS HALFPARTID FROM SFCCARTON WHERE CARTONID ='" + product + "'";
        }
        if (Fab == "Fab1/2")
        {
            sqlinserttmp1 = "SELECT HALFPARTID FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "' UNION ALL SELECT  LH_ID AS HALFPARTID FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID='" + product + "'";
        }
        DataTable dtinserttmp1 = Repository.getdatatableMES(sqlinserttmp1);
        return dtinserttmp1;

    }
    public static DataTable GetReject1(string product, string Fab)
    {
        string sqlinserttmp1 = "";
        if (Fab == "Fab3")
        {
            sqlinserttmp1 = "SELECT REJECTEDID FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "'UNION ALL SELECT CARTONID AS REJECTEDID FROM SFCCARTON WHERE CARTONID= '" + product + "'";
        }
        if (Fab == "Fab1/2")
        {
            sqlinserttmp1 = "SELECT REJECTEDID FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "'UNION ALL SELECT REJECTED_ID AS REJECTEDID FROM SD_OP_REJECTED WHERE REJECTED_ID='" + product + "'";
        }
        DataTable dtinserttmp1 = Repository.getdatatableMES(sqlinserttmp1);
        return dtinserttmp1;

    }
    public static DataTable GetREJEY(string product)
    {

        string sqlinserttmp1 = "SELECT DISTINCT ISDELETE FROM BRWREJECTED WHERE REJECTEDID='" + product + "'";

        DataTable dtinserttmp1 = Repository.getdatatableMES(sqlinserttmp1);
        return dtinserttmp1;

    }
    public static DataTable GetReworkTmpInfonewmo1(string product)
    {
        //string sqlinserttmp1 = "SELECT UPN FROM BRWREJECTED WHERE REJECTEDID='" + product + "' ";
        string sqlinserttmp1 = "SELECT MO FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "' ";
        DataTable dtinserttmp1 = Repository.getdatatableMES(sqlinserttmp1);
        return dtinserttmp1;

    }
    ///查询工单
    public static DataTable GetReworkTmpInfonewmo(string NEWUPN, string Fab)
    {
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = " SELECT ORDER_NO AS MO FROM SD_OP_WORKORDER WHERE PRODUCT_ID='" + NEWUPN + "'AND ORDER_NO LIKE'MP%'ORDER BY ORDER_NO";
        }
        if (Fab == "Fab3")
        {
            //strSQL = " SELECT MO FROM SFCMO WHERE UPN='" + NEWUPN + "'AND MO LIKE'MP%'ORDER BY MO ";
            strSQL = " SELECT MO FROM SFCMO WHERE MO LIKE'MP%'ORDER BY MO ";
        }
        //string sqlinserttmperrorcode = "SELECT CODETYPE FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "'";
        //string sqlinserttmpcodeid = "SELECT CODEID FROM SFCUPNINFO WHERE UPN IN(SELECT DISTINCT UPN FROM SFCCARTON WHERE CARTONID='" + product + "' )";
        DataTable dtinserttmpmo = Repository.getdatatableMES(strSQL);
        return dtinserttmpmo;

    }
    ///查询机种
    public static DataTable GetReworkTmpInfonewcodeid(string product, string Fab)
    {
        string sqlinserttmpcodeid = "";
        if (Fab == "Fab3")
        {
            sqlinserttmpcodeid = "SELECT CODETYPE FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "' UNION ALL  SELECT CODEID AS CODETYPE FROM SFCUPNINFO WHERE UPN IN(SELECT SEMIUPN FROM SFCCARTON WHERE CARTONID='" + product + "')";
        }
        if (Fab == "Fab1/2")
        {
            sqlinserttmpcodeid = "SELECT CODETYPE FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "' UNION ALL  SELECT MO_TYPE AS CODETYPE FROM sd_op_workorder WHERE PRODUCT_ID IN( SELECT LH_ID FROM SD_OP_REJECTEDMAIN WHERE REJECTED_ID='" + product + "')";

        }
        DataTable dtinserttmpcodeid = Repository.getdatatableMES(sqlinserttmpcodeid);
        return dtinserttmpcodeid;

    }
    ///查询不良代码
    public static DataTable GetReworkTmpInfonewerrorcode(string product, string Fab)
    {
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = " SELECT DISTINCT REMARK_CODE FROM SD_OP_REJECTED WHERE  REJECTED_ID='" + product + "'";
        }
        if (Fab == "Fab3")
        {
            strSQL = " SELECT * FROM DUAL  ";
        }
        //string sqlinserttmperrorcode = "SELECT CODETYPE FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + product + "'";
        //string sqlinserttmpcodeid = "SELECT CODEID FROM SFCUPNINFO WHERE UPN IN(SELECT DISTINCT UPN FROM SFCCARTON WHERE CARTONID='" + product + "' )";
        DataTable dtinserttmperrorcode = Repository.getdatatableMES(strSQL);
        return dtinserttmperrorcode;

    }
    //删除一列
    public static bool DeleteReworkTmpBySn(string Usn)
    {
        try
        {
            string sql = "DELETE FROM BRWREWORKTMP WHERE  USN = '" + Usn + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }

    //删除临时表 
    public static bool Delete(string Ip, string lh_user)
    {
        try
        {
            //string sql = "DELETE FROM BRWREWORKTMP WHERE  IP = '" + Ip + "' ";
            string sql = "DELETE FROM BRWREWORKTMP WHERE  IP = '" + Ip + "' AND USERID ='" + lh_user + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    #endregion
    #region R02

    ////箱号状态
    public static DataTable GetReworkstatus(string REJECTED, string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlstatus = "SELECT DISTINCT STATUS FROM BRWREJECTED WHERE REJECTEDID= '" + REJECTED + "'";
        DataTable dtstatus = Repository.getdatatableMES(sqlstatus);
        return dtstatus;
    }
    //主箱号数量
    public static DataTable GetReworkcount(string REJECTED, string Ip, string lh_user)
    {

        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlcount = "SELECT * FROM BRWREJECTED WHERE REJECTEDID= '" + REJECTED + "'";
        DataTable dtcount = Repository.getdatatableMES(sqlcount);
        return dtcount;

    }
    ////成功刷入临时表
    public static string brwinsert(string REJECTED, string lh_user, string ip, string NEWUPN, string CODEID, string Fab, string MO, string CPADH)
    {
        string rtn = "";
        string sql = "INSERT INTO BRWREJECTTMP SELECT  '" + REJECTED + "','" + NEWUPN + "',USN,'" + ip + "','" + lh_user + "'，'" + CODEID + "','" + MO + "' ,'" + CPADH + "' FROM BRWREJECTED WHERE REJECTEDID = '" + REJECTED + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return rtn;
    }
    //查询临时表
    public static DataTable GetReworkTmprejectInfo(string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlinserttmp = "SELECT REJECTEDID,USN,UPN ,USERID,CODEID,MO,CPADH  FROM BRWREJECTTMP WHERE IP='" + Ip + "' AND USERID ='" + lh_user + "'";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;
    }
    //查询副箱号表
    public static DataTable GetReworkTmprejectcarton(string REJECTED1, string Ip, string lh_user)
    {

        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlinserttmp = "SELECT DISTINCT REJECTEDID FROM BRWREJECTEDMAIN WHERE REJECTEDID= '" + REJECTED1 + "'";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;
    }
    //删除临时表 
    public static bool Deletereje(string Ip, string lh_user)
    {
        try
        {
            //string sql = "DELETE FROM BRWREWORKTMP WHERE  IP = '" + Ip + "' ";
            string sql = "DELETE FROM BRWREJECTTMP WHERE  IP = '" + Ip + "' AND USERID ='" + lh_user + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    //删除一列
    public static bool btn_delPro(string REJECTEDID)
    {
        try
        {
            string sql = "DELETE FROM BRWREJECTTMP WHERE  REJECTEDID = '" + REJECTEDID + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }
    //临时表料号
    public static DataTable GetReworkTmprejectupn(string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        string sqlinserttmp = "SELECT DISTINCT UPN FROM BRWREJECTTMP WHERE IP='" + Ip + "'AND USERID ='" + lh_user + "'";

        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    //临时表工单
    public static DataTable GetReworkTmprejectmo(string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        string sqlinserttmp = "SELECT DISTINCT MO FROM BRWREJECTTMP WHERE IP='" + Ip + "'AND USERID ='" + lh_user + "'";

        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    //临时表待料状态
    public static DataTable GetReworkTmprejectcpadh(string Ip, string lh_user)
    {
        //string sqlinserttmp = "SELECT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        string sqlinserttmp = "SELECT DISTINCT CPADH FROM BRWREJECTTMP WHERE IP='" + Ip + "'AND USERID ='" + lh_user + "'";

        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    //生成箱号
    public static string CreateBrwreject(string Ip, string lh_user)
    {
        string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
        DataTable dtdata = Repository.getdatatableMES(sqldate);
        string backid = dtdata.Rows[0][0].ToString();
        string m = "";
        string sqlcheck = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        if (dtcheck.Rows[0][0].ToString() != "")
        {
            m = dtcheck.Rows[0][0].ToString();
        }
        backid = "3" + backid + m;
        string sqlma = "SELECT * FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + backid + "'";
        DataTable dt = Repository.getdatatableMES(sqlma);
        if (dt.Rows.Count > 0)
        {
            string sqlserial = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
            DataTable dtserial = Repository.getdatatableMES(sqlserial);
            backid = "3" + backid + "-" + dtserial.Rows[0][0].ToString();
        }

        return backid;
    }
    //插入箱号
    public static bool InsertBrwreject(string REJECTEDID, string lh_user, string Ip)
    {
        try
        {
            string sqlInsert = "INSERT INTO BRWREJECTEDMAIN  SELECT  DISTINCT '" + REJECTEDID + "',UPN,'','0','N','','','',SYSDATE,'',CODEID,'','','',CPADH FROM BRWREJECTTMP WHERE  IP='" + Ip + "' AND USERID ='" + lh_user + "'";
            Repository.getdatatablenoreturnMES(sqlInsert);
            string sqlInsertDetail = "INSERT INTO BRWREJECTED  SELECT  '" + REJECTEDID + "',USN,MO,'','','','" + lh_user + "',SYSDATE FROM BRWREJECTTMP WHERE  IP='" + Ip + "' AND USERID ='" + lh_user + "'";
            Repository.getdatatablenoreturnMES(sqlInsertDetail);
            return true;
        }
        catch (Exception EX)
        {
            return false;
        }

    }
    //箱号是否刷过
    public static DataTable GetBrwBySnOrReject(string REJECTED, string Usn)
    {
        string sql6 = "SELECT * FROM BRWREJECTTMP WHERE REJECTEDID='" + REJECTED + "' OR USN='" + Usn + "'";
        DataTable dtss3 = Repository.getdatatableMES(sql6);
        return dtss3;
    }
    ///获取仓别
    public static DataTable GetRejectloc(string REJECTED)
    {
        string sql6 = "SELECT LOC FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + REJECTED + "'";
        DataTable dtss3 = Repository.getdatatableMES(sql6);
        return dtss3;
    }
    /// 临时表仓别
    public static DataTable GetRejectoldloc()
    {
        string sql6 = "SELECT DISTINCT LOC FROM BRWREJECTEDMAIN WHERE REJECTEDID IN( SELECT DISTINCT REJECTEDID FROM BRWREJECTTMP)";
        DataTable dtss3 = Repository.getdatatableMES(sql6);
        return dtss3;
    }
    #endregion
    #region R04
    public static string getstatus(string type)
    {
        string sqlrjtype = "SELECT DISTINCT STATUS FROM BRWBASETYPE WHERE WORKPAGE='" + type + "'";
        DataTable dtrjtype = Repository.getdatatableMES(sqlrjtype);
        string rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static string getloc(string type)
    {
        string sqlrjtype = "SELECT DISTINCT LOC FROM BRWBASETYPE WHERE WORKPAGE='" + type + "'";
        DataTable dtrjtype = Repository.getdatatableMES(sqlrjtype);
        string rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static DataTable GetReworkTmpInfonewpcsmo(string ChipId)
    {
       
        string sqlrjtype = "SELECT MO FROM BRWREJECTED WHERE USN='" + ChipId + "'";
        DataTable dtrjtype = Repository.getdatatableMES(sqlrjtype);
        return dtrjtype;
    }
    ///查询料号
    public static DataTable GetReworkupn(string USN)
    {
        string sqlinserttmpmo = "SELECT HALFPARTID FROM BRWREJECTEDMAIN WHERE REJECTEDID IN(SELECT REJECTEDID FROM BRWREJECTED WHERE USN ='" + USN + "')";
        //string sqlinserttmpmo = "SELECT DISTINCT MO FROM SFCUSN WHERE USN IN(SELECT USN FROM SFCCARTONITEM  WHERE CARTONID='" + product + "' )";
        DataTable dtgetupn = Repository.getdatatableMES(sqlinserttmpmo);
        return dtgetupn;

    }
    //插入临时表
    public static DataTable insertipqctmp(string USN, string STATUS, string LOC, string ERRORCODE, string lh_user, string Ip, string MO, string HALFPARTID)
    {
        string sql = "INSERT INTO BRWIPQCTMP (USN,STATUS,LOC,ERRORCODE,MO,HALFPARTID,USERID,IP)VALUES('" + USN + "','" + STATUS + "','" + LOC + "','" + ERRORCODE + "','" + MO + "','" + HALFPARTID + "','" + lh_user + "','" + Ip + "')";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable checkiqc(string USN)
    {
        string strSQL = "SELECT *FROM BRWREJECTEDMAIN WHERE REJECTEDID IN(SELECT REJECTEDID FROM BRWREJECTED WHERE USN='" + USN + "')AND IQCFLAG='Y'";
        DataTable dtss = Repository.getdatatableMES(strSQL);
        return dtss;
    }
    public static DataTable checkiqcrejected(string USN)
    {
        string strSQL = "SELECT * FROM BRWREJECTED WHERE USN ='" + USN + "'AND ISDELETE ='Y'AND SUBSTR(REJECTEDID,0,1)='1'";
        DataTable dtss = Repository.getdatatableMES(strSQL);
        return dtss;
    }
    public static DataTable checktmp(string USN)
    {
        string strSQL = "SELECT *FROM BRWIPQCTMP WHERE USN ='" + USN + "'";
        DataTable dtss = Repository.getdatatableMES(strSQL);
        return dtss;
    }
    public static DataTable getshow(string Ip, string lh_user)
    {
        string strSQL = "SELECT USN,STATUS,LOC,ERRORCODE,MO,HALFPARTID,USERID,IP FROM BRWIPQCTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        DataTable dtss = Repository.getdatatableMES(strSQL);
        return dtss;
    }
    //删除一列
    public static bool getbrwiqcdel(string USN)
    {
        try
        {
            string sql = "DELETE FROM BRWIPQCTMP WHERE USN='" + USN + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    ///清空
    public static bool getbrwiqcdeltmp(string Ip, string lh_user)
    {
        try
        {
            string sql = "DELETE FROM BRWIPQCTMP WHERE  IP = '" + Ip + "' AND USERID ='" + lh_user + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static DataTable Gettmpupn(string lh_user, string Ip)
    {
        string sqlinserttmpmo = "SELECT DISTINCT HALFPARTID FROM BRWIPQCTMP WHERE  USERID = '" + lh_user + "' AND IP ='" + Ip + "'";
        //string sqlinserttmpmo = "SELECT DISTINCT MO FROM SFCUSN WHERE USN IN(SELECT USN FROM SFCCARTONITEM  WHERE CARTONID='" + product + "' )";
        DataTable dtgetupn = Repository.getdatatableMES(sqlinserttmpmo);
        return dtgetupn;

    }
    public static DataTable Gettmploc(string lh_user, string Ip)
    {
        string sqlinserttmpmo = "SELECT DISTINCT LOC FROM BRWIPQCTMP WHERE  USERID = '" + lh_user + "' AND IP ='" + Ip + "'";
        //string sqlinserttmpmo = "SELECT DISTINCT MO FROM SFCUSN WHERE USN IN(SELECT USN FROM SFCCARTONITEM  WHERE CARTONID='" + product + "' )";
        DataTable dtgetupn = Repository.getdatatableMES(sqlinserttmpmo);
        return dtgetupn;

    }
    //生成箱号
    public static string CreateBrwiqc(string Ip, string lh_user)
    {
        string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
        DataTable dtdata = Repository.getdatatableMES(sqldate);
        string backid = dtdata.Rows[0][0].ToString();
        string m = "";
        string sqlcheck = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        if (dtcheck.Rows[0][0].ToString() != "")
        {
            m = dtcheck.Rows[0][0].ToString();
        }
        backid = "1" + backid + m;
        string sqlma = "SELECT * FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + backid + "'";
        DataTable dt = Repository.getdatatableMES(sqlma);
        if (dt.Rows.Count > 0)
        {
            string sqlserial = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
            DataTable dtserial = Repository.getdatatableMES(sqlserial);
            backid = "1" + backid + dtserial.Rows[0][0].ToString();
        }

        return backid;
    }
    ///清空
    public static bool insertiqc(string lh_user, string REJECTEDID)
    {
        try
        {
            string sql = "INSERT INTO BRWREJECTED SELECT '" + REJECTEDID + "',USN,MO,STATUS,ERRORCODE,NULL,'" + lh_user + "',SYSDATE,'N'FROM BRWIPQCTMP";
            Repository.getdatatableMES(sql);
            string sql1 = "INSERT INTO BRWREJECTEDMAIN SELECT DISTINCT '" + REJECTEDID + "', HALFPARTID,LOC,'0','Y','','','" + lh_user + "',SYSDATE,'','','','','','R04'FROM BRWIPQCTMP";
            Repository.getdatatableMES(sql1);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static bool getbrwiqcup(string Ip, string lh_user)
    {
        try
        {
            string sql = "UPDATE BRWREJECTED SET ISDELETE ='Y'WHERE USN IN(SELECT  USN FROM BRWIPQCTMP WHERE IP = '" + Ip + "' AND USERID ='" + lh_user + "')";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    #endregion
    #region R63
    public static string getmo(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT DISTINCT A.ORDER_NO MO FROM SD_OP_WORKORDER A,SD_BASE_CODEWITHPRODUCT B WHERE A.PRODUCT_ID=B.PRODUCT_ID AND IS_CLOSED='N' ORDER BY ORDER_NO";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT DISTINCT A.MO MO FROM SFCCHECKINOUT A, SFCUPNINFO B WHERE A.UPN = B.UPN ORDER BY MO";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static string getloc1(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT 'A棟' AS LOC FROM  DUAL UNION ALL SELECT 'B棟' AS LOC FROM  DUAL ";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT 'MJMM' AS LOC FROM  DUAL";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static string getleibie(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT NULL AS LEIBIE FROM  DUAL";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT '點收' AS LEIBIE FROM  DUAL UNION ALL SELECT '一鍵打包' AS LEIBIE FROM  DUAL ";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static string getleixin(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT NULL AS LEIXIN FROM  DUAL ";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT '製造支援工單' AS LEIXIN FROM  DUAL UNION ALL SELECT 'fresh工單' AS LEIXIN FROM  DUAL";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static DataTable getpackshow(string MO, string DATETIMEPICKER, string DATETIMEPICKER2, string USERID, string LOC, string LEIBIE, string LEIXIN, string Fab, string TO, string END)
    {
        string strSQL = "";
        string sql2 = "";
        string sql3 = "";
        string sdate = DATETIMEPICKER + " " + TO;
        string edate = DATETIMEPICKER2 + " " + END;
        if (Fab == "Fab1/2")
        {
            if (DATETIMEPICKER != "" || DATETIMEPICKER2 == "")
            {


                if (DATETIMEPICKER != "" && DATETIMEPICKER2 == "")
                {
                    sdate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }
                if (DATETIMEPICKER == "" && DATETIMEPICKER2 != "")
                {
                    edate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }

                sql2 += " and to_char(a.create_date,'yyyy-MM-dd hh24miss') between '" + sdate + "' and '" + edate + "'";
            }
            if (MO != "")
            {
                sql2 += "and a.order_no='" + MO + "'";
            }
            if (USERID != "")
            {
                sql2 += "and a.create_user='" + USERID + "'";
            }
            if (LOC != "")
            {
                strSQL = @"select a.order_no,d.code_id ,c.product_id,A.PRODUCT_ID PART_ID,count(distinct case when a.flag='Y' then product_codecell else '' end) flag_Y,count(distinct case when a.flag='N' or a.flag='1' then product_codecell else '' end) flag_N,(case when c.site='A棟' then 'M1MM' else 'MHMM' end) ku from SD_OP_BRWTOSAP_CHAI a,sd_op_workorder c,sd_base_codewithproduct d where A.REMARK IS NULL AND c.product_id=d.product_id and a.order_no=c.order_no and c.site='" + LOC + @"' " + sql2 + @" group by a.order_no,d.code_id,c.product_id,A.PRODUCT_ID,c.site";
                sql3 = @"update SD_OP_BRWTOSAP_CHAI a set a.flag='1' where A.REMARK IS NULL and a.order_no in(select order_no from sd_op_workorder where site='" + LOC + @"') " + sql2 + @" and a.flag='N' ";
            }
            else
            {
                strSQL = @"select a.order_no,d.code_id,c.product_id,A.PRODUCT_ID PART_ID,count(distinct case when a.flag='Y' then product_codecell else '' end) flag_Y,count(distinct case when a.flag='N' or a.flag='1' then product_codecell else '' end) flag_N,(case when c.site='A棟' then 'M1MM' else 'MHMM' end) ku ,'' AS MOTYPE  from SD_OP_BRWTOSAP_CHAI a,sd_op_workorder c,sd_base_codewithproduct d where A.REMARK IS NULL AND c.product_id=d.product_id and a.order_no=c.order_no " + sql2 + @" group by a.order_no,d.code_id,c.product_id,A.PRODUCT_ID,c.site";
                sql3 = @"update SD_OP_BRWTOSAP_CHAI a set a.flag='1' where A.REMARK IS NULL AND 1=1 " + sql2 + @" and a.flag='N' ";
            }

            DataTable dt1 = Repository.getdatatableMES(sql3);
        }
        if (Fab == "Fab3")
        {
            strSQL += @"
                    SELECT C.MO AS ORDER_NO,
       E.CODEID AS CODE_ID,
       C.UPN AS PRODUCT_ID,    
       D.SEMIUPN PART_ID,
       SUM(DECODE(C.STOREINFLAG, '1', 1, 0)) FLAG_Y,
       SUM(DECODE(C.STOREINFLAG, '0', 1, 0)) flag_N, 
        'MJMM' AS KU, 
(CASE WHEN G.STATUS ='C'  AND G.MFGTYPE='MPD' THEN '拆解工单(已结案)'
           WHEN G.STATUS <> 'C'  AND G.MFGTYPE  <> 'MPD' THEN '正常工单(未结案)'
           WHEN G.STATUS <> 'C'  AND G.MFGTYPE  = 'MPD' THEN '拆解工单(未结案)'
           WHEN G.STATUS = 'C'  AND G.MFGTYPE  <> 'MPD' THEN '正常工单(已结案)'  ELSE NULL END) MOTYPE 
  FROM (SELECT B.USN, B.DEFECTDATE, DECODE(B.RACPADHSTATUSID, NULL, B.CPADHSTATUSID, B.RACPADHSTATUSID) STATUSID
        FROM SFCUSNDEFECT B ,(SELECT MAX(A.DEFECTDATE) DEFECTDATE, A.USN USN FROM SFCUSNDEFECT A ";
            if (MO != "") strSQL += " WHERE A.MO ='" + MO + "'";
            strSQL += @" GROUP BY A.USN) C
        WHERE B.USN = C.USN 
        AND B.DEFECTDATE = C.DEFECTDATE) B, SFCCHECKINOUT C,
       SFCMOADHSEMIUPN D, SFCUPNINFO E, SFCMO G ----,ERPMOCLOSEINFO T
 WHERE B.USN = C.USN
   AND C.MO = D.MO
   AND G.MO = D.MO
  ---- AND T.MO  = G.MO
   AND B.STATUSID = D.CPADHSTATUSID
   AND C.UPN = E.UPN 
   AND G.UPN = E.UPN
   AND C.CHECKINAPID = 'OPTNGCHK001'
  ";

            if (MO != "")
                strSQL += " AND C.MO='" + MO + "'";
            if (DATETIMEPICKER != "" || DATETIMEPICKER2 == "")
            {


                if (DATETIMEPICKER != "" && DATETIMEPICKER2 == "")
                {
                    sdate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }
                if (DATETIMEPICKER == "" && DATETIMEPICKER2 != "")
                {
                    edate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }

                strSQL += " and to_char(C.CHECKINDATE,'yyyy-MM-dd hh24miss') between '" + sdate + "' and '" + edate + "'";
            }
            if (USERID != "")
                strSQL += "  AND C.CHECKINUSERID LIKE'" + USERID + "'%";
            if (LEIBIE != "")
            {
                if (LEIBIE != "點收")
                {
                    strSQL += " AND C.CHECKINAPID='OPTNGCHK001'";
                }
                if (LEIBIE != "一鍵打包")
                {
                    strSQL += " AND C.CHECKINAPID = 'OPTNGPACK001'";
                }
            }
            if (LEIXIN != "")
            {
                if (LEIXIN != "製造支援工單")
                {
                    strSQL += " AND G.MFGTYPE='MPD'";
                }
                if (LEIXIN != "fresh")
                {
                    strSQL += " AND G.MFGTYPE <> 'MPD'";
                }

            }
            strSQL += " GROUP BY C.MO, D.SEMIUPN, C.UPN, E.CODEID,G.STATUS,G.MFGTYPE ";
        }
        DataTable dt = Repository.getdatatableMES(strSQL);
        return dt;
    }
    public static DataTable getpackshow1(string MO, string DATETIMEPICKER, string DATETIMEPICKER2, string USERID, string LOC, string LEIBIE, string LEIXIN, string Fab, string TO, string END)
    {
        string strSQL = "";
        string sql2 = "";
        string sdate = DATETIMEPICKER + " " + TO;
        string edate = DATETIMEPICKER2 + " " + END;
        if (Fab == "Fab1/2")
        {
            if (DATETIMEPICKER != "" || DATETIMEPICKER2 == "")
            {


                if (DATETIMEPICKER != "" && DATETIMEPICKER2 == "")
                {
                    sdate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }
                if (DATETIMEPICKER == "" && DATETIMEPICKER2 != "")
                {
                    edate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }

                sql2 += " and to_char(a.create_date,'yyyy-MM-dd hh24miss') between '" + sdate + "' and '" + edate + "'";
            }
            if (MO != "")
            {
                sql2 += "and a.order_no='" + MO + "'";
            }
            if (USERID != "")
            {
                sql2 += "and a.create_user='" + USERID + "'";
            }
            if (LOC != "")
            {
                sql2 += "and c.site='" + LOC + "'";
            }
            strSQL = @"select a.order_no,d.code_id,c.product_id,count(distinct case when a.flag='Y' then product_codecell else '' end) flag_Y,count(distinct case when a.flag='N' or a.flag='1' then product_codecell else '' end) flag_N,b.part_id,(case when c.site='A棟' then 'M1MM' else 'MHMM' end) ku
                        from SD_OP_BRWTOSAP_CHAI a, sd_base_orderpart b,sd_op_workorder c,sd_base_codewithproduct d where A.REMARK IS NULL AND c.product_id=d.product_id and a.product_id=d.product_id and a.order_no=c.order_no and a.order_no=b.order_no and a.product_status=b.part_status and b.part_id like 'PZ%' " + sql2 + @" group by a.order_no,d.code_id,c.product_id,b.part_id,c.site";
        }

        if (Fab == "Fab3")
        {
            strSQL += @"
                    SELECT C.MO AS ORDER_NO,
       E.CODEID AS CODE_ID,
       C.UPN AS PRODUCT_ID,    
       D.SEMIUPN PART_ID,
       SUM(DECODE(C.STOREINFLAG, '1', 1, 0)) FLAG_Y,
       SUM(DECODE(C.STOREINFLAG, '0', 1, 0)) flag_N, 
        'MJMM' AS KU, 
(CASE WHEN G.STATUS ='C'  AND G.MFGTYPE='MPD' THEN '拆解工单(已结案)'
           WHEN G.STATUS <> 'C'  AND G.MFGTYPE  <> 'MPD' THEN '正常工单(未结案)'
           WHEN G.STATUS <> 'C'  AND G.MFGTYPE  = 'MPD' THEN '拆解工单(未结案)'
           WHEN G.STATUS = 'C'  AND G.MFGTYPE  <> 'MPD' THEN '正常工单(已结案)'  ELSE NULL END) MOTYPE 
  FROM (SELECT B.USN, B.DEFECTDATE, DECODE(B.RACPADHSTATUSID, NULL, B.CPADHSTATUSID, B.RACPADHSTATUSID) STATUSID
        FROM SFCUSNDEFECT B ,(SELECT MAX(A.DEFECTDATE) DEFECTDATE, A.USN USN FROM SFCUSNDEFECT A ";
            if (MO != "") strSQL += " WHERE A.MO ='" + MO + "'";
            strSQL += @" GROUP BY A.USN) C
        WHERE B.USN = C.USN 
        AND B.DEFECTDATE = C.DEFECTDATE) B, SFCCHECKINOUT C,
       SFCMOADHSEMIUPN D, SFCUPNINFO E, SFCMO G ----,ERPMOCLOSEINFO T
 WHERE B.USN = C.USN
   AND C.MO = D.MO
   AND G.MO = D.MO
  ---- AND T.MO  = G.MO
   AND B.STATUSID = D.CPADHSTATUSID
   AND C.UPN = E.UPN 
   AND G.UPN = E.UPN
   AND C.CHECKINAPID = 'OPTNGCHK001'
  ";

            if (MO != "")
                strSQL += " AND C.MO='" + MO + "'";
            if (DATETIMEPICKER != "" || DATETIMEPICKER2 == "")
            {


                if (DATETIMEPICKER != "" && DATETIMEPICKER2 == "")
                {
                    sdate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }
                if (DATETIMEPICKER == "" && DATETIMEPICKER2 != "")
                {
                    edate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }

                strSQL += " and to_char(C.CHECKINDATE,'yyyy-MM-dd hh24miss') between '" + sdate + "' and '" + edate + "'";
            }
            if (USERID != "")
                strSQL += "  AND C.CHECKINUSERID LIKE'" + USERID + "'%";
            if (LEIBIE != "")
            {
                if (LEIBIE != "點收")
                {
                    strSQL += " AND C.CHECKINAPID='OPTNGCHK001'";
                }
                if (LEIBIE != "一鍵打包")
                {
                    strSQL += " AND C.CHECKINAPID = 'OPTNGPACK001'";
                }
            }
            if (LEIXIN != "")
            {
                if (LEIXIN != "製造支援工單")
                {
                    strSQL += " AND G.MFGTYPE='MPD'";
                }
                if (LEIXIN != "fresh")
                {
                    strSQL += " AND G.MFGTYPE <> 'MPD'";
                }

            }
            strSQL += " GROUP BY C.MO, D.SEMIUPN, C.UPN, E.CODEID,G.STATUS,G.MFGTYPE ";
        }

        DataTable dt = Repository.getdatatableMES(strSQL);
        return dt;
    }

    public static string btn_sap_Click(string MO, string DATETIMEPICKER, string DATETIMEPICKER2, string USERID, string LOC, string LEIBIE, string LEIXIN, string Fab, string TO, string END, string lh_user)
    {
        string strSQL = "";
        string rtn = "";
        string sql2 = "";
        string sql3 = "";
        string sdate = DATETIMEPICKER + " " + TO;
        string edate = DATETIMEPICKER2 + " " + END;
        if (Fab == "Fab1/2")
        {
            if (DATETIMEPICKER != "" || DATETIMEPICKER2 == "")
            {


                if (DATETIMEPICKER != "" && DATETIMEPICKER2 == "")
                {
                    sdate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }
                if (DATETIMEPICKER == "" && DATETIMEPICKER2 != "")
                {
                    edate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }

                strSQL += " and to_char(a.create_date,'yyyy-MM-dd hh24miss') between '" + sdate + "' and '" + edate + "'";
            }
            if (MO != "")
            {
                strSQL += "and a.order_no='" + MO + "'";
            }
            if (USERID != "")
            {
                strSQL += "and a.create_user='" + USERID + "'";
            }
            if (LOC != "")
            {
                strSQL = "select * from SD_OP_BRWTOSAP_CHAI a,sd_op_workorder c where A.REMARK IS NULL AND  a.order_no=c.order_no and c.site='" + LOC + "' " + strSQL + " and flag='1'";
                sql3 = @"update SD_OP_BRWTOSAP_CHAI a set a.flag='Y',a.rejected_user='" + lh_user + "',a.rejected_date=sysdate where A.REMARK IS NULL AND a.order_no in(select order_no from sd_op_workorder where site ='" + LOC + @"') " + strSQL + @"and a.flag='1' ";
            }
            else
            {
                strSQL = "select * from SD_OP_BRWTOSAP_CHAI a,sd_op_workorder c where A.REMARK IS NULL AND a.order_no=c.order_no " + strSQL + " and flag='1'";
                sql3 += "update SD_OP_BRWTOSAP_CHAI a set a.flag='Y',a.rejected_user='" + lh_user + "',a.rejected_date=sysdate where A.REMARK IS NULL AND 1=1 " + strSQL + " and a.flag='1'";
            }
            DataTable dt = Repository.getdatatableMES(strSQL);
            if (dt.Rows.Count > 0)
            {
                Repository.getdatatableMES(sql3);
                rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"入庫成功！\"}]";
            }
            else
            {
                rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"您查詢的產品已經全部入庫，請知悉！\"}]";
            }
        }
        if (Fab == "Fab3")
        {
            strSQL += @"UPDATE  SFCCHECKINOUT SET STOREINFLAG ='1' WHERE USN IN(
                    SELECT B.USN
  FROM (SELECT B.USN, B.DEFECTDATE, DECODE(B.RACPADHSTATUSID, NULL, B.CPADHSTATUSID, B.RACPADHSTATUSID) STATUSID
        FROM SFCUSNDEFECT B ,(SELECT MAX(A.DEFECTDATE) DEFECTDATE, A.USN USN FROM SFCUSNDEFECT A ";
            if (MO != "") strSQL += " WHERE A.MO ='" + MO + "'";
            strSQL += @" GROUP BY A.USN) C
        WHERE B.USN = C.USN 
        AND B.DEFECTDATE = C.DEFECTDATE) B, SFCCHECKINOUT C,
       SFCMOADHSEMIUPN D, SFCUPNINFO E, SFCMO G ----,ERPMOCLOSEINFO T
 WHERE B.USN = C.USN
   AND C.MO = D.MO
   AND G.MO = D.MO
  ---- AND T.MO  = G.MO
   AND B.STATUSID = D.CPADHSTATUSID
   AND C.UPN = E.UPN 
   AND G.UPN = E.UPN
   AND C.STOREINFLAG='0'
   AND C.CHECKINAPID = 'OPTNGCHK001')
  ";

            if (MO != "")
                sql2 += " AND C.MO='" + MO + "'";
            if (DATETIMEPICKER != "" || DATETIMEPICKER2 == "")
            {


                if (DATETIMEPICKER != "" && DATETIMEPICKER2 == "")
                {
                    sdate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }
                if (DATETIMEPICKER == "" && DATETIMEPICKER2 != "")
                {
                    edate = System.DateTime.Now.ToString("yyyy-MM-dd") + " " + DATETIMEPICKER;

                }

                strSQL += " and to_char(C.CHECKINDATE,'yyyy-MM-dd hh24miss') between '" + sdate + "' and '" + edate + "'";
            }
            if (USERID != "")
                strSQL += "  AND C.CHECKINUSERID LIKE'" + USERID + "'%";
            if (LEIBIE != "")
            {
                if (LEIBIE != "點收")
                {
                    strSQL += " AND C.CHECKINAPID='OPTNGCHK001'";
                }
                if (LEIBIE != "一鍵打包")
                {
                    strSQL += " AND C.CHECKINAPID = 'OPTNGPACK001'";
                }
            }
            if (LEIXIN != "")
            {
                if (LEIXIN != "製造支援工單")
                {
                    strSQL += " AND G.MFGTYPE='MPD'";
                }
                if (LEIXIN != "fresh")
                {
                    strSQL += " AND G.MFGTYPE <> 'MPD'";
                }

            }
            Repository.getdatatableMES(strSQL);
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"入庫成功！\"}]";
        }
        return rtn;
    }

    #endregion
    #region R12
    public static string GetR12Error()
    {
        string sql = "SELECT CODE_ID,CODE_ID||':'||CODE_NAME CODE_NAME FROM SD_BASE_CODE WHERE (FLAG='Y'OR FLAG_1='Y') AND CODE_ID NOT IN(SELECT CODE_ID FROM SD_BASE_CODE WHERE CODE_ID LIKE 'GZ3%') ORDER BY CODE_ID";
        DataTable dt = Repository.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    public static string GetR12Type()
    {
        string sql = "SELECT HALF_NAME FROM SD_BASE_HALFPART";
        DataTable dt = Repository.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    public static DataTable GetOrder(string str_lot)
    {
        string strSQL = "SELECT * FROM BRWLOT WHERE LOTMO = '" + str_lot + "'";
        DataTable dtHis = Repository.getdatatableMES(strSQL);
        return dtHis;
    }

    public static string GetStepM(string step, string type)
    {
        string sql = "select stepm_id from SD_BASE_BRWSTEP where step_id='" + step + "' and code_id='" + type + "' order by step_order";
        DataTable dt = Repository.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    public static string GetStep(string lot)
    {
        string sql = "SELECT DISTINCT A.STEP_ID FROM SD_BASE_BRWSTEP A,BRWLOT B WHERE A.STEP_FLAG='Y' AND A.STEP_ID=B.STEPCURRENT AND B.LOTID='" + lot + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        string rtn = JsonConvert.SerializeObject(dt);
        return rtn;
    }

    public static DataTable GetInfor(string str_Lot)
    {
        string sql = "SELECT A.LOTID,B.PRODUCT_ID,A.LOTQTY,B.ORDER_NO,B.DUE_DATE,TO_CHAR(A.CREATEDATE,'YYYYMMDD') CREATEDATE,A.STEPCURRENT,B.MO_TYPE FROM BRWLOT A,SD_OP_WORKORDER B WHERE A.MO=B.ORDER_NO AND A.LOTID ='" + str_Lot + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static string GetLotImfor(string status, string lotqty, string TxtCreateTime, string order_no, string DueDate, string codeid)
    {
        string sql1 = "select '" + lotqty + "' LOT_QTY,'" + status + "' status,'" + order_no + "' ORDER_NO,'" + TxtCreateTime + "' TxtCreateTime,'" + DueDate + "' DueDate,'" + codeid + "' CODEID from dual";
        DataTable dtzz = Repository.getdatatableMES(sql1);
        string rtn = JsonConvert.SerializeObject(dtzz);
        return rtn;
    }

    public static DataTable CheckChance(string strUser, string duty)
    {
        string strSQL = "SELECT * FROM SD_TMP_BRWNGDUTY WHERE USER_ID='" + strUser + "' AND DUTY='" + duty + "' and flag='Y'";
        DataTable dtHis = Repository.getdatatableMES(strSQL);
        return dtHis;
    }

    public static DataTable CheckRework(string chipid, string lot)
    {
        string strSQL = "SELECT * FROM BRWREWORK WHERE USN = '" + chipid + "'";
        if (lot == "Null")
        {

            strSQL = "SELECT * FROM BRWREWORK WHERE USN = '" + chipid + "' AND LOTNO IS NOT NULL";
        }
        else
        {

            strSQL += "SELECT * FROM BRWREWORK WHERE USN = '" + chipid + "' AND LOTNO = '" + lot + "'";
        }

        DataTable dtHis = Repository.getdatatableMES(strSQL);
        return dtHis;
    }
    #endregion
    #region Q17
    /// 获取类别
    public static string GetQ17_TYPE()
    {
        string sqlrepairtype = "SELECT item_type FROM SD_BASE_ITEMTYPE ORDER BY STEP_ORDER";
        DataTable dtrepairtype = Repository.getdatatableMES(sqlrepairtype);
        string rtn = JsonConvert.SerializeObject(dtrepairtype);
        return rtn;



    }
    public static DataTable GetQ17()
    {
        string sql = "SELECT * FROM SD_BASE_IQCWEIGHT WHERE FLAG='Y' ORDER BY MO_TYPE,PRODUCT_STATUS";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetQ17_select(string ddl_motype, string ddl_status, string banxing)
    {
        string sql = "SELECT * FROM SD_BASE_IQCWEIGHT WHERE MO_TYPE='" + ddl_motype + "' AND PRODUCT_STATUS='" + ddl_status + "' AND FLAG='Y' AND CODE_JB='" + banxing + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetQ17_insert(string ddl_motype, string ddl_status, string banxing, string txt_tray, string txt_weight, string txt_fullweught,
        string txt_minweight, string txt_store, string txt_repair, string user, string Ip)
    {
        string sql = @"INSERT INTO SD_BASE_IQCWEIGHT (MO_TYPE,PRODUCT_STATUS,TRAY_CAP,WEIGHT,FULLWEIGHT,REPAIRDIF,STOREDIF,CREATE_USER,CREATE_DATE,FLAG,IP_ADDR,MINWEIGHT,CODE_JB)
VALUES('" + ddl_motype + "','" + ddl_status + "','" + txt_tray + "','" + txt_weight + "','" + txt_fullweught + "','" + txt_repair + "','" + txt_store + "','" + user + "',SYSDATE,'Y','" + Ip + "','" + txt_minweight + "','" + banxing + "')";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetQ17_del(string MO_TYPE, string PRODUCT_STATUS, string lh_user)
    {
        string sql = "UPDATE SD_BASE_IQCWEIGHT SET FLAG='N',MODIFY_USER='" + lh_user + "',MODIFY_DATE=SYSDATE WHERE MO_TYPE='" + MO_TYPE + "' AND PRODUCT_STATUS='" + PRODUCT_STATUS + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    #endregion
    #region R17
    /// 查询11码
    public static DataTable GetR17_ChipId(string TextBox1)
    {
        string sqlrepairtype = "select get_PCS_chip('" + TextBox1 + "') from dual";
        DataTable dtrepairtype = Repository.getdatatableMES(sqlrepairtype);
        //string rtn = JsonConvert.SerializeObject(dtrepairtype);
        return dtrepairtype;
    }
    public static DataTable GetR17_ChipId2(string ChipId)
    {
        string sql = "select * from sd_op_brwinfo where (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + ChipId + "') order by create_date desc";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetR17_ChipId3(string lbluser)
    {
        string sql = "SELECT CHECK_USERLIMMIT('" + lbluser + "','TJO409') FROM DUAL";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetR17_show(string HostName)
    {
        string sql = "SELECT PC_ID FROM  SD_TMP_PCMEMORY WHERE  TREEID='TJO409' AND  PC_ID IN('" + HostName + "')";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetR17_show2(string TextBox2)
    {
        string sql = "select * from sd_base_code where code_id='" + TextBox2 + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetR17_show3(string ChipId)
    {
        string sql = "select * from sd_op_brwinfo where (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + ChipId + "') order by create_date desc";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetR17_show4(string dtss4, string TextBox2, string Label1, string lh_user, string sn)
    {
        string is_receive = "update sd_op_brwinfo set reason_code='" + TextBox2 + "' where  (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + dtss4 + "') and receiveflag='Y'";
        DataTable dt = Repository.getdatatableMES(is_receive);
        DataTable dt2 = Repository.getdatatableMES(@"insert into sd_his_meswork(PRODUCT_CODECELL,REMARK,ORDER_NO,CREATE_USER,CREATE_DATE,PRODUCT_STATUS,ERRNEWCODE) 
            values('" + dtss4 + @"','點收后變更不良CODE','" + sn + "','" + lh_user + "',sysdate,'" + Label1 + "','" + TextBox2 + "')");

        return dt;
    }

    public static DataTable GetR17_show5(string dtss4, string TextBox2, string Label1, string lh_user, string sn)
    {
        string is_receive = "update sd_op_brwinfo set reason_code='" + TextBox2 + "' where  (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + dtss4 + "') and receiveflag='N'";
        DataTable dt = Repository.getdatatableMES(is_receive);
        DataTable dt2 = Repository.getdatatableMES(@"insert into sd_his_meswork(PRODUCT_CODECELL,REMARK,ORDER_NO,CREATE_USER,CREATE_DATE,PRODUCT_STATUS,ERRNEWCODE) 
            values('" + dtss4 + @"','變更不良CODE','" + sn + "','" + lh_user + "',sysdate,'" + Label1 + "','" + TextBox2 + "')");

        return dt;
    }

    //上传
    public static string GetQ17_upload(DataTable dt, string user)
    {
        //Workbook work = Workbook.Load(fname);
        //Worksheet sheet = work.Worksheets[0];
        //if (sheet.Cells.LastRowIndex < 2)
        //{
        //    return "NG";
        //}
        string sn = "";
        string old_code = null;
        string new_code = null;
        string NGSN = null;
        string ChipId = null;
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            sn = dt.Rows[i]["SN"].ToString().Trim();
            old_code = dt.Rows[i]["OLD_CODE"].ToString().Trim();
            new_code = dt.Rows[i]["NEW_CODE"].ToString().Trim();
            #region 判斷產品編碼是否正確

            string strSQL = "select get_PCS_chip('" + sn + "') from dual";
            DataTable dtss = Repository.getdatatableMES(strSQL);
            string flag = "N";
            if (dtss.Rows[0][0].ToString().Length != 11)
            {
                //ScriptManager.RegisterStartupScript(UpdatePanel1, this.GetType(), "Air", "<script>alert('異常SN如下：" + strSQL + "請單PCS確認，謝謝!')</script>", false);
                //return;
                //ScriptManager.RegisterStartupScript(UpdatePanel1, this.GetType(), "Air", "<script>alert('未發現此產品的cell信息，請聯繫IT!')</script>", false);
                NGSN = sn + "," + NGSN;
                flag = "Y";
            }
            else
            {
                ChipId = dtss.Rows[0][0].ToString();


            #endregion
                string is_receive = "select * from sd_op_brwinfo where (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + ChipId + "') order by create_date desc";
                DataTable dt_receive = Repository.getdatatableMES(is_receive);
                if (dt_receive.Rows.Count != 1)
                {

                    //ScriptManager.RegisterStartupScript(UpdatePanel1, this.GetType(), "pld", "<script>alert('此產品非維修室未點收產品，請確認！')</script>", false);
                    NGSN = sn + "," + NGSN;
                    flag = "Y";
                }

                string sqluserlmt = "SELECT CHECK_USERLIMMIT('" + user + "','TJO409') FROM DUAL";
                DataTable dtuserlmt = Repository.getdatatableMES(sqluserlmt);
                if (dtuserlmt.Rows[0][0].ToString() != "OK")
                {
                    //ScriptManager.RegisterStartupScript(UpdatePanel1, this.GetType(), "aaa", "<script>alert('" + dtuserlmt.Rows[0][0] + "')</script>", false);
                    NGSN = sn + "," + NGSN;
                    flag = "Y";
                }

                string code = "select * from sd_base_code where code_id='" + new_code + "'";
                DataTable dt_code = Repository.getdatatableMES(code);
                if (dt_code.Rows.Count != 1)
                {
                    //ScriptManager.RegisterStartupScript(UpdatePanel1, this.GetType(), "pld", "<script>alert('無此不良CODE，請確認！')</script>", false);
                    NGSN = sn + "," + NGSN;
                    flag = "Y";
                }
                if (flag == "N")
                {
                    is_receive = "select * from sd_op_brwinfo where (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + ChipId + "') order by create_date desc";
                    DataTable dt_1 = Repository.getdatatableMES(is_receive);
                    if (dt_1.Rows[0]["RECEIVEFLAG"].ToString() == "Y")
                    {
                        is_receive = "update sd_op_brwinfo set reason_code='" + new_code + "' where  (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + ChipId + "') and receiveflag='Y'";
                        Repository.getdatatableMES(is_receive);
                        Repository.getdatatableMES(@"insert into sd_his_meswork(PRODUCT_CODECELL,REMARK,ORDER_NO,CREATE_USER,CREATE_DATE,PRODUCT_STATUS,ERRNEWCODE) 
            values('" + ChipId + @"','點收后變更不良CODE','" + dt_1.Rows[0]["order_no"].ToString() + "','" + user + "',sysdate,'" + old_code + "','" + new_code + "')");
                        //Label2.Visible = true;
                        //Label2.Text = "變更成功！";

                    }
                    else if (dt_1.Rows[0]["RECEIVEFLAG"].ToString() == "N")
                    {
                        is_receive = "update sd_op_brwinfo set reason_code='" + new_code + "' where  (order_no,product_codecell) in (select order_no,product_codecell from sd_op_lotproduct where product_codecell='" + ChipId + "') and receiveflag='N'";
                        Repository.getdatatableMES(is_receive);
                        Repository.getdatatableMES(@"insert into sd_his_meswork(PRODUCT_CODECELL,REMARK,ORDER_NO,CREATE_USER,CREATE_DATE,PRODUCT_STATUS,ERRNEWCODE) 
            values('" + ChipId + @"','變更不良CODE','" + dt_1.Rows[0]["order_no"].ToString() + "','" + user + "',sysdate,'" + old_code + "','" + new_code + "')");
                        //Label2.Visible = true;
                        //Label2.Text = "變更成功！";

                    }
                    else
                    {
                        //ScriptManager.RegisterStartupScript(UpdatePanel1, this.GetType(), "Air", "<script>alert('點收信息異常，請聯繫IT!')</script>", false);
                        NGSN = sn + "," + NGSN;
                        flag = "Y";
                    }
                }

            }

        }

        return NGSN;
    }
    #endregion
    #region R27
    public static DataTable GetRepairMater()
    {
        string sql = "SELECT * FROM SD_BASE_REPAIRMATERIAL WHERE 1=1";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetRepairMater_selectPro(string statustype, string adderrorcode)
    {

        string sql = "SELECT * FROM SD_BASE_REPAIRMATERIAL WHERE 1=1";
        if (statustype != "")
        {
            sql += "AND ITEM_TYPE='" + statustype + "'";
        }
        if (adderrorcode != "")
        {
            sql += "AND REASON_CODE='" + adderrorcode + "'";
        }

        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }

    public static DataTable GetRepairMater_insertPro(string statustype, string adderrorcode, string lotno, string login, string str_loginhost)
    {

        string sql = "INSERT INTO SD_BASE_REPAIRMATERIAL(item_type,reason_code,material,create_user,ip_addr,create_date) VALUES('" + statustype + "','" + adderrorcode + "','" + lotno + "','" + login + "','" + str_loginhost + "',SYSDATE)";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetRepairMater_del(string statustype, string adderrorcode)
    {

        string sql = "delete SD_BASE_REPAIRMATERIAL where ITEM_TYPE='" + statustype + "' and REASON_CODE='" + adderrorcode + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    #endregion
    #region R62
    public static string Getcodeid(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT DISTINCT MO_TYPE FROM SD_OP_WORKORDER WHERE MO_TYPE IN('Melon','Melon2','F50','F60','F52','F62','F54','F64','F57','F51','F56')";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT DISTINCT CODEID AS MO_TYPE FROM SFCUPNINFO  WHERE CODEID IN('F64','F66','F54','F56','F57','F50','F52','F62','F60')";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static string Getstatus(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT DISTINCT PART_STATUS AS STATUS FROM SD_BASE_ORDERPART WHERE  PART_STATUS IN('FOF','D-FLEX','MDL','MR-CELL','CGL','T-FLEX','PANEL','成品','CELL','COG','U-FLEX','FOG','D-FLEX')UNION ALL SELECT 'MDL無印'AS STATUS FROM DUAL UNION ALL SELECT '成品無'AS STATUS FROM DUAL UNION ALL SELECT '成品:出貨'AS STATUS FROM DUAL UNION ALL SELECT 'TERMINAL CUT'AS STATUS FROM DUAL UNION ALL SELECT 'GRINDING'AS STATUS FROM DUAL";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT  DESCRIPTION AS STATUS FROM SFCCPADHSTATUS";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static bool btn_delTmpOper(string CODEID, string STEP_ID, string STEMP_ID)
    {
        try
        {
            string sql = "delete from  BRWREPAIRROUTE WHERE CODEID='" + CODEID + "'AND STEP_ID='" + STEP_ID + "'AND STEMP_ID='" + STEMP_ID + "' ";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static bool btn_delTmpOper1(string CODEID, string STATUS, string BRWPROJECT, string STEMP_ID)
    {
        try
        {
            string sql = "delete from  BRWREPAIRPROCESS WHERE CODEID='" + CODEID + "'AND STATUS='" + STATUS + "'AND BRWPROJECT='" + BRWPROJECT + "'AND STEMP_ID='" + STEMP_ID + "' ";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static DataTable showStep()
    {

        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlinserttmp = "SELECT CODEID,STEP_ID,STEP_IDDESC,STEMP_ID,STEMP_IDDESC,CREATEUSER FROM BRWREPAIRROUTE ORDER BY CREATEDATE DESC";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    public static DataTable showPro()
    {

        //string sqlinserttmp = "SELECT * FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "' ";
        string sqlinserttmp = "SELECT CODEID,STATUS,BRWPROJECT,STEMP_IDDESC,STEMP_ID,BMZ_TYPE,CREATEDATE,CREATEUSER FROM   BRWREPAIRPROCESS  ORDER BY CREATEDATE DESC";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;

    }
    public static DataTable Getcount(string MO_TYPE, string STEP_ID, string STEP_IDDESC, string STEMP_IDDESC, string STEMP_ID, string lh_user)
    {
        string sqlinserttmpcodeid = "SELECT *FROM BRWREPAIRROUTE WHERE CODEID='" + MO_TYPE + "'AND STEP_ID='" + STEP_ID + "'AND STEP_IDDESC='" + STEP_IDDESC + "'AND STEMP_IDDESC='" + STEMP_IDDESC + "'AND STEMP_ID='" + STEMP_ID + "'";
        //string sqlinserttmpcodeid = "SELECT CODEID FROM SFCUPNINFO WHERE UPN IN(SELECT DISTINCT UPN FROM SFCCARTON WHERE CARTONID='" + product + "' )";
        DataTable dtinserttmpcodeid = Repository.getdatatableMES(sqlinserttmpcodeid);
        return dtinserttmpcodeid;

    }
    public static string insertStep(string MO_TYPE, string STEP_ID, string STEP_IDDESC, string STEMP_IDDESC, string STEMP_ID, string lh_user)
    {
        ////成功刷入临时表
        string rtn = "";
        string sql = " INSERT INTO BRWREPAIRROUTE (CODEID,STEP_ID,STEP_IDDESC,STEMP_ID,STEMP_IDDESC,CREATEDATE,CREATEUSER)VALUES ('" + MO_TYPE + "','" + STEP_ID + "','" + STEP_IDDESC + "','" + STEMP_ID + "','" + STEMP_IDDESC + "',SYSDATE,'" + lh_user + "')";
        DataTable dt = Repository.getdatatableMES(sql);
        return rtn;
    }
    public static DataTable Getcount1(string MO_TYPE, string STATUS, string BRWPROJECT, string STEMP_IDDESC, string STEMP_ID, string BMZ_TYPE, string lh_user)
    {
        string sqlinserttmpcodeid = "SELECT *FROM BRWREPAIRPROCESS WHERE CODEID='" + MO_TYPE + "'AND STATUS='" + STATUS + "'AND BRWPROJECT='" + BRWPROJECT + "'AND STEMP_IDDESC='" + STEMP_IDDESC + "'AND STEMP_ID='" + STEMP_ID + "'AND BMZ_TYPE='" + BMZ_TYPE + "'";
        //string sqlinserttmpcodeid = "SELECT CODEID FROM SFCUPNINFO WHERE UPN IN(SELECT DISTINCT UPN FROM SFCCARTON WHERE CARTONID='" + product + "' )";
        DataTable dtinserttmpcodeid = Repository.getdatatableMES(sqlinserttmpcodeid);
        return dtinserttmpcodeid;

    }
    public static string insertPro(string MO_TYPE, string STATUS, string BRWPROJECT, string STEMP_IDDESC, string STEMP_ID, string BMZ_TYPE, string lh_user)
    {
        ////成功刷入临时表
        string rtn = "";
        string sql = "  INSERT INTO BRWREPAIRPROCESS (CODEID,STATUS,BRWPROJECT,STEMP_IDDESC,STEMP_ID,BMZ_TYPE,CREATEDATE,CREATEUSER)VALUES('" + MO_TYPE + "','" + STATUS + "','" + BRWPROJECT + "','" + STEMP_IDDESC + "','" + STEMP_ID + "','" + BMZ_TYPE + "',SYSDATE,'" + lh_user + "')";
        DataTable dt = Repository.getdatatableMES(sql);
        return rtn;
    }
    #endregion
    #region M17
    public static string getsite(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT 'A' AS SITE FROM  DUAL UNION ALL SELECT 'B' AS SITE FROM  DUAL UNION ALL SELECT 'Fab3' AS SITE FROM  DUAL";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT 'FAB3' AS SITE FROM  DUAL ";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static string getcodeid(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT 'Melon' AS CODEID FROM  DUAL UNION ALL SELECT 'F50' AS CODEID FROM  DUAL UNION ALL SELECT 'F51' AS CODEID FROM  DUAL UNION ALL SELECT 'F60' AS CODEID FROM  DUAL UNION ALL SELECT 'F52' AS CODEID FROM  DUAL UNION ALL SELECT 'F62' AS CODEID FROM  DUAL UNION ALL SELECT 'F54' AS CODEID FROM  DUAL UNION ALL SELECT 'F64' AS CODEID FROM  DUAL UNION ALL SELECT 'F56' AS CODEID FROM  DUAL UNION ALL SELECT 'Melon2' AS CODEID FROM  DUAL UNION ALL SELECT 'F57' AS CODEID FROM  DUAL";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT 'F50' AS CODEID FROM  DUAL UNION ALL SELECT 'F51' AS CODEID FROM  DUAL UNION ALL SELECT 'F60' AS CODEID FROM  DUAL UNION ALL SELECT 'F52' AS CODEID FROM  DUAL UNION ALL SELECT 'F62' AS CODEID FROM  DUAL UNION ALL SELECT 'F54' AS CODEID FROM  DUAL UNION ALL SELECT 'F64' AS CODEID FROM  DUAL UNION ALL SELECT 'F56' AS CODEID FROM  DUAL UNION ALL  SELECT 'F57' AS CODEID FROM  DUAL";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static string getunmo(string Fab)
    {
        string rtn = "";
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "select order_no AS MO from (select order_no from sd_op_workorder WHERE REALWORK_DATE>TO_DATE('6/1/2017', 'MM/DD/YYYY') and is_closed='N' UNION ALL select order_no from sd_op_workorder where product_id in (select product_id from sd_base_codewithproduct where code_id in ('F54','F64')) AND REALWORK_DATE<=TO_DATE('8/1/2017', 'MM/DD/YYYY')AND REALWORK_DATE>TO_DATE('7/1/2017', 'MM/DD/YYYY') and is_closed='N') order by MO";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT S.MO FROM SFCMO S WHERE STATUS <> 'C' AND EXISTS (SELECT 1 FROM SFCMOREADY WHERE MO = S.MO AND READYFLAG = 1) ORDER BY MO";
        }
        DataTable dtrjtype = Repository.getdatatableMES(strSQL);
        rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    //插入临时表
    public static DataTable insertunusualtmp(string SITE, string MO_TYPE, string STATUS, string LOC, string MO, string UPN, string ERRORCODE, string QTY, string lh_user, string Ip)
    {
        string sql2 = "INSERT INTO BRWREJECTEDUNUSUALTMP(SITE,MO_TYPE,STATUS,LOC,MO,UPN,ERRORCODE,QTY,USERID,IP)values('" + SITE + "','" + MO_TYPE + "','" + STATUS + "','" + LOC + "','" + MO + "','" + UPN + "','" + ERRORCODE + "','" + QTY + "','" + lh_user + "','" + Ip + "')";
        DataTable dt3 = Repository.getdatatableMES(sql2);
        return dt3;
    }
    public static DataTable showunusualtmp(string lh_user, string Ip)
    {
        string strSQL = "SELECT SITE,MO_TYPE,STATUS,LOC,MO,UPN,ERRORCODE,QTY,USERID,IP FROM BRWREJECTEDUNUSUALTMP WHERE USERID='" + lh_user + "' AND IP='" + Ip + "'";
        DataTable dtss = Repository.getdatatableMES(strSQL);
        return dtss;
    }
    public static DataTable Getunusualupn(string lh_user, string Ip)
    {
        //string sqlinserttmp = "SELECT UPN FROM BRWREWORKTMP WHERE IP='" + Ip + "' AND USERID='" + lh_user + "'";
        string sqlinserttmp = "SELECT DISTINCT UPN FROM BRWREJECTEDUNUSUALTMP WHERE USERID='" + lh_user + "'AND IP ='" + Ip + "'";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;
    }
    public static bool delunusualtmp(string lh_user, string Ip)
    {
        try
        {
            string sql = "DELETE FROM BRWREJECTEDUNUSUALTMP WHERE  USERID='" + lh_user + "'AND IP ='" + Ip + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static bool delunusualtmp1(string MO, string lh_user, string Ip)
    {
        try
        {
            string sql = "DELETE FROM BRWREJECTEDUNUSUALTMP WHERE MO='" + MO + "'AND USERID='" + lh_user + "'AND Ip='" + Ip + "'";
            Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static string Createunusual()
    {
        string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
        DataTable dtdata = Repository.getdatatableMES(sqldate);
        string backid = dtdata.Rows[0][0].ToString();
        string m = "";
        string sqlcheck = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
        DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
        if (dtcheck.Rows[0][0].ToString() != "")
        {
            m = dtcheck.Rows[0][0].ToString();
        }
        backid = "1" + backid + m;
        string sqlma = "SELECT * FROM BRWREJECTEDUNUSUAL WHERE REJECTED='" + backid + "'";
        DataTable dt = Repository.getdatatableMES(sqlma);
        if (dt.Rows.Count > 0)
        {
            string sqlserial = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
            DataTable dtserial = Repository.getdatatableMES(sqlserial);
            backid = "1" + backid + dtserial.Rows[0][0].ToString();
        }

        return backid;
    }
    public static bool Insertunusual(string REJECTED, string lh_user, string Ip, string Fab)
    {
        if (Fab == "Fab1/2")
        {
            string sqlInsert = "INSERT INTO BRWREJECTEDUNUSUAL SELECT '" + REJECTED + "',SITE,MO_TYPE,STATUS,LOC,MO,UPN,ERRORCODE,QTY,USERID ,SYSDATE FROM BRWREJECTEDUNUSUALTMP WHERE USERID='" + lh_user + "' AND IP='" + Ip + "'";
            Repository.getdatatablenoreturnMES(sqlInsert);
            //入TT
            //string sqlInsertDetail = "INSERT INTO SD_HIS_WEIGHTLOG(REJECTED_ID, CODE_ID, PRODUCT_STATUS, COUNTNUM, CODE_JB)SELECT  '" + REJECTED + "', A.STATUS, A.SITE, QTY, C.CODE_JB FROM BRWREJECTEDUNUSUALTMP  A, SD_OP_WORKORDER B, SD_BASE_CODEWITHPRODUCT C WHERE A.MO = B.ORDER_NO AND B.PRODUCT_ID = C.PRODUCT_ID  AND A.IP = '" + Ip + "' ";
            //Repository.getdatatablenoreturnMES(sqlInsertDetail);
            return true;
        }
        if (Fab == "Fab3")
        {
            string sqlInsert = "INSERT INTO BRWREJECTEDUNUSUAL SELECT '" + REJECTED + "',SITE,MO_TYPE,STATUS,LOC,MO,UPN,ERRORCODE,QTY,USERID ,SYSDATE FROM BRWREJECTEDUNUSUALTMP WHERE USERID='" + lh_user + "' AND IP='" + Ip + "'";
            Repository.getdatatablenoreturnMES(sqlInsert);
        }
        return true;
    }
    #endregion
    #region R28
    public static string GetMoR28()
    {
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = @"SELECT A.ORDER_NO MO,CASE WHEN B.MODESC='MP' THEN '量產:'||A.ORDER_NO WHEN B.MODESC='PR' THEN '試產:'||A.ORDER_NO ELSE '調機:'||A.ORDER_NO END ORDERDESC 
                        FROM SD_OP_WORKORDER A , SD_BASE_MOTYPE B WHERE A.IS_CLOSED='N' AND A.MOTYPE=B.MOTYPE AND A.MOTYPE = 'ZMPD' AND A.ORDER_NO NOT LIKE '%MP%' ORDER BY B.MODESC,A.ORDER_NO";
        }
        if (Fab == "Fab3")
        {
            strSQL = @"SELECT A.MO,CASE WHEN B.MFGTYPE='MP' THEN '量產:'||A.MO WHEN B.MFGTYPE='PR' THEN '試產:'||A.MO ELSE '調機:'||A.MO END ORDERDESC
                        FROM SFCMO A , SFCMOTYPE B  WHERE A.MOTYPE ='2' AND A.STATUS ='W' AND A.MFGTYPE=B.MOTYPE";
        }
        DataTable dtss = Repository.getdatatableMES(strSQL);
        string Result = JsonConvert.SerializeObject(dtss);
        return Result;
    }
    public static DataTable GetBrwZeBie(string Mo)
    {
        string sqlBrwinfo = "SELECT DISTINCT ZEBIE FROM BRWORDERINFO WHERE MO='" + Mo + "' AND ZEBIE IS NOT NULL";
        DataTable dtBrwinfo = Repository.getdatatableMES(sqlBrwinfo);
        return dtBrwinfo;
    }

    public static string GetBrwProcess(string Codeid, string Status, string BmzType)
    {
        string sqlpro = "SELECT DISTINCT BRWPROCESSID,BRWPROCESS FROM BRWBASEPRO WHERE CODEID='" + Codeid + "' AND STATUS='" + Status + "' AND ZBTYPE ='" + BmzType + "' ORDER BY BRWPROCESS";
        DataTable dtpro = Repository.getdatatableMES(sqlpro);
        string rtn = JsonConvert.SerializeObject(dtpro);
        return rtn;
    }

    public static DataTable GetReworkTmp(string Ip, string lh_user)
    {
        string sqlinserttmp = "SELECT * FROM BRWRESURETMP WHERE IP='" + Ip + "'AND CREATEUSER ='" + lh_user + "'";
        DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
        return dtinserttmp;
    }

    public static DataTable GetCheckOrderPart(string Status, string Mo, string Type)
    {
        string rtwhere = "";
        if (Status != "NA")
        {
            rtwhere = rtwhere + "AND PART_STATUS='" + Status + "'";
        }
        if (Mo != "NA")
        {
            rtwhere = rtwhere + "AND ORDER_NO='" + Mo + "'";
        }
        if (Mo == "PZ")
        {
            rtwhere = rtwhere + "AND part_id like 'PZ%'";
        }

        string sqlsn = "SELECT * FROM sd_base_orderpart  WHERE 1=1 " + rtwhere;
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }
    public static DataTable GetCheckBrwResureTmp(string Usn, string User, string Ip)
    {
        string rtwhere = "";
        if (Usn != "NA")
        {
            rtwhere = rtwhere + "AND USN='" + Usn + "'";
        }
        if (User != "NA")
        {
            rtwhere = rtwhere + "AND CREATEUSER='" + User + "'";
        }
        if (Ip != "NA")
        {
            rtwhere = rtwhere + "AND IP='" + Ip + "'";
        }
        string sqlsn = "SELECT * FROM BRWRESURETMP WHERE 1=1 " + rtwhere;
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }

    public static DataTable GetOrderTmp(string User, string Ip)
    {
        string sqlsn = "SELECT DISTINCT MO FROM BRWRESURETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "'";
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }
    public static DataTable GetProcessId(string Mo)
    {
        string sqlsn = "";
        if (Fab == "Fab1/2")
        {
            sqlsn = "SELECT PROCESS_NAME PROCESSID FROM SD_BASE_PROCEPRODUCT WHERE PRODUCT_ID = (SELECT PRODUCT_ID FROM SD_OP_WORKORDER WHERE ORDER_NO ='" + Mo + "') AND FLAG = 'Y'";
        }
        else if (Fab == "Fab3")
        {
            sqlsn = "SELECT 'F57' PROCESSID from dual";
        }
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;

    }

    public static DataTable GetCheckBrwResure(string Usn, string Mo)
    {
        string rtwhere = "";
        if (Usn != "NA")
        {
            rtwhere = rtwhere + "AND USN='" + Usn + "'";
        }
        if (Mo != "NA")
        {
            rtwhere = rtwhere + "AND Mo='" + Mo + "'";
        }
        string sqlsn = "select * from BRWRESURE where 1=1 " + rtwhere + " and flag='Y'order by createdate desc ";
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }

    public static bool InsertBrwResure(string Mo, string Usn, string Upn, string StepFrom, string DefectCode, string User, string Ip, string OldUpn, string ProcessId)
    {
        try
        {
            string sqlrejectedidtmp = @"INSERT INTO BRWRESURETMP(MO,USN,UPN,STEPFROM,DEFECTCODE,CREATEDATE,CREATEUSER,IP,OLDUPN,PROCESSID)
                                        values ('" + Mo + "','" + Usn + "','" + Upn + "','" + StepFrom + "','" + DefectCode + "',sysdate,'" + User + "','" + Ip + "','" + OldUpn + "','" + ProcessId + "')";

            Repository.getdatatablenoreturnMES(sqlrejectedidtmp);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }

    public static string MoveOutR28(string Mo, string ProcessId, string Upn, string Status, string processname, string zebie, string User, string Ip)
    {
        string rtn = "";
        OracleConnection con = dbcon();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();
        try
        {
            OracleCommand cmd201 = new OracleCommand(@"UPDATE BRWUSNINFO SET RECEIVEFLAG='Y',BRWFLAG='Y' WHERE USN IN (SELECT USN FROM BRWRESURETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "')", con);
            //OracleCommand cmd202 = new OracleCommand(@"UPDATE SD_OP_BRWINFO SET MA_RECEIVE='Y' WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + User + "' AND ADDR_IP='" + Ip + "')AND MA_RECEIVE='N'", con);
            OracleCommand cmd3 = new OracleCommand(@"INSERT INTO BRWUSNINFO(MO,HALFPARTID,USN,STATUS,LOTNO,CREATEUSER,CREATEDATE,STEPFROM,STEPMFROM,DEFFECTCODE,WORKPAGE) 
                                                    SELECT MO,UPN,USN,'" + Status + "','','" + User + @"',SYSDATE,STEPFROM,STEPFROM,DEFECTCODE,'R28' FROM  BRWRESURETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "'", con);

            //string sql2 = @"SELECT * FROM BRWRESURETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "'";
            //DataTable dt2 = Repository.getdatatableMES(sql2);
            //for (int i = 0; i < dt2.Rows.Count; i++)
            //{
            //    string PRODUCT_CODECELL = dt2.Rows[i]["USN"].ToString();
            //    string sql21 = @"SELECT COUNT(*) I_COUNT1 FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + PRODUCT_CODECELL + "'";
            //    DataTable dt21 = Repository.getdatatableMES(sql21);
            //    int I_COUNT1 = int.Parse(dt21.Rows[0]["I_COUNT1"].ToString());
            //    if (I_COUNT1 > 0)
            //    {
            //        OracleCommand cmd4 = new OracleCommand(@"UPDATE SD_OP_LOTPRODUCT SET LOT_ID='NULL',PRODUCT_STATUS='W',ORDER_NO='" + Mo + "',PRODUCT_ID='" + Upn + "' WHERE PRODUCT_CODECELL='" + PRODUCT_CODECELL + "'", con);
            //        cmd4.Transaction = ots;
            //        cmd4.ExecuteNonQuery();
            //    }
            //    else
            //    {
            //        OracleCommand cmd41 = new OracleCommand(@"INSERT INTO SD_OP_LOTPRODUCT(LOT_ID,PRODUCT_STATUS,ORDER_NO,PRODUCT_ID,PRODUCT_CODECELL)VALUES('NULL','W','" + Mo + "','" + Upn + "','" + PRODUCT_CODECELL + "')", con);
            //        cmd41.Transaction = ots;
            //        cmd41.ExecuteNonQuery();
            //    }
            //}

            //OracleCommand cmd5 = new OracleCommand(@"UPDATE SD_OP_LOTPRODUCT SET LOT_ID='NULL',PRODUCT_STATUS='W',ORDER_NO='" + Mo + "',PRODUCT_ID='" + Upn + "' WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + User + "' AND ADDR_IP='" + Ip + "')", con);
            //            OracleCommand cmd6 = new OracleCommand(@"INSERT INTO SD_HIS_PCSINFO(PRODUCT_CODECELL,ORDER_NO,LOT_ID,STEP_ID,REMARK,LINE_ID,CREATE_USER)
            //                                                         SELECT PRODUCT_CODECELL,ORDER_NO,'NA','BRW','維修下線','NA','" + User + "' FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + User + "' AND ADDR_IP='" + Ip + "'", con);
            //OracleCommand cmd7 = new OracleCommand(@"INSERT INTO SD_OP_PRODUCTINFO(PRODUCT_CODE,ORDER_NO,FLAG,CREATE_USER,CREATE_DATE,IS_OFFLINE) SELECT PRODUCT_CODECELL,'" + Mo + "','Y','" + User + "',SYSDATE,'Y' FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + User + "' AND ADDR_IP='" + Ip + "'", con);
            //            OracleCommand cmd8 = new OracleCommand(@"INSERT INTO SD_OP_PRODUCTSTATUS(ORDER_NO,PRODUCT_CODECELL,PRODUCT_STATUS,USER_ID,CREATE_DATE,STEP_ID)
            //                                                     SELECT '" + Mo + "',PRODUCT_CODECELL,'B','" + User + "',SYSDATE,'BRW' FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + User + "' AND ADDR_IP='" + Ip + "'", con);

            //string sql3 = @"SELECT COUNT(*) I_COUNT FROM WORKPROCESS WHERE MO='" + Mo + "'";
            //DataTable dt3 = Repository.getdatatableMES(sql3);
            //int I_COUNT = int.Parse(dt3.Rows[0]["I_COUNT"].ToString());
            //if (I_COUNT == 0)
            //{
            //    OracleCommand cmd9 = new OracleCommand(@"INSERT INTO WORKPROCESS (MO,PROCESSID) VALUES ('" + Mo + "','" + ProcessId + "')", con);
            //    cmd9.Transaction = ots;
            //    cmd9.ExecuteNonQuery();
            //}

            //            OracleCommand cmd10 = new OracleCommand(@"INSERT INTO SD_OP_REWORK (ORDER_NO,PRODUCT_CODE,TOSTEP_ID,CREATE_USER,PRODUCT_CODECELL,LINE_TYPE,IS_RMA,REASON_CODE) 
            //                                                          SELECT '" + Mo + "',PRODUCT_BL,'BRW','" + User + "',PRODUCT_CODECELL,'A',IS_RMA,TYPE FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + User + "' AND ADDR_IP='" + Ip + "'", con);

            string sql4 = @"SELECT COUNT(USN)  FROM (SELECT DISTINCT USN FROM BRWRESURETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "')";
            DataTable dt4 = Repository.getdatatableMES(sql4);
            int QTY = int.Parse(dt4.Rows[0][0].ToString());

            //if (I_COUNT > 0)
            //{


            //OracleCommand cmd11 = null;
            //if (Fab == "Fab1/2")
            //{
            //     cmd11 = new OracleCommand(@"UPDATE SD_OP_WORKORDER SET QUANTITY_CREATED=QUANTITY_CREATED+" + QTY + ",INPUTDATE=TO_DATE(TO_CHAR(SYSDATE,'yyyyMMdd hh24miss'),'yyyyMMdd hh24miss')  WHERE ORDER_NO='" + Mo + "'", con);
            //}
            //else if (Fab == "Fab3")
            //{
            //    cmd11 = new OracleCommand(@"UPDATE SFCMO SET INPUTQTY=INPUTQTY+" + QTY + ",INPUTDATE=TO_DATE(TO_CHAR(SYSDATE,'yyyyMMdd hh24miss'),'yyyyMMdd hh24miss')  WHERE MO='" + Mo + "'", con);
            //}
            //cmd11.Transaction = ots;
            //cmd11.ExecuteNonQuery();


            //}
            //else
            //{
            //    OracleCommand cmd12 = new OracleCommand(@"UPDATE SD_OP_WORKORDER SET QUANTITY_CREATED=QUANTITY_CREATED+" + QTY + "  WHERE ORDER_NO='" + Mo + "'", con);
            //    cmd12.Transaction = ots;
            //    cmd12.ExecuteNonQuery();
            //}
            //2019/12/12 GPF
            //OracleCommand cmd13 = new OracleCommand(@"delete from sd_tmp_brwrework where addr_ip='" + str_loginhost + "'", con);

            string brw_lot = "";
            string lock_num = "";
            string strSQL = "";
            //生成BLOT號
            string strSQL01 = " select 'B'||to_char(sysdate,'yyyymmdd')  from dual";
            DataTable dt01 = Repository.getdatatableMES(strSQL01);
            brw_lot = dt01.Rows[0][0].ToString();
            string strSQL1 = "select '" + brw_lot + "'||'-'||inttoh10(LOTFORR28.nextval,4) from dual";
            DataTable dt0101 = Repository.getdatatableMES(strSQL1);
            brw_lot = dt0101.Rows[0][0].ToString();
            lock_num = dt0101.Rows[0][0].ToString();

            string code_id = "";
            string order = Mo;

            DataTable dtcode = BaseServices.GetMoInfo(order);

            if (dtcode.Rows.Count > 0)
            {
                code_id = dtcode.Rows[0]["codeid"].ToString();
                if (code_id == "F50" || code_id == "F60")
                {
                    code_id = "F50/F60";
                }
                else if (code_id == "F52" || code_id == "F62")
                {
                    code_id = "F52/F62";
                }
                else if (code_id == "F54" || code_id == "F64")
                {
                    code_id = "F54/F64";
                }
                else if (code_id == "Melon" || code_id == "Melon2")
                {
                    code_id = "Melon/Melon2";
                }
                else if (code_id == "F57")
                {
                    code_id = "F57";
                }
                else
                {
                    code_id = "F56/F66";
                }
            }
            string brwpro = processname;
            string item = Status;
            string SS = "";

            SS = "SELECT * FROM BRWBASEPRO WHERE CODEID='" + code_id + "' AND STATUS='" + Status + "' AND BRWPROCESSID='" + processname + "' and ZBTYPE='" + zebie + "' ORDER BY ITEM";

            DataTable dtpid = Repository.getdatatableMES(SS);
            //int step_order = dtpid.Rows.Count;
            //int pid = 0;

            //for (int i = 0; i < step_order; i++)
            //{
            //    string blotstep = dtpid.Rows[i]["BRWSTEPID"].ToString();
            //    pid = pid + 10;
            //    OracleCommand cmd14 = new OracleCommand("insert into sd_op_lotprocess(b_lot,step_id,create_user,process_id) values('" + brw_lot + "','" + blotstep + "','" + User + "','" + pid + "')", con);
            //    cmd14.Transaction = ots;
            //    cmd14.ExecuteNonQuery();
            //}
            //pid = pid + 10;
            //OracleCommand cmd15 = new OracleCommand("insert into sd_op_lotprocess(b_lot,step_id,create_user,process_id) values('" + brw_lot + "','OQC','" + User + "','" + pid + "')", con);

            //if (Status == "成品")
            //{
            OracleCommand cmdmark = null;
            if (Fab == "Fab1/2")
            {
                cmdmark = new OracleCommand(@"INSERT INTO BLOTPRODUCTLABEL(USN,FPC,BL,CPN,CG,BLCODE,CREATEDATE,SC_FLAG,L_TYPE,BLOT,UPN) 
                    SELECT DISTINCT A.PRODUCT_CODECELL,A.PRODUCT_FPC,A.PRODUCT_BL,A.PRODUCT_CPN,A.PRODUCT_CG,A.BL_CODE,SYSDATE,A.SC_FLAG,A.L_TYPE,'" + brw_lot + "',B.OLDUPN FROM SD_OP_PRODUCTLABEL A,BRWRESURETMP B WHERE A.PRODUCT_CODECELL=B.USN AND  B.IP='" + Ip + "' AND B.CREATEUSER='" + User + "'", con);
            }
            else if (Fab == "Fab3")
            {
                cmdmark = new OracleCommand(@"INSERT INTO BLOTPRODUCTLABEL(USN,FPC,BL,CPN,CG,BLCODE,CREATEDATE,SC_FLAG,L_TYPE,BLOT,UPN) 
                    SELECT A.USN,B.PRODUCTLABEL FPC,C.PRODUCTLABEL BL,D.PRODUCTLABEL FG,E.PRODUCTLABEL CG,'',SYSDATE,'','','" + brw_lot + @"',A.OLDUPN FROM BRWRESURETMP A ,SFCUSNPRODUCTLABEL B ,SFCUSNPRODUCTLABEL C,SFCUSNPRODUCTLABEL D,SFCUSNPRODUCTLABEL E
                    WHERE A.USN=B.USN AND A.USN=C.USN AND A.USN=D.USN AND A.USN=E.USN AND B.PRODUCTLABELTYPE='FPC' AND C.PRODUCTLABELTYPE='BL' AND D.PRODUCTLABELTYPE='FG' AND E.PRODUCTLABELTYPE='CG' AND A.IP='" + Ip + "' AND A.CREATEUSER='" + User + "'", con);
            }
            cmdmark.Transaction = ots;
            cmdmark.ExecuteNonQuery();
            //}

            //            if (USN.SelectedValue == "FPC" || USN.SelectedValue == "BLU" || USN.SelectedValue == "FPCCG" || USN.SelectedValue == "FPCBLU" || USN.SelectedValue == "FPCCGBLU")
            //            {
            //                string code_id1 = "";
            //                string order1 = Mo;
            //                string sqlcode_id1 = "select * from sd_base_codewithproduct where product_id in(select product_id from sd_op_workorder where order_no='" + order1 + "')";
            //                DataTable dtcode1 = pc.getdatatable(sqlcode_id1);
            //                code_id1 = dtcode1.Rows[0]["code_id"].ToString();
            //                if (code_id1 != "F56")
            //                {

            //                    OracleCommand cmd101 = new OracleCommand(@"insert into  SD_OP_PRODUCTLABELBRW (PRODUCT_CODECELL,PRODUCT_FPC,PRODUCT_BL,PRODUCT_ID,CPN,CREATE_USER,CREATE_DATE,L_TYPE)
            //                        SELECT D.PRODUCT_CODECELL,D.PRODUCT_FPC ,D.PRODUCT_BL ,C.PRODUCT_ID , B.PART_ID,C.RESURE_USER,SYSDATE,'" + USN.SelectedValue + @"'  FROM SD_OP_LOTPRODUCT A,SD_OP_AUXPARTS B,SD_TMP_BRWRESURE C,SD_OP_PRODUCTLABEL D 
            //                        WHERE A.PRODUCT_CODECELL=C.PRODUCT_CODECELL  AND B.ORDER_NO=A.SENCONDMO AND B.PART_ID LIKE 'A1029%'AND A.PRODUCT_CODECELL=D.PRODUCT_CODECELL AND  
            //                        C.ip_addr='" + str_loginhost + "' and C.resure_user='" + User + "'ORDER BY A.CREATE_DATE DESC", con);
            //                    cmd101.Transaction = ots;
            //                    cmd101.ExecuteNonQuery();
            //                }
            //                else
            //                {
            //                    OracleCommand cmd102 = new OracleCommand(@"insert into  SD_OP_PRODUCTLABELBRW (PRODUCT_CODECELL,PRODUCT_FPC,PRODUCT_BL,PRODUCT_ID,CPN,CREATE_USER,CREATE_DATE,L_TYPE)                 
            //                        SELECT A4.PRODUCT_CODECELL,A4.PRODUCT_FPC ,A4.PRODUCT_BL ,A3.PRODUCT_ID ,A1.PART_ID,A3.RESURE_USER,SYSDATE,'" + USN.SelectedValue + @"' FROM SD_OP_AUXPARTS A1, SD_BASE_SLPMATERIAL A2,SD_TMP_BRWRESURE A3,SD_oP_PRODUCTLABEL A4 
            //                        WHERE A1.ORDER_NO = A3.ORDER_NO AND A1.PART_ID =A2.CPN AND A2.DESCRIPTION = 'BL' AND A3.PRODUCT_CODECELL=A4.PRODUCT_CODECELL AND  A3.ip_addr='" + str_loginhost + "' and A3.resure_user='" + User + "'", con);
            //                    cmd102.Transaction = ots;
            //                    cmd102.ExecuteNonQuery();
            //                }
            //            }
            OracleCommand cmd16 = new OracleCommand(@"INSERT INTO BRWRESURE (MO,USN,LOTNO,UPN,STEPFROM,CREATEUSER,CREATEDATE,DEFECTCODE,NEWDEFECTCODE,REALTYPE,BRWLOT,WORKPAGE) 
                                                        SELECT DISTINCT MO,USN,LOTNO,UPN,STEPFROM,CREATEUSER,SYSDATE,DEFECTCODE,NEWDEFECTCODE,REALTYPE,'" + brw_lot + @"','R28' FROM  
                                                        BRWRESURETMP WHERE IP='" + Ip + "' AND CREATEUSER='" + User + "'", con);
            //            OracleCommand cmd17 = new OracleCommand("update SD_op_brwinfo set resure_flag='Y' where (product_codecell,order_no) in (select PRODUCT_CODECELL,ORDER_NO from SD_TMP_BRWRESURE where ip_addr='" + Ip + "' and resure_user='" + User + "') and brw_flag='N'", con);

            //            OracleCommand cmd18 = new OracleCommand(@"insert into SD_HIS_PCSINFO(PRODUCT_CODECELL,ORDER_NO,LOT_ID,STEP_ID,REMARK,LINE_ID,CREATE_USER)
            //                                                        select DISTINCT product_codecell,ORDER_NO,'" + brw_lot + "',STEP_from,'維修BLOT','NA','" + User + "'  from SD_TMP_BRWRESURE where ip_addr='" + Ip + "' and resure_user='" + User + "'", con);
            OracleCommand cmd19 = new OracleCommand(@"INSERT INTO BRWLOTDETAIL(LOTNO,USN,FLAG) SELECT DISTINCT '" + brw_lot + "',USN ,'Y' FROM BRWRESURETMP WHERE IP='" + Ip + "' and CREATEUSER='" + User + "'", con);

            cmd201.Transaction = ots;
            //cmd202.Transaction = ots;
            cmd3.Transaction = ots;
            //cmd5.Transaction = ots;
            //cmd6.Transaction = ots;
            //cmd7.Transaction = ots;
            //cmd8.Transaction = ots;
            cmd201.ExecuteNonQuery();
            //cmd202.ExecuteNonQuery();
            cmd3.ExecuteNonQuery();
            //cmd5.ExecuteNonQuery();
            //cmd6.ExecuteNonQuery();
            //cmd7.ExecuteNonQuery();
            //cmd8.ExecuteNonQuery();
            //cmd15.Transaction = ots;
            //cmd15.ExecuteNonQuery();
            cmd16.Transaction = ots;
            cmd16.ExecuteNonQuery();
            //cmd17.Transaction = ots;
            //cmd17.ExecuteNonQuery();
            //cmd18.Transaction = ots;
            //cmd18.ExecuteNonQuery();
            cmd19.Transaction = ots;
            cmd19.ExecuteNonQuery();
            //ots.Rollback();
            ots.Commit();
            //MsgResult = "sucess";
            strSQL = "select * from sd_op_lotprocess where b_lot='" + brw_lot + "'order by process_id";
            //dt = pc.getdatatable(strSQL);
            //if (dt.Rows.Count > 0)
            //{
            //    step_currentid = dt.Rows[0]["process_id"].ToString();
            //    step_id = dt.Rows[0]["step_id"].ToString();
            //}
            ots = con.BeginTransaction();

            string sqlcount = "SELECT COUNT(*) FROM(SELECT DISTINCT USN FROM BRWRESURETMP WHERE IP='" + Ip + "' AND CREATEUSER='" + User + "')";
            DataTable dtcount = Repository.getdatatableMES(sqlcount);
            int count = Convert.ToInt16(dtcount.Rows[0][0].ToString());
            string stepcurrent = dtpid.Rows[0]["BRWSTEPID"].ToString();
            OracleCommand cmd20 = new OracleCommand(@"INSERT INTO BRWLOT (LOTNO,MO,PROCESSNAME,STEPCURRENT,STEPCURRENTID,CREATEUSER,CREATEDATE,IP,LOTQTY,RECEIVEFLAG,STATUS,LOTTYPE)
                                                    SELECT '" + brw_lot + "',MO,'" + processname + @"','" + stepcurrent + "','1','" + User + "',SYSDATE,'" + Ip + "','" + count + "','Y','" + Status + "','" + zebie + "' FROM BRWRESURETMP where rownum=1 and IP='" + Ip + "' AND CREATEUSER='" + User + "'", con);

            //OracleCommand cmd21 = new OracleCommand("delete from SD_TMP_BRWRESURE where ip_addr='" + str_loginhost + "' and resure_user='" + User + "'", con);
            cmd20.Transaction = ots;
            cmd20.ExecuteNonQuery();

            ots.Commit();
            //if (Fab == "Fab1/2")
            //{
            //    TTServices.updateData("R28", Ip, User, "NA", brw_lot);
            //}

            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬成功\",\"LOTNO\":\"" + brw_lot + "\"}]";
        }
        catch
        {
            ots.Rollback();
            con.Close();
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"過賬失敗\"}]";
        }
        return rtn;
    }

    //刪除臨時表
    public static bool DeleteR28Tmp(string Usn, string Ip, string User)
    {
        try
        {
            if (Usn == "NA")
            {
                string sql = @"DELETE FROM BRWRESURETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "'";
                Repository.getdatatablenoreturnMES(sql);
                return true;
            }
            else
            {
                string sql = @"DELETE FROM BRWRESURETMP WHERE USN ='" + Usn + "' AND CREATEUSER='" + User + "' AND IP='" + Ip + "'";
                Repository.getdatatablenoreturnMES(sql);
                return true;
            }
        }
        catch (Exception ex)
        {
            return false;
        }

    }
    #endregion R28
    #region Q18
    public static bool DeleteRepairTmpByUsn(string Usn)
    {
        try
        {
            string sql = @"DELETE BRWFUPANTMP WHERE USN='" + Usn + "'";
                Repository.getdatatablenoreturnMES(sql);
                return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }
    //插入临时表
    public static DataTable CheckFP(string user, string ip, string page,string usn)
    {
        string sql = "";

        if (usn == "")
        {

            sql = @"SELECT * FROM BRWFUPAN WHERE usn IN(SELECT USN FROM BRWFUPANTMP WHERE CREATEUSER='" + user + "' AND IP = '" + ip + "' AND WORKPAGE = '" + page + "')";

        }
        else {

            sql = @"SELECT * FROM BRWFUPAN WHERE USN='" + usn + "'";
        }

         
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable CheckFPT(string usn)
    {
        string sql = @"SELECT * FROM BRWFUPANTMP WHERE USN='" + usn + "'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static string InTmpFP(string user, string ip,string page)
    {
        string rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"復判成功\"}]";
        try
        {
            string cmd3 = @"INSERT INTO BRWFUPAN 
                    SELECT * FROM BRWFUPANTMP WHERE CREATEUSER='" + user + "' AND IP = '" + ip + "' AND WORKPAGE = '" + page + "'";
            Repository.getdatatablenoreturnMES(cmd3);
            string cmd4 = @"DELETE FROM BRWFUPANTMP WHERE CREATEUSER='" + user + "' AND IP = '" + ip + "' AND WORKPAGE = '" + page + "'";
            Repository.getdatatablenoreturnMES(cmd4);

        }
        catch
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"復判失敗\"}]";
            return rtn;

        }
        return rtn;
    }
    public static DataTable CheckFPCode(string code)
    {
        string sql = @"SELECT * FROM BRWFUPANCODE WHERE DEFECTCODE='" + code + "' AND FLAG = 'Y'";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetFPMo(string usn, string Fab)
    {
        string sql = "";
        if (Fab == "Fab1/2")
        {

            sql = @"SELECT B.MO_TYPE FROM SD_OP_LOTPRODUCT A LEFT JOIN SD_OP_WORKORDER B ON A.ORDER_NO=B.ORDER_NO WHERE A.PRODUCT_CODECELL='" + usn + @"'";

        }
        else if (Fab == "Fab3")
        {

            sql = @"SELECT MO FROM SFCUSN WHERE USN='" + usn + "'";
        }


        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static DataTable GetFPCode(string usn, string Fab)
    {
        string sql = "";
        if (Fab == "Fab1/2")
        {
            sql = @"SELECT REASON_CODE FROM 
                                        (SELECT PRODUCT_CODECELL,REASON_CODE,CREATE_DATE FROM SD_HIS_NGMSG 
                                        UNION ALL 
                                        SELECT PRODUCT_CODECELL,REASON_CODE,CREATE_DATE FROM SD_HIS_BRWNGMSG
                                        UNION ALL
                                        SELECT PRODUCT_CODECELL,ERRNEWCODE REASON_CODE,CREATE_DATE FROM SD_HIS_MESWORK WHERE REMARK='變更不良CODE') A 
                                        WHERE A.PRODUCT_CODECELL='" + usn + @"' AND (A.PRODUCT_CODECELL,A.CREATE_DATE) IN
                                        (SELECT B.PRODUCT_CODECELL,MAX( B.CREATE_DATE) FROM 
                                        (SELECT PRODUCT_CODECELL,REASON_CODE,CREATE_DATE FROM SD_HIS_NGMSG 
                                        UNION ALL
                                        SELECT PRODUCT_CODECELL,REASON_CODE,CREATE_DATE FROM SD_HIS_BRWNGMSG
                                        UNION ALL
                                        SELECT PRODUCT_CODECELL,ERRNEWCODE REASON_CODE,CREATE_DATE FROM SD_HIS_MESWORK WHERE REMARK='變更不良CODE') B 
                                        WHERE A.PRODUCT_CODECELL=B.PRODUCT_CODECELL GROUP BY B.PRODUCT_CODECELL)";

        }
        else if (Fab == "Fab3")
        {

            sql = @"SELECT (CASE WHEN RAERRORCODE IS NOT NULL THEN RAERRORCODE ELSE ERRORCODE END) REASON_CODE  FROM SFCUSNDEFECT WHERE (USN,DEFECTDATE) IN (
                    SELECT USN,MAX(DEFECTDATE) FROM SFCUSNDEFECT WHERE USN = '" + usn + @"'
                    GROUP BY USN)";
        }
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    public static bool InFP(string Usn,string Fab,string user,string ip,string page)
    {
        try
        {
            string sql = "";
            if (Fab == "Fab1/2")
            {
                sql = @"INSERT INTO BRWFUPANTMP
                                        WITH A AS(
                                        SELECT A.PRODUCT_CODECELL,B.PRODUCT_FPC,B.PRODUCT_BL,A.ORDER_NO,C.MO_TYPE 
                                        FROM SD_OP_LOTPRODUCT A LEFT JOIN SD_OP_PRODUCTLABEL B ON A.PRODUCT_CODECELL=B.PRODUCT_CODECELL
                                        LEFT JOIN SD_OP_WORKORDER C ON C.ORDER_NO=A.ORDER_NO WHERE A.PRODUCT_CODECELL='" + Usn + @"'
                                        ),
                                        B AS (
                                        select * from SD_HIS_NGMSG Z WHERE Z.PRODUCT_CODECELL='" + Usn + @"' AND (Z.PRODUCT_CODECELL,Z.CREATE_DATE)
                                        IN (SELECT X.PRODUCT_CODECELL,MAX(X.CREATE_DATE) FROM SD_HIS_NGMSG X WHERE X.PRODUCT_CODECELL=Z.PRODUCT_CODECELL GROUP BY X.PRODUCT_CODECELL)
                                        ),
                                        C AS (
                                        SELECT * FROM 
                                        (SELECT PRODUCT_CODECELL,ERRNEWCODE REASON_CODE,CREATE_DATE FROM SD_HIS_MESWORK WHERE REMARK='變更不良CODE'
                                        UNION ALL 
                                        SELECT PRODUCT_CODECELL,REASON_CODE,CREATE_DATE FROM SD_HIS_BRWNGMSG) A 
                                        WHERE A.PRODUCT_CODECELL='" + Usn + @"' AND (A.PRODUCT_CODECELL,A.CREATE_DATE) IN
                                        (SELECT B.PRODUCT_CODECELL,MAX( B.CREATE_DATE) FROM 
                                        (SELECT PRODUCT_CODECELL,ERRNEWCODE REASON_CODE,CREATE_DATE FROM SD_HIS_MESWORK WHERE REMARK='變更不良CODE'
                                        UNION ALL 
                                        SELECT PRODUCT_CODECELL,REASON_CODE,CREATE_DATE FROM SD_HIS_BRWNGMSG) B 
                                        WHERE A.PRODUCT_CODECELL=B.PRODUCT_CODECELL GROUP BY B.PRODUCT_CODECELL)
                                        )                                            
                                        SELECT A.MO_TYPE,A.PRODUCT_CODECELL,A.PRODUCT_FPC,A.PRODUCT_BL,B.STEP_ID,B.REASON_CODE,(CASE WHEN B.CREATE_DATE<C.CREATE_DATE THEN C.REASON_CODE ELSE B.REASON_CODE END),'" + user + @"','" + ip + @"','"+ page +@"',SYSDATE 
                                        FROM A LEFT JOIN B ON A.PRODUCT_CODECELL=B.PRODUCT_CODECELL LEFT JOIN C ON A.PRODUCT_CODECELL=C.PRODUCT_CODECELL";

            }
            else if (Fab == "Fab3")
            {

                sql = @"INSERT INTO BRWFUPANTMP
WITH A AS(
SELECT A.USN,B.CODEID,A.SMALLSTAGE,A.ERRORCODE,A.RAERRORCODE FROM SFCUSNDEFECT A,SFCUPNINFO B WHERE (A.USN,A.DEFECTDATE) IN (
SELECT USN,MAX(DEFECTDATE) FROM SFCUSNDEFECT WHERE USN = '" + Usn + @"'
GROUP BY USN) AND A.UPN = B.UPN),
 B AS(
SELECT USN,PRODUCTLABEL FPC FROM SFCUSNPRODUCTLABEL WHERE USN = '" + Usn + @"' AND PRODUCTLABELTYPE='FPC'),
 C AS(
SELECT USN,PRODUCTLABEL BL FROM SFCUSNPRODUCTLABEL WHERE USN = '" + Usn + @"' AND PRODUCTLABELTYPE='BL')
SELECT A.USN,B.FPC,C.BL,A.SMALLSTAGE,A.ERRORCODE,A.RAERRORCODE,'" + user + @"','" + ip + @"','" + page + @"',SYSDATE FROM A,B,C WHERE A.USN = B.USN AND B.USN = C.USN";
            }
            DataTable dt = Repository.getdatatableMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }
    public static DataTable GetFPTable(string user, string ip, string page)
    {
        string sql = "SELECT CODEID,USN,PRODUCTFPC,PRODUCTBL,STEPID,NGREASON,BRWREASON FROM BRWFUPANTMP WHERE CREATEUSER='" + user + "' AND IP = '" + ip + "' AND WORKPAGE = '" + page + "' ORDER BY CREATEDATE DESC";
        DataTable dt = Repository.getdatatableMES(sql);
        return dt;
    }
    #endregion
    #region J01
    public static string geterrorcode1(string Fab)
    {
        string sqlrjtype = "";
        if (Fab == "Fab1/2")
        {
            sqlrjtype = "SELECT DISTINCT   A.CODE_ID || '-' || B.CODE_NAME ERRORCODE1 FROM SD_BASE_CODSTEP A, SD_BASE_CODE B WHERE A.CODE_ID = B.CODE_ID AND A.STEP_ID = 'BRW' ORDER BY ERRORCODE1";
        }
        if (Fab == "Fab3")
        {
            sqlrjtype = "SELECT DISTINCT ERRORCODE||'-'||DESCRIPTION ERRORCODE1 FROM SFCERRORCODE ORDER BY ERRORCODE1";
        }
        DataTable dtrjtype = Repository.getdatatableMES(sqlrjtype);
        string rtn = JsonConvert.SerializeObject(dtrjtype);
        return rtn;
    }
    public static DataTable getcount(string SEMIUPN, string STATUS)
    {

        string sqlrjtype = "SELECT A.QTY AS COUNT FROM SFCNGCARTONQTY A,SFCUPNINFO B WHERE B.UPN='" + SEMIUPN + "' AND A.CPADH='" + STATUS + "' AND A.GLASSTYPE=B.GLASSTYPE AND A.CODEID=B.CODEID";
        DataTable dtrjtype = Repository.getdatatableMES(sqlrjtype);
        return dtrjtype;
    }
    public static DataTable getdabao(string USN)
    {

        string sqlrjtype = "SELECT * FROM BRWREJECTED WHERE USN='" + USN + "'AND ISDELETE='N'";
        DataTable dtrjtype = Repository.getdatatableMES(sqlrjtype);
        return dtrjtype;
    }
    public static DataTable getusn(string USN)
    {
        string getusn = "";
        if(Fab=="Fab3")
        {
            getusn = "SELECT A.MO, C. SEMIUPN, B.DESCRIPTION AS STATUS, A.USN, A.ERRORCODE ,D.CODEID FROM SFCUSNDEFECT A, SFCCPADHSTATUS B,SFCMOADHSEMIUPN C,SFCUPNINFO D WHERE A.USN ='" + USN + "'AND A.MO=C.MO AND C.SEMIUPN=D.UPN AND A.CPADHSTATUSID=C.CPADHSTATUSID AND A.CPADHSTATUSID = B.CPADHSTATUSID AND A.DEFECTDATE IN (SELECT MAX(DEFECTDATE) FROM SFCUSNDEFECT C WHERE A.USN = C.USN)";
        }
        DataTable dtrjtype = Repository.getdatatableMES(getusn);
        return dtrjtype;
    }
    public static DataTable getloc99(string CODEID, string STATUS, string ERRORCODE,string LOC)
    {
        string getusn = "";
        if (Fab == "Fab3")
        {
            getusn = "SELECT * FROM SFCERRCODESTORAGELOC WHERE CODEID='" + CODEID + "'AND CPADH='" + STATUS + "'AND ERRORCODE='" + ERRORCODE + "'AND STORAGELOC='" + LOC + "' ";
        }
        if(Fab=="Fab1/2")
        {
            getusn = "SELECT * FROM SD_OP_REPAIRSTORE WHERE PRODUCT_TYPE='" + CODEID + "'AND PRODUCT_STATUS='" + STATUS + "'AND REASON_CODE='" + ERRORCODE + "'AND STORE_LOC='" + LOC + "'";
        }
        DataTable dtrjtype = Repository.getdatatableMES(getusn);
        return dtrjtype;
    }

    public static DataTable getloc98(string CODEID, string STATUS, string ERRORCODE)
    {
        string getusn = "";
        if (Fab == "Fab3")
        {
            getusn = "SELECT STORAGELOC FROM SFCERRCODESTORAGELOC WHERE CODEID='" + CODEID + "'AND CPADH='" + STATUS + "'AND ERRORCODE='" + ERRORCODE + "'";
        }
        if (Fab == "Fab1/2")
        {
            getusn = "SELECT STORE_LOC STORAGELOC FROM SD_OP_REPAIRSTORE WHERE PRODUCT_TYPE='" + CODEID + "'AND PRODUCT_STATUS='" + STATUS + "'AND REASON_CODE='" + ERRORCODE + "'";
        }
        DataTable dtrjtype = Repository.getdatatableMES(getusn);
        return dtrjtype;
    }

    public static DataTable getloc97(string CODEID, string STATUS, string ERRORCODE,string page)
    {
        string getusn = "";
        if (Fab == "Fab3")
        {
            getusn = "SELECT * FROM BRWBASETYPE WHERE CODEID='" + CODEID + "'AND STATUS='" + STATUS + "'AND LOC='" + ERRORCODE + "'AND WORKPAGE='" + page + "'";
        }
        DataTable dtrjtype = Repository.getdatatableMES(getusn);
        return dtrjtype;
    }
    public static bool insertTMP(string MO,string USN,string SEMIUPN,string STATUS,string LOC,string lh_user,string Ip,string ERRORCODE)
    {
        try
        {

            string sql = @"INSERT INTO BRWREJECTEDTMP(MO,USN,UPN,STATUS,LOC,CREATEUSER,IP,CREATEDATE,WORKPAGE,DEFFECTCODE)VALUES('" + MO + "','" + USN + "','" + SEMIUPN + "','" + STATUS + "','" + LOC + "','" + lh_user + "','" + Ip + "',SYSDATE,'J01','" + ERRORCODE + "')";
                Repository.getdatatablenoreturnMES(sql);
                return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }
    public static DataTable show789(string lh_user, string Ip,string page)
    {
        string sql12 = "SELECT MO,USN,UPN,STATUS,LOC,DEFFECTCODE AS ERRORCODE FROM BRWREJECTEDTMP WHERE CREATEUSER='" + lh_user + "'AND IP='" + Ip + "' AND WORKPAGE = '"+ page +"'";
        DataTable dt31 = Repository.getdatatableMES(sql12);
        return dt31;
    }
    public static DataTable show890(string lh_user, string Ip,string USN, string page)
    {
        string sql12 = "SELECT * FROM BRWREJECTEDTMP WHERE CREATEUSER='" + lh_user + "'AND IP='" + Ip + "' AND USN ='" + USN + "'AND WORKPAGE = '" + page + "'";
        DataTable dt31 = Repository.getdatatableMES(sql12);
        return dt31;
    }
    public static bool deleteProTMP(string lh_user, string Ip)
    {
        try
        {

            string sql = "DELETE FROM BRWREJECTEDTMP WHERE  CREATEUSER='" + lh_user + "'AND IP='" + Ip + "'";
            Repository.getdatatablenoreturnMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }
     public static bool btn_delPro2(string USN,string lh_user, string Ip)
    {
        try
        {

            string sql = "DELETE FROM BRWREJECTEDTMP WHERE USN='" + USN + "'AND  CREATEUSER='" + lh_user + "'AND IP='" + Ip + "'";
            Repository.getdatatablenoreturnMES(sql);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }

    }
     public static string CreateBrwcg1(string lh_user, string Ip)
     {
         string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
         DataTable dtdata = Repository.getdatatableMES(sqldate);
         string backid = dtdata.Rows[0][0].ToString();
         string m = "";
         string sqlcheck = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
         DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
         if (dtcheck.Rows[0][0].ToString() != "")
         {
             m = dtcheck.Rows[0][0].ToString();
         }
         backid = "M" + backid  + m;
         string sqlma = "SELECT * FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + backid + "'";
         DataTable dt = Repository.getdatatableMES(sqlma);
         if (dt.Rows.Count > 0)
         {
             string sqlserial = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
             DataTable dtserial = Repository.getdatatableMES(sqlserial);
             backid = "M" + backid  + dtserial.Rows[0][0].ToString();
         }

         return backid;
     }
     public static DataTable getupncode(string lh_user, string Ip)
     {
         string getusn = "";
         if (Fab == "Fab3")
         {
              getusn = "SELECT CODEID FROM SFCUPNINFO WHERE UPN IN(SELECT DISTINCT UPN FROM BRWREJECTEDTMP WHERE CREATEUSER='" + lh_user + "'AND IP='" + Ip + "' )";
             
         }
         DataTable dtrjtype = Repository.getdatatableMES(getusn);
         return dtrjtype;
     }
     public static bool InsertButton1(string REJECTEDID, string CODEID, string lh_user,string Ip)
     {
         try
         {

             string sql = "INSERT INTO BRWREJECTEDMAIN SELECT DISTINCT '" + REJECTEDID + "',UPN,LOC,'0','N','','',CREATEUSER,SYSDATE,'','" + CODEID + "','','','J01',STATUS FROM BRWREJECTEDTMP WHERE CREATEUSER='" + lh_user + "'AND IP='" + Ip + "'";
             string sql1 = "INSERT INTO BRWREJECTED SELECT '" + REJECTEDID + "',USN,MO,STATUS,DEFFECTCODE,'',CREATEUSER,SYSDATE,'N'FROM BRWREJECTEDTMP WHERE CREATEUSER='" + lh_user + "'AND IP='" + Ip + "'";
             Repository.getdatatablenoreturnMES(sql);
             Repository.getdatatablenoreturnMES(sql1);
             return true;
         }
         catch (Exception ex)
         {
             return false;
         }

     }
     public static DataTable errstrSQL(string lh_user, string Ip, string ERRORCODE1)
     {
         string getusn = "SELECT * FROM BRWREJECTEDTMP WHERE CREATEUSER='" + lh_user + "'AND IP='" + Ip + "'AND DEFFECTCODE<>'" + ERRORCODE1 + "'";
         DataTable dtrjtype = Repository.getdatatableMES(getusn);
         return dtrjtype;
     }
     public static DataTable dttemp(string USN)
     {
         string sql12 = "SELECT * FROM SD_HIS_TEMPSTORE WHERE (PRODUCT_CODECELL,ORDER_NO) IN(SELECT PRODUCT_CODECELL,ORDER_NO FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + USN + "')";
         DataTable dt31 = Repository.getdatatableMES(sql12);
         return dt31;
     }

    #endregion
    #region R31
     public static string CreateBrwcg12(string lh_user, string Ip)
     {
         string sqldate = "select to_char(sysdate,'yyyymmdd') from dual";
         DataTable dtdata = Repository.getdatatableMES(sqldate);
         string backid = dtdata.Rows[0][0].ToString();
         string m = "";
         string sqlcheck = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
         DataTable dtcheck = Repository.getdatatableMES(sqlcheck);
         if (dtcheck.Rows[0][0].ToString() != "")
         {
             m = dtcheck.Rows[0][0].ToString();
         }
         backid = "3" + backid + m;
         string sqlma = "SELECT * FROM BRWREJECTEDMAIN WHERE REJECTEDID='" + backid + "'";
         DataTable dt = Repository.getdatatableMES(sqlma);
         if (dt.Rows.Count > 0)
         {
             string sqlserial = " select lpad(TEMP_BRWLOT.nextval,4,'0') from dual";
             DataTable dtserial = Repository.getdatatableMES(sqlserial);
             backid = "3" + backid + dtserial.Rows[0][0].ToString();
         }

         return backid;
     }
     #endregion
    #region R12
        public static string GetstatusR12(string Fab)
        {
            string rtn = "";
            string strSQL = "";
            if (Fab == "Fab1/2")
            {
                strSQL = @"SELECT DISTINCT PART_STATUS STATUS  FROM SD_BASE_ORDERPART WHERE  PART_STATUS IN('FOF','D-FLEX','MR-CELL','CGL','T-FLEX','PANEL','成品','CELL','COG','U-FLEX','FOG','CA','COF','GRINDING','TERMINAL CUT','成品無印字')
    ORDER BY PART_STATUS";
            }
            if (Fab == "Fab3")
            {
                strSQL = "SELECT  DESCRIPTION AS STATUS FROM SFCCPADHSTATUS";
            }
            DataTable dtrjtype = Repository.getdatatableMES(strSQL);
            rtn = JsonConvert.SerializeObject(dtrjtype);
            return rtn;
        }

        public static DataTable CheckDutyR12(string user,string duty)
        {
            string sqlinserttmp = "SELECT * FROM SD_TMP_BRWNGDUTY WHERE USER_ID='" + user + "' AND DUTY='" + duty + "' and flag='Y'";
            DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
            return dtinserttmp;

        }

        public static string GetDutyR12()
        {
            string ngSql = @"SELECT '重工責' DUTY FROM DUAL
    UNION ALL 
    SELECT '物料責' DUTY FROM DUAL
    UNION ALL 
    SELECT '規格緩' DUTY FROM DUAL
    UNION ALL 
    SELECT 'Loca責' DUTY FROM DUAL
    UNION ALL 
    SELECT 'Fab3作業' DUTY FROM DUAL
    UNION ALL 
    SELECT 'B50作業' DUTY FROM DUAL
    UNION ALL 
    SELECT '其他' DUTY FROM DUAL";
            DataTable dtcode = Repository.getdatatableMES(ngSql);
            string rtn = JsonConvert.SerializeObject(dtcode);
            return rtn;
        }

        public static DataTable CheckHavNGR12(string lotno, string stepmid,string usn)
        {
            string sqlinserttmp = "SELECT * FROM BRWNGMSG WHERE LOTNO='"+ lotno +"' AND STEPMID='"+ stepmid +"' AND USN='"+ usn +"'";
            DataTable dtinserttmp = Repository.getdatatableMES(sqlinserttmp);
            return dtinserttmp;

        }

        public static DataTable GetReceiveFlagR12(string Lot)
        {
            string sql2 = @"SELECT A.PROCESSNAME,C.CODEID,A.MO,A.LOTQTY,A.STEPCURRENT,A.STATUS FROM BRWLOT A
 LEFT JOIN SFCMO B ON A.MO = B.MO
 LEFT JOIN SFCUPNINFO C ON B.UPN = C.UPN WHERE A.LOTNO='" + Lot + @"' AND A.RECEIVEFLAG='Y'
            ";
            DataTable dt2 = Repository.getdatatableMES(sql2);
            return dt2;
        }

        public static DataTable GetBrwStepmIdR12(string lot, string CodeId)
        {
            string ngSql = @"SELECT B.BRWSTEPID,B.BRWSTEP FROM BRWLOT A
 LEFT JOIN BRWBASEPRO B ON A.PROCESSNAME = B.BRWPROCESSID
 WHERE B.CODEID = '"+ CodeId +@"' AND A.STATUS = B.STATUS AND A.LOTTYPE = B.ZBTYPE
 AND A.LOTNO='"+ lot +@"'
 ORDER BY ITEM";
            DataTable dtcode = Repository.getdatatableMES(ngSql);
            return dtcode;
        }

        public static DataTable GetBrwStepmR12(string lot, string CodeId)
        {
            string ngSql = @"SELECT B.BRWSTEPID,B.BRWSTEP FROM BRWLOT A
 LEFT JOIN BRWBASEPRO B ON A.PROCESSNAME = B.BRWPROCESSID
 WHERE B.CODEID = '" + CodeId + @"' AND A.STATUS = B.STATUS AND A.LOTTYPE = B.ZBTYPE
 AND A.LOTNO='" + lot + @"'
 ORDER BY ITEM";
            DataTable dtcode = Repository.getdatatableMES(ngSql);
            return dtcode;
        }

        public static DataTable GetNextStepR12(string code_id ,string processname,string status,string duty,string item)
        {
            string sql2 = " SELECT * FROM BRWBASEPRO WHERE CODEID = '" + code_id + "' AND BRWPROCESSID='" + processname + "' AND STATUS='" + status + "' AND ZBTYPE='" + duty + "' AND ITEM = '" + item + "'";
            DataTable dt2 = Repository.getdatatableMES(sql2);
            return dt2;
        }

        public static string MoveOutR12(string str_Lot, int in_qty, int out_qty, string stepId,string changstatus,string Page,string user,string nextstep,string id,string currentid)
        {
            string rtn = "";
            OracleConnection con = dbcon();
            OracleTransaction ots;
            con.Open();
            ots = con.BeginTransaction();
            try
            {
                OracleCommand cmd1 = new OracleCommand("INSERT INTO BRWNGMSG (LOTNO, USN, DEFECTCODE,STEPID, STEPMID,CREATEUSER,CREATEDATE,REMARK,DUTY,STATUS)  SELECT LOTNO , USN, DEFECTCODE, STEPID, STEPMID,CREATEUSER,CREATEDATE,REMARK,DUTY," + changstatus + " FROM BRWNGMSGTMP WHERE LOTNO = '" + str_Lot + "' ", con);

                OracleCommand cmd11 = new OracleCommand(@"INSERT INTO BRWLOTOPERMSG(LOTNO,STEPID,STEPMID,EQPID,CREATEUSER,CREATEDATE,INQTY,OUTQTY,WORKPAGE) 
                                        values('" + str_Lot + "','" + stepId + "','" + stepId + "','" + currentid + "','" + user + "',sysdate,'" + in_qty + "','" + out_qty + "','" + Page + "') ", con);

                OracleCommand cmd2 = new OracleCommand("UPDATE BRWLOT SET LOTQTY=" + out_qty + ",STEPCURRENT='" + nextstep + "',STEPCURRENTID='" + id + "' WHERE LOTNO ='" + str_Lot + "'", con);

                OracleCommand cmd3 = new OracleCommand("UPDATE BRWLOTDETAIL SET FLAG='N' WHERE LOTNO ='" + str_Lot + "' AND USN IN (SELECT USN FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "')", con);

                OracleCommand cmd4 = new OracleCommand("UPDATE BRWUSNINFO A SET A.NEWDEFFECTCODE=(SELECT DISTINCT B.DEFECTCODE FROM BRWNGMSGTMP B WHERE A.USN=B.USN ) WHERE (A.USN) IN(SELECT USN FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "')", con);
                
                OracleCommand cmd5 = new OracleCommand("DELETE FROM BRWNGMSGTMP WHERE LOTNO='" + str_Lot + "'", con);

                cmd1.Transaction = ots;
                cmd11.Transaction = ots;
                cmd2.Transaction = ots;
                cmd3.Transaction = ots;
                cmd4.Transaction = ots;
                cmd5.Transaction = ots;
                cmd1.ExecuteNonQuery();
                cmd11.ExecuteNonQuery();
                cmd2.ExecuteNonQuery();
                cmd3.ExecuteNonQuery();
                cmd4.ExecuteNonQuery();
                cmd5.ExecuteNonQuery();
                ots.Commit();
                con.Close();
                rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬成功\"}]";
            }
            catch
            {
                ots.Rollback();
                con.Close();
                rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"過賬失敗\"}]";
            }
            return rtn;
        }
        #endregion
    #region R06
    public static DataTable GetCgColor(string Upn)
    {
        string sqlcgcolor = "SELECT * FROM SD_BASE_CODECOLOR WHERE PRODUCT_ID='" + Upn + "'";
        DataTable dtcgcolor = Repository.getdatatableMES(sqlcgcolor);
        return dtcgcolor;
    }
    public static DataTable GetReportLot(string LotNo)
    {
        string sqllot = "";
        if (Fab == "Fab1/2")
        {
            sqllot = @"SELECT * FROM SD_OP_REPORTLOT WHERE LOT_ID = '" + LotNo + "'";
        }
        if (Fab == "Fab3")
        {
            sqllot = @"SELECT * FROM SFCOKLOT WHERE LOTNO = '" + LotNo + "'";
        }
        DataTable dtlot = Repository.getdatatableMES(sqllot);
        return dtlot;
    }
    public static DataTable GetRepairType(string CodeId, string DefectCode, string Status)
    {
        string sqlrep = "SELECT * FROM SD_BASE_REPAIRTYPE WHERE CODE_ID='" + CodeId + "' AND REASON_CODE='" + DefectCode + "' AND STATUS='" + Status + "' AND FLAG='Y'";
        DataTable dtrep = Repository.getdatatableMES(sqlrep);
        return dtrep;
    }

    public static DataTable GetStatusName(string Status)
    {
        string sqlrep = "SELECT STATUSNAME FROM BRWSTATUS WHERE STATUSID = '" + Status + "'";
        DataTable dtrep = Repository.getdatatableMES(sqlrep);
        return dtrep;
    }

    public static bool InsertBrwReceiveTmp(string Mo, string Upn, string Usn, string Ip, string User, string StepFrom, string DefectCode, string StatusType, string ReceiveType, string RepairType)
    {
        try
        {
            string sqlreceivetmp = @"INSERT INTO BRWRECEIVETMP(MO,UPN,USN,IP,CREATEUSER,CREATEDATE,STEPFROM,DEFECTCODE,STATUSTYPE,RECEIVETYPE,REPAIRTYPE)
                       VALUES('" + Mo + "','" + Upn + "','" + Usn + "','" + Ip + "','" + User + "',SYSDATE,'" + StepFrom + "','" + DefectCode + "','" + StatusType + "','" + ReceiveType + "','" + RepairType + "')";
            Repository.getdatatablenoreturnMES(sqlreceivetmp);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    public static DataTable GetHalfPartId(string Mo, string Status)
    {
        string sqllot = "";
        if (Fab == "Fab1/2")
        {
            sqllot = @"SELECT DISTINCT PART_ID HALFPARTID  FROM SD_BASE_ORDERPART A,BRWSTATUS B WHERE B.STATUSNAME=A.PART_STATUS AND A.ORDER_NO='" + Mo + "' AND B.STATUSID='" + Status + "' AND A.FLAG ='1'";
        }
        if (Fab == "Fab3")
        {
            sqllot = @"SELECT DISTINCT SEMIUPN HALFPARTID FROM SFCMOADHSEMIUPN where mo='" + Mo + "' and cpadhstatusid ='" + Status + "'";
        }
        DataTable dtlot = Repository.getdatatableMES(sqllot);
        return dtlot;

    }

    public static bool DelReceiveTmp(string Usn, string Ip, string User)
    {
        try
        {
            if (Usn == "NA")
            {
                string sql = @"DELETE FROM BRWRECEIVETMP WHERE CREATEUSER='" + User + "' AND IP='" + Ip + "'";
                Repository.getdatatablenoreturnMES(sql);
                return true;
            }
            else
            {
                string sql = @"DELETE FROM BRWRECEIVETMP WHERE USN ='" + Usn + "' AND CREATEUSER='" + User + "' AND IP='" + Ip + "'";
                Repository.getdatatablenoreturnMES(sql);
                return true;
            }
        }
        catch (Exception ex)
        {
            return false;
        }

    }

    public static DataTable GetReceiveTmp(string Usn, string User, string Ip)
    {
        string rtwhere = "";
        if (Usn != "NA")
        {
            rtwhere = rtwhere + "AND USN='" + Usn + "'";
        }
        if (User != "NA")
        {
            rtwhere = rtwhere + "AND CREATEUSER='" + User + "'";
        }
        if (Ip != "NA")
        {
            rtwhere = rtwhere + "AND IP='" + Ip + "'";
        }
        string sqlsn = "SELECT * FROM BRWRECEIVETMP WHERE 1=1 " + rtwhere;
        DataTable dtsn = Repository.getdatatableMES(sqlsn);
        return dtsn;
    }

    public static string MoveOutR06(string User, string Ip)
    {
        string rtn = "";
        OracleConnection con = dbcon();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();
        try
        {
            OracleCommand cmd1 = new OracleCommand(@"UPDATE BRWUSNINFO A SET A.RECEIVEFLAG ='Y', A.RECEIVEUSER = '" + User + @"', A.RECEIVEDATE = SYSDATE,A.ITEMTYPE='NEWRECEIVE',A.REPAIRTYPEFLAG='Y',
                                                        A.STATUS= (SELECT DISTINCT B.STATUSTYPE FROM BRWRECEIVETMP B WHERE  B.IP ='" + Ip + @"' AND A.USN = B.USN AND A.MO = B.MO),
                                                        A.REPAIRTYPE = (SELECT DISTINCT B.REPAIRTYPE FROM BRWRECEIVETMP B WHERE  B.IP ='" + Ip + @"' AND A.USN = B.USN AND A.MO = B.MO)
                                                         WHERE (A.USN,A.MO) IN (SELECT USN,MO FROM BRWRECEIVETMP WHERE IP = '" + Ip + @"')", con);
            //if (Fab == "Fab1/2")
            //{
            //    OracleCommand cmd2 = new OracleCommand("UPDATE SD_OP_PRODUCTSTATUS SET PRODUCT_STATUS='B',STEP_ID='BRW' WHERE (ORDER_NO,PRODUCT_CODECELL) IN (SELECT MO,USN FROM BRWRECEIVETMP WHERE IP='" + Ip + "')", con);
            //    cmd2.Transaction = ots;
            //    cmd2.ExecuteNonQuery();
            //}
            OracleCommand cmd3 = new OracleCommand("DELETE BRWRECEIVETMP WHERE IP ='" + Ip + "'", con);
            cmd1.Transaction = ots;
            cmd1.ExecuteNonQuery();
            cmd3.Transaction = ots;
            cmd3.ExecuteNonQuery();
            ots.Commit();
            con.Close();
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"點收成功\"}]";
        }
        catch
        {
            ots.Rollback();
            con.Close();
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"點收失敗\"}]";
        }
        return rtn;
    }
    #endregion R06
    #region R08
    public static string getlocR08(string type,string Page)
    {
        string sqlrepairtype = "SELECT DISTINCT LOC FROM BRWBASETYPE WHERE WORKPAGE ='" + Page + "' AND STATUS='" + type + "' ORDER BY LOC";
        DataTable dtrepairtype = Repository.getdatatableMES(sqlrepairtype);
        string rtn = JsonConvert.SerializeObject(dtrepairtype);
        return rtn;
    }

    public static string gettypeR08(string Page)
    {
        string sqlrepairtype = "SELECT DISTINCT STATUS,DESCRIPTIONID FROM BRWBASETYPE WHERE WORKPAGE ='" + Page + "' ORDER BY STATUS";
        DataTable dtrepairtype = Repository.getdatatableMES(sqlrepairtype);
        string rtn = JsonConvert.SerializeObject(dtrepairtype);
        return rtn;
    }

    #endregion 
}
