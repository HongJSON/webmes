$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetPdline();
    GetTemplate();
    GetDn_no();
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
    GetDate();
});

function addrow() {
    var Dnno = $("#Dnno").val();
    var user = $("#user").text();
    if (Dnno == "") {
        var error_msg = "请选择任务单号!";
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
        data: { DN_NO: Dnno, user: user, funcName: 'addrow' },
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
            }
            if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            }
        }
    });
    GetDn_no();
}

function Daddrow() {
    var Dnno = $("#Dnno").val();
    var user = $("#user").text();
    if (Dnno == "") {
        var error_msg = "请选择任务单号!";
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
        data: { DN_NO: Dnno, user: user, funcName: 'Daddrow' },
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
            }
            if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            }
        }
    });
    GetDn_no();
}

function GetDate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { funcName: 'GetDate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#datetimepicker").val(res[0].ERR_MSG);
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
function GetDn_no() {
    var Template = $("#Template").val();
    var PdlineName = $("#PdlineName").val();
    //var ProcessName = $("#ProcessName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { Template: Template, PdlineName: PdlineName, datetimepicker: datetimepicker, dataType: dataType, funcName: 'ShowDnno' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].DN_NO + "'>" + res[i].DN_NO + "</option>";
                }
                $("#Dnno").html(str);
            }
            //document.getElementById("ProcessName").value = "";
            document.getElementById("Template").value = "";
            document.getElementById("PdlineName").value = "";
            document.getElementById("dataType").value = "";
        }
    });
}
function GetShow() {
    var Dnno = $("#Dnno").val();
    show(Dnno);
}

function show(Dnno) {
    var Template = $("#Template").val();
    var PdlineName = $("#PdlineName").val();
    //var ProcessName = $("#ProcessName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (Dnno == "") {
        var error_msg = "请选择任务单号!";
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
    var QTY = 0;
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { DN_NO: Dnno, funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        
        success: function (res) {
            var html = "<option></option>";
            var Type = "Typ";
            for (var i = 0; i < res.length; i++) {

                if (i == 0) {
                    TYPE1 = res[i].TITLE;
                    QTY = 1;
                }
                if (i == 1) {
                    TYPE2 = res[i].TITLE;
                    QTY = 2;
                }
                if (i == 2) {
                    TYPE3 = res[i].TITLE;
                    QTY = 3;
                }
                if (i == 3) {
                    TYPE4 = res[i].TITLE;
                    QTY = 4;
                }
                if (i == 4) {
                    TYPE5 = res[i].TITLE;
                    QTY = 5;
                }
                if (i == 5) {
                    TYPE6 = res[i].TITLE;
                    QTY = 6;
                }
                if (i == 6) {
                    TYPE7 = res[i].TITLE;
                    QTY = 7;
                }
                if (i == 7) {
                    TYPE8 = res[i].TITLE;
                    QTY = 8;
                }
                if (i == 8) {
                    TYPE9 = res[i].TITLE;
                    QTY = 9;
                }
                if (i == 9) {
                    TYPE10 = res[i].TITLE;
                    QTY = 10;
                }
                if (i == 10) {
                    TYPE11 = res[i].TITLE;
                    QTY = 11;
                }
                if (i == 11) {
                    TYPE12 = res[i].TITLE;
                    QTY = 12;
                }
                if (i == 12) {
                    TYPE13 = res[i].TITLE;
                    QTY = 13;
                }
                if (i == 13) {
                    TYPE14 = res[i].TITLE;
                    QTY = 14;
                }
                if (i == 14) {
                    TYPE15 = res[i].TITLE;
                    QTY = 15;
                }
                if (i == 15) {
                    TYPE16 = res[i].TITLE;
                    QTY = 16;
                }
                if (i == 16) {
                    TYPE17 = res[i].TITLE;
                    QTY = 17;
                }
                if (i == 17) {
                    TYPE18 = res[i].TITLE;
                    QTY = 18;
                }
                if (i == 18) {
                    TYPE19 = res[i].TITLE;
                    QTY = 19;
                }
                if (i == 19) {
                    TYPE20 = res[i].TITLE;
                    QTY = 20;
                }
            }


        }
    });
    if (QTY == 1) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            rowNum: 100,
            height: 800,        //就是这里，加上就可以固定表头
            pageSize: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 2) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2,width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 3) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center',width: 50 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 4) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center',width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 5) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
                { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 6) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
                { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            { field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 7) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
                { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 8) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
                { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 9) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
                { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 10) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
                { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
        /*    { field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },*/
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 11) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
                { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 12) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
                { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 13) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
                { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 14) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
                { field: 'TYPE14', title: TYPE14, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 15) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center',width: 100 },
                { field: 'TYPE15', title: TYPE15, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 16) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center',width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center',width: 100 },
                { field: 'TYPE16', title: TYPE16, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 17) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center',width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center',width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center',width: 100 },
                { field: 'TYPE17', title: TYPE17, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 18) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center',width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center',width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center',width: 100 },
            { field: 'TYPE17', title: TYPE17, align: 'center',width: 100 },
                { field: 'TYPE18', title: TYPE18, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 19) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center',width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center',width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center',width: 100 },
            { field: 'TYPE17', title: TYPE17, align: 'center',width: 100 },
            { field: 'TYPE18', title: TYPE18, align: 'center',width: 100 },
                { field: 'TYPE19', title: TYPE19, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },

            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
    if (QTY == 20) {
        var url = "../../../controller/OQC-QUALITY/O05.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100, rowNum: 100,
            columns: [{ title: 'ID', align: 'center',width: 35, formatter: function (value, row, index) { return index + 1; } },
            //{ field: 'DN_NO', title: '任务号', align: 'center',width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', align: 'center',width: 100 },
                { field: 'CLASS', title: '班别', align: 'center',width: 50 },
                { field: 'TYPE1', title: TYPE1, align: 'center',width: 50 },
                { field: 'TYPE2', title: TYPE2, width: 100 },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
                { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center',width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center',width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center',width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center',width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center',width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center',width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center',width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center',width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center',width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center',width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center',width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center',width: 100 },
            { field: 'TYPE17', title: TYPE17, align: 'center',width: 100 },
            { field: 'TYPE18', title: TYPE18, align: 'center',width: 100 },
            { field: 'TYPE19', title: TYPE19, align: 'center',width: 100 },
                { field: 'TYPE20', title: TYPE20, align: 'center',width: 100 },
                { field: 'REMARK', title: '备注', align: 'center',width: 100 },
            //{ field: 'RESULT', title: '结果', align: 'center',width: 100 },
            //{ field: 'FA', title: 'FA', align: 'center',width: 100 },
            //{ field: 'CA', title: 'CA', align: 'center',width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', align: 'center',width: 100 },
            { field: 'EMP_NAME', title: '创建人员', align: 'center',width: 100 },
                { field: 'UPDATE_DATE', title: '审核时间', align: 'center',width: 100 },
            { field: 'EMP_NAME1', title: '审核人员', align: 'center',width: 100 },]
        });
    }
}

function addAutoAssy1(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
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
        GetLabel1(row.DN_NO,row.TEMPLATE, row.TYPE1, row.TYPE2, row.TYPE3, row.TYPE4, row.TYPE5, row.TYPE6, row.TYPE7, row.TYPE8, row.TYPE9, row.TYPE10, row.TYPE11, row.TYPE12, row.TYPE13, row.TYPE14, row.TYPE15, row.TYPE16, row.TYPE17, row.TYPE18, row.TYPE19, row.TYPE20);
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



function GetLabel1(DN_NO,Template, TYPE1, TYPE2, TYPE3, TYPE4, TYPE5, TYPE6, TYPE7, TYPE8, TYPE9, TYPE10, TYPE11, TYPE12, TYPE13, TYPE14, TYPE15, TYPE16, TYPE17, TYPE18, TYPE19, TYPE20) {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O05.ashx",
        data: { DN_NO: DN_NO, funcName: 'GetLabel' },
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
    var DN_NO = $("#Dnno11").val();
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
                show(DN_NO);
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




//function GetProcess() {
//    var PdlineName = $("#PdlineName").val();
//    if (PdlineName == "") {
//        var error_msg = "请选择线体!";
//        swal({
//            text: error_msg,
//            type: "error",
//            confirmButtonColor: '#3085d6'
//        })
//        return;
//    }
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/O04.ashx",
//        data: { PdlineName: PdlineName, funcName: 'GetProcess' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            var str = "<option value=''></option>";

//            for (var i = 0; i < res.length; i++) {
//                str += "<option value='" + res[i].PROCESS_NAME + "'>" + res[i].PROCESS_NAME + "</option>";
//            }
//            $("#ProcessName").html(str);

//        }
//    });
//}



function SelectShow() {
    GetDn_no();
}
