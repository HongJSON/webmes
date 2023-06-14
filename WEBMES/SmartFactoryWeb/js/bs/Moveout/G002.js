var urlG002 = "../../../controller/MoveOut/G002Controller.ashx?";
var loadflag = false;
var clickcount = 0;  //判断点击次数寄存
var closetimer = null;  //延时函数寄存

$(document).ready(function () {
    if (!loadflag) {
        loadflag = true;

        var user = getCookie("Mes3User");
        //alert("333");
        //var user = "Mes3User";
        $('#getInfo').text(user);
        //$('#getInfo').text("O0910002");
        showsmsselect();
        var myDate = new Date();
        var month = (myDate.getMonth() + 1).toString();
        var date = myDate.getDate().toString();
        var hourBe = myDate.getHours();
        var hourEnd = myDate.getHours();
        var minutesBe = myDate.getMinutes();
        var minutesEnd = myDate.getMinutes();
        if (month < 10) {
            month = "0" + month;
        }
        if (date < 10) {
            date = "0" + date;
        }
        if (minutesBe - 21 < 0) {
            minutesBe = minutesBe + 60 - 21;
            if (hourBe - 1 < 0) {
                hourBe = "00";
                minutesBe = "00";
            }
            else {
                hourBe = hourBe - 1;
            }
        }
        else { minutesBe = minutesBe - 21; }
        if (minutesEnd - 20 < 0) {
            minutesEnd = minutesEnd + 60 - 20;
            if (hourEnd - 1 < 0) {
                hourEnd = "00";
                minutesEnd = "00";
            }
            else {
                hourEnd = hourEnd - 1;
            }
        }
        else {
            minutesEnd = minutesEnd - 20;
        }

        if (hourBe < 10) {
            hourBe = "0" + hourBe;
        }
        if (minutesBe < 10) {
            minutesBe = "0" + minutesBe;
        }
        if (hourEnd < 10) {
            hourEnd = "0" + hourEnd;
        }
        if (minutesEnd < 10) {
            minutesEnd = "0" + minutesEnd;
        }

        $("input[name='datetimeStartdate']").val(myDate.getFullYear().toString() + month + date);
        $("input[name='datetimeStarttime']").val(hourBe.toString() + minutesBe.toString());
        $("input[name='datetimeEndDate']").val(myDate.getFullYear().toString() + month + date);
        $("input[name='datetimeEndTime']").val(hourEnd.toString() + minutesEnd.toString());
        LotTmpOperInit();
        LotTmpNgmsgInit();
        GetAD();
        $("#lot").focus();
        $("#formtype").css("display", "none");//修改display属性抄为none
        $("#position").css("display", "none");//修改display属性抄为none
       
        $("#adderrorcode").change(function () {
            var stepid = $("input[name='txtstepid']").val();
            var errorcode = $("#adderrorcode").val();

        });
    }
})

//過賬
function onConfirm() {
    var ngnum = $("#addnum").val();
    if (ngnum != "")
    {
        if (!confirm("不良數量仍有數量未打入臨時表,請確認是否繼續過賬?"))
        {
            return;
        }
    }
    document.getElementById("btnMoveout").style.display = "none";
    var stepid = $("#stepcurrent").val();
    if (stepid == "28PRT") {
        $("#btnMoveout").attr("disabled", "disabled");
        setTimeout(function () {
            $("#btnMoveout").removeAttr("disabled");
        }, 5000);
    }
    BtnMoveOut();
    clickcount++;  //记录点击次数
    //closetimer = window.setTimeout(setout, 100);
    document.getElementById("btnMoveout").style.display = "";
}

function setout() {  //点击执行事件
    if (clickcount > 1)   //如果点击次数超过1
    {
        window.clearTimeout(closetimer);  //清除延时函数
        closetimer = null;  //设置延时寄存为null
        //添加操作代码        
        clickcount = 0;  //重置点击次数为0
    }
    else {  //如果点击次数为1
        BtnMoveOut();
        clickcount = 0;   //重置点击次数为0
    }
};

//LOT回車事件
function onKeyDown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键

        initTable();
        GetErrorCode();
        $("#checklineCG").focus();
    }
}

//不良产品回車事件
function onKeyDownNgnum(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键
        BtnTmpNgMsg();
    }
}


//不良備註回車事件
function onKeyDownNGremark(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键
        addnum.focus();
    }
}

//CG 刷入的回車事件
//function onKeyDownCGLine(event) {
//    var e = event || window.event || arguments.callee.caller.arguments[0];
//    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
//    }
//    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
//    }
//    if (e && e.keyCode == 13) { // enter 键
//        $("#lblcheckcgl").text("");
//        var cg = $("#checklineCG").val();
//        var lot = $("#lot").val();
//        var process = $("#processname").val();
//        var userid = $("#getInfo").text();
//        var orderno = $("#orderno").text();
//        if (cg.toString().length == 0) return;
//        $.ajax({
//            method: "post",
//            url: urlG002 + "funcName=CheckCGLine&lotId=" + lot + "&strCG=" + encodeURIComponent(cg) + "&strProcess=" + process + "&strUser=" + userid + "&orderNo =" + orderno,
//            dataType: "json",
//            success: function (value) {
//                var str = "";
//                for (var i = 0; i < value.length; i++) {
//                    //Show ERR_MSG
//                    if (value[i].ERR_CODE == "Y") {
//                        alert(value[i].ERR_MSG);
//                        $("#checklineCG").val("");
//                        $("#checklineCG").focus();
//                        return;
//                    }
//                    else {
//                        $("#lblcheckcgl").text(value[i].ERR_MSG);
//                    }
//                }
//            }
//        });
//    }
//}



//獲取電腦登入的賬號
function GetAD() {
    $.ajax({
        method: "post",
        url: urlG002 + "funcName=getAD",
        dataType: "json",
        success: function (res) {
            var loginhost;
            for (var i = 0; i < res.length; i++) {
                loginhost = res[i].USER_ID;
                // str += '<option value="' + res[i].LINE_CODE + '">' + res[i].LINE_CODE + '</option>';
            }
            //loginhost = "F2-02_MTP1";
            if (loginhost.toString().length < 6) {
                alert('此电脑非过账用电脑');
                return;
            }

            var var_lineid;
            var step_id;
            var arr = loginhost.split('_');
            if (arr.toString().length > 1) {
                var_lineid = arr[0];
                step_id = arr[1];
            }
	   
            $("input[name='txtlineid']").val(var_lineid);
            $("input[name='txtstepid']").val(step_id);
            $("#addline").val(var_lineid);
        }
    });
}

//頁面初始值設定
function showsmsselect() {

    LineBind();

    //添加change事件，显示料件信息
    $("#addstepm").change(function () {
        EQPBind("null");
        var stepid = $("input[name='txtstepid']").val();
        var codeid = $("input[name='txtproductcode']").val();
        MaterialBind("null");
        //if (stepid != '26PRT') {
        //    if (stepid = 'CGL') {
        //        if (codeid = 'Melon') {
        //            MaterialBind("null");
        //        }
        //    }
        //    else {
        //        MaterialBind("null");
        //    }
        //}
    })
    $("#addline").change(function () { EQPBind("null"); })
    $("#addeqp").change(function () { OperUserBind("null"); })
    $("#addoper").change(function () { OperUserInsert(); });
    $("#addstepmerror").change(function () { GetErrorCode(); });
    $("#adderrorcode").change(function () { ErrorChange(); });
}

function ErrorChange() {
    $("#addnum").focus();
}


//線體編號綁定
function LineBind() {
    var code = $("#addstepm").val();
    var lot = $("#lot").val();
    $.ajax({
        method: "post",
        url: urlG002 + "funcName=getLine&lotId=" + lot + "&Stepmid=" + code + "",
        dataType: "json",
        success: function (res) {
            var str = "";
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].LINE_CODE + '">' + res[i].LINE_CODE + '</option>';
            }
            $("#addline").html(str);
            // $('#addline').selectpicker('refresh');
        }
    });
}

//機台編號綁定
function EQPBind(stepmid) {
    if (stepmid == "null") {
        stepmid = $("#addstepm").val();
    }
    var lineid = $("#addline").val();
    $.ajax({
        method: "post",
        url: urlG002 + "funcName=getEQP&Stepmid=" + stepmid + "&Lineid=" + lineid + "",
        dataType: "json",
        success: function (res) {
            var str = "";
            var str = '<option value=""></option>';
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].EQP_ID + '">' + res[i].EQP_ID + '</option>';
                if (res.length == 1) {
                    OperUserBind(res[i].EQP_ID);
                }
            }
            $("#addeqp").html(str);
            //    $('#addeqp').selectpicker('refresh');
        }
    });
}

//切换小站点
function StepmIdNext(lot, stepid, stepmid) {
    //小站點切換下一個小站點
    $.ajax({
        url: urlG002 + "funcName=getStepmNext&lotId=" + lot + "&Stepid=" + stepid + "&Stepmid=" + stepmid,
        type: "post",
        dataType: "json",
        success: function (result) {
            var h = "";
            $.each(result, function (key, value) {

                $("#addstepm").val(value.STEPM_ID);
                //機台變更為目前的小站点，線體對應的機台
                EQPBind(value.STEPM_ID);
                MaterialBind(value.STEPM_ID);
                OperUserBind("null");
            });

        }
    });addoper
}

//人员信息綁定
function OperUserBind(Eqpid) {
    var stepmid = $("#addstepm").val();
    //var lineid = $("#lineid").val();
    var lineid = $("#lineid").val();
    if (Eqpid == "null") {
        Eqpid = $("#addeqp").val();
    }


    $.ajax({
        method: "post",
        url: urlG002,
        data: { funcName: "getOperUser", eqpId: Eqpid, Stepmid: stepmid, Lineid: lineid },
        dataType: "json",
        success: function (res) {
            var str = '<option value=""></option>';
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].USER_NAME + '">' + res[i].USER_NAME + '</option>';
            }
            $("#addoper").html(str);
            //    $('#addeqp').selectpicker('refresh');
        }
    });
}

//操作人员录入
function OperUserInsert() {
    var oper = $("#addoper").val();
    if ((oper == "null") || (oper.toString().length == 0)) {
        return;
    }
    var lot = $("#lot").val();
    if (lot.toString().length == 0) {
        alert('请先输入LOT号!');
        $("#lot").val("");
        $("#lot").focus();
        return;
    }
    var Eqpid = $("#addeqp").val();
    if ((Eqpid == "null") || (Eqpid.toString().length == 0)) {
        alert('请先选择机台编号!');
        return;
    }
    var stepmid = $("#addstepm").val();
    if ((stepmid == "null") || (stepmid.toString().length == 0)) {
        alert('请先选择小站点!');
        return;
    }
    
   
    var stepid = $("#stepcurrent").val();


    $.ajax({
        method: "post",
        url: urlG002,
        data: { funcName: "OperUserInsert",lotId:lot,eqpId:Eqpid,oper:oper,Stepid:stepid,Stepmid:stepmid },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                //Show ERR_MSG
                if (value[i].ERR_CODE == "Y") {
                    alert(value[i].ERR_MSG);
                    return;
                }
                GridBindOper();
                StepmIdNext(lot, stepid, stepmid);
            }
        }
    });
}

//获取对应站点的不良代码
function GetErrorCode() {
    var stepmid = $("#addstepmerror").val();
    var lot = $("#lot").val();
    var orderno = $("#orderno").val();
    if (lot == "") return;
    //if (stepmid == "") return;
    $.ajax({
        method: "post",
        url: urlG002 + "funcName=getErrorCode&Lotid=" + lot + "&Stepmid=" + stepmid + "&orderNo=" + orderno,
        dataType: "json",
        success: function (res) {
            var str = '<option value=""></option>';
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].CODE_ID + '">' + res[i].CODE_NAME + '</option>';
            }
            $("#adderrorcode").empty();
            $("#adderrorcode").html(str);
            //    $('#addeqp').selectpicker('refresh');
        }
    });

}

//料件维护綁定
function MaterialBind(stepmid) {
    if (stepmid == "null") {
        stepmid = $("#addstepm").val();
    }

    $('#material').attr("class", "form-group hide");
    $('#materials').attr("class", "form-group hide");
    $('#material1').attr("class", "col-sm-4 hide");
    $('#material2').attr("class", "col-sm-4 hide");
    $('#material3').attr("class", "col-sm-4 hide");
    $('#material4').attr("class", "col-sm-4 hide");
    $.ajax({
        method: "post",
        url: urlG002 + "funcName=getMaterial&Stepmid=" + stepmid,
        dataType: "json",
        success: function (res) {
            var str = "";
            for (var i = 0; i < res.length; i++) {
                $('#material').attr("class", "form-group");
                str += res[i].ITEM_TYPE + ',';
                if (i == 0) {
                    $("#materialname1").text(res[i].ITEM_TYPE);
                    $('#material1').attr("class", "col-sm-4");

                }
                if (i == 1) {
                    $("#materialname2").text(res[i].ITEM_TYPE);
                    $('#material2').attr("class", "col-sm-4");

                }
                if (i == 2) {
                    $("#materialname3").text(res[i].ITEM_TYPE);
                    $('#material3').attr("class", "col-sm-4");

                }
                if (i == 3) {
                    $('#materials').attr("class", "form-group");
                    $("#materialname4").text(res[i].ITEM_TYPE);
                    $('#material4').attr("class", "col-sm-4");

                }
            }
        }
    });
}

//料件维护綁定
function MaterialBindOne() {
    var stepid = "TFOG";//获取当前站点
    var lot = $("#lot").val();  //获取当前LOT
    var stepid = $("#stepcurrent").val();

    $('#material').attr("class", "form-group hide");
    $('#materials').attr("class", "form-group hide");
    $('#material1').attr("class", "col-sm-4 hide");
    $('#material2').attr("class", "col-sm-4 hide");
    $('#material3').attr("class", "col-sm-4 hide");
    $('#material4').attr("class", "col-sm-4 hide");
    $.ajax({
        method: "post",
        url: urlG002 + "funcName=getMaterialOne&Lotid=" + lot + "&Stepid=" + stepid,
        dataType: "json",
        success: function (res) {
            var str = "";
            for (var i = 0; i < res.length; i++) {
                $('#material').attr("class", "form-group");
                str += res[i].ITEM_TYPE + ',';
                if (i == 0) {
                    $("#materialname1").text(res[i].ITEM_TYPE);
                    $('#material1').attr("class", "col-sm-4");

                }
                if (i == 1) {
                    $("#materialname2").text(res[i].ITEM_TYPE);
                    $('#material2').attr("class", "col-sm-4");

                }
                if (i == 2) {
                    $("#materialname3").text(res[i].ITEM_TYPE);
                    $('#material3').attr("class", "col-sm-4");

                }
                if (i == 3) {
                    $('#materials').attr("class", "form-group");
                    $("#materialname4").text(res[i].ITEM_TYPE);
                    $('#material4').attr("class", "col-sm-4");

                }
            }
        }
    });
}


////急结工单判断
//function JijieOrder(var_order) {
//    $('#ORDERMSG').attr("class", "form-group hide");
//    jQuery.ajax({
//        url: urlG002 + "funcName=getJijieOrder&orderNo=" + var_order,
//        type: "post",
//        dataType: "json",
//        success: function (value) {
//            var obj = [];
//            for (var i = 0; i < value.length; i++) {
//                $('#ORDERMSG').attr("class", "form-group");
//            }
//        }
//    });
//}

//lot回車事件
function initTable() {
    var lot = $("#lot").val();
    var stepcurrent = $("#stepcurrent").val();
    jQuery.ajax({
        url: urlG002 + "funcName=getLotInformation&lotId=" + lot,
        type: "post",
        dataType: "json",
        // data: mytest,
        success: function (value) {
            var obj = [];
            for (var i = 0; i < value.length; i++) {
                //Show ERR_MSG
                if (value[i].ERR_CODE == "Y") {
                    alert(value[i].ERR_MSG);
                    $("#lot").val("");
                    $("#lot").focus();
                    return;
                }

                ////急结工单判断
                //JijieOrder(value[i].ORDER_NO);

                //if (value[i].ORDER_NO == '000035213429' && value[i].STEP_CURRENT == 'AP2M') {
                //    alert('此批号对应工单为镭射验证品，请联系物料670120');
                //    $("#lot").val("");
                //    $("#lot").focus();
                //    return;
                //}
                //if (value[i].ORDER_NO == '000035223989' && value[i].STEP_CURRENT == 'MTP1') {
                //    alert('此批号对应工单为镭射验证品，请联系物料670120');
                //    $("#lot").val("");
                //    $("#lot").focus();
                //    return;
                //}



                //当前站点判断
                var lotstepcurrent = value[i].STEP_CURRENT;
                if (lotstepcurrent != stepcurrent) {
                    alert('此批在<' + lotstepcurrent + '>站,不可在<' + stepcurrent + '>站作业!');
                    $("#lot").val("");
                    $("#lot").focus();
                    return;
                }
                //LOT状态判断
                var status = value[i].LOT_STATUS;
                if (status == "A") {
                    alert('此批未下线!');
                    $("#lot").val("");
                    $("#lot").focus();
                    return;
                }
                if (status == "U") {
                    alert('此批产品已經取消產線作業!');
                    $("#lot").val("");
                    $("#lot").focus();
                    return;
                }
                if (status != "W" && status != "C" && status != "A") {
                    alert('此批产品状态不正常!');
                    $("#lot").val("");
                    $("#lot").focus();
                    return;
                }
                var str_loginhost = $("#lineid").val() + '_' + $("#stepcurrent").val();
                if ((value[i].IS_LOCK == "Y") && (str_loginhost != value[i].LOCK_CPU)) {
                    alert('此批已被' + value[i].LOCK_CPU + '锁定!');
                    $("#lot").val("");
                    $("#lot").focus();
                    return;
                }
                //目前状态赋值
                if (status == "C") {
                    $("#lotstatus").val("待過帳");
                }
                else if (status == "W") {
                    $("#lotstatus").val("正常");
                }
                else if (status == "S") {
                    $("#lotstatus").val("維修報廢");
                }
                else if (status == "L") {
                    $("#lotstatus").val("制損報廢");
                }
                else if (status == "R") {
                    $("#lotstatus").val("原材報廢");
                }
                else if (status == "F") {
                    $("#lotstatus").val("完工待包裝");
                }
                //下线日期赋值
                $("#lotstartdate").val(value[i].REALWORK_DATE);
                //预交日期赋值
                $("#realdate").val(value[i].DUE_DATE);
                //机种类别赋值
                $("#codeid").val(value[i].MO_TYPE);
                //工单号赋值
                $("#orderno").val(value[i].ORDER_NO);
                //机种赋值
                $("#productid").val(value[i].PRODUCT_ID);
                //流程赋值
                $("#processname").val(value[i].PROCESS_NAME);
                //当前数量赋值
                $("#lotqty").val(value[i].LOT_QTY);

                //针对无change事件，显示料件信息，主要看此大战对应小站是否只有一项
                MaterialBindOne();

                GridBindOper();
                GridBindNgmsg();
                if (stepcurrent == "CGL") {
                    $('#myModal').modal('show');
                    $("#checklineCG").focus();
                }
            }
        }
    });
    var firststepm = "NA";
    //填充小站点信息
    jQuery.ajax({
        url: "../../../controller/MoveOut/G002Controller.ashx",
        data: { funcName: "getStepm", lotId: lot, Stepid: stepcurrent },
        type: "post",
        dataType: "json",
        success: function (result) {
            var h = "";
            $.each(result, function (key, value) {
                if (firststepm == "NA") {
                    firststepm = value.STEPM_ID;
                }
                h += "<option value='" + value.STEPM_ID + "'>" + value.STEP_DESC //下拉框序言的循环数据
                + "</option>";
            });

            $("#addstepm").empty();
            $("#addstepm").append(h);//append 添加进去并展示  
            $("#addstepm").on(
                    "change",
                    function (a, b, c) {
                        $("#contentID").val(
                                $("#addrole option:selected").val());

                        $("#contentName").val(
                                $("#addrole option:selected").text());

                    });
            $("#addstepmerror").empty();
            $("#addstepmerror").append(h);//append 添加进去并展示  

            EQPBind(firststepm);
        }
        //,
        //error: function (jqXHR, textStatus, errorThrown) {
        //    /*弹出jqXHR对象的信息*/
        //    alert(jqXHR.responseText);
        //    alert(jqXHR.status);
        //    alert(jqXHR.readyState);
        //    alert(jqXHR.statusText);
        //    /*弹出其他两个参数的信息*/
        //    alert(textStatus);
        //    alert(errorThrown);
        //}
    });
}

/*初始化Grid*/
function GridBindOper() {
    var lot = $("input[name='txtlot']").val();
    var stepid = $("input[name='txtstepid']").val();
    $("#jqGridLotTmpOper").jqGrid('clearGridData');  //清空表格
    $("#jqGridLotTmpOper").jqGrid('setGridParam', {  // 重新加载数据
        url: urlG002 + "funcName=tableOperMsg&lotId=" + lot + "&stepId=" + stepid,
        datatype: "json",//请求数据返回的类型。可选json,xml,txt
        page: 1
    }).trigger("reloadGrid");

}

/*初始化Grid*/
function GridBindNgmsg() {
    var lot = $("input[name='txtlot']").val();
    var stepid = $("input[name='txtstepid']").val();
    $("#jqGridLotTmpNgmsg").jqGrid('clearGridData');  //清空表格
    $("#jqGridLotTmpNgmsg").jqGrid('setGridParam', {  // 重新加载数据
        url: urlG002 + "funcName=tableNgmsg&lotId=" + lot + "&stepId=" + stepid,
        datatype: "json",//请求数据返回的类型。可选json,xml,txt
        page: 1
    }).trigger("reloadGrid");
}

/*不良信息录入*/
function BtnTmpNgMsg() {
    var lot = $("#lot").val();
    var stepcurrent = $("#stepcurrent").val();
    var stepmid = $("#addstepmerror").val();
    var errorcode = $("#adderrorcode").val();
    var ngnum = $("#addnum").val();
  
    if (ngnum == "") {
        return;
    }
    if (lot == "") {
        alert('请先刷入批号!');
        $("#addnum").val() = "";
        return;
    }
    if (stepcurrent == "") { return; }
    if (stepmid == "") {
        alert('请先选择打不良的小站点!');
        return;
    }
    if (errorcode == "") {
        alert('请先选择打不良的不良代码!');
        return;
    }
    

    errorcode = errorcode.toString().toUpperCase();

    var varremark = $("#addremark").val();
    if (varremark != "") { varremark = varremark.toString().toUpperCase(); }
    var userid = $("#getInfo").text();
    jQuery.ajax({
        url: urlG002 + "funcName=NgmsgInsert&lotId=" + lot + "&Stepid=" + stepcurrent + "&Stepmid=" + stepmid + "&Ngnum=" + ngnum + "&Errorcode=" + errorcode + "&strRemark=" + varremark + "&strUser=" + userid,
        type: "post",
        dataType: "json",
        // data: mytest,
        success: function (value) {
            var obj = [];
            //Show ERR_MSG
            if (value[0].ERR_CODE == "Y") {
                alert(value[0].ERR_MSG);
                //$("#addremark").val("");
                $("#addnum").val("");
                $("#addnum").focus();
                return;
            }
            else {
                //$("#addremark").val("");
                $("#addnum").val("");
                $("#addnum").focus();
                GridBindNgmsg();
            }
        }
    });
}

/*创建LotTmpOper*/
function LotTmpOperInit() {
    //创建jqGrid组件$("input[name='addtimein']")
    var lot = $("input[name='txtlot']").val();

    jQuery("#jqGridLotTmpOper").jqGrid(
			{
			    url: urlG002 + "funcName=tableOperMsg&lotId=" + lot,
			    datatype: "json",//请求数据返回的类型。可选json,xml,txt
			    colNames: ['小站点', '机台编号', '操作者', '操作'],//jqGrid的列显示名字
			    colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
				             { name: 'STEPM_ID', index: 'STEPM_ID', width: 150 },
				             { name: 'EQP_ID', index: 'EQP_ID', width: 180 },
				             { name: 'OUSER', index: 'OUSER', width: 170 },
				             {
				                 label: '删除', name: '', index: 'operate', width: 50, align: 'center',
				                 formatter: function (cellvalue, options, rowObject) {
				                     var detail = "<img  onclick='btn_delTmpOper(\"" + rowObject.STEPM_ID + "\",\"" + rowObject.EQP_ID + "\",\"" + rowObject.OUSER + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
				                     return detail;
				                 },
				             }
			    ],
			    rowNum: 10,//一页显示多少条
			    rownumbers: true,  //显示行号
			    rowList: [10, 20, 30],//可供用户选择一页显示多少条
			    pager: '#jqGridPagerLotTmpOper',//表格页脚的占位符(一般是div)的id
			    sortname: 'STEPM_ID',//初始化的时候排序的字段
			    sortorder: "desc",//排序方式,可选desc,asc
			    mtype: "post",//向后台请求数据的ajax的类型。可选post,get
			    viewrecords: true,
			    caption: "此LOT已维护操作人员列表"//表格的标题名字
			});
    /*创建jqGrid的操作按钮容器*/
    /*可以控制界面上增删改查的按钮是否显示*/
    jQuery("#jqGridLotTmpOper").jqGrid('navGrid', '#jqGridPagerLotTmpOper', { edit: false, add: false, del: false });

}

/*LotTmpOper的删除动作*/
function btn_delTmpOper(stepmid, eqpid, ouser) {
    var lot = $("input[name='txtlot']").val();
    if ((stepmid == "") || (eqpid == "") || (ouser == ""))
        return;
    $.ajax({
        method: "post",
        url: urlG002,
        data: { funcName: "delTmpOper",lotId:lot,Stepmid:stepmid,eqpId:eqpid,ouser:ouser },
        dataType: "json",
        success: function (res) {
            $(jqGridLotTmpOper).jqGrid().trigger("reloadGrid");
        }
    });
}

/*创建LotTmpNgMsg*/
function LotTmpNgmsgInit() {
    //创建jqGrid组件
    jQuery("#jqGridLotTmpNgmsg").jqGrid(
			{
			    url: urlG002 + "funcName=tableNgmsg&lotId=D3W24770801-0181.002",
			    datatype: "json",//请求数据返回的类型。可选json,xml,txt
			    colNames: ['小站点', '不良代码', '不良数量', '操作'],//jqGrid的列显示名字
			    colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
				             { name: 'STEPM_ID', index: 'STEPM_ID', width: 150 },
				             { name: 'ERROR_CODE', index: 'ERROR_CODE', width: 260 },
                             { name: 'NGQTY', index: 'NGQTY', width: 80 },
				             {
				                 label: '删除', name: '', index: 'operate', width: 60, align: 'center',
				                 formatter: function (cellvalue, options, rowObject) {
				                     var detail = "<img  onclick='btn_delTmpNgMsg(\"" + rowObject.STEPM_ID + "\",\"" + rowObject.ERROR_CODE + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
				                     return detail;
				                 },
				             }
			    ],
			    rowNum: 10,//一页显示多少条
			    rowList: [10, 20, 30, 100, 150],//可供用户选择一页显示多少条
			    rownumbers: true,  //显示行号
			    pager: '#jqGridPagerLotTmpNgmsg',//表格页脚的占位符(一般是div)的id
			    sortname: 'STEPM_ID',//初始化的时候排序的字段
			    sortorder: "desc",//排序方式,可选desc,asc
			    mtype: "post",//向后台请求数据的ajax的类型。可选post,get
			    viewrecords: true,
			    caption: "此LOT已维护不良信息列表"//表格的标题名字
			});
    /*创建jqGrid的操作按钮容器*/
    /*可以控制界面上增删改查的按钮是否显示*/
    jQuery("#jqGridLotTmpNgmsg").jqGrid('navGrid', '#jqGridPagerLotTmpNgmsg', { edit: false, add: false, del: false });
}

/*LotTmpNgMsg的删除动作*/
function btn_delTmpNgMsg(stepmid, errorcode) {
    if ((stepmid == "") || (errorcode == ""))
        return;
    var lot = $("input[name='txtlot']").val();
    $.ajax({
        method: "post",
        url: urlG002 + "funcName=delTmpNgmsg&lotId=" + lot + "&Stepmid=" + stepmid + "&Errorcode=" +errorcode,
        dataType: "json",
        success: function (res) {
            //LotTmpNgmsgInit();
            $(jqGridLotTmpNgmsg).jqGrid().trigger("reloadGrid");
        }
    });
}

/*过账按钮动作*/
function BtnMoveOut() {
    var lot = $("#lot").val();
    var stepcurrent = $("#stepcurrent").val();
    var codeid = $("input[name='txtproductcode']").val();
    var orderno = $("#orderno").val();
    if (lot == "") {
        alert('请先刷入批号!');
        $("#lot").focus();
        return;
    }
    var userid = $("#getInfo").text();
    jQuery.ajax({
        url: urlG002 + "funcName=BtnMoveout&lotId=" + lot + "&Stepid=" + stepcurrent + "&strUser=" + userid + "&codeId=" + codeid + "&orderNo=" + orderno,
        type: "post",
        async: false,
        dataType: "json",
        // data: mytest,
        success: function (value) {
            var obj = [];
            for (var i = 0; i < value.length; i++) {
                //Show ERR_MSG
                if (value[i].ERR_CODE == "Y") {
                    alert(value[i].ERR_MSG);
                    return;
                }
            }
            $("#lot").val("");
            $("#lotqty").val("");
            $("#lotstatus").val("");
            $("#lotstartdate").val("");
            $("#orderno").val("");
            $("#realdate").val("");
            $("#productid").val("");
            $("#codeid").val("");
            $("#processname").val("");

            GridBindOper();
            GridBindNgmsg();
            alert('过账成功!');
            $("#lot").focus();
        }
    });

}