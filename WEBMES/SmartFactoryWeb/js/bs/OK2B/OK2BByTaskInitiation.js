var uploadIdNum = 0;

$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    var dataType = $("#dataType").val();
    $("#taskName").focus();

    //$.ajax({
    //    method: "post",
    //    url: "../../../controller/OK2B/Ok2bController.ashx",
    //    data: { user: user, dataType: dataType ,funcName: 'showTemplateName' },
    //    dataType: "json",
    //    async: false,
    //    success: function (res) {
    //        if (res != null) {
    //            var str = "<option value=''></option>";

    //            for (var i = 0; i < res.length; i++) {
    //                str += "<option value='" + res[i].TEMPLATE_NAME + "'>" + res[i].TEMPLATE_NAME + "</option>";
    //            }
    //            $("#templateName").html(str);
    //        }

    //        $("#taskName").focus();
    //    }
    //});
    show();
})

$('#expiryDate').datetimepicker({
    format: 'yyyy-mm-dd hh:00:00',
    autoclose: true,
    /* minView: "month",  *///选择日期后，不会再跳转去选择时分秒 
    language: 'zh-CN',
    dateFormat: 'yyyy-mm-dd',//日期显示格式
    timeFormat: 'HH:mm:ss',//时间显示格式
    todayBtn: 1,
    autoclose: 1,
    minView: 1,  //0表示可以选择小时、分钟   1只可以选择小时
    minuteStep: 1,//分钟间隔1分钟
});

function Add() {
    var user = $("#user").text();
    var modelName = $("#modelName").val();
    var taskName = $("#taskName").val();
    var templateName = $("#templateName").val();
    var dataType = $("#dataType").val();
    var expiryDate = $("#expiryDate").val();

    if (taskName=="") {
        var error_msg = "请输入本次任务的任务名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (modelName == "") {
        var error_msg = "请选择本次任务的机种名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (expiryDate == "") {
        var error_msg = "请选择本次任务的截止时间!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (templateName == "") {
        var error_msg = "请选择本次任务的模板!";
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
        data: { taskName: taskName, expiryDate: expiryDate, dataType: dataType, modelName: modelName, templateName: templateName, user: user, funcName: 'addTaskInfo' },
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
                document.getElementById("expiryDate").value = "";
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
    var modelName = $("#modelName").val();
    var taskName = $("#taskName").val();
    var dataType = $("#dataType").val();
    var url = "../../../controller/OK2B/Ok2bController.ashx?funcName=show&&dataType=" + dataType + "&modelName=" + modelName + "&taskName=" + taskName;

    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        pageSize: 5,
        columns: [{
            title: 'ID',
            width: 35,
            formatter: function (value, row, index) {
                return index + 1;
            }
        }, {
            field: 'DATA_TYPE',
            title: '任务模式',
            width: 80
        }, {
            field: 'TASK_NAME',
            title: '任务名称',
            width: 180
        },{
            field: 'MODEL_NAME',
            title: '机种名称',
            width: 180
        },{
            field: 'TEMPLATE_NAME',
            title: '模板名称',
            width: 180
        }, {
            field: 'STATUS',
            title: '状态',
            width: 80
        }, {
            field: 'EXPIRYDATE',
            title: '截止日期',
            width: 200
        },{
            field: 'EMP_NAME',
            title: '创建人员',
            width: 100
        }, {
            field: 'DATETIME',
            title: '创建时间',
            width: 200
        }, {
            field: 'ERROR_MSG',
            title: '备注',
            width: 220
        }, {
            field: 'OPERATE',
            title: '刪除',
            width: 20,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }, {
            field: 'ASSY',
            title: '汇总',
            width: 20,
            events: autoAssyEvents,//给按钮注册事件
            formatter: addAutoAssy//表格中增加按钮  
        }, {
            field: '下载',
            title: '下载',
            width: 20,
            events: operateDownEvents,//给按钮注册事件
            formatter: addDownsEvents//表格中增加按钮
        }]
    });
}

//下载
function addDownsEvents(value, row, index) {
    return [
        '<img id="down" src="../../../img/Down.png" style="cursor: pointer"  />'
    ].join('');
}

//汇总
function addAutoAssy(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer" title="单击汇总当前任务所有文件" />'
    ].join('');
}

//删除
function addFunctionAlty(value, row, index) {
    return [
        '<img id="delete" src="../../../img/del.png" style="cursor: pointer" title="单击删除当前数据" />'
    ].join('');
}

//下载事件
window.operateDownEvents = {
    'click #down': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);

        var fileStatus = row.STATUS;
        var fileName = row.FILE_NAME;
        var dataType = $("#dataType").val();

        if (fileStatus != "已汇总") {
            swal({
                text: "当前任务未进行汇总,无法下载!",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        var url = "../../../controller/OK2B/Ok2bController.ashx?dataType=" + dataType + "&funcName=downFile&id=" + row.ID + "&user=" + user;

        window.open(url);
    }
};

//汇总
window.autoAssyEvents = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        var dataType = $("#dataType").val();
        console.log(user);
        var status = row.STATUS;

        if (status!="已完结") {
            swal({
                text: "[未完结]或者[已汇总]状态任务无法汇总!",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        swal({
            text: '确定将当前任务文件进行汇总?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            var modelId = $("#modelName").val();
            var taskName = $("#taskName").val();
            $.ajax({
                url: "../../../controller/OK2B/Ok2bController.ashx",
                type: "post",
                data: { funcName: 'assyTaskFile', id: row.ID, dataType: dataType, user: user },
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
};

//删除
window.operateEvents = {
    'click #delete': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        var dataType = $("#dataType").val();
        console.log(user);
        swal({
            text: '确定删除当前任务?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            var modelId = $("#modelName").val();
            var taskName = $("#taskName").val();
            $.ajax({
                url: "../../../controller/OK2B/Ok2bController.ashx",
                type: "post",
                data: { funcName: 'del', id: row.ID, dataType: dataType, user: user },
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
};


function dataTypeChange() {
    //var user = getCookie("Mes3User");
    //var dataType = $("#dataType").val();
    //console.log(user);

    //$.ajax({
    //    method: "post",
    //    url: "../../../controller/OK2B/Ok2bController.ashx",
    //    data: { user: user, dataType: dataType, funcName: 'showTemplateName' },
    //    dataType: "json",
    //    async: false,
    //    success: function (res) {
    //        if (res != null) {
    //            var str = "<option value=''></option>";

    //            for (var i = 0; i < res.length; i++) {
    //                str += "<option value='" + res[i].TEMPLATE_NAME + "'>" + res[i].TEMPLATE_NAME + "</option>";
    //            }
    //            $("#templateName").html(str);
    //        }

    //        $("#taskName").focus();
    //    }
    //});
    show();
}

function showFileUploadItem() {
    var user = getCookie("Mes3User");
    var dataType = $("#dataType").val();
    console.log(user);

    $.ajax({
        method: "post",
        url: "../../../controller/OK2B/Ok2bController.ashx",
        data: { user: user, dataType: dataType, funcName: 'showSystemTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {

                var str = "";

                for (var i = 0; i < res.length; i++) {
                    str += '<tr>' +
                        '<td><p id="name' + i + '">' + res[i].FILE_NAME +'</p></td>' +
                        '<td><input id="checkbox' + i + '" type="checkbox"/></td> ' +
                        '<td><input id="uploademp' + i + '" type="text"/></td> ' +
                        '<td><input id="checkemp' + i + '" type="text"/></td> ' +
                        '<td><p id="isAutoAssy' + i + '">' + res[i].IS_AUTO_ASSY + '</p></td>' +
                        '</tr>';
                }

                uploadIdNum = res.length;
                
                $("#showItems").html(str);
            }
        }
    });

    $("#mymodal").modal('show');
}


function saveUploadtem() {
    var itemTemplate = "";
    var user = getCookie("Mes3User");
    console.log(user);
    var dataType = $("#dataType").val();

    var taskName = $("#taskName").val();

    if (taskName == "") {
        var error_msg = "请输入本次任务的任务名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    for (var i = 0; i < uploadIdNum; i++) {
        var itemCheck = $("#checkbox" + i).is(':checked');

        if (!itemCheck) {
            continue;
        }

        itemTemplate += ($("#name" + i).text() + "±" + $("#uploademp" + i).val() + "±" + $("#checkemp" + i).val() + "±" + $("#isAutoAssy" + i).text() + ";");
    }

    $.ajax({
        method: "post",
        url: "../../../controller/OK2B/Ok2bConfigController.ashx",
        data: { user: user, dataType: dataType, taskName: taskName, itemTemplate: itemTemplate ,funcName: 'saveUploadFileItem' },
        dataType: "json",
        async: false,
        success: function (res) {
            var error_msg = "";
            if (res[0].ERR_CODE == "N") {
                $("#templateName").text(res[0].ERR_MSG);
                $("#templateName").val(res[0].ERR_MSG);
                $("#mymodal").modal('hide');
            }
            else if (res[0].ERR_CODE == "Y") {
                swal({
                    text: res[0].ERR_MSG,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });
}