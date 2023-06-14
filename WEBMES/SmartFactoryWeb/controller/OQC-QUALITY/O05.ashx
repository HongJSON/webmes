<%@ WebHandler Language="C#" Class="O05" %>
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

public class O05 : IHttpHandler
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
        string PdlineName = context.Request["PdlineName"];
        //string ProcessName = context.Request["ProcessName"];
        string datetimepicker = context.Request["datetimepicker"];
        string dataType = context.Request["dataType"];
        string DN_NO = context.Request["DN_NO"];
        string ID = context.Request["ID"];
        string Result = context.Request["Result"];
        string Fa = context.Request["Fa"];
        string Ca = context.Request["Ca"];
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
             string JJ = context.Request["JJ"];
        switch (funcName)
        {
       
              case "ShowPdlineJJ":
                rtnValue = ShowPdlineJJ(JJ);
                break;
            case "ShowPdline":
                rtnValue = ShowPdline();
                break;
            case "ShowDnno":
                rtnValue = ShowDnno(Template,user,PdlineName,datetimepicker,dataType);
                break;
            case "GetProcess":
                rtnValue = GetProcess(PdlineName);
                break;
            case "ShowTemplate":
                rtnValue = ShowTemplate();
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
            case "GetLabel":
                rtnValue = GetLabel(DN_NO);
                break;
            case "GetDate":
                rtnValue = GetDate();
                break;
            case "addrow":
                rtnValue = addrow(DN_NO,user);
                break;
            case "Daddrow":
                rtnValue = Daddrow(DN_NO,user);
                break;

        }
        context.Response.Write(rtnValue);
    }
            public string ShowPdlineJJ(string JJ)
    {
        string sSQL = @"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT PDLINE_NAME FROM  SAJET.SYS_ECHECK_POWER_BASE) AND PDLINE_NAME LIKE'"+JJ+"%'ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string addrow(string DN_NO ,string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }

        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE='审核人权限'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if(dt1.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有审核权限\"}]";
        }

        sSQL1 = $"SELECT * FROM  SAJET.G_ECHECK_BASE WHERE DN_NO='{DN_NO}' AND FATYPE='Y'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if(dt1.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该单号有FACA未填写，不可审核\"}]";
        }




        string sSQL = $@"UPDATE SAJET.SYS_ECHECK_TEMPLATE_MODEL  SET DN_STATUS='审核完成',UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO  SAJET.SYS_HT_ECHECK_TEMPLATE_MODEL SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,任务审核成功!\"}]";
    }
    public string Daddrow(string DN_NO ,string user)
    {
        string userEmpId = getEmpIdByNo(user);
        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"NG,用户信息不存在,请检查!\"}]";
        }

        string sSQL1 = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        DataTable dt1 = PubClass.getdatatableMES(sSQL1);
        sSQL1 = $"SELECT * FROM  SAJET.SYS_ECHECK_POWER_BASE WHERE TEMPLATE='{dt1.Rows[0]["TEMPLATE"].ToString()}' AND PDLINE_NAME='{dt1.Rows[0]["PDLINE_NAME"].ToString()}'AND CHECK_EMPID='{userEmpId}' AND CHECK_TYPE='审核人权限'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if(dt1.Rows.Count==0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该人员没有审核权限\"}]";
        }

        sSQL1 = $"SELECT * FROM  SAJET.G_ECHECK_BASE WHERE DN_NO='{DN_NO}' AND FATYPE='Y'";
        dt1 = PubClass.getdatatableMES(sSQL1);
        if(dt1.Rows.Count>0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"该单号有FACA未填写，不可审核\"}]";
        }

        string sSQL = $@"UPDATE SAJET.SYS_ECHECK_TEMPLATE_MODEL  SET DN_STATUS='任务退回',UPDATE_USERID='{userEmpId}',UPDATE_DATE=SYSDATE WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        sSQL = $@"INSERT INTO  SAJET.SYS_HT_ECHECK_TEMPLATE_MODEL SELECT * FROM  SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}'";
        PubClass.getdatatablenoreturnMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,任务退回成功!\"}]";
    }

    public string GetDate()
    {
        string sSQL = $@"SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\""+dt.Rows[0][0].ToString()+"\"}]";
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
        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"OK,审核OK!\"}]";
    }

    public string GetLabel(string DN_NO)
    {
        string sSQL = $@"SELECT TITLE FROM SAJET.SYS_ECHECK_TEMPLATE_TITLE WHERE TEMPLATE  IN(SELECT TEMPLATE FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL WHERE DN_NO='{DN_NO}') ORDER BY SEQ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
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
        string sSQL = $@"SELECT PDLINE_NAME FROM SAJET.SYS_PDLINE WHERE ENABLED='Y' AND PDLINE_NAME IN(SELECT PDLINE_NAME FROM  SAJET.SYS_ECHECK_POWER_BASE)  ORDER BY PDLINE_NAME ";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string ShowDnno(string Template,string user,string PdlineName,string datetimepicker,string dataType)
    {
        string sql = "";

        if(Template!=""&& Template!=null&& Template!="null")
        {
            sql = sql + " AND TEMPLATE ='" + Template + "'";
        }
        if(datetimepicker!=""&& datetimepicker!=null&& datetimepicker!="null")
        {
            sql = sql + " AND YEAR_DATE ='" + datetimepicker + "'";
        }
        if(dataType!=""&& dataType!=null&& dataType!="null"&& dataType!="--请选择--")
        {
            sql = sql + " AND CLASS ='" + dataType + "'";
        }
        if(PdlineName!=""&& PdlineName!=null&& PdlineName!="null")
        {
            sql = sql + " AND PDLINE_NAME ='" + PdlineName + "'";
        }
        //if(ProcessName!=""&& ProcessName!=null&& ProcessName!="null")
        //{
        //    sql = sql + " AND PROCESS_NAME ='" + ProcessName + "'";
        //}
        string sSQL = $@"SELECT TO_CHAR(SYSDATE-1,'YYYY-MM-DD') FROM DUAL";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        string StartDate=dt.Rows[0][0].ToString();
        string YEAR_DATE = DateTime.Now.ToString("yyyy-MM-dd");
        sSQL = $@"SELECT * FROM SAJET.SYS_ECHECK_TEMPLATE_MODEL  WHERE DN_STATUS IN('任务审核')"+sql+"";
        dt = PubClass.getdatatableMES(sSQL);
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
        string sql = "";
        string sSQL = $@"SELECT C.REMARK,C.UPDATE_DATE,E.EMP_NAME AS EMP_NAME1,B.RESULT,B.FA,B.CA,A.TEMPLATE,B.ID,B.DN_NO,C.YEAR_DATE,C.CLASS,B.TYPE1,B.TYPE2,B.TYPE3,B.TYPE4,B.TYPE5,B.TYPE6,B.TYPE7,B.TYPE8,B.TYPE9,B.TYPE10,B.TYPE11,B.TYPE12,B.TYPE13,B.TYPE14,B.TYPE15,B.TYPE16,B.TYPE17,B.TYPE18,B.TYPE19,B.TYPE20,B.CREATE_DATE,D.EMP_NAME FROM SAJET.SYS_ECHECK_TEMPLATE_CONFIG A ,SAJET.G_ECHECK_BASE B,SAJET.SYS_ECHECK_TEMPLATE_MODEL C,SAJET.SYS_EMP D,SAJET.SYS_EMP E
WHERE A.NUMBER_ID=B.NUMBER_ID
AND A.NUMBER_ID=C.NUMBER_ID
AND B.DN_NO=C.DN_NO AND B.DN_NO ='" + DN_NO + "'  AND B.CREATE_EMPID=D.EMP_ID(+) AND C.UPDATE_USERID=E.EMP_ID(+) ORDER BY B.SEQ";
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