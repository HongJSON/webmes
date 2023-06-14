$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);

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
    show();
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

function show() {
  
    var user = $("#user").text();
    var isUpload = $("#isUpload").val();

    var url = "../../../controller/ProfitLoss/SBU1/RemarkUploadController.ashx?funcName=show&isUpload=" + isUpload + "&user=" + user ;

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
            width: 120
        }, {
            field: 'START_TIME',
            title: '开始时间',
            width: 150
        },{
            field: 'END_TIME',
            title: '结束时间',
            width: 150
        },{
            field: 'SALES_VOLUME',
            title: '总销售额',
            width: 90
        }, {
            field: 'PROFITS',
            title: 'PROFIT',
            width: 90
        }, {
            field: 'REMARK',
            title: '备注',
            width: 350
        }, {
            field: 'EDIT',
            title: '填报备注',
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

        var projectType = row.PROJECT_TYPE;
        var id = row.ID;

        var remark = prompt("请输入 [" + projectType + "] 的生产备注:");

        if (remark != null && remark.length == 0) {
            swal({
                text: "未输入生产备注,请检查",
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        if (remark==null) {
            return;
        }


        var user = $("#user").text();

        if (id == "") {
            var error_msg = "选择填报内容错误,请刷新页面重新选择!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        $.ajax({
            method: "post",
            url: "../../../controller/ProfitLoss/SBU1/RemarkUploadController.ashx",
            data: { user: user, ID: id, remark: remark, funcName: 'add' },
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
        show();

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

