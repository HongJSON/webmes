<%@ WebHandler Language= "C#" Class="DLHUploadController" %>

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
using ExcelLibrary;
using ExcelLibrary.SpreadSheet;

public class DLHUploadController : IHttpHandler
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
        
        switch (funcName)
        {
            case "addPLModelConfig":
                rtnValue = addPLModelConfig(modelName, projectType, projectName, exrate, priceDollar, priceRmb, bomCostDollar, bomCostRmb, laborRate, upphTarget, sga, user);
                break;
            case "show":
                rtnValue = show(isUpload, projectName);
                break;
            case "addDLH":
                rtnValue = addDLHNum(id,dlhNum, user);
                break;
            case "del":
                rtnValue = del(id, user);
                break;
            case "GetLabel":
                rtnValue = GetLabel();
                break;
            case "excel":
                rtnValue = uploadFile(user, context);
                break;
            case "showProjectName":
                rtnValue = showProjectName(isUpload);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string showProjectName(string isUpload)
    {
        string sSQL = $@"SELECT DISTINCT SM.PROJECT_NAME  --, GPDYS.MODEL_NAME
                        FROM SAJET.G_PAL_DAY_YIELD_SUMMARY GPDYS 
                        LEFT JOIN SAJET.SYS_PAL_MODEL_CONFIG SM ON GPDYS.MODEL_ID = SM.MODEL_ID 
                            AND SM.ENABLE = 'Y'
                        WHERE 1=1
                        AND GPDYS.ENABLED = 'Y'";

        if (isUpload == "未填报")
        {
            sSQL += " AND GPDYS.DLH_NUM IS NULL ";
        }
        else if (isUpload == "已填报")
        {
            sSQL += " AND GPDYS.DLH_NUM IS NOT NULL ";
        }

        sSQL += " ORDER BY SM.PROJECT_NAME ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    private string uploadFile(string user, HttpContext context)
    {
        FileStream fileStream = null;
        try
        {

            if (context.Request.Files.Count > 0)
            {
                string filePath = context.Server.MapPath("../Data/");
                //如不存在,则创建对应文件夹
                if (!System.IO.Directory.Exists(filePath))
                {
                    System.IO.Directory.CreateDirectory(filePath);
                }
                HttpFileCollection files = context.Request.Files;
                //批量上传时使用
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    string fname = filePath + file.FileName;
                    file.SaveAs(fname);

                    fileStream = new FileStream(fname, FileMode.Open, FileAccess.Read);
                    Workbook workbook = Workbook.Load(fileStream);
                    Worksheet worksheet = workbook.Worksheets[0];

                    string id, dlhTime;

                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {

                        id = worksheet.Cells[L, 0].ToString().Replace("ID","");
                        dlhTime = worksheet.Cells[L, 9].ToString().Trim();

                        if (dlhTime==null||dlhTime.Length==0)
                        {
                            continue;
                        }

                        string sSQL = $@"SELECT *
                                        FROM SAJET.G_PAL_DAY_YIELD_SUMMARY
                                        WHERE ID = '{id}'
                                        AND ENABLED = 'Y'
                                        AND DLH_NUM IS NULL";

                        DataTable dt = PubClass.getdatatableMES(sSQL);

                        if (dt.Rows.Count == 0)
                        {
                            continue;
                        }

                        addDLHNum(id,dlhTime,user);
                    }
                    fileStream.Close();
                    File.Delete(fname);
                }
            }
        }
        catch (Exception ex)
        {
            return "NG,批量上传失败";
        }
        finally
        {
            fileStream.Close();
        }

        return "OK,批量上传成功";

    }

    public string GetLabel()
    {
        return show("未填报","");
    }

    public string addDLHNum(string id,string dlhNum,string user)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
        }

        try
        {
            double temp = Convert.ToDouble(dlhNum);

            if(temp < 0){
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"工时数量不可以小于0,请检查！\"}]";
            }
        }
        catch (Exception ex)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"工时数量不是数值类型,请检查！\"}]";
        }

        string sSQL = $@"UPDATE SAJET.G_PAL_DAY_YIELD_SUMMARY
                        SET DLH_NUM = '{dlhNum}',MODIFY_EMP_ID  = '{userEmpId}',UPDATE_DATE = SYSDATE
                        WHERE ID = '{id}'";

        PubClass.getdatatablenoreturnMES(sSQL);

        return "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"工时数据填报完成！\"}]";
    }

    public string show(string isUpload,string projectName)
    {
        string sSQL = $@"SELECT TO_CHAR(GPDYS.ID) AS ID,SM.PROJECT_NAME  ,GPDYS.MODEL_NAME ,GPDYS.MODEL_ID ,TO_CHAR(GPDYS.START_TIME,'yyyy-MM-dd hh24:mi:ss') AS START_TIME, TO_CHAR(GPDYS.END_TIME,'yyyy-MM-dd hh24:mi:ss') AS END_TIME,CASE WHEN GPDYS.SHIFT = 'D' THEN '白班' ELSE '夜班' END AS SHIFT,GPDYS.INPUT_QTY ,GPDYS.OUTPUT_QTY ,GPDYS.FAIL_QTY ,GPDYS.DLH_NUM 
                        FROM SAJET.G_PAL_DAY_YIELD_SUMMARY GPDYS 
                        LEFT JOIN SAJET.SYS_PAL_MODEL_CONFIG SM ON GPDYS.MODEL_ID = SM.MODEL_ID 
                            AND SM.ENABLE = 'Y'
                        WHERE 1=1
                        AND GPDYS.ENABLED = 'Y'";

        if (isUpload== "未填报")
        {
            sSQL += " AND GPDYS.DLH_NUM IS NULL ";
        }else if (isUpload == "已填报")
        {
            sSQL += " AND GPDYS.DLH_NUM IS NOT NULL ";
        }

        if (projectName.Length > 0)
        {
            sSQL += $" AND SM.PROJECT_NAME = '{projectName}' ";
        }

        sSQL += " AND ROWNUM <= 1000 ORDER BY GPDYS.END_TIME DESC,SM.PROJECT_NAME,GPDYS.SEQ_NUM ";

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