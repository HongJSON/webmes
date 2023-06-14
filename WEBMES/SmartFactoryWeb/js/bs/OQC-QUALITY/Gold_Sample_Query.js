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
        url: "../../../controller/OQC-QUALITY/Gold_Sample_Query.ashx",
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
    var WorkOrder = $("#WorkOrder").val();
    var ProcessName = $("#ProcessName").val();
    var TerminalName = $("#TerminalName").val();
    var Shift = $("#Shift").val();
    var Startdatetimepicker = document.getElementById("Startdatetimepicker").value;
    var Enddatetimepicker = document.getElementById("Enddatetimepicker").value;

    var url = "../../../controller/OQC-QUALITY/Gold_Sample_Query.ashx?funcName=show&&PdlineName=" + PdlineName + "&&WorkOrder=" + WorkOrder + "&&ProcessName=" + ProcessName + "&&Shift=" + Shift + "&&TerminalName=" + TerminalName + "&&Startdatetimepicker=" + Startdatetimepicker + "&&Enddatetimepicker=" + Enddatetimepicker;
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
                { field: 'WORK_ORDER', title: '工单', align: 'center', width: 100, },
                { field: 'SERIAL_NUMBER', title: '条码,', align: 'center', width: 100, },
                { field: 'PDLINE_NAME', title: '线体', align: 'center', width: 100, },
                { field: 'PROCESS_NAME', title: '制程', align: 'center', width: 100, },
                { field: 'TERMINAL_NAME', title: '机台', align: 'center', width: 100, },
                { field: 'CURRENT_STATUS', title: '状态', align: 'center', width: 100, },
                { field: 'CREATE_TIME', title: '时间', align: 'center', width: 100, },
                { field: 'PASS_SEQ', title: 'PASS_SEQ', align: 'center', width: 100, },
                { field: 'END_TYPE', title: 'END_TYPE', align: 'center', width: 100, },
                { field: 'STATUS', title: '结果', align: 'center', width: 100, },
                { field: 'SHIFT', title: '班别', align: 'center', width: 100, }]
        });


}
function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/Gold_Sample_Query.ashx",
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
function Gold_Sample_Query(event) {
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
            url: "../../../controller/OQC-QUALITY/Gold_Sample_Query.ashx",
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

function ShowPdline() {
    var PdlineName = $("#PdlineName").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/Gold_Sample_Query.ashx",
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
function ShowProcess() {
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/Gold_Sample_Query.ashx",
        data: { ProcessName: ProcessName, PdlineName: PdlineName, funcName: 'ShowTerminal' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TERMINAL_NAME + "'>" + res[i].TERMINAL_NAME + "</option>";
                }
                $("#TerminalName").html(str);
            }
        }
    });
}


