$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);

    SelectShow();
    GetPdline();
    GetTemplate();

})
function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O06.ashx",
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
        url: "../../../controller/OQC-QUALITY/O06.ashx",
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
function O06Keydown(event) {
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
            url: "../../../controller/OQC-QUALITY/O06.ashx",
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

function SelectShow() {
    var Template = $("#Template").val();
    var PdlineName = $("#PdlineName").val();
    var CHECK_TYPE = $("#CHECK_TYPE").val();
    var url = "../../../controller/OQC-QUALITY/O06.ashx?funcName=show&&Template=" + Template + "&&PdlineName=" + PdlineName + "&CHECK_TYPE=" + CHECK_TYPE;
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
        },{
            field: 'PDLINE_NAME',
            title: '线体',
            width: 170
            }, {
            field: 'TEMPLATE',
                title: '模板名称',
                width: 170
            }, {
            field: 'CHECK_TYPE',
                title: '权限类型',
                width: 170
            },{
            field: 'EMP_NAME',
            title: '创建人员',
            width: 170
        }, {
            field: 'EMP_NAME1',
            title: '权限人员',
            width: 100
        }, {
            field: 'EMAIL',
            title: '邮件地址',
            width: 170
        }, {
            field: 'CREATE_DATE',
            title: '创建时间',
            width: 100
        },{
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
            text: '确定删除当前人员权限?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            $.ajax({
                url: "../../../controller/OQC-QUALITY/O06.ashx",
                type: "post",
                data: { funcName: 'del', PdlineName: row.PDLINE_NAME, template: row.TEMPLATE, CHECK_TYPE: row.CHECK_TYPE, EMP_NAME1: row.EMP_NAME1},
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
    var CHECK_TYPE = $("#CHECK_TYPE").val();
    var Emp = $("#Emp").val();
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Emp == "") {
        var error_msg = "请输入人员工号!";
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
    if (CHECK_TYPE == "") {
        var error_msg = "请选择权限类型!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O06.ashx",
        data: { user: user, Template: Template, PdlineName: PdlineName, CHECK_TYPE: CHECK_TYPE, EMP_NAME1:Emp,funcName: 'addTemplateInfo' },
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
                document.getElementById("Emp").value = "";
                $("#Emp").focus();

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