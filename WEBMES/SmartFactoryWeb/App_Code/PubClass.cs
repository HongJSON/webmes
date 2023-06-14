using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.OracleClient;
using System.Data.SqlClient;
using System.Net;
using System.Net.Sockets;

/// <summary>
///PubClass 的摘要说明
/// </summary>
namespace DataHelper
{
    public class PubClass
    {
        static string WOKDSD = System.Configuration.ConfigurationManager.ConnectionStrings["WOKDSD"].ConnectionString;

        /// <summary>
        /// 获取本机IP地址
        /// </summary>
        /// <returns>本机IP地址</returns>
        public static string GetLocalIP()
        {
            try
            {
                string HostName = Dns.GetHostName(); //得到主机名
                IPHostEntry IpEntry = Dns.GetHostEntry(HostName);
                for (int i = 0; i < IpEntry.AddressList.Length; i++)
                {
                    //从IP地址列表中筛选出IPv4类型的IP地址
                    //AddressFamily.InterNetwork表示此IP为IPv4,
                    //AddressFamily.InterNetworkV6表示此地址为IPv6类型
                    if (IpEntry.AddressList[i].AddressFamily == AddressFamily.InterNetwork)
                    {
                        return IpEntry.AddressList[i].ToString();
                    }
                }
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public static OracleConnection dbconMES()
        {
            OracleConnection con = new OracleConnection();
            con = new OracleConnection(WOKDSD);
            return con;
        }

        public static DataTable getdatatablewms(string sql)
        {
            OracleDataAdapter oda = new OracleDataAdapter();
            oda = new OracleDataAdapter(sql, dbconWMS());
            DataSet ds = new DataSet();
            oda.Fill(ds, "tmp");
            DataTable returndt = ds.Tables["tmp"];
            dbconWMS().Close();
            return returndt;
        }

        public static OracleConnection dbconWMS()
        {
            OracleConnection con = new OracleConnection();
            con = new OracleConnection("server=WOKLMS;user id=LMS;password=LMS");
            return con;
        }

        public static DataTable getdatatableMES(string sql)
        {
            OracleDataAdapter oda = new OracleDataAdapter();
            oda = new OracleDataAdapter(sql, dbconMES());
            DataSet ds = new DataSet();
            oda.Fill(ds, "tmp");
            DataTable returndt = ds.Tables["tmp"];
            dbconMES().Close();
            return returndt;
        }
        public static void getdatatablenoreturnMES(string sql)
        {
            OracleDataAdapter oda = new OracleDataAdapter();
            oda = new OracleDataAdapter(sql, dbconMES());
            DataSet ds = new DataSet();
            oda.Fill(ds, "tmp");
            dbconMES().Close();
        }
        public static string excuteOts(List<string> strs)
        {
            string strReturn = "操作失敗!";
            OracleConnection con = dbconMES();
            OracleTransaction ots;
            con.Open();
            ots = con.BeginTransaction();
            try
            {
                for (int i = 0; i < strs.Count; i++)
                {
                    OracleCommand cmd = new OracleCommand(strs[i].ToString(), con);
                    cmd.Transaction = ots;
                    cmd.ExecuteNonQuery();
                }
                ots.Commit();
                strReturn = "操作成功";
            }
            catch (Exception ex)
            {
                ots.Rollback();
            }
            finally
            {
                con.Close();
                con.Dispose();
                ots.Dispose();
            }
            return strReturn;
        }
        /// <summary>
        /// DSD
        /// </summary>
        /// <returns></returns>
        /// 
        public static OracleConnection dbcon()
        {
            OracleConnection con = new OracleConnection();
            con = new OracleConnection(WOKDSD);
            return con;
        }
        public static DataTable getdatatable(string sql)
        {
            OracleDataAdapter oda = new OracleDataAdapter();
            oda = new OracleDataAdapter(sql, dbcon());
            DataSet ds = new DataSet();
            oda.Fill(ds, "tmp");
            DataTable returndt = ds.Tables["tmp"];
            dbcon().Close();
            return returndt;
        }
        public static void getdatatablenoreturn(string sql)
        {
            OracleDataAdapter oda = new OracleDataAdapter();
            oda = new OracleDataAdapter(sql, dbcon());
            DataSet ds = new DataSet();
            oda.Fill(ds, "tmp");
            dbcon().Close();
        }
        public static string getLoginUser(string IP, string User)
        {
            string user = User.Replace("WKSCN\\", "");
            user = user.Replace("CIM\\", "");
            List<string> addrs = new List<string>();
            addrs.Add("10.57.0.97");
            addrs.Add("10.57.0.99");
            addrs.Add("10.57.0.114");
            addrs.Add("10.57.0.106");
            addrs.Add("10.57.0.142");
            addrs.Add("10.57.0.141");
            addrs.Add("10.57.0.102");
            addrs.Add("10.57.0.150");
            addrs.Add("10.57.0.158");
            addrs.Add("10.57.0.151");
            string loginUser = IP;
            foreach (string addr in addrs)
            {
                if (addr == IP)
                {
                    loginUser = user;
                }
            }
            return loginUser;
        }
   public static void updateData(string pageNumber, string ipAddr, string pageType = "NA", string orderNo = "NA", string Boxid = "NA", string productId = "NA")
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
                getdatatableMES("DELETE FROM  SD_HIS_TTLOTLIST  WHERE PRODUCT_CODECELL IN  (SELECT PRODUCT_CODECELL FROM SD_TMP_STORETOBRW  WHERE IP_ADDR='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL,STEP_ID,CREATE_DATE,EX_HOUR,ORDER_NO,S_TYPE) SELECT PRODUCT_CODECELL,'" + remark + "',SYSDATE,'0',ORDER_NO,'正常' FROM SD_TMP_STORETOBRW  WHERE IP_ADDR='" + ipAddr + "'");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'" + remark + "', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_STORETOBRW  WHERE IP_ADDR='" + ipAddr + "'");
            }
            if (pageNumber == "R06")
            {
                getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='維修已點收待分類', CREATE_DATE=SYSDATE,EX_HOUR=0 WHERE PRODUCT_CODECELL IN(SELECT  PRODUCT_CODECELL  FROM SD_TMP_BRWRECEIVE  WHERE USER_IP='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'維修已點收待分類', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_BRWRECEIVE  WHERE USER_IP='" + ipAddr + "'");
            }
            if (pageNumber == "R08")  //增加称重的TT
            {
                getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET STEP_ID='維修已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'維修已打包待入庫', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "R26")
            {
                getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='重工區已點收維修流程未走完', CREATE_DATE=SYSDATE,EX_HOUR=0 WHERE PRODUCT_CODECELL IN(SELECT A1.PRODUCT_CODECELL FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'重工區已點收維修流程未走完', '" + pageNumber + "','" + ipAddr + "' FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "'");
            }
            if (pageNumber == "R26_FAB3")
            {
                getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='Fab3已點收维修流程未走完', CREATE_DATE=SYSDATE,EX_HOUR=0,S_TYPE = '正常' WHERE PRODUCT_CODECELL IN(SELECT A1.PRODUCT_CODECELL FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'Fab3已點收维修流程未走完', '" + pageNumber + "','" + ipAddr + "' FROM SD_HIS_BRWLOTPRODUCT A1, SD_TMP_BLOTRECEIVE A2 WHERE A1.BLOT_ID=A2.LOT_ID AND A2.CREATE_USER = '" + ipAddr + "'");
            }
            if (pageNumber == "M43")
            {
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT A1.PRODUCT_CODECELL FROM SD_TMP_ORTREJECTED A1 WHERE A1.IP_ADDR = '" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER) SELECT PRODUCT_CODECELL,'M43', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_ORTREJECTED A1 WHERE A1.IP_ADDR = '" + ipAddr + "'");
            }
            if (pageNumber == "R15")
            {
                getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='維修已點收待分類', CREATE_DATE=SYSDATE,EX_HOUR=0 WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM  SD_TMP_BRWRECEIVE_CHAI WHERE USER_IP='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE,CREATE_USER) SELECT PRODUCT_CODECELL,'維修已點收待分類', '" + pageNumber + "','" + ipAddr + "' FROM SD_TMP_BRWRECEIVE_CHAI WHERE USER_IP= '" + ipAddr + "'");
            }
            if (pageNumber == "R28")
            {
                getdatatableMES(@"DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + pageType + "' AND ADDR_IP='" + ipAddr + "')");
                getdatatableMES(@"INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL,STEP_ID,CREATE_DATE,EX_HOUR,BLOT_ID,S_TYPE)
SELECT      PRODUCT_CODECELL,'已下線待重工區點收',SYSDATE,0,'" + Boxid + "','正常' FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + pageType + "' AND ADDR_IP='" + ipAddr + "'");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE,CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'已下線待重工區點收', '" + pageNumber + "','" + ipAddr + "'||'-'||CREATE_USER,ORDER_NO||'-'||TYPE||'" + Boxid + "' FROM SD_TMP_BRWREWORK WHERE CREATE_USER='" + pageType + "' AND ADDR_IP='" + ipAddr + "'");
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT BOX_ID FROM SD_TMP_BRWRESURE WHERE CREATE_USER='" + pageType + "' AND IP_ADDR='" + ipAddr + "')");
                getdatatableMES("DELETE FROM SD_HIS_WEIGHTLOG WHERE REJECTED_ID IN(SELECT BOX_ID FROM SD_TMP_BRWRESURE WHERE CREATE_USER='" + pageType + "' AND IP_ADDR='" + ipAddr + "')");
            }
            if (pageNumber == "M07" || pageNumber == "M36" || pageNumber == "M48" || pageNumber == "M38")
            {
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE,CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'MES下线', '" + pageNumber + "','" + ipAddr + "',ORDER_NO FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "'");
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN(SELECT BOX_ID FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "')");
                getdatatableMES("DELETE FROM SD_HIS_WEIGHTLOG WHERE REJECTED_ID IN(SELECT BOX_ID FROM SD_TMP_REWORK WHERE ADDR_IP='" + ipAddr + "' AND ORDER_NO='" + orderNo + "')");
            }
            if (pageNumber == "R31")
            {
                getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='客責不明責(非再檢)已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'客責不明責(非再檢)已打包待入庫', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC  FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "R33")
            {
                getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='客責不明責(非再檢)已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK) SELECT PRODUCT_CODECELL,'客責不明責(非再檢)已打包待入庫', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC  FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "J01")
            {
                getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET STEP_ID='不明責(需再檢)已打包待下線', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'不明責(需再檢)已打包待下線', '" + pageNumber + "',CREATE_USER||'-'||IP_ADDR, ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");
            }
            if (pageNumber == "J02")
            {   //2019/12/3  gpf  TT沒有的重新插入
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (select product_codecell FROM SD_TMP_BRWREWORK WHERE ADDR_IP='" + ipAddr + "' )");
                getdatatableMES("insert into SD_HIS_TTLOTLIST (product_codecell,step_id,Create_Date,ex_hour,Box_Date,Box_Id,s_Type) select product_codecell,'已下線待再檢打包',SYSDATE,0,SYSDATE,'" + Boxid + "','正常' from SD_TMP_BRWREWORK WHERE ADDR_IP='" + ipAddr + "'");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'已下線待再檢打包', '" + pageNumber + "','" + ipAddr + "'||'-'||CREATE_USER, ORDER_NO FROM SD_TMP_BRWREWORK WHERE ADDR_IP='" + ipAddr + "'");
            }
            if (pageNumber == "J04")
            {
                getdatatableMES("UPDATE  SD_HIS_TTLOTLIST SET STEP_ID='再檢后已打包待入庫', CREATE_DATE=SYSDATE,EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'再檢后已打包待入庫', '" + pageNumber + "','" + ipAddr + "'||'-'||CREATE_USER,ITEM3||'-'||'" + Boxid + "'||'-'||STORELOC FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "'");

                getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO) SELECT  '" + Boxid + "','結箱','稱重','" + pageNumber + "', PRODUCT_ID FROM SD_TMP_BRWTOMA WHERE IP_ADDR ='" + ipAddr + "' GROUP BY PRODUCT_ID");
            }
            if (pageNumber == "Q15")
            {
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                DataTable dttt = getdatatableMES("SELECT 1 FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                if (dttt.Rows.Count > 0)
                {
                    getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                    getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'Q15點收', '" + pageNumber + "','" + ipAddr + "' ,REJECTED_ID FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                }
            }
            if (pageNumber == "Q08")
            {
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                DataTable dttt = getdatatableMES("SELECT 1 FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                if (dttt.Rows.Count > 0)
                {
                    getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT PRODUCT_CODECELL FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "'))");
                    getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT PRODUCT_CODECELL,'Q08點收', '" + pageNumber + "','" + ipAddr + "' ,REJECTED_ID FROM  SD_OP_REJECTED WHERE REJECTED_ID IN (SELECT REJECTED_ID FROM SD_TMP_HFIQCBOX WHERE IP_ADDRESS='" + ipAddr + "')");
                }
            }
            if (pageNumber == "L02")
            {
                DataTable dttt = getdatatableMES("SELECT 1 FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT CODE11 FROM SD_TMP_RAREJECTED WHERE IP_ADDR ='" + ipAddr + "')");
                if (dttt.Rows.Count > 0)
                {
                    getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL IN (SELECT CODE11 FROM SD_TMP_RAREJECTED WHERE IP_ADDR ='" + ipAddr + "')");
                    getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER, REMARK ) SELECT CODE11,'L02作業', '" + pageNumber + "','" + ipAddr + "' ,'" + Boxid + "' FROM  SD_TMP_RAREJECTED WHERE IP_ADDR='" + ipAddr + "'");
                }
            }
            if (pageNumber == "R40" || pageNumber == "R13" || pageNumber == "R21" || pageNumber == "R37" || pageNumber == "R38" || pageNumber == "R46" || pageNumber == "M17" || pageNumber == "M43")
            {
                if (pageNumber == "R40" || pageNumber == "R21" || pageNumber == "R37")
                {
                    getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM SD_TMP_BRWTOMA WHERE IP_ADDR='" + ipAddr + "')");
                }
                if (pageNumber == "R13" || pageNumber == "R38")
                {
                    getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM sd_tmp_rejected WHERE IP_ADDR='" + ipAddr + "')");
                }
                if (pageNumber == "R46")
                {
                    getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM SD_TMP_REPAIRREJECTED WHERE CREATE_USER='" + ipAddr + "')");
                }
                if (pageNumber == "M43")
                {
                    getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET EX_HOUR=0,BOX_ID='" + Boxid + "', BOX_DATE=SYSDATE  WHERE PRODUCT_CODECELL IN ( SELECT PRODUCT_CODECELL FROM sd_tmp_ortrejected WHERE IP_ADDR='" + ipAddr + "')");
                }
                getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO)VALUES ('" + Boxid + "','結箱','稱重','" + pageNumber + "', '" + productId + "')");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER ) VALUES ('" + Boxid + "','結箱','" + pageNumber + "','" + ipAddr + "')");

            }

            if (pageNumber == "R39")
            {
                getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL='" + Boxid + "' AND S_TYPE = '稱重'");
                getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER ) VALUES ('" + Boxid + "','R39拆箱','" + pageNumber + "','" + ipAddr + "')");

            }
            if (pageNumber == "R14")
            {
                if (productId == "DEL")
                {
                    getdatatableMES("DELETE FROM SD_HIS_TTLOTLIST WHERE PRODUCT_CODECELL='" + Boxid + "' AND S_TYPE = '稱重'");
                    getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER ) VALUES ('" + Boxid + "','R14合箱','" + pageNumber + "','" + ipAddr + "')");
                }
                else
                {
                    getdatatableMES("INSERT INTO SD_HIS_TTLOTLIST(PRODUCT_CODECELL, STEP_ID, S_TYPE, BOX_ID, ORDER_NO)VALUES ('" + Boxid + "','結箱','稱重','" + pageNumber + "', '" + productId + "')");
                    getdatatableMES("INSERT INTO SD_HIS_TTLOTPCSINFO(PRODUCT_CODECELL, STEP_ID, PAGE, CREATE_USER ) VALUES ('" + Boxid + "','結箱','" + pageNumber + "','" + ipAddr + "')");
                    getdatatableMES("UPDATE SD_HIS_TTLOTLIST SET BOX_ID='" + Boxid + "' WHERE PRODUCT_CODECELL IN(SELECT PRODUCT_CODECELL FROM  SD_TMP_REPAIRREJECTED WHERE CREATE_USER='" + ipAddr + "')");
                }

            }

        }

    }
}