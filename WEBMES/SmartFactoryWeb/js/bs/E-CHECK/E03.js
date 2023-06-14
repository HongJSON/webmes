$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetTemplate();
    GetBuName();
    show();
})
var TemplateQty;

function GetTemplate() {
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E03.ashx",
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
function E03Keydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var JJ = $("#JJ").val()

        if (JJ == '') {
            var error_msg = "请输入制程名称!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        $.ajax({
            method: "post",
            url: "../../../controller/E-CHECK/E03.ashx",
            data: { JJ: JJ, funcName: 'ShowTemplate1' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res != null) {
                    var str = "<option value=''></option>";

                    for (var i = 0; i < res.length; i++) {
                        str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
                    }
                    $("#Project_Name").html(str);
                    $('#JJ').val("");
                }
            }
        });
    }
}


function GetBuName() {
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E03.ashx",
        data: { funcName: 'ShowBuName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";
                str += "<option value='ALL'>ALL</option>";
                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].SECTON_NAME + "'>" + res[i].SECTON_NAME + "</option>";
                }
                $("#Section_Name").html(str);
            }
        }
    });
}

function GetBuName1() {
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E03.ashx",
        data: { funcName: 'ShowBuName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";
                str += "<option value='ALL'>ALL</option>";
                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].SECTON_NAME + "'>" + res[i].SECTON_NAME + "</option>";
                }
                $("#LSection_Name").html(str);
            }
        }
    });
}

function SelectShow() {
    show();
}

function show() {
    var Project_Name = $("#Project_Name").val();
    var url = "../../../controller/E-CHECK/E03.ashx?funcName=show&&Project_Name=" + Project_Name;
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
        //height: 800,        //就是这里，加上就可以固定表头
        fixedColumns: true,
        fixedNumber: 1,//固定列数
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        pageSize: 1000,
        columns: [{ title: 'ID', width: 35, formatter: function (value, row, index) { return index + 1; } },
            { field: 'PROJECT_NAME', title: '制程名称', align: 'center', width: 20, },
            { field: 'CHECK_NO', title: '事项序号', align: 'center', width: 100, },
            { field: 'CHECK_NAME', title: '点检制程名称', align: 'center', width: 30, },
            { field: 'CHECK_ITEM', title: '检查事项', align: 'center', width: 30, },
            { field: 'SECTION_NAME', title: '部门', align: 'center', width: 100, },
            { field: 'EMP_NAME', title: '创建人员', align: 'center', width: 100, },
            { field: 'CREATE_DATE', title: '创建时间', align: 'center', width: 100, },
            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 },
       

        { field: 'OPERATE', title: '刪除', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
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
        GetBuName1();
        $('#LProject_Name').val(row.PROJECT_NAME);
        $('#LCheck_No').val(row.CHECK_NO);
        $('#LCheck_Name').val(row.CHECK_NAME);
        $('#LCheck_Item').val(row.CHECK_ITEM);
        $('#LSection_Name').val(row.SECTION_NAME);
    }
}

function insert() {
    var user = $("#user").text();
    var Project_Name = $("#LProject_Name").val();
    var Section_Name = $("#LSection_Name").val();
    var Check_No = $("#LCheck_No").val();
    var Check_Name = $("#LCheck_Name").val();
    var Check_Item = $("#LCheck_Item").val();
    if (Project_Name == "") {
        var error_msg = "制程名称未选择,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Section_Name == "") {
        var error_msg = "部门未选择,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_No == "") {
        var error_msg = "事项序号未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Name == "") {
        var error_msg = "点检制程名称未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Item == "") {
        var error_msg = "检查事项未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E03.ashx",
        data: { Section_Name: Section_Name, Project_Name: Project_Name, Check_No: Check_No, Check_Name: Check_Name, Check_Item: Check_Item, user: user, funcName: 'addTemplateInfo1' },
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


var PTYPE1;

function addAutoAssy(value, row, index) {
    return [
        '<img id="delete" src="../../../img/del.png" style="cursor: pointer" title="单击删除当前数据" />'
    ].join('');
}
window.operateDownEvents = {
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
                url: "../../../controller/E-CHECK/E03.ashx",
                type: "post",
                data: { funcName: 'del',NUMBER_ID: row.NUMBER_ID, user: user },
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

function Add() {
    var user = $("#user").text();
    var Project_Name = $("#Project_Name").val();
    var Section_Name = $("#Section_Name").val();
    var Check_No = $("#Check_No").val();
    var Check_Name = $("#Check_Name").val();
    var Check_Item = $("#Check_Item").val();
    if (Project_Name == "") {
        var error_msg = "制程名称未选择,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Section_Name == "") {
        var error_msg = "部门未选择,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_No == "") {
        var error_msg = "事项序号未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Name == "") {
        var error_msg = "点检制程名称未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Item == "") {
        var error_msg = "检查事项未输入,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E03.ashx",
        data: { Section_Name: Section_Name, Project_Name: Project_Name, Check_No: Check_No, Check_Name: Check_Name, Check_Item: Check_Item, user: user, funcName: 'addTemplateInfo' },
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


function download() {

    var TemplateN = "E-CHECK";
    var LOG = "";
    let myDate = new Date();
    var date = myDate.toLocaleDateString();
    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr>";
    var tableHtmlEnd = "</tr>";
    var TYPE = "<td align='center'>部门名称</td><td align='center'>制程名称</td><td align='center'>事项序号</td><td align='center'>点检制程名称</td><td align='center'>检查事项</td>";
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
        url: "../../../controller/E-CHECK/E03.ashx?funcName=excel&user=" + user + "&Path=" + files + "",
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
    GetShow();
}


function SelectDown() {
    var Project_Name = $("#Project_Name").val();
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E03.ashx",
        data: { Project_Name: Project_Name, funcName: 'ShowDown' },
        dataType: "text",
        async: false,
        success: function (res) {
            console.log(res);
            $("#table").html(res);
            var excelBlob = new Blob([res], {
                type: 'application/vnd.ms-excel'
            });
            var oa = document.createElement('a');
            oa.href = URL.createObjectURL(excelBlob);
            oa.download ="事项"+ '.xls';
            document.body.appendChild(oa);
            oa.click();

        }
    });
}






















