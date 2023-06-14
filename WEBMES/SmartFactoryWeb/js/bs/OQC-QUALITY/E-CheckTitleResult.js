$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);

    GetModel();
    GetPdline();
    show();
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
    $('#datetimepicker').focus(function () {
        $(this).blur();//不可输入状态
    })
});

function SelectShow() {
    show();
}

function GetModel() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckTitleResult.ashx",
        data: { funcName: 'ShowModel' },
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
        url: "../../../controller/OQC-QUALITY/E-CheckTitleResult.ashx",
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
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
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
        url: "../../../controller/OQC-QUALITY/E-CheckTitleResult.ashx",
        data: { ModelName: ModelName, PdlineName: PdlineName, funcName: 'GetTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TEMPLATE_POINT + "'>" + res[i].TEMPLATE_POINT + "</option>";
                }
                $("#Template").html(str);
            
        }
    });
}

function GetTitle() {
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var Template = $("#Template").val();
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
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckTitleResult.ashx",
        data: { ModelName: ModelName, PdlineName: PdlineName, Template: Template, funcName: 'GetTitle' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TITLE + "'>" + res[i].TITLE + "</option>";
                }
                $("#Title").html(str);
            }
        }
    });
}

function addrow() {
    var user = $("#user").text();
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var Template = $("#Template").val();
    var Title = $("#Title").val();
    var Result = $("#Result").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    if (datetimepicker == "") {
        var error_msg = "请选择时间!";
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
    if (Template == "") {
        var error_msg = "请输入模板名称";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Title == "") {
        var error_msg = "请输入标题";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Result == "") {
        var error_msg = "请输入结果";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckTitleResult.ashx",
        data: { user: user, ModelName: ModelName, PdlineName: PdlineName, Template: Template, Title: Title, Result: Result, datetimepicker: datetimepicker, funcName: 'InsertTemplateInfo' },
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
                document.getElementById("Result").value = "";
                $("#Title").focus();
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
    show();
}

function show() {
    var user = $("#user").text();
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var Template = $("#Template").val();
    var Title = $("#Title").val();
    var Result = $("#Result").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var url = "../../../controller/OQC-QUALITY/E-CheckTitleResult.ashx?funcName=show&&ModelName=" + ModelName + "&datetimepicker=" + datetimepicker + "&PdlineName=" + PdlineName + "&Title=" + Title + "&Result=" + Result + "&Template=" + Template;
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
            field: 'TERINTIME',
                title: '日期',
                width: 120
        }, {
            field: 'MODEL_NAME',
            title: '机种',
            width: 120
        }, {
            field: 'PDLINE_NAME',
            title: '线体',
            width: 120
        }, {
            field: 'TEMPLATE_POINT',
            title: '模板名称',
            width: 170
        }, {
            field: 'TITLE1',
            title: '标题',
            width: 100
         }, {
            field: 'RESULT_STATUS',
                title: '结果',
                width: 100
         }, {
                field: 'DN_NO',
                title: '单号',
                width: 100
         },{
            field: 'CREATE_DATE',
            title: '创建时间',
            width: 150
        }, {
            field: 'EMP_NAME',
            title: '创建人员',
            width: 120
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
            text: '确定删除当前模板配置?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            $.ajax({
                url: "../../../controller/OQC-QUALITY/E-CheckTitleResult.ashx",
                type: "post",
                data: { funcName: 'del', MODEL_NAME: row.MODEL_NAME, user: user, PDLINE_NAME: row.PDLINE_NAME, TEMPLATE_POINT: row.TEMPLATE_POINT, Title: row.TITLE1, TERINTIME: row.TERINTIME},
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
