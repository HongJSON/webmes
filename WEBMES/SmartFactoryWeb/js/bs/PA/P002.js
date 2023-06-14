var URLP002 = "../../../controller/PA/P002Controller.ashx";

$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    //$("#imgcode").JsBarcode('F741-39HJ0001');
    //$("#img1").JsBarcode('F741-39HJ0001');
    $("#boxid").focus();
    getip();
    show();
    getboxnum();
})

function getip() {
    var user = $('#user').text();
    $.ajax({
        async: false,
        method: "post",
        url: URLP002,
        data: { user: user, funcName: 'getip' },
        dataType: "json",
        success: function (value) {
            for (var i = 0; i < value.length; i++) {
                $("#ipaddr").text(value[i].IP);
            }
        }
    });
}
function getboxnum() {
    var boxid = $("#boxid").val();
    var xz = document.getElementById("cbstroc");
    var cbstroc = xz.checked;
    var ddlstroc = $("#ddlstroc").val();
    $.ajax({
        async: false,
        method: "post",
        url: URLP002,
        data: { boxid: boxid, cbstroc: cbstroc, ddlstroc: ddlstroc, funcName: 'getboxnum' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#boxnum").val('0');
            }
            else if (value[0].FLAG == "Y") {
                $("#boxnum").val(value[0].MSG);
            }
        }
    });
}
function keyintmp(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 13) {// enter 键       
        inserttmp();
    }
}

function inserttmp() {
    var boxid = $("#boxid").val();
    if (boxid == "") {
        $("#labmsg").text("箱號不能為空,請確認~");
        return;
    }
    var xz = document.getElementById("cbstroc");
    var cbstroc = xz.checked;
    var ddlstroc = $("#ddlstroc").val();
    $.ajax({
        async: false,
        method: "post",
        url: URLP002,
        data: { boxid: boxid, cbstroc: cbstroc, ddlstroc: ddlstroc, funcName: 'inserttmp' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#labmsg").text(value[0].MSG);
                $("#boxid").val('');
            }
            else if (value[0].FLAG == "Y") {
                $("#labmsg").text(value[0].MSG);
                $("#labsp").text(value[0].STORE_KK);
                show();
                getboxnum();
                $("#boxid").val('');
            }
        }
    });
}

$("#cbstroc").on("change", function () {
    if ($("#cbstroc").is(':checked')) {
        $("#strocdiv").css("display", "block");
    }
    else {
        $("#strocdiv").css("display", "none");
    }
});

function STOREIN() {
    var user = $("#user").text();
    var boxid = $("#boxid").val();
    var xz = document.getElementById("cbstroc");
    var cbstroc = xz.checked;
    var ddlstroc = $("#ddlstroc").val();
    $.ajax({
        async: false,
        method: "post",
        url: URLP002,
        data: { user: user, cbstroc: cbstroc, ddlstroc: ddlstroc, funcName: 'STOREIN' },
        dataType: "json",
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#labmsg").text(value[0].MSG);
                $("#boxid").val('');
            }
            else if (value[0].FLAG == "Y") {
                $("#labmsg").text(value[0].MSG);
                $("#storeid").val(value[0].STOREID);
                show();
                getboxnum();
                $("#boxid").val('');
            }
        }
    });
}

function show() {
    var user = $("#user").text();
    jQuery("#jqGridST").GridUnload();
    jQuery("#jqGridST").jqGrid(
		{
		    url: URLP002 + "?funcName=show&user=" + user + "",
		    datatype: 'json',
		    colNames: ['BOX_ID', 'PRODUCT_ID', 'ORDER_NO', 'QUANTITY', 'STORAGE', '刪除'],
		    colModel: [
			            { name: 'BOX_ID', index: 'BOX_ID', width: '100%' },
		                { name: 'PRODUCT_ID', index: 'PRODUCT_ID', width: '100%' },
                        { name: 'ORDER_NO', index: 'ORDER_NO', width: '100%', align: 'center' },
                        { name: 'QUANTITY', index: 'QUANTITY', width: '100%' },
                        { name: 'STORAGE', index: 'STORAGE', width: '100%' },
		                {
		                    label: '删除', name: '', index: 'operate', width: '100%', align: 'center',
		                    formatter: function (cellvalue, options, rowObject) {
		                        var detail = "<img onclick='btn_deltmpone(\"" + rowObject.BOX_ID + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
		                        return detail;
		                    },
		                }
		    ],
		    height: 250,
		    rowNum: 10,
		    rownumbers: true,
		    rowList: [10, 20, 30],
		    pager: '#jqGridPagerST',
		    sortname: 'BOX_ID',
		    sortorder: "desc",
		    mtype: "post",
		    viewrecords: true,
		    caption: "臨時列表",
		    loadonce: true
		});
    jQuery("#jqGridST").jqGrid('navGrid', '#jqGridPagerST', { edit: false, add: false, del: false });
    jQuery("#jqGridST").trigger("reloadGrid");
}

function btn_deltmpone(boxid) {
    var IP = $("#IPADDR").text();
    var user = $("#user").text();
    $.ajax({
        async: false,
        method: "post",
        url: URLP002,
        data: { boxid: boxid, ip: IP, user: user, funcName: 'deltmpone' },
        dataType: 'json',
        success: function (value) {
            if (value[0].FLAG == "Y") {
                show();
                getboxnum();
            }
        }
    });
}

function deltmpall() {
    var IP = $("#IPADDR").text();
    var user = $("#user").text();
    $.ajax({
        async: false,
        method: "post",
        url: URLP002,
        data: { boxid: '', ip: IP, user: user, funcName: 'deltmpall' },
        dataType: 'json',
        success: function (value) {
            if (value[0].FLAG == "Y") {
                show();
                getboxnum();
            }
        }
    });
}


function PRT() {
    var storeid = $("#storeid").val();
    var user = $("#user").text();
    var IP = $("#IPADDR").text();
    if (storeid == "") {
        $("#labmsg").text("棧板單不能為空,請確認~");
        return;
    }
    var now = new Date();
    var year = now.getFullYear(); //得到年份
    var month = now.getMonth()+1;//得到月份
    var date = now.getDate();//得到日期
    var day = now.getDay();//得到周几
    var hour = now.getHours();//得到小时
    var minu = now.getMinutes();//得到分钟
    var sec = now.getSeconds();//得到秒
    var MS = now.getMilliseconds();//获取毫秒
    var nowdate = year + '/' + month + '/' + date + ' ' + hour + ':' + minu + ':' + sec;
    $("#imgcode").JsBarcode(storeid);
    $("#labrkd").text(storeid);
    $("#labuser").text(user);
    $("#labdate").text(nowdate);
    $.ajax({
        method: "post",
        url: URLP002,
        data: { storeid: storeid, ip: IP, user: user, funcName: 'printstore' },
        dataType: 'json',
        success: function (value) {
            if (value[0].FLAG == "N") {
                $("#labmsg").text(value[0].MSG);
                return;
            }
            else {
                var printhtml = pp(value);
                $('#tb2').html(printhtml);
                print2();
            }
        }
    });
}

function pp(value) {

    var str100p = "style=\"font-size: 20px;width:100px;text-align:center; margin: 0px 0px 0px 20px;\"";
    var str220p = "style=\"font-size: 20px;width:220px;text-align:center; margin: 0px 0px 0px 20px;\"";
    var strcenter = "style=\"font-size: 20px;text-align:center;\"";
    var str = "<tr>";
    str += " <td " + str100p + ">序號</td>";
    str += " <td " + str220p + ">工單</td>";
    str += " <td " + str220p + ">機種</td>";
    str += " <td " + str220p + ">客戶料號</td>";
    str += " <td " + str100p + ">倉位</td>";
    str += " <td " + str100p + ">單位</td>";
    str += " <td " + str100p + ">數量</td>";
    str += " </tr>";
    var num = 0;
    for (var i = 0; i < value.length; i++) {
        var no = i + 1; num += value[i].數量;
        str += " <tr>";
        str += " <td " + strcenter + ">" + no + "</td>";
        str += " <td " + strcenter + ">" + value[i].工單 + "</td>";
        str += " <td " + strcenter + ">" + value[i].機種 + "</td>";
        str += " <td " + strcenter + ">" + value[i].客戶料號 + "</td>";
        str += " <td " + strcenter + ">" + value[i].倉位 + "</td>";
        str += " <td " + strcenter + ">PCS</td>";
        str += " <td " + strcenter + ">" + value[i].數量 + "</td>";
        str += " </tr>";
    }
    str += "<tr>";
    str += " <td " + strcenter + ">合計:</td>";
    str += " <td></td>";
    str += " <td></td>";
    str += " <td></td>";
    str += " <td></td>";
    str += " <td></td>";
    str += " <td " + strcenter + ">" + num + "</td>";
    str += " </tr>";
    msg = str;
    return msg;
}

function print2() {
    var oldhtml = document.body.innerHTML;
    document.getElementById("tb1").style.display = "";//显示
    bdhtml = window.document.body.innerHTML;
    sprnstr = "<!--startprint-->";
    eprnstr = "<!--endprint-->";
    prnhtml = bdhtml.substr(bdhtml.indexOf(sprnstr) + 17);
    prnhtml = prnhtml.substring(0, prnhtml.indexOf(eprnstr));
    window.document.body.innerHTML = prnhtml;
    window.print();
    document.getElementById("tb1").style.display = "none";//显示
    document.body.innerHTML = oldhtml;
}


