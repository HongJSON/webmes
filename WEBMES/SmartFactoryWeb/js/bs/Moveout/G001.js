var urlG001 = "../../../controller/Moveout/G001Controller.ashx";
$(document).ready(function () {
    var xz = document.getElementById("CBLINE");
    var CBLINE = xz.checked;
    $.ajax({
        method: "post",
        url: urlG001,
        data: { CBLINE: CBLINE, funcName: 'getstep' },
        dataType: "json",
        success: function (result) {
            var loginhost;
            for (var i = 0; i < result.length; i++) {
                loginhost = result[i].STEP_ID;
            }
            console.log(loginhost);
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
            $('#lbl1').html(var_lineid);
            $('#DdlStep').html(step_id);
            show();
        }
    })
})
function getstepm() {
    var processname = $("#processname").val();
    var DdlStep = $('#DdlStep').text();
    $.ajax({
        type: 'post',
        url: urlG001,
        data: { step: DdlStep, pname: processname, funcName: 'getstepm' },
        dataType: 'json',
        success: function (result) {
            var str = "<option value=''></option>";
            for (var i = 0; i < result.length; i++) {
                str += "<option value='" + result[i].STEPM_ID + "'>" + result[i].STEPM_NAME + "</option>";
            }
            $('#DdlStepm').html(str);
        }
    })
}
function getEQP() {
    var lineid = $("#lbl1").text();  // 獲取線體
    var DdlStepm = $('#DdlStepm').val();        // 獲取站點
    var xz = document.getElementById("CBLINE");     // 是否跨線體
    var CBLINE = xz.checked;
    $.ajax({
        type: 'post',
        url: urlG001,
        data: { stepm: DdlStepm, line: lineid, CBLINE: CBLINE, funcName: 'geteqp' },
        dataType: 'json',
        success: function (result) {
            if (result[0].EQP_ID == "NOEQP") {
                alert('未維護該線體對應機台信息');
            }
            else {
                var str = "<option value=''></option>";
                for (var i = 0; i < result.length; i++) {
                    str += "<option value='" + result[i].EQP_ID + "'>" + result[i].EQP_ID + "</option>";
                }
                $('#DdlEqp').html(str);
            }
        }
    })
}
function onKeyDown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情
    }
    if (e && e.keyCode == 13) { // enter 键
        getkey();
    }
}
function getkey() {
    var user = $("#TxtUser").val();
    //var lineid = $("#DdlEqp").val().substring(0, 5);
    var lineid = $("#lbl1").text();
    //alert(lineid);
    var DdlStepm = $('#DdlStepm').val();
    var processname = $("#processname").val();
    var DdlStep = $('#DdlStep').text();
    var eqp = $('#DdlEqp').val();
    $.ajax({
        type: "post",
        url: urlG001,
        data: { eqp: eqp, step: DdlStep, pname: processname, stepm: DdlStepm, line: lineid, user: user, funcName: 'getkey' },
        dataType: 'json',
        success: function (result) {
            if (result[0].ERR_CODE == "Y") {
                getnum();
                $("#TxtUser").val("");
                $("#TxtUser").focus();
            }
            else {
                $("#TxtUser").val("");
                $("#TxtUser").focus();
                alert(result[0].ERR_MSG);
            }
        }
    })
}

function getnum() {
    var user = $("#TxtUser").val();
    var DdlStepm = $('#DdlStepm').val();
    var processname = $("#processname").val();
    var DdlStep = $('#DdlStep').text();
    var eqp = $('#DdlEqp').val();
    $.ajax({
        method: "post",
        url: urlG001,
        data: { pname: processname, user: user, funcName: 'getnum' },
        dataType: "json",
        success: function (value) {
            if (value[0].NUM != "0") {
                jQuery("#jqGridG04").GridUnload();
                SHOW();
            }
            else {
                jQuery("#jqGridG04").GridUnload();
            }
        }
    });
}

function SHOW() {
    var user = $("#TxtUser").val();
    var lineid = $("#lbl1").text();
    var DdlStepm = $('#DdlStepm').val();
    var processname = $("#processname").val();
    var DdlStep = $('#DdlStep').text();
    var eqp = $('#DdlEqp').val();
    eqp = eqp.replace(/\%/g, "%25");
    eqp = eqp.replace(/\#/g, "%23");
    eqp = eqp.replace(/\&/g, "%26");
    eqp = eqp.replace(/\ /g, "%20");
    jQuery("#jqGridG04").GridUnload();
    jQuery("#jqGridG04").jqGrid(
		{
		    url: urlG001 + "?funcName=show&eqp=" + eqp + "&step=" + DdlStep + "&pname=" + processname + "&stepm=" + DdlStepm + "&line=" + lineid + "&user=" + user + "",
		    datatype: 'json',
		    colNames: ['小站點', '機台', '操作者', '上線時間', '删除', '上線'],
		    colModel: [
			            { name: 'STEP_ID', index: 'STEP_ID', width: 150 },
		                { name: 'EQP_ID', index: 'EQP_ID', width: 150 },
                        { name: 'USER_ID', index: 'USER_ID', width: 150 },
                        { name: 'ONLINE_TIME', index: 'ONLINE_TIME', width: 150, cellattr: addCellAttr },
		                {
		                    label: '删除', name: '', index: 'operate', width: 50, align: 'center',
		                    formatter: function (cellvalue, options, rowObject) {
		                        var detail = "<img onclick='btn_deluser(\"" + rowObject.STEP_ID + "\",\"" + rowObject.EQP_ID + "\",\"" + rowObject.USER_ID + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
		                        return detail;
		                    },
		                },
		                {
		                    label: '上線', name: '', index: 'operate', width: 50, align: 'center',
		                    formatter: function (cellvalue, options, rowObject) {
		                        var detail = "<img onclick='btn_updateuser(\"" + rowObject.STEP_ID + "\",\"" + rowObject.EQP_ID + "\",\"" + rowObject.USER_ID + "\")'' src='../../../img/hand.gif' style='padding:0px 10px'>";
		                        return detail;
		                    },
		                }
		    ],
		    height: 300,
		    rowNum: 20,
		    rownumbers: true,
		    rowList: [10, 20, 30],
		    pager: '#jqGridPagerG04',
		    sortname: 'ONLINE_TIME',
		    sortorder: "desc",
		    mtype: "post",
		    viewrecords: true,
		    caption: "已上線人員",
		    loadonce: true
		});
    jQuery("#jqGridG04").jqGrid('navGrid', '#jqGridPagerG04', { edit: false, add: false, del: false });
    jQuery("#jqGridG04").trigger("reloadGrid");
}

function addCellAttr(rowId, val, rawObject, cm, rdata) {
    var time = frontOneHour();//2019-04-16 07:59:17   20210327032647
    var time1 = rawObject.ONLINE_TIME.substring(0,4) + rawObject.ONLINE_TIME.substring(5,7) + rawObject.ONLINE_TIME.substring(8,10) + rawObject.ONLINE_TIME.substring(11,13) + rawObject.ONLINE_TIME.substring(14,16) + rawObject.ONLINE_TIME.substring(17,19);
    console.log(time +"--------------"+time1)
    if (time1 < time) {
        return "style='background-color:red'";
    }
}

function btn_deluser(step_id, eqp_id, user_id) {
    $.ajax({
        method: "post",
        url: urlG001,
        data: { eqp: eqp_id, step: step_id, user: user_id, funcName: 'delete' },
        dataType: 'json',
        success: function (value) {
            if (value[0].ERR_CODE == "Y") {
                SHOW();
            }
        }
    });
}

function btn_updateuser(step_id, eqp_id, user_id) {
    $.ajax({
        method: "post",
        url: urlG001,
        data: { eqp: eqp_id, step: step_id, user: user_id, funcName: 'update' },
        dataType: 'json',
        success: function (value) {
            if (value[0].ERR_CODE == "Y") {
                SHOW();
            }
        }
    });
}

function frontOneHour() {
    var check_res;
    $.ajax({
        async: false,
        method: "post",
        url: urlG001,
        data: { funcName: 'getdatatime' },
        dataType: 'json',
        success: function (value) {
            check_res = value[0].TIME;
        }
    });
    return check_res;
}