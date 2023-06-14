using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.OracleClient;
using DataHelper;




public partial class creportOQC : System.Web.UI.Page
{
    PubClass pc = new PubClass();


    protected void Page_Load(object sender, EventArgs e)
    {
        //string lot_id = "'000020130312-0006.004'";
        string str_lotid = "";
        string ll = Request.Params[0].ToString();

        string[] str_l = ll.Split(',');
        for (int i = 0; i < str_l.Length; i++)
        {
            str_lotid = str_lotid + "'" + str_l[i].ToString() + "',";
        }

            string sqlreport = "";
            str_lotid = str_lotid.Remove(str_lotid.Length - 1, 1);
            string sql = "select * from sd_op_elot where elot_id in (" + str_lotid + ")";
            DataTable dt = PubClass.getdatatableMES(sql);
          
                if (dt.Rows.Count > 0)
                {
                    sqlreport = @"select c.order_no,a.qty,b.elot_id,b.elot_id||'*' elot_new,c.lot_id,c.product_id,to_char(sysdate,'yyyy-MM-dd')from
                                   (select sum(in_qty) qty from sd_op_elot where elot_id in(" + str_lotid + @")) a,
                                    sd_op_elot b,
                                    sd_op_lotinfo c
                                    where b.LOT_ID=c.lot_id
                                    and b.elot_id in(" + str_lotid + @")";
                }
                OracleConnection oracon = PubClass.dbconMES();
                            oracon.Open();
                            OracleDataAdapter oda = new OracleDataAdapter(sqlreport, oracon);
                            DataSet ds = new DataSet();
                            oda.Fill(ds, "ABC");
                            string reportPath = Server.MapPath("OQC.rpt");
                            CrystalReportSource1.ReportDocument.Load(reportPath);
                            CrystalReportSource1.ReportDocument.SetDataSource(ds.Tables["ABC"].DefaultView);
                            CrystalReportSource1.DataBind();
                            CrystalReportViewer1.ReportSource = CrystalReportSource1;
                            CrystalReportViewer1.DataBind();
                            CrystalReportViewer1.Visible = true;
                            //CrystalReportViewer1.Dispose();
                            oracon.Close();
    }
}