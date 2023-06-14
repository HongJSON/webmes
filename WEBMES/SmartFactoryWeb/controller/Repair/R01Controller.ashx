<%@ WebHandler Language="C#" Class="R06Controller" %>

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
using MesRepository;
using System.Web.UI.HtmlControls;
using System.Data.OracleClient;
using System.IO;
using System.Collections.Generic;

public class R06Controller : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string rtnValue = "獲取數據失敗";
        string funcName = context.Request["funcName"];
        string Ip = HttpContext.Current.Request.UserHostAddress.ToString();
        string ddl_materialtype = "";
        string ddl_lotType = "";
        string txt_productcode = "";
        string lh_user = "";
        string PRODUCT_CODE = "";
        switch (funcName)
        {
            case "btn_delPro":
                //TODO GetParams
                string lotid1 = context.Request["lotid"];
                string stepm1 = context.Request["stepm"];
                string code = context.Request["code"];
                rtnValue = btn_delPro(lotid1, Ip, stepm1,code);
                break;
            case "Button2_Click":
                //TODO GetParams
                rtnValue = Button2_Click(Ip);
                break;
            case "deleteTmpTable":
                //TODO GetParams
                rtnValue = deleteTmpTable(Ip);
                break;
            case "R06select":
                //TODO GetParams
                rtnValue = R06select(Ip);
                break;
            case "btn_Elot_Click":
                //TODO GetParams
                lh_user = context.Request["lh_user"];
                rtnValue = btn_Elot_Click(Ip, lh_user);
                break;
            case "show":
                //TODO GetParams
                rtnValue = show(Ip);
                break;
            case "lotid_enter":
                //TODO GetParams
                string lotid = context.Request["lotid"];
                string stepm = context.Request["stepm"];
                string item = context.Request["item"];
                rtnValue = lotid_enter(lotid,Ip,stepm,item);
                break;
            case "stepms":
                rtnValue = getStepm();
                break; 
                
                
            case "btnEnter_Click":
                //TODO GetParams
                ddl_materialtype = context.Request["ddl_materialtype"];
                ddl_lotType = context.Request["ddl_lotType"];
                txt_productcode = context.Request["txt_productcode"];
                lh_user = context.Request["lh_user"];
                rtnValue = btnEnter_Click(ddl_materialtype, ddl_lotType, txt_productcode, lh_user,Ip);
                break;
        }
        context.Response.Write(rtnValue);
    }

    //查詢料號和工單
    private string lotid_enter(string lotid,string ip,string stepm,string item) {
        string sql = "select a.order_no,b.product_id,a.reason_code,a.ngqty from SD_OP_BRWINFO a left join SD_OP_WORKORDER b on a.order_no = b.order_no where a.lot_id = '"+lotid+"' and receiveflag = 'N' and stepm_id = '"+stepm+"'";
        DataTable dt = PubClass.getdatatableMES(sql);
        string returnVal = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"已点收或无此LOT号\"}]";
        
        if (dt.Rows.Count > 0) {
            //   
            


            for (int i = 0; i < dt.Rows.Count; i++) {
                string order = dt.Rows[i]["ORDER_NO"] + "";
                string product = dt.Rows[i]["PRODUCT_ID"] + "";
                string reasonCode = dt.Rows[i]["REASON_CODE"] + "";
                string ngqty = dt.Rows[i]["NGQTY"] + "";
                if (i == dt.Rows.Count-1)
                returnVal = "[{\"ERR_CODE\":\"Y\",\"order\":\"" + order + "\",\"product\":\"" + product + "\"}]";
                //添加到临时表
                string sqlAdd = "insert into SD_TMP_BRWRECEIVE values('" + order + "','" + lotid + "','" + stepm + "','" + reasonCode + "','" + item + "','" + ip + "','" + ngqty + "',sysdate,'" + product + "')";
                DataTable dtAdd = PubClass.getdatatableMES(sqlAdd);
            }

            
        }
       
        return returnVal;
    }

    //獲取所有站點
    public string getStepm()
    {
        string sql = "select STEPM_ID from sd_base_stepm";
        DataTable dt = PubClass.getdatatableMES(sql);
        return JsonConvert.SerializeObject(dt);
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    private string deleteTmpTable(string Ip)
    {
        string rtn = "";
        string sqlrjtype = "DELETE FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "'";
         PubClass.getdatatableMES(sqlrjtype);
        rtn = "[{\"ERR_CODE\":\"N\"}]";
        return rtn;
    }
    private string show( string Ip)
    {
        string rtn = "";
        string sqlmo = "SELECT * FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "' ORDER BY CREATEDATE DESC";
        DataTable cpn1 = PubClass.getdatatableMES(sqlmo);
        rtn = JsonConvert.SerializeObject(cpn1);
        return rtn;
    }
    /**
     * 确认点收
     */
    private string btn_Elot_Click(string Ip,string user)
    {
        string rtn = "";
        string SQL222 = "SELECT * FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "'";
        DataTable dtsi1 = PubClass.getdatatableMES(SQL222);
        if(dtsi1.Rows.Count==0)
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表中無產品，不可點收!\"}]";
            return rtn;
        }
        for (int i = 0; i < dtsi1.Rows.Count; i++)
        {
            string lotid = dtsi1.Rows[i]["LOT_ID"]+"";
            string stepmid = dtsi1.Rows[i]["STEPM_ID"]+"";
            string item = dtsi1.Rows[i]["ITEM"] + "";
            string code = dtsi1.Rows[i]["REASON_CODE"] + "";
            string sql = "update SD_OP_BRWINFO set receiveflag = 'Y',item = '" + item + "',receiveuser= '" + user + "',receivedate= sysdate where lot_id = '" + lotid + "' and stepm_id = '" + stepmid + "' and receiveflag='N' and REASON_CODE = '"+code+"'";
            DataTable dt = PubClass.getdatatableMES(sql);


            string sqlsysid = "SELECT SEQ_LOTSYSID.NEXTVAL FROM DUAL";
            DataTable dtsysid = PubClass.getdatatableMES(sqlsysid);
            string sysid = dtsysid.Rows[0][0].ToString();
            string sqlnifiid = "SELECT SEQ_LOTOPERMSG.NEXTVAL FROM DUAL";
            DataTable dtnifiid = PubClass.getdatatableMES(sqlnifiid);
            string nifiid = dtnifiid.Rows[0][0].ToString();

            //select * from sd_op_brwinfo  where lot_id = 'TEST111-0044'
            DataTable brw = PubClass.getdatatableMES("select * from sd_op_brwinfo  where lot_id = '" + lotid + "'");
            //select * from sd_op_workorder where order_no = '000000000001'
            DataTable work = PubClass.getdatatableMES("select * from sd_op_workorder where order_no = '" + brw.Rows[0]["ORDER_NO"].ToString() + "'");
            DataTable type = PubClass.getdatatableMES("select BRW_FLAG from sd_base_motype where motype ='" + work.Rows[0]["MOTYPE"] + "'");

            PubClass.getdatatableMES("INSERT INTO SD_HIS_LOTOPERMSG(LOT_ID, SYSID,STEP_ID, STEPM_ID,EQP_ID,OUSER,  CREATE_USER,IN_QTY,OUT_QTY,   PASSCOUNT ,LINEID, MO, MO_FLAG1, MO_FLAG2, MO_FLAG3, MO_BRWFLAG,NIFIID,LOTSTATUS) VALUES('" + brw.Rows[0]["LOT_ID"] + "','" + sysid + "','" + brw.Rows[0]["STEP_ID"] + "','" + brw.Rows[0]["STEPM_ID"] + "','NULL','" + user + "','" + user + "','" + brw.Rows[0]["NGQTY"] + "','" + brw.Rows[0]["NGQTY"] + "','1','" + brw.Rows[0]["LINE_ID"] + "','" + brw.Rows[0]["ORDER_NO"] + "','" + work.Rows[0]["SITE"] + "', '" + work.Rows[0]["MO_TYPE"] + "', '" + work.Rows[0]["MODESC"] + "', '" + type.Rows[0]["BRW_FLAG"] + "','" + nifiid + "','R')"); 
            
        }
        //刪除臨時表
        string sqlrjtype = "DELETE FROM SD_TMP_BRWRECEIVE WHERE  USER_IP ='" + Ip + "' ";
        PubClass.getdatatableMES(sqlrjtype);


            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"點收完畢\"}]";
        return rtn;
    }
    
    //删除临时表
    private string btn_delPro(string lotid, string Ip,string stepm,string code)
    {
        string rtn = "";
        string sqlrjtype = "DELETE FROM SD_TMP_BRWRECEIVE WHERE LOT_ID ='" + lotid + "' and USER_IP ='" + Ip + "' and STEPM_ID ='" + stepm + "' and REASON_CODE='"+code+"'";
       PubClass.getdatatableMES(sqlrjtype);
        rtn = "[{\"ERR_CODE\":\"Y\"}]";
        return rtn;
    }
    private string Button2_Click(string Ip)
    {
        string rtn = "";
        string sqlrjtype = "DELETE FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "'";
         PubClass.getdatatableMES(sqlrjtype);
        rtn = "[{\"ERR_CODE\":\"N\"}]";
        return rtn;
    }
    private string R06select(string Ip)
    {
        string rtn = "";
        string sqlrjtype = "DELETE FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "'";
         PubClass.getdatatableMES(sqlrjtype);
        rtn = "[{\"ERR_CODE\":\"N\"}]";
        return rtn;
    }
      private string btnEnter_Click(string ddl_materialtype,string ddl_lotType,string txt_productcode,string lh_user,string Ip)
    {
        string rtn = ""; int cnt = 0;string str_MO = "";string chipid = "";
        string strSQL = "SELECT GET_PCS_CHIP('" + txt_productcode + "') FROM DUAL";
        DataTable dtss = PubClass.getdatatableMES(strSQL);
        if (dtss.Rows.Count > 0)
        {
            if (dtss.Rows[0][0].ToString().Length != 11)
            {
                rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"未發現此產品的cell信息，請聯繫IT!\"}]";
                return rtn;
            }
            else
            {
                chipid = dtss.Rows[0][0].ToString();
            }
        }
        else
        {
            rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"未發現此產品的cell信息，請聯繫IT!\"}]";
            return rtn;
        }
        //20170930   B類異常產品  季宏斌
       
        ////卡控刷入工號 非提供工號不可輸入 申請人：朱憶蓉、肖成功  Rorer SL15060114
          string check_user = "SELECT * FROM SD_TMP_ZPS WHERE PRODUCT_CODECELL='" + lh_user + "' AND LOT_ID='BRW_RECEIVE'";
          DataTable dt_check_user = PubClass.getdatatableMES(check_user);
          if(dt_check_user.Rows.Count<1)
          {
              rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"抱歉，你沒有點收權限，詳情請聯繫你們組長!\"}]";
              return rtn;
          }
        ///AS類顯示&CG顏色
          string Label15 = "";
        string checkcgcolor = "SELECT * FROM SD_BASE_CODECOLOR WHERE PRODUCT_ID=(SELECT PRODUCT_ID FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + chipid + "')";
        DataTable dtcgcolor = PubClass.getdatatableMES(checkcgcolor);
          if(dtcgcolor.Rows.Count>0)
          {
               if (dtcgcolor.Rows[0]["color"].ToString().Trim() == "黑")
               {
                   Label15 = "CG顏色：" + dtcgcolor.Rows[0]["color"] + "色";
               }
               else
               {
                    Label15 = "CG顏色：" + dtcgcolor.Rows[0]["color"] + "色";
               }
          }
          else
          {
               Label15 = "此產品所在工單還未維護對應的CG顏色";
          }
          string checkS = "SELECT * FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "'";
          DataTable dtcheckS = PubClass.getdatatableMES(checkS);
          string Label19 = "";
          string strSQL1 = "SELECT A.ORDER_NO,A.ORDER_NO||':'||C.MODESC1,B.MO_TYPE CODE_ID,B.MODESC,B.MOTYPE,B.SITE,B.IS_CLOSED,B.CELL_COME CODE_JB, B.STORAGELOC FROM SD_OP_LOTPRODUCT A,SD_OP_WORKORDER B,SD_BASE_MOTYPE C WHERE A.ORDER_NO=B.ORDER_NO AND B.MOTYPE=C.MOTYPE AND A.PRODUCT_CODECELL='" + chipid + "'";
          DataTable dtorder = PubClass.getdatatableMES(strSQL1);
          if (dtorder.Rows.Count > 0)
          {
              str_MO = dtorder.Rows[0]["ORDER_NO"].ToString();
              if (dtorder.Rows[0]["MOTYPE"].ToString() == "ZPRR" || dtorder.Rows[0]["MOTYPE"].ToString() == "ZPRF" || dtorder.Rows[0]["MOTYPE"].ToString() == "ZPRL" || dtorder.Rows[0]["MOTYPE"].ToString() == "ZPRD")
              {
                  Label19 = "試產工單只可入MB02/MB01";
              }
              else
              {
                   Label19 = "";
              }
               if (dtorder.Rows[0]["MODESC"].ToString() == "PR")
               {
                   rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品為試產工單產品，不可點收!\"}]";
                   return rtn;
               }
               if (dtorder.Rows[0]["MOTYPE"].ToString() == "ZMPD")
               {
                   rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品為拆解工單產品，不可點收!\"}]";
                   return rtn;
               }
               string AB = dtorder.Rows[0]["SITE"].ToString();
               string tborder = dtorder.Rows[0]["ORDER_NO"].ToString();
              ///REPAIRCHECK判斷
               string txtShow = "";
               string str_show = "SELECT REPAIRCHECK('" + chipid + "','R06','" + Ip + "','" + Ip + "','SD_TMP_BRWRECEIVE') FROM DUAL";
               DataTable dt_show = PubClass.getdatatableMES(str_show);
               if (dt_show.Rows[0][0].ToString() != "PASS")
               {
                    if (dt_show.Rows[0][0].ToString().Length > 4)
                    {
                         if (dt_show.Rows[0][0].ToString().Substring(0, 4) == "PASS")   //PASS且顯示在頁面上
                         {
                            txtShow = dt_show.Rows[0][0].ToString();
                         }
                         if (dt_show.Rows[0][0].ToString().Substring(0, 2) == "MI")   //點收提示
                         {
                              txtShow = dt_show.Rows[0][0].ToString();
                         }
                         if (dt_show.Rows[0][0].ToString().Substring(0, 2) == "NG")
                         {
                             rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品為" + dt_show.Rows[0][0].ToString() + "，不可作業!\"}]";
                             return rtn; 
                         }
                    }
               }
              //提示Show--依據工單&依據SN
               
               string str_show1 = "SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 2 AND S_TYPE = 'BRWRECEIVE' AND O_TYPE = 'MO' AND IS_USE = 'Y' AND O_MESSAGE='" + str_MO + @"' UNION ALL
                       SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 2 AND S_TYPE = 'BRWRECEIVE' AND O_TYPE = 'SN' AND IS_USE = 'Y' AND O_MESSAGE='" + chipid + "'";
               DataTable dt_show1 = PubClass.getdatatableMES(str_show1);
               
              if (dt_show1.Rows.Count > 0)
              {
                   txtShow = dt_show.Rows[0]["SHOW_MESSAGE"].ToString();
              }
               //提示Show--依據工單開立時的倉別
              string str_show2 = @"SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 2 AND S_TYPE = 'BRWRECEIVE' AND O_TYPE = 'STORC' AND IS_USE = 'Y' AND O_MESSAGE='" + dtorder.Rows[0]["STORAGELOC"].ToString() + @"'";
              DataTable dt_show2 = PubClass.getdatatableMES(str_show2);
              if (dt_show2.Rows.Count > 0)
              {
                 string  txtShow1 = dt_show.Rows[0]["SHOW_MESSAGE"].ToString();
                  txtShow = txtShow1 + "--" + dt_show.Rows[0]["SHOW_MESSAGE"].ToString();
              }
              //2019-08-14 YW K01 卡控類型('BRWTOSTOLC','BRWPACKSTOLC','ALONESTOLC') 不可R06點收 PFG
             string  str_show3 = @"SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 1 AND S_TYPE in ( 'BRWTOSTOLC','BRWPACKSTOLC','ALONESTOLC' ) AND O_TYPE = 'MO' AND IS_USE = 'Y' AND O_MESSAGE='" + str_MO + @"' 
                        UNION ALL
                        SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 1 AND S_TYPE in ( 'BRWTOSTOLC','BRWPACKSTOLC','ALONESTOLC' ) AND O_TYPE = 'SN' AND IS_USE = 'Y' AND O_MESSAGE='" + chipid + @"'";
             DataTable dt_show3 = PubClass.getdatatableMES(str_show3);
               if (dt_show3.Rows.Count > 0)
               {
                   rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"R06不可點收,只能入MAC5倉,請聯繫YW600862\"}]";
                   return rtn;
               }
              //卡控不可點收--依據工單&依據SN
               string str_show4 = @"SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 1 AND S_TYPE = 'BRWRECEIVE' AND O_TYPE = 'MO' AND IS_USE = 'Y' AND O_MESSAGE='" + str_MO + @"' 
                   UNION ALL SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 1 AND S_TYPE = 'BRWRECEIVE' AND O_TYPE = 'SN' AND IS_USE = 'Y' AND O_MESSAGE='" + chipid + "'";
               DataTable dt_show4 = PubClass.getdatatableMES(str_show4);
               if (dt_show4.Rows.Count > 0)
               {
                   rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"不可點收, " + dt_show.Rows[0]["SHOW_MESSAGE"].ToString() + "'}]";
                   return rtn;
               }
              //卡控不可點收--依據工單開立時的倉別
               string str_show5 = @"SELECT * FROM SD_CHECK_ORDERBIND WHERE L_TYPE = 1 AND S_TYPE = 'BRWRECEIVE' AND O_TYPE = 'STORC' AND IS_USE = 'Y' AND O_MESSAGE='" + dtorder.Rows[0]["STORAGELOC"].ToString() + "'";
               DataTable dt_show5 = PubClass.getdatatableMES(str_show5);
              if(dt_show5.Rows.Count > 0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"不可點收, " + dt_show.Rows[0]["SHOW_MESSAGE"].ToString() + "'}]";
                  return rtn;
              }
              //二次進維修室
              string Label14 = "";
              string sqlsecond = "SELECT STEP_FROM FROM SD_OP_BRWINFO WHERE PRODUCT_CODECELL ='" + chipid + "'";
              DataTable dtsecond = PubClass.getdatatableMES(sqlsecond);
               if (dtsecond.Rows.Count == 2)
               {
                   string sqlsecond1 = "SELECT DISTINCT STEP_FROM FROM SD_OP_BRWINFO WHERE PRODUCT_CODECELL ='" + chipid + "'";
                   DataTable dtsecond1 = PubClass.getdatatableMES(sqlsecond1);
                   if (dtsecond1.Rows.Count == 1)
                   {
                        Label14 = "該產品為同一站點二次打不良";
                   }
                   else
                   {
                        Label14 = "";
                   }
               }
              //急結工單顯示
               string Remaind1 = "";
               str_MO = dtorder.Rows[0]["ORDER_NO"].ToString();
               string sqlO = @"SELECT * FROM SD_OP_ORDERMSG WHERE ORDER_NO='" + str_MO + "' AND FLAG='Y'";
               DataTable dtO = PubClass.getdatatableMES(sqlO);
               if (dtO.Rows.Count > 0)
               {

                    Remaind1 = "此工單為急結工單";
               }
               else
               {
                   Remaind1 = "";
               }
               /// 結案卡控
               if (dtorder.Rows[0]["is_closed"].ToString() == "Y")
               {
                    if (dtorder.Rows[0]["code_id"].ToString() != "F50" && dtorder.Rows[0]["code_id"].ToString() != "F60")
                    {
                        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此工單已結案，不可點收！\"}]";
                        return rtn;
                    }
               }
              ////前後段搭料狀態check
               string status1 = ddl_materialtype;
               string sqlX = "SELECT * FROM SD_OP_WORKORDER WHERE ORDER_NO='" + str_MO + "' AND ID_ORDER LIKE '%1%'";
               DataTable dtX = PubClass.getdatatableMES(sqlX);
               if (dtX.Rows.Count > 0)
               {
                    if (status1 == "COG" || status1 == "T-FLEX" || status1 == "D-FLEX" || status1 == "CGL" || status1 == "成品")
                    {
                        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此工單為前段工單 不可選此狀態！\"}]";
                        return rtn;
                    }
               }
              //获取刷入产品的半品料号
               string txtSap = "";
               
             
              
              
              //卡控產品料號是否一致
               string checlLH = "SELECT DISTINCT PART_ID FROM  SD_TMP_BRWRECEIVE  WHERE  USER_IP='" + Ip + "'";
               DataTable dtCheck4 = PubClass.getdatatableMES(checlLH);
              
              
              
              string celltype = dtorder.Rows[0]["CODE_JB"].ToString();
              string subCode = chipid.Substring(0, 2);
              string strSQL7 = "SELECT CODE_JB FROM SD_BASE_RULE WHERE CODE_ID='" + dtorder.Rows[0]["code_id"].ToString() + "' AND MODESC='" + dtorder.Rows[0]["modesc"].ToString() + "' AND CODE_2='" + subCode + "' AND CODE_JB='" + celltype + "'";
              DataTable dtCellType = PubClass.getdatatableMES(strSQL7);
              if (dtCellType.Rows.Count == 0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品" + chipid + "与工单玻璃类型不同，请确认!\"}]";
                  return rtn; 
              }
              //jay 20140317 pcshold卡控
              string strSQL8 = "SELECT * FROM SD_OP_PCSHOLD WHERE PRODUCT_CODECELL='" + chipid + "' AND FLAG='Y'";
              DataTable dtss1 = PubClass.getdatatableMES(strSQL8);
              if(dtss1.Rows.Count > 0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品被PCS HOLD中，無法點收, Hold原因<" + dtss1.Rows[0]["HOLD_REASON"].ToString() + ">\"}]";
                  return rtn; 
              }
              string tmp = "SELECT PRODUCT_CODE,USER_IP FROM SD_TMP_BRWRECEIVE WHERE PRODUCT_CODECELL='" + chipid + "'";
              DataTable dt2 = PubClass.getdatatableMES(tmp);
              if(dt2.Rows.Count > 0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品已在列表中,刷入的登陸電腦的賬號為" + dt2.Rows[0]["user_ip"].ToString() + "!\"}]";
                  return rtn;  
              }
              //卡控待維修的產品不可再點收
              string sqlcheck1 = "SELECT PRODUCT_STATUS FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + chipid + "'";
              DataTable dtcheck1 = PubClass.getdatatableMES(sqlcheck1);
              if(dtcheck1.Rows.Count == 0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"没有找到此产品" + txt_productcode + "!\"}]";
                  return rtn;  
              }
               if (dtcheck1.Rows[0][0].ToString() == "M" || dtcheck1.Rows[0][0].ToString() == "X")
               {
                   rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"請將此產品" + txt_productcode + "送至物料!\"}]";
                   return rtn;   
               }
              //多次進維修室產品提醒
               string Label13 = "";
               string sqlcheck2 = "SELECT PRODUCT_CODECELL FROM SD_OP_BRWINFO WHERE PRODUCT_CODECELL='" + chipid + "' AND NEWLOT_ID IS NULL";
               DataTable dtcheck2 = PubClass.getdatatableMES(sqlcheck2);
               if (dtcheck2.Rows.Count > 1)
               {
                   Label13 = "此產品為二次不良品";
               }
               string product_code = txt_productcode;
               string sql6 = @"SELECT A.*,A.REASON_CODE||':'||B.CODE_NAME REASON_CODE_NAME,ITEM3 ,REASON_CODE FROM SD_OP_BRWINFO A LEFT JOIN SD_BASE_CODE B ON A.REASON_CODE=B.CODE_ID 
                        WHERE PRODUCT_CODECELL='" + chipid + @"' AND BRW_FLAG='N' ORDER BY CREATE_DATE DESC";
               DataTable dt = PubClass.getdatatableMES(sql6);
               if (dt.Rows.Count == 0)
               {
                   string sqq = "SELECT A.STEP_CURRENT FROM SD_OP_LOTINFO A LEFT JOIN SD_OP_LOTPRODUCT B ON A.LOT_ID=B.LOT_ID WHERE PRODUCT_CODECELL='" + chipid + "'";
                   DataTable dt1 = PubClass.getdatatableMES(sqq);
                   if (dt1.Rows.Count == 0)
                   {
                       rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品不存在!\"}]";
                       return rtn;   
                   }
                   else
                   {
                       string step = dt1.Rows[0][0].ToString();
                       rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品當前所在站為" + step + "站!'\"}]";
                       return rtn;  
                   }
               }
              ///卡控原材報廢不良代碼及點收
               string sql501 = @"SELECT DISTINCT CODE_ID FROM SD_BASE_CODEWITHPRODUCT 
                            WHERE PRODUCT_ID IN(SELECT PRODUCT_ID FROM SD_OP_WORKORDER 
                            WHERE ORDER_NO IN(SELECT ORDER_NO FROM SD_OP_LOTPRODUCT WHERE PRODUCT_CODECELL='" + chipid + "'))";
               DataTable dtcodeid = PubClass.getdatatableMES(sql501);
              if(dtcodeid.Rows.Count > 0)
              {
                  string code_check = "SELECT * FROM SD_BASE_REPAIRCODE WHERE CODE_ID='" + dtcodeid.Rows[0]["code_id"].ToString() + "' AND REASON_CODE='" + dt.Rows[0]["reason_code"].ToString() + "' AND STATUS='" + ddl_materialtype + "'";
                  DataTable dtcodecheck = PubClass.getdatatableMES(code_check);
                  if (dtcodecheck.Rows.Count > 0)
                  {
                      if (dtcodecheck.Rows[0]["BRW_CHECK"].ToString() == "Y")
                      {
                          rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品不良代碼屬於原材報廢!\"}]";
                          return rtn;   
                      }
                  }
                  else
                  {
                      rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品不良代碼類別未維護，請聯繫整合!\"}]";
                      return rtn;  
                  }
              }
              ///卡控AAB工單只可入卡控仓别
              string sqlM15 = "SELECT * FROM  SD_OP_PAORDERBIND WHERE ORDER_NO IN (SELECT ORDER_NO FROM SD_OP_LOTPRODUCT WHERE  PRODUCT_CODECELL='" + chipid + "') AND PA_REMARK='AAB'";
              DataTable dtM15 = PubClass.getdatatableMES(sqlM15);
              if (dtM15.Rows.Count > 0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品為AAB工單產品，只可一鍵打包入" + dtM15.Rows[0]["FLAG"].ToString() + "!\"}]";
                  return rtn;   
              }
              string sqltmpp = "SELECT * FROM SD_OP_WORKORDER WHERE ORDER_NO IN (SELECT DISTINCT ORDER_NO FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "' AND ROWNUM=1)";
              DataTable dttmpp = PubClass.getdatatableMES(sqltmpp);
              if(dttmpp.Rows.Count > 0)
              {
                  //kid 要求變更從卡工單一致改為卡機種一致  7/11 reid
                    if (dt.Rows[0]["product_id"].ToString() != dttmpp.Rows[0]["product_id"].ToString())
                    {
                        rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品的機種為" + dt.Rows[0]["product_id"].ToString() + "，與临时表中产品機種不符,請確認!\"}]";
                        return rtn;   
                    }
              }
              if (dt.Rows[0]["receiveflag"].ToString() == "Y")
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品已經點收!\"}]";
                  return rtn;   
              }
              string order_no = dt.Rows[0]["order_no"].ToString();
              string reason_code = dt.Rows[0]["reason_code_name"].ToString();
              string reasoncode = dt.Rows[0]["reason_code"].ToString();
              string sqlmmgg = "select * from sd_op_lotinfo where lot_id='" + dt.Rows[0]["lot_id"].ToString() + "'";
              DataTable dtmmgg = PubClass.getdatatableMES(sqlmmgg);
              if (dtmmgg.Rows.Count > 0)
              {
                  if (dtmmgg.Rows[0]["lot_status"].ToString() == "H")
                  {
                      rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品來源LOT屬於風險批hold狀態,請確認!\"}]";
                      return rtn;   
                  }
              }
              //20190404 YW 提出不良代码不一致不可以同时刷入
              string sqltmp = "SELECT DISTINCT REASON_CODE FROM SD_TMP_BRWRECEIVE WHERE USER_IP = '" + Ip + "'";
              DataTable dttmp = PubClass.getdatatableMES(sqltmp);
              if (dttmp.Rows.Count > 0)
              {
                  if (reason_code != dttmp.Rows[0][0].ToString())
                  {
                      rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"所刷產品不良代碼與臨時表已刷入產品不一致，不可刷入!\"}]";
                      return rtn;    
                  }
              }
              //不明責他責不良代碼不能自責點收
              string sqltz = "SELECT * FROM SD_OP_REPAIRSTORE WHERE CODE_TYPE IN ('他責','不明責') AND PRODUCT_STATUS='" + ddl_materialtype + "' AND REASON_CODE='" + reasoncode + "' AND PRODUCT_TYPE='" + dtorder.Rows[0]["code_id"].ToString() + "'";
              DataTable dttz = PubClass.getdatatableMES(sqltz);
              if (dttz.Rows.Count > 0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品不良代碼屬於他責或不明責!\"}]";
                  return rtn;  
              }
              /*卡控良品lot和主线正常品 */
              string noSql = "SELECT * FROM SD_OP_REPORTLOT A WHERE A.LOT_ID IN( SELECT LOT_ID FROM SD_HIS_NGMSG WHERE PRODUCT_CODECELL='" + chipid + "' and CREATE_DATE=(SELECT  max(CREATE_DATE ) FROM  SD_HIS_NGMSG  WHERE PRODUCT_CODECELL='" + chipid + "'))";
              DataTable normalDt = PubClass.getdatatableMES(noSql);
              string lotType = ddl_lotType;
              if (normalDt.Rows.Count != 0)
              {
                   if (lotType != "LLOT") //良品lot
                   {
                       rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此产品为良品LOT，請至R56作業!\"}]";
                       return rtn;   
                   }
                       
              }
              else
              {
                   if (lotType != "ZZLOT" && lotType != "BWS" && lotType != "GHH")  // 自责
                   {
                       rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此产品为主线正常品，请选择自责点收/B-S/GHH!\"}]";
                       return rtn;   
                   }
              }
              string dtpcssi1 = "SELECT * FROM SD_HIS_RECHECK WHERE PRODUCT_CODECELL='" + chipid + "' AND ORDER_NO='" + order_no + "'";
              DataTable dtpcssi= PubClass.getdatatableMES(dtpcssi1);
              if (dtpcssi.Rows.Count > 0)
              {
                  string sqlsi = "SELECT * FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "' AND (PRODUCT_CODECELL,ORDER_NO) NOT  IN (SELECT PRODUCT_CODECELL,ORDER_NO FROM SD_HIS_RECHECK WHERE RECEIVE_FLAG='N')";
                  DataTable dtsi = PubClass.getdatatableMES(sqlsi);
                  if (dtsi.Rows.Count > 0)
                  {
                      rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表中有非SI復判品 此產品為SI復判品!\"}]";
                      return rtn;   
                  }
              }
              else
              {
                  string sqlsi = "SELECT * FROM SD_TMP_BRWRECEIVE WHERE USER_IP='" + Ip + "' AND (PRODUCT_CODECELL,ORDER_NO) IN (SELECT PRODUCT_CODECELL,ORDER_NO FROM SD_HIS_RECHECK WHERE RECEIVE_FLAG='N')";
                  DataTable dtsi = PubClass.getdatatableMES(sqlsi);
                  if (dtsi.Rows.Count > 0)
                  {
                      rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"臨時表中有SI復判品 此產品非SI復判品!\"}]";
                      return rtn;  
                  }
              }
              ///維修類型分類
              string item = "";
              string itemtype = "";
              string order_no1 = "";
              string repairtype = "";
              string sql_type = "select order_no ,mo_type from sd_op_workorder where order_no=(select order_no from sd_op_lotproduct where product_codecell='" + chipid + "')";
              DataTable dt_type = PubClass.getdatatableMES(sql_type);
              order_no1 = dt_type.Rows[0]["ORDER_NO"].ToString();
              string sqlbrw = "SELECT * FROM SD_OP_BRWINFO WHERE ORDER_NO='" + order_no1 + "' AND PRODUCT_CODECELL='" + chipid + "'";
              DataTable dtbrw = PubClass.getdatatableMES(sqlbrw);
              string codeid = dt_type.Rows[0]["MO_TYPE"].ToString();
              ////Vicky He 良品Lot不能再次頁面打包只能在R56打包 --YYH
              string strSQL11 = "SELECT * FROM SD_OP_BRWINFO WHERE PRODUCT_CODECELL = '" + chipid + "' AND ORDER_NO =  '" + order_no1 + "' AND BRW_FLAG='N' ";
              DataTable dtBrwinfo = PubClass.getdatatableMES(strSQL11);
              if (dtBrwinfo.Rows.Count == 0)
              {
                  string sql_rj = "select * from sd_op_rejected where  (product_codecell,order_no) in(select product_codecell,order_no from sd_op_lotproduct where product_codecell='" + chipid + "')";
                  DataTable dt_rj = PubClass.getdatatableMES(sql_rj);
                  if (dt_rj.Rows.Count > 0)
                  {
                      rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品已退庫到箱號" + dt.Rows[0]["rejected_id"].ToString() + "!\"}]";
                      return rtn;  
                  }
                  else
                  {
                      rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品已出站!\"}]";
                      return rtn;   
                  }
              }
              if (dtBrwinfo.Rows.Count > 1)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品維修信息異常，請聯繫IT!\"}]";
                  return rtn; 
              }
              string str_LOT = dtBrwinfo.Rows[0]["LOT_ID"].ToString();
              string sql22 = "SELECT * FROM SD_OP_REPORTLOT WHERE LOT_ID = '" + str_LOT + "'";
              DataTable sql221 = PubClass.getdatatableMES(sql22);
              if(sql221.Rows.Count>0)
              {
                  rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"此產品為良品Lot，只能在R56打包，如有疑問請聯繫Vicky He!\"}]";
                  return rtn; 
              }
               if (dtbrw.Rows.Count == 1)
               {
                   string reflag = dtbrw.Rows[0]["RECEIVEFLAG"].ToString();
                   itemtype = dtbrw.Rows[0]["ITEM_TYPE"].ToString();
                   string brwflag = dtbrw.Rows[0]["BRW_FLAG"].ToString();
                   string typeflag = dtbrw.Rows[0]["TYPE_FLAG"].ToString();
                   string retype = dtbrw.Rows[0]["REPAIR_TYPE"].ToString();
                   item = dtbrw.Rows[0]["ITEM3"].ToString();
                   if (brwflag == "Y")
                   {
                       rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"該產品已打包,請確認!!\"}]";
                       return rtn; 
                   }
                        
                }
               else
               {
                   rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"維修信息有誤,請確認!!\"}]";
                   return rtn;  
               }
               if (itemtype == "NEWRECEIVE")
               {
                   reasoncode = dtbrw.Rows[0]["REASON_CODE"].ToString();
               }
              //製造支援工單點收
               if (itemtype == "NEW")
               {
                   item = ddl_materialtype;
                   reasoncode = dtbrw.Rows[0]["REASON_RELINECODE"].ToString();
                   if (reasoncode == "")
                   {
                       string sqlbrwng = @"SELECT A.REASON_CODE FROM SD_HIS_BRWNGMSG A,SD_HIS_BRWLOTPRODUCT B WHERE B.ORDER_NO='" + order_no1 + @"'  
                            AND A.PRODUCT_CODECELL=B.PRODUCT_CODECELL AND A.LOT_ID=B.BLOT_ID AND B.PRODUCT_CODECELL='" + chipid + "'";
                       DataTable dtbrwng = PubClass.getdatatableMES(sqlbrwng);
                       if (dtbrwng.Rows.Count > 0)
                       {
                           reasoncode = dtbrwng.Rows[0][0].ToString();
                       }
                   }
               }
               item = ddl_materialtype;
               string[] re = reasoncode.Split('-');
               string re0 = re[0].ToString();
               string sqlrep = "SELECT * FROM SD_BASE_REPAIRTYPE WHERE CODE_ID='" + codeid + "' AND REASON_CODE='" + re0 + "' AND STATUS='" + item + "' AND FLAG='Y'";
               DataTable dtrep = PubClass.getdatatableMES(sqlrep);
               if (dtrep.Rows.Count == 1)
               {
                   repairtype = dtrep.Rows[0]["TYPE"].ToString();
               }
               else
               {
                   rtn = "[{\"ERR_CODE\":\"Y\",\"ERR_MSG\":\"未維護維修分類,機種:" + codeid + ",不良:" + re0 + ",狀態:" + item + "!!\"}]";
                   return rtn;  
               }
               string str1 = "INSERT INTO SD_TMP_BRWRECEIVE (ORDER_NO,PRODUCT_CODE,BRW_FLAG,USER_IP,CNT,STEP_LAST,REASON_CODE,PRODUCT_CODECELL,REAL_PART_TYPE,PART_ID,LOT_TYPE) VALUES ('" + order_no + "','" + product_code + "','N','" + Ip + "'," + cnt + ",'" + dt.Rows[0]["stepm_id"].ToString() + "','" + reason_code + "','" + chipid + "','" + ddl_materialtype + "','" + txtSap + "','" + lotType + "')";
               PubClass.getdatatableMES(str1);
               string str2 = "INSERT INTO SD_TMP_REPAIRTYPE (PRODUCT_CODECELL,ORDER_NO,REPAIRTYPE,IP_ADDR,CREATE_USER,CREATE_DATE) VALUES('" + chipid + "','" + order_no1 + "','" + repairtype + "','" + Ip + "','',sysdate)";
               PubClass.getdatatableMES(str2);
               rtn = "[{\"ERR_CODE\":\"N\",\"ERR_MSG\":\"success\",\"Label15\":\"" + Label15 + "\",\"Label19\":\"" + Label19 + "\",\"txtShow\":\"" + txtShow + "\",\"Label14\":\"" + Label14 + "\",\"Remaind1\":\"" + Remaind1 + "\",\"txtSap\":\"" + txtSap + "\",\"repairtype\":\"" + repairtype + "\",\"Label13\":\"" + Label13 + "\",\"AB\":\"" + AB + "\",\"celltype\":\"" + celltype + "\",\"tborder\":\"" + tborder + "\"}]";

          }
          return rtn;
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}