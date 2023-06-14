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
        url: "../../../controller/OQC-QUALITY/E03.ashx",
        data: { funcName: 'ShowTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
                }
                $("#Project_Name").html(str);
            }
        }
    });
}

function Add() {
    var user = $("#user").text();
    var Project_Name = $("#Project_Name").val();
    var Check_Time = $("#Check_Time").val();
    var Frequency = $("#Frequency").val();
    if (Project_Name == "") {
        var error_msg = "制程名称为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Time == "") {
        var error_msg = "时间范围为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Frequency == "") {
        var error_msg = "频率类型为空,请选择!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E03.ashx",
        data: { Project_Name: Project_Name, Check_Time: Check_Time, user: user, Frequency: Frequency, funcName: 'addTemplateInfo' },
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
                document.getElementById("Check_Time").value = "";
                $("#Check_Time").focus();
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
    var Project_Name = $("#Project_Name").val();
    var url = "../../../controller/OQC-QUALITY/E03.ashx?funcName=show&&Project_Name=" + Project_Name;
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
            field: 'CHECK_TIME',
            title: '时间范围',
            width: 170
        }, {
            field: 'FREQUENCY',
            title: '频率类型',
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
        },  {
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
                url: "../../../controller/OQC-QUALITY/E03.ashx",
                type: "post",
                data: { funcName: 'del', NUMBER_ID: row.PROJECT_ID, user: user, Frequency: row.FREQUENCY, Check_Time: row.CHECK_TIME },
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

function download() {

    var TemplateN = "E-CHECK";
    var LOG = "";
    let myDate = new Date();
    var date = myDate.toLocaleDateString();
    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr>";
    var tableHtmlEnd = "</tr>";
    var TYPE = "<td align='center'>制程名称</td><td align='center'>08:00-12:00/频率例如1</td>";
    tableHtml = tableHtml + TYPE + tableHtmlEnd;
    tableHtml += "</table></body></html>";
    var excelBlob = new Blob([tableHtml], {
        type: 'application/vnd.ms-excel'
    });
    var oa = document.createElement('a');
    oa.href = URL.createObjectURL(excelBlob);
    oa.download = TemplateN + '.xls';
    document.body.appendChild(oa);
    oa.click();
}

function importExcel() {
    var fileUpload = $("#fileinp").get(0);
    var files = fileUpload.files;
    var data = new FormData();
    var user = $("#user").text();
    if (files.length == 0) {
        alert("请先下载模板上传数据!!!");
        return;
    }
    for (var i = 0; i < files.length; i++) {
        data.append(files[i].name, files[i]);
    }
    var t = document.getElementById('txt');


    $.ajax({
        url: "../../../controller/OQC-QUALITY/E03.ashx?funcName=excel&user=" + user + "&Path=" + files + "",
        type: "POST",
        data: data,
        async: false,
        contentType: false,
        processData: false,
        success: function (result) {
            if (result.substr(0, 2) == 'OK') {
                var error_msg = result;
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
            } else {

                var error_msg = result;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        },
    });
    document.getElementById("fileinp").value = "";
    show();
}

