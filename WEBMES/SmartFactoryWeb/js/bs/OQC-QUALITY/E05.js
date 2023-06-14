$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetPdline();
    GetTemplate();
    GetBuName();

})

function GetBuName() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E05.ashx",
        data: { funcName: 'ShowBuName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].SECTON_NAME + "'>" + res[i].SECTON_NAME + "</option>";
                }
                $("#BuName").html(str);
            }
        }
    });
}


function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E05.ashx",
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
        url: "../../../controller/OQC-QUALITY/E05.ashx",
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
function E05Keydown(event) {
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
            url: "../../../controller/OQC-QUALITY/E05.ashx",
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
        url: "../../../controller/OQC-QUALITY/E05.ashx",
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



function SelectShow() {
    var Template = $("#Template").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var BuName = $("#BuName").val();
    var url = "../../../controller/OQC-QUALITY/E05.ashx?funcName=show&&Template=" + Template + "&&BuName=" + BuName + "&&PdlineName=" + PdlineName + "&ProcessName=" + ProcessName;
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
            field: 'PDLINE_NAME',
            title: '线体',
            width: 170
        }, {
            field: 'PROCESS_NAME',
            title: '站点',
            width: 170
        }, {
            field: 'TEMPLATE',
            title: '模板名称',
            width: 170
        }, {
            field: 'SECTON_NAME',
            title: '部门名称',
            width: 170
        }, {
            field: 'EMP_NAME',
            title: '创建人员',
            width: 170
        }, {
            field: 'CREATE_DATE',
            title: '创建时间',
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
            text: '确定删除当前权限?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            $.ajax({
                url: "../../../controller/OQC-QUALITY/E05.ashx",
                type: "post",
                data: { funcName: 'del', user: user, PdlineName: row.PDLINE_NAME, template: row.TEMPLATE, BuName: row.SECTON_NAME, ProcessName: row.PROCESS_NAME },
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
                    SelectShow();
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
}


function Add() {
    var user = $("#user").text();
    var Template = $("#Template").val();
    var PdlineName = $("#PdlineName").val();
    var ProcessName = $("#ProcessName").val();
    var BuName = $("#BuName").val();
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ProcessName == "") {
        var error_msg = "请选择站点!";
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
    if (BuName == "") {
        var error_msg = "请选择部门!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E05.ashx",
        data: { user: user, Template: Template, PdlineName: PdlineName, BuName: BuName, ProcessName: ProcessName, funcName: 'addTemplateInfo' },
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
            SelectShow();
        }
    });

}