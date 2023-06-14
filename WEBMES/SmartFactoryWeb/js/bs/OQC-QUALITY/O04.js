$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetPdline();
    GetTemplate();
    GetDn_no();
})
//定義全局變量
var dataObj = [];  // 數據對象數據
function SelectDnno()
{
    GetDn_no();
}
function Commit() {
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
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { DN_NO: Dnno, user: user, funcName: 'Commit' },
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
                GetDn_no();
                $.ajax({
                    method: "post",
                    url: "../../../controller/OQC-QUALITY/O04.ashx",
                    data: { DN_NO: "N/A", funcName: 'GetDnnoType' },
                    dataType: "json",
                    async: false,
                    success: function (res) {
                        if (res[0].ERR_CODE == "N") {
                            $("#Dnstatus").val(res[0].ERR_MSG);
                        }
                    }
                });
            }
        }
    });

}


function O04Keydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var JJ = $("#JJ").val()

        if (JJ == '') {
            var error_msg = "请输入线体!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/O04.ashx",
            data: { JJ: JJ,funcName: 'ShowPdlineJJ' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res != null) {
                    var str = "<option value=''></option>";

                    for (var i = 0; i < res.length; i++) {
                        str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
                    }
                    $("#PdlineName").html(str);
                    $('#JJ').val("");
                }
            }
        });
    }
}

function GetDate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
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
        linked: true,
/*        startDate: new Date(),*/
        clearBtn: true,//清除按钮
        forceParse: 0
    });
    GetDate();
});
function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
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
        url: "../../../controller/OQC-QUALITY/O04.ashx",
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
        url: "../../../controller/OQC-QUALITY/O04.ashx",
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
    var ModelName = $("#ModelName").val();
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
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { DN_NO: Dnno,funcName: 'GetDnnoType' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#Dnstatus").val(res[0].ERR_MSG);
            }
        }
    });
    var TYPE1 = "TYPE1"; var TYPE2 = "TYPE2"; var TYPE3 = "TYPE3"; var TYPE4 = "TYPE4"; var TYPE5 = "TYPE5"; var TYPE6 = "TYPE6"; var TYPE7 = "TYPE7"; var TYPE8 = "TYPE8"; var TYPE9 = "TYPE9";
    var TYPE10 = "TYPE10"; var TYPE11 = "TYPE11";
    var TYPE12 = "TYPE12"; var TYPE13 = "TYPE13"; var TYPE14 = "TYPE14"; var TYPE15 = "TYPE15"; var TYPE16 = "TYPE16"; var TYPE17 = "TYPE17"; var TYPE18 = "TYPE18"; var TYPE19 = "TYPE19"; var TYPE20 = "TYPE20";
    var QTY = 0;
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
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
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },

                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },/* { field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 2) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },/* { field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 3) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },/* { field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 4) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 5) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 6) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 7) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 8) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 9) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 10) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;



        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
            //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; }} },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; }} },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; }} },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; }} },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
                { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 11) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 12) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 13) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 14) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },
                { field: 'TYPE14', title: TYPE14, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE14 == "NG") { return '<span style="color:#fd7879">' + row.TYPE14 + '</span>'; } else { return row.TYPE14; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 15) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },
                { field: 'TYPE14', title: TYPE14, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE14 == "NG") { return '<span style="color:#fd7879">' + row.TYPE14 + '</span>'; } else { return row.TYPE14; } } },
                { field: 'TYPE15', title: TYPE15, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE15 == "NG") { return '<span style="color:#fd7879">' + row.TYPE15 + '</span>'; } else { return row.TYPE15; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 16) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },
                { field: 'TYPE14', title: TYPE14, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE14 == "NG") { return '<span style="color:#fd7879">' + row.TYPE14 + '</span>'; } else { return row.TYPE14; } } },
                { field: 'TYPE15', title: TYPE15, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE15 == "NG") { return '<span style="color:#fd7879">' + row.TYPE15 + '</span>'; } else { return row.TYPE15; } } },
                { field: 'TYPE16', title: TYPE16, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE16 == "NG") { return '<span style="color:#fd7879">' + row.TYPE16 + '</span>'; } else { return row.TYPE16; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 17) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },
                { field: 'TYPE14', title: TYPE14, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE14 == "NG") { return '<span style="color:#fd7879">' + row.TYPE14 + '</span>'; } else { return row.TYPE14; } } },
                { field: 'TYPE15', title: TYPE15, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE15 == "NG") { return '<span style="color:#fd7879">' + row.TYPE15 + '</span>'; } else { return row.TYPE15; } } },
                { field: 'TYPE16', title: TYPE16, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE16 == "NG") { return '<span style="color:#fd7879">' + row.TYPE16 + '</span>'; } else { return row.TYPE16; } } },
                { field: 'TYPE17', title: TYPE17, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE17 == "NG") { return '<span style="color:#fd7879">' + row.TYPE17 + '</span>'; } else { return row.TYPE17; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 18) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            fixedColumns: true,
            fixedNumber: 1 ,//固定列数
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },
                { field: 'TYPE14', title: TYPE14, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE14 == "NG") { return '<span style="color:#fd7879">' + row.TYPE14 + '</span>'; } else { return row.TYPE14; } } },
                { field: 'TYPE15', title: TYPE15, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE15 == "NG") { return '<span style="color:#fd7879">' + row.TYPE15 + '</span>'; } else { return row.TYPE15; } } },
                { field: 'TYPE16', title: TYPE16, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE16 == "NG") { return '<span style="color:#fd7879">' + row.TYPE16 + '</span>'; } else { return row.TYPE16; } } },
                { field: 'TYPE17', title: TYPE17, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE17 == "NG") { return '<span style="color:#fd7879">' + row.TYPE17 + '</span>'; } else { return row.TYPE17; } } },
                { field: 'TYPE18', title: TYPE18, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE18 == "NG") { return '<span style="color:#fd7879">' + row.TYPE18 + '</span>'; } else { return row.TYPE18; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
                { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 19) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row);var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
            //{ field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },
                { field: 'TYPE14', title: TYPE14, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE14 == "NG") { return '<span style="color:#fd7879">' + row.TYPE14 + '</span>'; } else { return row.TYPE14; } } },
                { field: 'TYPE15', title: TYPE15, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE15 == "NG") { return '<span style="color:#fd7879">' + row.TYPE15 + '</span>'; } else { return row.TYPE15; } } },
                { field: 'TYPE16', title: TYPE16, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE16 == "NG") { return '<span style="color:#fd7879">' + row.TYPE16 + '</span>'; } else { return row.TYPE16; } } },
                { field: 'TYPE17', title: TYPE17, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE17 == "NG") { return '<span style="color:#fd7879">' + row.TYPE17 + '</span>'; } else { return row.TYPE17; } } },
                { field: 'TYPE18', title: TYPE18, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE18 == "NG") { return '<span style="color:#fd7879">' + row.TYPE18 + '</span>'; } else { return row.TYPE18; } } },
                { field: 'TYPE19', title: TYPE19, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE19 == "NG") { return '<span style="color:#fd7879">' + row.TYPE19 + '</span>'; } else { return row.TYPE19; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }
    if (QTY == 20) {
        var url = "../../../controller/OQC-QUALITY/O04.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { dataObj.push(row); var a = ""; if (row.TYPE1 == "NG" || row.TYPE2 == "NG" || row.TYPE3 == "NG" || row.TYPE4 == "NG" || row.TYPE5 == "NG" || row.TYPE6 == "NG" || row.TYPE7 == "NG" || row.TYPE8 == "NG" || row.TYPE9 == "NG" || row.TYPE10 == "NG" || row.TYPE11 == "NG" || row.TYPE12 == "NG" || row.TYPE13 == "NG" || row.TYPE14 == "NG" || row.TYPE15 == "NG" || row.TYPE16 == "NG" || row.TYPE17 == "NG" || row.TYPE18 == "NG" || row.TYPE19 == "NG" || row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + (index + 1) + '</span>'; } else { return index + 1; } } },
                //{ field: 'DN_NO', title: '任务号', width: 200 },
                //{ field: 'YEAR_DATE', title: '日期', width: 100 },
                { field: 'CLASS', title: '班别', align: 'center', width: 50, formatter: function (value, row, index) { if (row.CLASS == "NG") { return '<span style="color:#fd7879">' + row.CLASS + '</span>'; } else { return row.CLASS; } } },
                { field: 'TYPE1', title: TYPE1, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE1 == "NG") { return '<span style="color:#fd7879">' + row.TYPE1 + '</span>'; } else { return row.TYPE1; } } },
                { field: 'TYPE2', title: TYPE2, width: 100, formatter: function (value, row, index) { if (row.TYPE2 == "NG") { return '<span style="color:#fd7879">' + row.TYPE2 + '</span>'; } else { return row.TYPE2; } } },
                { field: 'TYPE3', title: TYPE3, align: 'center', width: 50, formatter: function (value, row, index) { if (row.TYPE3 == "NG") { return '<span style="color:#fd7879">' + row.TYPE3 + '</span>'; } else { return row.TYPE3; } } },
                { field: 'TYPE4', title: TYPE4, width: 250, formatter: function (value, row, index) { if (row.TYPE4 == "NG") { return '<span style="color:#fd7879">' + row.TYPE4 + '</span>'; } else { return row.TYPE4; } } },
                { field: 'TYPE5', title: TYPE5, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE5 == "NG") { return '<span style="color:#fd7879">' + row.TYPE5 + '</span>'; } else { return row.TYPE5; } } },
                { field: 'TYPE6', title: TYPE6, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE6 == "NG") { return '<span style="color:#fd7879">' + row.TYPE6 + '</span>'; } else { return row.TYPE6; } } },
                { field: 'TYPE7', title: TYPE7, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE7 == "NG") { return '<span style="color:#fd7879">' + row.TYPE7 + '</span>'; } else { return row.TYPE7; } } },
                { field: 'TYPE8', title: TYPE8, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE8 == "NG") { return '<span style="color:#fd7879">' + row.TYPE8 + '</span>'; } else { return row.TYPE8; } } },
                { field: 'TYPE9', title: TYPE9, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE9 == "NG") { return '<span style="color:#fd7879">' + row.TYPE9 + '</span>'; } else { return row.TYPE9; } } },
                { field: 'TYPE10', title: TYPE10, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE10 == "NG") { return '<span style="color:#fd7879">' + row.TYPE10 + '</span>'; } else { return row.TYPE10; } } },
                { field: 'TYPE11', title: TYPE11, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE11 == "NG") { return '<span style="color:#fd7879">' + row.TYPE11 + '</span>'; } else { return row.TYPE11; } } },
                { field: 'TYPE12', title: TYPE12, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE12 == "NG") { return '<span style="color:#fd7879">' + row.TYPE12 + '</span>'; } else { return row.TYPE12; } } },
                { field: 'TYPE13', title: TYPE13, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE13 == "NG") { return '<span style="color:#fd7879">' + row.TYPE13 + '</span>'; } else { return row.TYPE13; } } },
                { field: 'TYPE14', title: TYPE14, align: 'center',width: 100, formatter: function (value, row, index) { if (row.TYPE14 == "NG") { return '<span style="color:#fd7879">' + row.TYPE14 + '</span>'; } else { return row.TYPE14; } } },
                { field: 'TYPE15', title: TYPE15, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE15 == "NG") { return '<span style="color:#fd7879">' + row.TYPE15 + '</span>'; } else { return row.TYPE15; } } },
                { field: 'TYPE16', title: TYPE16, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE16 == "NG") { return '<span style="color:#fd7879">' + row.TYPE16 + '</span>'; } else { return row.TYPE16; } } },
                { field: 'TYPE17', title: TYPE17, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE17 == "NG") { return '<span style="color:#fd7879">' + row.TYPE17 + '</span>'; } else { return row.TYPE17; } } },
                { field: 'TYPE18', title: TYPE18, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE18 == "NG") { return '<span style="color:#fd7879">' + row.TYPE18 + '</span>'; } else { return row.TYPE18; } } },
                { field: 'TYPE19', title: TYPE19, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE19 == "NG") { return '<span style="color:#fd7879">' + row.TYPE19 + '</span>'; } else { return row.TYPE19; } } },
                { field: 'TYPE20', title: TYPE20, align: 'center', width: 100, formatter: function (value, row, index) { if (row.TYPE20 == "NG") { return '<span style="color:#fd7879">' + row.TYPE20 + '</span>'; } else { return row.TYPE20; } } },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
                { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy }, /*{ field: '修改', title: '修改', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },*/]
        });
    }






}

function addAutoAssy(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}
//function addAutoAssy1(value, row, index) {
//    return [
//        '<img id="autoAssy1" src="../../../img/edit.png" style="cursor: pointer"/>'
//    ].join('');
//}

//window.operateDownEvents1 = {
//    'click #autoAssy1': function (e, value, row, index) {
//        console.log(row);
//        let user = $("#user").text();
//        console.log(user);
//        $("#mymodal").modal('show');
//        $('#Id').val(row.ID);
//        $('#Dnno1').val(row.DN_NO);
//        $('#datetimepicker1').val(row.YEAR_DATE);
//        $('#banbie').val(row.CLASS);
//        $('#Remark').val(row.REMARK);

//        //var TEMPLATE = row.TEMPLATE;

//        GetQTY(row.TEMPLATE);
//        GetLabel(row.REMARK, row.DN_NO, row.TEMPLATE, row.TYPE1, row.TYPE2, row.TYPE3, row.TYPE4, row.TYPE5, row.TYPE6, row.TYPE7, row.TYPE8, row.TYPE9, row.TYPE10, row.TYPE11, row.TYPE12, row.TYPE13, row.TYPE14, row.TYPE15, row.TYPE16, row.TYPE17, row.TYPE18, row.TYPE19, row.TYPE20);
//    }
//}

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
        $('#Remark').val(row.REMARK);

        //var TEMPLATE = row.TEMPLATE;

        GetQTY(row.TEMPLATE);
        GetLabel(row.REMARK,row.DN_NO,row.TEMPLATE, row.TYPE1, row.TYPE2, row.TYPE3, row.TYPE4, row.TYPE5, row.TYPE6, row.TYPE7, row.TYPE8, row.TYPE9, row.TYPE10, row.TYPE11, row.TYPE12, row.TYPE13, row.TYPE14, row.TYPE15, row.TYPE16, row.TYPE17, row.TYPE18, row.TYPE19, row.TYPE20);
    }
}

function GetQTY(Template) {
    //var Template = row.TEMPLATE;




    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
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

function GetLabel(REMARK,DN_NO,Template, TYPE1, TYPE2, TYPE3, TYPE4, TYPE5, TYPE6, TYPE7, TYPE8, TYPE9, TYPE10, TYPE11, TYPE12, TYPE13, TYPE14, TYPE15, TYPE16, TYPE17, TYPE18, TYPE19, TYPE20) {
    var Dnstatus = $("#Dnstatus").val();
    $('#Remark').val(REMARK);
    var Datetime;

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { funcName: 'GetDate1' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                Datetime = res[0].ERR_MSG;
            }
        }
    });


    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { DN_NO: DN_NO, funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            var Type = "Typ";
            //document.getElementById("Type1").disabled = false;
            //document.getElementById("Type2").disabled = false;
            //document.getElementById("Type3").disabled = false;
            //document.getElementById("Type4").disabled = false;
            //document.getElementById("Type5").disabled = false;
            //document.getElementById("Type6").disabled = false;
            //document.getElementById("Type7").disabled = false;
            //document.getElementById("Type8").disabled = false;
            //document.getElementById("Type9").disabled = false;
            //document.getElementById("Type10").disabled = false;
            //document.getElementById("Type11").disabled = false;
            //document.getElementById("Type12").disabled = false;
            //document.getElementById("Type13").disabled = false;
            //document.getElementById("Type14").disabled = false;
            //document.getElementById("Type15").disabled = false;
            //document.getElementById("Type16").disabled = false;
            //document.getElementById("Type17").disabled = false;
            //document.getElementById("Type18").disabled = false;
            //document.getElementById("Type19").disabled = false;
            //document.getElementById("Type20").disabled = false;




            for (var i = 0; i < res.length; i++) {

                if (i == 0) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type1').val(TYPE1);

                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];

                            if (start < Datetime && (TYPE1 == "" || TYPE1 == "null" || TYPE1 == null)) {
                                document.getElementById("Type1").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type1").disabled = true;

                                }
                                else {
                                    document.getElementById("Type1").disabled = false;
                                    break;
                                }
                            }                       
                        }
                        else
                        {
                            document.getElementById("Type1").disabled = true;
                        }
                    }



                    if (TYPE1 != "" && TYPE1 != "null" && TYPE1 != null && TYPE1 != undefined) {
                    //    document.getElementById("Type1").disabled = true;
                    }
                }
                if (i == 1) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type2').val(TYPE2);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE2 == "" || TYPE2 == "null" || TYPE2 == null)) {
                                document.getElementById("Type2").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type2").disabled = true;

                                }
                                else {
                                    document.getElementById("Type2").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type2").disabled = true;
                        }
                    }
                    if (TYPE2 != "" && TYPE2 != "null" && TYPE2 != null && TYPE2 != undefined) {
                        // document.getElementById("Type2").disabled = true;
                    }
                }
                if (i == 2) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type3').val(TYPE3);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE3 == "" || TYPE3 == "null" || TYPE3 == null)) {
                                document.getElementById("Type3").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type3").disabled = true;

                                }
                                else {
                                    document.getElementById("Type3").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type3").disabled = true;
                        }
                    }
                    if (TYPE3 != "" && TYPE3 != "null" && TYPE3 != null && TYPE3 != undefined) {
                        // document.getElementById("Type3").disabled = true;
                    }
                }
                if (i == 3) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type4').val(TYPE4);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE4 == "" || TYPE4 == "null" || TYPE4== null)) {
                                document.getElementById("Type4").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type4").disabled = true;

                                }
                                else {
                                    document.getElementById("Type4").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type4").disabled = true;
                        }
                    }
                    if (TYPE4 != "" && TYPE4 != "null" && TYPE4 != null && TYPE4 != undefined) {
                       //  document.getElementById("Type4").disabled = true;
                    }
                }
                if (i == 4) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type5').val(TYPE5);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE5 == "" || TYPE5== "null" || TYPE5== null)) {
                                document.getElementById("Type5").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type5").disabled = true;

                                }
                                else {
                                    document.getElementById("Type5").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type5").disabled = true;
                        }
                    }
                    if (TYPE5 != "" && TYPE5 != "null" && TYPE5 != null && TYPE5 != undefined) {
                        // document.getElementById("Type5").disabled = true;
                    }
                }
                if (i == 5) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type6').val(TYPE6);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE6 == "" || TYPE6 == "null" || TYPE6 == null)) {
                                document.getElementById("Type6").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type6").disabled = true;

                                }
                                else {
                                    document.getElementById("Type6").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type6").disabled = true;
                        }
                    }
                    if (TYPE6 != "" && TYPE6 != "null" && TYPE6 != null && TYPE6 != undefined) {
                       //  document.getElementById("Type6").disabled = true;
                    }
                }
                if (i == 6) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type7').val(TYPE7);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE7 == "" || TYPE7 == "null" || TYPE7 == null)) {
                                document.getElementById("Type7").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type7").disabled = true;

                                }
                                else {
                                    document.getElementById("Type7").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type7").disabled = true;
                        }
                    }
                    if (TYPE7 != "" && TYPE7 != "null" && TYPE7 != null && TYPE7 != undefined) {
                       //  document.getElementById("Type7").disabled = true;
                    }
                }
                if (i == 7) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type8').val(TYPE8);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE8 == "" || TYPE8 == "null" || TYPE8 == null)) {
                                document.getElementById("Type8").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type8").disabled = true;

                                }
                                else {
                                    document.getElementById("Type8").disabled = false;
                                    break;
                                }
                            }
                        }
                        else {
                            document.getElementById("Type8").disabled = true;
                        }
                    }
                    if (TYPE8 != "" && TYPE8 != "null" && TYPE8 != null && TYPE8 != undefined) {
                       //  document.getElementById("Type8").disabled = true;
                    }
                }
                if (i == 8) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type9').val(TYPE9);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE9 == "" || TYPE9 == "null" || TYPE9 == null)) {
                                document.getElementById("Type9").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type9").disabled = true;

                                }
                                else {
                                    document.getElementById("Type9").disabled = false;
                                    break;
                                }
                            }
                        }
                        else {
                            document.getElementById("Type9").disabled = true;
                        }
                    }
                    if (TYPE9 != "" && TYPE9 != "null" && TYPE9 != null && TYPE9 != undefined) {
                        // document.getElementById("Type9").disabled = true;
                    }
                }
                if (i == 9) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type10').val(TYPE10);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE10 == "" || TYPE10 == "null" || TYPE10 == null)) {
                                document.getElementById("Type10").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type10").disabled = true;

                                }
                                else {
                                    document.getElementById("Type10").disabled = false;
                                    break;
                                }
                            }
                        }
                        else {
                            document.getElementById("Type10").disabled = true;
                        }
                    }
                    if (TYPE10 != "" && TYPE10 != "null" && TYPE10 != null && TYPE10 != undefined) {
                        // document.getElementById("Type10").disabled = true;
                    }
                }
                if (i == 10) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type11').val(TYPE11);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE11 == "" || TYPE11 == "null" || TYPE11 == null)) {
                                document.getElementById("Type11").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type11").disabled = true;

                                }
                                else {
                                    document.getElementById("Type11").disabled = false;
                                    break;
                                }
                            }
                        }
                        else {
                            document.getElementById("Type11").disabled = true;
                        }
                    }
                    if (TYPE11 != "" && TYPE11 != "null" && TYPE11 != null && TYPE11 != undefined) {
                        // document.getElementById("Type11").disabled = true;
                    }
                }
                if (i == 11) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type12').val(TYPE12);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE12 == "" || TYPE12 == "null" || TYPE12 == null)) {
                                document.getElementById("Type12").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type12").disabled = true;

                                }
                                else {
                                    document.getElementById("Type12").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type12").disabled = true;
                        }
                    }
                    if (TYPE12 != "" && TYPE12 != "null" && TYPE12 != null && TYPE12 != undefined) {
                        // document.getElementById("Type12").disabled = true;
                    }
                }
                if (i == 12) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type13').val(TYPE13);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE13 == "" || TYPE13 == "null" || TYPE13 == null)) {
                                document.getElementById("Type13").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type13").disabled = true;

                                }
                                else {
                                    document.getElementById("Type13").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type13").disabled = true;
                        }
                    }
                    if (TYPE13 != "" && TYPE13 != "null" && TYPE13 != null && TYPE13 != undefined) {
                        // document.getElementById("Type13").disabled = true;
                    }
                }
                if (i == 13) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type14').val(TYPE14);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE14 == "" || TYPE14 == "null" || TYPE14 == null)) {
                                document.getElementById("Type14").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type14").disabled = true;

                                }
                                else {
                                    document.getElementById("Type14").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type14").disabled = true;
                        }
                    }
                    if (TYPE14 != "" && TYPE14 != "null" && TYPE14 != null && TYPE14 != undefined) {
                        // document.getElementById("Type14").disabled = true;
                    }
                }
                if (i == 14) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type15').val(TYPE15);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE15 == "" || TYPE15 == "null" || TYPE15 == null)) {
                                document.getElementById("Type15").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type15").disabled = true;

                                }
                                else {
                                    document.getElementById("Type15").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type15").disabled = true;
                        }
                    }
                    if (TYPE15 != "" && TYPE15 != "null" && TYPE15 != null && TYPE15 != undefined) {
                        // document.getElementById("Type15").disabled = true;
                    }
                }
                if (i == 15) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type16').val(TYPE16);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE16 == "" || TYPE16 == "null" || TYPE16 == null)) {
                                document.getElementById("Type16").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type16").disabled = true;

                                }
                                else {
                                    document.getElementById("Type16").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type16").disabled = true;
                        }
                    }
                    if (TYPE16 != "" && TYPE16 != "null" && TYPE16 != null && TYPE16 != undefined) {
                       //  document.getElementById("Type16").disabled = true;
                    }
                }
                if (i == 16) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type17').val(TYPE17);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE17 == "" || TYPE17 == "null" || TYPE17 == null)) {
                                document.getElementById("Type17").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type17").disabled = true;

                                }
                                else {
                                    document.getElementById("Type17").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type17").disabled = true;
                        }
                    }
                    if (TYPE17 != "" && TYPE17 != "null" && TYPE17 != null && TYPE17 != undefined) {
                        // document.getElementById("Type17").disabled = true;
                    }
                }
                if (i == 17) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type18').val(TYPE18);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE18 == "" || TYPE18 == "null" || TYPE18 == null)) {
                                document.getElementById("Type18").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type18").disabled = true;

                                }
                                else {
                                    document.getElementById("Type18").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type18").disabled = true;
                        }
                    }
                    if (TYPE18 != "" && TYPE18 != "null" && TYPE18 != null && TYPE18 != undefined) {
                        // document.getElementById("Type18").disabled = true;
                    }
                }
                if (i == 18) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type19').val(TYPE19);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE19 == "" || TYPE19 == "null" || TYPE19 == null)) {
                                document.getElementById("Type19").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type19").disabled = true;

                                }
                                else {
                                    document.getElementById("Type19").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type19").disabled = true;
                        }
                    }
                    if (TYPE19 != "" && TYPE19 != "null" && TYPE19 != null && TYPE19 != undefined) {
                        // document.getElementById("Type19").disabled = true;
                    }
                }
                if (i == 19) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                    $('#Type20').val(TYPE20);
                    for (var g = 0; g < res[i].TITLE.split(' ').length; g++) {
                        if (res[i].TITLE.split(' ')[g].split('-').length > 1) {
                            var start = res[i].TITLE.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].TITLE.split(' ')[g].split('-')[1].split(':')[0];
                            if (start < Datetime && (TYPE20 == "" || TYPE20 == "null" || TYPE20 == null)) {
                                document.getElementById("Type20").disabled = false;
                                break;
                            }
                            else {
                                if (Datetime < start || Datetime > end) {
                                    document.getElementById("Type20").disabled = true;

                                }
                                else {
                                    document.getElementById("Type20").disabled = false;
                                    break;
                                }
                            }
                        } else {
                            document.getElementById("Type20").disabled = true;
                        }
                    }
                    if (TYPE20 != "" && TYPE20 != "null" && TYPE20 != null && TYPE20 != undefined) {
                        // document.getElementById("Type20").disabled = true;
                    }
                }
            }

        }
    });
}

function Clear() {
    $("#mymodal1").modal('hide');
    $("#mymodal").modal('hide');
}

function insert1() {

    $("#mymodal1").modal('hide');
    var user = $("#user").text();
    var ID = $("#Id").val();
    var DN_NO = $("#Dnno1").val();
    var REMARK = $("#Remark").val();
    /*    var isAutoAssy = $("#isAutoAssy").is(':checked');*/

    var xz = document.getElementById("isAutoAssy");
    var isAutoAssy = xz.checked;


    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); var Type13 = $("#Type13").val(); var Type14 = $("#Type14").val(); var Type15 = $("#Type15").val();
    var Type16 = $("#Type16").val(); var Type17 = $("#Type17").val(); var Type18 = $("#Type18").val(); var Type19 = $("#Type19").val(); var Type20 = $("#Type20").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { DN_NO: DN_NO, REMARK: REMARK, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Type13: Type13, Type14: Type14, Type15: Type15, Type16: Type16, Type17: Type17, Type18: Type18, Type19: Type19, Type20: Type20, ID: ID, isAutoAssy: isAutoAssy, funcName: 'UpdateTemplateInfo11' },
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
                 show(DN_NO);
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                $("#mymodal").modal('hide');



                 show(DN_NO);
            }
        }
    });
}

function insert() {
    var user = $("#user").text();
    var ID = $("#Id").val();
    var DN_NO = $("#Dnno1").val();
    var REMARK = $("#Remark").val();
/*    var isAutoAssy = $("#isAutoAssy").is(':checked');*/

    var xz = document.getElementById("isAutoAssy");    
    var isAutoAssy = xz.checked;


    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); var Type13 = $("#Type13").val(); var Type14 = $("#Type14").val(); var Type15 = $("#Type15").val();
    var Type16 = $("#Type16").val(); var Type17 = $("#Type17").val(); var Type18 = $("#Type18").val(); var Type19 = $("#Type19").val(); var Type20 = $("#Type20").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { DN_NO: DN_NO, REMARK: REMARK, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Type13: Type13, Type14: Type14, Type15: Type15, Type16: Type16, Type17: Type17, Type18: Type18, Type19: Type19, Type20: Type20, ID: ID, isAutoAssy: isAutoAssy, funcName: 'UpdateTemplateInfo1' },
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
                show(DN_NO);
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                if (error_msg == "NG,输入值不在允许范围内!") {
                    $("#mymodal1").modal('show');
                }
                else {
                    swal({
                        text: error_msg,
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    })
                      $("#mymodal").modal('hide');
                }

               
              
                show(DN_NO);
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

function Add() {
    var user = $("#user").text();
    var Template = $("#Template").val();
    var PdlineName = $("#PdlineName").val();
 /*   var ProcessName = $("#ProcessName").val();*/
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (datetimepicker == "") {
        var error_msg = "日期为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    } if (dataType == "" || dataType == "--请选择--" ) {
        var error_msg = "班别为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Template == "") {
        var error_msg = "模板号为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    //if (ModelName == "") {
    //    var error_msg = "机种为空,请检查!";
    //    swal({
    //        text: error_msg,
    //        type: "error",
    //        confirmButtonColor: '#3085d6'
    //    })
    //    return;
    //}
    //if (ProcessName == "") {
    //    var error_msg = "制程为空,请检查!";
    //    swal({
    //        text: error_msg,
    //        type: "error",
    //        confirmButtonColor: '#3085d6'
    //    })
    //    return;
    //}
    if (PdlineName == "") {
        var error_msg = "线体为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { datetimepicker: datetimepicker, dataType: dataType, user: user, Template: Template, PdlineName: PdlineName, funcName: 'addTemplateInfo' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = "新增任务成功";
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
                GetDn_no();
                show(res[0].ERR_MSG);
                $("#Dnstatus").val("");
                document.getElementById("Template").value = "";
                document.getElementById("PdlineName").value = "";
                document.getElementById("dataType").value = "";       
               
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


function download() {
    var str = "";
    var Dnno = $("#Dnno").val();
    if (Dnno == "") {
        var error_msg = "请选择任务单号!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr>";
    var tableHtmlEnd = "</tr>";
    var LOG = "";

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { DN_NO:Dnno,funcName: 'GetTitle' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                qty = res.length;
                for (var i = 0; i < res.length; i++) {
                    var TYPE = "<td text-align:center>" + res[i].TITLE + "</td>";
                    LOG = LOG + TYPE;
                }
            }
        }
    });
    tableHtml = tableHtml + LOG + "</tr>";
    var row = "";
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O04.ashx",
        data: { DN_NO: Dnno, funcName: 'GetTitleNO' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                for (var i = 0; i < res.length; i++) {
                    if (qty == 9) {

                        row = "<tr ><td>" + res[i].TYPE1 + "</td><td>" + res[i].TYPE2 + "</td><td>" + res[i].TYPE3 + "</td><td>" + res[i].TYPE4 + "</td><td>" + res[i].TYPE5 + "</td><td>" + res[i].TYPE6 + "</td><td>" + res[i].TYPE7 + "</td><td>" + res[i].TYPE8 + "</td><td>" + res[i].TYPE9 + "</td></tr>";
                    }
                    if (qty == 10) {
                        row = "<tr><td>" + res[i].TYPE1 + "</td><td text-align:center>" + res[i].TYPE2 + "</td><td>" + res[i].TYPE3 + "</td><td>" + res[i].TYPE4 + "</td><td>" + res[i].TYPE5 + "</td><td>" + res[i].TYPE6 + "</td><td>" + res[i].TYPE7 + "</td><td>" + res[i].TYPE8 + "</td><td>" + res[i].TYPE9 + "</td><td>" + res[i].TYPE10 + "</td></tr>";
                    } if (qty == 11) {
                        row = "<tr><td>" + res[i].TYPE1 + "</td><td>" + res[i].TYPE2 + "</td><td>" + res[i].TYPE3 + "</td><td>" + res[i].TYPE4 + "</td><td>" + res[i].TYPE5 + "</td><td>" + res[i].TYPE6 + "</td><td>" + res[i].TYPE7 + "</td><td>" + res[i].TYPE8 + "</td><td>" + res[i].TYPE9 + "</td><td>" + res[i].TYPE10 + "</td><td>" + res[i].TYPE11 + "</td></tr>";
                    } if (qty == 12) {
                        row = "<tr><td>" + res[i].TYPE1 + "</td><td>" + res[i].TYPE2 + "</td><td>" + res[i].TYPE3 + "</td><td>" + res[i].TYPE4 + "</td><td>" + res[i].TYPE5 + "</td><td>" + res[i].TYPE6 + "</td><td>" + res[i].TYPE7 + "</td><td>" + res[i].TYPE8 + "</td><td>" + res[i].TYPE9 + "</td><td>" + res[i].TYPE10 + "</td><td>" + res[i].TYPE11 + "</td><td>" + res[i].TYPE12 + "</td></tr>";
                    } if (qty == 13) {
                        row = "<tr><td>" + res[i].TYPE1 + "</td><td>" + res[i].TYPE2 + "</td><td>" + res[i].TYPE3 + "</td><td>" + res[i].TYPE4 + "</td><td>" + res[i].TYPE5 + "</td><td>" + res[i].TYPE6 + "</td><td>" + res[i].TYPE7 + "</td><td>" + res[i].TYPE8 + "</td><td>" + res[i].TYPE9 + "</td><td>" + res[i].TYPE10 + "</td><td>" + res[i].TYPE11 + "</td><td>" + res[i].TYPE12 + "</td><td>" + res[i].TYPE13 + "</td></tr>";
                    } if (qty == 14) {
                        row = "<tr><td>" + res[i].TYPE1 + "</td><td>" + res[i].TYPE2 + "</td><td>" + res[i].TYPE3 + "</td><td>" + res[i].TYPE4 + "</td><td>" + res[i].TYPE5 + "</td><td>" + res[i].TYPE6 + "</td><td>" + res[i].TYPE7 + "</td><td>" + res[i].TYPE8 + "</td><td>" + res[i].TYPE9 + "</td><td>" + res[i].TYPE10 + "</td><td>" + res[i].TYPE11 + "</td><td>" + res[i].TYPE12 + "</td><td>" + res[i].TYPE13 + "</td><td>" + res[i].TYPE14 + "</td></tr>";
                    } if (qty == 15) {
                        row = "<tr><td>" + res[i].TYPE1 + "</td><td>" + res[i].TYPE2 + "</td><td>" + res[i].TYPE3 + "</td><td>" + res[i].TYPE4 + "</td><td>" + res[i].TYPE5 + "</td><td>" + res[i].TYPE6 + "</td><td>" + res[i].TYPE7 + "</td><td>" + res[i].TYPE8 + "</td><td>" + res[i].TYPE9 + "</td><td>" + res[i].TYPE10 + "</td><td>" + res[i].TYPE11 + "</td><td>" + res[i].TYPE12 + "</td><td>" + res[i].TYPE13 + "</td><td>" + res[i].TYPE14 + "</td><td>" + res[i].TYPE15 + "</td></tr>";
                    }
                    tableHtml += row;
                }
            }
        }
    });

    tableHtml += "</table></body></html>";
    var excelBlob = new Blob([tableHtml], {
        type: 'application/vnd.ms-excel'
    });
    var oa = document.createElement('a');
    oa.href = URL.createObjectURL(excelBlob);
    oa.download = Dnno+'.xls';
    document.body.appendChild(oa);
    oa.click();
}


//导出excel
function download1() {
    var Template = "";
    Template = $("#Dnno").val();
    if (Template == "") {
        var error_msg = "任务号为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    var blob = sheet2blob(XLSX.utils.table_to_sheet($('table')[0]));
    //设置链接
    var link = window.URL.createObjectURL(blob);
    var a = document.createElement("a");    //创建a标签
    a.download = Template+".xlsx";                //设置被下载的超链接目标（文件名）
    a.href = link;                            //设置a标签的链接
    document.body.appendChild(a);            //a标签添加到页面
    a.click();                                //设置a标签触发单击事件
    document.body.removeChild(a);            //移除a标签
}
// 将一个sheet转成最终的excel文件的blob对象，然后利用URL.createObjectURL下载
function sheet2blob(sheet, sheetName) {
    sheetName = sheetName || 'sheet1';
    var workbook = {
        SheetNames: [sheetName],
        Sheets: {}
    };
    workbook.Sheets[sheetName] = sheet;
    // 生成excel的配置项
    var wopts = {
        bookType: 'xlsx', // 要生成的文件类型
        bookSST: false, // 是否生成Shared String Table，官方解释是，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
        type: 'binary'
    };
    var wbout = XLSX.write(workbook, wopts);
    var blob = new Blob([s2ab(wbout)], { type: "application/octet-stream" });
    // 字符串转ArrayBuffer
    function s2ab(s) {
        var buf = new ArrayBuffer(s.length);
        var view = new Uint8Array(buf);
        for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
        return buf;
    }
    return blob;
}



function importExcel() {
    var fileUpload = $("#fileinp").get(0);
    var files = fileUpload.files;
    var data = new FormData();
    var user = $("#user").text();

    var Dnno = $("#Dnno").val();
    if (Dnno == "") {
        var error_msg = "请选择任务单号!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }


    if (files.length == 0) {
        alert("请先下载模板上传数据!!!");
        return;
    }
    for (var i = 0; i < files.length; i++) {
        data.append(files[i].name, files[i]);
    }
    var t = document.getElementById('txt');


    $.ajax({
        url: "../../../controller/OQC-QUALITY/O04.ashx?funcName=excel&user=" + user + "&DN_NO=" + Dnno + "&Path=" + files + "",
        type: "POST",
        data: data,
        async: false,
        contentType: false,
        processData: false,
        success: function (result) {
            if (result.substr(0, 2) == 'OK') {

                var error_msg = result;
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
            } else {

                var error_msg = result;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        },
    });
    document.getElementById("fileinp").value = "";
    GetShow();
}
