<%@ WebHandler Language="C#" Class="G004Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Data.OracleClient;
using System.Net;
using System.Collections.Generic;
using System.Windows.Forms;
using Excel = Microsoft.Office.Interop.Excel;
using System.Reflection;
using System.IO;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;



public class G004Controller : IHttpHandler
{

    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string turl = System.Web.HttpContext.Current.Server.MapPath("G06.html");
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string lotno = context.Request["lotno"];
        switch (funcName)
        {
            case "tmpInsert":
                rtnValue = tmpInsert(lotno);
                break;
            case "getip":
                rtnValue = getip();
                break;
            case "CreatePDF":
                rtnValue = createPDF(lotno, turl);
                break;
        }
        context.Response.Write(rtnValue);
    }
    public static string getip()
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

    private string createPDF(string strLotId, string strurl)
    {
        string rtn;
        string str_sql = "select * from sd_op_lotinfo where lot_id='" + strLotId + "'";
        DataTable dt = PubClass.getdatatableMES(str_sql);
        if (dt.Rows.Count == 0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此" + strLotId + "產品對應的LOT號有問題，請確認IT！\"}]";
            return rtn;
        }
        else
        {
            rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + strLotId + "\"}]";
            return rtn;
        }
    }

    private void pdfGenerate(DataTable dt, string strPathrpt, string strPathpdf)
    {
        CrystalDecisions.CrystalReports.Engine.ReportDocument rptDoc = new ReportDocument();

        rptDoc.Load(strPathrpt);
        rptDoc.SetDataSource(dt);
        CrystalDecisions.Shared.DiskFileDestinationOptions objFile = new DiskFileDestinationOptions();
        objFile.DiskFileName = strPathpdf;
        rptDoc.ExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
        rptDoc.ExportOptions.DestinationOptions = objFile;
        rptDoc.ExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
        rptDoc.Export();
    }

    private DataTable getdatelot(string str_lotid)
    {
        string sqlreport = "";
        string sql = "select * from sd_op_lotinfo where lot_id ='" + str_lotid + "'";
        DataTable dt = PubClass.getdatatableMES(sql);
        if (dt.Rows.Count == 0)
        {
            return dt;
        }

        DataTable dtlot = PubClass.getdatatableMES(sqlreport);

        return dtlot;
    }

    private string tmpInsert(string strLotId)
    {

        string rtn = "";
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