<%@ WebHandler Language="C#" Class="Consumable_Query_HT" %>
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


public class Consumable_Query_HT : IHttpHandler
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
        string Label = context.Request["Label"];
        string Remark = context.Request["Remark"];
        string Sn = context.Request["Sn"];
        string Check_Type = context.Request["Check_Type"];
        string ModelName = context.Request["ModelName"];
        string Process_Name = context.Request["Process_Name"];
        string Consumable_Type = context.Request["Consumable_Type"];
        string LabelType = context.Request["LabelType"];
        string PdlineName = context.Request["PdlineName"];
        switch (funcName)
        {

            case "Add":
                rtnValue = Add(PdlineName, ModelName, LabelType, Consumable_Type, Process_Name, Check_Type, Sn, Remark, user);
                break;
            case "ShowLabel":
                rtnValue = ShowLabel(Label);
                break;
            case "show":
                rtnValue = show(PdlineName, ModelName, Process_Name, Consumable_Type);
                break;
            case "del":
                rtnValue = del(PdlineName, ModelName, Process_Name, Consumable_Type, user, Sn);
                break;


        }
        context.Response.Write(rtnValue);
    }
    public string del(string PdlineName, string ModelName, string Process_Name, string Consumable_Type, string user, string Sn)
    {
        string ISQL = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        if (Sn != "" && Sn != null && Sn != "null")
        {
            ISQL = $"UPDATE  SAJET.SYS_CONSUMABLE_BASE  SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS NOT NULL";
            PubClass.getdatatablenoreturnMES(ISQL);
            ISQL = $"INSERT INTO  SAJET.SYS_HT_CONSUMABLE_BASE SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS NOT NULL ";
            PubClass.getdatatablenoreturnMES(ISQL);
            ISQL = $"DELETE  FROM SAJET.SYS_CONSUMABLE_BASE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS NOT NULL ";
            PubClass.getdatatablenoreturnMES(ISQL);
        }
        else
        {
            ISQL = $"UPDATE  SAJET.SYS_CONSUMABLE_BASE  SET UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS  NULL";
            PubClass.getdatatablenoreturnMES(ISQL);
            ISQL = $"INSERT INTO  SAJET.SYS_HT_CONSUMABLE_BASE SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS  NULL ";
            PubClass.getdatatablenoreturnMES(ISQL);
            ISQL = $"DELETE  FROM SAJET.SYS_CONSUMABLE_BASE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS  NULL ";
            PubClass.getdatatablenoreturnMES(ISQL);
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,删除成功!\"}]";
    }



    public string Add(string PdlineName, string ModelName, string LabelType, string Consumable_Type, string Process_Name, string Check_Type, string Sn, string Remark, string user)
    {
        string ISQL = "";
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        if (Check_Type == "上线")
        {
            if (LabelType == "无条码")
            {
                string SQL = $"SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}' AND SN IS  NULL";
                DataTable dt = PubClass.getdatatableMES(SQL);
                if (dt.Rows.Count > 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,!无条码类型已有上线记录\"}]";
                }
                ISQL = $"INSERT INTO  SAJET.SYS_CONSUMABLE_BASE (PDLINE_NAME,MODEL_NAME,PROCESS_NAME,CONSUMABLE_TYPE,REMARK,CREATE_DATE,CREATE_USERID,UPDATE_DATE)VALUES" +
                    $"('{PdlineName}','{ModelName}','{Process_Name}','{Consumable_Type}','{Remark}',SYSDATE,'{userEmpId}',SYSDATE)";
                PubClass.getdatatablenoreturnMES(ISQL);
                ISQL = $"INSERT INTO  SAJET.SYS_HT_CONSUMABLE_BASE (PDLINE_NAME,MODEL_NAME,PROCESS_NAME,CONSUMABLE_TYPE,REMARK,CREATE_DATE,CREATE_USERID,UPDATE_DATE)VALUES" +
    $"('{PdlineName}','{ModelName}','{Process_Name}','{Consumable_Type}','{Remark}',SYSDATE,'{userEmpId}',SYSDATE)";
                PubClass.getdatatablenoreturnMES(ISQL);
            }
            if (LabelType == "有条码")
            {
                string SQL = $"SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS NOT NULL";
                DataTable dt = PubClass.getdatatableMES(SQL);
                if (dt.Rows.Count > 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,!有条码类型已有上线记录\"}]";
                }
                ISQL = $"INSERT INTO  SAJET.SYS_CONSUMABLE_BASE (PDLINE_NAME,MODEL_NAME,PROCESS_NAME,CONSUMABLE_TYPE,REMARK,CREATE_DATE,CREATE_USERID,UPDATE_DATE,SN)VALUES" +
                $"('{PdlineName}','{ModelName}','{Process_Name}','{Consumable_Type}','{Remark}',SYSDATE,'{userEmpId}',SYSDATE,'{Sn}')";
                PubClass.getdatatablenoreturnMES(ISQL);
                ISQL = $"INSERT INTO  SAJET.SYS_HT_CONSUMABLE_BASE (PDLINE_NAME,MODEL_NAME,PROCESS_NAME,CONSUMABLE_TYPE,REMARK,CREATE_DATE,CREATE_USERID,UPDATE_DATE,SN)VALUES" +
             $"('{PdlineName}','{ModelName}','{Process_Name}','{Consumable_Type}','{Remark}',SYSDATE,'{userEmpId}',SYSDATE,'{Sn}')";
                PubClass.getdatatablenoreturnMES(ISQL);
            }
        }
        if (Check_Type == "更换")
        {
            if (LabelType == "无条码")
            {
                string SQL = $"SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS  NULL";
                DataTable dt = PubClass.getdatatableMES(SQL);
                if (dt.Rows.Count == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,!无条码类型未有上线记录\"}]";
                }
                ISQL = $"UPDATE  SAJET.SYS_CONSUMABLE_BASE  SET REMARK='{Remark}',UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS  NULL";
                PubClass.getdatatablenoreturnMES(ISQL);
                ISQL = $"INSERT INTO  SAJET.SYS_HT_CONSUMABLE_BASE SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS  NULL ";
                PubClass.getdatatablenoreturnMES(ISQL);
            }
            if (LabelType == "有条码")
            {
                string SQL = $"SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS NOT NULL";
                DataTable dt = PubClass.getdatatableMES(SQL);
                if (dt.Rows.Count == 0)
                {
                    return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,!有条码类型未有上线记录\"}]";
                }
                ISQL = $"UPDATE  SAJET.SYS_CONSUMABLE_BASE  SET SN='{Sn}'REMARK='{Remark}',UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS NOT NULL";
                PubClass.getdatatablenoreturnMES(ISQL);
                ISQL = $"INSERT INTO  SAJET.SYS_HT_CONSUMABLE_BASE SELECT * FROM SAJET.SYS_CONSUMABLE_BASE WHERE  PDLINE_NAME='{PdlineName}' AND MODEL_NAME='{ModelName}' AND PROCESS_NAME='{Process_Name}' AND CONSUMABLE_TYPE='{Consumable_Type}'AND SN IS NOT NULL ";
                PubClass.getdatatablenoreturnMES(ISQL);
            }
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + Check_Type + "成功\"}]";

    }
    public string show(string PdlineName, string ModelName, string Process_Name, string Consumable_Type)
    {
        string sql = "";
        if (PdlineName != "" && PdlineName != null && PdlineName != "null")
        {
            sql = sql + " AND A.PDLINE_NAME ='" + PdlineName + "'";
        }
        if (ModelName != "" && ModelName != null && ModelName != "null")
        {
            sql = sql + " AND A.MODEL_NAME ='" + ModelName + "'";
        }
        if (Process_Name != "" && Process_Name != null && Process_Name != "null")
        {
            sql = sql + " AND A.PROCESS_NAME ='" + Process_Name + "'";
        }
        if (Consumable_Type != "" && Consumable_Type != null && Consumable_Type != "null")
        {
            sql = sql + " AND A.CONSUMABLE_TYPE ='" + Consumable_Type + "'";
        }
        string SQL = $"SELECT A.PDLINE_NAME,A.MODEL_NAME,A.PROCESS_NAME,A.CONSUMABLE_TYPE,A.SN,A.REMARK,A.CREATE_DATE,B.EMP_NAME,A.UPDATE_DATE,C.EMP_NAME AS EMP_NAME1 FROM  SAJET.SYS_HT_CONSUMABLE_BASE A,SAJET.SYS_EMP B,SAJET.SYS_EMP C WHERE A.CREATE_USERID=B.EMP_ID(+) AND A.UPDATE_USERID=C.EMP_ID(+)" + sql + " ORDER BY A.CREATE_DATE DESC";
        DataTable dt = PubClass.getdatatableMES(SQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowLabel(string Label)
    {
        if (!Label.Contains("|"))
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,线体机种制程请用|区分!\"}]";
        }
        string[] LabelName = Label.Split('|');
        if (LabelName.Length != 3)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,刷入条码根据|区分不为四条数据!\"}]";
        }
        string PDLINE_NAME = LabelName[0];
        string MODEL_NAME = LabelName[1];
        string PROCESS_NAME = LabelName[2];

        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME='{PDLINE_NAME}'  ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此线体不存在\"}]";
        }
        sSQL = $@"SELECT * FROM SAJET.SYS_MODEL WHERE MODEL_NAME='{MODEL_NAME}' AND  ENABLED='Y' ";
        dt = PubClass.getdatatableMES(sSQL);
        if (dt.Rows.Count == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此机种不存在\"}]";
        }


        //return JsonConvert.SerializeObject(dt);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"" + Label + "\"}]";
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