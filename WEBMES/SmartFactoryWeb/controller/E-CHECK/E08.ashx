<%@ WebHandler Language="C#" Class="E08" %>
using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using ExcelLibrary;
using System.Security;
using System.Web.UI;
using System.Drawing.Text;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient;
using System.IO;
using ExcelLibrary.SpreadSheet;
using System.Collections.Generic;
using System.Text;
using System.Net;
using System.Net.Cache;
using System.Diagnostics;
using System.Linq;
using System.Net.Mail;


public class E08 : IHttpHandler
{
    public MailMessage MyProperty { get; set; }
    private SmtpClient smtp = new SmtpClient();
    public SmtpClient Smtp
    {
        get { return smtp; }
        set { smtp = value; }
    }
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string NUMBER_ID = context.Request["NUMBER_ID"];
        string PdlineName = context.Request["PdlineName"];
        string JJ = context.Request["JJ"];
        string BuName = context.Request["BuName"];
        string ProcessName = context.Request["ProcessName"];
        string Section_Name = context.Request["Section_Name"];
        string datetimepicker = context.Request["datetimepicker"];
        string dataType = context.Request["dataType"];
        string ProjectName = context.Request["ProjectName"];
        string type = context.Request["type"];
        string DnNo = context.Request["DnNo"];
        string ID = context.Request["ID"];
        string Type1 = context.Request["Type1"];
        string Type2 = context.Request["Type2"];
        string Type3 = context.Request["Type3"];
        string Type4 = context.Request["Type4"];
        string Type5 = context.Request["Type5"];
        string Pro = context.Request["Pro"];
        string Remark = context.Request["Remark"];
        string TemplateQty = context.Request["TemplateQty"];
        string isAutoAssy = context.Request["isAutoAssy"] == "true" ? "Y" : "N";
        string ModelName = context.Request["ModelName"];
        string Check_Name = context.Request["Check_Name"];
        string Check_No = context.Request["Check_No"];
        string Check_Item = context.Request["Check_Item"];
        string Check_Qty = context.Request["Check_Qty"];
        string Upper = context.Request["Upper"];
        string Floor = context.Request["Floor"];
        string Unit = context.Request["Unit"];
        string ProjectNo = context.Request["ProjectNo"];
        switch (funcName)
        {

            case "ShowProject":
                rtnValue = ShowProject(PdlineName, ModelName);
                break;
            case "GetProjectNo":
                rtnValue = GetProjectNo(ProjectName, PdlineName, ModelName);
                break;
            case "ShowBuNo":
                rtnValue = ShowBuNo(user);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "ShowProcess":
                rtnValue = ShowProcess(PdlineName);
                break;
            case "ShowModel":
                rtnValue = ShowModel(PdlineName);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "show":
                rtnValue = show(datetimepicker, dataType, PdlineName, ModelName, ProjectName, ProjectNo);
                break;
            case "ShowDown":
                rtnValue = ShowDown(ProjectNo,datetimepicker, dataType, PdlineName, ModelName, ProjectName);
                break;


        }
        context.Response.Write(rtnValue);
    }
    public string ShowDown(string ProjectNo, string datetimepicker, string dataType, string PdlineName,string ModelName,string ProjectName)
    {
        string sql = ""; string sql1 = "";
        if (datetimepicker != "" && datetimepicker != null && datetimepicker != "null")
        {
            sql = sql + " AND C.WORK_DATE ='" + datetimepicker + "'";
        }
        if (dataType != "" && dataType != null && dataType != "null")
        {
            sql = sql + " AND C.WORK_TYPE ='" + dataType + "'";
        }
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql1 = sql1 + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (ModelName != "" && ModelName != null && ModelName != "null")
        {
            sql1 = sql1 + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        if (ProjectName != "" && ProjectName != null && ProjectName != "null")
        {
            sql1 = sql1 + " AND A.PROJECT_NAME ='" + ProjectName + "'";
        }
        if (ProjectNo != "" && ProjectNo != null && ProjectNo != "null")
        {
            sql1 = sql1 + " AND A.PROJECT_NO ='" + ProjectNo + "'";
        }
        string SQL = $"SELECT DISTINCT A.PROJECT_ID,A.PROJECT_NO FROM SAJET.SYS_PROJECT_MODEL_BASE A " +
                     $" INNER JOIN SAJET.SYS_ECHECK_PROJECT_BASE B ON A.PROJECT_ID=B.PROJECT_ID AND A.CHECK_NO=B.CHECK_NO AND A.CHECK_NAME=B.CHECK_NAME AND A.CHECK_ITEM=B.CHECK_ITEM" +
                     $" LEFT JOIN  SAJET.G_CHECK_WORK_BASE_INFO C  ON C.PROJECT_ID=A.PROJECT_ID AND C.CHECK_NO=A.CHECK_NO AND C.CHECK_NAME=A.CHECK_NAME AND C.CHECK_ITEM=A.CHECK_ITEM "+sql+" " +
                     $" WHERE 1=1 "+sql1+" ORDER BY A.PROJECT_NO";
        DataTable dt = PubClass.getdatatableMES(SQL);
        string LOG1 = $"<tr style=text-align:center ><td rowspan='2' colspan='1'></td><td style=text-align:center colspan='1'>机种名称</td><td style=text-align:center colspan='1'>{ModelName}</td><td style=text-align:center colspan='1'>CQP 文件版本</td><td style=text-align:center colspan='4'></td><td style=text-align:center colspan='11'></td></tr>" +
                     $"<td style=text-align:center colspan='1'>线别</td><td style=text-align:center colspan='1'>{PdlineName}</td><td style=text-align:center colspan='1'>A</td><td style=text-align:center colspan='4'>日期</td><td style=text-align:center colspan='11'>{datetimepicker}</td></tr>";
        string LOG2 = "";
        if(dataType=="白班")
        {
            LOG2 = $"<tr style=text-align:center><td colspan='1'>工序号</td><td colspan='1'>制程名称</td><td colspan='2'>检查事项-Check Point</td><td colspan='1'>抽测数量</td><td colspan='1'>管控下限</td><td colspan='1'>管控上限</td><td colspan='1'>抽检频率</td><td colspan='2'>08:00-10:00</td><td colspan='2'>10:00-12:00</td><td colspan='2'>13:00-15:00</td><td colspan='2'>15:00-17:00</td><td colspan='2'>17:00-19:00</td><td colspan='1'>结果</td></tr>";
        }
        if(dataType=="夜班")
        {
            LOG2 = $"<tr style=text-align:center><td colspan='1'>工序号</td><td colspan='1'>制程名称</td><td colspan='2'>检查事项-Check Point</td><td colspan='1'>抽测数量</td><td colspan='1'>管控下限</td><td colspan='1'>管控上限</td><td colspan='1'>抽检频率</td><td colspan='2'>20:00-22:00</td><td colspan='2'>22:00-24:00</td><td colspan='2'>01:00-03:00</td><td colspan='2'>03:00-05:00</td><td colspan='2'>05:00-07:00</td><td colspan='1'>结果</td></tr>";
        }
        string tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1>";
        string LOG6 = "";
        for(int i=0;i<=dt.Rows.Count-1;i++)
        {
                     SQL = $"SELECT A.PROJECT_NO,A.PROJECT_NAME,A.CHECK_NO,A.CHECK_NAME,A.CHECK_ITEM,A.CHECK_QTY,A.FREQUENCY,A.FLOOR,A.UPPER,C.TYPE1,C.TYPE2,C.TYPE3,C.TYPE4,C.TYPE5,C.RESULT FROM SAJET.SYS_PROJECT_MODEL_BASE A " +
                     $" INNER JOIN SAJET.SYS_ECHECK_PROJECT_BASE B ON A.PROJECT_ID=B.PROJECT_ID AND A.CHECK_NO=B.CHECK_NO AND A.CHECK_NAME=B.CHECK_NAME AND A.CHECK_ITEM=B.CHECK_ITEM" +
                     $" LEFT JOIN  SAJET.G_CHECK_WORK_BASE_INFO C  ON C.PROJECT_ID=A.PROJECT_ID AND C.CHECK_NO=A.CHECK_NO AND C.CHECK_NAME=A.CHECK_NAME AND A.PROJECT_ID=C.PROJECT_ID AND A.MODEL_NAME=C.MODEL_NAME AND C.CHECK_ITEM=A.CHECK_ITEM "+sql+" " +
                     $" WHERE A.PROJECT_ID='{dt.Rows[i]["PROJECT_ID"].ToString()}'AND A.PROJECT_NO='{dt.Rows[i]["PROJECT_NO"].ToString()}'"+sql1+" " +
                     $" ORDER BY TO_NUMBER(A.CHECK_NO)";
        DataTable dt1 = PubClass.getdatatableMES(SQL);      
            string LOG51 = "";string LOG5 = "";
            LOG51 = $"<tr style=text-align:center><td rowspan='{dt1.Rows.Count.ToString()}' colspan='1'>{dt.Rows[i]["PROJECT_NO"].ToString()}</td><td rowspan='{dt1.Rows.Count.ToString()}' colspan='1'>{dt1.Rows[0]["PROJECT_NAME"].ToString()}</td>";
            for(int L=0;L<=dt1.Rows.Count-1;L++)
            {
                string TYPE1 = dt1.Rows[L]["CHECK_NO"].ToString() + "." + dt1.Rows[L]["CHECK_ITEM"].ToString();
                LOG5 += $"<td  style=text-align:center colspan='1'>{dt1.Rows[L]["CHECK_NAME"].ToString()}</td><td style=text-align:center colspan='1'>{TYPE1}</td><td style=text-align:center colspan='1'>{dt1.Rows[L]["CHECK_QTY"].ToString()}</td><td style=text-align:center colspan='1'>{dt1.Rows[L]["FLOOR"].ToString()}</td><td style=text-align:center colspan='1'>{dt1.Rows[L]["UPPER"].ToString()}</td><td style=text-align:center colspan='1'>{dt1.Rows[L]["FREQUENCY"].ToString()}</td>";
                if( dt1.Rows[L]["FREQUENCY"].ToString()=="2")
                {
                    LOG5 += $"<td style=text-align:center colspan='2'>{dt1.Rows[L]["TYPE1"].ToString()}</td><td style=text-align:center colspan='2'>{dt1.Rows[L]["TYPE2"].ToString()}</td><td style=text-align:center colspan='2'>{dt1.Rows[L]["TYPE3"].ToString()}</td><td style=text-align:center colspan='2'>{dt1.Rows[L]["TYPE4"].ToString()}</td><td style=text-align:center colspan='2'>{dt1.Rows[L]["TYPE5"].ToString()}</td><td style=text-align:center colspan='1'>{dt1.Rows[L]["RESULT"].ToString()}</td>";
                }
                if( dt1.Rows[L]["FREQUENCY"].ToString()=="4")
                {
                    LOG5 += $"<td style=text-align:center colspan='4'>{dt1.Rows[L]["TYPE1"].ToString()}</td><td style=text-align:center colspan='4'>{dt1.Rows[L]["TYPE3"].ToString()}</td><td style=text-align:center colspan='2'>{dt1.Rows[L]["TYPE5"].ToString()}</td><td style=text-align:center colspan='1'>{dt1.Rows[L]["RESULT"].ToString()}</td>";
                } if( dt1.Rows[L]["FREQUENCY"].ToString()=="12")
                {
                    LOG5 += $"<td style=text-align:center colspan='10'>{dt1.Rows[L]["TYPE1"].ToString()}</td><td style=text-align:center colspan='1'>{dt1.Rows[L]["RESULT"].ToString()}</td>";
                }
                LOG5 = LOG5 + $"</tr>";
            }
            LOG6 += LOG51 + LOG5 + $"</tr>";

        }
        tableHtml += LOG1 + LOG2 + LOG6 + "</table></body></html>";
        return tableHtml;
    }

    public string GetProjectNo(string ProjectName, string PdlineName, string ModelName)
    {
        string sSQL = $@"SELECT DISTINCT PROJECT_NO FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}'AND PROJECT_NAME='{ProjectName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowProject(string PdlineName, string ModelName)
    {
        string sSQL = $@"SELECT DISTINCT PROJECT_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowModel(string PdlineName)
    {
        string sSQL = $@"SELECT DISTINCT MODEL_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE WHERE PDLINE_NAME='{PdlineName}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string datetimepicker, string dataType, string PdlineName, string ModelName, string ProjectName, string ProjectNo)
    {
        string sql = ""; string sql1 = "";
        if (datetimepicker != "" && datetimepicker != null && datetimepicker != "null")
        {
            sql = sql + " AND C.WORK_DATE ='" + datetimepicker + "'";
        }
        if (dataType != "" && dataType != null && dataType != "null")
        {
            sql = sql + " AND C.WORK_TYPE ='" + dataType + "'";
        }
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql1 = sql1 + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (ModelName != "" && ModelName != null && ModelName != "null")
        {
            sql1 = sql1 + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        if (ProjectName != "" && ProjectName != null && ProjectName != "null")
        {
            sql1 = sql1 + " AND A.PROJECT_NAME ='" + ProjectName + "'";
        }
        if (ProjectNo != "" && ProjectNo != null && ProjectNo != "null")
        {
            sql1 = sql1 + " AND A.PROJECT_NO ='" + ProjectNo + "'";
        }
        string SQL = $"SELECT A.PROJECT_NO,A.CHECK_NO,A.CHECK_NAME,A.CHECK_ITEM,A.FREQUENCY,A.UNIT,A.CHECK_QTY,A.FLOOR,A.UPPER,C.TYPE1,C.TYPE2,C.TYPE3,C.TYPE4,C.TYPE5 FROM SAJET.SYS_PROJECT_MODEL_BASE A " +
                     $" INNER JOIN SAJET.SYS_ECHECK_PROJECT_BASE B ON A.PROJECT_ID=B.PROJECT_ID AND A.CHECK_NO=B.CHECK_NO AND A.CHECK_NAME=B.CHECK_NAME AND A.CHECK_ITEM=B.CHECK_ITEM" +
                     $" LEFT JOIN  SAJET.G_CHECK_WORK_BASE_INFO C  ON C.PROJECT_ID=A.PROJECT_ID AND A.MODEL_NAME=C.MODEL_NAME AND C.CHECK_NO=A.CHECK_NO AND C.CHECK_NAME=A.CHECK_NAME AND C.CHECK_ITEM=A.CHECK_ITEM "+sql+" " +
                     $" WHERE 1=1 "+sql1+" " +
                     $" ORDER BY PROJECT_NO,TO_NUMBER(CHECK_NO)";
        DataTable dt = PubClass.getdatatableMES(SQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowBuNo(string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查\"}]";

        }
        string sSQL = $@"SELECT SECTON_NAME,STATUS FROM  SAJET.SYS_CHECK_SECTOR_CONFIG WHERE   EMP_ID='{userEmpId}'AND CHECK_TYPE='2' ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此人员未维护部门信息,请检查\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + dt.Rows[0][0].ToString() + "\",\"ERR_SN\":\"" + dt.Rows[0][1].ToString() + "\"}]";
    }
    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT DISTINCT PDLINE_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE ) ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'AND PDLINE_NAME IN(SELECT DISTINCT PDLINE_NAME FROM SAJET.SYS_PROJECT_MODEL_BASE )  AND PDLINE_NAME LIKE'" + JJ + "%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowProcess(string PdlineName)
    {
        string SSQL = "SELECT DISTINCT B.PROCESS_NAME FROM SAJET.SYS_TERMINAL A ,SAJET.SYS_PROCESS B,SAJET.SYS_PDLINE C WHERE C.PDLINE_NAME = '" + PdlineName + "'AND A.PROCESS_ID = B.PROCESS_ID AND A.PDLINE_ID=C.PDLINE_ID ";
        DataTable dt = PubClass.getdatatableMES(SSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetDate()
    {
        string TIME; string DATE;
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD'),TO_CHAR(SYSDATE,'HH24'),TO_CHAR(SYSDATE-1,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (int.Parse(dt.Rows[0][1].ToString()) >= 08 && int.Parse(dt.Rows[0][1].ToString()) < 20)
        {
            TIME = "白班";
            DATE = dt.Rows[0][0].ToString();

        }
        else
        {
            TIME = "夜班";
            DATE = dt.Rows[0][2].ToString();
        }
        return "[{\"ERR_CODE\":\"" + TIME + "\",\"ERR_MSG\":\"" + DATE + "\",\"ERR_TIME\":\"" + dt.Rows[0][1].ToString() + "\"}]";
    }
    public string getEmpIdByNo(string user)
    {
        string sSQL = $@"SELECT EMP_ID 
                            FROM SAJET.SYS_EMP SE 
                            WHERE EMP_NO = '{user}'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "";
        }
        return dt.Rows[0]["EMP_ID"].ToString();
    }


    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}