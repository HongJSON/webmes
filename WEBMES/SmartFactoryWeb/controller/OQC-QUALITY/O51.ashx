<%@ WebHandler Language="C#" Class="O51" %>
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

public class O51 : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString();
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string Template = context.Request["Template"];
        string NUMBER_ID = context.Request["NUMBER_ID"];
        string ModelName = context.Request["ModelName"];
        string PdlineName = context.Request["PdlineName"];
        string ProcessName = context.Request["ProcessName"];
        string datetimepicker = context.Request["datetimepicker"];
        string dataType = context.Request["dataType"];
        string DN_NO = context.Request["DN_NO"];
               string Result = context.Request["Result"];
               string Fa = context.Request["Fa"];
               string Ca = context.Request["Ca"];
               string ID = context.Request["ID"];
                    string Type1 = context.Request["Type1"];
        string Type2 = context.Request["Type2"];
        string Type3 = context.Request["Type3"];
        string Type4 = context.Request["Type4"];
        string Type5 = context.Request["Type5"];
        string Type6 = context.Request["Type6"];
        string Type7 = context.Request["Type7"];
        string Type8 = context.Request["Type8"];
        string Type9 = context.Request["Type9"];
        string Type10 = context.Request["Type10"];
        string Type11= context.Request["Type11"];
        string Type12 = context.Request["Type12"];
        string Type13 = context.Request["Type13"];
        string Type14 = context.Request["Type14"];
        string Type15 = context.Request["Type15"];
        string Type16 = context.Request["Type16"];
        string Type17 = context.Request["Type17"];
        string Type18 = context.Request["Type18"];
        string Type19 = context.Request["Type19"];
        string Type20 = context.Request["Type20"];
        switch (funcName)
        {
            case "ShowModel":
                rtnValue = ShowModel();
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "GetProcess":
                rtnValue = GetProcess(PdlineName);
                break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
                break;
            case "GetDnno":
                rtnValue = GetDnno(Template,ModelName,PdlineName,ProcessName,datetimepicker,dataType);
                break;
             case "GetLabel":
                rtnValue = GetLabel(Template);
                break;
            case "show":
                rtnValue = show(Template,DN_NO,datetimepicker,dataType);
                break;
            case "GetQTY":
                rtnValue = GetQTY(Template);
                break;
            case "UpdateTemplateInfo":
                rtnValue = UpdateTemplateInfo(Result,Fa,Ca,ID,user);
                break;
               case "UpdateTemplateInfo1":
                rtnValue = UpdateTemplateInfo1(user,ID,Type1,Type2,Type3,Type4,Type5,Type6,Type7,Type8,Type9,Type10,Type11,Type12,Type13,Type14,Type15,Type16,Type17,Type18,Type19,Type20);
                break;


        }
        context.Response.Write(rtnValue);
    }
    public string UpdateTemplateInfo(string Result,string Fa,string Ca,string ID,string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL = $@"UPDATE SAJET.G_ECHECK_BASE SET RESULT='{Result}',FA='{Fa}',CA='{Ca}', DRI_DATE=SYSDATE,DRI_EMPID='{userEmpId}' WHERE ID='{ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"NG,审核OK!\"}]";
    }
    public string UpdateTemplateInfo1(string user,string ID,string Type1,string Type2,string Type3,string Type4,string Type5,string Type6,string Type7,string Type8,string Type9,string Type10,string Type11,string Type12,string Type13,string Type14,string Type15,string Type16,string Type17,string Type18,string Type19,string Type20)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }
        string sSQL = $@"UPDATE SAJET.G_ECHECK_BASE SET TYPE1='{Type1}',TYPE2='{Type2}',TYPE3='{Type3}',TYPE4='{Type4}',TYPE5='{Type5}',TYPE6='{Type6}',TYPE7='{Type7}',TYPE8='{Type8}',TYPE9='{Type9}',TYPE10='{Type10}',
        TYPE11='{Type11}',TYPE12='{Type12}',TYPE13='{Type13}',TYPE14='{Type14}',TYPE15='{Type15}',TYPE16='{Type16}',TYPE17='{Type17}',TYPE18='{Type18}',TYPE19='{Type19}',TYPE20='{Type20}',CREATE_DATE=SYSDATE,CREATE_EMPID='{userEmpId}' WHERE ID='{ID}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"NG,维护OK!\"}]";
    }




    public string GetQTY(string Template)
    {
        string sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{Template}' ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,此模板未维护标题!\"}]";
        }
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+dt.Rows.Count+"\"}]";
    }
    public string ShowModel()
    {
        string sSQL = $@"SELECT MODEL_NAME FROM SAJET.SYS_MODEL WHERE ENABLED='Y'ORDER BY MODEL_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetLabel(string Template)
    {
        string sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE ='{Template}' ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string GetDnno(string Template,string ModelName,string PdlineName,string ProcessName,string datetimepicker,string dataType)
    {
        string sSQL = $@"SELECT DN_NO FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE MODEL_NAME='{ModelName}'AND PDLINE_NAME='{PdlineName}' AND PROCESS_NAME='{ProcessName}' AND TEMPLATE='{Template}' AND YEAR_DATE='{datetimepicker}' AND CLASS='{dataType}'";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        if(dt.Rows.Count==0)
        {
            return "NG";
        }
        return JsonConvert.SerializeObject(dt);
    }

    public string GetProcess(string PdlineName)
    {
        string sSQL = $@"Select DISTINCT B.PROCESS_NAME "
               + " From SAJET.SYS_TERMINAL A "
               + "     ,SAJET.SYS_PROCESS B "
               + "     ,SAJET.SYS_STAGE C "
               + "     ,SAJET.SYS_PDLINE D "
               + "     ,SAJET.SYS_OPERATE_TYPE E "
               + " Where D.PDLINE_NAME = '" + PdlineName + "' "
               + " AND A.PROCESS_ID = B.PROCESS_ID "
               + " AND B.OPERATE_ID = E.OPERATE_ID "
               + " AND A.STAGE_ID = C.STAGE_ID "
               + " AND A.PDLINE_ID = D.PDLINE_ID  ORDER BY B.PROCESS_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }


    public string ShowPdline()
    {
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string ShowTemplate()
    {
        string sSQL = $@"SELECT TEMPLATE FROM  SAJET.SYS_ECHECK_TEMPLATE_CONFIG ORDER BY  TEMPLATE";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }
    public string show(string Template,string DN_NO,string datetimepicker,string dataType)
    {
        string sSQL = $@"SELECT B.DRI_DATE,E.EMP_NAME AS EMP_NAME1,B.RESULT,B.FA,B.CA,A.TEMPLATE,B.ID,B.DN_NO,C.YEAR_DATE,C.CLASS,B.TYPE1,B.TYPE2,B.TYPE3,B.TYPE4,B.TYPE5,B.TYPE6,B.TYPE7,B.TYPE8,B.TYPE9,B.TYPE10,B.TYPE11,B.TYPE12,B.TYPE13,B.TYPE14,B.TYPE15,B.TYPE16,B.TYPE17,B.TYPE18,B.TYPE19,B.TYPE20,B.CREATE_DATE,D.EMP_NAME FROM SAJET.SYS_ECHECK_TEMPLATE_CONFIG A ,SAJET.G_ECHECK_BASE B,SAJET.SYS_ECHECK_TEMPLATE_MODEL C,SAJET.SYS_EMP D,SAJET.SYS_EMP E
WHERE A.NUMBER_ID=B.NUMBER_ID
AND A.NUMBER_ID=C.NUMBER_ID
AND B.DN_NO=C.DN_NO
AND A.TEMPLATE='{Template}'
AND B.DN_NO='{DN_NO}'
AND C.YEAR_DATE='{datetimepicker}'
AND C.CLASS='{dataType}' AND B.CREATE_EMPID=D.EMP_ID(+) AND B.DRI_EMPID=E.EMP_ID(+)";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
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