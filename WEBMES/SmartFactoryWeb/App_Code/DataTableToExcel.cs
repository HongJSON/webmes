using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Text;
using ExcelLibrary.SpreadSheet;
using NPOI.HSSF.UserModel;
using NPOI.SS.Formula.Eval;
using NPOI.SS.Formula.Functions;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.POIFS.FileSystem;
using NPOI.HPSF;
using NPOI.SS.Util;
using System.Drawing;
using NPOI.HSSF.Util;
using System.Text.RegularExpressions;

/// <summary>
/// DataTableToExcel 的摘要说明
/// </summary>
public class DataTableToExcel
{
	public DataTableToExcel()
	{
		//
		// TODO: 在此处添加构造函数逻辑
		//
	}
    public static string DataTableToExcelXLSX(System.Data.DataTable dtData, String FileName)
    {

        //当前对话 
        System.Web.HttpContext curContext = System.Web.HttpContext.Current;

        DataTable DT = dtData;
        ExcelToDataTable exd = new ExcelToDataTable();
        string serverPath = curContext.Server.MapPath("~/TempFolder/");
        string str_date = DateTime.Now.ToString("yyyyMMddHHmmssfff");
        string strFile = "/TempFolder/" + FileName + str_date + ".xlsx";
        exd.DataTableToExcel(DT, "Sheet1", true, curContext.Server.MapPath(strFile));
        strFile = serverPath + "" + FileName + str_date + ".xlsx";

        //获取项目绝对路径地址
        string url = HttpContext.Current.Request.Url.AbsoluteUri.ToString().Split('/')[0] + "//" + HttpContext.Current.Request.Url.Authority.ToString();
        string httpurl = "";

        var virtualPath = System.Web.Hosting.HostingEnvironment.ApplicationVirtualPath;
        string fileName = "";
        if (virtualPath != "/")
        {
            //有子应用程序
            fileName = virtualPath + "/TempFolder/" + FileName + str_date + ".xlsx";
        }
        else
        {
            fileName = "/TempFolder/" + FileName + str_date + ".xlsx";
        }

        //拼接文件相对地址
        //string fileName = "/Document/TemporaryDocuments/" + tempExcelName;

        //返回文件url地址
        httpurl = url + fileName;

        //清除历史文件，避免历史文件越来越多，可进行删除
        DirectoryInfo dyInfo = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/TempFolder/"));
        //获取文件夹下所有的文件
        foreach (FileInfo feInfo in dyInfo.GetFiles())
        {
            //判断文件日期是否小于两天前，是则删除
            if (feInfo.CreationTime < DateTime.Today.AddDays(-2))
                feInfo.Delete();
        }

        //返回下载地址
        return httpurl;

    }
    /// <summary>
    /// 将DataTable数据导入到excel中
    /// </summary>
    /// <param name="data">要导入的数据</param>
    /// <param name="isColumnWritten">DataTable的列名是否要导入</param>
    /// <param name="sheetName">要导入的excel的sheet的名称</param>
    /// <returns>导入数据行数(包含列名那一行)</returns>
    public int DataTableToExcelNew(DataTable data, string sheetName, bool isColumnWritten, string fileName, string s_type)
    {
        int count = 0;
        int j = 0;
        int i = 0;
        IWorkbook workbook = new XSSFWorkbook();
        ISheet mysheet = workbook.CreateSheet(sheetName);
        ICell cell = null;
        //csRightHeader
        ICellStyle csRightHeader = workbook.CreateCellStyle();
        csRightHeader.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
        csRightHeader.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin;
        csRightHeader.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
        csRightHeader.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin;
        csRightHeader.FillBackgroundColor = NPOI.HSSF.Util.HSSFColor.Red.Index;
        csRightHeader.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.LightGreen.Index;
        csRightHeader.FillPattern = FillPattern.SolidForeground;
        csRightHeader.WrapText = true;// 指定单元格自动换行
        IFont F = workbook.CreateFont();
        F.Boldweight = short.MaxValue;
        F.IsBold = true;
        F.FontHeightInPoints = 10;
        csRightHeader.SetFont(F);//设置字体
        csRightHeader.VerticalAlignment = VerticalAlignment.Center;//垂直居中
        csRightHeader.Alignment = HorizontalAlignment.Right;
        //
        if (isColumnWritten == true) //写入DataTable的列名
        {

            IRow row = mysheet.CreateRow(0);

            for (j = 0; j < data.Columns.Count; ++j)
            {
                cell = row.CreateCell(j);
                cell.CellStyle = csRightHeader;
                cell.SetCellValue(data.Columns[j].ColumnName);
            }
            count = 1;
        }
        else
        {
            count = 0;
        }

        ICellStyle csRight = workbook.CreateCellStyle();
        csRight.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
        csRight.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin;
        csRight.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
        csRight.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin;
        //csRight.WrapText = true;// 指定单元格自动换行
        IFont Fmin = workbook.CreateFont();
        Fmin.FontHeightInPoints = 8;
        csRight.SetFont(Fmin);//设置字体
        csRight.VerticalAlignment = VerticalAlignment.Center;//垂直居中
        csRight.Alignment = HorizontalAlignment.Right;

        for (i = 0; i < data.Rows.Count; ++i)
        {
            IRow row = mysheet.CreateRow(count);
            for (j = 0; j < data.Columns.Count; ++j)
            {
                cell = row.CreateCell(j);
                Boolean isNum = false;
                Boolean isInteger = false;
                Boolean isPercent = false;
                Boolean isDate = false;
                DateTime dt_dt ;
                object data1 = data.Rows[i][j];
                if ((data.Rows[i][j] != null) && (data.Rows[i][j].ToString() != ""))
                {
                    string columnName = data.Columns[j].ToString().ToUpper();
                    if (s_type == "ProjectScope")   //日期型和数值型都挑出来显示
                    {
                        if (columnName == "QTY")
                        {
                            int dd = Convert.ToInt16(data1);
                            csRight.DataFormat = HSSFDataFormat.GetBuiltinFormat("#,#0");
                            cell.CellStyle = csRight;
                            cell.SetCellValue(data1.ToString());
                        }
                        else if (columnName.Contains("DATE"))
                        {
                            isDate = DateTime.TryParse(data1.ToString(), out dt_dt);
                            if (isDate)
                            {
                                csRight.DataFormat = workbook.CreateDataFormat().GetFormat("yyyy-mm-dd");
                                cell.CellStyle = csRight;
                                cell.SetCellValue(data.Rows[i][j].ToString());
                            }
                            else
                            {
                                cell.CellStyle = csRight;
                                cell.SetCellValue(data.Rows[i][j].ToString());
                            }
                        }
                        else
                        {
                            cell.CellStyle = csRight;
                            cell.SetCellValue(data.Rows[i][j].ToString());
                        }
                    }
                    else if (s_type == "Workcenter")   //日期型和数值型都挑出来显示
                    {
                        cell.CellStyle = csRight;
                        cell.SetCellValue(data.Rows[i][j].ToString());
                    }
                    else if (s_type == "Workload")   //日期型和数值型都挑出来显示
                    {
                        if ((columnName == "SALES_ORDER") || (columnName == "SALES_ORDERITEM") || (columnName == "NETWORK") || (columnName == "WBS"))
                        {
                            cell.CellStyle = csRight;
                            cell.SetCellValue(data.Rows[i][j].ToString());
                        }
                        else if (columnName.Contains('/'))
                        {
                            double dd = Convert.ToDouble(data1);
                            csRight.DataFormat = (short)CellType.Numeric;
                            cell.CellStyle = csRight;
                            cell.SetCellValue(dd);
                        }
                        else
                        {
                            isNum = Regex.IsMatch(data1.ToString(), "^(-?\\d+)(\\.\\d+)?$");
                            isInteger = Regex.IsMatch(data1.ToString(), "^[-\\+]?[\\d]*$");
                            isPercent = data1.ToString().Contains("%");
                            isDate = DateTime.TryParse(data1.ToString(), out dt_dt);

                            if (isNum && !isPercent)
                            {
                                try
                                {
                                    double dd = Convert.ToDouble(data1);
                                    csRight.DataFormat = (short)CellType.Numeric;
                                    cell.CellStyle = csRight;
                                    cell.SetCellValue(dd);
                                }
                                catch
                                {
                                    cell.CellStyle = csRight;
                                    cell.SetCellValue(data.Rows[i][j].ToString());
                                }
                            }
                            else if (isDate)
                            {
                                csRight.DataFormat = workbook.CreateDataFormat().GetFormat("yyyy-mm-dd");
                                cell.CellStyle = csRight;
                                cell.SetCellValue(data.Rows[i][j].ToString());
                            }
                            else
                            {
                                cell.CellStyle = csRight;
                                cell.SetCellValue(data.Rows[i][j].ToString());
                            }
                        }
                    }
                    else
                    {
                        isNum = Regex.IsMatch(data1.ToString(), "^(-?\\d+)(\\.\\d+)?$");
                        isInteger = Regex.IsMatch(data1.ToString(), "^[-\\+]?[\\d]*$");
                        isPercent = data1.ToString().Contains("%");
                        isDate = DateTime.TryParse(data1.ToString(), out dt_dt);

                        if (isNum && !isPercent)
                        {
                            try
                            {
                                double dd = Convert.ToDouble(data1);
                                csRight.DataFormat = (short)CellType.Numeric;
                                cell.CellStyle = csRight;
                                cell.SetCellValue(dd);
                            }
                            catch
                            {
                                cell.CellStyle = csRight;
                                cell.SetCellValue(data.Rows[i][j].ToString());
                            }
                        }
                        else if (isDate)
                        {
                            csRight.DataFormat = workbook.CreateDataFormat().GetFormat("yyyy-mm-dd");
                            cell.CellStyle = csRight;
                            cell.SetCellValue(data.Rows[i][j].ToString());
                        }
                        else
                        {
                            cell.CellStyle = csRight;
                            cell.SetCellValue(data.Rows[i][j].ToString());
                        }
                    }

                }
                else
                {
                    cell.CellStyle = csRight;
                    cell.SetCellValue(data.Rows[i][j].ToString());
                }
            }
            ++count;
        }
        FileStream file = new FileStream(fileName, FileMode.Create);
        workbook.Write(file); //写入到excel
        return count;
    }


    /// <summary>
    /// 将DataTable数据导入到excel中
    /// </summary>
    /// <param name="data">要导入的数据</param>
    /// <param name="isColumnWritten">DataTable的列名是否要导入</param>
    /// <param name="sheetName">要导入的excel的sheet的名称</param>
    /// <returns>导入数据行数(包含列名那一行)</returns>
    public int DataTableToExcelAllNew(DataSet ds, bool isColumnWritten, string fileName)
    {
        int count = 0;
        int j = 0;
        int i = 0;
        IWorkbook workbook = new XSSFWorkbook();
        for (int k = 0; k < ds.Tables.Count; k++)
        {
            if (ds.Tables[k] != null)
            {
                DataTable data = ds.Tables[k];
                ISheet mysheet = workbook.CreateSheet(ds.Tables[k].TableName);
                ICell cell = null;
                //csRightHeader
                ICellStyle csRightHeader = workbook.CreateCellStyle();
                csRightHeader.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
                csRightHeader.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin;
                csRightHeader.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
                csRightHeader.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin;
                csRightHeader.FillBackgroundColor = NPOI.HSSF.Util.HSSFColor.Red.Index;
                csRightHeader.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.LightGreen.Index;
                csRightHeader.FillPattern = FillPattern.SolidForeground;
                csRightHeader.WrapText = true;// 指定单元格自动换行
                IFont F = workbook.CreateFont();
                F.Boldweight = short.MaxValue;
                F.IsBold = true;
                F.FontHeightInPoints = 10;
                csRightHeader.SetFont(F);//设置字体
                csRightHeader.VerticalAlignment = VerticalAlignment.Center;//垂直居中
                csRightHeader.Alignment = HorizontalAlignment.Right;
                //
                if (isColumnWritten == true) //写入DataTable的列名
                {

                    IRow row = mysheet.CreateRow(0);

                    for (j = 0; j < data.Columns.Count; ++j)
                    {
                        cell = row.CreateCell(j);
                        cell.CellStyle = csRightHeader;
                        cell.SetCellValue(data.Columns[j].ColumnName);
                    }
                    count = 1;
                }
                else
                {
                    count = 0;
                }

                ICellStyle csRight = workbook.CreateCellStyle();
                csRight.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
                csRight.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin;
                csRight.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
                csRight.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin;
                //csRight.WrapText = true;// 指定单元格自动换行
                IFont Fmin = workbook.CreateFont();
                Fmin.FontHeightInPoints = 8;
                csRight.SetFont(Fmin);//设置字体
                csRight.VerticalAlignment = VerticalAlignment.Center;//垂直居中
                csRight.Alignment = HorizontalAlignment.Right;

                for (i = 0; i < data.Rows.Count; ++i)
                {
                    IRow row = mysheet.CreateRow(count);
                    for (j = 0; j < data.Columns.Count; ++j)
                    {
                        cell = row.CreateCell(j);
                        Boolean isNum = false;
                        Boolean isInteger = false;
                        Boolean isPercent = false;
                        Boolean isDate = false;
                        DateTime dt_dt;
                        object data1 = data.Rows[i][j];
                        if ((data.Rows[i][j] != null) && (data.Rows[i][j].ToString() != ""))
                        {
                            string columnName = data.Columns[j].ToString().ToUpper();

                            //SALES_ORDER	SALES_ORDERITEM	NETWORK
                            if ((columnName == "SALES_ORDER") || (columnName == "SALES_ORDERITEM") || (columnName == "NETWORK") || (columnName == "WBS"))
                            {
                                cell.CellStyle = csRight;
                                cell.SetCellValue(data.Rows[i][j].ToString());
                            }
                            else if (columnName.Contains('/'))
                            {
                                double dd = Convert.ToDouble(data1);
                                csRight.DataFormat = (short)CellType.Numeric;
                                cell.CellStyle = csRight;
                                cell.SetCellValue(dd);
                            }
                            else
                            {
                                isNum = Regex.IsMatch(data1.ToString(), "^(-?\\d+)(\\.\\d+)?$");
                                isInteger = Regex.IsMatch(data1.ToString(), "^[-\\+]?[\\d]*$");
                                isPercent = data1.ToString().Contains("%");
                                isDate = DateTime.TryParse(data1.ToString(), out dt_dt);
                                if (isNum && !isPercent)
                                {
                                    try
                                    {
                                        double dd = Convert.ToDouble(data1);
                                        csRight.DataFormat = (short)CellType.Numeric;
                                        cell.CellStyle = csRight;
                                        cell.SetCellValue(dd);
                                    }
                                    catch
                                    {
                                        cell.CellStyle = csRight;
                                        cell.SetCellValue(data.Rows[i][j].ToString());
                                    }
                                }
                                else if (isDate)
                                {
                                    csRight.DataFormat = workbook.CreateDataFormat().GetFormat("yyyy-mm-dd");
                                    cell.CellStyle = csRight;
                                    cell.SetCellValue(data.Rows[i][j].ToString());
                                }
                                else
                                {
                                    cell.CellStyle = csRight;
                                    cell.SetCellValue(data.Rows[i][j].ToString());
                                }
                            }
                        }
                        else
                        {
                            cell.CellStyle = csRight;
                            cell.SetCellValue(data.Rows[i][j].ToString());
                        }
                    }
                    ++count;
                }
            }
        }
        FileStream file = new FileStream(fileName, FileMode.Create);
        workbook.Write(file); //写入到excel
        return count;
    }

   
}