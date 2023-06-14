$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetTemplate();
    GetBuName();
    show();
})
var TemplateQty;

function GetTemplate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E04.ashx",
        data: { funcName: 'ShowTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";
                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
                }
                $("#Project_Name").html(str);
            }
        }
    });
}

function GetBuName() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E04.ashx",
        data: { funcName: 'ShowBuName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";
                str += "<option value='ALL'>ALL</option>";
                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].SECTON_NAME + "'>" + res[i].SECTON_NAME + "</option>";
                }
                $("#Section_Name").html(str);
            }
        }
    });
}


function SelectShow() {
    show();
}

function show() {
    var Project_Name = $("#Project_Name").val();
    var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Project_Name=" + Project_Name;
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
        columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'PROJECT_NAME', title: '制程名称', align: 'center', width: 20, },
            { field: 'CHECK_NO', title: '事项序号', align: 'center', width: 100, },
            { field: 'CHECK_NAME', title: '点检制程名称', align: 'center', width: 30, },
            { field: 'CHECK_ITEM', title: '检查事项', align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },
            { field: 'EMP_NAME', title: '创建人员', align: 'center', width: 100, },
            { field: 'CREATE_DATE', title: '创建时间', align: 'center', width: 100, },

       

        { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
    });






    var Typ1 = $("#Typ1").text(); var Typ2 = $("#Typ2").text(); var Typ3 = $("#Typ3").text(); var Typ4 = $("#Typ4").text(); var Typ5 = $("#Typ5").text(); var Typ6 = $("#Typ6").text();
    var Typ7 = $("#Typ7").text(); var Typ8 = $("#Typ8").text(); var Typ9 = $("#Typ9").text(); var Typ10 = $("#Typ10").text(); var Typ11 = $("#Typ11").text();
    var Typ12 = $("#Typ12").text(); var Typ13 = $("#Typ13").text(); var Typ14 = $("#Typ14").text(); var Typ15 = $("#Typ15").text(); var Typ16 = $("#Typ16").text(); var Typ17 = $("#Typ17").text();
    var Typ18 = $("#Typ18").val(); var Typ19 = $("#Typ19").text(); var Typ20 = $("#Typ20").text();
    var Type1 = $("#Type1").val();
    var Type2 = $("#Type2").val();

    if (TemplateQty == 1) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 25, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 2) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 25, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 3) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 25, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 4) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 5) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 6) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 7) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 8) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 9) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 10) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 11) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 25, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 12) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 13) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 14) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'TYPE14', title: Typ14, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 15) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'TYPE14', title: Typ14, align: 'center', width: 30, },
            { field: 'TYPE15', title: Typ15, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 16) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'TYPE14', title: Typ14, align: 'center', width: 30, },
            { field: 'TYPE15', title: Typ15, align: 'center', width: 30, },
            { field: 'TYPE16', title: Typ16, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 17) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'TYPE14', title: Typ14, align: 'center', width: 30, },
            { field: 'TYPE15', title: Typ15, align: 'center', width: 30, },
            { field: 'TYPE16', title: Typ16, align: 'center', width: 30, },
            { field: 'TYPE17', title: Typ17, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 18) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'TYPE14', title: Typ14, align: 'center', width: 30, },
            { field: 'TYPE15', title: Typ15, align: 'center', width: 30, },
            { field: 'TYPE16', title: Typ16, align: 'center', width: 30, },
            { field: 'TYPE17', title: Typ17, align: 'center', width: 30, },
            { field: 'TYPE18', title: Typ18, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 19) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'TYPE14', title: Typ14, align: 'center', width: 30, },
            { field: 'TYPE15', title: Typ15, align: 'center', width: 30, },
            { field: 'TYPE16', title: Typ16, align: 'center', width: 30, },
            { field: 'TYPE17', title: Typ17, align: 'center', width: 30, },
            { field: 'TYPE18', title: Typ18, align: 'center', width: 30, },
            { field: 'TYPE19', title: Typ19, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },

            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (TemplateQty == 20) {
        var url = "../../../controller/OQC-QUALITY/E04.ashx?funcName=show&&Template=" + Template + "&&Section_Name=" + Section_Name + "&&Type1=" + Type1 + "&&Type2=" + Type2;
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
            columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'TYPE1', title: Typ1, align: 'center', width: 20, },
            { field: 'TYPE2', title: Typ2, align: 'center', width: 100, },
            { field: 'TYPE3', title: Typ3, align: 'center', width: 30, },
            { field: 'TYPE4', title: Typ4, align: 'center', width: 30, },
            { field: 'TYPE5', title: Typ5, align: 'center', width: 30, },
            { field: 'TYPE6', title: Typ6, align: 'center', width: 30, },
            { field: 'TYPE7', title: Typ7, align: 'center', width: 30, },
            { field: 'TYPE8', title: Typ8, align: 'center', width: 30, },
            { field: 'TYPE9', title: Typ9, align: 'center', width: 30, },
            { field: 'TYPE10', title: Typ10, align: 'center', width: 30, },
            { field: 'TYPE11', title: Typ11, align: 'center', width: 30, },
            { field: 'TYPE12', title: Typ12, align: 'center', width: 30, },
            { field: 'TYPE13', title: Typ13, align: 'center', width: 30, },
            { field: 'TYPE14', title: Typ14, align: 'center', width: 30, },
            { field: 'TYPE15', title: Typ15, align: 'center', width: 30, },
            { field: 'TYPE16', title: Typ16, align: 'center', width: 30, },
            { field: 'TYPE17', title: Typ17, align: 'center', width: 30, },
            { field: 'TYPE18', title: Typ18, align: 'center', width: 30, },
            { field: 'TYPE19', title: Typ19, align: 'center', width: 30, },
            { field: 'TYPE20', title: Typ20, align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },

            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },
            { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }



}

var PTYPE1;

function addAutoAssy(value, row, index) {
    return [
        '<img id="delete" src="../../../img/del.png" style="cursor: pointer" title="单击删除当前数据" />'
    ].join('');
}
window.operateDownEvents = {
    'click #delete': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        swal({
            text: '确定删除当前配置?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            $.ajax({
                url: "../../../controller/OQC-QUALITY/E04.ashx",
                type: "post",
                data: { funcName: 'del',NUMBER_ID: row.NUMBER_ID, user: user },
                dataType: "json",
                async: false,
                success: function (res) {
                    var error_msg = "";
                    if (res[0].ERR_CODE == "N") {
                        swal({
                            text: res[0].ERR_MSG,
                            type: "success",
                            confirmButtonColor: '#3085d6'
                        })
                    }
                    else if (res[0].ERR_CODE == "Y") {
                        swal({
                            text: res[0].ERR_MSG,
                            type: "error",
                            confirmButtonColor: '#3085d6'
                        })
                    }
                    show();
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
}

function Add() {
    var user = $("#user").text();
    var Project_Name = $("#Project_Name").val();
    var Section_Name = $("#Section_Name").val();
    var Check_No = $("#Check_No").val();
    var Check_Name = $("#Check_Name").val();
    var Check_Item = $("#Check_Item").val();
    if (Project_Name == "") {
        var error_msg = "制程名称未选择,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Section_Name == "") {
        var error_msg = "部门未选择,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_No == "") {
        var error_msg = "事项序号未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Name == "") {
        var error_msg = "点检制程名称未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Item == "") {
        var error_msg = "检查事项未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E04.ashx",
        data: { Section_Name: Section_Name, Project_Name: Project_Name, Check_No: Check_No, Check_Name: Check_Name, Check_Item: Check_Item, user: user, funcName: 'addTemplateInfo' },
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


function download() {

    var TemplateN = "E-CHECK";
    var LOG = "";
    let myDate = new Date();
    var date = myDate.toLocaleDateString();
    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr>";
    var tableHtmlEnd = "</tr>";
    var TYPE = "<td align='center'>部门名称</td><td align='center'>制程名称</td><td align='center'>事项序号</td><td align='center'>点检制程名称</td><td align='center'>检查事项</td>";
    tableHtml = tableHtml + TYPE + tableHtmlEnd;
    tableHtml += "</table></body></html>";
    var excelBlob = new Blob([tableHtml], {
        type: 'application/vnd.ms-excel'
    });
    var oa = document.createElement('a');
    oa.href = URL.createObjectURL(excelBlob);
    oa.download = TemplateN + '.xls';
    document.body.appendChild(oa);
    oa.click();
}
function importExcel() {
    var fileUpload = $("#fileinp").get(0);
    var files = fileUpload.files;
    var data = new FormData();
    var user = $("#user").text();
    if (files.length == 0) {
        alert("请先下载模板上传数据!!!");
        return;
    }
    for (var i = 0; i < files.length; i++) {
        data.append(files[i].name, files[i]);
    }
    var t = document.getElementById('txt');


    $.ajax({
        url: "../../../controller/OQC-QUALITY/E04.ashx?funcName=excel&user=" + user + "&Path=" + files + "",
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

























