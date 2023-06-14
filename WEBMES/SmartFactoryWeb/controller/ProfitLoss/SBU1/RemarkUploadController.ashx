<%@ WebHandler Language= "C#" Class="RemarkUploadController" %>

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

public class RemarkUploadController : IHttpHandler
{
    string str_loginhost = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"].ToString(); 
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string funcName = context.Request["funcName"];
        string user = context.Request["user"];
        string modelName = context.Request["modelName"];
        string modelId = context.Request["modelId"];
        string id = context.Request["id"];
        string projectType = context.Request["projectType"];
        string projectName = context.Request["projectName"];
        string exrate = context.Request["exrate"];
        string priceDollar = context.Request["priceDollar"];
        string priceRmb = context.Request["priceRmb"];
        string bomCostDollar = context.Request["bomCostDollar"];
        string bomCostRmb = context.Request["bomCostRmb"];
        string laborRate = context.Request["laborRate"];
        string upphTarget = context.Request["upphTarget"];
        string sga = context.Request["sga"];
        string isUpload = context.Request["isUpload"];
        string dlhNum = context.Request["dlhNum"];
        string remark = context.Request["remark"];
        
        switch (funcName)
        {
            case "show":
                rtnValue = show(isUpload);
                break;
            case "add":
                rtnValue = add(id, remark, user);
                break;
            case "del":
                rtnValue = del(id, user);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string add(string id,string remark, string user)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
        }

        double temp = remark.Length;

        if (temp <= 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"生产备注未填写,请检查！\"}]";
        }

        string sSQL = $@"UPDATE SAJET.G_PAL_COST_SUMMARY
                        SET REMARK = '{remark}',MODIFY_EMP_ID  = '{userEmpId}',UPDATE_DATE = SYSDATE
                        WHERE ID = '{id}'";

        PubClass.getdatatablenoreturnMES(sSQL);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"生产备注填报完成！\"}]";
    }

    public string show(string isUpload)
    {
        string sSQL = $@"SELECT ID,PROJECT_TYPE ,TO_CHAR(START_TIME,'yyyy-MM-dd hh24:mi:ss') AS START_TIME ,TO_CHAR(END_TIME,'yyyy-MM-dd hh24:mi:ss') END_TIME ,ROUND(SALES_VOLUME,2) AS SALES_VOLUME ,ROUND(TOTAL_COST,2) AS TOTAL_COST ,(ROUND(PROFIT*100,2)||'%') AS PROFITS,REMARK 
                            FROM SAJET.G_PAL_COST_SUMMARY GPCS 
                            WHERE 1=1";

        if (isUpload== "未填报")
        {
            sSQL += " AND REMARK IS NULL ";
        }else if (isUpload == "已填报")
        {
            sSQL += " AND REMARK IS NOT NULL ";
        }

        sSQL += " ORDER BY END_TIME DESC,PROJECT_TYPE ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string addPLModelConfig(string modelName,string projectType,string projectName,string exrate,string priceDollar,string priceRmb,string bomCostDollar,string bomCostRmb,string laborRate,string upphTarget,string sga,string user)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
        }        

        if (projectType.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"项目类型为空,请检查！\"}]";
        }

        if (projectName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"项目名称为空,请检查！\"}]";
        }

        if (modelName.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"机种名称为空,请检查！\"}]";
        }

        if (exrate.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"汇率为空,请检查！\"}]";
        }
        
        if (priceDollar.Length == 0 || priceRmb.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"售价为空,请检查！\"}]";
        }

        if (bomCostDollar.Length == 0 || bomCostRmb.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"Bom Cost为空,请检查！\"}]";
        }

        if (laborRate.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"工费率+制费率 为空,请检查！\"}]";
        }

        if (sga.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"SG&A 为空,请检查！\"}]";
        }

        if (upphTarget.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"UPPH Target 为空,请检查！\"}]";
        }

        string id = System.Guid.NewGuid().ToString("N");

       

        string sSQL = $@"SELECT *
                        FROM SAJET.SYS_PAL_MODEL_CONFIG SPMC 
                        WHERE PROJECT_TYPE = '{projectType}'
                        AND PROJECT_NAME = '{projectName}'
                        AND ENABLE = 'Y'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count > 0)
        {
            sSQL = $@"UPDATE SAJET.SYS_PAL_MODEL_CONFIG SPMC 
                        SET ENABLE = 'N',MODIFY_DATE = SYSDATE ,MODIFY_EMP_ID  = {userEmpId}
                        WHERE PROJECT_TYPE = '{projectType}'
                        AND PROJECT_NAME = '{projectName}'
                        AND ENABLE = 'Y'";

            PubClass.getdatatablenoreturnMES(sSQL);

            //return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前项目类型和项目名称已存在！\"}]";
        }

        sSQL = $@"SELECT *
                        FROM SAJET.SYS_PAL_MODEL_CONFIG SPMC 
                        WHERE PROJECT_TYPE = '{projectType}'
                        AND ENABLE = 'Y'";

        dt = PubClass.getdatatableMES(sSQL);

        sSQL = $@"INSERT INTO SAJET.SYS_PAL_MODEL_CONFIG
                (ID, PROJECT_TYPE, MODEL_ID, SEQ_NUM, EXRATE, PRICE_DOLLAR, PRICE_RMB, BOM_COST_DOLLAR, BOM_COST_RMB, LABOR_RATE, SG_A, PROJECT_NAME, UPPH_TARGET, ENABLE, CREATE_DATE, MODIFY_DATE, MODIFY_EMP_ID)
                VALUES('{id}', '{projectType}', '{modelName}', {dt.Rows.Count}, '{exrate}', '{priceDollar}', '{priceRmb}', '{bomCostDollar}', '{bomCostRmb}', '{laborRate}', '{sga}', '{projectName}', '{upphTarget}', 'Y', SYSDATE, SYSDATE, '{userEmpId}')";

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

    private string del(string id,string user)
    {
        try
        {
            string sSQL = $@"SELECT *
                                FROM SAJET.G_PAL_DAY_YIELD_SUMMARY
                                WHERE ID = '{id}'
                                AND ENABLED = 'Y'";

            DataTable dt = PubClass.getdatatableMES(sSQL);

            if (dt.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前统计数据不存在,请刷新页面后重新操作！\"}]";
            }

            string userEmpId = getEmpIdByNo(user);

            if (userEmpId.Length == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
            }

            sSQL = $@"UPDATE SAJET.G_PAL_DAY_YIELD_SUMMARY
                        SET ENABLED = 'N',UPDATE_USER_EMP = '{userEmpId}',UPDATE_DATE = SYSDATE
                        WHERE ID = '{id}'";

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