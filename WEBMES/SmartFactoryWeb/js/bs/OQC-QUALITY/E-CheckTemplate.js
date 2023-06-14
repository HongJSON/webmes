$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);

    GetModel();
    GetPdline();
    show();
})

function SelectShow() {
    show();
}

function GetModel() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/ECheckTemplate.ashx",
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
        url: "../../../controller/OQC-QUALITY/ECheckTemplate.ashx",
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


function addrow() {
    var user = $("#user").text();
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var Template = $("#Template").val();
    var Title = $("#Title").val();

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
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/ECheckTemplate.ashx",
        data: { user: user, ModelName: ModelName, PdlineName: PdlineName, Template: Template, Title: Title,funcName: 'InsertTemplateInfo' },
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
                document.getElementById("Title").value = "";
                $("#Template").focus();
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
                url: "../../../controller/OQC-QUALITY/ECheckTemplate.ashx",
                type: "post",
                data: { funcName: 'del', MODEL_NAME: row.MODEL_NAME, user: user, PDLINE_NAME: row.PDLINE_NAME, TEMPLATE_POINT: row.TEMPLATE_POINT, TITLE: row.TITLE },
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

function show() {
    var ModelName = $("#ModelName").val();
    var PdlineName = $("#PdlineName").val();
    var Template = $("#Template").val();
    var Template = $("#Template").val();
    var TITLE = $("#Title").val();
    var url = "../../../controller/OQC-QUALITY/ECheckTemplate.ashx?funcName=show&&ModelName=" + ModelName + "&PdlineName=" + PdlineName + "&TITLE=" + TITLE + "&Template=" + Template;
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
            field: 'TITLE',
            title: '标题',
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

