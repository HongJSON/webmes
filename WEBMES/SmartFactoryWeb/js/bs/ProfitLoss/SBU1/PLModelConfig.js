$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    var dataType = $("#dataType").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OK2B/Ok2bController.ashx",
        data: { funcName: 'showModelName' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].MODEL_ID + "'>" + res[i].MODEL_NAME + "</option>";
                }
                $("#modelName").html(str);
            }

            $("#projectType").focus();
        }
    });

    show();
})

function modelChange() {

    var modelName = $("#modelName").val();
    var user = getCookie("Mes3User");
    console.log("1");

    $.ajax({
        method: "post",
        url: "../../../controller/ProfitLoss/SBU1/PLModelConfigController.ashx",
        data: { funcName: 'showProcessName', modelName: modelName, user: user },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROCESS_ID + "'>" + res[i].PROCESS_NAME + "</option>";
                }
                $("#startProcess").html(str);
                $("#endProcess").html(str);
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
    var modelName = $("#modelName").val();
    var projectType = $("#projectType").val();
    var projectName = $("#projectName").val();
    var exrate = $("#exrate").val();
    var priceDollar = $("#priceDollar").val();
    var priceRmb = $("#priceRmb").val();
    var bomCostDollar = $("#bomCostDollar").val();
    var bomCostRmb = $("#bomCostRmb").val();
    var laborRate = $("#laborRate").val();
    var upphTarget = $("#upphTarget").val();
    var sga = $("#sga").val();
    var startProcess = $("#startProcess").val();
    var endProcess = $("#endProcess").val();
    var isEndProduct = $("#isEndProduct").is(':checked');
    var weighted = $("#weighted").val();

    if (projectType == "") {
        var error_msg = "项目类型未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (projectName == "") {
        var error_msg = "项目名称未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (exrate == "") {
        var error_msg = "汇率未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (modelName=="") {
        var error_msg = "机种未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (priceDollar==""||priceRmb == "") {
        var error_msg = "售价未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }


    if (bomCostDollar == "" || bomCostRmb == "") {
        var error_msg = "Bom Cost 未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (laborRate == "") {
        var error_msg = "工费率+制费率未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (sga == "") {
        var error_msg = "SG&A 未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (upphTarget == "") {
        var error_msg = "UPPH TARGET 未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (startProcess == "" || endProcess == "") {
        var error_msg = "起始制程 未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (weighted == "" ) {
        var error_msg = "权重 未维护,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (isEndProduct == true) {
        isEndProduct = "Y";
    } else {
        isEndProduct = "N";
    }


    
    $.ajax({
        method: "post",
        url: "../../../controller/ProfitLoss/SBU1/PLModelConfigController.ashx",
        data: { user: user, modelName: modelName, projectType: projectType, projectName: projectName, exrate: exrate, priceDollar: priceDollar, priceRmb: priceRmb, bomCostDollar: bomCostDollar, bomCostRmb: bomCostRmb, laborRate: laborRate, upphTarget: upphTarget, sga: sga, funcName: 'addPLModelConfig', startProcess: startProcess, endProcess: endProcess, isEndProduct: isEndProduct, weighted: weighted},
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
                document.getElementById("projectName").value = "";
                document.getElementById("modelName").value = "";
                document.getElementById("exrate").value = "";
                document.getElementById("priceDollar").value = "";
                document.getElementById("priceRmb").value = "";
                document.getElementById("bomCostDollar").value = "";
                document.getElementById("bomCostRmb").value = "";
                document.getElementById("laborRate").value = "";
                document.getElementById("sga").value = "";
                document.getElementById("upphTarget").value = "";
                document.getElementById("startProcess").value = "";
                document.getElementById("endProcess").value = "";
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

function exrateInput() {
    priceInput();
    bomCostInput();
}


function priceInput() {
    var exrate = $("#exrate").val();
    var priceDollar = $("#priceDollar").val();
    var temp = exrate * priceDollar;
    $("#priceRmb").val(Math.round(temp * 10000) / 10000);
}

function bomCostInput() {
    var exrate = $("#exrate").val();
    var bomCostDollar = $("#bomCostDollar").val();
    var temp = exrate * bomCostDollar;
    $("#bomCostRmb").val(Math.round(temp * 10000) / 10000);
}

function show() {
    var user = $("#user").text();
    var modelName = $("#modelName").val();
    var projectType = $("#projectType").val();
    var projectName = $("#projectName").val();
    var url = "../../../controller/ProfitLoss/SBU1/PLModelConfigController.ashx?funcName=show&&projectType=" + projectType + "&projectName=" + projectName ;

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
            field: 'PROJECT_TYPE',
            title: '项目类型',
            width: 250
        }, {
            field: 'PROJECT_NAME',
            title: '项目名称',
            width: 130
        },{
            field: 'MODEL_NAME',
            title: '机种名称',
            width: 130
        }, {
            field: 'IS_ENDPRODUCT',
            title: '成品',
            width: 20
        },{
            field: 'EXRATE',
            title: '汇率',
            width: 40
        }, {
            field: 'PRICE_DOLLAR',
            title: '售价($)',
            width: 40
        }, {
            field: 'PRICE_RMB',
            title: '售价(¥)',
            width: 40
        },{
            field: 'BOM_COST_DOLLAR',
            title: 'Bom Cost($)',
            width: 40
        }, {
            field: 'BOM_COST_RMB',
            title: 'Bom Cost(¥)',
            width: 40
        }, {
            field: 'LABOR_RATE',
            title: '工费(制费)率',
            width: 60
        }, {
            field: 'SG_A',
            title: 'SG&A',
            width: 30
        }, {
            field: 'UPPH_TARGET',
            title: 'UPH',
            width: 30
        },{
            field: 'STPN',
            title: '开始制程',
            width: 80
        }, {
            field: 'ENPN',
            title: '结束制程',
            width: 80
        }, {
            field: 'WEIGHTED',
            title: '权重',
            width: 30
        },{
            field: 'EDIT',
            title: '编辑',
            width: 40,
            events: operateEditEvents,//给按钮注册事件
            formatter: addEdit//表格中增加按钮
        }, {
            field: 'OPERATE',
            title: '刪除',
            width: 40,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }]
    });
}

//下载
function addDownsEvents(value, row, index) {
    return [
        '<img id="down" src="../../../img/Down.png" style="cursor: pointer"  />'
    ].join('');
}

//编辑
function addEdit(value, row, index) {
    return [
        '<img id="addEdit" src="../../../img/edit.png" style="cursor: pointer" title="单击汇总当前任务所有文件" />'
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

//编辑
window.operateEditEvents = {
    'click #addEdit': function (e, value, row, index) {
        console.log(row);

        $("#modelName").val(row.MODEL_ID);
        modelChange();
        $("#projectType").val(row.PROJECT_TYPE);
        $("#projectName").val(row.PROJECT_NAME);
        $("#exrate").val(row.EXRATE);
        $("#priceDollar").val(row.PRICE_DOLLAR);
        $("#priceRmb").val(row.PRICE_RMB);
        $("#bomCostDollar").val(row.BOM_COST_DOLLAR);
        $("#bomCostRmb").val(row.BOM_COST_RMB);
        $("#laborRate").val(row.LABOR_RATE);
        $("#upphTarget").val(row.UPPH_TARGET);
        $("#sga").val(row.SG_A);
        $("#startProcess").val(row.STPI);
        $("#endProcess").val(row.ENPI);
        document.getElementById("isEndProduct").checked = row.IS_ENDPRODUCT=='Y';
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
                url: "../../../controller/ProfitLoss/SBU1/PLModelConfigController.ashx",
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

                    
                    show();
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
    show();
}


function download() {
    var url = "../../../controller/ProfitLoss/SBU1/每日盈亏模板.xls";

    window.open(url);
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

    $.ajax({
        url: "../../../controller/ProfitLoss/SBU1/PLModelConfigController.ashx?funcName=excel&user=" + user +  "&Path=" + files + "",
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
    GetType1();
}