$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    show();
})
function Add() {
    var user = $("#user").text();
    var Project_Name = $("#Project_Name").val();
    if (Project_Name == "") {
        var error_msg = "点检制程名称为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E02.ashx",
        data: { user: user, Project_Name: Project_Name, funcName: 'addTemplateInfo' },
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
                document.getElementById("Project_Name").value = "";
                $("#Project_Name").focus();
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

function SelectShow() {
    show();
}

function show() {
    var Project_Name = $("#Project_Name").val();
    var url = "../../../controller/OQC-QUALITY/E02.ashx?funcName=show&&&Project_Name=" + Project_Name;
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
            field: 'PROJECT_NAME',
            title: '制程名称',
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
                url: "../../../controller/OQC-QUALITY/E02.ashx",
                type: "post",
                data: { funcName: 'del', user: user, NUMBER_ID: row.PROJECT_ID, Project_Name: row.PROJECT_NAME },
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
