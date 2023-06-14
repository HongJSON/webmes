var urlR07 = "../../../controller/Repair/R07Controller.ashx";
$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    getip();
    getorder();
    show();
})
function getip() {
    $.ajax({
        async: false,
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: { 'funcName': 'getip' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                $("#IPADDR").text(value[i].IP);
            }
        }
    });
}
function orderchange()
{
    getstep();
    getordernum();
    show();
}
function getstep() {
    var order = $("#order").val();
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: { order: order, funcName: 'getstep' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "";
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].STEP_ID + '">' + res[i].STEP_NAME + '</option>';
            }
            $("#Ddl_step").html(str);
        }
    });
}
function getorder() {
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: { funcName: 'getorder' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "";
            str += '<option value="' + '">' + '</option>';
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].ORDER_NO + '">' + res[i].ORDER_NO + '</option>';
            }
            $("#order").html(str);
        }
    });
}
function getordernum() {
    var user = $("#user").text();
    var order = $("#order").val();
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: { order: order,user:user, funcName: 'getordernum' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "";
            for (var i = 0; i < res.length; i++) {
                $("#ORDERNUM").text(res[i].ORDERNUM);
                $("#PRODUCTID").text(res[i].PRODUCTID);
                $("#SHENYU").text(res[i].SHENYU);
                $("#innum").text(res[i].SHUARU);
            }
        }
    });
}
function R07keydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键
        inserttmpbox();
        show();
    }
}
function inserttmpbox() {
    var order = $("#order").val();
    var box = $("#box").val();
    var user = $("#user").text();
    var step = $("#Ddl_step").val();
    if (box == "") {
        alert("箱號不能為空");
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: { order: order, box: box, user: user, step: step,funcName: 'inserttmpbox' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "";
            for (var i = 0; i < res.length; i++) {
                if (res[i].ERR_CODE == "N") {
                    alert(res[i].ERR_MSG);
                }
                else {
                    if (res[i].ERR_CODE == "Y") {
                    }
                }
                getordernum();
                show();
                $("#box").val('');
                $("#box").focus();
            }
        }
    });
}

function show() {
    var user = $("#user").text();
    var order = $("#order").val();
    jQuery("#jqGridR07").GridUnload();
    jQuery("#jqGridR07").jqGrid(
		{
		    url: urlR07 + "?funcName=show&user=" + user,
		    datatype: 'json',
		    colNames: ['料號','工單', '箱號', '數量', '來源站點', '人員', '時間', '刪除'],
		    colModel: [
                        { name: 'PRODUCT_ID', index: 'PRODUCT_ID', width: 100 },
			            { name: 'ORDER_NO', index: 'ORDER_NO', width: 100 },
		                { name: 'BOX_ID', index: 'PRODUCT_CODE', width: 200 },
                        { name: 'REJECTED_QTY', index: 'REASON_CODE', width: 100, align: 'center' },
                        { name: 'STEP_ID', index: 'STEP_ID', width: 80 },
                        { name: 'CREATE_USER', index: 'CREATE_USER', width: 100 },
                        { name: 'CREATE_DATE', index: 'CREATE_DATE', width: 100 },
		                {
		                    label: '删除', name: '', index: 'operate', width: 50, align: 'center',
		                    formatter: function (cellvalue, options, rowObject) {
		                        var detail = "<img onclick='btn_delsn(\"" + rowObject.BOX_ID + "\",\"" + rowObject.REJECTED_QTY + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
		                        return detail;
		                    },
		                }
		    ],
		    height: 190,
		    rowNum: 10,
		    rownumbers: true,
		    rowList: [10, 20, 30],
		    pager: '#jqGridPagerR07',
		    sortname: 'CREATE_DATE',
		    sortorder: "desc",
		    mtype: "post",
		    viewrecords: true,
		    caption: "臨時列表",
		    loadonce: true
		});
    jQuery("#jqGridR07").jqGrid('navGrid', '#jqGridPagerR07', { edit: false, add: false, del: false });
    jQuery("#jqGridR07").trigger("reloadGrid");
}
function btn_delsn(BOX_ID, REJECTED_QTY) {
    var IP = $("#IPADDR").text();
    var user = $("#user").text();
    $.ajax({
        async: false,
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: { BOX_ID: BOX_ID, user: user, REJECTED_QTY: REJECTED_QTY, ip: IP, funcName: 'delete' },
        dataType: 'json',
        success: function (value) {
            if (value[0].ERR_CODE == "Y") {
                show();
                getordernum();
            }
        }
    });
}
function deletetmp() {
    var user = $("#user").text();
    $.ajax({
        async: false,
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: {  user: user, funcName: 'deletetmp' },
        dataType: 'json',
        success: function (value) {
            if (value[0].ERR_CODE == "Y") {
                show();
                $("#innum").text('0');
            }
            if (value[0].ERR_CODE == "N") {
                alert(value[0].ERR_MSG);
            }
        }
    });
}
function insert() {
    var user = $("#user").text();
    var step = $("#Ddl_step").val();
    var SHENYU = $("#SHENYU").text();
    var innum = $("#innum").text();
    $.ajax({
        async: false,
        method: "post",
        url: "../../../controller/Repair/R07Controller.ashx",
        data: {  user: user, step: step,SHENYU:SHENYU,innum:innum, funcName: 'insert' },
        dataType: 'json',
        success: function (res) {
            for (var i = 0; i < res.length; i++) {
                if (res[i].ERR_CODE == "Y") {
                    $("#newlot").val(res[i].ERR_MSG);
                    getordernum();
                    show();
                    alert('下線成功');
                }
                if (res[i].ERR_CODE == "N") {
                    alert(res[0].ERR_MSG);
                }
            }
        }
    });
}
function print()
{
    var lotid = $("#newlot").val();
    //alert("../../../report/creport.aspx?u=" + lotid);
    window.open("../../../report/SLMEScreport.aspx?u=" + lotid + "");
}