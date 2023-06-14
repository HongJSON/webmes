using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.OracleClient;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using System.IO;
using DataHelper;

public partial class creport : System.Web.UI.Page
{
    publicClass pc = new publicClass();
    CrystalDecisions.CrystalReports.Engine.ReportDocument rptDoc = new ReportDocument();
    protected void Page_Load(object sender, EventArgs e)
    {
        string str_lotid = "";
        string ll = Request.Params[0].ToString();

        str_lotid = ll;

        DataTable dt = getdate(str_lotid);
        if (dt.Rows.Count == 0)
        {
            Response.Write("<script language='javascript'>alert('此LOT不存在!')</script>");
            return;
        }
        string strDateNow = System.DateTime.Now.ToString("yyyyMMdd");

        string strPathPdf = this.Server.MapPath("PDF") + "\\" + strDateNow;
        if (Directory.Exists(strPathPdf) == false)
        {
            Directory.CreateDirectory(strPathPdf);
        }


        pdfGenerate(dt, str_lotid);
        Response.Write("<script language='javascript'>window.location='pdf/" + strDateNow + '/' + str_lotid + ".pdf'</script>");
		
    }

    private DataTable getdate(string str_lotid)
    {
        string sqlreport = "";
        string sql = "select * from sd_op_lotinfo where lot_id ='" + str_lotid + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count == 0) return dt;
        string sql1 = "select code_jb from sd_base_codewithproduct where product_id in(select product_id from sd_op_runcard where lot_id  ='" + str_lotid + "')";
        DataTable dt1 = PubClass.getdatatableMES(sql1);
        string codejb = dt1.Rows[0][0].ToString();
        //2017.2.10 SIMON 打指定工單加-R或-5 
        string errType = "";
        string checkOrder = "0000";
        string codeType = "SELECT DISTINCT CODE_TYPE,ORDER_NO  FROM SD_BASE_SPECIALORDER  WHERE ORDER_NO ='" + dt.Rows[0]["ORDER_NO"].ToString() + "' AND FLAG='Y'";
        DataTable dtCode = PubClass.getdatatableMES(codeType); 
        if (dtCode.Rows.Count == 1)
        {
            errType = dtCode.Rows[0]["CODE_TYPE"].ToString();
            checkOrder = dtCode.Rows[0]["ORDER_NO"].ToString();
        }
        //CHANGE AND (A1.ISOFF_LINE = 'Y' OR A1.IS_OFFLINE = 'Y')
        if (dt.Rows.Count > 0)
        {
            string sqly = "select * from sd_his_tmplot where tmplot_id ='" + str_lotid + "'";
            DataTable dty = PubClass.getdatatableMES(sqly);
            if (dty.Rows.Count > 0)
            {
                sqlreport = @"SELECT  B.LOT_ID,CASE WHEN B.ORDER_NO  IN('" + checkOrder + @"') THEN B.ORDER_NO||'" + errType + @"' ELSE B.ORDER_NO END  ORDER_NO, 
                                               CASE WHEN B.ORDER_NO1 IN('" + checkOrder + @"') THEN B.ORDER_NO1||'" + errType + @"' ELSE B.ORDER_NO1 END  ORDER_NO1,
                                              CASE WHEN B.ORDER_NO2 IN('" + checkOrder + @"') THEN B.ORDER_NO2||'" + errType + @"' ELSE B.ORDER_NO2 END  ORDER_NO2,
                              CREATE_TIME,B.LOT_STARTQTY,B.STEP_ID,B.ARRY_LOT,B.STEPM_ID,B.QUANTITY,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END)||B.WORKORDER_INFO WORKORDER_INFO,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END) WORKORDER_INFO1,B.PRODUCT_ID,B.CPN_ID,B.PRODUCT_ID1,B.CPN_ID1,B.PRODUCT_ID2,B.CPN_ID2
                             FROM
                            (SELECT   A1.LOT_ID LOT_ID,A2.CELL_COME,
                            CASE WHEN ID_ORDER IN ('01','03-1') THEN A2.ORDER_NO  ELSE '' END ORDER_NO,
                            CASE WHEN ID_ORDER IN ('02','03-2') THEN A2.ORDER_NO ELSE '' END ORDER_NO1,
                            CASE WHEN ID_ORDER IN ('03','03-3') THEN A2.ORDER_NO ELSE '' END ORDER_NO2, 
                            TO_CHAR (A1.CREATE_DATE,'yyyy/MM/dd') CREATE_TIME,A1.LOT_STARTQTY, A3.STEP_ID,A8.ARRY_LOT,
                         A5.STEPM_ID || ':' || A6.STEP_DESC STEPM_ID, A2.QUANTITY,A2.WORKORDER_INFO,
                         CASE WHEN ID_ORDER IN ('01','03-1')  THEN A1.PRODUCT_ID ELSE '' END PRODUCT_ID,
                         CASE WHEN ID_ORDER IN ('01','03-1')  THEN A7.CPN_ID ELSE '' END CPN_ID,
                         CASE WHEN ID_ORDER IN ('02','03-2')  THEN A1.PRODUCT_ID ELSE '' END PRODUCT_ID1,
                         CASE WHEN ID_ORDER IN ('02','03-2') THEN A7.CPN_ID ELSE '' END CPN_ID1,
                         CASE WHEN ID_ORDER IN ('03','03-3')  THEN A1.PRODUCT_ID ELSE '' END PRODUCT_ID2,
                         CASE WHEN ID_ORDER IN ('03','03-3') THEN A7.CPN_ID ELSE '' END CPN_ID2
                    FROM SD_OP_RUNCARD A1,
                         SD_OP_WORKORDER A2,
                         SD_BASE_PROCESS A3,
                         SD_BASE_STEPM A5,
                         SD_BASE_STEP A6,
                         SD_OP_CPN A7,
                         SD_HIS_TMPLOT A8
                   WHERE A1.LOT_ID IN '" + str_lotid + @"'
                     AND A2.ORDER_NO = '" + dt.Rows[0]["ORDER_NO"].ToString() + @"'
                     AND A1.PROCESS_NAME = A3.PROCESS_NAME AND A3.FLAG = 'Y' 
                AND A3.PROCESS_NAME=A5.PROCESS_NAME
                     AND A5.STEP_ID = A3.STEP_ID
                     AND A6.STEP_ID(+) = A5.STEPM_ID
                     AND A3.STEP_ID != 'OQ105'
                     AND A7.PRODUCT_ID=A2.PRODUCT_ID
                     AND A8.LOT_ID=A1.LOT_ID
                ORDER BY A1.LOT_ID,A3.PROCESS_ID, A5.STEP_ORDER,A6.STEP_ID )B";
            }
            else
            {
                string sqlst = @"SELECT DISTINCT STEP_ID FROM SD_HIS_LOTWKP WHERE LOT_ID ='" + str_lotid + @"' AND LOT_STATUS='C' AND ORDER_NO IN(SELECT DISTINCT ORDER_NO FROM SD_OP_LOTINFO WHERE LOT_ID ='" + str_lotid + @"') ";
                DataTable dtst = PubClass.getdatatableMES(sqlst);
                if (str_lotid.Substring(1, 1) == "R" && (!str_lotid.Contains(".")) && dtst.Rows.Count > 0)
                {
                    sqlreport = @" SELECT  B.LOT_ID,CASE WHEN B.ORDER_NO  IN('" + checkOrder + @"') THEN B.ORDER_NO||'" + errType + @"' ELSE B.ORDER_NO END  ORDER_NO, 
                                                  CASE WHEN B.ORDER_NO1 IN('" + checkOrder + @"') THEN B.ORDER_NO1||'" + errType + @"' ELSE B.ORDER_NO1 END  ORDER_NO1,
                                                  CASE WHEN B.ORDER_NO2 IN('" + checkOrder + @"') THEN B.ORDER_NO2||'" + errType + @"' ELSE B.ORDER_NO2 END  ORDER_NO2,
CREATE_TIME,B.LOT_STARTQTY,
B.STEP_ID,B.ARRY_LOT,B.STEPM_ID,B.QUANTITY,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END)||B.WORKORDER_INFO WORKORDER_INFO,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END) WORKORDER_INFO1,B.PRODUCT_ID,B.CPN_ID,B.PRODUCT_ID1,B.CPN_ID1,B.PRODUCT_ID2,B.CPN_ID2          
FROM (SELECT   a1.lot_id lot_id,case when id_order in ('01','03-1') then a2.order_no else '' end order_no,A2.CELL_COME,
                                                        case when id_order in ('02','03-2') then a2.order_no else '' end order_no1,
                                                        case when id_order in ('03','03-3') then a2.order_no else '' end order_no2,
                                        TO_CHAR (a1.create_date,'yyyy/MM/dd') create_time,a1.lot_startqty, a3.step_id, '' arry_lot,
                                        a5.stepm_id || ':' || a6.step_desc stepm_id, a2.quantity,a2.workorder_info,
                        case when id_order in ('01','03-1')  then a1.product_id else '' end product_id,
                        case when id_order in ('01','03-1')  then a7.CPN_ID else '' end CPN_ID,
                        case when id_order in ('02','03-2')  then a1.product_id else '' end product_id1,
                        case when id_order in ('02','03-2') then a7.CPN_ID else '' end CPN_ID1,
                        case when id_order in ('03','03-3')  then a1.product_id else '' end product_id2,
                        case when id_order in ('03','03-3') then a7.CPN_ID else '' end CPN_ID2
                    FROM sd_op_runcard a1,
                         sd_op_workorder a2,
                         sd_base_process a3,
                         sd_base_stepm a5,
                         sd_base_step a6,
                         sd_op_cpn a7
                   WHERE a1.lot_id ='" + str_lotid + @"'
                     AND A2.ORDER_NO = '" + dt.Rows[0]["ORDER_NO"].ToString() + @"'
                     AND a1.process_name = a3.process_name AND a3.flag = 'Y'  
                     AND a5.step_id = a3.step_id
                AND A3.PROCESS_NAME=a5.PROCESS_NAME
                     AND a6.step_id(+) = a5.stepm_id
                     AND a3.step_id != 'OQ105'
                     and a7.product_id=a2.product_id
                     AND A3.PROCESS_ID>=(SELECT PROCESS_ID FROM SD_BASE_PROCESS WHERE 
                     STEP_ID=(SELECT DISTINCT STEP_ID FROM SD_HIS_LOTWKP WHERE LOT_ID='" + str_lotid + @"' AND LOT_STATUS='C' 
                 AND ORDER_NO IN(SELECT DISTINCT ORDER_NO FROM SD_OP_LOTINFO WHERE LOT_ID ='" + str_lotid + @"')
                           ) AND PROCESS_NAME=A3.PROCESS_NAME)
                    ORDER BY a1.lot_id,A3.PROCESS_ID, a5.step_order,a6.STEP_ID) B";
                }
                else
                {

                    string sqlsts = "SELECT * FROM SD_HIS_LOTWKP WHERE LOT_ID ='" + str_lotid + @"' and step_id in('CELL','AP1','TCUT','GRM')   ";
                    DataTable dtsts = PubClass.getdatatableMES(sqlsts);

                    if ((str_lotid.Substring(0, 1) == "F" || str_lotid.Substring(0, 1) == "E") && dtsts.Rows.Count > 0)
                    {


                        sqlreport = @" SELECT  B.LOT_ID,CASE WHEN B.ORDER_NO  IN('" + checkOrder + @"') THEN B.ORDER_NO||'" + errType + @"' ELSE B.ORDER_NO END  ORDER_NO, 
                                                  CASE WHEN B.ORDER_NO1 IN('" + checkOrder + @"') THEN B.ORDER_NO1||'" + errType + @"' ELSE B.ORDER_NO1 END  ORDER_NO1,
                                                  CASE WHEN B.ORDER_NO2 IN('" + checkOrder + @"') THEN B.ORDER_NO2||'" + errType + @"' ELSE B.ORDER_NO2 END  ORDER_NO2,
                    CREATE_TIME,B.LOT_STARTQTY,
                    B.STEP_ID,B.ARRY_LOT,B.STEPM_ID,B.QUANTITY,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END)||B.WORKORDER_INFO WORKORDER_INFO,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END) WORKORDER_INFO1,B.PRODUCT_ID,B.CPN_ID,B.PRODUCT_ID1,B.CPN_ID1,B.PRODUCT_ID2,B.CPN_ID2          
                    FROM (SELECT   a1.lot_id lot_id,case when id_order in ('01','03-1') then a2.order_no else '' end order_no,A2.CELL_COME,
                                                        case when id_order in ('02','03-2') then a2.order_no else '' end order_no1,
                                                        case when id_order in ('03','03-3') then a2.order_no else '' end order_no2,
                                        TO_CHAR (a1.create_date,'yyyy/MM/dd') create_time,a1.lot_startqty, a3.step_id, '' arry_lot,
                                        a5.stepm_id || ':' || a6.step_desc stepm_id, a2.quantity,a2.workorder_info,
                        case when id_order in ('01','03-1')  then a1.product_id else '' end product_id,
                        case when id_order in ('01','03-1')  then a7.CPN_ID else '' end CPN_ID,
                        case when id_order in ('02','03-2')  then a1.product_id else '' end product_id1,
                        case when id_order in ('02','03-2') then a7.CPN_ID else '' end CPN_ID1,
                        case when id_order in ('03','03-3')  then a1.product_id else '' end product_id2,
                        case when id_order in ('03','03-3') then a7.CPN_ID else '' end CPN_ID2
                    FROM sd_op_runcard a1,
                         sd_op_workorder a2,
                         sd_base_process a3,
                         sd_base_stepm a5,
                         sd_base_step a6,
                         sd_op_cpn a7
                   WHERE a1.lot_id ='" + str_lotid + @"'
                     AND A2.ORDER_NO = '" + dt.Rows[0]["ORDER_NO"].ToString() + @"'
                     AND a1.process_name = a3.process_name AND a3.flag = 'Y'  
                     AND a5.step_id = a3.step_id
                AND A3.PROCESS_NAME=a5.PROCESS_NAME
                     AND a6.step_id(+) = a5.stepm_id
                     AND a3.step_id != 'OQ105'
                     and a7.product_id=a2.product_id
                 AND a3.step_id in('CELL','AP1','TCUT','GRM')
                ORDER BY a1.lot_id,A3.PROCESS_ID, a5.step_order,a6.STEP_ID) B";
                    }
                    else { 


                    sqlreport = @" SELECT  B.LOT_ID,CASE WHEN B.ORDER_NO  IN('" + checkOrder + @"') THEN B.ORDER_NO||'" + errType + @"' ELSE B.ORDER_NO END  ORDER_NO, 
                                                  CASE WHEN B.ORDER_NO1 IN('" + checkOrder + @"') THEN B.ORDER_NO1||'" + errType + @"' ELSE B.ORDER_NO1 END  ORDER_NO1,
                                                  CASE WHEN B.ORDER_NO2 IN('" + checkOrder + @"') THEN B.ORDER_NO2||'" + errType + @"' ELSE B.ORDER_NO2 END  ORDER_NO2,
                    CREATE_TIME,B.LOT_STARTQTY,
                    B.STEP_ID,B.ARRY_LOT,B.STEPM_ID,B.QUANTITY,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END)||B.WORKORDER_INFO WORKORDER_INFO,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END) WORKORDER_INFO1,B.PRODUCT_ID,B.CPN_ID,B.PRODUCT_ID1,B.CPN_ID1,B.PRODUCT_ID2,B.CPN_ID2          
                    FROM (SELECT   a1.lot_id lot_id,case when id_order in ('01','03-1') then a2.order_no else '' end order_no,A2.CELL_COME,
                                                        case when id_order in ('02','03-2') then a2.order_no else '' end order_no1,
                                                        case when id_order in ('03','03-3') then a2.order_no else '' end order_no2,
                                        TO_CHAR (a1.create_date,'yyyy/MM/dd') create_time,a1.lot_startqty, a3.step_id, '' arry_lot,
                                        a5.stepm_id || ':' || a6.step_desc stepm_id, a2.quantity,a2.workorder_info,
                        case when id_order in ('01','03-1')  then a1.product_id else '' end product_id,
                        case when id_order in ('01','03-1')  then a7.CPN_ID else '' end CPN_ID,
                        case when id_order in ('02','03-2')  then a1.product_id else '' end product_id1,
                        case when id_order in ('02','03-2') then a7.CPN_ID else '' end CPN_ID1,
                        case when id_order in ('03','03-3')  then a1.product_id else '' end product_id2,
                        case when id_order in ('03','03-3') then a7.CPN_ID else '' end CPN_ID2
                    FROM sd_op_runcard a1,
                         sd_op_workorder a2,
                         sd_base_process a3,
                         sd_base_stepm a5,
                         sd_base_step a6,
                         sd_op_cpn a7
                   WHERE a1.lot_id ='" + str_lotid + @"'
                     AND A2.ORDER_NO = '" + dt.Rows[0]["ORDER_NO"].ToString() + @"'
                     AND a1.process_name = a3.process_name AND a3.flag = 'Y'  
                     AND a5.step_id = a3.step_id
                AND A3.PROCESS_NAME=a5.PROCESS_NAME
                     AND a6.step_id(+) = a5.stepm_id
                     AND a3.step_id != 'OQ105'
                     and a7.product_id=a2.product_id
                ORDER BY a1.lot_id,A3.PROCESS_ID, a5.step_order,a6.STEP_ID) B";
                    }
                }
            }
        }
        else
        {

            string order_no = dt.Rows[0]["order_no"].ToString();
            if (order_no != "NULL")
            {
                if (dt.Rows[0]["lot_flag"].ToString() == "0")
                {
                    sqlreport = @"SELECT  B.LOT_ID,CASE WHEN B.ORDER_NO  IN('" + checkOrder + @"') THEN B.ORDER_NO||'" + errType + @"' ELSE B.ORDER_NO END  ORDER_NO, 
                                                CASE WHEN B.ORDER_NO1 IN('" + checkOrder + @"') THEN B.ORDER_NO1||'" + errType + @"' ELSE B.ORDER_NO1 END  ORDER_NO1,
                                                CASE WHEN B.ORDER_NO2 IN('" + checkOrder + @"') THEN B.ORDER_NO2||'" + errType + @"' ELSE B.ORDER_NO2 END  ORDER_NO2,
CREATE_TIME,B.LOT_STARTQTY,
B.STEP_ID,B.ARRY_LOT,B.STEPM_ID,B.QUANTITY,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END)||B.WORKORDER_INFO WORKORDER_INFO,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END) WORKORDER_INFO1,B.PRODUCT_ID,B.CPN_ID,B.PRODUCT_ID1,B.CPN_ID1,B.PRODUCT_ID2,B.CPN_ID2
FROM
(SELECT   a1.lot_id lot_id,case when id_order in ('01','03-1') then a2.order_no else B.ORDER_NO end order_no,A2.CELL_COME,
                                                            case when id_order in ('02','03-2') then a2.order_no else '' end order_no1,
                                                            case when id_order in ('03','03-3') then a2.order_no else '' end order_no2,
                                    TO_CHAR (a1.create_date,'yyyy/MM/dd') create_time,a1.lot_startqty, a3.step_id,a8.arry_lot,
                                a5.stepm_id || ':' || a6.step_desc stepm_id, a2.quantity,
                                case when id_order in ('01','03-1')  then a1.product_id else '' end product_id,a2.workorder_info,
                                case when id_order in ('01','03-1')  then a7.CPN_ID else '' end CPN_ID,
                                case when id_order in ('02','03-2') then a1.product_id else '' end product_id1,
                                case when id_order in ('02','03-2') then a7.CPN_ID else '' end CPN_ID1,
                                case when id_order in ('03','03-3') then a1.product_id else '' end product_id2,
                                case when id_order in ('03','03-3') then a7.CPN_ID else '' end CPN_ID2
                        FROM sd_op_runcard a1,
                                sd_op_workorder a2,
                                sd_base_process a3,
                                sd_base_stepm a5,
                                sd_base_step a6,
                                sd_op_cpn a7,
                                sd_his_tmplot a8
                        WHERE a1.lot_id ='" + str_lotid + @"'
                            AND A2.ORDER_NO = '" + dt.Rows[0]["ORDER_NO"].ToString() + @"'
                            AND a1.process_name = a3.process_name AND a3.flag = 'Y'  
                            AND a5.step_id = a3.step_id
                    AND A3.PROCESS_NAME=a5.PROCESS_NAME
                            AND a6.step_id(+) = a5.stepm_id
                            AND a3.step_id != 'OQ105'
                            and a7.product_id=a2.product_id
                            and a8.lot_id=a1.lot_id
                    ORDER BY a1.lot_id,A3.PROCESS_ID, a5.step_order,a6.STEP_ID)B";
                }
                else
                {
                    sqlreport = @" SELECT  B.LOT_ID,CASE WHEN B.ORDER_NO  IN('" + checkOrder + @"') THEN B.ORDER_NO||'" + errType + @"' ELSE B.ORDER_NO END  ORDER_NO, 
                                                  CASE WHEN B.ORDER_NO1 IN('" + checkOrder + @"') THEN B.ORDER_NO1||'" + errType + @"' ELSE B.ORDER_NO1 END  ORDER_NO1,
                                                  CASE WHEN B.ORDER_NO2 IN('" + checkOrder + @"') THEN B.ORDER_NO2||'" + errType + @"' ELSE B.ORDER_NO2 END  ORDER_NO2,
CREATE_TIME,B.LOT_STARTQTY,
B.STEP_ID,B.ARRY_LOT,B.STEPM_ID,B.QUANTITY,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END)||B.WORKORDER_INFO WORKORDER_INFO,(CASE WHEN CELL_COME='J1' THEN 'J1黃色' WHEN CELL_COME='D3' THEN 'D3白色' ELSE '' END) WORKORDER_INFO1,B.PRODUCT_ID,B.CPN_ID,B.PRODUCT_ID1,B.CPN_ID1,B.PRODUCT_ID2,B.CPN_ID2
FROM
(SELECT   a1.lot_id lot_id,case when id_order in ('01','03-1') then a2.order_no else '' end order_no,A2.CELL_COME,
                                                            case when id_order in ('02','03-2') then a2.order_no else '' end order_no1,
                                                            case when id_order in ('03','03-3') then a2.order_no else '' end order_no2,
                                    TO_CHAR (a1.create_date,'yyyy/MM/dd') create_time,a1.lot_startqty, a3.step_id,a8.arry_lot,
                                a5.stepm_id || ':' || a6.step_desc stepm_id, a2.quantity,
                                case when id_order in ('01','03-1')  then a1.product_id else '' end product_id,a2.workorder_info,
                                case when id_order in ('01','03-1')  then a7.CPN_ID else '' end CPN_ID,
                                case when id_order in ('02','03-2') then a1.product_id else '' end product_id1,
                                case when id_order in ('02','03-2') then a7.CPN_ID else '' end CPN_ID1,
                                case when id_order in ('03','03-3') then a1.product_id else '' end product_id2,
                                case when id_order in ('03','03-3') then a7.CPN_ID else '' end CPN_ID2
                        FROM sd_op_runcard a1,
                                sd_op_workorder a2,
                                sd_base_process a3,
                                sd_base_stepm a5,
                                sd_base_step a6,
                                sd_op_cpn a7,
                                sd_his_tmplot a8
                        WHERE a1.lot_id ='" + str_lotid + @"'
                            AND A2.ORDER_NO = '" + dt.Rows[0]["ORDER_NO"].ToString() + @"'
                            AND a1.process_name = a3.process_name AND a3.flag = 'Y'  
                            AND a5.step_id = a3.step_id
                    AND A3.PROCESS_NAME=a5.PROCESS_NAME
                            AND a6.step_id(+) = a5.stepm_id
                            AND a3.step_id != 'OQ105'
                            and a7.product_id=a2.product_id
                            and a8.lot_id=a1.lot_id
                    ORDER BY a1.lot_id,A3.PROCESS_ID, a5.step_order,a6.STEP_ID)B";
                }
            }
            else
            {
                sqlreport = @"SELECT   a1.lot_id lot_id,'' order_no, TO_CHAR (a1.create_date,'yyyy/MM/dd') create_time,
                         a1.lot_startqty, a3.step_id,a8.arry_lot,
                         a5.stepm_id || ':' || a6.step_desc stepm_id, 
                         a1.product_id,a7.cpn_id
                    FROM sd_op_runcard a1,
                         sd_base_process a3,
                         sd_base_stepm a5,
                         sd_base_step a6,
                         sd_op_cpn a7,
                         sd_his_tmplot a8
                   WHERE a1.lot_id ='" + str_lotid + @"'
                     AND a1.process_name = a3.process_name AND a3.flag = 'Y'  
                     AND a5.step_id = a3.step_id
                AND A3.PROCESS_NAME=a5.PROCESS_NAME
                     AND a6.step_id(+) = a5.stepm_id
                     AND a3.step_id != 'OQ105'
                     and a7.product_id=a2.product_id
                     and a8.lot_id=a1.lot_id
                ORDER BY a1.lot_id,A3.PROCESS_ID, a5.step_order,a6.STEP_ID";
            }
        }
        dt = PubClass.getdatatableMES(sqlreport);

        return dt;
    }
    private void pdfGenerate(DataTable dt, string strLotid)
    {
        

        rptDoc.Load(this.Server.MapPath("CrystalReport.rpt"));
        rptDoc.SetDataSource(dt);
        string strDateNow = System.DateTime.Now.ToString("yyyyMMdd");
        CrystalDecisions.Shared.DiskFileDestinationOptions objFile = new DiskFileDestinationOptions();
        objFile.DiskFileName = this.Server.MapPath(@"PDF\" + strDateNow + @"\" + strLotid + ".pdf");
        rptDoc.ExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
        rptDoc.ExportOptions.DestinationOptions = objFile;
        rptDoc.ExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
        rptDoc.Export();
    }
    private void Page_Unload(object sender, EventArgs e)
    {
        rptDoc.Dispose();
    } 
}