<%@ WebHandler Language= "C#" Class="Ok2bFileUploadController" %>

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

public class Ok2bFileUploadController : IHttpHandler
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
        string taskId = context.Request["taskId"];
        string modelName = context.Request["modelName"];
        string modelId = context.Request["modelId"];
        string ary_lot = context.Request["ary_lot"];
        string site = context.Request["site"];
        string step = context.Request["step"];
        string line = context.Request["line"];
        string eqp = context.Request["eqp"];
        string desc = context.Request["desc"];
        string pos = context.Request["pos"];
        string id = context.Request["id"];
        string templateName = context.Request["templateName"];
        string templateId = context.Request["templateId"];
        string quantity = context.Request["quantity"];
        string dataFiles = context.Request["dataFiles"];
        string taskStatus = context.Request["taskStatus"];
        string filePath = context.Request["filePath"];
        string dataType = context.Request["dataType"];

        switch (funcName)
        {
            case "showTaskName":
                rtnValue = showTaskName(taskStatus, user, dataType);
                break;
            case "show":
                rtnValue = show(taskStatus, taskId, user, dataType);
                break;
            case "uploadFiles":
                rtnValue = uploadFiles(taskId, templateId, dataFiles, user, context, dataType);
                break;
            case "downFile":
                rtnValue = downFile(taskId,templateId, user, context, dataType);
                break;
            case "operateAudi":
                rtnValue = operateAudi(id,taskStatus,user,taskId);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string operateAudi(string id,string taskStatus,string user,string taskId)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请刷新页面后查看!\"}]";
        }

        string sSQL = $@"SELECT FILE_PATH ,ID
                         FROM SAJET.G_OK2X_UPLOAD_FILE_LOG
                         WHERE ID = '{id}'
                         AND ENABLED = 'Y'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"操作的文件不存在,请刷新页面后查看!\"}]";
        }

        sSQL = $@"SELECT SOXTC.AUDITOR_EMP_ID 
                         FROM SAJET.G_OK2X_UPLOAD_FILE_LOG GOXUFL
                         INNER JOIN SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC ON GOXUFL.TEMPLATE_ID = SOXTC.ID 
                         WHERE GOXUFL.ID = '{id}'
                         AND GOXUFL.ENABLED = 'Y'";

        dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前文件任务在模板中不存在,请刷新页面后查看!\"}]";
        }

        string tenaId = dt.Rows[0]["AUDITOR_EMP_ID"].ToString();

        if (userEmpId!=tenaId)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前账户不是当前审核任务的审核人,无法进行审核!\"}]";
        }

        if (taskStatus=="0")
        {
            sSQL = $@"UPDATE SAJET.G_OK2X_UPLOAD_FILE_LOG
                        SET AUDITOR_EMP_ID  = '{userEmpId}', UPDATE_EMP = '{userEmpId}',MODIFY_DATE = SYSDATE,STATUS =9
                        WHERE ID = '{id}'
                        AND STATUS = 1";
        }
        else
        {
            sSQL = $@"SELECT SOTC.TASK_NAME ,SOTC.MODEL_NAME ,SE.EMP_NO ,SE.EMAIL ,SOXTC.FILE_NAME ,SOTC.DATA_TYPE 
                        FROM SAJET.G_OK2X_UPLOAD_FILE_LOG GOXUFL 
                        INNER JOIN SAJET.SYS_OK2X_TASK_CONFIG SOTC ON GOXUFL.TASK_ID = SOTC.ID 
                        INNER JOIN SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC ON GOXUFL.TEMPLATE_ID = SOXTC.ID 
	                        AND SOTC.TEMPLATE_NAME = SOXTC.TEMPLATE_NAME AND SOXTC.ENABLED = 'Y'
                        INNER JOIN SAJET.SYS_EMP SE ON SOXTC.DRI_EMP_ID = SE.EMP_ID 
                        WHERE GOXUFL.ID = '{id}'
                        AND GOXUFL.ENABLED = 'Y'";

            dt = PubClass.getdatatableMES(sSQL);

            string taskName = dt.Rows[0]["TASK_NAME"].ToString();
            string modelName = dt.Rows[0]["MODEL_NAME"].ToString();
            string fileName = dt.Rows[0]["FILE_NAME"].ToString();
            string empNo = dt.Rows[0]["EMP_NO"].ToString();
            string email = dt.Rows[0]["EMAIL"].ToString();
            string dataType = dt.Rows[0]["DATA_TYPE"].ToString();

            Task task = new Task(() => {
                ConnWebApi(empNo, $@"{dataType} 任务提示:\r\n机种[{modelName}]的 [{taskName}] 任务中[{fileName}]被批退,请及时检查文件内容并重新上传,谢谢");
                Send($@"{dataType} 系统提示", email, "jintao.bai@luxshare-ict.com", "OK2X 任务批退通知", $@"{dataType} 任务提示:\r\n机种[{modelName}]的 [{taskName}] 任务中[{fileName}]被批退,请及时检查文件内容并重新上传,谢谢");
            });

            task.Start();

            sSQL = $@"UPDATE SAJET.G_OK2X_UPLOAD_FILE_LOG
                        SET AUDITOR_EMP_ID  = '{userEmpId}', UPDATE_EMP = '{userEmpId}',MODIFY_DATE = SYSDATE,STATUS =2
                        WHERE ID = '{id}'
                        AND STATUS = 1";
        }

        PubClass.getdatatablenoreturnMES(sSQL);

        sSQL = $@"SELECT SOXTC.FILE_NAME  
                        FROM SAJET.SYS_OK2X_TASK_CONFIG SOTC 
                        INNER JOIN SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC ON SOTC.TEMPLATE_NAME = SOXTC.TEMPLATE_NAME 
	                        AND SOXTC.ENABLED = 'Y'
                        AND SOTC.ID = '{taskId}'";

        DataTable taskDt = PubClass.getdatatableMES(sSQL);

        sSQL = $@"SELECT DISTINCT TEMPLATE_ID 
                        FROM SAJET.G_OK2X_UPLOAD_FILE_LOG GOXUFL 
                        WHERE ENABLED = 'Y'
                        AND TASK_ID = '{taskId}'
                        AND STATUS = 9";

        DataTable uploadDt = PubClass.getdatatableMES(sSQL);

        //所有的数据上传完成后将当前的任务更改为待汇总状态
        if (uploadDt.Rows.Count >= taskDt.Rows.Count)
        {
            sSQL = $@"UPDATE SAJET.SYS_OK2X_TASK_CONFIG SOXTC 
                            SET STATUS = 8
                            WHERE ID = '{taskId}'
                            AND ENABLED = 'Y'";

            PubClass.getdatatablenoreturnMES(sSQL);

            sSQL = $@"SELECT SOTC.TASK_NAME ,SOTC.MODEL_NAME ,SE.EMP_NO ,SE.EMAIL ,SOTC.DATA_TYPE 
                    FROM SAJET.G_OK2X_UPLOAD_FILE_LOG GOXUFL 
                    INNER JOIN SAJET.SYS_OK2X_TASK_CONFIG SOTC ON GOXUFL.TASK_ID = SOTC.ID 
                    INNER JOIN SAJET.SYS_EMP SE ON SOTC.EMP_ID  = SE.EMP_ID 
                    WHERE GOXUFL.ID = '{id}'
                    AND GOXUFL.ENABLED = 'Y'";

            dt = PubClass.getdatatableMES(sSQL);

            string taskName1 = dt.Rows[0]["TASK_NAME"].ToString();
            string modelName1 = dt.Rows[0]["MODEL_NAME"].ToString();
            string empNo1 = dt.Rows[0]["EMP_NO"].ToString();
            string email1 = dt.Rows[0]["EMAIL"].ToString();
            string dataType1 = dt.Rows[0]["DATA_TYPE"].ToString();

            Task task1 = new Task(() => {
                ConnWebApi(empNo1, $@"{dataType1} 任务提示:\r\n机种[{modelName1}]的 [{taskName1}] 任务[已完结],请及时前往OK2X系统进行文件检查和汇总,谢谢");
                Send($@"{dataType1} 系统提示", email1, "jintao.bai@luxshare-ict.com", "OK2X 任务完结通知", $@"{dataType1} 任务提示:<br/>机种[{modelName1}]的 [{taskName1}] 任务[已完结],请及时前往OK2X系统进行文件检查和汇总,谢谢");
            });

            task1.Start();
        }
        else
        {
            sSQL = $@"UPDATE SAJET.SYS_OK2X_TASK_CONFIG SOXTC 
                            SET STATUS = 0
                            WHERE ID = '{taskId}'
                            AND ENABLED = 'Y'";

            PubClass.getdatatablenoreturnMES(sSQL);
        }

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK\"}]"; ;
    }

    public string downFile(string taskId,string templateId,string user, HttpContext context,string dataType)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "用户信息不存在,请检查!";
        }

        string sSQL = $@"SELECT FILE_PATH ,ID
                         FROM SAJET.G_OK2X_UPLOAD_FILE_LOG
                         WHERE TASK_ID = '{taskId}'
                         AND TEMPLATE_ID = '{templateId}'
                         AND DATA_TYPE = '{dataType}'
                         AND ENABLED = 'Y'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"下载的文件不存在,请刷新页面后查看!\"}]";
        }

        string filePath =  dt.Rows[0]["FILE_PATH"].ToString();
        string id = dt.Rows[0]["ID"].ToString();

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

            //try
            //{
            //    //此处写你的逻辑得到文件地址，或者进行记录

            //    //以字符流的形式下载文件
            //    FileStream fs = new FileStream(filePath, FileMode.Open);
            //    byte[] bytes = new byte[(int)fs.Length];
            //    fs.Read(bytes, 0, bytes.Length);
            //    fs.Close();
            //    context.Response.ContentType = "application/octet-stream";
            //    //通知浏览器下载文件而不是打开
            //    context.Response.AddHeader("Content-Disposition", "attachment;   filename=" + HttpUtility.UrlEncode(file.Name, System.Text.Encoding.UTF8));
            //    context.Response.BinaryWrite(bytes);
            //}
            //catch (Exception ex)
            //{

            //}
            //finally
            //{
            //    context.Response.Flush();
            //    context.Response.End();
            //}

            return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+filePath+"\"}]";
        }

        return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件路径异常,请刷新页面后查看!\"}]";
    }


    public string uploadFiles(string taskId,string templateId,string dataFiles, string user, HttpContext context,string dataType)
    {
        if (context.Request.Files.Count > 0)
        {
            //string sharePath = context.Server.MapPath("..\\..\\OK2X_Files\\");
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
                return "文件服务器保存异常,请联系MES团队!";
            }

            string userEmpId = getEmpIdByNo(user);

            if (userEmpId.Length == 0)
            {
                return "用户信息不存在,请检查!";
            }

            string sSQL = $@"SELECT DRI_EMP_ID ,ENABLED 
                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC 
                            WHERE ID = '{templateId}'
                            AND DATA_TYPE = '{dataType}'";

            DataTable dt = PubClass.getdatatableMES(sSQL);

            if (dt.Rows.Count == 0)
            {
                return "当前模板中文件不存在,无需上传,请刷新页面!";
            }

            string enable = dt.Rows[0]["ENABLED"].ToString();
            string driEmpId = dt.Rows[0]["DRI_EMP_ID"].ToString();

            if (enable.ToUpper()=="N")
            {
                return "当前模板文件已删除,无需上传,请刷新页面!";
            }

            if (driEmpId != userEmpId)
            {
                return "当前模板上传责任人不是当前登录账号!";
            }

            string filePath = sharePath + taskId + "\\" + templateId + "\\";

            try
            {
                if (!System.IO.Directory.Exists(filePath))
                {
                    System.IO.Directory.CreateDirectory(filePath);
                }
            }
            catch (System.Exception ex)
            {
                return "文件服务器保存异常,请联系MES团队!";
            }

            HttpFileCollection files = context.Request.Files;
            //批量上传时使用
            for (int i = 0; i < files.Count; i++)
            {
                string id = System.Guid.NewGuid().ToString("N");
                string fname = filePath + id + "\\";

                try
                {
                    if (!System.IO.Directory.Exists(fname))
                    {
                        System.IO.Directory.CreateDirectory(fname);
                    }
                }
                catch (System.Exception ex)
                {
                    return "文件服务器保存异常,请联系MES团队!";
                }


                HttpPostedFile file = files[i];

                if (!(file.FileName.ToUpper().EndsWith("XLSX")))
                {
                    return "不允许上传非.XLSX文件!";
                }

                fname = fname + file.FileName;
                file.SaveAs(fname);

                sSQL = $@" SELECT *
                             FROM SAJET.G_OK2X_UPLOAD_FILE_LOG
                             WHERE TASK_ID = '{taskId}'
                             AND TEMPLATE_ID = '{templateId}'
                             AND ENABLED = 'Y'
                             AND DATA_TYPE = '{dataType}'";

                dt = PubClass.getdatatableMES(sSQL);

                if (dt.Rows.Count > 0)
                {
                    sSQL = $@"UPDATE SAJET.G_OK2X_UPLOAD_FILE_LOG
                             SET ENABLED = 'N'
                             WHERE TASK_ID = '{taskId}'
                             AND TEMPLATE_ID = '{templateId}'
                             AND DATA_TYPE = '{dataType}'
                             AND ENABLED = 'Y'";

                    PubClass.getdatatablenoreturnMES(sSQL);
                }

                sSQL = $@"INSERT INTO SAJET.G_OK2X_UPLOAD_FILE_LOG
                            (ID, TASK_ID, TEMPLATE_ID, FILE_PATH, DRI_EMP_ID, DATA_TYPE, ENABLED, UPDATE_EMP, CREATE_DATE, MODIFY_DATE,FILE_NAME,STATUS)
                            VALUES('{id}', '{taskId}', '{templateId}', '{fname}', '{userEmpId}', '{dataType}', 'Y', '{userEmpId}', SYSDATE, SYSDATE,'{file.FileName}',1)";

                PubClass.getdatatablenoreturnMES(sSQL);

                sSQL = $@"SELECT SOTC.TASK_NAME ,SOTC.MODEL_NAME ,SOXTC.FILE_NAME , SE.EMP_NO  ,SE.EMAIL
                        FROM SAJET.SYS_OK2X_TASK_CONFIG SOTC 
                        INNER JOIN SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC ON SOTC.TEMPLATE_NAME = SOXTC.TEMPLATE_NAME 
	                        AND SOXTC.ENABLED = 'Y'
                        INNER JOIN SAJET.SYS_EMP SE ON SOXTC.AUDITOR_EMP_ID = SE.EMP_ID 
                        WHERE SOTC.ID = '{taskId}'
                        AND SOXTC.ID = '{templateId}'
                        AND SOTC.ENABLED = 'Y'";

                dt = PubClass.getdatatableMES(sSQL);

                string taskName = dt.Rows[0]["TASK_NAME"].ToString();
                string modelName = dt.Rows[0]["MODEL_NAME"].ToString();
                string fileName = dt.Rows[0]["FILE_NAME"].ToString();
                string empNo = dt.Rows[0]["EMP_NO"].ToString();
                string email = dt.Rows[0]["EMAIL"].ToString();

                Task task = new Task(() => {
                    ConnWebApi(empNo, $@"{dataType} 任务提示:\r\n机种[{modelName}]的 [{taskName}] 任务中[{fileName}]已上传,请及时进行审核,谢谢");
                    Send($@"{dataType} 系统提示", email, "jintao.bai@luxshare-ict.com", "OK2X 任务审核通知", $@"{dataType} 任务提示:<br/>机种[{modelName}]的 [{taskName}] 任务中[{fileName}]已上传,请及时进行审核,谢谢");
                });

                task.Start();
            }
           
        }
        return "OK";
    }

    public string show(string taskStatus, string taskId, string user,string dataType)
    {
        string empId = getEmpIdByNo(user);

        if (empId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户 信息不存在,请检查！\"}]";
        }

        string sSQL = $@"SELECT GOUFL.ID ,SOTC.ID AS TASK_ID ,SOTC.TASK_NAME ,SOXTC.TEMPLATE_NAME ,SOXTC.ID AS TEMPLATE_ID ,SOXTC.FILE_NAME ,SE.EMP_NAME,SE.EMP_NO,CASE WHEN GOUFL.STATUS IS NULL OR GOUFL.STATUS = 0 THEN '未上传' WHEN GOUFL.STATUS = 1 THEN '待审核' WHEN GOUFL.STATUS = 2 THEN '审核批退' WHEN GOUFL.STATUS = 9 THEN '审核通过' END AS STATUS ,NVL(GOUFL.FILE_PATH,'/')  FILE_PATH ,NVL(TO_CHAR(GOUFL.MODIFY_DATE,'yyyy-MM-dd hh24:mi:ss'),'/') UPLOADTIME ,GOUFL.FILE_NAME UPLOAD_FILE_NAME,SOTC.MODEL_NAME,SEA.EMP_NAME AS ENA
                         FROM SAJET.SYS_OK2X_TASK_CONFIG SOTC 
                         INNER JOIN SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC ON SOTC.TEMPLATE_NAME = SOXTC.TEMPLATE_NAME
 	                        AND SOXTC.ENABLED = 'Y'
                         INNER JOIN SAJET.SYS_EMP SE ON SOXTC.DRI_EMP_ID = SE.EMP_ID 
                         INNER JOIN SAJET.SYS_EMP SEA ON SOXTC.AUDITOR_EMP_ID = SEA.EMP_ID
                         LEFT JOIN SAJET.G_OK2X_UPLOAD_FILE_LOG GOUFL ON SOTC.ID = GOUFL.TASK_ID 
 	                        AND SOXTC.ID = GOUFL.TEMPLATE_ID 
 	                        AND GOUFL.ENABLED = 'Y'
                         WHERE SOTC.ENABLED = 'Y'
                         AND SOTC.STATUS = '{taskStatus}'
                         AND SOTC.ID = '{taskId}'
                         AND SOTC.DATA_TYPE = '{dataType}'
                         ORDER BY SOXTC.CREATE_DATE ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string addTaskInfo(string taskName,string modelId, string user,string templateName,string dataType)
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

        if (modelId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"机种信息未选择,请检查！\"}]";
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
                        (ID, TASK_NAME, STATUS, EMP_ID, CREATE_DATE, MODIFY_DATE,MODEL_ID,DATA_TYPE,UPDATE_EMP,ENABLED,TEMPLATE_NAME)
                        VALUES(
                        '{id}', '{taskName}', 0, {empId}, SYSDATE, SYSDATE,{modelId},'{dataType}',{modelId},'Y','{templateName}')";

        PubClass.getdatatablenoreturnMES(sSQL);

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

    public string showTaskName(string taskStatus, string user,string dataType)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
        }

        string sSQL = $@" SELECT DISTINCT TASK_NAME ,ID 
                             FROM SAJET.SYS_OK2X_TASK_CONFIG SOBTC
                             WHERE DATA_TYPE = '{dataType}'
                             AND ENABLED = 'Y'
                             AND STATUS = '{taskStatus}'
                             AND (TEMPLATE_NAME IN (
	                            SELECT DISTINCT TEMPLATE_NAME 
	                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG SOXTC 
	                            WHERE (DRI_EMP_ID = '{userEmpId}' OR AUDITOR_EMP_ID = '{userEmpId}')
	                            AND DATA_TYPE = '{dataType}'
                            ) OR EMP_ID = '{userEmpId}')
                             ORDER BY TASK_NAME  ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string showTemplateName(string user,string dataType)
    {
        string sSQL = $@"SELECT DISTINCT TEMPLATE_NAME
								FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG SM 
								WHERE ENABLED = 'Y'
                                AND DATA_TYPE = '{dataType}'
								ORDER BY TEMPLATE_NAME ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    private string del(string id,string user,string dataType)
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


    public static string ConnWebApi(string emps, string message)
    {

        string url = "https://m.luxshare-ict.com/api/WorkWeChat/SendTextMessage?SendApp=1";
        string type = "POST";
        Encoding utF8 = Encoding.UTF8;
        string result = "";
        string jsondata = "{ 'Account':12646797, 'Password':'dsr7FhaLnwjGv8mCN3kP'," +
                          "'EmpCodes':'" + emps + "', 'Content':'" + message + "\r\n(平台地址:http://10.32.15.59:9001/)'}";
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