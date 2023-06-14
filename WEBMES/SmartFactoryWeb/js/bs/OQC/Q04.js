var URLQ04 = "../../../controller/OQC/Q04Controller.ashx";
var stepid = $('#stepid').val();

$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    $("#lotid").focus();
    gettime();
    getip();
    getngcodeid();
    ShowNG();
    $("#lotnum").val("0");
})

function changeddl() {
    var ddltype = $("#ddltype").val();
    if (ddltype == "2" || ddltype == "3") {
        document.getElementById("check1").style.display = "block";
    }
    else {
        document.getElementById("check1").style.display = "none";
    }
}

function gettime() {
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
    $("input[name='datetimeEnddate']").val(myDate.getFullYear().toString() + month + date);
    $("input[name='datetimeEndtime']").val(hourEnd.toString() + minutesEnd.toString());
}

function getip() {
    var user = $('#user').text();
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { user: user, funcName: 'getip' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                $("#IPADDR").text(value[i].IP);
            }
        }
    });
}

function getngcodeid() {
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { stepid:stepid,FuncName: 'getngcodeid' },
        dataType: "json",
        success: function (res) {
            var str = "";
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].CODE_ID + '">' + res[i].CODE_NAME + '</option>';
            }
            $("#ngcodeid").html(str);
        }
    })
}

function onKeyDownlot(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键
        checklot();
    }
}

function onKeyDownNgLot(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键
        checkNgLot();
    }
}

function onKeyDownNgtmp(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键
        insertNgtmp();
    }
}

function onKeyDowncheckouser(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键
        checkouser();
    }
}

function checkouser() {
    var ouser = $("#ouser").val();
    var lotid = $("#lotid").val();
    if (lotid == "") {
        alert("lot號不能為空");
        return;
    }
    if (ouser == "") {
        alert("人員不能為空");
        return;
    }
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { ouser: ouser, FuncName: 'checkouser' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                if (value[i].FLAG == "Y") {
                    $("#ouser").val(value[i].MSG);
                }
                else {
                    alert(value[i].MSG);
                    $("#ouser").val("");
                    $("#ouser").focus();
                }
            }
        }
    })
}

function checklot() {
    var lotid = $("#lotid").val();
    var mo_type = "";
    if (lotid == "") {
        alert("lot號不能為空");
        return;
    }
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { lotid: lotid,stepid:stepid, FuncName: 'checklot' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                if (value[i].FLAG == "Y") {
                    mo_type = value[i].mo_type;                   
                    getngNewcodeid(mo_type);
                   // $("#movetype").removeAttr("disabled");
                  //  $("#movetype").val("NA");
                  //  $("#checkOK").css('display', 'none');
                 //   $("#checkNG").css('display', 'none');
                    $("#lotnum").val(value[i].QTY);
                    ShowNG();
                }
                else {
                    alert(value[i].MSG);
                    $("#lotid").val("");
                    $("#lotid").focus();
                }
            }
        }
    })
}

function getngNewcodeid(mo_type) {
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { mo_type: mo_type,stepid:stepid, FuncName: 'getngNewcodeid' },
        dataType: "json",
        success: function (value) {
            var str = "";
            for (var i = 0; i < value.length; i++) {
                str += '<option value="' + value[i].CODE_ID + '">' + value[i].CODE_NAME + '</option>';
            }
            $("#ngcodeid").html(str);
        }
    })
}



function insertNgtmp() {
    var re = /^[0-9]+.?[0-9]*$/;
    var ngnum = $("#ngnum").val();
    var lotid = $("#lotid").val();
    var ngcodeid = $("#ngcodeid").val();
    var var_lotnum = $("#lotnum").val();
    var var_ddltype = $("#ddltype").val();
    var checknum = $("#checknum").val();
    var ngremark = $("#ngremark").val();
    var nglot = $("#ngLot").val();
    var mlotnum = $("#mlotnum").text();
    if (!re.test(ngnum)) {
        alert("不良数量必须为数字");
        $("#ngNum").val("");
        return false;
    }
    if (!re.test(mlotnum)) {
        alert("请输入正确的不良LOT");
        return false;
    }
    if (ngcodeid == "") {
        alert("請選擇不良原因");
        return;
    }
    if (lotid == "" || ngnum == "") {
        alert("lot號或不良数量不能為空");
        return;
    }
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { ngnum: ngnum, lotid: lotid, ngcodeid: ngcodeid, ngremark: ngremark, lotnum: var_lotnum, ddltype: var_ddltype, checknum: checknum,nglot:nglot,mlotnum:mlotnum, FuncName: 'insertNgtmp' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                if (value[i].FLAG == "Y") {
                    ShowNG();
                    $("#ngsn").val("");
                    $("#ngsn").focus();
                }
                else {
                    alert(value[i].MSG);
                    $("#ngsn").val("");
                    $("#ngsn").focus();
                }
            }
        }
    })
}

function Q12del(lot_id, error_code, ngnum) {
    error_code = error_code.toString().split(':');
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { lotid: lot_id, ngcodeid: error_code[0], ngnum: ngnum, FuncName: 'del' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                if (value[i].FLAG == "N") {
                    alert(value[i].MSG);
                }
                ShowNG();
            }
        }
    })
}

function ShowNG() {
    var lotid = $("#lotid").val();
    jQuery("#jqGridQ11").GridUnload();
    jQuery("#jqGridQ11").jqGrid(
		{
		    url: URLQ04 + "?funcName=show&lotid=" + lotid,
		    datatype: 'json',
		    colNames: ['LOT_ID', 'ERROR_CODE','NG_NUM', '刪除'],
		    colModel: [
			            { name: 'LOT_ID', index: 'LOT_ID', width: 200 },		                
                        { name: 'ERROR_CODE', index: 'ERROR_CODE', width: 100, align: 'center' },
                        { name: 'NG_NUM', index: 'NG_NUM', width: 80 },
                        {
                            label: '删除', name: '', index: 'operate', width: 50, align: 'center',
                            formatter: function (cellvalue, options, rowObject) {
                                var detail = "<img  onclick='Q12del(\"" + rowObject.LOT_ID + "\",\"" + rowObject.ERROR_CODE + "\",\"" + rowObject.NG_NUM + "\")' src='../../../img/cal.gif' style='padding:0px 10px'>";
                                return detail;
                            }
                        }
		    ],
		    height: 230,
		    rowNum: 10,
		    rownumbers: true,
		    rowList: [10, 20, 30],
		    pager: '#jqGridPagerQ11',
		    sortname: 'LOT_ID',
		    sortorder: "desc",
		    mtype: "post",
		    viewrecords: true,
		    caption: "臨時列表",
		    loadonce: true
		});
    jQuery("#jqGridQ11").jqGrid('navGrid', '#jqGridPagerQ11', { edit: false, add: false, del: false });
    jQuery("#jqGridQ11").trigger("reloadGrid");
}


function yunshou() {
    //document.getElementById("checkOK").style.display = "none";   
    var lotid = $("#lotid").val();   
    var JigNO = $("#JigNO").val();    
    var var_ouser = $("#ouser").val();
    var var_user = $('#user').text();;
    var var_lotnum = $("#lotnum").val();
    var var_ddltype = $("#ddltype").val();
    var checknum = $("#checknum").val();   
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { checknum: checknum, JigNO: JigNO,lotid: lotid,ouser: var_ouser, user: var_user, ddltype: var_ddltype, lotnum: var_lotnum,stepid:stepid, FuncName: 'checkOK' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                if (value[i].FLAG == "N") {
                    alert(value[i].MSG);
                    return;
                }
                if (value[i].FLAG == "LNG") {
                    alert(value[i].MSG);
                    document.getElementById("LNG").style.display = "block";
                    return;
                }
                if (value[i].FLAG == "Nglot") {
                    alert(value[i].MSG);
                    $("#lotid").val(""); $("#lotid").focus();
                    return;
                }
                if (value[i].FLAG == "Nguser") {
                    alert(value[i].MSG);
                    $("#ouser").val(""); $("#ouser").focus();
                    return;
                }
                if (value[i].FLAG == "checknum") {
                    alert(value[i].MSG);
                    $("#checknum").val(""); $("#checknum").focus();
                    return;
                }
                if (value[i].FLAG == "Y") {
                    alert(value[i].MSG); gettime();
                    $("#lotid").val(""); $("#lotid").focus(); $("#sortreturn").prop("checked", false);
                    $("#sortnum").val("0"); $("#movetype").val("NA"); $("#lotnum").val("0");
                    $("#ouser").val(""); $("#JigNO").val(""); $("#ddltype").val("0"); $("#ngLot").val("");
                    getngcodeid();
                    $("#ngremark").val(""); $("#ngnum").val("");
                    ShowNG();
                    document.getElementById("LNG").style.display = "block";
                    document.getElementById("isnlotnum").style.display = "none";
                    return;
                }

            }
        }
    })
}
function checkNgLot() {
    var lotid = $("#lotid").val();// 大lot号
    var var_nglot = $("#ngLot").val();// 小lot号
    $.ajax({
        async: false,
        method: "post",
        url: URLQ04,
        data: { lotid: lotid, nglot: var_nglot, FuncName: 'checkNgLot' },
        dataType: "json",
        success: function (value) {
            $("#mlotnum").text(value[0].MSG);
            document.getElementById("isnlotnum").style.display = "block";
        }

    })
}
