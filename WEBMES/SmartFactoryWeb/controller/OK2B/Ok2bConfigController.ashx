<%@ WebHandler Language= "C#" Class="Ok2bConfigController" %>

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

public class Ok2bConfigController : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString(); 
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string taskName = context.Request["taskName"];
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
        string fileName = context.Request["fileName"];
        string empNo = context.Request["empNo"];
        string quantity = context.Request["quantity"];
        string dataType = context.Request["dataType"];
        string auditorEmpNo = context.Request["auditorEmpNo"];
        string itemTemplate = context.Request["itemTemplate"];
        string isAutoAssy = context.Request["isAutoAssy"]=="true"?"Y":"N";
        switch (funcName)
        {
            case "addTemplateInfo":
                rtnValue = addTemplateInfo(templateName, fileName, empNo, user, dataType, auditorEmpNo, isAutoAssy);
                break;
            case "show":
                rtnValue = show(templateName, fileName, empNo, dataType, auditorEmpNo);
                break;
            case "del":
                rtnValue = del(id, user, dataType, auditorEmpNo);
                break;
            case "saveUploadFileItem":
                rtnValue = saveUploadFileItem(user, dataType, taskName, itemTemplate);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string saveUploadFileItem(string user,string dataType, string taskName,string itemTemplate)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
        }

        taskName = taskName + DateTime.Now.ToString("yyyyMMddHHmmss");

        if (taskName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"模板名称为空,请检查！\"}]";
        }

        string checkSQL = $@"SELECT *
                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG
                            WHERE TEMPLATE_NAME = '{taskName}'
                            AND ENABLED = 'Y'";

        DataTable checkDt = PubClass.getdatatableMES(checkSQL);

        if (checkDt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前模板名称 已新建！\"}]";
        }

        string[] itemArr = itemTemplate.Split(';');

        for (int i = 0; i<itemArr.Length; i++)
        {
            string item = itemArr[i];

            if (item.Trim().Length==0)
            {
                continue;
            }

            string fileName = item.Split('±')[0];
            string uploadEmp = item.Split('±')[1];
            string checkEmp = item.Split('±')[2];
            string isAutoAssy = item.Split('±')[3];

            string sSQL = $@"SELECT *
                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG
                            WHERE TEMPLATE_NAME = '{taskName.Trim()}'
                            AND FILE_NAME = '{fileName.Trim()}'
                            AND ENABLED = 'Y'";

            DataTable dt = PubClass.getdatatableMES(sSQL);

            if (dt.Rows.Count > 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件名称重复,请检查！\"}]";
            }

            string driEmpId = getEmpIdByNo(uploadEmp);

            if (driEmpId.Length == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"责任人员 : "+uploadEmp+" 信息不存在,请检查！\"}]";
            }

            string auditorEmpId = getEmpIdByNo(checkEmp);

            if (auditorEmpId.Length == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"审核人员 : " + checkEmp + " 信息不存在,请检查！\"}]";
            }

            string id = System.Guid.NewGuid().ToString("N");

            sSQL = $@"INSERT INTO SAJET.SYS_OK2X_TEMPLATE_CONFIG
                    (ID, TEMPLATE_NAME, FILE_NAME, DRI_EMP_ID, DATA_TYPE, ENABLED, UPDATE_EMP, CREATE_DATE, MODIFY_DATE, AUDITOR_EMP_ID,IS_AUTO_ASSY)
                    VALUES('{id.Trim()}', '{taskName.Trim()}', '{fileName.Trim()}', '{driEmpId.Trim()}', '{dataType.Trim()}', 'Y', '{userEmpId.Trim()}', SYSDATE, SYSDATE , '{auditorEmpId.Trim()}','{isAutoAssy.Trim()}')";

            PubClass.getdatatablenoreturnMES(sSQL);
        }

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+ taskName.Trim() + "\"}]";
    }

    public string show(string templateName, string fileName,string empNo,string dataType,string auditorEmpNo)
    {
        string sSQL = $@" SELECT SOTC.TEMPLATE_NAME ,SOTC.FILE_NAME ,SE.EMP_NAME ,TO_CHAR(SOTC.MODIFY_DATE,'yyyy-MM-dd hh24:mi:ss') MODIFYDATE ,SOTC.ID ,SOTC.DATA_TYPE,ASE.EMP_NAME AUDITOR_EMP_NAME,SOTC.IS_AUTO_ASSY
                             FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG SOTC
                             LEFT JOIN SAJET.SYS_EMP SE ON SOTC.DRI_EMP_ID = SE.EMP_ID 
                             LEFT JOIN SAJET.SYS_EMP ASE ON SOTC.AUDITOR_EMP_ID = ASE.EMP_ID
                             WHERE SOTC.ENABLED = 'Y'
                             AND SOTC.DATA_TYPE = '{dataType}'
                             AND SOTC.TEMPLATE_NAME LIKE '{templateName}%'
                             AND SOTC.FILE_NAME LIKE '{fileName}%'
                             ORDER BY TEMPLATE_NAME ,CREATE_DATE ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string addTemplateInfo(string templateName,string fileName, string empNo,string user,string dataType,string auditorEmpNo,string isAutoAssy)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
        }

        string driEmpId = getEmpIdByNo(empNo);

        if (driEmpId.Length == 0)
        {
            driEmpId = "0";
            //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"责任人员信息不存在,请检查！\"}]";
        }

        string auditorEmpId = getEmpIdByNo(auditorEmpNo);

        if (auditorEmpId.Length == 0)
        {
            auditorEmpId = "0";
            //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"责任人员信息不存在,请检查！\"}]";
        }

        if (templateName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"模板名称为空,请检查！\"}]";
        }

        if (fileName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"文件名称为空,请检查！\"}]";
        }

        string id = System.Guid.NewGuid().ToString("N");

        if (dataType=="OK2S")
        {
            string checkSQL = $@"SELECT *
                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG
                            WHERE TEMPLATE_NAME = '{templateName}'
                            AND ENABLED = 'Y'
                            AND DATA_TYPE = 'OK2B'";

            DataTable checkDt = PubClass.getdatatableMES(checkSQL);

            if (checkDt.Rows.Count > 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前模板名称 已在 OK2B 中新建！\"}]";
            }
        }

        if (dataType == "OK2B")
        {
            string checkSQL = $@"SELECT *
                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG
                            WHERE TEMPLATE_NAME = '{templateName}'
                            AND ENABLED = 'Y'
                            AND DATA_TYPE = 'OK2X'";

            DataTable checkDt = PubClass.getdatatableMES(checkSQL);

            if (checkDt.Rows.Count > 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前模板名称 已在 OK2S 中新建！\"}]";
            }
        }

        string sSQL = $@"SELECT *
                            FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG
                            WHERE TEMPLATE_NAME = '{templateName.Trim()}'
                            AND FILE_NAME = '{fileName.Trim()}'
                            AND ENABLED = 'Y'
                            AND DATA_TYPE = '{dataType.Trim()}'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count > 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前模板名称 和 文件名称已关联！\"}]";
        }

        sSQL = $@"INSERT INTO SAJET.SYS_OK2X_TEMPLATE_CONFIG
                    (ID, TEMPLATE_NAME, FILE_NAME, DRI_EMP_ID, DATA_TYPE, ENABLED, UPDATE_EMP, CREATE_DATE, MODIFY_DATE, AUDITOR_EMP_ID,IS_AUTO_ASSY)
                    VALUES('{id.Trim()}', '{templateName.Trim()}', '{fileName.Trim()}', '{driEmpId.Trim()}', '{dataType.Trim()}', 'Y', '{userEmpId.Trim()}', SYSDATE, SYSDATE , '{auditorEmpId.Trim()}','{isAutoAssy.Trim()}')";

        PubClass.getdatatablenoreturnMES(sSQL);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"添加成功\"}]";
    }

    

    public string showEmpName(string user)
    {
        string sSQL = $@"SELECT EMP_ID ,EMP_NAME 
                            FROM SAJET.SYS_EMP SE 
                            WHERE ENABLED = 'Y'
                            ORDER BY EMP_NAME  ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
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

    private string del(string id,string user,string dataType,string auditorEmpNo)
    {
        try
        {
            string sSQL = $@" SELECT *
                          FROM SAJET.SYS_OK2X_TEMPLATE_CONFIG SOBTC
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

            sSQL = $@"UPDATE SAJET.SYS_OK2X_TEMPLATE_CONFIG SOBTC
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

    public static string getEmpIdByNo(string user)
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