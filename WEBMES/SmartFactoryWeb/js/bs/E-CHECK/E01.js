$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    $('#ShowTBuName').hide();
    $('#ShowTName').hide();
    $('#ShowTBu').hide();
    $('#ShowTable').hide();
    $('#ShowType').hide();



})
function pageshow(info) {
    if (info == "R1") {
        $('#ShowTBu').show();
        $('#ShowTBuName').hide();
        $('#ShowTName').hide();
        $('#ShowType').hide();
        ShowBu();
    }
    if (info == "R2") {
        $('#ShowTBu').hide();
        $('#ShowTBuName').show();
        $('#ShowTName').show();
        $('#ShowType').show();
        ShowBuName();
        ShowSECTON_NAME();
    }
    $('#ShowTable').show();
    LabelType = info;

}
function ShowSECTON_NAME() {
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E01.ashx",
        data: { funcName: 'ShowSECTON_NAME' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].SECTON_NAME + "'>" + res[i].SECTON_NAME + "</option>";
                }
                $("#BuName").html(str);
            }
        }
    });
}
function ShowBu() {
    var Bu = $("#Bu").val();
    var url = "../../../controller/E-CHECK/E01.ashx?funcName=ShowBu&&Bu=" + Bu;
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
            field: 'SECTON_NAME',
            title: '部门名称',
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
function ShowBuName() {
    var BuName = $("#BuName").val();
    var Type = $("#Type").val();
    var BuNo = $("#BuNo").val();
    var url = "../../../controller/E-CHECK/E01.ashx?funcName=ShowBuName&&BuName=" + BuName + "&&Type=" + Type + "&&BuNo=" + BuNo;
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
            field: 'SECTON_NAME',
            title: '部门名称',
            width: 170
        }, {
            field: 'STATUS',
            title: '类型',
            width: 170
        }, {
            field: 'EMP_NAME',
            title: '人员',
            width: 170
        }, {
            field: 'EMP_NO',
            title: '人员工号',
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
            events: operateEvents1,//给按钮注册事件
            formatter: addFunctionAlty1//表格中增加按钮  
        }]
    });
}
function addFunctionAlty1(value, row, index) {
    return [
        '<img id="delete1" src="../../../img/del.png" style="cursor: pointer" title="单击删除当前数据" />'
    ].join('');
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
            text: '确定删除当前部门?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            $.ajax({
                url: "../../../controller/E-CHECK/E01.ashx",
                type: "post",
                data: { funcName: 'DelSection', SECTON_NAME: row.SECTON_NAME, user: user },
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
                    ShowBu();
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
}

window.operateEvents1 = {
    'click #delete1': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        swal({
            text: '确定删除当前部门人员?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            $.ajax({
                url: "../../../controller/E-CHECK/E01.ashx",
                type: "post",
                data: { funcName: 'DelSectionNo', STATUS: row.STATUS, SECTON_NAME: row.SECTON_NAME, EMP_NO: row.EMP_NO, user: user },
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
                    ShowBuName();
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
}
function SelectShow() {
    if (LabelType == "R1") {
        ShowBu();
    }
    if (LabelType == "R2") {
        ShowBuName();
    }
}
//定義全局變量
var LabelType;
function Add() {
    var user = $("#user").text();
    if (LabelType == "R1") {
        var Bu = $("#Bu").val();
        if (Bu == "") {
            var error_msg = "部门名称为空,请检查!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        $.ajax({
            method: "post",
            url: "../../../controller/E-CHECK/E01.ashx",
            data: { user: user, Bu: Bu, funcName: 'addBu' },
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
                    document.getElementById("Bu").value = "";
                    $("#Bu").focus();
                    ShowBu();
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
    if (LabelType == "R2") {
        var BuName = $("#BuName").val();
        var BuNo = $("#BuNo").val();
        var Type = $("#Type").val();
        if (BuName == "") {
            var error_msg = "部门名称为空,请检查!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        if (BuNo == "") {
            var error_msg = "人员工号为空,请检查!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        if (Type == "--请选择--") {
            var error_msg = "请选择类型,请检查!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        $.ajax({
            method: "post",
            url: "../../../controller/E-CHECK/E01.ashx",
            data: { Type: Type, user: user, BuName: BuName, BuNo: BuNo, funcName: 'addBuNo' },
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
                    document.getElementById("BuNo").value = "";
                    $("#BuNo").focus();
                    ShowBuName();
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
}

