$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetTemplate();
    show();
})
function SelectShow() {
    show();
}
function GetTemplate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O02.ashx",
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


function Add() {
    var user = $("#user").text();
    var Template = $("#Template").val();
    var Title = $("#Title").val();
    if (Template == "") {
        var error_msg = "模板号为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Title == "") {
        var error_msg = "标题为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O02.ashx",
        data: { Title: Title, user: user, Template: Template, funcName: 'addTemplateInfo' },
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
                $("#Title").focus();
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




function show() {
    var Template = $("#Template").val();
    var Title = $("#Title").val();
    var url = "../../../controller/OQC-QUALITY/O02.ashx?funcName=show&&Title=" + Title + "&Template=" + Template;
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
            field: 'TEMPLATE',
            title: '模板名称',
            width: 170
        }, {
            field: 'TITLE',
            title: '标题',
            width: 170
        }, {
            field: 'CREATE_DATE',
            title: '创建时间',
            width: 170
        }, {
            field: 'EMP_NAME',
            title: '创建人员',
            width: 100
        }, {
            field: 'UPDATE_DATE',
            title: '修改时间',
            width: 170
        }, {
            field: 'EMP_NAME1',
            title: '修改人员',
            width: 100
            }, { field: '编辑', title: '编辑', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },{
            field: 'OPERATE',
            title: '刪除',
            width: 20,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }]
    });
}


function addAutoAssy1(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}

window.operateDownEvents1 = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        $("#mymodal").modal('show');
        $('#moban1').val(row.TEMPLATE);
        $('#baiti').val(row.TITLE);
    }
}

function insert() {
    var user = $("#user").text();
    var Template = $("#moban1").val();
    var Title = $("#baiti").val();
    var BIAOTI1 = $("#baiti1").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O02.ashx",
        data: { Template: Template, Title: Title, user: user, BIAOTI1: BIAOTI1,funcName: 'UpdateTemplateInfo1' },
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
                show();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal").modal('hide');
                show();
            }
        }
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
                url: "../../../controller/OQC-QUALITY/O02.ashx",
                type: "post",
                data: { funcName: 'del', NUMBER_ID: row.NUMBER_ID, user: user, Template: row.TEMPLATE, Title: row.TITLE },
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


