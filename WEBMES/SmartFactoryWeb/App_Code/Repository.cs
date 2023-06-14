using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Collections;
using System.Collections.Generic;
using System.Data.OracleClient;

namespace MesRepository
{
    public class Repository
    {
        static string WOKDSD = System.Configuration.ConfigurationManager.ConnectionStrings["WOKDSD"].ConnectionString;
        static string MESDB01 = System.Configuration.ConfigurationManager.ConnectionStrings["MESDB01"].ConnectionString;
        static string MES2DB01 = System.Configuration.ConfigurationManager.ConnectionStrings["MES2DB01"].ConnectionString;
        static string MesCon = "";
        static string Fab = System.Configuration.ConfigurationManager.AppSettings["Fab"].ToString();

        public static OracleConnection dbconMES()
        {
            if (Fab == "Fab1/2")
            {
                MesCon = MESDB01;
            }
            if (Fab == "Fab3")
            {
                MesCon = MES2DB01;
            }

            OracleConnection con = new OracleConnection();
            con = new OracleConnection(MesCon);
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
        public static OracleConnection dbconDsd()
        {
            OracleConnection con = new OracleConnection();
            con = new OracleConnection(WOKDSD);
            return con;
        }
        //public DataTable getdatatableDsd(string sql)
        //{
        //    OracleDataAdapter oda = new OracleDataAdapter();
        //    oda = new OracleDataAdapter(sql, dbcon());
        //    DataSet ds = new DataSet();
        //    oda.Fill(ds, "tmp");
        //    DataTable returndt = ds.Tables["tmp"];
        //    dbcon().Close();
        //    return returndt;
        //}
        //public void getdatatablenoreturnDsd(string sql)
        //{
        //    OracleDataAdapter oda = new OracleDataAdapter();
        //    oda = new OracleDataAdapter(sql, dbcon());
        //    DataSet ds = new DataSet();
        //    oda.Fill(ds, "tmp");
        //    dbcon().Close();
        //}
    }

}
