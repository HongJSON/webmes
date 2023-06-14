<%@ WebHandler Language="C#" Class="B003Controller" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using DataHelper;
using System.Data.OracleClient;



public class B003Controller : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string rtnValue = string.Empty;
        string user = context.Request["user"];
        string funcName = context.Request["funcName"];
        string tb_product = context.Request["tb_product"];
        string drpprocess = context.Request["drpprocess"];
        switch (funcName)
        {
            case "Gridview1":
                rtnValue = Gridview1(tb_product, drpprocess);
                break;
            case "tb_product_TextChanged":
                rtnValue = tb_product_TextChanged(tb_product);
                break;
            case "add_Click":
                rtnValue = add_Click(tb_product, drpprocess);
                break;
            case "img_delete2_Click":
                rtnValue = img_delete2_Click(tb_product, drpprocess);
                break;
            case "drpprocess_SelectedIndexChanged":
                rtnValue = drpprocess_SelectedIndexChanged( drpprocess);
                break;
            case "getprocess":
                rtnValue = getprocess();
                break;   
                
        }
        context.Response.Write(rtnValue);
    }


    private string Gridview1(string tb_product, string drpprocess)
    {
        string rtn = "";
        string str_product = tb_product.ToUpper();
        string str_process = drpprocess.ToString();
        string user = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        user = user.Replace("CIM\\", "");
        user = user.Replace("WKSCN\\", "");
        string str_sql = @"select process_name,process_id,a1.step_id,step_desc,
           (case when a1.step_bmaterial='N' then '一般站點' when a1.step_bmaterial= 'A' then '維護材料LOT' 
           when a1.step_bmaterial='D' then 'FPC轉碼' when a1.step_bmaterial = 'E' then 'BL轉碼' else ' ' end) step_bmaterial
           from sd_base_process a1,sd_base_step a2 where a1.step_id=a2.step_id and 
           process_name='" + str_process + "' and flag='Y' and workcenter='" + user + "' order by process_id";

        DataTable dt_list = PubClass.getdatatableMES(str_sql);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string tb_product_TextChanged(string tb_product)
    {
        string rtn = "";
        //獲取IP信息
        string str_product = tb_product.ToUpper();
        string tp1  = "select distinct process_name from sd_base_proceproduct where product_id='" + str_product + "' and flag='Y' order by process_name";
        DataTable dt_list = PubClass.getdatatableMES(tp1);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string drpprocess_SelectedIndexChanged(string drpprocess)
    {
        string rtn = "";
        string user = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        user = user.Replace("CIM\\", "");
        user = user.Replace("WKSCN\\", "");
        DataTable dtprocess = PubClass.getdatatableMES("select process_name||':'||process_id||':'||a1.step_id||':'||step_desc process from sd_base_process a1,sd_base_step a2 where a1.step_id=a2.step_id and process_name='" + drpprocess + "' and a2.workcenter='" + user + "'  order by process_id");

        rtn = JsonConvert.SerializeObject(dtprocess);
        return rtn;
    }
    private string getprocess()
    {
        string rtn = "";
        //獲取IP信息

        string tp1 = "select distinct process_name from sd_base_process where flag='Y' order by process_name";
        DataTable dt_list = PubClass.getdatatableMES(tp1);
        rtn = JsonConvert.SerializeObject(dt_list);
        return rtn;
    }
    private string add_Click(string tb_product, string drpprocess)
    {
        string rtn = "";
        string str_product = tb_product.ToUpper();
        string str_process = drpprocess.ToString();
        string user = HttpContext.Current.Request.ServerVariables["AUTH_USER"].ToString().ToUpper();
        user = user.Replace("CIM\\", "");
        user = user.Replace("WKSCN\\", "");
        DataTable dd = PubClass.getdatatableMES("select * from sd_op_cpn where product_id='" + str_product + "'");
        if (dd.Rows.Count == 0)
        {
            
            rtn = "PM未維護機種對應的客戶機種的信息，請聯繫PM！";
            return rtn;
        }
        if (str_process == "")
        {
      
            rtn = "請選擇需關聯的流程！";
            return rtn;
        }
        OracleConnection con = PubClass.dbcon();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();

        try
        {
            //一個機種只能關聯一個流程
            DataTable dtproproduct = PubClass.getdatatableMES("select * from sd_base_proceproduct where product_id='" + str_product + "'");
            if (dtproproduct.Rows.Count > 0)
            {

                rtn = "" + str_product + "機種已關聯" + dtproproduct.Rows[0]["process_name"].ToString() + "流程，請確認！";
                return rtn;
            }
            else
            {
                OracleCommand cmd = new OracleCommand("insert into sd_base_proceproduct (product_id,process_name,create_user) values('" + str_product + "','" + str_process + "','" + user + "')", con);
                cmd.Transaction = ots;
                cmd.ExecuteNonQuery();
                ots.Commit();
                con.Close();
              
              
                rtn = "OK！";
            }
        }
        catch
        {
            ots.Rollback();
            con.Close();
          
            rtn = "關聯機種流程失敗！";
        }
        return rtn;
    }
    private string img_delete2_Click(string tb_product, string drpprocess)
    {
        string rtn = "";
        string str_product = tb_product.ToUpper();
        string str_process = drpprocess.ToString();

        OracleConnection con = PubClass.dbcon();
        OracleTransaction ots;
        con.Open();
        ots = con.BeginTransaction();

        try
        {
            OracleCommand cmd = new OracleCommand("delete from sd_base_proceproduct  where product_id='" + str_product + "' and process_name='" + str_process + "'", con);
            cmd.Transaction = ots;
            cmd.ExecuteNonQuery();
            ots.Commit();
            con.Close();
           
            rtn = "刪除此機種流程成功";
        }
        catch
        {
            ots.Rollback();
            con.Close();
            rtn = "刪除此機種流程失敗";
        }
        return rtn;
    }
    public bool IsReusable {
        get {
            return false;
        }
    }
      

}