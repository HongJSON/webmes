$(document).ready(function () {
    //var user = "12650378";

    var user = getCookie("Mes3User");
    $('#user').text(user);
    $('#type').text("点检");
    GetBuNo();
    GetPdline();
    //GetTemplate();

})
function GetBuNo() {
    var user = $("#user").text();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { user: user, funcName: 'ShowBuNo' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $('#Section_Name').val(res[0].ERR_MSG);
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
function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
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
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { funcName: 'ShowTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TEMPLATE + "'>" + res[i].TEMPLATE + "</option>";
                }
                $("#ProjectName").html(str);
            }
        }
    });
}
function E09Keydown(event) {
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
            url: "../../../controller/OQC-QUALITY/E09.ashx",
            data: { JJ: JJ, funcName: 'ShowPdlineJJ' },
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

function ShowProcess() {
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { ModelName: ModelName, PdlineName: PdlineName, funcName: 'ShowProject' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
                }
                $("#ProjectName").html(str);
            } 
        }
    });
}

function ShowPdline() {
    var PdlineName = $("#PdlineName").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { PdlineName: PdlineName, funcName: 'ShowModel' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
                }
                $("#ModelName").html(str);
            } else {
                var error_msg = "此线体未维护机种对应上下线信息";
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });


    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { PdlineName: PdlineName, funcName: 'ShowProcess' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROCESS_NAME + "'>" + res[i].PROCESS_NAME + "</option>";
                }
                $("#ProcessName").html(str);
            }
        }
    });
}
//function ShowProject() {
//    var Section_Name = $("#Section_Name").val();
//    var PdlineName = $("#PdlineName").val();
//    var ProcessName = $("#ProcessName").val();
//    var Template = $("#Template").val();
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/E09.ashx",
//        data: { Section_Name: Section_Name, PdlineName: PdlineName, ProcessName:ProcessName,Template: Template, funcName: 'ShowProject' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res != null) {
//                var str = "<option value=''></option>";

//                for (var i = 0; i < res.length; i++) {
//                    str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
//                }
//                $("#ProjectName").html(str);
//            } else {
//                var error_msg = "此人员部门无操作此模板权限";
//                swal({
//                    text: error_msg,
//                    type: "error",
//                    confirmButtonColor: '#3085d6'
//                })
//            }
//        }
//    });
//}
function ShowTempLateQty() {
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    var ProjectName = $("#ProjectName").val();
    var dataType = $("#dataType").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { PdlineName: PdlineName, ModelName: ModelName, ProjectName: ProjectName, funcName: 'ShowTemplateData' },
        dataType: "json",
        async: false,
        success: function (res) {

            if (res.length == 0) {
                var error_msg = "未维护标题名称!";
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            }
            if (dataType == "白班") {
                for (var i = 0; i < res.length; i++) {
                    if (i == 0) {

                        Typ1 = res[i].CHECK_TIME.split(' ')[0];

                    }
                    if (i == 1) {
                        Typ2 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 2) {
                        Typ3 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 3) {
                        Typ4 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 4) {
                        Typ5 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 5) {
                        Typ6 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 6) {
                        Typ7 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 7) {
                        Typ8 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 8) {
                        Typ9 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 9) {
                        Typ10 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 10) {
                        Typ11 = res[i].CHECK_TIME.split(' ')[0];
                    }
                    if (i == 11) {
                        Typ12 = res[i].CHECK_TIME.split(' ')[0];
                    }
                }

            }
            if (dataType == "夜班") {
                for (var i = 0; i < res.length; i++) {
                    if (i == 0) {

                        Typ1 = res[i].CHECK_TIME.split(' ')[1];

                    }
                    if (i == 1) {
                        Typ2 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 2) {
                        Typ3 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 3) {
                        Typ4 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 4) {
                        Typ5 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 5) {
                        Typ6 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 6) {
                        Typ7 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 7) {
                        Typ8 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 8) {
                        Typ9 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 9) {
                        Typ10 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 10) {
                        Typ11 = res[i].CHECK_TIME.split(' ')[1];
                    }
                    if (i == 11) {
                        Typ12 = res[i].CHECK_TIME.split(' ')[1];
                    }
                }

            }

            TemplateQty = res.length;
        }
    });
}
var TemplateQty;
var Typ1; var Typ2; var Typ3; var Typ4; var Typ5; var Typ6; var Typ7; var Typ8; var Typ9;
var Typ10; var Typ11; var Typ12; var Typ13; var Typ14; var Typ15; var Typ16; var Typ17; var Typ18;
var Typ19; var Typ20;
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
function GetDate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { funcName: 'GetDate' },
        dataType: "json",
        async: false,
        success: function (res) {
            $("#datetimepicker").val(res[0].ERR_MSG);
            $("#dataType").val(res[0].ERR_CODE);
            Datetime = res[0].ERR_TIME;
        }
    });
}
function GetProcess() {
    var user = $("#user").text();
    var type = $("#type").text();
    var ProjectName = $("#ProjectName").val();
    var Section_Name = $("#Section_Name").val();
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (dataType == "--请选择--") {
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
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ProjectName == "") {
        var error_msg = "请选择项目名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    ShowTempLateQty();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { ModelName: ModelName, type: type, user: user, datetimepicker: datetimepicker, dataType: dataType, PdlineName: PdlineName, Section_Name: Section_Name, ProjectName: ProjectName, funcName: 'GetProcess' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $('#DnNo').val(res[0].ERR_MSG);
                Show();
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

function Show() {
    var DnNo = $("#DnNo").val();
    var ProjectName = $("#ProjectName").val();
    var Section_Name = $("#Section_Name").val();


    if (TemplateQty == 1) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            // height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },

            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
  ,]
        });
    }
    if (TemplateQty == 2) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },
                { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            ]
        });
    }
    if (TemplateQty == 3) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },

                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },

           ]
        });
    }
    if (TemplateQty == 4) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },

                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },

            ]
        });
    }
    if (TemplateQty == 5) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            // height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },

                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },

           ]
        });
    }
    if (TemplateQty == 6) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');


        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },

           ]
        });
    }
    if (TemplateQty == 7) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },

            ]
        });
    }
    if (TemplateQty == 8) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            // height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 20, },

           ]
        });
    }
    if (TemplateQty == 9) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, }, { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 20, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 20, },

            ]
        });
    }
    if (TemplateQty == 10) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, }, { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 20, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 20, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 20, },

            ]
        });
    }
    if (TemplateQty == 11) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, }, { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 20, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 20, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 20, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 20, },

            ]
        });
    }
    if (TemplateQty == 12) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 20, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 20, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 20, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 20, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 20, },

            ]
        });
    }
    if (TemplateQty == 13) {
        var url = "../../../controller/OQC-QUALITY/E09.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            //height: 800,        //就是这里，加上就可以固定表头
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 1000,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
                { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
                { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
                { field: 'UNIT', title: '单位', align: 'center', width: 20, },
                { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
                { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
                { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },{ field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 20, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 20, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 20, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 20, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 20, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 20, },

            ]
        });
    }

}
function addAutoAssy(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}
function SelectShow() {
    var user = $("#user").text();
    var type = $("#type").text();
    var ProjectName = $("#ProjectName").val();
    var Section_Name = $("#Section_Name").val();
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (dataType == "--请选择--") {
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
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ProjectName == "") {
        var error_msg = "请选择项目名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    ShowTempLateQty();
    Show();
}

function SelectDown() {
    var user = $("#user").text();
    var ProjectName = $("#ProjectName").val();
    var Section_Name = $("#Section_Name").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var ModelName = $("#ModelName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (dataType == "--请选择--") {
        var error_msg = "请选择班别!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ModelName == "") {
        var error_msg = "请选择机种!";
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
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { PdlineName: PdlineName, ModelName: ModelName, dataType: dataType, datetimepicker: datetimepicker, funcName: 'ShowDown' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var excelBlob = new Blob([res[0].ERR_MSG], {
                    type: 'application/vnd.ms-excel'
                });
                var oa = document.createElement('a');
                oa.href = URL.createObjectURL(excelBlob);
                oa.download = ModelName + "_" + PdlineName + '.xls';
                document.body.appendChild(oa);
                oa.click();
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



window.operateDownEvents = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        $("#mymodal").modal('show');
        PTYPE1 = row.NUMBER_ID;
        PTYPE2 = row.WORK_NO;
        PTYPE3 = row.PROJECT_NAME;
        $('#Remark').val(row.REMARK);
        $('#Check_No').val(row.CHECK_NO);
        $('#Check_Name').val(row.CHECK_NAME);
        $('#Check_Item').val(row.CHECK_ITEM);
        $('#Unit').val(row.UNIT);
        $('#Check_Qty').val(row.CHECK_QTY);
        $('#Upper').val(row.UPPER);
        $('#Floor').val(row.FLOOR);
        //$('#Id').val(row.NUMBER_ID);
        //$('#Mo').val(row.WORK_NO);
        //$('#Tel').val(row.TEMPLATE);
        //$('#Pro').val(row.PROJECT_NAME);
        //$('#workt').val(row.WORK_DATE);
        //$('#banbie').val(row.WORK_TYPE);
        $("#TYPE1").hide(); $("#TYPE2").hide(); $("#TYPE3").hide(); $("#TYPE4").hide(); $("#TYPE5").hide();
        $("#TYPE6").hide(); $("#TYPE7").hide(); $("#TYPE8").hide(); $("#TYPE9").hide(); $("#TYPE10").hide();
        $("#TYPE11").hide(); $("#TYPE12").hide();
        for (var i = 1; i <= TemplateQty; i++) {
            var Type = "TYPE";
            Type = Type + i;
            $("#" + Type + "").show();
        }
        GetLabel(row.PROJECT_NAME, row.WORK_NO, row.TYPE1, row.TYPE2, row.TYPE3, row.TYPE4, row.TYPE5, row.TYPE6, row.TYPE7, row.TYPE8, row.TYPE9, row.TYPE10, row.TYPE11, row.TYPE12);
    }
}
var Datetime;
function GetLabel(PROJECT_NAME, WORK_NO, TYPE1, TYPE2, TYPE3, TYPE4, TYPE5, TYPE6, TYPE7, TYPE8, TYPE9, TYPE10, TYPE11, TYPE12) {


    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    var ProjectName = $("#ProjectName").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { funcName: 'GetDate' },
        dataType: "json",
        async: false,
        success: function (res) {
            Datetime = res[0].ERR_TIME;
        }
    });


    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { PdlineName: PdlineName, ModelName:ModelName,ProjectName: PROJECT_NAME, funcName: 'ShowTemplateData' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            var Type = "Typ";
            for (var i = 0; i < res.length; i++) {

                if (i == 0) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type1').val(TYPE1);

                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];

                            //if (start < Datetime && (TYPE1 == "" || TYPE1 == "null" || TYPE1 == null)) {
                            //    document.getElementById("Type1").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type1").disabled = true;

                            }
                            else {
                                document.getElementById("Type1").disabled = false;
                                break;
                            }
                            /* }*/
                        }
                        else {
                            document.getElementById("Type1").disabled = true;
                        }
                    }
                }
                if (i == 1) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type2').val(TYPE2);
          
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE2 == "" || TYPE2 == "null" || TYPE2 == null)) {
                            //    document.getElementById("Type2").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type2").disabled = true;

                            }
                            else {
                                document.getElementById("Type2").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type3').val(TYPE3);
                  
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE3 == "" || TYPE3 == "null" || TYPE3 == null)) {
                            //    document.getElementById("Type3").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type3").disabled = true;

                            }
                            else {
                                document.getElementById("Type3").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type4').val(TYPE4);
                
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE4 == "" || TYPE4 == "null" || TYPE4 == null)) {
                            //    document.getElementById("Type4").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type4").disabled = true;

                            }
                            else {
                                document.getElementById("Type4").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type5').val(TYPE5);
               
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE5 == "" || TYPE5 == "null" || TYPE5 == null)) {
                            //    document.getElementById("Type5").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type5").disabled = true;

                            }
                            else {
                                document.getElementById("Type5").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type6').val(TYPE6);
                  
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE6 == "" || TYPE6 == "null" || TYPE6 == null)) {
                            //    document.getElementById("Type6").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type6").disabled = true;

                            }
                            else {
                                document.getElementById("Type6").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type7').val(TYPE7);
                
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE7 == "" || TYPE7 == "null" || TYPE7 == null)) {
                            //    document.getElementById("Type7").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type7").disabled = true;

                            }
                            else {
                                document.getElementById("Type7").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type8').val(TYPE8);
                
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE8 == "" || TYPE8 == "null" || TYPE8 == null)) {
                            //    document.getElementById("Type8").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type8").disabled = true;

                            }
                            else {
                                document.getElementById("Type8").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type9').val(TYPE9);
                  
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE9 == "" || TYPE9 == "null" || TYPE9 == null)) {
                            //    document.getElementById("Type9").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type9").disabled = true;

                            }
                            else {
                                document.getElementById("Type9").disabled = false;
                                break;
                            }
                            /*  }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type10').val(TYPE10);
                  
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE10 == "" || TYPE10 == "null" || TYPE10 == null)) {
                            //    document.getElementById("Type10").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type10").disabled = true;

                            }
                            else {
                                document.getElementById("Type10").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type11').val(TYPE11);
                  
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE11 == "" || TYPE11 == "null" || TYPE11 == null)) {
                            //    document.getElementById("Type11").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type11").disabled = true;

                            }
                            else {
                                document.getElementById("Type11").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type12').val(TYPE12);
                   
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE12 == "" || TYPE12 == "null" || TYPE12 == null)) {
                            //    document.getElementById("Type12").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type12").disabled = true;

                            }
                            else {
                                document.getElementById("Type12").disabled = false;
                                break;
                            }
                            /* }*/
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
                    $("#" + TYPE + "").text(res[i].CHECK_TIME);
                    $('#Type13').val(TYPE13);
                  
                    for (var g = 0; g < res[i].CHECK_TIME.split(' ').length; g++) {
                        if (res[i].CHECK_TIME.split(' ')[g].split('-').length > 1) {
                            var start = res[i].CHECK_TIME.split(' ')[g].split('-')[0].split(':')[0];
                            var end = res[i].CHECK_TIME.split(' ')[g].split('-')[1].split(':')[0];
                            //if (start < Datetime && (TYPE13 == "" || TYPE13 == "null" || TYPE13 == null)) {
                            //    document.getElementById("Type13").disabled = false;
                            //    break;
                            //}
                            //else {
                            if (Datetime < start || Datetime >= end) {
                                document.getElementById("Type13").disabled = true;

                            }
                            else {
                                document.getElementById("Type13").disabled = false;
                                break;
                            }
                            /*  }*/
                        } else {
                            document.getElementById("Type13").disabled = true;
                        }
                    }
                    if (TYPE13 != "" && TYPE13 != "null" && TYPE13 != null && TYPE13 != undefined) {
                        // document.getElementById("Type13").disabled = true;
                    }
                }
            }

        }
    });
}

var PTYPE1;
var PTYPE2;
var PTYPE3;

function insert() {
    var user = $("#user").text();
    var ID = PTYPE1;
    var DnNo = PTYPE2;
    var Pro = PTYPE3;
    var Remark = $("#Remark").val();
    var ModelName = $("#ModelName").val();
    var Check_No = $("#Check_No").val();
    var Check_Name = $("#Check_Name").val();
    var Check_Item = $("#Check_Item").val();
    var Unit = $("#Unit").val();
    var Check_Qty = $("#Check_Qty").val();
    var Upper = $("#Upper").val();
    var Floor = $("#Floor").val();
    //var ID = $("#Id").val();
    //var DnNo = $("#Mo").val();
    //var Pro = $("#Pro").val();
    var Section_Name = $("#Section_Name").val();
    var xz = document.getElementById("isAutoAssy");
    var isAutoAssy = xz.checked;

    //var xz = document.getElementById("isAutoAssy");
    //var isAutoAssy = xz.checked;
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); 
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { Check_No: Check_No, Check_Name: Check_Name, Check_Item: Check_Item, Unit: Unit, Check_Qty: Check_Qty, Upper: Upper, Floor: Floor, ModelName: ModelName, Remark: Remark, Section_Name: Section_Name, isAutoAssy: isAutoAssy, TemplateQty: TemplateQty, Pro: Pro, DnNo: DnNo, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, ID: ID, funcName: 'UpdateTemplateInfo1' },
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
                Show();
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
                    Show();
                }





                //var error_msg = res[0].ERR_MSG;

                //    swal({
                //        text: error_msg,
                //        type: "error",
                //        confirmButtonColor: '#3085d6'
                //    })
                //    $("#mymodal").modal('hide');

            }
        }
    });

}


function Save() {
    var user = $("#user").text();
    var ID = $("#Id").val();
    var DnNo = $("#Mo").val();
    var Pro = $("#Pro").val();

    //var xz = document.getElementById("isAutoAssy");
    //var isAutoAssy = xz.checked;
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); var Type13 = $("#Type13").val(); var Type14 = $("#Type14").val(); var Type15 = $("#Type15").val();
    var Type16 = $("#Type16").val(); var Type17 = $("#Type17").val(); var Type18 = $("#Type18").val(); var Type19 = $("#Type19").val(); var Type20 = $("#Type20").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { TemplateQty: TemplateQty, Pro: Pro, DnNo: DnNo, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Type13: Type13, Type14: Type14, Type15: Type15, Type16: Type16, Type17: Type17, Type18: Type18, Type19: Type19, Type20: Type20, ID: ID, funcName: 'Save' },
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
                Show();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;

                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal").modal('hide');
                Show();
            }
        }
    });

}
function Clear() {
    $("#mymodal1").modal('hide');
    $("#mymodal").modal('hide');
}
function insert1() {
    var user = $("#user").text();
    var ID = PTYPE1;
    var DnNo = PTYPE2;
    var Pro = PTYPE3;
    var xz = document.getElementById("isAutoAssy");
    var isAutoAssy = xz.checked;
    var Section_Name = $("#Section_Name").val();
    var Remark = $("#Remark").val();
    var ModelName = $("#ModelName").val();
    var Check_No = $("#Check_No").val();
    var Check_Name = $("#Check_Name").val();
    var Check_Item = $("#Check_Item").val();
    var Unit = $("#Unit").val();
    var Check_Qty = $("#Check_Qty").val();
    var Upper = $("#Upper").val();
    var Floor = $("#Floor").val();
    var PdlineName = $("#PdlineName").val();


    //var xz = document.getElementById("isAutoAssy");
    //var isAutoAssy = xz.checked;
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); 
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E09.ashx",
        data: { PdlineName:PdlineName,ModelName: ModelName, Remark: Remark, Section_Name: Section_Name, isAutoAssy: isAutoAssy, TemplateQty: TemplateQty, Pro: Pro, DnNo: DnNo, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Check_No: Check_No, Check_Name: Check_Name, Check_Item: Check_Item, Unit: Unit, Check_Qty: Check_Qty, Upper: Upper, Floor: Floor, ModelName: ModelName, ID: ID, funcName: 'UpdateTemplateInfo1L' },
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
                $("#mymodal1").modal('hide');
                Show();
            }
            else if (res[0].ERR_CODE == "Y") {

                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal").modal('hide');
                $("#mymodal1").modal('hide');

                Show();
            }





            //var error_msg = res[0].ERR_MSG;

            //    swal({
            //        text: error_msg,
            //        type: "error",
            //        confirmButtonColor: '#3085d6'
            //    })
            //    $("#mymodal").modal('hide');

        }
    });
}

