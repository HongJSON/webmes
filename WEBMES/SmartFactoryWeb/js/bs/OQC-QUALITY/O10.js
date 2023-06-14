$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetModel();
    GetPdline();
    GetTemplate();
})

$(function () {
    $("#datetimepicker").datetimepicker({
        format: 'yyyy-mm-dd',
        language: 'zh-CN',
        weekStart: 1,
        todayBtn: 1,//显示‘今日’按钮
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        minView: 2,
        clearBtn: true,//清除按钮
        forceParse: 0
    });
    $('#datetimepicker').focus(function () {
        $(this).blur();//不可输入状态
    })
});


function GetModel() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { funcName: 'ShowModel' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
                }
                $("#ModelName").html(str);
            }
        }
    });
}

function GetProcess() {
    var PdlineName = $("#PdlineName").val();
    if (PdlineName == "") {
        var error_msg = "请选择线体!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { PdlineName: PdlineName, funcName: 'GetProcess' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "<option value=''></option>";

            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].PROCESS_NAME + "'>" + res[i].PROCESS_NAME + "</option>";
            }
            $("#ProcessName").html(str);

        }
    });
}



function GetDnno() {
    var Template = $("#Template").val();
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    } if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    } if (ProcessName == "") {
        var error_msg = "请选择站点!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    } if (datetimepicker == "") {
        var error_msg = "请选择日期!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (dataType == "") {
        var error_msg = "请选择班别!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (PdlineName == "") {
        var error_msg = "请选择线体!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { Template: Template, ModelName: ModelName, ProcessName: ProcessName, datetimepicker: datetimepicker, dataType: dataType, PdlineName: PdlineName, funcName: 'GetDnno' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res == "NG") {
                var error_msg = "NG,未查询到任务单号,请先生成任务号!";
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            } else {
                var str = "<option value=''></option>";
                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].DN_NO + "'>" + res[i].DN_NO + "</option>";
                }
                $("#Dnno").html(str);
            }
        }
    });
}


function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { funcName: 'ShowPdline' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
                }
                $("#PdlineName").html(str);
            }
        }
    });
}


function GetTemplate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { funcName: 'ShowTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TEMPLATE + "'>" + res[i].TEMPLATE + "</option>";
                }
                $("#Template").html(str);
            }
        }
    });
}
function SelectShow() {
    show();
}

function GetShow() {
    show();
}


function show() {
    var Template = $("#Template").val();
    var Dnno = $("#Dnno").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Dnno == "") {
        var error_msg = "请选择任务单号!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (datetimepicker == "") {
        var error_msg = "请选择日期!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (dataType == "") {
        var error_msg = "请选择班别!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var TYPE1 = "TYPE1"; var TYPE2 = "TYPE2"; var TYPE3 = "TYPE3"; var TYPE4 = "TYPE4"; var TYPE5 = "TYPE5"; var TYPE6 = "TYPE6"; var TYPE7 = "TYPE7"; var TYPE8 = "TYPE8"; var TYPE9 = "TYPE9";
    var TYPE10 = "TYPE10"; var TYPE11 = "TYPE11";
    var TYPE12 = "TYPE12"; var TYPE13 = "TYPE13"; var TYPE14 = "TYPE14"; var TYPE15 = "TYPE15"; var TYPE16 = "TYPE16"; var TYPE17 = "TYPE17"; var TYPE18 = "TYPE18"; var TYPE19 = "TYPE19"; var TYPE20 = "TYPE20";
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { Template: Template, funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            var Type = "Typ";
            for (var i = 0; i < res.length; i++) {
                if (i == 0) {
                    TYPE1 = res[i].TITLE;
                }
                if (i == 1) {
                    TYPE2 = res[i].TITLE;
                }
                if (i == 2) {
                    TYPE3 = res[i].TITLE;
                }
                if (i == 3) {
                    TYPE4 = res[i].TITLE;
                }
                if (i == 4) {
                    TYPE5 = res[i].TITLE;
                }
                if (i == 5) {
                    TYPE6 = res[i].TITLE;
                }
                if (i == 6) {
                    TYPE7 = res[i].TITLE;
                }
                if (i == 7) {
                    TYPE8 = res[i].TITLE;
                }
                if (i == 8) {
                    TYPE9 = res[i].TITLE;
                }
                if (i == 9) {
                    TYPE10 = res[i].TITLE;
                }
                if (i == 10) {
                    TYPE11 = res[i].TITLE;
                }
                if (i == 11) {
                    TYPE12 = res[i].TITLE;
                }
                if (i == 12) {
                    TYPE13 = res[i].TITLE;
                }
                if (i == 13) {
                    TYPE14 = res[i].TITLE;
                }
                if (i == 14) {
                    TYPE15 = res[i].TITLE;
                }
                if (i == 15) {
                    TYPE16 = res[i].TITLE;
                }
                if (i == 16) {
                    TYPE17 = res[i].TITLE;
                }
                if (i == 17) {
                    TYPE18 = res[i].TITLE;
                }
                if (i == 18) {
                    TYPE19 = res[i].TITLE;
                }
                if (i == 19) {
                    TYPE20 = res[i].TITLE;
                }
            }

        }
    });
    var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        pageSize: 50,
        columns: [{
            title: 'ID',
            width: 35,
            formatter: function (value, row, index) {
                return index + 1;
            }
        }, {
            field: '编辑',
            title: '编辑',
            width: 20,
            events: operateDownEvents,//给按钮注册事件
            formatter: addAutoAssy//表格中增加按钮
        }, {
            field: '提交',
            title: '提交',
            width: 20,
            events: operateDownEvents1,//给按钮注册事件
            formatter: addAutoAssy1//表格中增加按钮
        }, {
            field: 'DN_NO',
            title: '任务号',
            width: 200
        }, {
            field: 'YEAR_DATE',
            title: '日期',
            width: 100
        }, {
            field: 'CLASS',
            title: '班别',
            width: 100
        }, {
            field: 'TYPE1',
            title: TYPE1,
            width: 100
        }, {
            field: 'TYPE2',
            title: TYPE2,
            width: 100
        }, {
            field: 'TYPE3',
            title: TYPE3,
            width: 100
        }, {
            field: 'TYPE4',
            title: TYPE4,
            width: 100
        }, {
            field: 'TYPE5',
            title: TYPE5,
            width: 100
        }, {
            field: 'TYPE6',
            title: TYPE6,
            width: 100
        }, {
            field: 'TYPE7',
            title: TYPE7,
            width: 100
        }, {
            field: 'TYPE8',
            title: TYPE8,
            width: 100
        }, {
            field: 'TYPE9',
            title: TYPE9,
            width: 100
        }, {
            field: 'TYPE10',
            title: TYPE10,
            width: 100
        }, {
            field: 'TYPE11',
            title: TYPE11,
            width: 100
        }, {
            field: 'TYPE12',
            title: TYPE12,
            width: 100
        }, {
            field: 'TYPE13',
            title: TYPE13,
            width: 100
        }, {
            field: 'TYPE14',
            title: TYPE14,
            width: 100
        }, {
            field: 'TYPE15',
            title: TYPE15,
            width: 100
        }, {
            field: 'TYPE16',
            title: TYPE16,
            width: 100
        }, {
            field: 'TYPE17',
            title: TYPE17,
            width: 100
        }, {
            field: 'TYPE18',
            title: TYPE18,
            width: 100
        }, {
            field: 'TYPE19',
            title: TYPE19,
            width: 100
        }, {
            field: 'TYPE20',
            title: TYPE20,
            width: 100
        }, {
            field: 'RESULT',
            title: '结果',
            width: 100
        }, {
            field: 'FA',
            title: 'FA',
            width: 100
        }, {
            field: 'CA',
            title: 'CA',
            width: 100
        }, {
            field: 'CREATE_DATE',
            title: '创建时间',
            width: 170
        }, {
            field: 'EMP_NAME',
            title: '创建人员',
            width: 100
        }, {
            field: 'DRI_DATE',
            title: '审核时间',
            width: 170
        }, {
            field: 'EMP_NAME1',
            title: '审核人员',
            width: 100
        }]
    });
}

function addAutoAssy(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}
function addAutoAssy1(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}
window.operateDownEvents = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        $("#mymodal").modal('show');
        $('#Id').val(row.ID);
        $('#Dnno1').val(row.DN_NO);
        $('#datetimepicker1').val(row.YEAR_DATE);
        $('#banbie').val(row.CLASS);

        //var TEMPLATE = row.TEMPLATE;

        GetQTY(row.TEMPLATE);
        GetLabel(row.TEMPLATE, row.TYPE1, row.TYPE2, row.TYPE3, row.TYPE4, row.TYPE5, row.TYPE6, row.TYPE7, row.TYPE8, row.TYPE9, row.TYPE10, row.TYPE11, row.TYPE12, row.TYPE13, row.TYPE14, row.TYPE15, row.TYPE16, row.TYPE17, row.TYPE18, row.TYPE19, row.TYPE20);
    }
}
window.operateDownEvents1 = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        $("#mymodal1").modal('show');
        $('#Id1').val(row.ID);
        $('#Dnno11').val(row.DN_NO);
        $('#datetimepicker11').val(row.YEAR_DATE);
        $('#banbie1').val(row.CLASS);
        $('#Result').val(row.RESULT);
        $('#Fa').val(row.FA);
        $('#Ca').val(row.CA);

        GetQTY1(row.TEMPLATE);
        GetLabel1(row.TEMPLATE, row.TYPE1, row.TYPE2, row.TYPE3, row.TYPE4, row.TYPE5, row.TYPE6, row.TYPE7, row.TYPE8, row.TYPE9, row.TYPE10, row.TYPE11, row.TYPE12, row.TYPE13, row.TYPE14, row.TYPE15, row.TYPE16, row.TYPE17, row.TYPE18, row.TYPE19, row.TYPE20);
    }
}


function GetQTY1(Template) {
    //var Template = row.TEMPLATE;
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { Template: Template, funcName: 'GetQTY' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#LTYPE1").hide(); $("#LTYPE2").hide(); $("#LTYPE3").hide(); $("#LTYPE4").hide(); $("#LTYPE5").hide();
                $("#LTYPE6").hide(); $("#LTYPE7").hide(); $("#LTYPE8").hide(); $("#LTYPE9").hide(); $("#LTYPE10").hide();
                $("#LTYPE11").hide(); $("#LTYPE12").hide(); $("#LTYPE13").hide(); $("#LTYPE14").hide(); $("#LTYPE15").hide();
                $("#LTYPE16").hide(); $("#LTYPE17").hide(); $("#LTYPE18").hide(); $("#LTYPE19").hide(); $("#LTYPE20").hide();

                for (var i = 1; i <= res[0].ERR_MSG; i++) {
                    var Type = "LTYPE";
                    Type = Type + i;
                    $("#" + Type + "").show();
                }
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });
}
function GetQTY(Template) {
    //var Template = row.TEMPLATE;
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { Template: Template, funcName: 'GetQTY' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#TYPE1").hide(); $("#TYPE2").hide(); $("#TYPE3").hide(); $("#TYPE4").hide(); $("#TYPE5").hide();
                $("#TYPE6").hide(); $("#TYPE7").hide(); $("#TYPE8").hide(); $("#TYPE9").hide(); $("#TYPE10").hide();
                $("#TYPE11").hide(); $("#TYPE12").hide(); $("#TYPE13").hide(); $("#TYPE14").hide(); $("#TYPE15").hide();
                $("#TYPE16").hide(); $("#TYPE17").hide(); $("#TYPE18").hide(); $("#TYPE19").hide(); $("#TYPE20").hide();

                for (var i = 1; i <= res[0].ERR_MSG; i++) {
                    var Type = "TYPE";
                    Type = Type + i;
                    $("#" + Type + "").show();
                }
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });
}

function GetLabel(Template, TYPE1, TYPE2, TYPE3, TYPE4, TYPE5, TYPE6, TYPE7, TYPE8, TYPE9, TYPE10, TYPE11, TYPE12, TYPE13, TYPE14, TYPE15, TYPE16, TYPE17, TYPE18, TYPE19, TYPE20) {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { Template: Template, funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            var Type = "Typ";
            for (var i = 0; i < res.length; i++) {

                if (i == 0) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type1').val(TYPE1);
                }
                if (i == 1) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type2').val(TYPE2);
                }
                if (i == 2) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type3').val(TYPE3);
                }
                if (i == 3) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type4').val(TYPE4);
                }
                if (i == 4) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type5').val(TYPE5);
                }
                if (i == 5) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type6').val(TYPE6);
                }
                if (i == 6) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type7').val(TYPE7);
                }
                if (i == 7) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type8').val(TYPE8);
                }
                if (i == 8) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type9').val(TYPE9);
                }
                if (i == 9) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type10').val(TYPE10);
                }
                if (i == 10) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type11').val(TYPE11);
                }
                if (i == 11) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type12').val(TYPE12);
                }
                if (i == 12) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type13').val(TYPE13);
                }
                if (i == 13) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type14').val(TYPE14);
                }
                if (i == 14) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type15').val(TYPE15);
                }
                if (i == 15) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type16').val(TYPE16);
                }
                if (i == 16) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type17').val(TYPE17);
                }
                if (i == 17) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type18').val(TYPE18);
                }
                if (i == 18) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type19').val(TYPE19);
                }
                if (i == 19) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type20').val(TYPE20);
                }
            }

        }
    });
}



function GetLabel1(Template, TYPE1, TYPE2, TYPE3, TYPE4, TYPE5, TYPE6, TYPE7, TYPE8, TYPE9, TYPE10, TYPE11, TYPE12, TYPE13, TYPE14, TYPE15, TYPE16, TYPE17, TYPE18, TYPE19, TYPE20) {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { Template: Template, funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            var Type = "LTyp";
            for (var i = 0; i < res.length; i++) {

                if (i == 0) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType1').val(TYPE1);
                }
                if (i == 1) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType2').val(TYPE2);
                }
                if (i == 2) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType3').val(TYPE3);
                }
                if (i == 3) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType4').val(TYPE4);
                }
                if (i == 4) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType5').val(TYPE5);
                }
                if (i == 5) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType6').val(TYPE6);
                }
                if (i == 6) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType7').val(TYPE7);
                }
                if (i == 7) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType8').val(TYPE8);
                }
                if (i == 8) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType9').val(TYPE9);
                }
                if (i == 9) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType10').val(TYPE10);
                }
                if (i == 10) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType11').val(TYPE11);
                }
                if (i == 11) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType12').val(TYPE12);
                }
                if (i == 12) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType13').val(TYPE13);
                }
                if (i == 13) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType14').val(TYPE14);
                }
                if (i == 14) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType15').val(TYPE15);
                }
                if (i == 15) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType16').val(TYPE16);
                }
                if (i == 16) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType17').val(TYPE17);
                }
                if (i == 17) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType18').val(TYPE18);
                }
                if (i == 18) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType19').val(TYPE19);
                }
                if (i == 19) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#LType20').val(TYPE20);
                }
            }

        }
    });
}



function insert1() {
    var user = $("#user").text();
    var Result = $("#Result").val();
    var Fa = $("#Fa").val();
    var Ca = $("#Ca").val();
    var ID = $("#Id1").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { user: user, Result: Result, Fa: Fa, Ca: Ca, ID: ID, funcName: 'UpdateTemplateInfo' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal1").modal('hide');
                show();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });

}


function insert() {
    var user = $("#user").text();
    var ID = $("#Id").val();
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); var Type13 = $("#Type13").val(); var Type14 = $("#Type14").val(); var Type15 = $("#Type15").val();
    var Type16 = $("#Type16").val(); var Type17 = $("#Type17").val(); var Type18 = $("#Type18").val(); var Type19 = $("#Type19").val(); var Type20 = $("#Type20").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Type13: Type13, Type14: Type14, Type15: Type15, Type16: Type16, Type17: Type17, Type18: Type18, Type19: Type19, Type20: Type20, ID: ID, funcName: 'UpdateTemplateInfo1' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal").modal('hide');
                show();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });

}