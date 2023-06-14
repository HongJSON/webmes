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
using System.Runtime.InteropServices;
using System.Reflection;
using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;

/// <summary>
/// ExcelToDataTable 的摘要说明
/// </summary>
public class ExcelToDataTable
{
    /// <summary>
    /// Excel文件导成Datatable
    /// </summary>
    /// <param name="strFilePath">Excel文件目录地址</param>
    /// <param name="strTableName">Datatable表名</param>
    /// <param name="iSheetIndex">Excel sheet index</param>
    /// <returns></returns>
    public DataTable XlSToDataTable(string strFilePath, string strTableName, int iSheetIndex)
    {
        string strExtName = Path.GetExtension(strFilePath);
        DataTable dt = new DataTable();
        if (!string.IsNullOrEmpty(strTableName))
        {
            dt.TableName = strTableName;
        }
        if (strExtName.Equals(".xlsx") || strExtName.Equals(".XLSX"))   //OFFICE 2007以上版本
        {
            using (FileStream file = new FileStream(strFilePath, FileMode.Open, FileAccess.Read))
            {
                XSSFWorkbook workbook = new XSSFWorkbook(file);
                ISheet sheet = workbook.GetSheetAt(iSheetIndex);
                //列头
                foreach (ICell item in sheet.GetRow(sheet.FirstRowNum).Cells)
                {
                    dt.Columns.Add(item.ToString(), typeof(string));
                }
                //写入内容
                System.Collections.IEnumerator rows = sheet.GetRowEnumerator();
                while (rows.MoveNext())
                {
                    IRow row = (XSSFRow)rows.Current;
                    if (row.RowNum == sheet.FirstRowNum)
                    {
                        continue;
                    }
                    DataRow dr = dt.NewRow();
                    foreach (ICell item in row.Cells)
                    {
                        if (item.ColumnIndex < dt.Columns.Count)
                        {
                            switch (item.CellType)
                            {
                                case CellType.Boolean:
                                    dr[item.ColumnIndex] = item.BooleanCellValue;
                                    break;
                                case CellType.Formula:
                                    switch (item.CachedFormulaResultType)
                                    {
                                        case CellType.Boolean:
                                            dr[item.ColumnIndex] = item.BooleanCellValue;
                                            break;
                                        case CellType.Numeric:
                                            if (DateUtil.IsCellDateFormatted(item))
                                            {
                                                if (item.DateCellValue.ToString() != "N/A")
                                                { dr[item.ColumnIndex] = item.DateCellValue.ToString("yyyy-MM-dd"); }
                                                else
                                                { dr[item.ColumnIndex] = null; }
                                            }
                                            else
                                            {
                                                dr[item.ColumnIndex] = item.NumericCellValue;
                                            }
                                            break;
                                        case CellType.String:
                                            string str = item.StringCellValue;

                                            if (!string.IsNullOrEmpty(str))
                                            {
                                                if ((str != "NA") && (str != "N/A"))
                                                { dr[item.ColumnIndex] = str.Replace(",", "").Replace("\n", "").ToString(); }
                                                else
                                                { dr[item.ColumnIndex] = null; }
                                            }
                                            else
                                            {
                                                dr[item.ColumnIndex] = null;
                                            }
                                            break;
                                        case CellType.Unknown:
                                        case CellType.Blank:
                                        default:
                                            dr[item.ColumnIndex] = string.Empty;
                                            break;
                                    }
                                    break;
                                case CellType.Numeric:
                                    if (DateUtil.IsCellDateFormatted(item))
                                    {
                                        string ss = item.NumericCellValue.ToString();
                                        string ddd = DateTime.FromOADate(Int32.Parse(item.NumericCellValue.ToString())).ToString("yyyy-MM-dd");
                                        dr[item.ColumnIndex] = DateTime.FromOADate(Int32.Parse(item.NumericCellValue.ToString())).ToString("yyyy-MM-dd");
                                    }
                                    else
                                    {
                                        dr[item.ColumnIndex] = item.NumericCellValue;
                                    }
                                    break;
                                case CellType.String:
                                    string strValue = item.StringCellValue;
                                    if (!string.IsNullOrEmpty(strValue))
                                    {
                                        if ((strValue != "NA") && (strValue != "N/A"))
                                        { dr[item.ColumnIndex] = strValue.ToString().Replace(",", "").Replace("\n", "").ToString(); }
                                        else
                                        { dr[item.ColumnIndex] = null; }
                                    }
                                    else
                                    {
                                        dr[item.ColumnIndex] = null;
                                    }
                                    break;
                                case CellType.Unknown:
                                case CellType.Blank:
                                default:
                                    dr[item.ColumnIndex] = string.Empty;
                                    break;
                            }
                        }
                    }
                        
                    
                    dt.Rows.Add(dr);
                }
            }
        }
        else if (strExtName.Equals(".xls") || strExtName.Equals(".XLS"))   //OFFICE 2003
        {
            using (FileStream file = new FileStream(strFilePath, FileMode.Open, FileAccess.Read))
            {
                HSSFWorkbook workbook = new HSSFWorkbook(file);
                ISheet sheet = workbook.GetSheetAt(iSheetIndex);
                //列头
                foreach (ICell item in sheet.GetRow(sheet.FirstRowNum).Cells)
                {
                    dt.Columns.Add(item.ToString(), typeof(string));
                }
                //写入内容
                System.Collections.IEnumerator rows = sheet.GetRowEnumerator();
                while (rows.MoveNext())
                {
                    IRow row = (HSSFRow)rows.Current;
                    if (row.RowNum == sheet.FirstRowNum)
                    {
                        continue;
                    }
                    DataRow dr = dt.NewRow();
                    foreach (ICell item in row.Cells)
                    {
                        switch (item.CellType)
                        {
                            case CellType.Boolean:
                                dr[item.ColumnIndex] = item.BooleanCellValue;
                                break;
                            case CellType.Formula:
                                switch (item.CachedFormulaResultType)
                                {
                                    case CellType.Boolean:
                                        dr[item.ColumnIndex] = item.BooleanCellValue;
                                        break;
                                    case CellType.Numeric:
                                        if (DateUtil.IsCellDateFormatted(item))
                                        {
                                            if (item.DateCellValue.ToString() != "N/A")
                                            { dr[item.ColumnIndex] = item.DateCellValue.ToString("yyyy-MM-dd"); }
                                            else
                                            { dr[item.ColumnIndex] = null; }
                                        }
                                        else
                                        {
                                            dr[item.ColumnIndex] = item.NumericCellValue;
                                        }
                                        break;
                                    case CellType.String:
                                        string str = item.StringCellValue;

                                        if (!string.IsNullOrEmpty(str))
                                        {
                                            if ((str != "NA") && (str != "N/A"))
                                            { dr[item.ColumnIndex] = str.Replace(",", "").Replace("\n", "").ToString(); }
                                            else
                                            { dr[item.ColumnIndex] = null; }
                                        }
                                        else
                                        {
                                            dr[item.ColumnIndex] = null;
                                        }
                                        break;
                                    case CellType.Unknown:
                                    case CellType.Blank:
                                    default:
                                        dr[item.ColumnIndex] = string.Empty;
                                        break;
                                }
                                break;
                            case CellType.Numeric:
                                if (DateUtil.IsCellDateFormatted(item))
                                {
                                    if (item.DateCellValue.ToString() != "N/A")
                                    { dr[item.ColumnIndex] = item.DateCellValue.ToString("yyyy-MM-dd"); }
                                    else
                                    { dr[item.ColumnIndex] = null; }
                                }
                                else
                                {
                                    dr[item.ColumnIndex] = item.NumericCellValue;
                                }
                                break;
                            case CellType.String:
                                string strValue = item.StringCellValue;
                                if (!string.IsNullOrEmpty(strValue))
                                {
                                    if ((strValue != "NA") && (strValue != "N/A"))
                                    { dr[item.ColumnIndex] = strValue.ToString().Replace(",", "").Replace("\n", "").ToString(); }
                                    else
                                    { dr[item.ColumnIndex] = null; }

                                }
                                else
                                {
                                    dr[item.ColumnIndex] = null;
                                }
                                break;
                            case CellType.Unknown:
                            case CellType.Blank:
                            default:
                                dr[item.ColumnIndex] = string.Empty;
                                break;
                        }
                    }
                    dt.Rows.Add(dr);
                }
            }
        }
        else
        {}
        return dt;
    }


    /// <summary>
    /// Excel文件导成Datatable For Workcenter STD
    /// </summary>
    /// <param name="strFilePath">Excel文件目录地址</param>
    /// <param name="strTableName">Datatable表名</param>
    /// <param name="iSheetIndex">Excel sheet index</param>
    /// <returns></returns>
    public DataTable XlSToDataTable_WorkcenterSTD(string strFilePath, string strTableName, int iSheetIndex)
    {
        string strExtName = Path.GetExtension(strFilePath);
        DataTable dt = new DataTable();
        if (!string.IsNullOrEmpty(strTableName))
        {
            dt.TableName = strTableName;
        }
        if (strExtName.Equals(".xlsx") || strExtName.Equals(".XLSX"))   //OFFICE 2007以上版本
        {
            using (FileStream file = new FileStream(strFilePath, FileMode.Open, FileAccess.Read))
            {
                XSSFWorkbook workbook = new XSSFWorkbook(file);
                ISheet sheet = workbook.GetSheetAt(iSheetIndex);
                //列头
                //foreach (ICell item in sheet.GetRow(sheet.FirstRowNum).Cells)
                //{
                //    dt.Columns.Add(item.ToString(), typeof(string));
                //}
                dt.Columns.Add("product_name");
                dt.Columns.Add("workcntr");
                dt.Columns.Add("std");

                //写入内容
                System.Collections.IEnumerator rows = sheet.GetRowEnumerator();
                while (rows.MoveNext())
                {
                    IRow row = (XSSFRow)rows.Current;
                    if (row.RowNum == sheet.FirstRowNum)
                    {
                        continue;
                    }
                    string str_productname = "";
                    foreach (ICell item in row.Cells)
                    {
                        DataRow dr = dt.NewRow();
                        //str_productname = "";
                        if (sheet.GetRow(sheet.FirstRowNum).Cells[item.ColumnIndex].ToString().ToLower().Contains("product"))
                        {
                            //dr[0] = item.StringCellValue;
                            str_productname = item.StringCellValue;
                            continue;
                        }
                        else
                        {

                            dr[0] = str_productname;
                            dr[1] = sheet.GetRow(sheet.FirstRowNum).Cells[item.ColumnIndex].ToString();

                            switch (item.CellType)
                            {
                                case CellType.Boolean:
                                    dr[2] = item.BooleanCellValue;
                                    break;
                                case CellType.Formula:
                                    switch (item.CachedFormulaResultType)
                                    {
                                        case CellType.Boolean:
                                            dr[2] = item.BooleanCellValue;
                                            break;
                                        case CellType.Numeric:
                                            if (DateUtil.IsCellDateFormatted(item))
                                            {
                                                if (item.DateCellValue.ToString() != "N/A")
                                                { dr[2] = item.DateCellValue.ToString("yyyy-MM-dd"); }
                                                else
                                                { dr[2] = null; }
                                            }
                                            else
                                            {
                                                dr[2] = item.NumericCellValue;
                                            }
                                            break;
                                        case CellType.String:
                                            string str = item.StringCellValue;

                                            if (!string.IsNullOrEmpty(str))
                                            {
                                                if ((str != "NA") && (str != "N/A"))
                                                { dr[2] = str.Replace(",", "").Replace("\n", "").ToString(); }
                                                else
                                                { dr[2] = null; }
                                            }
                                            else
                                            {
                                                dr[2] = null;
                                            }
                                            break;
                                        case CellType.Unknown:
                                        case CellType.Blank:
                                        default:
                                            dr[2] = string.Empty;
                                            break;
                                    }
                                    break;
                                case CellType.Numeric:
                                    if (DateUtil.IsCellDateFormatted(item))
                                    {
                                        string ss = item.NumericCellValue.ToString();
                                        string ddd = DateTime.FromOADate(Int32.Parse(item.NumericCellValue.ToString())).ToString("yyyy-MM-dd");
                                        dr[2] = DateTime.FromOADate(Int32.Parse(item.NumericCellValue.ToString())).ToString("yyyy-MM-dd");
                                    }
                                    else
                                    {
                                        dr[2] = item.NumericCellValue;
                                    }
                                    break;
                                case CellType.String:
                                    string strValue = item.StringCellValue;
                                    if (!string.IsNullOrEmpty(strValue))
                                    {
                                        if ((strValue != "NA") && (strValue != "N/A"))
                                        { dr[2] = strValue.ToString().Replace(",", "").Replace("\n", "").ToString(); }
                                        else
                                        { dr[2] = null; }
                                    }
                                    else
                                    {
                                        dr[2] = null;
                                    }
                                    break;
                                case CellType.Unknown:
                                case CellType.Blank:
                                default:
                                    dr[2] = string.Empty;
                                    break;
                            }

                            dt.Rows.Add(dr);
                        }
                    }

                }

            }
        }

        return dt;
    }

    public void CreateCSVfile(DataTable dtable, string strFilePath)
    {
        StreamWriter sw = new StreamWriter(strFilePath, false);
        int icolcount = dtable.Columns.Count;
        foreach (DataRow drow in dtable.Rows)
        {
            for (int i = 0; i < icolcount; i++)
            {
                if (!Convert.IsDBNull(drow[i]))
                {
                    sw.Write(drow[i].ToString());
                }
                if (i < icolcount - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);
        }
        sw.Close();
        sw.Dispose();
    }


    //private string fileName = "z100.xlsx"; //文件名
    private IWorkbook workbook = null;
    private FileStream fs = null;
    private bool disposed;



    /// <summary>
    /// 将DataTable数据导入到excel中
    /// </summary>
    /// <param name="data">要导入的数据</param>
    /// <param name="isColumnWritten">DataTable的列名是否要导入</param>
    /// <param name="sheetName">要导入的excel的sheet的名称</param>
    /// <returns>导入数据行数(包含列名那一行)</returns>
    public int DataTableToExcel(DataTable data, string sheetName, bool isColumnWritten, string fileName)
    {
        int i = 0;
        int j = 0;
        int count = 0;
        ISheet sheet = null;

        fs = new FileStream(fileName, FileMode.OpenOrCreate, FileAccess.ReadWrite);
        if (fileName.IndexOf(".xlsx") > 0) // 2007版本
            workbook = new XSSFWorkbook();
        else if (fileName.IndexOf(".xls") > 0) // 2003版本
            workbook = new HSSFWorkbook();

        try
        {
            if (workbook != null)
            {
                sheet = workbook.CreateSheet(sheetName);
            }
            else
            {
                return -1;
            }

            if (isColumnWritten == true) //写入DataTable的列名
            {
                IRow row = sheet.CreateRow(0);
                for (j = 0; j < data.Columns.Count; ++j)
                {
                    row.CreateCell(j).SetCellValue(data.Columns[j].ColumnName);
                }
                count = 1;
            }
            else
            {
                count = 0;
            }

            for (i = 0; i < data.Rows.Count; ++i)
            {
                IRow row = sheet.CreateRow(count);
                for (j = 0; j < data.Columns.Count; ++j)
                {
                    row.CreateCell(j).SetCellValue(data.Rows[i][j].ToString());
                }
                ++count;
            }
            workbook.Write(fs); //写入到excel
            return count;
        }
        catch (Exception ex)
        {
            Console.WriteLine("Exception: " + ex.Message);
            return -1;
        }
    }

    /// <summary>
    /// 将多个DataTable数据导入到excel的各个sheet中
    /// </summary>
    /// <param name="ds">DataSet</param>
    /// <param name="isColumnWritten">DataTable的列名是否要导入</param>
    /// <param name="fileName">要导入的excel的路径名称</param>
    /// <returns>导入数据行数(包含列名那一行)</returns>
    public int DataTableToExcelall(DataSet ds,  bool isColumnWritten, string fileName)
    {
        int i = 0;
        int j = 0;
        int count = 0;
        ISheet sheet = null; 
        fs = new FileStream(fileName, FileMode.OpenOrCreate, FileAccess.ReadWrite);
        
        if (fileName.IndexOf(".xlsx") > 0) // 2007版本
            workbook = new XSSFWorkbook();
        else if (fileName.IndexOf(".xls") > 0) // 2003版本
            workbook = new HSSFWorkbook();

        try
        {
            for (int k = 0; k < ds.Tables.Count; k++)
            { 
                if (ds.Tables[k] != null)
                {
                    if (workbook != null)
                    {
                        sheet = workbook.CreateSheet(ds.Tables[k].TableName);
                    }
                    else
                    {
                        return -1;
                    }
                    if (isColumnWritten == true) //写入DataTable的列名
                    {
                        IRow row = sheet.CreateRow(0);
                        for (j = 0; j < ds.Tables[k].Columns.Count; ++j)
                        {
                            row.CreateCell(j).SetCellValue(ds.Tables[k].Columns[j].ColumnName);
                        }
                        count = 1;
                    }
                    else
                    {
                        count = 0;
                    }

                    for (i = 0; i < ds.Tables[k].Rows.Count; ++i)
                    {
                        IRow row = sheet.CreateRow(count);
                        for (j = 0; j < ds.Tables[k].Columns.Count; ++j)
                        {
                            row.CreateCell(j).SetCellValue(ds.Tables[k].Rows[i][j].ToString());
                        }
                        ++count;
                    } 
                }
            }
             

            workbook.Write(fs); //写入到excel
            return count;
        }
        catch (Exception ex)
        {
            Console.WriteLine("Exception: " + ex.Message);
            return -1;
        }
    }
     
    public  void dataTableToExcel2(DataTable table, string fileName)
    {
        using (MemoryStream ms = new MemoryStream())
        {
            IWorkbook workbook = null;

            if (fileName.IndexOf(".xlsx") > 0)
                workbook = new XSSFWorkbook();
            else if (fileName.IndexOf(".xls") > 0)
                workbook = new HSSFWorkbook();
            ISheet sheet = workbook.CreateSheet();
            IRow headerRow = sheet.CreateRow(0);

            // handling header.  
            foreach (DataColumn column in table.Columns)
                headerRow.CreateCell(column.Ordinal).SetCellValue(column.Caption);//If Caption not set, returns the ColumnName value  

            // handling value.  
            int rowIndex = 1;
            foreach (DataRow row in table.Rows)
            {
                IRow dataRow = sheet.CreateRow(rowIndex);
                foreach (DataColumn column in table.Columns)
                {
                    dataRow.CreateCell(column.Ordinal).SetCellValue(row[column].ToString());
                }
                rowIndex++;
            }
            workbook.Write(ms);
            ms.Flush();
            using (FileStream fs = new FileStream(fileName, FileMode.Create, FileAccess.Write))
            {
                byte[] data = ms.ToArray();

                fs.Write(data, 0, data.Length);
                fs.Flush();
                data = null;
            }
        }
    }



}