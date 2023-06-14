<%@ WebHandler Language= "C#" Class="PLModelConfigController" %>

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

public class PLModelConfigController : IHttpHandler
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
        string startProcess = context.Request["startProcess"];
        string endProcess = context.Request["endProcess"];
        string isEndProduct = context.Request["isEndProduct"];
        string weighted = context.Request["weighted"];
        
        switch (funcName)
        {
            case "addPLModelConfig":
                rtnValue = addPLModelConfig(modelName, projectType, projectName, exrate, priceDollar, priceRmb, bomCostDollar, bomCostRmb, laborRate, upphTarget, sga, user, startProcess, endProcess, isEndProduct, weighted);
                break;
            case "show":
                rtnValue = show(projectType, projectName);
                break;
            case "del":
                rtnValue = del(id, user);
                break;
            case "showProcessName":
                rtnValue = showProcessName(modelName, user);
                break;
            case "excel":
                rtnValue = uploadFile(user, context);
                break;

        }
        context.Response.Write(rtnValue);
    }

    public string showProcessName(string modelName,string user)
    {
        string sSQL = $@"SELECT DISTINCT PROCESS_NAME,PROCESS_ID 
                            FROM (
                            SELECT DISTINCT SRD.SEQ ,SPP.PROCESS_NAME ,SPP.PROCESS_ID 
                            FROM SAJET.SYS_MODEL SM 
                            INNER JOIN SAJET.SYS_PART SP ON SM.MODEL_ID = SP.MODEL_ID 
                            INNER JOIN SAJET.SYS_ROUTE_DETAIL SRD ON SP.ROUTE_ID = SRD.ROUTE_ID 
                            INNER JOIN SAJET.SYS_PROCESS SPP ON SRD.PROCESS_ID = SPP.PROCESS_ID 
                            AND SM.MODEL_ID = '{modelName}'
                            )
                            ORDER BY PROCESS_NAME";
        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);

    }

    public string show(string projectType,string projectName)
    {
        string sSQL = $@"SELECT ID ,PROJECT_TYPE ,PROJECT_NAME ,SPMC.MODEL_ID,SM.MODEL_NAME ,SPMC.EXRATE ,SPMC.PRICE_DOLLAR ,
	                            SPMC.PRICE_RMB ,SPMC.BOM_COST_DOLLAR ,SPMC.BOM_COST_RMB ,SPMC.LABOR_RATE ,SPMC.SG_A ,SPMC.UPPH_TARGET ,
	                            SPMC.MODIFY_DATE ,SE.EMP_NAME ,STSP.PROCESS_NAME AS STPN,STSP.PROCESS_ID AS STPI,ENSP.PROCESS_NAME AS ENPN,ENSP.PROCESS_ID AS ENPI,SPMC.IS_ENDPRODUCT,
                                round(SPMC.WEIGHTED,2) AS WEIGHTED
                            FROM SAJET.SYS_PAL_MODEL_CONFIG SPMC 
                            INNER JOIN SAJET.SYS_MODEL SM ON SPMC.MODEL_ID = SM.MODEL_ID 
                            INNER JOIN SAJET.SYS_EMP SE ON SPMC.MODIFY_EMP_ID = SE.EMP_ID 
                            INNER JOIN SAJET.SYS_PROCESS STSP ON SPMC.START_PROCESS = STSP.PROCESS_ID
                            INNER JOIN SAJET.SYS_PROCESS ENSP ON SPMC.END_PROCESS = ENSP.PROCESS_ID
                            WHERE SPMC.PROJECT_TYPE LIKE '{projectType}%'
                            AND SPMC.PROJECT_NAME LIKE '{projectName}%'
                            AND SPMC.ENABLE = 'Y'
                            ORDER BY PROJECT_TYPE,SPMC.SEQ_NUM  ";

        DataTable dt = PubClass.getdatatableMES(sSQL);
        return JsonConvert.SerializeObject(dt);
    }

    public string addPLModelConfig(string modelName,string projectType,string projectName,string exrate,string priceDollar,string priceRmb,string bomCostDollar,string bomCostRmb,string laborRate,string upphTarget,string sga,string user,string startProcess, string endProcess,string isEndProduct,string weighted)
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

        if (startProcess.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"开始制程 为空,请检查！\"}]";
        }

        if (endProcess.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"结束制程 为空,请检查！\"}]";
        }

        if (weighted.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"权重 为空,请检查！\"}]";
        }

        string id = System.Guid.NewGuid().ToString("N");

       

        string sSQL = $@"SELECT SEQ_NUM
                        FROM SAJET.SYS_PAL_MODEL_CONFIG SPMC 
                        WHERE PROJECT_TYPE = '{projectType}'
                        AND PROJECT_NAME = '{projectName}'
                        AND ENABLE = 'Y'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        int seqNum = -1;

        if (dt.Rows.Count > 0)
        {
            seqNum = Convert.ToInt32(dt.Rows[0][0].ToString());

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

        if (seqNum == -1)
        {
            seqNum = dt.Rows.Count;
        }

        sSQL = $@"INSERT INTO SAJET.SYS_PAL_MODEL_CONFIG
                (ID, PROJECT_TYPE, MODEL_ID, SEQ_NUM, EXRATE, PRICE_DOLLAR, PRICE_RMB, BOM_COST_DOLLAR, BOM_COST_RMB, LABOR_RATE, SG_A, PROJECT_NAME, UPPH_TARGET, ENABLE, CREATE_DATE, MODIFY_DATE, MODIFY_EMP_ID,START_PROCESS,END_PROCESS,IS_ENDPRODUCT,WEIGHTED)
                VALUES('{id}', '{projectType}', '{modelName}', {seqNum}, '{exrate}', '{priceDollar}', '{priceRmb}', '{bomCostDollar}', '{bomCostRmb}', '{laborRate}', '{sga}', '{projectName}', '{upphTarget}', 'Y', SYSDATE, SYSDATE, '{userEmpId}',{startProcess},{endProcess},'{isEndProduct}','{weighted}')";

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
            string sSQL = $@" SELECT *
                                FROM SAJET.SYS_PAL_MODEL_CONFIG SPMC 
                                WHERE ID = '{id}'
                                AND ENABLE = 'Y'";

            DataTable dt = PubClass.getdatatableMES(sSQL);

            if (dt.Rows.Count == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"当前配置信息不存在！\"}]";
            }

            string userEmpId = getEmpIdByNo(user);

            if (userEmpId.Length == 0)
            {
                return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
            }

            sSQL = $@"UPDATE SAJET.SYS_PAL_MODEL_CONFIG SPMC 
                             SET ENABLE = 'N',MODIFY_EMP_ID = '{userEmpId}',MODIFY_DATE = SYSDATE
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

    private string uploadFile(string user, HttpContext context)
    {
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

                    FileStream fileStream = new FileStream(fname, FileMode.Open, FileAccess.Read);
                    Workbook workbook = Workbook.Load(fileStream);
                    Worksheet worksheet = workbook.Worksheets[0];

                    string projectType, projectName, modelName, isEndProduct, exrate, priceDollar, priceRmb, bomCostDollar;
                    string bomCostRmb, laborRate, sga, upphTarget, startProcess, endProcess, weighted;

                    for (int L = 1; L < worksheet.Cells.LastRowIndex + 1; L++)
                    {
                        
                        projectType = worksheet.Cells[L, 0].ToString();
                        projectName = worksheet.Cells[L, 1].ToString();
                        modelName = worksheet.Cells[L, 2].ToString();
                        isEndProduct = worksheet.Cells[L, 3].ToString();
                        exrate = worksheet.Cells[L, 4].ToString();
                        priceDollar = worksheet.Cells[L, 5].ToString();
                        priceRmb = worksheet.Cells[L, 6].ToString();
                        if (priceRmb.Length==0)
                        {
                            priceRmb = (Convert.ToDouble(exrate) * Convert.ToDouble(priceDollar)).ToString();
                        }
                        bomCostDollar = worksheet.Cells[L, 7].ToString();
                        bomCostRmb = worksheet.Cells[L, 8].ToString();
                        if (bomCostRmb.Length==0)
                        {
                            bomCostRmb = (Convert.ToDouble(exrate) * Convert.ToDouble(bomCostDollar)).ToString();
                        }
                        laborRate = worksheet.Cells[L, 9].ToString();
                        sga = worksheet.Cells[L, 10].ToString();
                        upphTarget = worksheet.Cells[L, 11].ToString();
                        startProcess = worksheet.Cells[L, 12].ToString();
                        endProcess = worksheet.Cells[L, 13].ToString();
                        weighted = worksheet.Cells[L, 14].ToString();

                        string sSQL = $@"SELECT MODEL_ID 
                                            FROM SAJET.SYS_MODEL
                                            WHERE MODEL_NAME = '{modelName}'";

                        DataTable dt = PubClass.getdatatableMES(sSQL);

                        if (dt.Rows.Count == 0)
                        {
                            continue;
                        }

                        string modelId = dt.Rows[0]["MODEL_ID"].ToString();

                        string startProcessID = getProcessIdByName(startProcess);

                        if (startProcessID == "NG")
                        {
                            continue;
                        }

                        string endProcessID = getProcessIdByName(endProcess);

                        if (endProcessID == "NG")
                        {
                            continue;
                        }

                        addPLModelConfig(modelId, projectType, projectName, exrate, priceDollar, priceRmb, bomCostDollar, bomCostRmb, laborRate, upphTarget, sga, user, startProcessID, endProcessID, isEndProduct, weighted);
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

        return "OK,批量上传成功";

    }

    public string getProcessIdByName(string processName)
    {
        string sSQL = $@"SELECT PROCESS_ID  
                        FROM SAJET.SYS_PROCESS SP 
                        WHERE PROCESS_NAME = '{processName}'";

        DataTable dt = PubClass.getdatatableMES(sSQL);

        if (dt.Rows.Count == 0)
        {
            return "NG";
        }

        return dt.Rows[0]["PROCESS_ID"].ToString();
    }
}