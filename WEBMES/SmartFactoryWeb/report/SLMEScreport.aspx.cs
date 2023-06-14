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

public partial class SLMEScreport : System.Web.UI.Page
{
    PubClass pc = new PubClass();
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
        if (dt.Rows.Count > 0)
        {
            string daduilot = dt.Rows[0]["ary_lot"].ToString();
            sqlreport = @"SELECT  B.LOT_ID,CASE WHEN B.ORDER_NO  IN('" + dt.Rows[0]["ORDER_NO"].ToString() + @"') THEN B.ORDER_NO||'' ELSE B.ORDER_NO END  ORDER_NO, 
                        CASE WHEN B.ORDER_NO1 IN('" + dt.Rows[0]["ORDER_NO"].ToString() + @"') THEN B.ORDER_NO1||'' ELSE B.ORDER_NO1 END  ORDER_NO1,
                        CASE WHEN B.ORDER_NO2 IN('" + dt.Rows[0]["ORDER_NO"].ToString() + @"') THEN B.ORDER_NO2||'' ELSE B.ORDER_NO2 END  ORDER_NO2,
                        CREATE_TIME,B.LOT_STARTQTY,B.STEP_ID,B.STEPM_ID,B.QUANTITY,B.WORKORDER_INFO WORKORDER_INFO,
                        '' WORKORDER_INFO1,B.PRODUCT_ID,B.CPN_ID,B.PRODUCT_ID1,B.CPN_ID1,B.PRODUCT_ID2,B.CPN_ID2,'" + daduilot + @"'ARY_LOT
                        FROM
                        (SELECT A1.LOT_ID LOT_ID,'' CELL_COME,
                        CASE WHEN ID_ORDER IN ('01','03-1') THEN A2.ORDER_NO  ELSE '' END ORDER_NO,
                        CASE WHEN ID_ORDER IN ('02','03-2') THEN A2.ORDER_NO ELSE '' END ORDER_NO1,
                        CASE WHEN ID_ORDER IN ('03','03-3') THEN A2.ORDER_NO ELSE '' END ORDER_NO2, 
                        TO_CHAR (A1.CREATE_DATE,'yyyy/MM/dd') CREATE_TIME,A1.LOT_STARTQTY, A5.STEP_ID,
                        A5.STEPM_ID || ':' || A6.STEP_DESC STEPM_ID, A2.QUANTITY,A2.WORKORDER_INFO,
                        CASE WHEN ID_ORDER IN ('01','03-1')  THEN A1.PRODUCT_ID ELSE '' END PRODUCT_ID,
                        '' CPN_ID,
                        CASE WHEN ID_ORDER IN ('02','03-2')  THEN A1.PRODUCT_ID ELSE '' END PRODUCT_ID1,
                        '' CPN_ID1,
                        CASE WHEN ID_ORDER IN ('03','03-3')  THEN A1.PRODUCT_ID ELSE '' END PRODUCT_ID2,
                        '' CPN_ID2
                        FROM SD_OP_RUNCARD A1,
                        SD_OP_WORKORDER A2,
                        SD_BASE_STEPM A5,
                        SD_BASE_STEP A6
                        WHERE A1.LOT_ID IN '" + str_lotid + @"'
                        AND A2.ORDER_NO = '" + dt.Rows[0]["ORDER_NO"].ToString() + @"'
                        AND A1.PROCESS_NAME = A5.process_name 
                        AND A6.STEP_ID(+) = A5.STEPM_ID
                        AND A5.STEP_ID != 'OQ105'
                        ORDER BY A1.LOT_ID ,A5.STEP_ORDER,A6.STEP_ID) B";
        }
        dt = PubClass.getdatatableMES(sqlreport);
        return dt;
    }
    private void pdfGenerate(DataTable dt, string strLotid)
    {
        rptDoc.Load(this.Server.MapPath("SLMESCrystalReport.rpt"));
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