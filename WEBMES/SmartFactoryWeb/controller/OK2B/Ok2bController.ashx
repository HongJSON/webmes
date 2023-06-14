<%@ WebHandler Language= "C#" Class="Ok2bController" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Security;
using System.Web.UI;
using System.Drawing.Text;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient;
using System.IO;
using System.Text;
using System.Net;
using System.Net.Cache;
using System.Diagnostics;
using System.Net.Mail;
using System.Threading;
using System.Threading.Tasks;
using Spire.Xls;

public class Ok2bController : IHttpHandler
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
        string taskName = context.Request["taskName"];
        string modelName = context.Request["modelName"];
        string ary_lot = context.Request["ary_lot"];
        string site = context.Request["site"];
        string step = context.Request["step"];
        string line = context.Request["line"];
        string eqp = context.Request["eqp"];
        string desc = context.Request["desc"];
        string pos = context.Request["pos"];
        string id = context.Request["id"];
        string templateName = context.Request["templateName"];
        string quantity = context.Request["quantity"];
        string dataType = context.Request["dataType"];
        string expiryDate = context.Request["expiryDate"];
        switch (funcName)
        {
            case "showModelName":
                rtnValue = showModelName(user);
                break;
            case "showTemplateName":
                rtnValue = showTemplateName(dataType,user);
                break;
            case "addTaskInfo":
                rtnValue = addTaskInfo(dataType, taskName, modelName, user, templateName, expiryDate);
                break;
            case "show":
                rtnValue = show(dataType, taskName, modelName);
                break;
            case "del":
                rtnValue = del(id, dataType, user);
                break;
            case "assyTaskFile":
                rtnValue = assyTaskFile(id, dataType, user);
                break;
            case "downFile":
                rtnValue = downFile(id, dataType, user, context);
                break;
            case "showSystemTemplate":
                rtnValue = showSystemTemplate(dataType, user);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string showSystemTemplate(string dataType, string user)
    {
        string sSQL = $@"SELECT FILE_NAME ,IS_AUTO_ASSY   
                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG SM 
                            WHERE ENABLED = 'Y'
                            AND DATA_TYPE = '{dataType}' 
                            AND TEMPLATE_NAME = '{dataType}系统标准'
                            ORDER BY TEMPLATE_NAME ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }


    public string downFile(string id, string dataType, string user, HttpContext context)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }

        string sSQL = $@"SELECT STATUS ,FILE_PATH 
                            FROM SAJET.SYS_OK2X_TASK_CONFIG SOXTC 
                            WHERE ID = '{id}'
                            AND ENABLED = 'Y'
                            AND DATA_TYPE = '{dataType}'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前任务不存在,请刷新页面!\"}]";
            
        }

        string filePath = dt.Rows[0]["FILE_PATH"].ToString();
        string status = dt.Rows[0]["STATUS"].ToString();

        if (status != "9")
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前任务状态不是[已汇总],请汇总后再进行下载!\"}]";
        }

        if (File.Exists(filePath))
        {
            System.IO.FileInfo file = new System.IO.FileInfo(filePath);
            context.Response.ContentType = "application/ms-download";
            context.Response.Clear();
            context.Response.AddHeader("Content-Type", "application/octet-stream");
            context.Response.Charset = "utf-8";
            context.Response.AddHeader("Content-Disposition", "attachment;filename=" + System.Web.HttpUtility.UrlEncode(file.Name, System.Text.Encoding.UTF8));
            context.Response.AddHeader("Content-Length", file.Length.ToString());
            context.Response.WriteFile(filePath);
            context.Response.Flush();
            context.Response.Clear();

            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + filePath + "\"}]";
        }

        return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件路径异常,请刷新页面后查看!\"}]";
    }

    public string assyTaskFile(string id,string dataType,string user)
    {
        string empId = getEmpIdByNo(user);

        if (empId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户 信息不存在,请检查！\"}]";
        }

        string sSQL = $@"SELECT SOTC.TASK_NAME ,SOTC.STATUS ,SOXTC.ID AS TEMPLATE_ID ,GOXUFL.FILE_NAME,GOXUFL.FILE_PATH  
                            FROM SAJET.SYS_OK2X_TASK_CONFIG SOTC 
                            INNER JOIN SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC ON SOTC.TEMPLATE_NAME = SOXTC.TEMPLATE_NAME 
	                            AND SOXTC.ENABLED = 'Y'
                                AND SOXTC.IS_AUTO_ASSY = 'Y'
	                            AND SOXTC.DATA_TYPE = SOTC.DATA_TYPE 
                            LEFT JOIN SAJET.G_OK2X_UPLOAD_FILE_LOG GOXUFL ON SOTC.ID = GOXUFL.TASK_ID 
	                            AND SOXTC.ID = GOXUFL.TEMPLATE_ID 
	                            AND GOXUFL.ENABLED = 'Y'
                            WHERE SOTC.ID = '{id}'
                            AND SOTC.DATA_TYPE = '{dataType}'
                            AND SOTC.ENABLED = 'Y'
                            ORDER BY SOXTC.CREATE_DATE";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前任务名称不存在或者无可合成任务！\"}]";
        }

        sSQL = $@"UPDATE SAJET.SYS_OK2X_TASK_CONFIG SOXTC 
                    SET STATUS = 7,ERROR_MSG = ''
                    WHERE ID = '{id}'
                    AND ENABLED = 'Y'";

        PubClass.getdatatablenoreturnMES(sSQL);

        string taskAssyFilePath = "";
        int errorNum = 0;

        Task task = new Task(() => {

            Restart:
            try
            {
                //新建一个Excel工作簿
                Microsoft.Office.Interop.Excel.Application Eapp = new Microsoft.Office.Interop.Excel.Application();
                Eapp.Visible = false;
                Eapp.DisplayAlerts = false;
                Eapp.AlertBeforeOverwriting = false;
                Microsoft.Office.Interop.Excel.Workbook wbk = Eapp.Workbooks.Add();
                Microsoft.Office.Interop.Excel._Worksheet sheet = (Microsoft.Office.Interop.Excel._Worksheet)wbk.Sheets[1];

                string taskName = "";

                try
                {
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        taskName = dt.Rows[i]["TASK_NAME"].ToString();
                        string taskStatus = dt.Rows[i]["STATUS"].ToString();
                        string templateId = dt.Rows[i]["TEMPLATE_ID"].ToString();
                        string fileName = dt.Rows[i]["FILE_NAME"].ToString();
                        string filePath = dt.Rows[i]["FILE_PATH"].ToString();

                        if (taskStatus != "8")
                        {
                            //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"未完结状态任务无法汇总!\"}]";
                            TaskNameErrorLog(id, "未完结状态任务无法汇总!");
                            return;
                        }

                        if (filePath == null || filePath.Trim().Length == 0)
                        {
                            //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"[" + fileName + "] 文件未上传,请检查!\"}]";
                            TaskNameErrorLog(id, $@"文件:{fileName}不存在,请检查!");
                            return;
                        }

                        string ExcelFile1 = filePath;

                        try
                        {

                            Microsoft.Office.Interop.Excel.Workbook wbk1 = Eapp.Workbooks.Open(ExcelFile1);

                            try
                            {
                                //sheet1.Copy(Type.Missing, sheet);//sheet1复制在sheet的后面
                                for (int j = 1; j <= wbk1.Sheets.Count; j++)
                                {
                                    Microsoft.Office.Interop.Excel._Worksheet sheet1 = (Microsoft.Office.Interop.Excel._Worksheet)wbk1.Sheets[j];
                                    sheet1.Copy(sheet, Type.Missing);//sheet1复制在sheet的前面
                                }
                            }
                            catch (System.Exception ex)
                            {
                                //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件汇总失败!\"}]";
                                TaskNameErrorLog(id, $"文件:{fileName} 汇总异常,请检查当前文件");
                                return;
                            }
                            finally
                            {
                                wbk1.Close();
                            }
                        }
                        catch (Exception ex)
                        {
                            TaskNameErrorLog(id, $"文件:{fileName} 打开异常,请检查当前文件");
                            return;
                        }
                        

                        
                    }

                    //保存新文件
                    string sharePath = System.Configuration.ConfigurationManager.ConnectionStrings["SHARE_PATH"].ConnectionString;
                    try
                    {
                        if (!System.IO.Directory.Exists(sharePath))
                        {
                            System.IO.Directory.CreateDirectory(sharePath);
                        }
                    }
                    catch (System.Exception ex)
                    {
                        //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件服务器保存异常,请联系MES团队!\"}]";
                        TaskNameErrorLog(id, $"文件服务器异常路径创建异常,请联系MES团队");
                        return;
                    }

                    string fileid = System.Guid.NewGuid().ToString("N");
                    taskAssyFilePath = sharePath + "AssyFiles\\" + id + "\\" + fileid + "\\";

                    try
                    {
                        if (!System.IO.Directory.Exists(taskAssyFilePath))
                        {
                            System.IO.Directory.CreateDirectory(taskAssyFilePath);
                        }
                    }
                    catch (System.Exception ex)
                    {
                        //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件服务器保存异常,请联系MES团队!\"}]";
                        TaskNameErrorLog(id, $"文件服务器异常路径创建异常,请联系MES团队");
                        return;
                    }

                    //taskAssyFilePath = taskAssyFilePath + taskName.Replace(":","") + ".xlsx";
                    taskAssyFilePath = taskAssyFilePath + dataType + "-" + user + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xlsx";

                    //string taskAssyFilePath = @"D:\03 BU17_MES_SOURCE_CODE\智能工厂\SmartFactoryWeb\SmartFactoryWeb\" + taskName + ".xlsx";
                    try
                    {
                        wbk.SaveAs(taskAssyFilePath);
                    }
                    catch (System.Exception ex)
                    {
                        //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件保存失败,请联系MES团队!\"}]";
                        TaskNameErrorLog(id, $"汇总文件保存文件服务器异常,请联系MES团队");
                        return;
                    }
                }
                finally
                {
                    wbk.Close();
                    Eapp.Quit();
                }
            }
            catch (Exception ex)
            {
                TaskNameErrorLog(id, $"任务汇总异常,请重试");
                return;
            }

            sSQL = $@"UPDATE SAJET.SYS_OK2X_TASK_CONFIG SOXTC 
                    SET STATUS = 9,FILE_PATH = '{taskAssyFilePath}'
                    WHERE ID = '{id}'
                    AND ENABLED = 'Y'";

            PubClass.getdatatablenoreturnMES(sSQL);

            //return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"文件开始汇总,请稍后查看!\"}]";
        });

        task.Start();

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"文件开始汇总,请稍后查看!\"}]";
    }

    public void TaskNameErrorLog(string taskId,string errorMsg)
    {
        string sSQL = $@"UPDATE SAJET.SYS_OK2X_TASK_CONFIG SOXTC 
                        SET ERROR_MSG = '{errorMsg}', STATUS =  8
                        WHERE ID = '{taskId}'
                        AND ENABLED = 'Y'";

        PubClass.getdatatablenoreturnMES(sSQL);
    }

    public string show(string dataType, string taskName,string modelName)
    {
        string sSQL = $@"SELECT SOBTC.ID ,SOBTC.MODEL_NAME,SOBTC.TASK_NAME ,
	                        CASE SOBTC.STATUS WHEN 0 THEN '待填报' WHEN 7 THEN '汇总中' WHEN 8 THEN '已完结' WHEN 9 THEN '已汇总' END AS STATUS,
	                        SE.EMP_NAME ,TO_CHAR(SOBTC.CREATE_DATE,'yyyy-MM-dd hh24:mi:ss') AS DATETIME ,SOBTC.TEMPLATE_NAME,SOBTC.DATA_TYPE,
                            TO_CHAR(EXPIRY_DATE,'yyyy-MM-dd hh24:mi:ss') AS EXPIRYDATE,SOBTC.ERROR_MSG
                        FROM SAJET.SYS_OK2X_TASK_CONFIG SOBTC 
                        INNER JOIN SAJET.SYS_EMP SE ON SOBTC.EMP_ID = SE.EMP_ID 
                        WHERE SOBTC.DATA_TYPE = '{dataType}'
                        AND SOBTC.ENABLED = 'Y'
                        AND SOBTC.MODEL_NAME LIKE '%{modelName}%'
                        AND SOBTC.TASK_NAME LIKE '{taskName}%'
                        ORDER BY SOBTC.STATUS ,SOBTC.CREATE_DATE DESC";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string addTaskInfo(string dataType,string taskName,string modelName, string user,string templateName,string expiryDate)
    {
        string empId = getEmpIdByNo(user);

        if (empId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户 信息不存在,请检查！\"}]";
        }

        if (taskName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"任务名称未输入,请检查！\"}]";
        }

        if (modelName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"机种信息未选择,请检查！\"}]";
        }

        if (expiryDate.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"截止日期未选择,请检查！\"}]";
        }

        if (templateName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"模板未选择,请检查！\"}]";
        }

        string id = System.Guid.NewGuid().ToString("N");

        string sSQL = $@"SELECT *
                        FROM SAJET.SYS_OK2X_TASK_CONFIG SOBTC 
                        WHERE TASK_NAME = '{taskName}'
                        AND DATA_TYPE = '{dataType}'
                        AND ENABLED = 'Y'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前任务名称已存在！\"}]";
        }

        sSQL = $@"INSERT INTO SAJET.SYS_OK2X_TASK_CONFIG
                        (ID, TASK_NAME, STATUS, EMP_ID, CREATE_DATE, MODIFY_DATE,MODEL_NAME,DATA_TYPE,UPDATE_EMP,ENABLED,TEMPLATE_NAME,EXPIRY_DATE)
                        VALUES(
                        '{id}', '{taskName}', 0, {empId}, SYSDATE, SYSDATE,'{modelName}','{dataType}',{empId},'Y','{templateName}',TO_DATE('{expiryDate}','yyyy-MM-dd hh24:mi:ss'))";

        PubClass.getdatatablenoreturnMES(sSQL);

        sSQL = $@"SELECT wm_concat(DISTINCT SED.EMP_NO) AS EMPNOS,wm_concat(DISTINCT SED.EMAIL) AS EMAILS
                    FROM SAJET.SYS_OK2X_TASK_CONFIG SOTC 
                    INNER JOIN SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC ON SOTC.TEMPLATE_NAME = SOXTC.TEMPLATE_NAME 
	                    AND SOXTC.ENABLED = 'Y'
                    INNER JOIN SAJET.SYS_EMP SED ON SOXTC.DRI_EMP_ID = SED.EMP_ID 
                    WHERE SOTC.ID = '{id}'";

        dt = PubClass.getdatatableMES(sSQL);

        string emps = dt.Rows[0]["EMPNOS"].ToString();
        string emails = dt.Rows[0]["EMAILS"].ToString();

        Task task = new Task(() => {
            ConnWebApi(emps, $@"{dataType} 任务提示:\r\n机种[{modelName}]的 [{taskName}] 任务创建成功,报告上传截止日期:{expiryDate},项目内容需要您提供部分文件,请及时上报相应的文件,谢谢");
            Send($@"{dataType} 系统提示", emails, "jintao.bai@luxshare-ict.com", "OK2X 任务发起通知", $@"{dataType} 任务提示:<br/>机种[{modelName}]的 [{taskName}] 任务创建成功,报告上传截止日期:{expiryDate},项目内容需要您提供部分文件,请及时上报相应的文件,谢谢");
        });

        task.Start();
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功\"}]";
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

    public string showModelName(string user)
    {
        string sSQL = $@"SELECT MODEL_NAME ,MODEL_ID
								FROM SAJET.SYS_MODEL SM 
								WHERE ENABLED = 'Y'
								ORDER BY MODEL_NAME ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string showTemplateName(string dataType,string user)
    {
        string sSQL = $@"SELECT DISTINCT TEMPLATE_NAME
								FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG SM 
								WHERE ENABLED = 'Y'
                                AND DATA_TYPE = '{dataType}' 
								ORDER BY TEMPLATE_NAME ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    private string search(string ary_lot)
    {

        string sql = "SELECT ARY_LOT,FLAG,QUANTITY,QUANTITY_CREATED,CREATE_USER,CREATE_DATE FROM SD_OP_ARYLOT WHERE ARY_LOT = '" + ary_lot + "' ORDER BY FLAG DESC";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }

    private string del(string id,string dataType, string user)
    {
        try
        {
            string sSQL = $@" SELECT *
                          FROM SAJET.SYS_OK2X_TASK_CONFIG SOBTC
                          WHERE ID = '{id}'
                          AND DATA_TYPE = '{dataType}'
                          AND ENABLED = 'Y'";

            DataTable dt = PubClass.getdatatableMES(sSQL);

            if (dt.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前机种 任务名称 不存在！\"}]";
            }

            string userEmpId = getEmpIdByNo(user);

            if (userEmpId.Length == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
            }

            sSQL = $@"UPDATE SAJET.SYS_OK2X_TASK_CONFIG SOBTC
                             SET ENABLED = 'N',UPDATE_EMP = '{userEmpId}',MODIFY_DATE = SYSDATE
                             WHERE ID = '{id}'
                             AND DATA_TYPE = '{dataType}'";

            PubClass.getdatatablenoreturnMES(sSQL);

            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"删除成功\"}]";
        }
        catch
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"删除失败！\"}]";
        }
    }
  
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    public static string ConnWebApi(string emps,string message )
    {

        string url = "https://m.luxshare-ict.com/api/WorkWeChat/SendTextMessage?SendApp=1";
        string type = "POST";
        Encoding utF8 = Encoding.UTF8;
        string result = "";
        string jsondata = "{ 'Account':12646797, 'Password':'dsr7FhaLnwjGv8mCN3kP'," +
                          "'EmpCodes':'"+emps+"', 'Content':'"+message+ "\r\n   (平台地址:http://10.32.15.59:9001/)'}";
        int state = 0;

        try
        {
            HttpWebRequest httpWebRequest = WebRequest.Create(url) as HttpWebRequest;
            httpWebRequest.Method = type;
            httpWebRequest.KeepAlive = true;
            httpWebRequest.ContentType = "application/json";
            httpWebRequest.CachePolicy = (RequestCachePolicy)new HttpRequestCachePolicy(HttpRequestCacheLevel.NoCacheNoStore);
            if (0 == string.Compare("POST", type))
            {
                byte[] bytes = utF8.GetBytes(jsondata);
                httpWebRequest.MediaType = "application/json";
                httpWebRequest.Accept = "application/json";
                httpWebRequest.ContentLength = (long)bytes.Length;
                Stream requestStream = httpWebRequest.GetRequestStream();
                requestStream.Write(bytes, 0, bytes.Length);
                requestStream.Close();
            }
            HttpWebResponse response = httpWebRequest.GetResponse() as HttpWebResponse;
            try
            {
                Debug.WriteLine((object)utF8);
                using (Stream responseStream = response.GetResponseStream())
                {
                    using (StreamReader streamReader = new StreamReader(responseStream, utF8))
                        result = streamReader.ReadToEnd();
                }
            }
            finally
            {
                response.Close();
            }
        }
        catch (Exception ex)
        {
            state = 1;
            result = ex.Message;
        }
        return result;
    }

    public void Send(string senderName, string EmailTo, string EmailCc, string subject, string body)
    {
        try
        {

            string[] MailToArray = EmailTo.Split(',');
            string[] MailCcArray = EmailCc.Split(',');


            MyProperty = new MailMessage();
            Smtp.Host = "10.41.3.22";
            Smtp.Port = 25;
            MyProperty.From = new MailAddress("KS-BU17.MES@luxshare-ict.com", senderName);// "KS-BU17.MES@luxshare-ict.com"
            Smtp.Credentials = new System.Net.NetworkCredential("KS-BU17.MES@luxshare-ict.com", "Luxsh@re,20723");//("KS-BU17.MES@luxshare-ict.com", "Luxsh@re,20723");
            MyProperty.Subject = subject;
            MyProperty.SubjectEncoding = Encoding.UTF8;
            MyProperty.IsBodyHtml = true;//是否为HTML
            MyProperty.Body = body + "(平台地址:http://10.32.15.59:9001/)"; //邮件内容
            for (int i = 0; i < MailToArray.Length; i++)
            {
                MyProperty.To.Add(MailToArray[i]);
            }
            for (int i = 0; i < MailCcArray.Length; i++)
            {
                MyProperty.CC.Add(MailCcArray[i]);
            }
            MyProperty.Priority = MailPriority.High; //设置邮箱优先等级
            Smtp.DeliveryMethod = SmtpDeliveryMethod.Network;//设置邮件发送方式
            SendEmail();
        }
        catch (Exception ex)
        {
        }

    }

    public void SendEmail()
    {
        try
        {
            this.smtp.Send(this.MyProperty);
            //this.smtp.SendAsync(this.mail.From, this.mail.To, this.mail.Subject, this.mail.Body);
        }
        catch (Exception e)
        {

        }
        finally
        {
            this.MyProperty.Dispose();
            //this.Smtp.Dispose(); 
        }
    }

}