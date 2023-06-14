var URLQ02 = "../../../controller/OQC/Q02Controller.ashx";

$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    $("#lotid").focus();
    getip();
    show();
    $("#labnum").text("0");
})

function getip() {
    var user = $('#user').text();
    $.ajax({
        async: false,
        method: "post",
        url: URLQ02,
        data: { user: user, funcName: 'getip' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                $("#IPADDR").text(value[i].IP);
            }
        }
    });
}
function onKeyDownlotid(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情
    }
    if (e && e.keyCode == 13) { // enter 键  
        check();
    }
    if (e && e.keyCode == 9) { // TAB 键  
    }
}
function getlotnum() {
    var lotid = $("#lotid").val();
    $.ajax({
        async: false,
        method: "post",
        url: URLQ02,
        data: { lotid: lotid, funcName: 'getlotnum' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#labnum").text('0');
            }
            else if (value[0].FLAG == "Y") {
                $("#labnum").text(value[0].MSG);
            }
        }
    });
}

function show() {
    var lotid = $("#lotid").val();
    jQuery("#jqGridQ04").GridUnload();
    jQuery("#jqGridQ04").jqGrid(
		{
		    url: URLQ02 + "?funcName=show&lotid=" + lotid,
		    datatype: 'json',
		    colNames: ['ELOT_ID', 'LOT_ID', 'IN_QTY'],
		    colModel: [
			            { name: 'ELOT_ID', index: 'ELOT_ID', width: 150 },
		                { name: 'LOT_ID', index: 'LOT_ID', width: 150 },
                        { name: 'IN_QTY', index: 'IN_QTY', width: 100, align: 'center' },
		    ],
		    height: 230,
		    rowNum: 10,
		    rownumbers: true,
		    rowList: [10, 20, 30],
		    pager: '#jqGridPagerQ04',
		    sortname: 'LOT_ID',
		    sortorder: "desc",
		    mtype: "post",
		    viewrecords: true,
		    caption: "臨時列表",
		    loadonce: true
		});
    jQuery("#jqGridQ04").jqGrid('navGrid', '#jqGridPagerQ04', { edit: false, add: false, del: false });
    jQuery("#jqGridQ04").trigger("reloadGrid");
}

function check() {
    var lotid = $("#lotid").val();
    $.ajax({
        async: false,
        method: "post",
        url: URLQ02,
        data: { lotid: lotid, funcName: 'check' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#labmsg").text(value[0].MSG);
                alert(value[0].MSG);
                $("#lotid").val("");

            }
            else if (value[0].FLAG == "Y") {
                show();
                getlotnum();
                $("#labmsg").text(value[0].MSG);
            }
        }
    });
}

function lotinsert() {
    var lotid = $("#lotid").val();
    var table = document.getElementById("jqGridQ04");
    var rows = table.rows.length - 1;
    if (rows == 0) {
        alert("請先查詢~");
        return;
    }
    $.ajax({
        async: false,
        method: "post",
        url: URLQ02,
        data: { lotid: lotid, funcName: 'check' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#labmsg").text(value[0].MSG);
                alert(value[0].MSG);
                $("#lotid").val("");
            }
            else if (value[0].FLAG == "Y") {
                insert();
            }
        }
    });
}

function insert() {
    var lotid = $("#lotid").val();
    var user = $("#user").text();
    $.ajax({
        async: false,
        method: "post",
        url: URLQ02,
        data: { lotid: lotid, user: user, funcName: 'insert' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#labmsg").text(value[0].MSG);
                alert(value[0].MSG);
                $("#lotid").val("");
            }
            else if (value[0].FLAG == "Y") {
                $("#labmsg").text(value[0].MSG);
                jQuery("#jqGridQ04").html("");
                $("#lotid").val("");
                alert(value[0].MSG);
            }
        }
    });
}

function lottmpdel() {
    var lotid = "";
    $("#labnum").text("0");
    $("#lotid").val("");
    jQuery("#jqGridQ04").GridUnload();
    jQuery("#jqGridQ04").jqGrid(
		{
		    url: URLQ02 + "?funcName=show&lotid=" + lotid,
		    datatype: 'json',
		    colNames: ['ELOT_ID', 'LOT_ID', 'IN_QTY'],
		    colModel: [
			            { name: 'ELOT_ID', index: 'ELOT_ID', width: 150 },
		                { name: 'LOT_ID', index: 'LOT_ID', width: 150 },
                        { name: 'IN_QTY', index: 'IN_QTY', width: 100, align: 'center' },
		    ],
		    height: 230,
		    rowNum: 10,
		    rownumbers: true,
		    rowList: [10, 20, 30],
		    pager: '#jqGridPagerQ04',
		    sortname: 'LOT_ID',
		    sortorder: "desc",
		    mtype: "post",
		    viewrecords: true,
		    caption: "臨時列表",
		    loadonce: true
		});
    jQuery("#jqGridQ04").jqGrid('navGrid', '#jqGridPagerQ04', { edit: false, add: false, del: false });
    jQuery("#jqGridQ04").trigger("reloadGrid");
}