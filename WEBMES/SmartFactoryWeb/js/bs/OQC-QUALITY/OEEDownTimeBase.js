$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetModel();
    GetPdline();
    Show();
})
function GetModel() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx",
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
function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx",
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
function ModelKeydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var ModelNameL = $("#ModelNameL").val()

        if (ModelNameL == '') {
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
            url: "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx",
            data: { ModelName: ModelNameL, funcName: 'GetModel' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res != null) {
                    var str = "<option value=''></option>";

                    for (var i = 0; i < res.length; i++) {
                        str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
                    }
                    $("#ModelName").html(str);
                    $('#ModelNameL').val("");
                }
            }
        });
    }
}
function PdlineKeydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var PdlineNameL = $("#PdlineNameL").val()

        if (PdlineNameL == '') {
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
            url: "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx",
            data: { PdlineName: PdlineNameL, funcName: 'ShowPdline' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res != null) {
                    var str = "<option value=''></option>";

                    for (var i = 0; i < res.length; i++) {
                        str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
                    }
                    $("#PdlineName").html(str);
                    $('#PdlineNameL').val("");
                }
            }
        });
    }
}
function ShowProcess() {
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
        url: "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx",
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











function Add() {
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var Dreason = document.getElementById("Dreason").value;
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


    if (Dreason == '') {
        var error_msg = "请选择DownTime原因!";
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
        url: "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx",
        data: { user: user, ModelName: ModelName, PdlineName: PdlineName, ProcessName: ProcessName, Dreason: Dreason, Dclass: Dclass, funcName: 'addDownTime' },
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
    var url = "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx?funcName=show&&user=" + user;
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
        },  {
                field: 'REASON',
            title: 'DownTime原因', align: 'center',
                width: 170
            },{
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
            },  {
            field: 'OPERATE',
            title: '刪除',
            width: 20,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }]
    });
}
function Query() {
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var Dreason = document.getElementById("Dreason").value;
    var Dclass = document.getElementById("Dclass").value;
    var url = "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx?funcName=QueryShow&&ModelName=" + ModelName + "&&PdlineName=" + PdlineName + "&&ProcessName=" + ProcessName + "&&Dreason=" + Dreason + "&&Dclass=" + Dclass;
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
            field: 'REASON',
            title: 'DownTime原因', align: 'center',
            width: 170
        },  {
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
            field: 'OPERATE',
            title: '刪除',
            width: 20,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
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
                url: "../../../controller/OQC-QUALITY/OEEDownTimeBase.ashx",
                type: "post",
                data: { funcName: 'del', user: user, ModelName: row.MODEL_NAME, PdlineName: row.PDLINE_NAME, ProcessName: row.PROCESS_NAME, Dreason: row.REASON, Dclass: row.CLASS},
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