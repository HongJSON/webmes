var templateName = "";

$(document).ready(function () {
    var user = getCookie("Mes3User");
    var dataType = $("#dataType").val();
    templateName = dataType + "系统标准";
    $('#user').text(user);
    show();
})

//enter键按下触发
function empNoKeydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var empNo = $("#empNo").val()
        var user = $("#user").text();
        $("#empName").val("");

        if (empNo == '') {
            alert("人员工号未输入,请输入");
            return;
        }

        //根据empNo查询EnpInfo
        $.ajax({
            method: "post",
            url: "../../../controller/loginController.ashx",
            data: { empNo: empNo, user: user, funcName: 'getEmpInfoByEmpId'},
            dataType: "json",
            success: function (res) {
                if (res[0].ERR_CODE == "Y") {
                    swal({
                        text: res[0].ERR_MSG,
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    })
                } else {
                    $("#empName").val(res[0].ERR_MSG)
                }


            }
        })
    }
}

//enter键按下触发
function auditorEmpNoKeydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var auditorEmpNo = $("#auditorEmpNo").val()
        var user = $("#user").text();
        $("#auditorEmpName").val("");

        if (auditorEmpNo == '') {
            alert("审核人员工号未输入,请输入");
            return;
        }

        //根据empNo查询EnpInfo
        $.ajax({
            method: "post",
            url: "../../../controller/loginController.ashx",
            data: { empNo: auditorEmpNo, user: user, funcName: 'getEmpInfoByEmpId' },
            dataType: "json",
            success: function (res) {
                if (res[0].ERR_CODE == "Y") {
                    swal({
                        text: res[0].ERR_MSG,
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    })
                } else {
                    $("#auditorEmpName").val(res[0].ERR_MSG)
                }


            }
        })
    }
}

function changeModelName() {
    $("#empNo").val("");
    $("#auditorEmpNo").val("");
    $("#empName").val("");
    $("#auditorEmpName").val("");
    $("#fileName").val("");
    show();
}

function Add() {
    var user = $("#user").text();
    //var templateName = $("#templateName").val();
    var fileName = $("#fileName").val();
    var empNo = $("#empNo").val();
    var empName = $("#empName").val();
    var dataType = $("#dataType").val();
    var auditorEmpNo = $("#auditorEmpNo").val();
    var auditorEmpName = $("#auditorEmpName").val();
    var isAutoAssy = $("#isAutoAssy").is(':checked');

    if (templateName == "") {
        var error_msg = "模板名称为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (fileName=="") {
        var error_msg = "文件名称为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    
    $.ajax({
        method: "post",
        url: "../../../controller/OK2B/Ok2bConfigController.ashx",
        data: { templateName: templateName, dataType: dataType, fileName: fileName, empNo: empNo, user: user, auditorEmpNo: auditorEmpNo, isAutoAssy: isAutoAssy, funcName: 'addTemplateInfo' },
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
                document.getElementById("fileName").value = "";
                document.getElementById("empNo").value = "";
                document.getElementById("empName").value = "";
                document.getElementById("auditorEmpNo").value = "";
                document.getElementById("auditorEmpName").value = "";
                $("#fileName").focus();
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
    //var templateName = $("#templateName").val();
    var fileName = $("#fileName").val();
    var empNo = $("#empNo").val();
    var auditorEmpNo = $("#auditorEmpNo").val();
    var dataType = $("#dataType").val();

    var url = "../../../controller/OK2B/Ok2bConfigController.ashx?funcName=show&&dataType=" + dataType + "&templateName=" + templateName + "&fileName=" + fileName + "&empNo=" + empNo + "&auditorEmpNo=" + auditorEmpNo;

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
            field: 'DATA_TYPE',
            title: '任务模式',
            width: 170
        },{
            field: 'TEMPLATE_NAME',
            title: '模板名称',
            width: 170
        },{
            field: 'FILE_NAME',
            title: '文件名称',
            width: 170
        }, {
            field: 'IS_AUTO_ASSY',
            title: '自动合成',
            width: 35
        }, {
            field: 'EMP_NAME',
            title: '责任人',
            width: 120
        }, {
            field: 'AUDITOR_EMP_NAME',
            title: '审核人',
            width: 120
        },  {
            field: 'MODIFYDATE',
            title: '上次修改时间',
            width: 180
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
        var dataType = $("#dataType").val();
        var auditorEmpNo = $("#auditorEmpNo").val();
        var auditorEmpName = $("#auditorEmpName").val();
        console.log(user);
        swal({
            text: '确定删除当前模板配置?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            //var templateName = $("#templateName").val();
            var fileName = $("#fileName").val();
            var empNo = $("#empNo").val();
            $.ajax({
                url: "../../../controller/OK2B/Ok2bConfigController.ashx",
                type: "post",
                data: { funcName: 'del', id: row.ID, dataType: dataType, user: user, auditorEmpNo: auditorEmpNo },
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

    templateName = dataType + "系统标准";

    show();
}
