var nowTemplateID = "";
var nowTaskID = "";

$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    var dataType = $("#dataType").val();

    showTaskNameSelect();
    show();
})

function showTaskNameSelect() {
    var taskStatus = $("#taskStatus").val();
    var user = $("#user").text();
    var dataType = $("#dataType").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OK2B/Ok2bFileUploadController.ashx",
        data: { user: user, dataType: dataType, taskStatus: taskStatus, funcName: 'showTaskName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].ID + "'>" + res[i].TASK_NAME + "</option>";
                }
                $("#taskName").html(str);
            }
        }
    });
}

function Add() {
    var user = $("#user").text();
    var modelId = $("#modelName").val();
    var taskName = $("#taskName").val();
    var templateName = $("#templateName").val();
    var dataType = $("#dataType").val();

    if (taskName=="") {
        var error_msg = "请输入本次任务的任务名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (modelId == "") {
        var error_msg = "请选择本次任务的机种名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (templateName == "") {
        var error_msg = "请选择本次任务的机种名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    
    $.ajax({
        method: "post",
        url: "../../../controller/OK2B/Ok2bController.ashx",
        data: { taskName: taskName, dataType: dataType,modelId: modelId, templateName: templateName, user: user, funcName: 'addTaskInfo' },
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
                document.getElementById("taskName").value = "";
                document.getElementById("modelName").value = "";
                document.getElementById("templateName").value = "";
                $("#modelName").focus();
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
    var taskStatus = $("#taskStatus").val();
    var taskId = $("#taskName").val();
    var dataType = $("#dataType").val();

    var url = "../../../controller/OK2B/Ok2bFileUploadController.ashx?funcName=show&&dataType=" + dataType+"&taskStatus=" + taskStatus + "&taskId=" + taskId + "&user=" + user;

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
            field: 'TASK_NAME',
            title: '任务名称',
            width: 170
        },{
            field: 'MODEL_NAME',
            title: '机种名称',
            width: 150
        }, {
            field: 'TEMPLATE_NAME',
            title: '模板名称',
            width: 150
        },{
            field: 'FILE_NAME',
            title: '文件名称',
            width: 180
        }, {
            field: 'STATUS',
            title: '文件状态',
            width: 80
        }, {
            field: 'EMP_NAME',
            title: '责任人',
            width: 100
        }, {
            field: 'ENA',
            title: '审核人',
            width: 100
        }, {
            field: 'UPLOAD_FILE_NAME',
            title: '上传文件名称',
            width: 180
        },{
            field: 'UPLOADTIME',
            title: '上传时间',
            width: 220
        }, {
            field: '下载',
            title: '下载',
            width: 20,
            events: operateDownEvents,//给按钮注册事件
            formatter: addDownsEvents//表格中增加按钮
        }, {
            field: '上传',
            title: '上传',
            width: 20,
            events: operateUploadEvents,//给按钮注册事件
            formatter: addUploadEvents//表格中增加按钮
        }, {
            field: '审核',
            title: '审核',
            width: 20,
            events: operateAudiEvents,//给按钮注册事件
            formatter: audiEvents//表格中增加按钮
        }]
    });
}

//审核
function audiEvents(value, row, index) {
    return [
        '<img id="audi" src="../../../img/hand.gif" style="cursor: pointer"  />'
    ].join('');
}


//下载
function addDownsEvents(value, row, index) {
    return [
    '<img id="down" src="../../../img/Down.png" style="cursor: pointer"  />'
    ].join('');
}

//上传
function addUploadEvents(value, row, index) {
    return [
        '<img id="upload" src="../../../img/Upload.png" style="cursor: pointer"  />'
    ].join('');
}

//审核事件
window.operateAudiEvents = {
    'click #audi': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);

        var fileStatus = row.STATUS;
        var fileName = row.FILE_NAME;
        var dataType = $("#dataType").val();
        var taskId = $("#taskName").val();

        if (fileStatus != "待审核") {
            swal({
                text: "文件 : " + fileName + " 不是待审核状态,无法审核!",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        var isPass = -1;

        swal({
            text: '当前文件上传是否通过审核?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: "通过",
            cancelButtonText: "批退",
        }).then(function () {
            isPass = 0;
            swal({
                text: '确认将当前的任务审批[通过]?',
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
            }).then(function () {
                $.ajax({
                    url: "../../../controller/OK2B/Ok2bFileUploadController.ashx?dataType=" + dataType + "&funcName=operateAudi&id=" + row.ID + "&user=" + user + "&taskStatus=" + isPass + "&taskId=" + taskId,
                    type: "POST",
                    dataType: "json",
                    async: false,
                    success: function (res) {
                        if (res[0].ERR_CODE == "N") {
                        } else {
                            var error_msg = res[0].ERR_MSG;
                            swal({
                                text: error_msg,
                                type: "error",
                                confirmButtonColor: '#3085d6'
                            })
                        }
                        show();
                    },

                    error: function (err) {
                        swal({
                            text: err.statusText,
                            type: "error",
                            confirmButtonColor: '#3085d6'
                        })
                    }
                });
            }, function (dismiss) {
                return;
            })
            
        }, function (dismiss) {
            swal({
                text: '确认将当前的任务审批[批退]?',
                type: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
            }).then(function () {
                isPass = 1;
                $.ajax({
                    url: "../../../controller/OK2B/Ok2bFileUploadController.ashx?dataType=" + dataType + "&funcName=operateAudi&id=" + row.ID + "&user=" + user + "&taskStatus=" + isPass + "&taskId=" + taskId,
                    dataType: "json",
                    async: false,
                    success: function (res) {
                        if (res[0].ERR_CODE == "N") {
                        } else {
                            var error_msg = res[0].ERR_MSG;
                            swal({
                                text: error_msg,
                                type: "error",
                                confirmButtonColor: '#3085d6'
                            })
                        }
                        show();
                    },

                    error: function (err) {
                        swal({
                            text: err.statusText,
                            type: "error",
                            confirmButtonColor: '#3085d6'
                        })
                    }
                });
            }, function (dismiss) {
                return;
            })
            
        })
    }
};


//下载事件
window.operateDownEvents = {
    'click #down': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);

        var fileStatus = row.STATUS;
        var fileName = row.FILE_NAME;
        var dataType = $("#dataType").val();

        if (fileStatus =="未上传") {
            swal({
                text: "文件 : " + fileName + " 未上传,无法下载!",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        var url = "../../../controller/OK2B/Ok2bFileUploadController.ashx?dataType=" + dataType+"&funcName=downFile&taskId=" + row.TASK_ID + "&templateId=" + row.TEMPLATE_ID + "&user=" + user;

        window.open(url);
    }
};

window.operateUploadEvents = {
    'click #upload': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);

        var fileStatus = row.STATUS;
        var fileName = row.FILE_NAME;
        var dirEmpNo = row.EMP_NO;
        var templateId = row.TEMPLATE_ID;
        var taskId = row.TASK_ID
        var dataType = $("#dataType").val();

        if (dirEmpNo != user) {
            swal({
                text: "文件 : " + fileName + " 上传责任人不是当前登录账号 ,无法上传!",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        $("#fileUploadBtn").click(); //打开本地上传文件窗口选择文件

        nowTaskID = taskId;
        nowTemplateID = templateId;
    }
};

function upload(obj) {
    var user = $("#user").text();
    var fileUpload = $("#fileUploadBtn").get(0);
    var dataFiles = fileUpload.files;
    var data = new FormData();
    var dataType = $("#dataType").val();

    if (dataFiles.length == 0) {
        swal({
            text: "请先选择文件后进行上传!",
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    for (var i = 0; i < dataFiles.length; i++) {
        data.append(dataFiles[i].name, dataFiles[i]);
    }
    var t = document.getElementById('txt');

    $.ajax({
        url: "../../../controller/OK2B/Ok2bFileUploadController.ashx?dataType=" + dataType+"&funcName=uploadFiles&taskId=" + nowTaskID + "&templateId=" + nowTemplateID + "&user=" + user ,
        type: "POST",
        data: data,
        async: false,
        contentType: false,
        processData: false,
        success: function (res) {
            if (res == "OK") {
 
                swal({
                    text: "文件上传成功!",
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
            } else {
          
                swal({
                    text: res,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
            show();
        },

        error: function (err) {
            swal({
                text: err.statusText,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
        }
    });
}

function dataTypeChange() {
    var user = getCookie("Mes3User");
    var dataType = $("#dataType").val();
    console.log(user);

    showTaskNameSelect();

    show();
}
