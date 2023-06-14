var dlhId = "";

$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    var dataType = $("#dataType").val();
    show(0);
})

function getProjectName() {

    var isUpload = $("#isUpload").val();

    $.ajax({
        method: "post",
        url: "../../../controller/ProfitLoss/SBU1/DLHUploadController.ashx",
        data: { isUpload: isUpload, funcName: 'showProjectName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
                }
                $("#projectName").html(str);
            }
        }
    });
}

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
    var dlhNum = $("#dlhNum").val();

    if (dlhId == "") {
        var error_msg = "选择填报内容错误,请刷新页面重新选择!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (dlhNum < 0) {
        var error_msg = "工时数量不可以小于0,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    
    $.ajax({
        method: "post",
        url: "../../../controller/ProfitLoss/SBU1/DLHUploadController.ashx",
        data: { user: user, ID: dlhId, dlhNum: dlhNum, funcName: 'addDLH' },
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
                document.getElementById("dlhNum").value = "";
                dlhId = "";
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
    show(1);
}


function priceInput() {
    var exrate = $("#exrate").val();
    var priceDollar = $("#priceDollar").val();
    $("#priceRmb").val(exrate * priceDollar);
}

function bomCostInput() {
    var exrate = $("#exrate").val();
    var bomCostDollar = $("#bomCostDollar").val();
    $("#bomCostRmb").val(exrate * bomCostDollar);
}

function show(temp) {

    document.getElementById("dlhShow").style.display = "none";
    document.getElementById("dlhBtn").style.display = "none";

    var user = $("#user").text();
    var isUpload = $("#isUpload").val();

    if (temp == 0) {
        getProjectName();
    }

    var projectName = $("#projectName").val();

    var url = "../../../controller/ProfitLoss/SBU1/DLHUploadController.ashx?funcName=show&isUpload=" + isUpload + "&user=" + user + "&projectName=" + projectName ;

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
            field: 'PROJECT_NAME',
            title: '项目名称',
            width: 90
        }, {
            field: 'MODEL_NAME',
            title: '机种名称',
            width: 120
        },{
            field: 'START_TIME',
            title: '开始时间',
            width: 240
        },{
            field: 'END_TIME',
            title: '结束时间',
            width: 240
        }, {
            field: 'SHIFT',
            title: '班别',
            width: 60
        }, {
            field: 'INPUT_QTY',
            title: '投入数量',
            width: 90
        },{
            field: 'OUTPUT_QTY',
            title: '产出数量',
            width: 90
        }, {
            field: 'FAIL_QTY',
            title: '不良数量',
            width: 90
        }, {
            field: 'DLH_NUM',
            title: '投入工时',
            width: 100
        }, {
            field: 'EDIT',
            title: '填报工时',
            width: 50,
            events: operateEditEvents,//给按钮注册事件
            formatter: addEdit//表格中增加按钮
        }]
    });
}

//编辑
function addEdit(value, row, index) {
    return [
        '<img id="addEdit" src="../../../img/edit.png" style="cursor: pointer" title="" />'
    ].join('');
}

//删除
function addFunctionAlty(value, row, index) {
    return [
        '<img id="delete" src="../../../img/del.png" style="cursor: pointer" title="" />'
    ].join('');
}

//编辑
window.operateEditEvents = {
    'click #addEdit': function (e, value, row, index) {
        console.log(row);

        var projectName = row.PROJECT_NAME;
        dlhId = row.ID;

        var dlhNum = prompt("请输入 [" + projectName + "] 的投入工时:");

        if (dlhNum != null && dlhNum.length == 0) {
            swal({
                text: "未输入投入工时,请检查",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        if (dlhNum==null) {
            return;
        }

        var re = /^[0-9]+.?[0-9]*$/; //判断字符串是否为数字 //判断正整数 /^[1-9]+[0-9]*]*$/ 

        if (!re.test(dlhNum)) {
            swal({
                text: "输入的内容需要是数值,请检查",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
        }


        var user = $("#user").text();

        if (dlhId == "") {
            var error_msg = "选择填报内容错误,请刷新页面重新选择!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        if (dlhNum < 0) {
            var error_msg = "工时数量不可以小于0,请检查!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }


        $.ajax({
            method: "post",
            url: "../../../controller/ProfitLoss/SBU1/DLHUploadController.ashx",
            data: { user: user, ID: dlhId, dlhNum: dlhNum, funcName: 'addDLH' },
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
                    document.getElementById("dlhNum").value = "";
                    dlhId = "";
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
        show(1);

        //dlhId = row.ID;
        //document.getElementById("dlhShow").style.display = "";
        //document.getElementById("dlhBtn").style.display = "";
    }
};

//删除
window.operateEvents = {
    'click #delete': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        swal({
            text: '确定删除当前任务?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
           
            $.ajax({
                url: "../../../controller/ProfitLoss/SBU1/DLHUploadController.ashx",
                type: "post",
                data: { funcName: 'del', id: row.ID , user: user }, 
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

                    
                    show(1);
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
};


function dataTypeChange() {
    var user = getCookie("Mes3User");
    var dataType = $("#dataType").val();
    console.log(user);

    $.ajax({
        method: "post",
        url: "../../../controller/OK2B/Ok2bController.ashx",
        data: { user: user, dataType: dataType, funcName: 'showTemplateName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TEMPLATE_NAME + "'>" + res[i].TEMPLATE_NAME + "</option>";
                }
                $("#templateName").html(str);
            }

            $("#taskName").focus();
        }
    });
    show(1);
}


function download() {

    console.log(user);

    var LOG = "";
    let myDate = new Date();
    var date = myDate.toLocaleDateString();
    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1>    <tr> " +
        "<td align = 'center' >ID</td>" +
        "<td align='center'>项目名称</td>" +
        "<td align='center'>机种名称</td>" +
        "<td align='center'>开始时间</td>" +
        "<td align='center'>结束时间</td>" +
        "<td align='center'>班别</td>" +
        "<td align='center'>投入数量</td>" +
        "<td align='center'>产出数量</td>" +
        "<td align='center'>不良数量</td>" +
        "<td align='center'>投入工时</td> </tr > ";

    $.ajax({
        method: "post",
        url: "../../../controller/ProfitLoss/SBU1/DLHUploadController.ashx",
        data: { funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            var Type = "Typ";

            for (var i = 0; i < res.length; i++) {
                var TYPE = "<tr><td align='center'>" + "ID" + res[i].ID + "</td>" +
                    "<td align='center'>" + res[i].PROJECT_NAME + "</td> " +
                    "<td align='center'>" + res[i].MODEL_NAME + "</td> " +
                    "<td align='center'>" + res[i].START_TIME + "</td> " +
                    "<td align='center'>" + res[i].END_TIME + "</td> " +
                    "<td align='center'>" + res[i].SHIFT + "</td> " +
                    "<td align='center'>" + res[i].INPUT_QTY + "</td> " +
                    "<td align='center'>" + res[i].OUTPUT_QTY + "</td> " +
                    "<td align='center'>" + res[i].FAIL_QTY + "</td> " +
                    "<td align='center'></td> </tr>" 
                    ;
                LOG = LOG + TYPE;
            }

        }
    });
    tableHtml = tableHtml + LOG;
    tableHtml += "</table></body></html>";
    var excelBlob = new Blob([tableHtml], {
        type: 'application/vnd.ms-excel'
    });
    var oa = document.createElement('a');
    oa.href = URL.createObjectURL(excelBlob);
    oa.download = '未填报工时数据汇总' + (Date.parse(new Date()) + "") + '.xls';
    document.body.appendChild(oa);
    oa.click();
}

function importExcel() {
    var fileUpload = $("#fileinp").get(0);
    var files = fileUpload.files;
    var data = new FormData();
    var user = $("#user").text();

    if (files.length == 0) {
        alert("请先下载记录上传数据!!!");
        return;
    }
    for (var i = 0; i < files.length; i++) {
        data.append(files[i].name, files[i]);
    }

    $.ajax({
        url: "../../../controller/ProfitLoss/SBU1/DLHUploadController.ashx?funcName=excel&user=" + user + "&Path=" + files + "",
        type: "POST",
        data: data,
        async: false,
        contentType: false,
        processData: false,
        success: function (result) {
            if (result.substr(0, 2) == 'OK') {

                var error_msg = result;
                show(1);
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
    GetType1();
}


