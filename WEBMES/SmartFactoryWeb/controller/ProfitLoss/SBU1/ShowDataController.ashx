<%@ WebHandler Language = "C#" Class="ShowDataController" %>

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
using System.Collections.Generic;
using System.IO;

public class ShowDataController : IHttpHandler
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
        string start_date = context.Request["start_date"];
        string end_date = context.Request["end_date"];
        string dataType = context.Request["dataType"];

        switch (funcName)
        {
            case "addPLModelConfig":
                rtnValue = addPLModelConfig(modelName, projectType, projectName, exrate, priceDollar, priceRmb, bomCostDollar, bomCostRmb, laborRate, upphTarget, sga, user);
                break;
            case "showMail":
                rtnValue = showMail(start_date, end_date, dataType);
                break;
            case "show":
                rtnValue = getHtmlTable("", "");
                break;
            case "addDLH":
                rtnValue = addDLHNum(id, dlhNum, user);
                break;
            case "del":
                rtnValue = del(id, user);
                break;
        }
        context.Response.Write(rtnValue);
    }

    public string addDLHNum(string id, string dlhNum, string user)
    {
        string userEmpId = getEmpIdByNo(user);

        if (userEmpId.Length == 0)
        {
            return "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"用户信息不存在,请检查！\"}]";
        }

        try
        {
            double temp = Convert.ToDouble(dlhNum);

            if (temp < 0)
            {
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

    public string showMail(string start_date, string end_date, string dataType)
    {

        string contentStr = getMailContent(start_date, end_date, dataType);

        return contentStr;
    }

    private string getMailContent(string start_date, string end_date, string dataType)
    {
        string mailMessage = $@"<!DOCTYPE html>
                                    <html>

                                    <head>
                                        <title></title>
                                        <meta charset='utf-8'>
                                    </head>

                                    <body>
                                        <p>以下是 属于 MES系统 自动发送 ，请勿直接回复，谢谢。</p>
                                        <p></p>
                                        <p> ";

        string titleMessage = getHtmlTable(start_date, end_date, dataType);

        string endMessage = $@" </p >
                            </ body >

                            </ html > ";

        mailMessage = mailMessage + titleMessage + endMessage;

        return mailMessage;
    }

    public string getHtmlTable(string startTime, string endTime, string type = "0")
    {
        if (startTime.Length == 0 || endTime.Length == 0)
        {
            startTime = DateTime.Now.AddDays(-2).ToString("yyyy-MM-dd") + "20:00:00";
            endTime = DateTime.Now.AddDays(-1).ToString("yyyy-MM-dd") + "20:00:00";
        }

        string sSQL = "";
        int mergeCell = 4;

        if (type == "0")
        {
            mergeCell = 4;

            sSQL = "SELECT \"售价$\",\"售价¥\",\"BOM cost $\",\"BOM cost ¥\",\"工费率+制费率 ￥\",\"SG&A\",\"项目类型\",\"Project\",\"投入数量\",\"产出数量\", "
                     + " \"不良品数\",\"实际投入工时\",\"UPPH target\", \"UPPH actual\",\"UPPH达成率\",WEIGHTED  AS \"权重\",\"销售额\",\"总成本\",\"Profit\" ,\"备注\" "
                       + " FROM( "
                       + "    SELECT "
                       + "    round(A.PRICE_DOLLAR,4) AS \"售价$\", "
                       + "    round(A.PRICE_RMB,4) AS \"售价¥\", "
                       + "    round(A.BOM_COST_DOLLAR,4) AS \"BOM cost $\" , "
                       + "    round(A.BOM_COST_RMB,4) AS \"BOM cost ¥\", "
                       + "    round(A.LABOR_RATE,4) AS \"工费率+制费率 ￥\", "
                       + "    round(A.SG_A,4) AS \"SG&A\", "
                       + "    A.PROJECT_TYPE AS \"项目类型\", "
                       + "    A.PROJECT_NAME AS \"Project\", "
                       + "   SUM(A.INPUT_QTY) AS \"投入数量\", "
                       + "    SUM(A.OUTPUT_QTY) AS \"产出数量\", "
                       + "    SUM(A.FAIL_QTY) AS \"不良品数\", "
                       + "    SUM(A.DLH_NUM) AS \"实际投入工时\", "
                       + "    round(A.UPPH_TARGET,0) AS \"UPPH target\", "
                       + "    CASE WHEN SUM(A.DLH_NUM) = 0 THEN 'N/A' ELSE TO_CHAR(round(SUM(A.OUTPUT_QTY)/SUM(A.DLH_NUM),0)) END AS \"UPPH actual\", "
                       + "    CASE WHEN SUM(A.DLH_NUM) = 0 THEN 'N/A' ELSE TO_CHAR(round(SUM(A.OUTPUT_QTY)/SUM(A.DLH_NUM)/A.UPPH_TARGET*100,0))||'%' END AS \"UPPH达成率\", "
                       + "    TO_CHAR(round(A.WEIGHTED*100, 0)) || '%' AS WEIGHTED, "
                       + "    A.SEQ_NUM "
                       + "    FROM "
                       + "    SAJET.G_PAL_DAY_YIELD_SUMMARY A "
                       + "    WHERE A.START_TIME >= TO_DATE('" + startTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "    AND A.END_TIME <= TO_DATE('" + endTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "    GROUP BY A.PRICE_DOLLAR, A.PRICE_RMB, A.BOM_COST_DOLLAR, A.BOM_COST_RMB, A.LABOR_RATE, A.SG_A, "
                       + "    A.PROJECT_TYPE, A.PROJECT_NAME, A.UPPH_TARGET, A.WEIGHTED, A.SEQ_NUM "
                       + " ) A "
                       + " LEFT JOIN( "
                       + "     SELECT PROJECT_TYPE, round(SALES_VOLUME,3) AS \"销售额\",round(TOTAL_COST,3) AS \"总成本\",REMARK AS \"备注\",CASE WHEN SALES_VOLUME = 0 THEN '0' ELSE (TO_CHAR(round((SALES_VOLUME-TOTAL_COST)/SALES_VOLUME*100,3))) END ||'%' AS \"Profit\" "
                       + "    FROM( "
                       + "        SELECT PROJECT_TYPE, REMARK, SUM(SALES_VOLUME) AS SALES_VOLUME, SUM(TOTAL_COST) AS TOTAL_COST,AVG(PROFIT) AS PROFIT"
                       + "        FROM SAJET.G_PAL_COST_SUMMARY GPCS "
                       + "        WHERE START_TIME >= TO_DATE('" + startTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "       AND END_TIME <= TO_DATE('" + endTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "        GROUP BY PROJECT_TYPE, REMARK "
                       + "     ) "
                       + " ) B ON A.\"项目类型\" = B.PROJECT_TYPE" +
                       " ORDER BY \"项目类型\",SEQ_NUM";
        }

        if (type == "1")
        {
            mergeCell = 2;

            sSQL = "SELECT \"项目类型\",\"Project\",\"投入数量\",\"产出数量\", "
                     + " \"不良品数\",\"实际投入工时\",\"UPPH target\", \"UPPH actual\",\"UPPH达成率\",WEIGHTED AS \"权重\",case when Profit >= 15 then '达标' else Profit ||'%' end as \"Profit\" ,\"备注\" "
                       + " FROM( "
                        + "    SELECT "
                       + "    round(A.PRICE_DOLLAR,4) AS \"售价$\", "
                       + "    round(A.PRICE_RMB,4) AS \"售价¥\", "
                       + "    round(A.BOM_COST_DOLLAR,4) AS \"BOM cost $\" , "
                       + "    round(A.BOM_COST_RMB,4) AS \"BOM cost ¥\", "
                       + "    round(A.LABOR_RATE,4) AS \"工费率+制费率 ￥\", "
                       + "    round(A.SG_A,4) AS \"SG&A\", "
                       + "    A.PROJECT_TYPE AS \"项目类型\", "
                       + "    A.PROJECT_NAME AS \"Project\", "
                       + "   SUM(A.INPUT_QTY) AS \"投入数量\", "
                       + "    SUM(A.OUTPUT_QTY) AS \"产出数量\", "
                       + "    SUM(A.FAIL_QTY) AS \"不良品数\", "
                       + "    SUM(A.DLH_NUM) AS \"实际投入工时\", "
                       + "    round(A.UPPH_TARGET,0) AS \"UPPH target\", "
                       + "    CASE WHEN SUM(A.DLH_NUM) = 0 THEN 'N/A' ELSE TO_CHAR(round(SUM(A.OUTPUT_QTY)/SUM(A.DLH_NUM),0)) END AS \"UPPH actual\", "
                       + "    CASE WHEN SUM(A.DLH_NUM) = 0 THEN 'N/A' ELSE TO_CHAR(round(SUM(A.OUTPUT_QTY)/SUM(A.DLH_NUM)/A.UPPH_TARGET*100,0))||'%' END AS \"UPPH达成率\", "
                       + "    TO_CHAR(round(A.WEIGHTED*100, 0)) || '%' AS WEIGHTED, "
                       + "    A.SEQ_NUM "
                       + "    FROM "
                       + "    SAJET.G_PAL_DAY_YIELD_SUMMARY A "
                       + "    WHERE A.START_TIME >= TO_DATE('" + startTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "    AND A.END_TIME <= TO_DATE('" + endTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "    GROUP BY A.PRICE_DOLLAR, A.PRICE_RMB, A.BOM_COST_DOLLAR, A.BOM_COST_RMB, A.LABOR_RATE, A.SG_A, "
                       + "    A.PROJECT_TYPE, A.PROJECT_NAME, A.UPPH_TARGET, A.WEIGHTED, A.SEQ_NUM "
                       + " ) A "
                       + " LEFT JOIN( "
                       + "     SELECT PROJECT_TYPE, round(SALES_VOLUME,3) AS \"销售额\",round(TOTAL_COST,3) AS \"总成本\",REMARK AS \"备注\",CASE WHEN SALES_VOLUME = 0 THEN '0' ELSE (TO_CHAR(round((SALES_VOLUME-TOTAL_COST)/SALES_VOLUME*100,3))) END AS Profit "
                       + "    FROM( "
                       + "        SELECT PROJECT_TYPE, REMARK, SUM(SALES_VOLUME) AS SALES_VOLUME, SUM(TOTAL_COST) AS TOTAL_COST,AVG(PROFIT) AS PROFIT"
                       + "        FROM SAJET.G_PAL_COST_SUMMARY GPCS "
                       + "        WHERE START_TIME >= TO_DATE('" + startTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "       AND END_TIME <= TO_DATE('" + endTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "        GROUP BY PROJECT_TYPE, REMARK "
                       + "     ) "
                       + " ) B ON A.\"项目类型\" = B.PROJECT_TYPE" +
                       " ORDER BY \"项目类型\",SEQ_NUM";
        }

        if (type == "2")
        {
            mergeCell = 1;

            sSQL = "SELECT \"项目类型\",\"Project\",\"投入数量\",\"产出数量\", "
                     + " \"不良品数\",\"实际投入工时\",\"UPPH target\", \"UPPH actual\",\"UPPH达成率\" ,\"备注\" "
                       + " FROM( "
                        + "    SELECT "
                       + "    round(A.PRICE_DOLLAR,4) AS \"售价$\", "
                       + "    round(A.PRICE_RMB,4) AS \"售价¥\", "
                       + "    round(A.BOM_COST_DOLLAR,4) AS \"BOM cost $\" , "
                       + "    round(A.BOM_COST_RMB,4) AS \"BOM cost ¥\", "
                       + "    round(A.LABOR_RATE,4) AS \"工费率+制费率 ￥\", "
                       + "    round(A.SG_A,4) AS \"SG&A\", "
                       + "    A.PROJECT_TYPE AS \"项目类型\", "
                       + "    A.PROJECT_NAME AS \"Project\", "
                       + "   SUM(A.INPUT_QTY) AS \"投入数量\", "
                       + "    SUM(A.OUTPUT_QTY) AS \"产出数量\", "
                       + "    SUM(A.FAIL_QTY) AS \"不良品数\", "
                       + "    SUM(A.DLH_NUM) AS \"实际投入工时\", "
                       + "    round(A.UPPH_TARGET,0) AS \"UPPH target\", "
                       + "    CASE WHEN SUM(A.DLH_NUM) = 0 THEN 'N/A' ELSE TO_CHAR(round(SUM(A.OUTPUT_QTY)/SUM(A.DLH_NUM),0)) END AS \"UPPH actual\", "
                       + "    CASE WHEN SUM(A.DLH_NUM) = 0 THEN 'N/A' ELSE TO_CHAR(round(SUM(A.OUTPUT_QTY)/SUM(A.DLH_NUM)/A.UPPH_TARGET*100,0))||'%' END AS \"UPPH达成率\", "
                       + "    TO_CHAR(round(A.WEIGHTED*100, 0)) || '%' AS WEIGHTED, "
                       + "    A.SEQ_NUM "
                       + "    FROM "
                       + "    SAJET.G_PAL_DAY_YIELD_SUMMARY A "
                       + "    WHERE A.START_TIME >= TO_DATE('" + startTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "    AND A.END_TIME <= TO_DATE('" + endTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "    GROUP BY A.PRICE_DOLLAR, A.PRICE_RMB, A.BOM_COST_DOLLAR, A.BOM_COST_RMB, A.LABOR_RATE, A.SG_A, "
                       + "    A.PROJECT_TYPE, A.PROJECT_NAME, A.UPPH_TARGET, A.WEIGHTED, A.SEQ_NUM "
                       + " ) A "
                       + " LEFT JOIN( "
                       + "     SELECT PROJECT_TYPE, round(SALES_VOLUME,3) AS \"销售额\",round(TOTAL_COST,3) AS \"总成本\",REMARK AS \"备注\",CASE WHEN SALES_VOLUME = 0 THEN '0' ELSE (TO_CHAR(round((SALES_VOLUME-TOTAL_COST)/SALES_VOLUME*100,3))) END||'%' AS \"Profit\" "
                       + "    FROM( "
                       + "        SELECT PROJECT_TYPE, REMARK, SUM(SALES_VOLUME) AS SALES_VOLUME, SUM(TOTAL_COST) AS TOTAL_COST,AVG(PROFIT) AS PROFIT"
                       + "        FROM SAJET.G_PAL_COST_SUMMARY GPCS "
                       + "        WHERE START_TIME >= TO_DATE('" + startTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "       AND END_TIME <= TO_DATE('" + endTime + "', 'yyyy-MM-ddhh24:mi:ss') "
                       + "        GROUP BY PROJECT_TYPE, REMARK "
                       + "     ) "
                       + " ) B ON A.\"项目类型\" = B.PROJECT_TYPE" +
                       " ORDER BY \"项目类型\",SEQ_NUM";
        }


        DataTable sqlData = PubClass.getdatatableMES(sSQL);


        string titleMessage = $@"<table border='1' style='width:100%;word-wrap:break-word;border-collapse:collapse;border: #a8aa44;font-size: 13px;'><tr style='background-color:#0a8fbd;color: cornsilk;'>";

        List<string> historyList1 = new List<string>();
        List<string> historyList2 = new List<string>();
        List<string> historyList3 = new List<string>();
        List<string> historyList4 = new List<string>();

        for (int i = 0; i < sqlData.Columns.Count; i++)
        {

            titleMessage += $@"<td>{sqlData.Columns[i].ColumnName}</td>";
        }

        titleMessage += "</tr>";

        string detailMessage = $@"";

        for (int i = 0; i < sqlData.Rows.Count; i++)
        {
            detailMessage += $@"<tr style='font-size:10px;'>";

            for (int j = 0; j < sqlData.Columns.Count; j++)
            {

                string projectType = sqlData.Rows[i]["项目类型"].ToString();

                DataRow[] drs = sqlData.Select($@"项目类型 = '{projectType}'");

                if (j >= sqlData.Columns.Count - mergeCell)
                {
                    if (mergeCell == 4)
                    {
                        if (historyList1.Contains(projectType) && historyList2.Contains(projectType) && historyList3.Contains(projectType) && historyList4.Contains(projectType))
                        {
                            continue;
                        }

                        if (j == sqlData.Columns.Count - 4)
                        {
                            historyList4.Add(projectType);
                        }

                        if (j == sqlData.Columns.Count - 3)
                        {
                            historyList3.Add(projectType);
                        }

                        if (j == sqlData.Columns.Count - 2)
                        {
                            historyList2.Add(projectType);
                        }

                        if (j == sqlData.Columns.Count - 1)
                        {
                            historyList1.Add(projectType);
                        }
                    }

                    if (mergeCell == 2)
                    {
                        if (historyList1.Contains(projectType) && historyList2.Contains(projectType))
                        {
                            continue;
                        }

                        if (j == sqlData.Columns.Count - 2)
                        {
                            historyList2.Add(projectType);
                        }

                        if (j == sqlData.Columns.Count - 1)
                        {
                            historyList1.Add(projectType);
                        }
                    }

                    if (mergeCell == 1)
                    {
                        if (historyList1.Contains(projectType))
                        {
                            continue;
                        }

                        if (j == sqlData.Columns.Count - 1)
                        {
                            historyList1.Add(projectType);
                        }
                    }


                    detailMessage += $@"<td rowspan='{drs.Length}'>{sqlData.Rows[i][sqlData.Columns[j].ColumnName]}</td>";
                }
                else
                {
                    detailMessage += $@"<td>{sqlData.Rows[i][sqlData.Columns[j].ColumnName]}</td>";
                }

            }

            detailMessage += $@"</tr>";
        }

        titleMessage = titleMessage.Trim(' ').Replace("\n", "") + detailMessage.Trim(' ').Replace("\n", "") + " </table>";

        return titleMessage;
    }


    public string addPLModelConfig(string modelName, string projectType, string projectName, string exrate, string priceDollar, string priceRmb, string bomCostDollar, string bomCostRmb, string laborRate, string upphTarget, string sga, string user)
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

    private string del(string id, string user)
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