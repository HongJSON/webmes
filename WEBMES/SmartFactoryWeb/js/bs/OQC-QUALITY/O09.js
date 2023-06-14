$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetPdline();
    GetTemplate();
/*    GetDn_no();*/
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

function GetDate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O09.ashx",
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

//$(function () {
//    $("#FinishTime").datetimepicker({
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
//});
//$(function () {
//    $("#StartTime").datetimepicker({
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

//function GetDate() {
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/O09.ashx",
//        data: { funcName: 'GetDate' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res[0].ERR_CODE == "N") {
//                $("#StartTime").val(res[0].ERR_MSG);
//                $("#FinishTime").val(res[0].ERR_MSG);
//            }
//        }
//    });
//}

//function SelectDnno() {
//    GetDn_no();
//}


function O09Keydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var JJ = $("#JJ").val()

        if (JJ == '') {
            var error_msg = "请输入机种!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/O09.ashx",
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




function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O09.ashx",
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
        url: "../../../controller/OQC-QUALITY/O09.ashx",
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


function SelectQueary() {
    var Template = $("#Template").val();
    var PdlineName = $("#PdlineName").val();
    //var ProcessName = $("#ProcessName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    var url = "../../../controller/OQC-QUALITY/O09.ashx?funcName=show&&datetimepicker=" + datetimepicker + "&&dataType=" + dataType + "&&PdlineName=" + PdlineName + "&&Template=" + Template;
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
/*        height: 800,        //就是这里，加上就可以固定表头*/
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        pageSize: 50,
        rowNum: 100,
        columns: [{
            title: 'ID',
            width: 35,
            formatter: function (value, row, index) {
                return index + 1;
            }
        }, {
            field: 'DN_NO',
            title: '任务单号',
            width: 170
        }, {
            field: 'DATED',
            title: '日期',
            width: 100
        }, {
            field: 'DATEW',
            title: '周别',
            width: 100
        }, {
            field: 'MODEL',
            title: '机种',
            width: 80
        }, {
            field: 'WF',
            title: 'WF',
            width: 80
            }, {
            field: 'PDLINE',
                title: '线别',
            width: 80
            }, {
            field: 'TERMINAL',
                title: '工站名称',
            width: 80
            }, {
            field: 'ABNORMAL',
                title: '异常内容',
                width: 170
            }, {
            field: 'ANALYSIS',
                title: '原因分析',
            width: 170
            }, {
            field: 'IMPROVEMENT',
                title: '改善对策',
            width: 170
            }, {
            field: 'CATEGORY',
                title: '缺失类别',
                width: 80
            }, {
            field: 'PERSON',
                title: '责任人',
            width: 80
            }, {
            field: 'DIRECTOR',
                title: '责任主管',
            width: 80
            }, {
            field: 'STARTTIME',
                title: '预计完成时间',
            width: 80
            }, {
            field: 'FINISHTIME',
                title: '实际完成时间',
            width: 80
            }, {
            field: 'FOLLOWUP',
                title: '效果追踪',
            width: 80
            }, {
            field: 'STATUS',
                title: '结案状态',
            width: 80
            }, {
            field: 'AUDITORS',
                title: '稽核人员',
            width: 80
            }]
    });
}









