$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetPdline();
    Show();
})
$(function () {
    $("#Startdatetimepicker").datetimepicker({
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
    $("#Enddatetimepicker").datetimepicker({
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
        url: "../../../controller/OQC-QUALITY/Sold_Weight_Query.ashx",
        data: { funcName: 'GetDate' },
        dataType: "json",
        async: false,
        success: function (res) {
            $("#Startdatetimepicker").val(res[0].ERR_CODE);
            $("#Enddatetimepicker").val(res[0].ERR_MSG);
        }
    });
}
function SelectShow() {
    Show();
}

function Show() {
    var PdlineName = $("#PdlineName").val();
    var Pstage = $("#Pstage").val();
    var Ptool = $("#Ptool").val();
    var Presult = $("#Presult").val();
    var Startdatetimepicker = document.getElementById("Startdatetimepicker").value;
    var Enddatetimepicker = document.getElementById("Enddatetimepicker").value;

        var url = "../../../controller/OQC-QUALITY/Sold_Weight_Query.ashx?funcName=show&&PdlineName=" + PdlineName + "&&Pstage=" + Pstage + "&&Ptool=" + Ptool + "&&Presult=" + Presult + "&&Startdatetimepicker=" + Startdatetimepicker + "&&Enddatetimepicker=" + Enddatetimepicker;
        $('#table').bootstrapTable('destroy');
        $('#table').bootstrapTable({
            url: url,
            /*    height: 800,        //就是这里，加上就可以固定表头*/
            fixedColumns: true,
            fixedNumber: 1,//固定列数
            theadClasses: "bg-light-blue", //設置表頭顏色
            striped: true, //是否显示行间隔色
            pagination: true, //是否显示分页
            pageSize: 100,
            columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
                { field: 'TOOLSN', title: '治具', align: 'center', width: 100, },
                { field: 'PDLINE_NAME', title: '线别,', align: 'center', width: 100, },
                { field: 'STAGE_NAME', title: '站别', align: 'center', width: 100, },
                { field: 'WEIGHT', title: '称重重量', align: 'center', width: 100, },
                { field: 'TOOLSN_WEIGHT', title: '治具重量', align: 'center', width: 100, },
                { field: 'SOLE_WEIGHT', title: '锡膏重量', align: 'center', width: 100, },
                { field: 'MAX_WEIGHT', title: '最大范围', align: 'center', width: 100, },
                { field: 'MIN_WEIGHT', title: '最小范围', align: 'center', width: 100, },
                { field: 'REMARK', title: '平均点', align: 'center', width: 100, },
                { field: 'RESULT', title: '结果', align: 'center', width: 100, },
                { field: 'EMP_NAME', title: '称重人员', align: 'center', width: 100, },
                { field: 'CREATE_TIME', title: '称重时间', align: 'center', width: 100, }]
        });


}
function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/Sold_Weight_Query.ashx",
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
function Sold_Weight_Query(event) {
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
            url: "../../../controller/OQC-QUALITY/Sold_Weight_Query.ashx",
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
