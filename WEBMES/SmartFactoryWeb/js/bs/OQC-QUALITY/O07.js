$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    //GetModel();
    //GetPdline();
    //GetTemplate();
    GetDn_no();
})


$(function () {
    $("#FinishTime").datetimepicker({
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
});
$(function () {
    $("#StartTime").datetimepicker({
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

function GetDate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O07.ashx",
        data: { funcName: 'GetDate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#StartTime").val(res[0].ERR_MSG);
                $("#FinishTime").val(res[0].ERR_MSG);
            }
        }
    });
}

//function SelectDnno() {
//    GetDn_no();
//}


//function O07Keydown(event) {
//    var e = event || window.event || arguments.callee.caller.arguments[0];
//    if (event.keyCode == "13") {
//        var JJ = $("#JJ").val()

//        if (JJ == '') {
//            var error_msg = "请输入机种!";
//            swal({
//                text: error_msg,
//                type: "error",
//                confirmButtonColor: '#3085d6'
//            })
//            return;
//        }

//        $.ajax({
//            method: "post",
//            url: "../../../controller/OQC-QUALITY/O07.ashx",
//            data: { JJ: JJ, funcName: 'ShowModelJJ' },
//            dataType: "json",
//            async: false,
//            success: function (res) {
//                if (res != null) {
//                    var str = "<option value=''></option>";

//                    for (var i = 0; i < res.length; i++) {
//                        str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
//                    }
//                    $("#ModelName").html(str);
//                    $('#JJ').val("");
//                }
//            }
//        });
//    }
//}

//function GetDate() {
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/O07.ashx",
//        data: { funcName: 'GetDate' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res[0].ERR_CODE == "N") {
//                $("#datetimepicker").val(res[0].ERR_MSG);
//            }
//        }
//    });
//}

//$(function () {
//    $("#datetimepicker").datetimepicker({
//        format: 'yyyy-mm-dd',
//        language: 'zh-CN',
//        weekStart: 1,
//        todayBtn: 1,//显示‘今日’按钮
//        autoclose: 1,
//        todayHighlight: 1,
//        startView: 2,
//        minView: 2,
//        linked: true,
//        /*        startDate: new Date(),*/
//        clearBtn: true,//清除按钮
//        forceParse: 0
//    });
//    GetDate();
//});
//function GetModel() {
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/O07.ashx",
//        data: { funcName: 'ShowModel' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res != null) {
//                var str = "<option value=''></option>";

//                for (var i = 0; i < res.length; i++) {
//                    str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
//                }
//                $("#ModelName").html(str);
//            }
//        }
//    });
//}
//function GetPdline() {
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/O07.ashx",
//        data: { funcName: 'ShowPdline' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res != null) {
//                var str = "<option value=''></option>";

//                for (var i = 0; i < res.length; i++) {
//                    str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
//                }
//                $("#PdlineName").html(str);
//            }
//        }
//    });
//}
//function GetTemplate() {
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/O07.ashx",
//        data: { funcName: 'ShowTemplate' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res != null) {
//                var str = "<option value=''></option>";

//                for (var i = 0; i < res.length; i++) {
//                    str += "<option value='" + res[i].TEMPLATE + "'>" + res[i].TEMPLATE + "</option>";
//                }
//                $("#Template").html(str);
//            }
//        }
//    });
//}
function GetDn_no() {
    //var Template = $("#Template").val();
    //var ModelName = $("#ModelName").val();
    //var PdlineName = $("#PdlineName").val();
    ////var ProcessName = $("#ProcessName").val();
    //var datetimepicker = document.getElementById("datetimepicker").value;
    /*    var dataType = $("#dataType").val();*/


    var user = $("#user").text();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O07.ashx",

        //data: { Template: Template, ModelName: ModelName, PdlineName: PdlineName, datetimepicker: datetimepicker, dataType: dataType, funcName: 'ShowDnno' },
        data: { user: user,funcName: 'ShowDnno' },
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
            //document.getElementById("Template").value = "";
            //document.getElementById("ModelName").value = "";
            //document.getElementById("PdlineName").value = "";
            //document.getElementById("dataType").value = "";
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
    //var datetimepicker = document.getElementById("datetimepicker").value;
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
        url: "../../../controller/OQC-QUALITY/O07.ashx",
        data: { DN_NO: Dnno, funcName: 'GetDnnoType' },
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
        url: "../../../controller/OQC-QUALITY/O07.ashx",
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
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 2) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 3) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 4) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 5) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 6) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 7) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 8) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 9) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 10) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 11) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 12) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 13) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 14) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 15) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center', width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 16) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center', width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center', width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 17) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center', width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center', width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center', width: 100 },
            { field: 'TYPE17', title: TYPE17, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 18) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center', width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center', width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center', width: 100 },
            { field: 'TYPE17', title: TYPE17, align: 'center', width: 100 },
            { field: 'TYPE18', title: TYPE18, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 19) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center', width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center', width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center', width: 100 },
            { field: 'TYPE17', title: TYPE17, align: 'center', width: 100 },
            { field: 'TYPE18', title: TYPE18, align: 'center', width: 100 },
            { field: 'TYPE19', title: TYPE19, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (QTY == 20) {
        var url = "../../../controller/OQC-QUALITY/O07.ashx?funcName=show&&dataType=" + dataType + "&&DN_NO=" + Dnno + "&&Template=" + Template;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            height: 800,        //就是这里，加上就可以固定表头

            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 50,
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'DN_NO', title: '任务号', width: 200 },
            //{ field: 'YEAR_DATE', title: '日期', width: 100 },
            { field: 'CLASS', title: '班别', align: 'center', width: 50 },
            { field: 'TYPE1', title: TYPE1, align: 'center', width: 50 },
            { field: 'TYPE2', title: TYPE2, width: 100 },
            { field: 'TYPE3', title: TYPE3, align: 'center', width: 50 },
            { field: 'TYPE4', title: TYPE4, width: 250 },
            { field: 'TYPE5', title: TYPE5, align: 'center', width: 100 },
            { field: 'TYPE6', title: TYPE6, align: 'center', width: 100 },
            { field: 'TYPE7', title: TYPE7, align: 'center', width: 100 },
            { field: 'TYPE8', title: TYPE8, align: 'center', width: 100 },
            { field: 'TYPE9', title: TYPE9, align: 'center', width: 100 },
            { field: 'TYPE10', title: TYPE10, align: 'center', width: 100 },
            { field: 'TYPE11', title: TYPE11, align: 'center', width: 100 },
            { field: 'TYPE12', title: TYPE12, align: 'center', width: 100 },
            { field: 'TYPE13', title: TYPE13, align: 'center', width: 100 },
            { field: 'TYPE14', title: TYPE14, align: 'center', width: 100 },
            { field: 'TYPE15', title: TYPE15, align: 'center', width: 100 },
            { field: 'TYPE16', title: TYPE16, align: 'center', width: 100 },
            { field: 'TYPE17', title: TYPE17, align: 'center', width: 100 },
            { field: 'TYPE18', title: TYPE18, align: 'center', width: 100 },
            { field: 'TYPE19', title: TYPE19, align: 'center', width: 100 },
            { field: 'TYPE20', title: TYPE20, align: 'center', width: 100 },

            //{ field: 'CREATE_DATE', title: '创建时间', width: 100 },
            { field: 'EMP_NAME', title: '创建人员', width: 100 },
            { field: '编辑', title: '编辑', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
}

function addAutoAssy(value, row, index) {
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
        $('#Class').val(row.CLASS);
        $('#Terminal').val(row.TYPE2);







        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/O07.ashx",
            data: { DN_NO: row.DN_NO, user: user, funcName: 'GetType' },
            dataType: "json",
            async: false,
            success: function (res) {
                $("#Model").val(res[0].MODEL_NAME);
                $("#Pdline").val(res[0].PDLINE_NAME);
                $("#Date").val(res[0].DATE);
                //$("#Text3").val(dt[0].USEREMPNAME);
                $("#Datew").val(res[0].WEEKDATE);
            }
        });
        document.getElementById("Class").disabled = true;
        document.getElementById("Terminal").disabled = true;
        document.getElementById("Model").disabled = true;
        document.getElementById("Pdline").disabled = true;
        document.getElementById("Date").disabled = true;
        document.getElementById("Datew").disabled = true;


        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/O07.ashx",
            data: { DN_NO: row.DN_NO, user: user, funcName: 'GetUserType' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res[0].USERTYPE == "点检人FACA权限") {

                    document.getElementById("StartTime").disabled = true;
                    document.getElementById("Analysis").disabled = true;
                    document.getElementById("Improvement").disabled = true;
                }
                if (res[0].USERTYPE == "FACA人权限") {

                    $.ajax({
                        method: "post",
                        url: "../../../controller/OQC-QUALITY/O07.ashx",
                        data: { DN_NO: row.DN_NO, user: user, ID: row.ID, funcName: 'GetTypeDn' },
                        dataType: "json",
                        async: false,
                        success: function (res) {
                            if (res[0].ERR_CODE == "Y") {
                                swal({
                                    text: "该单号点检人还未填写",
                                    type: "error",
                                    confirmButtonColor: '#3085d6'
                                })
                                $("#mymodal").modal('hide');
                            }
                            $("#wf").val(res[0].WF);
                            $("#Abnormal").val(res[0].ABNORMAL);
                            $("#Person").val(res[0].PERSON);
                            //$("#Text3").val(dt[0].USEREMPNAME);
                            $("#Director").val(res[0].DIRECTOR);
                            $("#FinishTime").val(res[0].FINISHTIME);
                            $("#Category").val(res[0].CATEGORY);
                            $("#Followup").val(res[0].FOLLOWUP);
                            $("#Status").val(res[0].STATUS);
                            $("#Auditors").val(res[0].AUDITORS);
                        }
                    });


                    document.getElementById("wf").disabled = true;
                    document.getElementById("Abnormal").disabled = true;
                    document.getElementById("Person").disabled = true;
                    document.getElementById("Director").disabled = true;
                    document.getElementById("FinishTime").disabled = true;
                    document.getElementById("Category").disabled = true;
                    document.getElementById("Followup").disabled = true;
                    document.getElementById("Status").disabled = true;
                    document.getElementById("Auditors").disabled = true;
                }
            }
        });




    }
}

function defete() {
    var user = $("#user").text();
    var ID = $("#Id").val();
    var Dnno = $("#Dnno1").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O07.ashx",
        data: { ID: ID, DN_NO: Dnno, user: user ,funcName: 'defete' },
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

                GetDn_no();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal").modal('hide');
                GetDn_no();
            }
        }
    });
}


function insert() {
    var user = $("#user").text();
    var ID = $("#Id").val();
    var Dnno = $("#Dnno1").val();
    var Date = $("#Date").val();
    var Datew = $("#Datew").val();
    var Model = $("#Model").val();
    var wf = $("#wf").val();
    var Pdline = $("#Pdline").val();
    var Class = $("#Class").val();
    var Terminal = $("#Terminal").val();
    var Abnormal = $("#Abnormal").val();
    var Analysis = $("#Analysis").val();
    var Improvement = $("#Improvement").val();
    var Category = $("#Category").val();
    var Person = $("#Person").val();
    var Director = $("#Director").val();
    //var StartTime = $("#StartTime").val();
    //var FinishTime = $("#FinishTime").val();
    var StartTime = document.getElementById("StartTime").value;
    var FinishTime = document.getElementById("FinishTime").value;
    var Followup = $("#Followup").val();
    var Status = $("#Status").val();
    var Auditors = $("#Auditors").val();
    var USERTYPE = "";
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O07.ashx",
        data: { DN_NO: Dnno, user: user, funcName: 'GetUserType' },
        dataType: "json",
        async: false,
        success: function (res) {
            USERTYPE = res[0].USERTYPE;
        }
    });
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O07.ashx",
        data: { USERTYPE: USERTYPE, Auditors: Auditors, Status: Status, Followup: Followup, FinishTime: FinishTime, StartTime: StartTime, Director: Director, Person: Person, ID: ID, DN_NO: Dnno, user: user, Date: Date, Datew: Datew, Model: Model, wf: wf, Pdline: Pdline, Class: Class, Terminal: Terminal, Abnormal: Abnormal, Analysis: Analysis, Improvement: Improvement, Category: Category, funcName: 'UpdateTemplateInfo1' },
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

                GetDn_no();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal").modal('hide');
                GetDn_no();
            }
        }
    });

}


