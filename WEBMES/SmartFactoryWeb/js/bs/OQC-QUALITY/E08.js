$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    $('#type').text("异常");
    GetBuNo();
    GetDn_no();
})

function GetBuNo() {
    var user = $("#user").text();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E08.ashx",
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
function GetDn_no() {
    var user = $("#user").text();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E08.ashx",
        data: { user: user, funcName: 'ShowDnno' },
        dataType: "json",
        async: false,


        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";
                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].WORK_NO + "'>" + res[i].WORK_NO + "</option>";
                }
                $("#Dnno").html(str);
            }
        }
    });
}
function GetShow() {
    var Dnno = $("#Dnno").val();
    ShowTempLateQty(Dnno);
    Show();
}
var TemplateQty;
var Typ1; var Typ2; var Typ3; var Typ4; var Typ5; var Typ6; var Typ7; var Typ8; var Typ9;
var Typ10; var Typ11; var Typ12; var Typ13; var Typ14; var Typ15; var Typ16; var Typ17; var Typ18;
var Typ19; var Typ20;

function ShowTempLateQty(Dnno) {
    //var DnNo = $("#DnNo").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E08.ashx",
        data: { DN_NO: Dnno, funcName: 'ShowTemplateData' },
        dataType: "json",
        async: false,
        success: function (res) {
            for (var i = 0; i < res.length; i++) {
                if (i == 0) {
                    Typ1 = res[i].CHECK_TIME;
                }
                if (i == 1) {
                    Typ2 = res[i].CHECK_TIME;
                }
                if (i == 2) {
                    Typ3 = res[i].CHECK_TIME;
                }
                if (i == 3) {
                    Typ4 = res[i].CHECK_TIME;
                }
                if (i == 4) {
                    Typ5 = res[i].CHECK_TIME;
                }
                if (i == 5) {
                    Typ6 = res[i].CHECK_TIME;
                }
                if (i == 6) {
                    Typ7 = res[i].CHECK_TIME;
                }
                if (i == 7) {
                    Typ8 = res[i].CHECK_TIME;
                }
                if (i == 8) {
                    Typ9 = res[i].CHECK_TIME;
                }
                if (i == 9) {
                    Typ10 = res[i].CHECK_TIME;
                }
                if (i == 10) {
                    Typ11 = res[i].CHECK_TIME;
                }
                if (i == 11) {
                    Typ12 = res[i].CHECK_TIME;
                }
                if (i == 12) {
                    Typ13 = res[i].CHECK_TIME;
                }
                if (i == 13) {
                    Typ14 = res[i].CHECK_TIME;
                }
                if (i == 14) {
                    Typ15 = res[i].CHECK_TIME;
                }
                if (i == 15) {
                    Typ16 = res[i].CHECK_TIME;
                }
                if (i == 16) {
                    Typ17 = res[i].CHECK_TIME;
                }
                if (i == 17) {
                    Typ18 = res[i].CHECK_TIME;
                }
                if (i == 18) {
                    Typ19 = res[i].CHECK_TIME;
                }
                if (i == 19) {
                    Typ20 = res[i].CHECK_TIME;
                }
            }
            TemplateQty = res.length;
        }
    });
}

function Show() {
    var DnNo = $("#Dnno").val();
    var ProjectName = $("#ProjectName").val();

    if (TemplateQty == 1) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 2) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 3) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 4) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 5) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, }, { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 6) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 7) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 8) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, }, { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 20, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 20, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 20, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 20, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 20, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 20, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 9) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 10) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 11) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 12) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: 'TYPE12', title: Typ12, align: 'center', width: 20, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 13) {
        var url = "../../../controller/OQC-QUALITY/E08.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: 'TYPE12', title: Typ12, align: 'center', width: 20, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 20, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
}


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
        url: "../../../controller/OQC-QUALITY/E08.ashx",
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




function addAutoAssy(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}

window.operateDownEvents = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        let TYPE = $("#type").text();
        console.log(user);
        $("#mymodal").modal('show');
        $('#Id').val(row.NUMBER_ID);
        $('#Dnno1').val(row.WORK_NO);
        $('#Class').val(row.WORK_TYPE);
        $('#Date').val(row.WORK_DATE);
        $("#Pdline").val(row.PDLINE_NAME);
        $("#Terminal").val(row.PROCESS_NAME);
        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/E08.ashx",
            data: { funcName: 'GetType' },
            dataType: "json",
            async: false,
            success: function (res) {
                $("#Datew").val(res[0].WEEKDATE);
            }
        });
        document.getElementById("Class").disabled = true;
        document.getElementById("Terminal").disabled = true;
        document.getElementById("Pdline").disabled = true;
        document.getElementById("Date").disabled = true;
        document.getElementById("Datew").disabled = true;

        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/E08.ashx",
            data: { user: user, funcName: 'GetUserType' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res[0].USERTYPE == "点检" || res[0].USERTYPE == "点检修改") {

                    document.getElementById("StartTime").disabled = true;
                    document.getElementById("Analysis").disabled = true;
                    document.getElementById("Improvement").disabled = true;
                }
                if (res[0].USERTYPE == "异常") {

                    $.ajax({
                        method: "post",
                        url: "../../../controller/OQC-QUALITY/E08.ashx",
                        data: { DN_NO: row.WORK_NO, user: user, ID: row.NUMBER_ID, funcName: 'GetTypeDn' },
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
function insert() {
    var user = $("#user").text();
    var ID = $("#Id").val();
    var Dnno = $("#Dnno1").val();
    var Date = $("#Date").val();
    var Datew = $("#Datew").val();
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
        url: "../../../controller/OQC-QUALITY/E08.ashx",
        data: { DN_NO: Dnno, user: user, funcName: 'GetUserType' },
        dataType: "json",
        async: false,
        success: function (res) {
            USERTYPE = res[0].USERTYPE;
        }
    });
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E08.ashx",
        data: { USERTYPE: USERTYPE, Auditors: Auditors, Status: Status, Followup: Followup, FinishTime: FinishTime, StartTime: StartTime, Director: Director, Person: Person, ID: ID, DN_NO: Dnno, user: user, Date: Date, Datew: Datew,wf: wf, Pdline: Pdline, Class: Class, Terminal: Terminal, Abnormal: Abnormal, Analysis: Analysis, Improvement: Improvement, Category: Category, funcName: 'UpdateTemplateInfo1' },
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
                GetDn_no();
                Show();
            }
        }
    });

}


