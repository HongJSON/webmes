using System;
using System.Data;
using System.Web;
using Newtonsoft.Json;
using MesRepository;


using DataHelper;
using System.Security;
using System.Web.UI;
using System.Drawing.Text;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient;
using System.IO;
using System.Collections.Generic;

/// <summary>
/// 基础数据CRUD
/// </summary>
public class BaseServices
{
    string user = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    static string Fab = System.Configuration.ConfigurationManager.AppSettings["Fab"].ToString();
    public BaseServices()
    {

    }
    //查詢USN的11碼
    public static DataTable GetChip(string Usn)
    {
        string strSQL = "SELECT GET_PCS_CHIP('" + Usn + "') FROM DUAL";
        DataTable dtss = Repository.getdatatableMES(strSQL);
        
        return dtss;
    }

    public static DataTable GetUsnInfo(string Usn)
    {
        string strSQL = "";
        if(Fab=="Fab1/2")
         {
             strSQL = "SELECT PRODUCT_CODECELL USN,LOT_ID LOTNO,ORDER_NO MO,PRODUCT_ID UPN,PRODUCT_STATUS STATUS FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + Usn + "'";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT USN,LOTNO,MO,UPN,STATUS FROM SFCUSN WHERE USN='" + Usn + "'";
        }
        DataTable dtss = Repository.getdatatableMES(strSQL);

        return dtss;
    }

    public static DataTable GetMoInfo(string Mo)
    {
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT ORDER_NO MO,MOTYPE,PRODUCT_ID UPN,CELL_COME GLASSTYPE,MO_TYPE CODEID FROM SD_OP_WORKORDER WHERE ORDER_NO='" + Mo + "'";
        }
        if (Fab == "Fab3")
        {
            strSQL = " SELECT A.MO,A.MOTYPE,A.UPN,B.GLASSTYPE,B.CODEID FROM SFCMO A LEFT JOIN SFCUPNINFO B ON A.UPN=B.UPN WHERE MO='" + Mo + "'";
        }
        DataTable dtss = Repository.getdatatableMES(strSQL);
        return dtss;
    }

    public static DataTable GetHoldInfo(string Usn)
    {
        string strSQL = "";
        if (Fab == "Fab1/2")
        {
            strSQL = "SELECT HOLD_USER HOLDUSERID,HOLD_REASON REASON FROM SD_OP_PCSHOLD WHERE FLAG ='Y' AND PRODUCT_CODECELL='" + Usn + "'";
        }
        if (Fab == "Fab3")
        {
            strSQL = "SELECT HOLDUSERID,REASON FROM SFCHOLD WHERE STATUS ='1' and USN='" + Usn + "'";
        }
        DataTable dtss = Repository.getdatatableMES(strSQL);
        return dtss;
    }

    //CHECK人員是否有效
    public static DataTable GetUser(string User)
    {
        string strSQL = "";
        strSQL = "SELECT * FROM SD_CAT_HRS WHERE USER_ID='" + User + "' AND FLAG='Y'";
        DataTable dtuser = Repository.getdatatableMES(strSQL);
        return dtuser;
    }

    //CHECK是否在庫
    public static string checkstoreloc(string sn)
    {
        string mesResult = "";
        string sqlStolc = "SELECT * FROM WMSIOENTITY@WOKLMS WHERE PLANT='F741' AND STATUS='2' AND USN='" + sn + "'";
        DataTable dtStolc = Repository.getdatatableMES(sqlStolc);
        if (dtStolc.Rows.Count > 0)
        {
            mesResult = "此產品在庫，不可作業";
        }
        else
        {
            string sqlStolc1 = "SELECT * FROM WMSIOENTITY@WOKLMS WHERE PLANT='F741' AND STATUS='2' AND CARTONID='" + sn + "'";
            DataTable dtStolc1 = Repository.getdatatableMES(sqlStolc1);
            if (dtStolc1.Rows.Count > 0)
            {
                mesResult = "此箱號在庫，不可作業";
            }
        }
        return mesResult;
    }
    //20170930   B類異常產品  季宏斌
    public static string checkBNG(string idname, string chipID, string ipAddr, string userid)
    {
        string msgPRT = "NA";
        string checktmpB = "";
        string checktmp = "";
        string is_f56 = "SELECT DISTINCT B.MO_TYPE FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.ORDER_NO=B.ORDER_NO AND A.PRODUCT_CODECELL='" + chipID + "'AND  B.ORDER_NO NOT IN ('000029317011','000029317010','000029317007','000029317008','000091655843','000091675972','000091675973','000091675974','000091675975')";
        DataTable dt_f56 = PubClass.getdatatableMES(is_f56);
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

                DataTable dtchecktmp = PubClass.getdatatableMES(checktmp);
                DataTable dtchecktmpB = PubClass.getdatatableMES(checktmpB);
                string checksn = "SELECT SN FROM SD_TMP_BERRCODE WHERE FLAG='Y' AND SN='" + chipID + "'";
                DataTable dtchecksn = PubClass.getdatatableMES(checksn);
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
    //获取刷入产品的半品料号
    public static string getProductID(string mType, string chipID, string order_no)
    {
        string productID = "NA";
        //string xBrwInfo = "";
        string str_code = "";
        string Ftype = "SELECT MO_TYPE  FROM SD_OP_WORKORDER WHERE ORDER_NO='" + order_no + "'";
        DataTable dtType = PubClass.getdatatableMES(Ftype);
        if (dtType.Rows.Count > 0)
        {
            str_code = dtType.Rows[0]["MO_TYPE"].ToString();
        }
        if (str_code == "F56")
        {
            if (mType == "D-FLEX" || mType == "U-FLEX" || mType == "T-FLEX")//FOG user不需要做維護
            {

                string Info = "SELECT DISTINCT PART_ID FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + mType + "'AND FLAG=1 AND PART_ID LIKE 'PZ%'";//半品
                DataTable dtInfo2 = PubClass.getdatatableMES(Info);
                if (dtInfo2.Rows.Count > 0)
                {
                    productID = dtInfo2.Rows[0]["PART_ID"].ToString();
                    //xBrwInfo = "此料號為B22頁面維修室維護后帶出";
                }
                else
                {
                    string sqlPid = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + chipID + "' AND B.ORDER_NO=A.SENCONDMO ";
                    DataTable dtPid = PubClass.getdatatableMES(sqlPid);
                    if (dtPid.Rows.Count > 0)
                    {
                        productID = dtPid.Rows[0]["PRODUCT_ID"].ToString();
                    }
                }
                //增加发料表check
            }
            else
            {
                //COG
                if (mType == "COG")
                {
                    string pro = "";
                    //先獲取FOG料號，根據FOG料號找到對應的COG料號
                    string sqlPid = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + chipID + "' AND B.ORDER_NO=A.SENCONDMO ";
                    DataTable dtPid = PubClass.getdatatableMES(sqlPid);
                    if (dtPid.Rows.Count > 0)
                    {
                        pro = dtPid.Rows[0]["PRODUCT_ID"].ToString();
                        //
                        string cogSQL = "SELECT  COG_PART  FROM SD_BASE_FCPART WHERE FOG_PART='" + pro + "' AND FLAG='Y'";
                        DataTable dtCog = PubClass.getdatatableMES(cogSQL);
                        if (dtCog.Rows.Count > 0)
                        {
                            productID = dtCog.Rows[0]["COG_PART"].ToString();
                            //xBrwInfo = "此料號為B108頁面維護";
                        }
                        else
                        {
                            string scheck = "SELECT  PART_ID  FROM SD_BASE_ORDERPART WHERE PART_STATUS='COG' AND ORDER_NO='" + order_no + "'";
                            DataTable second = PubClass.getdatatableMES(scheck);
                            if (second.Rows.Count > 0)
                            {
                                productID = second.Rows[0]["PART_ID"].ToString();
                                //xBrwInfo = "此料號為B22頁面維護";
                            }
                        }
                    }
                    else
                    {
                        string Info = "SELECT DISTINCT PART_ID FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + mType + "'AND FLAG=1 AND PART_ID LIKE 'PZ%'";//半品
                        DataTable dtInfo2 = PubClass.getdatatableMES(Info);
                        if (dtInfo2.Rows.Count > 0)
                        {
                            pro = dtInfo2.Rows[0]["PART_ID"].ToString();
                            string cogSQL = "SELECT  COG_PART  FROM SD_BASE_FCPART WHERE FOG_PART='" + pro + "' AND FLAG='Y'";
                            DataTable dtCog = PubClass.getdatatableMES(cogSQL);
                            if (dtCog.Rows.Count > 0)
                            {
                                productID = dtCog.Rows[0]["COG_PART"].ToString();
                                //xBrwInfo = "此料號為B108頁面維護";
                            }
                            else
                            {
                                string scheck = "SELECT  PART_ID  FROM SD_BASE_ORDERPART WHERE PART_STATUS='COG' AND ORDER_NO='" + order_no + "'";
                                DataTable second = PubClass.getdatatableMES(scheck);
                                if (second.Rows.Count > 0)
                                {
                                    productID = second.Rows[0]["PART_ID"].ToString();
                                    //xBrwInfo = "此料號為B22頁面維護";
                                }
                            }
                        }
                    }

                }
                else
                {
                    string Info = "SELECT DISTINCT PART_ID FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + mType + "'AND FLAG=1 AND PART_ID LIKE 'PZ%'";//半品
                    DataTable dtInfo2 = PubClass.getdatatableMES(Info);
                    if (dtInfo2.Rows.Count > 0)
                    {
                        productID = dtInfo2.Rows[0]["PART_ID"].ToString();
                        //xBrwInfo = "此料號為B22頁面維護";
                    }
                    else
                    {
                        string info = "SELECT DISTINCT PART_ID FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + mType + "'AND FLAG=1";//成品
                        DataTable dtInfo = PubClass.getdatatableMES(info);
                        if (dtInfo.Rows.Count > 0)
                        {
                            productID = dtInfo.Rows[0]["PART_ID"].ToString();
                            //xBrwInfo = "此料號為B22頁面維護";
                        }
                    }
                }
            }
        }
        else
        {
            //除了F56之外的都是B22頁面維護的
            string info = "SELECT DISTINCT PART_ID FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + mType + "'AND FLAG=1";
            DataTable dtInfo = PubClass.getdatatableMES(info);
            if (dtInfo.Rows.Count > 0)
            {
                productID = dtInfo.Rows[0]["PART_ID"].ToString();
                //xBrwInfo = "此料號為B22頁面維護";
            }
        }
        return productID;
    }
    //F56 检查印字规则一致
    public static string checkPrintRule(string page, string status, string order_no, string chipID, string ipAddr)
    {
        string msgPRT = "NA";
        string mo_type = "";
        string tmpLotSYS = "";
        string nowLOT = "";
        string moType = "SELECT MO_TYPE  FROM SD_OP_WORKORDER WHERE ORDER_NO='" + order_no + "'";
        DataTable dtType = PubClass.getdatatableMES(moType);
        if (dtType.Rows.Count > 0)
        {
            mo_type = dtType.Rows[0]["MO_TYPE"].ToString();
        }
        if (status == "成品無印字" && mo_type == "F56")
        {
            if (page == "R06" || page == "R20")
            {
                string sqlP = "SELECT *FROM SD_TMP_BRWRECEIVE WHERE   USER_IP ='" + ipAddr + "'";
                DataTable dtP = PubClass.getdatatableMES(sqlP);
                if (dtP.Rows.Count > 0)
                {
                    //先check lot印字规则是否一致 临时表中的
                    string tmpLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,C.SYSID,B.CREATE_DATE FROM SD_TMP_BRWRECEIVE A,SD_OP_BRWINFO B,SD_OP_NEWCODE_F56_LOT  C  WHERE  A.USER_IP ='" + ipAddr + "' AND A.PRODUCT_CODECELL=B.PRODUCT_CODECELL AND B.LOT_ID=C.LOT_ID  AND  B.ORDER_NO<>'ZMPD' ORDER BY  B.CREATE_DATE  DESC";
                    DataTable dtLot = PubClass.getdatatableMES(tmpLot);
                    if (dtLot.Rows.Count > 0)
                    {
                        tmpLotSYS = dtLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string sysID = "SELECT  A.ORDER_NO,B.SYSID FROM SD_TMP_BRWRECEIVE A,SD_OP_WORKORDER B  WHERE  A.USER_IP ='" + ipAddr + "' AND A.ORDER_NO=B.ORDER_NO ORDER BY  A.CREATE_DATE  DESC";
                        DataTable dtSys = PubClass.getdatatableMES(sysID);
                        if (dtSys.Rows.Count > 0)
                        {
                            tmpLotSYS = dtSys.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "临时表中产品无印字规则";
                        }

                    }
                    //当前刷入的
                    string nowLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,B.SYSID,A.CREATE_DATE FROM SD_OP_BRWINFO A,SD_OP_NEWCODE_F56_LOT  B  WHERE   A.PRODUCT_CODECELL='" + chipID + "' AND A.LOT_ID=B.LOT_ID  AND  A.ORDER_NO<>'ZMPD' ORDER BY  A.CREATE_DATE  DESC";
                    DataTable DTnowLot = PubClass.getdatatableMES(nowLot);
                    if (DTnowLot.Rows.Count > 0)
                    {
                        nowLOT = DTnowLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string currentSysid = "SELECT A.ORDER_NO,A.SYSID,B.CREATE_DATE FROM SD_OP_WORKORDER A,SD_OP_BRWINFO B WHERE A.ORDER_NO=B.ORDER_NO AND   A.ORDER_NO<>'ZMPD' AND B.PRODUCT_CODECELL='" + chipID + "'ORDER BY  CREATE_DATE DESC";
                        DataTable dtCurrentSysid = PubClass.getdatatableMES(currentSysid);
                        if (dtCurrentSysid.Rows.Count > 0)
                        {
                            nowLOT = dtCurrentSysid.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "当刷入产品印字规则异常";
                        }
                    }
                    if (tmpLotSYS != nowLOT)
                    {
                        string printRule = "SELECT DISTINCT PPP,EEEE,R,BB,FFF,PP79,VV79 FROM  SD_BASE_NEWCODE_F56 WHERE SYSID IN('" + tmpLotSYS + "','" + nowLOT + "')";
                        DataTable dtPrint = PubClass.getdatatableMES(printRule);
                        if (dtPrint.Rows.Count != 1)
                        {
                            msgPRT = "刷入临时表中SYSID为" + tmpLotSYS + "当前产品印字规则为" + nowLOT + "";
                        }
                    }
                }
            }
            if (page == "R08" || page == "R31" || page == "R33" || page == "R37" || page == "Rcancel")
            {
                string sqlP = "SELECT *FROM SD_TMP_BRWTOMA WHERE   IP_ADDR ='" + ipAddr + "'";
                DataTable dtP = PubClass.getdatatableMES(sqlP);
                if (dtP.Rows.Count > 0)
                {
                    string tmpLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,C.SYSID,B.CREATE_DATE FROM SD_TMP_BRWTOMA A,SD_OP_BRWINFO B,SD_OP_NEWCODE_F56_LOT  C  WHERE  A.IP_ADDR ='" + ipAddr + "' AND A.PRODUCT_CODECELL=B.PRODUCT_CODECELL AND B.LOT_ID=C.LOT_ID  AND  B.ORDER_NO<>'ZMPD' ORDER BY  B.CREATE_DATE  DESC";
                    DataTable dtLot = PubClass.getdatatableMES(tmpLot);
                    if (dtLot.Rows.Count > 0)
                    {
                        tmpLotSYS = dtLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string sysID = "SELECT  A.ORDER_NO,B.SYSID FROM SD_TMP_BRWTOMA A,SD_OP_WORKORDER B  WHERE  A.IP_ADDR ='" + ipAddr + "' AND A.ORDER_NO=B.ORDER_NO ORDER BY  A.CREATE_DATE  DESC";
                        DataTable dtSys = PubClass.getdatatableMES(sysID);
                        if (dtSys.Rows.Count > 0)
                        {
                            tmpLotSYS = dtSys.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "临时表中产品无印字规则";
                        }

                    }
                    //当前刷入的
                    string nowLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,B.SYSID,A.CREATE_DATE FROM SD_OP_BRWINFO A,SD_OP_NEWCODE_F56_LOT  B  WHERE   A.PRODUCT_CODECELL='" + chipID + "' AND A.LOT_ID=B.LOT_ID  AND  A.ORDER_NO<>'ZMPD' ORDER BY  A.CREATE_DATE  DESC";
                    DataTable DTnowLot = PubClass.getdatatableMES(nowLot);
                    if (DTnowLot.Rows.Count > 0)
                    {
                        nowLOT = DTnowLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string currentSysid = "SELECT A.ORDER_NO,A.SYSID,B.CREATE_DATE FROM SD_OP_WORKORDER A,SD_OP_BRWINFO B WHERE A.ORDER_NO=B.ORDER_NO AND   A.ORDER_NO<>'ZMPD' AND B.PRODUCT_CODECELL='" + chipID + "'ORDER BY  CREATE_DATE DESC";
                        DataTable dtCurrentSysid = PubClass.getdatatableMES(currentSysid);
                        if (dtCurrentSysid.Rows.Count > 0)
                        {
                            nowLOT = dtCurrentSysid.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "当刷入产品印字规则异常";
                        }
                    }
                    if (tmpLotSYS != nowLOT)
                    {
                        string printRule = "SELECT DISTINCT PPP,EEEE,R,BB,FFF,PP79,VV79 FROM  SD_BASE_NEWCODE_F56 WHERE SYSID IN('" + tmpLotSYS + "','" + nowLOT + "')";
                        DataTable dtPrint = PubClass.getdatatableMES(printRule);
                        if (dtPrint.Rows.Count != 1)
                        {
                            msgPRT = "刷入临时表中SYSID为" + tmpLotSYS + "当前产品印字规则为" + nowLOT + "";
                        }
                    }
                }
            }
            //
            if (page == "Rreport")
            {
                string sqlP = "SELECT *FROM SD_TMP_BRWTOMAREPORT WHERE   IP_ADDR ='" + ipAddr + "'";
                DataTable dtP = PubClass.getdatatableMES(sqlP);
                if (dtP.Rows.Count > 0)
                {
                    string tmpLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,C.SYSID,B.CREATE_DATE FROM SD_TMP_BRWTOMAREPORT A,SD_OP_BRWINFO B,SD_OP_NEWCODE_F56_LOT  C  WHERE  A.IP_ADDR ='" + ipAddr + "' AND A.PRODUCT_CODECELL=B.PRODUCT_CODECELL AND B.LOT_ID=C.LOT_ID  AND  B.ORDER_NO<>'ZMPD' ORDER BY  B.CREATE_DATE  DESC";
                    DataTable dtLot = PubClass.getdatatableMES(tmpLot);
                    if (dtLot.Rows.Count > 0)
                    {
                        tmpLotSYS = dtLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string sysID = "SELECT  A.ORDER_NO,B.SYSID FROM SD_TMP_BRWTOMAREPORT A,SD_OP_WORKORDER B  WHERE  A.IP_ADDR ='" + ipAddr + "' AND A.ORDER_NO=B.ORDER_NO ORDER BY  A.CREATE_DATE  DESC";
                        DataTable dtSys = PubClass.getdatatableMES(sysID);
                        if (dtSys.Rows.Count > 0)
                        {
                            tmpLotSYS = dtSys.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "临时表中产品无印字规则";
                        }

                    }
                    //当前刷入的
                    string nowLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,B.SYSID,A.CREATE_DATE FROM SD_OP_BRWINFO A,SD_OP_NEWCODE_F56_LOT  B  WHERE   A.PRODUCT_CODECELL='" + chipID + "' AND A.LOT_ID=B.LOT_ID  AND  A.ORDER_NO<>'ZMPD' ORDER BY  A.CREATE_DATE  DESC";
                    DataTable DTnowLot = PubClass.getdatatableMES(nowLot);
                    if (DTnowLot.Rows.Count > 0)
                    {
                        nowLOT = DTnowLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string currentSysid = "SELECT A.ORDER_NO,A.SYSID,B.CREATE_DATE FROM SD_OP_WORKORDER A,SD_OP_BRWINFO B WHERE A.ORDER_NO=B.ORDER_NO AND   A.ORDER_NO<>'ZMPD' AND B.PRODUCT_CODECELL='" + chipID + "'ORDER BY  CREATE_DATE DESC";
                        DataTable dtCurrentSysid = PubClass.getdatatableMES(currentSysid);
                        if (dtCurrentSysid.Rows.Count > 0)
                        {
                            nowLOT = dtCurrentSysid.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "当刷入产品印字规则异常";
                        }
                    }
                    if (tmpLotSYS != nowLOT)
                    {
                        string printRule = "SELECT DISTINCT PPP,EEEE,R,BB,FFF,PP79,VV79 FROM  SD_BASE_NEWCODE_F56 WHERE SYSID IN('" + tmpLotSYS + "','" + nowLOT + "')";
                        DataTable dtPrint = PubClass.getdatatableMES(printRule);
                        if (dtPrint.Rows.Count != 1)
                        {
                            msgPRT = "刷入临时表中SYSID为" + tmpLotSYS + "当前产品印字规则为" + nowLOT + "";
                        }
                    }
                }
            }
            if (page == "R15")
            {
                string sqlP = "SELECT *FROM SD_TMP_BRWRECEIVE_CHAI WHERE   USER_IP ='" + ipAddr + "'";
                DataTable dtP = PubClass.getdatatableMES(sqlP);
                if (dtP.Rows.Count > 0)
                {
                    string tmpLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,C.SYSID,B.CREATE_DATE FROM SD_TMP_BRWRECEIVE_CHAI A,SD_OP_BRWINFO B,SD_OP_NEWCODE_F56_LOT  C  WHERE  A.USER_IP ='" + ipAddr + "' AND A.PRODUCT_CODECELL=B.PRODUCT_CODECELL AND B.LOT_ID=C.LOT_ID  AND  B.ORDER_NO<>'ZMPD' ORDER BY  B.CREATE_DATE  DESC";
                    DataTable dtLot = PubClass.getdatatableMES(tmpLot);
                    if (dtLot.Rows.Count > 0)
                    {
                        tmpLotSYS = dtLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string sysID = "SELECT  A.ORDER_NO,B.SYSID FROM SD_TMP_BRWRECEIVE_CHAI A,SD_OP_WORKORDER B  WHERE  A.USER_IP ='" + ipAddr + "' AND A.ORDER_NO=B.ORDER_NO ORDER BY  A.CREATE_DATE  DESC";
                        DataTable dtSys = PubClass.getdatatableMES(sysID);
                        if (dtSys.Rows.Count > 0)
                        {
                            tmpLotSYS = dtSys.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "临时表中产品无印字规则";
                        }

                    }
                    //当前刷入的
                    string nowLot = "SELECT  A.PRODUCT_CODECELL,B.LOT_ID,B.SYSID,A.CREATE_DATE FROM SD_OP_BRWINFO A,SD_OP_NEWCODE_F56_LOT  B  WHERE   A.PRODUCT_CODECELL='" + chipID + "' AND A.LOT_ID=B.LOT_ID  AND  A.ORDER_NO<>'ZMPD' ORDER BY  A.CREATE_DATE  DESC";
                    DataTable DTnowLot = PubClass.getdatatableMES(nowLot);
                    if (DTnowLot.Rows.Count > 0)
                    {
                        nowLOT = DTnowLot.Rows[0]["SYSID"].ToString();
                    }
                    else
                    {
                        string currentSysid = "SELECT A.ORDER_NO,A.SYSID,B.CREATE_DATE FROM SD_OP_WORKORDER A,SD_OP_BRWINFO B WHERE A.ORDER_NO=B.ORDER_NO AND   A.ORDER_NO<>'ZMPD' AND B.PRODUCT_CODECELL='" + chipID + "'ORDER BY  CREATE_DATE DESC";
                        DataTable dtCurrentSysid = PubClass.getdatatableMES(currentSysid);
                        if (dtCurrentSysid.Rows.Count > 0)
                        {
                            nowLOT = dtCurrentSysid.Rows[0]["SYSID"].ToString();
                        }
                        else
                        {
                            msgPRT = "当刷入产品印字规则异常";
                        }
                    }
                    if (tmpLotSYS != nowLOT)
                    {
                        string printRule = "SELECT DISTINCT PPP,EEEE,R,BB,FFF,PP79,VV79 FROM  SD_BASE_NEWCODE_F56 WHERE SYSID IN('" + tmpLotSYS + "','" + nowLOT + "')";
                        DataTable dtPrint = PubClass.getdatatableMES(printRule);
                        if (dtPrint.Rows.Count != 1)
                        {
                            msgPRT = "刷入临时表中SYSID为" + tmpLotSYS + "当前产品印字规则为" + nowLOT + "";
                        }
                    }
                }
            }
        }
        return msgPRT;
    }
    //F56  FOG和CGL料号一致卡控
    public static string checkGapMaterial(string page, string status, string order_no, string chipID, string ipAddr, string errcode = "NA")
    {
        string msgPart = "NA";
        string mo_type = "";
        string tmpsn = "";
        string cusn = "";
        string moType = "SELECT MO_TYPE  FROM SD_OP_WORKORDER WHERE ORDER_NO='" + order_no + "'";
        DataTable dtType = PubClass.getdatatableMES(moType);
        if (dtType.Rows.Count > 0)
        {
            mo_type = dtType.Rows[0]["MO_TYPE"].ToString();
        }
        #region R08/R31页面卡控K01指定產品狀態不良代碼单独打包.Nono.20190613
        if (page == "R08" || page == "R31")
        {
            string s_check = "SELECT * FROM SD_CHECK_ORDERBIND WHERE S_TYPE='BRWITEMREASON' AND L_TYPE = 1 AND IS_USE = 'Y' AND S_NGCODE = '" + errcode + "' AND PRODUCT_ITEM ='" + status + "'";
            DataTable dtscheck = PubClass.getdatatableMES(s_check);
            if (dtscheck.Rows.Count > 0)
            {
                string s_tmp_check = "SELECT * FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "' AND (REASON_CODE != '" + errcode + "' OR ITEM3 != '" + status + "')";
                DataTable dttmpcheck = PubClass.getdatatableMES(s_tmp_check);
                if (dttmpcheck.Rows.Count > 0)
                {
                    msgPart = "刷入產品為K01卡控狀態與不良代碼需單獨包裝，不可與列表中產品混包，請聯繫楊偉確認";
                    return msgPart;
                }
            }
            else
            {
                string s_tmp_check2 = "SELECT A.* FROM SD_TMP_BRWTOMA A,SD_CHECK_ORDERBIND B WHERE A.IP_ADDR='" + ipAddr + "' AND A.REASON_CODE=B.S_NGCODE AND A.ITEM3=B.PRODUCT_ITEM AND B.S_TYPE='BRWITEMREASON' AND B.L_TYPE = 1 AND B.IS_USE = 'Y'";
                DataTable dttmpcheck2 = PubClass.getdatatableMES(s_tmp_check2);
                if (dttmpcheck2.Rows.Count > 0)
                {
                    msgPart = "刷入的臨時表中存在K01卡控狀態與不良代碼需單獨包裝產品，不可與列表中產品混包，請聯繫楊偉確認";
                    return msgPart;
                }
            }
        }
        #endregion
        if (page == "R06" || page == "R20")//SD_TMP_BRWRECEIVE
        {
            string F56tmp = "SELECT * FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + ipAddr + "'";
            DataTable dtF56 = PubClass.getdatatableMES(F56tmp);
            if (dtF56.Rows.Count > 0)
            {
                tmpsn = dtF56.Rows[0]["PRODUCT_CODECELL"].ToString();
                if (mo_type == "F56")
                {
                    //FOG料号一致
                    if (status == "U-FLEX" || status == "CGL" || status == "成品" || status == "成品無印字")
                    {
                        //刷入临时表中的
                        string sqltmppz = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + tmpsn + "' AND B.ORDER_NO=A.SENCONDMO ";
                        DataTable dttmppz = PubClass.getdatatableMES(sqltmppz);
                        string hhh = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + chipID + "' AND B.ORDER_NO=A.SENCONDMO ";
                        DataTable dthhh = PubClass.getdatatableMES(hhh);
                        if (dttmppz.Rows.Count > 0)//
                        {
                            if (dthhh.Rows.Count > 0)
                            {
                                tmpsn = dttmppz.Rows[0]["PRODUCT_ID"].ToString();
                                cusn = dthhh.Rows[0]["PRODUCT_ID"].ToString();
                                if (tmpsn != cusn)
                                {
                                    msgPart = "刷入产品FOG料号不一致";
                                }
                            }
                        }
                        else
                        {
                            string noFog = "SELECT PART_ID  FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + status + "'";
                            DataTable dtnofog = PubClass.getdatatableMES(noFog);
                            if (dtnofog.Rows.Count == 0)
                            {
                                msgPart = "产品存在异常，未找到对应FOG料号";
                            }
                        }
                    }
                    //CGL料号一致
                    if (status == "成品" || status == "成品無印字")
                    {
                        string cgltmpsql = @"SELECT B.PART_ID FROM SD_TMP_BRWTOMA A,SD_BASE_ORDERPART B WHERE A.ORDER_NO=B.ORDER_NO  AND B.PART_STATUS='CGL' AND IP_ADDR='" + ipAddr + "'";
                        DataTable dtCGL = PubClass.getdatatableMES(cgltmpsql);
                        string cglsql = @"SELECT * FROM SD_BASE_ORDERPART WHERE PART_STATUS='CGL' AND ORDER_NO IN (SELECT ORDER_NO FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + chipID + "')";
                        DataTable dtNOWCGL = PubClass.getdatatableMES(cglsql);
                        if (dtCGL.Rows.Count > 0 && dtNOWCGL.Rows.Count > 0)
                        {
                            string tmpsn2 = dtCGL.Rows[0]["PART_ID"].ToString();
                            string cusn2 = dtNOWCGL.Rows[0]["PART_ID"].ToString();
                            if (tmpsn2 != cusn2)
                            {
                                msgPart = "刷入产品CGL料号不一致";
                            }
                        }
                        else
                        {
                            msgPart = "产品存在异常，未找到对应CGL料号";
                        }
                    }
                }
            }
        }
        if (page == "R08" || page == "R31" || page == "R33" || page == "R37" || page == "Rcancel")//SD_TMP_BRWTOMA
        {
            string F56tmp = "SELECT * FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'";
            DataTable dtF56 = PubClass.getdatatableMES(F56tmp);
            if (dtF56.Rows.Count > 0)
            {
                tmpsn = dtF56.Rows[0]["PRODUCT_CODECELL"].ToString();
                if (mo_type == "F56")
                {
                    //FOG料号一致
                    if (status == "U-FLEX" || status == "CGL" || status == "成品" || status == "成品無印字")
                    {
                        //刷入临时表中的
                        string sqltmppz = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + tmpsn + "' AND B.ORDER_NO=A.SENCONDMO";
                        DataTable dttmppz = PubClass.getdatatableMES(sqltmppz);
                        string hhh = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + chipID + "' AND B.ORDER_NO=A.SENCONDMO";
                        DataTable dthhh = PubClass.getdatatableMES(hhh);
                        if (dttmppz.Rows.Count > 0)//
                        {
                            if (dthhh.Rows.Count > 0)
                            {
                                tmpsn = dttmppz.Rows[0]["PRODUCT_ID"].ToString();
                                cusn = dthhh.Rows[0]["PRODUCT_ID"].ToString();
                                if (tmpsn != cusn)
                                {
                                    msgPart = "刷入产品FOG料号不一致";
                                }
                            }
                        }
                        else
                        {
                            string noFog = "SELECT PART_ID  FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + status + "'";
                            DataTable dtnofog = PubClass.getdatatableMES(noFog);
                            if (dtnofog.Rows.Count == 0)
                            {
                                msgPart = "产品存在异常，未找到对应FOG料号";
                            }
                        }
                    }
                    //CGL料号一致
                    if (status == "成品" || status == "成品無印字")
                    {
                        string cgltmpsql = @"SELECT B.PART_ID FROM SD_TMP_BRWTOMA A,SD_BASE_ORDERPART B WHERE A.ORDER_NO=B.ORDER_NO  AND B.PART_STATUS='CGL' AND IP_ADDR='" + ipAddr + "'";
                        DataTable dtCGL = PubClass.getdatatableMES(cgltmpsql);
                        string cglsql = @"SELECT * FROM SD_BASE_ORDERPART WHERE PART_STATUS='CGL' AND ORDER_NO IN (SELECT ORDER_NO FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + chipID + "')";
                        DataTable dtNOWCGL = PubClass.getdatatableMES(cglsql);
                        if (dtCGL.Rows.Count > 0 && dtNOWCGL.Rows.Count > 0)
                        {
                            string tmpsn2 = dtCGL.Rows[0]["PART_ID"].ToString();
                            string cusn2 = dtNOWCGL.Rows[0]["PART_ID"].ToString();
                            if (tmpsn2 != cusn2)
                            {
                                msgPart = "刷入产品CGL料号不一致";
                            }
                        }
                        else
                        {
                            msgPart = "产品存在异常，未找到对应CGL料号";
                        }
                    }
                }
            }
        }
        if (page == "Rreport")//SD_TMP_BRWTOMAREPORT
        {
            string F56tmp = "SELECT * FROM SD_TMP_BRWTOMAREPORT WHERE IP_ADDR='" + ipAddr + "'";
            DataTable dtF56 = PubClass.getdatatableMES(F56tmp);
            if (dtF56.Rows.Count > 0)
            {
                tmpsn = dtF56.Rows[0]["PRODUCT_CODECELL"].ToString();
                if (mo_type == "F56")
                {
                    //FOG料号一致
                    if (status == "U-FLEX" || status == "CGL" || status == "成品" || status == "成品無印字")
                    {
                        //刷入临时表中的
                        string sqltmppz = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + tmpsn + "' AND B.ORDER_NO=A.SENCONDMO";
                        DataTable dttmppz = PubClass.getdatatableMES(sqltmppz);
                        string hhh = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + chipID + "' AND B.ORDER_NO=A.SENCONDMO";
                        DataTable dthhh = PubClass.getdatatableMES(hhh);
                        if (dttmppz.Rows.Count > 0)//
                        {
                            if (dthhh.Rows.Count > 0)
                            {
                                tmpsn = dttmppz.Rows[0]["PRODUCT_ID"].ToString();
                                cusn = dthhh.Rows[0]["PRODUCT_ID"].ToString();
                                if (tmpsn != cusn)
                                {
                                    msgPart = "刷入产品FOG料号不一致";
                                }
                            }
                        }
                        else
                        {
                            string noFog = "SELECT PART_ID  FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + status + "'";
                            DataTable dtnofog = PubClass.getdatatableMES(noFog);
                            if (dtnofog.Rows.Count == 0)
                            {
                                msgPart = "产品存在异常，未找到对应FOG料号";
                            }
                        }
                    }
                    //CGL料号一致
                    if (status == "成品" || status == "成品無印字")
                    {
                        string cgltmpsql = @"SELECT B.PART_ID FROM SD_TMP_BRWTOMAREPORT A,SD_BASE_ORDERPART B WHERE A.ORDER_NO=B.ORDER_NO  AND B.PART_STATUS='CGL' AND IP_ADDR='" + ipAddr + "'";
                        DataTable dtCGL = PubClass.getdatatableMES(cgltmpsql);
                        string cglsql = @"SELECT * FROM SD_BASE_ORDERPART WHERE PART_STATUS='CGL' AND ORDER_NO IN (SELECT ORDER_NO FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + chipID + "')";
                        DataTable dtNOWCGL = PubClass.getdatatableMES(cglsql);
                        if (dtCGL.Rows.Count > 0 && dtNOWCGL.Rows.Count > 0)
                        {
                            string tmpsn2 = dtCGL.Rows[0]["PART_ID"].ToString();
                            string cusn2 = dtNOWCGL.Rows[0]["PART_ID"].ToString();
                            if (tmpsn2 != cusn2)
                            {
                                msgPart = "刷入产品CGL料号不一致";
                            }
                        }
                        else
                        {
                            msgPart = "产品存在异常，未找到对应CGL料号";
                        }
                    }
                }
            }
        }
        if (page == "R15")//SD_TMP_BRWRECEIVE_CHAI
        {
            string F56tmp = "SELECT * FROM SD_TMP_BRWRECEIVE_CHAI WHERE USER_IP='" + ipAddr + "'";
            DataTable dtF56 = PubClass.getdatatableMES(F56tmp);
            if (dtF56.Rows.Count > 0)
            {
                tmpsn = dtF56.Rows[0]["PRODUCT_CODECELL"].ToString();
                if (mo_type == "F56")
                {
                    //FOG料号一致
                    if (status == "U-FLEX" || status == "CGL" || status == "成品" || status == "成品無印字")
                    {
                        //刷入临时表中的
                        string sqltmppz = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + tmpsn + "' AND B.ORDER_NO=A.SENCONDMO";
                        DataTable dttmppz = PubClass.getdatatableMES(sqltmppz);
                        string hhh = @"SELECT A.ORDER_NO,B.PRODUCT_ID FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B WHERE A.PRODUCT_CODECELL='" + chipID + "' AND B.ORDER_NO=A.SENCONDMO";
                        DataTable dthhh = PubClass.getdatatableMES(hhh);
                        if (dttmppz.Rows.Count > 0)//
                        {
                            if (dthhh.Rows.Count > 0)
                            {
                                tmpsn = dttmppz.Rows[0]["PRODUCT_ID"].ToString();
                                cusn = dthhh.Rows[0]["PRODUCT_ID"].ToString();
                                if (tmpsn != cusn)
                                {
                                    msgPart = "刷入产品FOG料号不一致";
                                }
                            }
                        }
                        else
                        {
                            string noFog = "SELECT PART_ID  FROM SD_BASE_ORDERPART WHERE ORDER_NO='" + order_no + "' AND PART_STATUS='" + status + "'";
                            DataTable dtnofog = PubClass.getdatatableMES(noFog);
                            if (dtnofog.Rows.Count == 0)
                            {
                                msgPart = "产品存在异常，未找到对应FOG料号";
                            }
                        }
                    }
                    //CGL料号一致
                    if (status == "成品" || status == "成品無印字")
                    {
                        string cgltmpsql = @"SELECT B.PART_ID FROM SD_TMP_BRWRECEIVE_CHAI A,SD_BASE_ORDERPART B WHERE A.ORDER_NO=B.ORDER_NO  AND B.PART_STATUS='CGL' AND IP_ADDR='" + ipAddr + "'";
                        DataTable dtCGL = PubClass.getdatatableMES(cgltmpsql);
                        string cglsql = @"SELECT * FROM SD_BASE_ORDERPART WHERE PART_STATUS='CGL' AND ORDER_NO IN (SELECT ORDER_NO FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + chipID + "')";
                        DataTable dtNOWCGL = PubClass.getdatatableMES(cglsql);
                        if (dtCGL.Rows.Count > 0 && dtNOWCGL.Rows.Count > 0)
                        {
                            string tmpsn2 = dtCGL.Rows[0]["PART_ID"].ToString();
                            string cusn2 = dtNOWCGL.Rows[0]["PART_ID"].ToString();
                            if (tmpsn2 != cusn2)
                            {
                                msgPart = "刷入产品CGL料号不一致";
                            }
                        }
                        else
                        {
                            msgPart = "产品存在异常，未找到对应CGL料号";
                        }
                    }
                }
            }
        }
        return msgPart;
    }
    public static bool updateData(string pageNumber, string ipAddr, string pageType, string orderNo, string Boxid, string productId)
    {
        try
        {

       
            if (pageNumber == "R53")
            {
                string remark = "";
                if (productId == "M8QM")
                {
                    remark = "M8QM倉已點收待出庫";
                }
                else if (productId == "M8MM")
                {
                    remark = "M8MM倉已點收待下線";
                }
                else
                {
                    remark = "再檢品已點收待下線";
                }
                PubClass.getdatatableMES("DELETE FROM  SD_HIS_TTLOTLIST  WHERE PRODUCT_CODECELL IN  (SELECT PRODUCT_CODECELL FROM SD_TMP_STORETOBRW  WHERE IP_ADDR='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL,STEP_ID,CREATE_DATE,EX_HOUR,BOX_DATE,BOX_ID,ORDER_NO,S_TYPE) SELECT PRODUCT_CODECELL,'" + remark + "',SYSDATE,'0',SYSDATE,REJECTED_ID,ORDER_NO,'正常' FROM SD_TMP_STORETOBRW  WHERE IP_ADDR='" + ipAddr + "'");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'" + remark + "', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_STORETOBRW  WHERE IP_ADDR='" + ipAddr + "'");
            }
            if (pageNumber == "R06")
            {
                PubClass.getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='已分維修類型待打包', CREATE_DATE=SYSDATE,EX_HOUR=0 WHERE PRODUCT_CODECELL IN(SELECT  PRODUCT_CODECELL  FROM SD_TMP_BRWRECEIVE  WHERE USER_IP='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'已分維修類型待打包', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_BRWRECEIVE  WHERE USER_IP='" + ipAddr + "'");
            }
            if (pageNumber == "R08")  //增加称重的TT
            {
                PubClass.getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET STEP_ID='維修已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'維修已打包待入庫', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "R26")
            {
                PubClass.getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='重工區已點收維修流程未走完', CREATE_DATE=SYSDATE,EX_HOUR=0 WHERE PRODUCT_CODECELL IN(SELECT A1.PRODUCT_CODECELL FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'重工區已點收維修流程未走完', '" + pageNumber + "','" + ipAddr + "' FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "'");
            }
            if (pageNumber == "R26_FAB3")
            {
                PubClass.getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='Fab3已點收维修流程未走完', CREATE_DATE=SYSDATE,EX_HOUR=0,S_TYPE = '正常' WHERE PRODUCT_CODECELL IN(SELECT A1.PRODUCT_CODECELL FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'Fab3已點收维修流程未走完', '" + pageNumber + "','" + ipAddr + "' FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "'");
            }
            if (pageNumber == "M43")
            {
                PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT A1.PRODUCT_CODECELL FROM SD_TMP_ORTREJECTED A1 WHERE A1.IP_ADDR = '" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'M43', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_ORTREJECTED A1 WHERE A1.IP_ADDR = '" + ipAddr + "'");
            }
            if (pageNumber == "R15")
            {
                PubClass.getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='已分維修類型待打包', CREATE_DATE=SYSDATE,EX_HOUR=0 WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM  SD_TMP_BRWRECEIVE_CHAI WHERE USER_IP='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE,CREATE_USER) SELECT PRODUCT_CODECELL,'已分維修類型待打包', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_BRWRECEIVE_CHAI WHERE USER_IP= '" + ipAddr + "'");
            }
            if (pageNumber == "R28")
            {
                PubClass.getdatatableMES(@"DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + pageType + "' AND ADDR_IP='" + ipAddr + "')");
                PubClass.getdatatableMES(@"INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL,STEP_ID,CREATE_DATE,EX_HOUR,BLOT_ID,S_TYPE)
SELECT      PRODUCT_CODECELL,'已下線待重工區點收',SYSDATE,0,'" + Boxid + "','正常' FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + pageType + "' AND ADDR_IP='" + ipAddr + "'");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE,CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'已下線待重工區點收', '" + pageNumber + "','" + ipAddr + "'||'-'||CREATE_USER,ORDER_NO||'-'||TYPE||'" + Boxid + "' FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + pageType + "' AND ADDR_IP='" + ipAddr + "'");
                PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT BOX_ID FROM SD_TMP_BRWRESURE WHERE CREATE_USER='" + pageType + "' AND IP_ADDR='" + ipAddr + "')");
                PubClass.getdatatableMES("DELETE FROM SD_HIS_WEIGHTLOG WHERE REJECTED_ID IN(SELECT BOX_ID FROM SD_TMP_BRWRESURE WHERE CREATE_USER='" + pageType + "' AND IP_ADDR='" + ipAddr + "')");
            }
            if (pageNumber == "M07" || pageNumber == "M36" || pageNumber == "M48" || pageNumber == "M38")
            {
                PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE,CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'MES下线', '" + pageNumber + "','" + ipAddr + "',ORDER_NO FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "'");
                PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT BOX_ID FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "')");
                PubClass.getdatatableMES("DELETE FROM SD_HIS_WEIGHTLOG WHERE REJECTED_ID IN(SELECT BOX_ID FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "')");
            }
            if (pageNumber == "R31")
            {
                PubClass.getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='客責不明責(非再檢)已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'客責不明責(非再檢)已打包待入庫', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC  FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "R33")
            {
                PubClass.getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='客責不明責(非再檢)已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'客責不明責(非再檢)已打包待入庫', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC  FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "J01")
            {
                PubClass.getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET STEP_ID='不明責(需再檢)已打包待下線', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'不明責(需再檢)已打包待下線', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");
            }
            if (pageNumber == "J02")
            {   //2019/12/3  gpf  TT沒有的重新插入
                PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (select product_codecell FROM SD_TMP_BRWREWORK WHERE ADDR_IP='" + ipAddr + "' )");
                PubClass.getdatatableMES("insert into SD_HIS_TTLOTLIST (product_codecell,step_id,Create_Date,ex_hour,Box_Date,Box_Id,s_Type) select product_codecell,'已下線待再檢打包',SYSDATE,0,SYSDATE,'" + Boxid + "','正常' from SD_TMP_BRWREWORK WHERE ADDR_IP='" + ipAddr + "'");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'已下線待再檢打包', '" + pageNumber + "','" + ipAddr + "'||'-'||CREATE_USER, ORDER_NO FROM SD_TMP_BRWREWORK WHERE ADDR_IP='" + ipAddr + "'");
            }
            if (pageNumber == "J04")
            {
                PubClass.getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='再檢后已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'再檢后已打包待入庫', '" + pageNumber + "','" + ipAddr + "'||'-'||CREATE_USER,ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "Q15")
            {
                PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                DataTable dttt = PubClass.getdatatableMES("SELECT 1 FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                if (dttt.Rows.Count > 0)
                {
                    PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                    PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'Q15點收', '" + pageNumber + "','" + ipAddr + "' ,REJECTED_ID FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                }
            }
            if (pageNumber == "Q08")
            {
                PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                DataTable dttt = PubClass.getdatatableMES("SELECT 1 FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                if (dttt.Rows.Count > 0)
                {
                    PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                    PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'Q08點收', '" + pageNumber + "','" + ipAddr + "' ,REJECTED_ID FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                }
            }
            if (pageNumber == "L02")
            {
                DataTable dttt = PubClass.getdatatableMES("SELECT 1 FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT CODE11 FROM SD_TMP_RAREJECTED WHERE IP_ADDR ='" + ipAddr + "')");
                if (dttt.Rows.Count > 0)
                {
                    PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE S_TYPE = '稱重' AND PRODUCT_CODECELL IN (SELECT DISTINCT REJECTED_ID FROM SD_OP_REJECTED WHERE PRODUCT_CODECELL IN (SELECT CODE11 FROM SD_TMP_RAREJECTED WHERE IP_ADDR ='" + ipAddr + "'))");
                    PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT CODE11 FROM SD_TMP_RAREJECTED WHERE IP_ADDR ='" + ipAddr + "')");
                    PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT CODE11,'L02作業', '" + pageNumber + "','" + ipAddr + "' ,'" + Boxid + "' FROM  SD_TMP_RAREJECTED WHERE IP_ADDR='" + ipAddr + "'");
                }
            }
            if (pageNumber == "R40" || pageNumber == "R13" || pageNumber == "R21" || pageNumber == "R37" || pageNumber == "R38" || pageNumber == "R46" || pageNumber == "M17" || pageNumber == "M43")
            {
                if (pageNumber == "R40" || pageNumber == "R21" || pageNumber == "R37")
                {
                    PubClass.getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                }
                if (pageNumber == "R13" || pageNumber == "R38")
                {
                    PubClass.getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM sd_tmp_rejected WHERE IP_ADDR='" + ipAddr + "')");
                }
                if (pageNumber == "R46")
                {
                    PubClass.getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER='" + ipAddr + "')");
                }
                if (pageNumber == "M43")
                {
                    PubClass.getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM sd_tmp_ortrejected WHERE IP_ADDR='" + ipAddr + "')");
                }
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO)VALUES ('" + Boxid + "','結箱','稱重','" + pageNumber + "', '" + productId + "')");
                PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER ) VALUES ('" + Boxid + "','結箱','" + pageNumber + "','" + ipAddr + "')");

            }

            if (pageNumber == "R39")
            {
                PubClass.getdatatableMES(@"DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT REJECTED_ID FROM SD_TMP_R39  WHERE IP_ADDR='" + ipAddr + "') AND S_TYPE = '稱重'");
                PubClass.getdatatableMES(@"INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER,REMARK ) 
                                        SELECT '" + Boxid + "','R39拆箱','" + pageNumber + "','" + ipAddr + "',RECEIVE_USER FROM SD_TMP_R39  WHERE IP_ADDR='" + ipAddr + "'");
            }
            if (pageNumber == "R14")
            {
                if (productId == "DEL")
                {
                    PubClass.getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL='" + Boxid + "' AND S_TYPE = '稱重'");
                    PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER ) VALUES ('" + Boxid + "','R14合箱','" + pageNumber + "','" + ipAddr + "')");
                }
                else
                {
                    PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO)VALUES ('" + Boxid + "','結箱','稱重','" + pageNumber + "', '" + productId + "')");
                    PubClass.getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER ) VALUES ('" + Boxid + "','結箱','" + pageNumber + "','" + ipAddr + "')");
                    PubClass.getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET BOX_ID='" + Boxid + "' WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM  SD_TMP_REPAIRREJECTED WHERE CREATE_USER='" + ipAddr + "')");
                }

            }
            return true;
             }
        catch (Exception ex)
        {
            return false;
        }

        }
    
 

}