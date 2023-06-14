$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetModel();
    //GetPdline();
    Show();
})
function GetModel() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { funcName: 'GetModel' },
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
function ShowPdline() {
    var ModelName = $("#ModelName").val()

    if (ModelName == '') {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { ModelName: ModelName, funcName: 'ShowPdline' },
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
function ShowProcess() {
    var ModelName = $("#ModelName").val()
    if (ModelName == '') {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var PdlineName = $("#PdlineName").val()
    if (PdlineName == '') {
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
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { PdlineName:PdlineName,ModelName: ModelName, funcName: 'ShowProcess' },
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
function ShowDreason() {
    var ModelName = $("#ModelName").val()
    if (ModelName == '') {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var PdlineName = $("#PdlineName").val()
    if (PdlineName == '') {
        var error_msg = "请选择线体!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var ProcessName = $("#ProcessName").val()
    if (ProcessName == '') {
        var error_msg = "请选择制程!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { ProcessName: ProcessName, PdlineName: PdlineName, ModelName: ModelName, funcName: 'ShowDreason' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].REASON + "'>" + res[i].REASON + "</option>";
                }
                $("#Dreason").html(str);
            }
        }
    });
}
function ShowClass() {
    var ModelName = $("#ModelName").val()
    if (ModelName == '') {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var PdlineName = $("#PdlineName").val()
    if (PdlineName == '') {
        var error_msg = "请选择线体!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var ProcessName = $("#ProcessName").val()
    if (ProcessName == '') {
        var error_msg = "请选择制程!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var Dreason = $("#Dreason").val()
    if (Dreason == '') {
        var error_msg = "请选择DownTime原因!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { Dreason:Dreason,ProcessName: ProcessName, PdlineName: PdlineName, ModelName: ModelName, funcName: 'ShowClass' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].CLASS + "'>" + res[i].CLASS + "</option>";
                }
                $("#Dclass").html(str);
            }
        }
    });
}





//function GetPdline() {
//    $.ajax({
//        method: "post",
//        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
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
//function ModelKeydown(event) {
//    var e = event || window.event || arguments.callee.caller.arguments[0];
//    if (event.keyCode == "13") {
//        var ModelNameL = $("#ModelNameL").val()

//        if (ModelNameL == '') {
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
//            url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
//            data: { ModelName: ModelNameL, funcName: 'GetModel' },
//            dataType: "json",
//            async: false,
//            success: function (res) {
//                if (res != null) {
//                    var str = "<option value=''></option>";

//                    for (var i = 0; i < res.length; i++) {
//                        str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
//                    }
//                    $("#ModelName").html(str);
//                    $('#ModelNameL').val("");
//                }
//            }
//        });
//    }
//}
//function PdlineKeydown(event) {
//    var e = event || window.event || arguments.callee.caller.arguments[0];
//    if (event.keyCode == "13") {
//        var PdlineNameL = $("#PdlineNameL").val()

//        if (PdlineNameL == '') {
//            var error_msg = "请输入线体!";
//            swal({
//                text: error_msg,
//                type: "error",
//                confirmButtonColor: '#3085d6'
//            })
//            return;
//        }
//        $.ajax({
//            method: "post",
//            url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
//            data: { PdlineName: PdlineNameL, funcName: 'ShowPdline' },
//            dataType: "json",
//            async: false,
//            success: function (res) {
//                if (res != null) {
//                    var str = "<option value=''></option>";

//                    for (var i = 0; i < res.length; i++) {
//                        str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
//                    }
//                    $("#PdlineName").html(str);
//                    $('#PdlineNameL').val("");
//                }
//            }
//        });
//    }
//}
//function ShowPdline() {
//    var PdlineName = $("#PdlineName").val()

//    if (PdlineName == '') {
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
//        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
//        data: { PdlineName: PdlineName, funcName: 'ShowProcess' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res != null) {
//                var str = "<option value=''></option>";

//                for (var i = 0; i < res.length; i++) {
//                    str += "<option value='" + res[i].PROCESS_NAME + "'>" + res[i].PROCESS_NAME + "</option>";
//                }
//                $("#ProcessName").html(str);
//            }
//        }
//    });
//}
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
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { funcName: 'GetDate' },
        dataType: "json",
        async: false,
        success: function (res) {
            //if (res[0].ERR_CODE == "N") {
                $("#WorkTime").val(res[0].ERR_CODE);
                $("#datetimepicker").val(res[0].ERR_MSG);

         /*   }*/
        }
    });
}


function Add() {
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var WorkTime = document.getElementById("WorkTime").value;
    var Dreason = document.getElementById("Dreason").value;
    var Dstoptime = $("#Dstoptime").val();
    var Dclass = document.getElementById("Dclass").value;
    var user = $("#user").text();
    if (ModelName == '') {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (PdlineName == '') {
        var error_msg = "请选择线体!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ProcessName == '') {
        var error_msg = "请选择制程!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (datetimepicker == '') {
        var error_msg = "请选择时间!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (WorkTime == '') {
        var error_msg = "请选择时间!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Dreason == '') {
        var error_msg = "请选择DownTime原因!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Dstoptime == '') {
        var error_msg = "请选择DownTime时间(分钟)!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Dclass == '') {
        var error_msg = "请选择DownTime类型!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { user: user, ModelName: ModelName, PdlineName: PdlineName, ProcessName: ProcessName, datetimepicker: datetimepicker, WorkTime: WorkTime, Dreason: Dreason, Dstoptime: Dstoptime, Dclass: Dclass, funcName: 'addDownTime' },
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
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
            Show();
        }
    });
}
function Show() {
    var user = $("#user").text();
    var url = "../../../controller/OQC-QUALITY/OEEDownTime.ashx?funcName=show&&user=" + user;
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        pageSize: 50,
        columns: [{
            title: 'ID',
            width: 35, align: 'center',
            formatter: function (value, row, index) {
                return index + 1;
            }
        }, {
                field: 'MODEL_NAME',
            title: '机种', align: 'center',
                width: 170
            }, {
            field: 'PDLINE_NAME',
            title: '线体', align: 'center',
            width: 170
        }, {
            field: 'PROCESS_NAME',
            title: '站点', align: 'center',
            width: 170
        }, {
            field: 'WORK_DATE',
            title: '日期', align: 'center',
            width: 170
        }, {
            field: 'WORK_TIME',
            title: '时间', align: 'center',
            width: 170
            }, {
                field: 'REASON',
            title: 'DownTime原因', align: 'center',
                width: 170
            }, {
                field: 'STOP_TIME',
            title: 'DownTime时间', align: 'center',
                width: 170
            }, {
                field: 'CLASS',
            title: 'DownTime类型', align: 'center',
                width: 170
            },{
            field: 'EMP_NAME',
            title: '创建人员', align: 'center',
            width: 170
        }, {
            field: 'CREATE_TIME',
            title: '创建时间', align: 'center',
            width: 100
            }, {
                field: 'EMP_NAME1',
            title: '修改人员', align: 'center',
                width: 170
            }, {
                field: 'UPDATE_TIME',
            title: '修改时间', align: 'center',
                width: 100
            }, {
                field: '编辑',
            title: '编辑', align: 'center',
                width: 20,
                events: operateDownEvents,//给按钮注册事件
                formatter: addAutoAssy//表格中增加按钮
            }]
    });
}
function Query() {
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var WorkTime = document.getElementById("WorkTime").value;
    var Dreason = document.getElementById("Dreason").value;
    var Dstoptime = $("#Dstoptime").val();
    var Dclass = document.getElementById("Dclass").value;
    var url = "../../../controller/OQC-QUALITY/OEEDownTime.ashx?funcName=QueryShow&&ModelName=" + ModelName + "&&PdlineName=" + PdlineName + "&&ProcessName=" + ProcessName + "&&datetimepicker=" + datetimepicker + "&&WorkTime=" + WorkTime + "&&Dreason=" + Dreason + "&&Dstoptime=" + Dstoptime + "&&Dclass=" + Dclass;
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
            field: 'MODEL_NAME',
            title: '机种', align: 'center',
            width: 170
        }, {
            field: 'PDLINE_NAME',
            title: '线体', align: 'center',
            width: 170
        }, {
            field: 'PROCESS_NAME',
            title: '站点', align: 'center',
            width: 170
        }, {
            field: 'WORK_DATE',
            title: '日期', align: 'center',
            width: 170
        }, {
            field: 'WORK_TIME',
            title: '时间', align: 'center',
            width: 170
        }, {
            field: 'REASON',
            title: 'DownTime原因', align: 'center',
            width: 170
        }, {
            field: 'STOP_TIME',
            title: 'DownTime时间', align: 'center',
            width: 170
        }, {
            field: 'CLASS',
            title: 'DownTime类型', align: 'center',
            width: 170
        }, {
            field: 'EMP_NAME',
            title: '创建人员', align: 'center',
            width: 170
        }, {
            field: 'CREATE_TIME',
            title: '创建时间', align: 'center',
            width: 100
        }, {
            field: 'EMP_NAME1',
            title: '修改人员', align: 'center',
            width: 170
        }, {
            field: 'UPDATE_TIME',
            title: '修改时间', align: 'center',
            width: 100
        }, {
            field: '编辑',
            title: '编辑', align: 'center',
            width: 20,
            events: operateDownEvents,//给按钮注册事件
            formatter: addAutoAssy//表格中增加按钮
        }]
    });
}


function addFunctionAlty(value, row, index) {
    return [
        '<img id="delete" src="../../../img/del.png" style="cursor: pointer" title="单击删除当前数据" />'
    ].join('');
}
window.operateEvents = {
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
                url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
                type: "post",
                data: { funcName: 'del', user: user, NUMBER_ID: row.NUMBER_ID},
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
                    Show();
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
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
        $('#Id').val(row.NUMBER_ID);
        $('#PModelName').val(row.MODEL_NAME);
        $('#PPdlineName').val(row.PDLINE_NAME);
        $('#PProcessName').val(row.PROCESS_NAME);
        $('#PWorkDate').val(row.WORK_DATE);
        $('#PWorkTime').val(row.WORK_TIME);
    }
}
function insert() {
    var NUMBER_ID = $("#Id").val();
    var ModelName = $("#PModelName").val();
    var PdlineName = $("#PPdlineName").val();
    var ProcessName = $("#PProcessName").val();
    var Dreason = document.getElementById("PDreason").value;
    var Dstoptime = $("#PDstoptime").val();
    var Dclass = document.getElementById("PDclass").value;
    var user = $("#user").text();
    var PWorkDate = $("#PWorkDate").val();
    var PWorkTime = $("#PWorkTime").val();
    if (Dreason == '') {
        var error_msg = "请选择DownTime原因!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Dstoptime == '') {
        var error_msg = "请选择DownTime时间(分钟)!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Dclass == '') {
        var error_msg = "请选择DownTime类型!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTime.ashx",
        data: { datetimepicker: PWorkDate, WorkTime:PWorkTime,user: user, ModelName: ModelName, PdlineName: PdlineName, ProcessName: ProcessName, NUMBER_ID: NUMBER_ID,  Dreason: Dreason, Dstoptime: Dstoptime, Dclass: Dclass, funcName: 'UpdateDownTime' },
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
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
            Show();
        }
    });
}
