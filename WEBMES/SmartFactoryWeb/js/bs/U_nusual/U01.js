var URLU01 = "../../../controller/U_nusual/U01Controller.ashx";
$(document).ready(function () {
    $("#lotid").focus();
    var user = getCookie("Mes3User");
    $('#user').text(user);
    getip();
    if ($("#pageid").val() != "") {
        show();
        $("#showpage").text($("#pageid").val());
    }
    $('#status').val("0");
})

function pagechange() {
    if ($("#pageid").val() != "") {
        getpage();
        $("#showpage").text($("#pageid").val());
        $('#status').val("0");
        $("#lotid").focus();
    }
}

function getpage() {
    var pageid = $("#pageid").val();
    var IP = $("#IPADDR").text();
    $.ajax({
        async: false,
        method: "post",
        url: URLU01,
        data: { pageid: pageid, ip: IP, funcName: 'getpage' },
        dataType: "json",
        success: function (res) {
            if (res[0].LOTID != "NA") {
                $('#lotid').val(res[0].LOTID);
            }
            else {
                $('#lotid').val('');
            }
            show();
            getqtyy();
        }
    });
}

function getip() {
    $.ajax({
        method: "post",
        url: URLU01,
        data: { lotnum: '', type: '', user: '', funcName: 'getip' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                $("#IPADDR").text(value[0].IP);
            }
        }
    });
}

function getqtyy() {
    var IP = $("#IPADDR").text();
    var pageid = $("#pageid").val();
    var USER = $("#user").text();
    {
        $.ajax({
            method: "post",
            url: URLU01,
            data: { user: USER, pageid: pageid, ip: IP, funcName: 'getqtyy' },
            dataType: "json",
            success: function (value) {
                if (value[0].FLAG == "N") {
                    $('#status').val(value[0].QTYY);

                }
            }
        });

    }
}

function getlotnum() {
    var lotid = $("#lotid").val();
    $.ajax({
        method: "post",
        url: URLU01,
        data: { lotid: lotid, funcName: 'getlotnum' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                alert(value[0].MSG);
                $("#Label6").text(value[0].MSG);
            }
            if (value[0].FLAG == "Y") {
                show();
                $('#NUM1').val(value[0].LOTQTY);
                $('#step').val(value[0].STEP);
                $('#mo').text(value[0].MO);
                $("#lotnum").focus();
                $('#Label6').val("");
            }
        }
    });
}


function keylotin(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情
    }
    if (e && e.keyCode == 13) { // enter 键 
        getlotnum();
    }
}

function keylottmpin(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情
    }
    if (e && e.keyCode == 13) { // enter 键 
        keylottmp();
    }
}

function keylottmp() {
    var IP = $("#IPADDR").text();
    var pageid = $("#pageid").val();
    var lotid = $("#lotid").val();
    var USER = $("#user").text();
    var lotnum = $("#lotnum").val();
    $.ajax({
        method: "post",
        url: URLU01,
        data: { lotnum: lotnum, lotid: lotid, user: USER, ip: IP, pageid: pageid, funcName: 'keylottmp' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                alert(value[0].MSG);
                var audiong = document.getElementById('musicng');
                if (musicng.paused) {
                    musicng.currentTime = 0;
                    musicng.play();
                }
                $("#Label6").text(value[0].MSG);
                $('#lotnum').val("");
            }
            if (value[0].FLAG == "Y") {
                show();
                getqtyy();
                $('#lotnum').val("");
                $('#Label6').val("");
            }
        }
    });
}

function show() {
    var IP = $("#IPADDR").text();
    var lotid = $("#lotid").val();
    var pageid = $("#pageid").val();
    jQuery("#jqGridU01").GridUnload();
    jQuery("#jqGridU01").jqGrid(
		{
		    url: URLU01 + "?funcName=show&ip=" + IP + "&lotid=" + lotid + "&pageid=" + pageid,
		    datatype: 'json',
		    colNames: ['Lot_Id', 'LOTNUM', 'Modify_User', 'Modify_Time', 'Arraylot', '刪除'],
		    colModel: [
			            { name: 'LOT_ID', index: 'LOT_ID', width: 120 },
		                { name: 'LOTNUM', index: 'LOTNUM', width: 250 },
                        { name: 'CREATE_USER', index: 'CREATE_USER', width: 100, align: 'center' },
                        { name: 'CREATE_TIME', index: 'CREATE_TIME', width: 150 },
                        { name: 'ARRAYLOT', index: 'ARRAYLOT', width: 100 },
		                {
		                    label: '删除', name: '', index: 'operate', width: 50, align: 'center',
		                    formatter: function (cellvalue, options, rowObject) {
		                        var detail = "<img onclick='btn_delsn(\"" + rowObject.LOT_ID + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
		                        return detail;
		                    },
		                }
		    ],
		    rowNum: 10,
		    rownumbers: true,
		    rowList: [10, 20, 30],
		    pager: '#jqGridPagerU01',
		    sortname: 'CREATE_TIME',
		    sortorder: "desc",
		    mtype: "post",
		    viewrecords: true,
		    caption: "拆批列表",
		    loadonce: true
		});
    jQuery("#jqGridU01").jqGrid('navGrid', '#jqGridPagerU01', { edit: false, add: false, del: false });
    jQuery("#jqGridU01").trigger("reloadGrid");
}

function btn_delsn(LOT_ID) {
    var pageid = $("#pageid").val();
    $.ajax({
        method: "post",
        url: URLU01,
        data: { pageid: pageid, lotid: LOT_ID, funcName: 'delete' },
        dataType: 'json',
        success: function (value) {
            if (value[0].FLAG == "Y") {
                show();
                getqtyy();
            }
        }
    });
}

function clearall() {
    var IP = $("#IPADDR").text();
    var pageid = $("#pageid").val();
    var USER = $("#user").text();
    $.ajax({
        method: "post",
        url: URLU01,
        data: { user: USER, pageid: pageid, ip: IP, funcName: 'clearall' },
        dataType: 'json',
        success: function (value) {
            if (value[0].FLAG == "Y") {
                show();
                $('#BRKLOT').val("");
                $('#lotnum').val("");
                $('#lotid').val("");
                $('#status').val("0");
                $('#NUM1').val("");
                $('#step').val("");
                $('#remark').val("");
                $('#Label6').val("");
            }
        }
    });
}

function BRKLotInsert() {
    var pageid = $("#pageid").val();
    var user = $("#user").text();
    var lotid = $("#lotid").val();
    var step = $("#step").val();
    var xz = document.getElementById("rb2");
    $('#STATUS').hide();
    var rb2 = xz.checked;
    $.ajax({
        method: "post",
        url: URLU01,
        data: { pageid: pageid, user: user, lotid: lotid, step: step, rb2: rb2, funcName: 'lotinsert' },
        dataType: 'json',
        success: function (value) {
            if (value[0].FLAG == "N") {
                alert(value[0].MSG);
                $("#Label6").text(value[0].MSG);
                $('#STATUS').show();
                $('#lotnum').val("");
            }
            if (value[0].FLAG == "Y") {
                show();
                getqtyy();
                $('#BRKLOT').val(value[0].MSG);
                $('#STATUS').show();
                $('#lotnum').val("");
                $('#lotid').val("");
                $('#status').val("");
                $('#NUM1').val("");
                $('#step').val("");
                $('#remark').val("");
                $('#Label6').val("");
            }
        }
    });
}

function getselect(id) {
    var Input = document.getElementById(id);
    //var Input = $(id);
    Input.focus();
    Input.select();
}

function printlot() {
    var lotid = $("#BRKLOT").val();
    window.open("../../../report/SLMEScreport.aspx?u=" + lotid + " ");
}