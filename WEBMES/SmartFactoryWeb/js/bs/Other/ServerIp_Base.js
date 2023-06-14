$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    show();
})
function SelectShow() {
    show();
}
function Add() {



    var user = $("#user").text();
    var LNUMBER_ID = $("#LNUMBER_ID").val();
    var LFUN = $("#LFUN").val();
    var LFUN_DES = $("#LFUN_DES").val();
    var LGROUPING = $("#LGROUPING").val();
    var LPriority = $("#LPriority").val();
    var LServerName = $("#LServerName").val();
    var LSystemname = $("#LSystemname").val();
    var LIP = $("#LIP").val();
    var LCPU = $("#LCPU").val();
    var Lmemory = $("#Lmemory").val();
    var LHard_disk_space = $("#LHard_disk_space").val();
    var Lapplicant = $("#Lapplicant").val();
    var Lmanager = $("#Lmanager").val();
    var LApplicant_department = $("#LApplicant_department").val();
    var LApplication_time = $("#LApplication_time").val();
    var LMaturity_time = $("#LMaturity_time").val();
    var Lfounder = $("#Lfounder").val();
    var LRemote_account = $("#LRemote_account").val();
    var LRemote_PASSWORD = $("#LRemote_PASSWORD").val();
    var LLogin_account = $("#LLogin_account").val();
    var LLogin_PASSWORD = $("#LLogin_PASSWORD").val();
    var LRemark1 = $("#LRemark1").val();
    var LRemark2 = $("#LRemark2").val();
    if (LIP == "") {
        var error_msg = "IP为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Other/ServerIp_Base.ashx",
        data: {LNUMBER_ID: LNUMBER_ID, LFUN: LFUN, LFUN_DES: LFUN_DES, LGROUPING: LGROUPING, LPriority: LPriority, LServerName: LServerName, LSystemname: LSystemname, LIP: LIP, LCPU: LCPU,Lmemory: Lmemory, LHard_disk_space: LHard_disk_space, Lapplicant: Lapplicant, Lmanager: Lmanager, LApplicant_department: LApplicant_department, user: user, LApplication_time: LApplication_time,LMaturity_time: LMaturity_time, Lfounder: Lfounder, LRemote_account: LRemote_account, LRemote_PASSWORD: LRemote_PASSWORD, LLogin_account: LLogin_account, LLogin_PASSWORD: LLogin_PASSWORD, LRemark1: LRemark1, LRemark2:LRemark2,funcName: 'addTemplateInfo' },
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
                $("#LNUMBER_ID").val("");
                $("#LFUN").val("");
                $("#LFUN_DES").val("");
                $("#LGROUPING").val("");
                $("#LPriority").val("");
                $("#LServerName").val("");
                $("#LSystemname").val("");
                $("#LIP").val("");
                $("#LCPU").val("");
                $("#Lmemory").val("");
                $("#LHard_disk_space").val("");
                $("#Lapplicant").val("");
                $("#Lmanager").val("");
                $("#LApplicant_department").val("");
                $("#LApplication_time").val("");
                $("#LMaturity_time").val("");
                $("#Lfounder").val("");
                $("#LRemote_account").val("");
                $("#LRemote_PASSWORD").val("");
                $("#LLogin_account").val("");
                $("#LLogin_PASSWORD").val("");
                $("#LRemark1").val("");
                $("#LRemark2").val("");
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

function SelectDown() {
    var user = $("#user").text();
    $.ajax({
        method: "post",
        url: "../../../controller/Other/ServerIp_Base.ashx",
        data: { funcName: 'ShowDown' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var excelBlob = new Blob([res[0].ERR_MSG], {
                    type: 'application/vnd.ms-excel'
                });
                var oa = document.createElement('a');
                oa.href = URL.createObjectURL(excelBlob);
                oa.download = 'MES服务器.xls';
                document.body.appendChild(oa);
                oa.click();
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
    var LFUN = $("#LFUN").val();
    var LFUN_DES = $("#LFUN_DES").val();
    var LIP = $("#LIP").val();
    var url = "../../../controller/Other/ServerIp_Base.ashx?funcName=show&&LFUN=" + LFUN + "&&LFUN_DES=" + LFUN_DES + "&&LIP=" + LIP;
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
            field: 'NUMBER_ID',
            title: '编号',
            width:100
        }, {
            field: 'FUN',
            title: '服务器功能',
            width: 200
        }, {
            field: 'FUN_DES',
            title: '功能',
            width: 500
        }, {
            field: 'GROUPING',
            title: '分组',
            width: 100
        }, {
            field: 'PRIORITY',
            title: '顺序',
            width: 100
        }, {
            field: 'SERVERNAME',
            title: '虚拟机名称',
            width: 500
        }, {
            field: 'SYSTEMNAME',
            title: '系统名称',
            width: 500
            }, {
            field: 'IP',
            title: 'IP地址',
            width: 500
            }, {
            field: 'CPU',
            title: 'CPU',
                width: 100
            }, {
            field: 'MEMORY',
            title: '内存',
                width: 100
            }, {
            field: 'HARD_DISK_SPACE',
            title: '硬盘空间',
            width: 500
            }, {
            field: 'APPLICANT',
            title: '申请人',
                width: 100
            }, {
            field: 'MANAGER',
            title: '管理人',
                width: 100
            }, {
            field: 'APPLICANT_DEPARTMENT',
            title: '申请人部门',
            width: 500
            }, {
            field: 'APPLICATION_TIME',
            title: '申请时间',
            width: 300
            }, {
            field: 'Maturity_time',
                title: '到期时间',
                width: 200
            }, {
            field: 'FOUNDER',
                title: '创建人',
                width: 100
            }, {
            field: 'REMOTE_ACCOUNT',
                title: '远程账户',
                width: 100
            }, {
            field: 'REMOTE_PASSWORD',
                title: '密码',
                width: 100
            }, {
            field: 'LOGIN_ACCOUNT',
                title: '管理员',
            width: 500
            }, {
            field: 'LOGIN_PASSWORD',
                title: '密码',
            width: 500
            }, {
            field: 'REMARK1',
                title: '备注1',
                width: 100
            }, {
            field: 'REMARK2',
                title: '备注2',
                width: 100
            }, {
                field: 'CREATE_DATE',
                title: '创建时间',
            width: 500
            }, {
                field: 'EMP_NAME',
                title: '创建人员',
            width: 500
            },{ field: '编辑', title: '编辑', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 }, {
            field: 'OPERATE',
            title: '刪除',
            width: 20,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }]
    });
}


function addAutoAssy1(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}
var NUMBER_ID1;
window.operateDownEvents1 = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        $("#mymodal").modal('show');


        $("#LLNUMBER_ID").val(row.NUMBER_ID);
        $("#LLFUN").val(row.FUN);
        $("#LLFUN_DES").val(row.FUN_DES);
        $("#LLGROUPING").val(row.GROUPING);
        $("#LLPriority").val(row.PRIORITY);
        $("#LLServerName").val(row.SERVERNAME);
        $("#LLSystemname").val(row.SYSTEMNAME);
        $("#LLIP").val(row.IP);
        $("#LLCPU").val(row.CPU);
        $("#LLmemory").val(row.MEMORY);
        $("#LLHard_disk_space").val(row.HARD_DISK_SPACE);
        $("#LLapplicant").val(row.APPLICANT);
        $("#LLmanager").val(row.MANAGER);
        $("#LLApplicant_department").val(row.APPLICANT_DEPARTMENT);
        $("#LLApplication_time").val(row.APPLICATION_TIME);
        $("#LLMaturity_time").val(row.MATURITY_TIME);
        $("#LLfounder").val(row.FOUNDER);
        $("#LLRemote_account").val(row.REMOTE_ACCOUNT);
        $("#LLRemote_PASSWORD").val(row.REMOTE_PASSWORD);
        $("#LLLogin_account").val(row.LOGIN_ACCOUNT);
        $("#LLLogin_PASSWORD").val(row.LOGIN_PASSWORD);
        $("#LLRemark1").val(row.REMARK1);
        $("#LLRemark2").val(row.REMARK2);

    }
}

function insert() {
    var user = $("#user").text();
    var LNUMBER_ID = $("#LLNUMBER_ID").val();
    var LFUN = $("#LLFUN").val();
    var LFUN_DES = $("#LLFUN_DES").val();
    var LGROUPING = $("#LLGROUPING").val();
    var LPriority = $("#LLPriority").val();
    var LServerName = $("#LLServerName").val();
    var LSystemname = $("#LLSystemname").val();
    var LIP = $("#LLIP").val();
    var LCPU = $("#LLCPU").val();
    var Lmemory = $("#LLmemory").val();
    var LHard_disk_space = $("#LLHard_disk_space").val();
    var Lapplicant = $("#LLapplicant").val();
    var Lmanager = $("#LLmanager").val();
    var LApplicant_department = $("#LLApplicant_department").val();
    var LApplication_time = $("#LLApplication_time").val();
    var LMaturity_time = $("#LLMaturity_time").val();
    var Lfounder = $("#LLfounder").val();
    var LRemote_account = $("#LLRemote_account").val();
    var LRemote_PASSWORD = $("#LLRemote_PASSWORD").val();
    var LLogin_account = $("#LLLogin_account").val();
    var LLogin_PASSWORD = $("#LLLogin_PASSWORD").val();
    var LRemark1 = $("#LLRemark1").val();
    var LRemark2 = $("#LLRemark2").val();
    $.ajax({
        method: "post",
        url: "../../../controller/Other/ServerIp_Base.ashx",
        data: { LNUMBER_ID: LNUMBER_ID, LFUN: LFUN, LFUN_DES: LFUN_DES, LGROUPING: LGROUPING, LPriority: LPriority, LServerName: LServerName, LSystemname: LSystemname, LIP: LIP, LCPU: LCPU, Lmemory: Lmemory, LHard_disk_space: LHard_disk_space, Lapplicant: Lapplicant, Lmanager: Lmanager, LApplicant_department: LApplicant_department, user: user, LApplication_time: LApplication_time, LMaturity_time: LMaturity_time, Lfounder: Lfounder, LRemote_account: LRemote_account, LRemote_PASSWORD: LRemote_PASSWORD, LLogin_account: LLogin_account, LLogin_PASSWORD: LLogin_PASSWORD, LRemark1: LRemark1, LRemark2: LRemark2, funcName: 'UpdateTemplateInfo1' },
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
                url: "../../../controller/Other/ServerIp_Base.ashx",
                type: "post",
                data: { funcName: 'del', LIP: row.IP, user: user },
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