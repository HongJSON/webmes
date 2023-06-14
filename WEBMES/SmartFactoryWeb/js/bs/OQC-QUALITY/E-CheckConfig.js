$(document).ready(function(){
    var user = getCookie("Mes3User");
    $('#user').text(user);
    dataObj = [];
    show();


})

//定義全局變量
var dataObj;  // 數據對象數據


function tableData() {
    var Processname = $("#Processname").val();
    var CheckPoint = $("#CheckPoint").val();
    var Floor = $("#Floor").val();
    var Upper = $("#Upper").val();
    var Unit = $("#Unit").val();
    var ModelName = $("#ModelName").val();
    var Cqp = $("#Cqp").val();
    var Template = $("#Template").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckConfig.ashx",
        data: { Processname: Processname, CheckPoint: CheckPoint, Floor: Floor, Upper: Upper, Unit: Unit, ModelName: ModelName, Cqp: Cqp, Template: Template, funcName: 'table' },
        dataType: "json",
        async: false,
        success: function (data) {
            if (data == null) {
                return;
            } else {
                for (var i = 0; i < data.length; i++) {
                    dataObj.push(data[i]);
                    //for 
                }
            }
        }
    });
}

function show(){
    var Processname = $("#Processname").val();
    var CheckPoint = $("#CheckPoint").val();
    var Floor = $("#Floor").val();
    var Upper = $("#Upper").val();
    var Unit = $("#Unit").val();
    var ModelName = $("#ModelName").val();
    var Cqp = $("#Cqp").val(); 
    var Template = $("#Template").val();
    var url = "../../../controller/OQC-QUALITY/E-CheckConfig.ashx?funcName=show&&Processname=" + Processname + "&CheckPoint=" + CheckPoint + "&Floor=" + Floor + "&Upper=" + Upper + "&Cqp=" + Cqp + "&Template=" + Template + "&Unit=" + Unit + "&ModelName=" + ModelName;
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
                field: 'MODEL_NAME',
                title: '机种名称',
                width: 120
            }, {
                field: 'CQP',
            title: 'CQP工站号',
                width: 120
            },{
            field: 'PROCESS_NAME',
            title: '制程名称',
            width: 120
            }, {
                field: 'TEMPLATE',
                title: '模板名称',
                width: 120
            },{
            field: 'ITEM',
            title: '事项序号',
            width: 35
        }, {
            field: 'CHECK_POINT',
            title: '检查事项',
            width: 170
        }, {
            field: 'UPPER',
            title: '管控上限',
            width: 35
        }, {
            field: 'FLOOR',
            title: '管控下限',
            width: 35
        }, {
            field: 'UNIT',
            title: '单位',
            width: 70
        },  {
                field: 'CREATE_DATE',
                title: '创建时间',
                width: 200
            }, {
            field: 'EMP_NAME',
            title: '创建人员',
            width: 120
            }, {
                field: 'UPDATE_DATE',
                title: '修改时间',
                width: 200
            }, {
                field: 'EMP_NAME1',
                title: '修改人员',
                width: 120
            }, {
                field: '编辑',
                title: '编辑',
                width: 20,
                events: operateDownEvents,//给按钮注册事件
                formatter: addAutoAssy//表格中增加按钮
            }, {
            field: 'OPERATE',
            title: '刪除',
            width: 20,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }]
    });
    tableData();
}


function addAutoAssy(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}

window.operateDownEvents = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);

        var PROCESS_NAME = row.PROCESS_NAME;
        var CHECK_POINT = row.CHECK_POINT;
        var UPPER = row.UPPER;
        var FLOOR = row.FLOOR;
        var UNIT = row.UNIT;
        var MODEL_NAME = row.MODEL_NAME;
        var UUID = row.UUID;
        var CQP = row.CQP; Template
        var TEMPLATE = row.TEMPLATE;

        $('#zhicheng').val(PROCESS_NAME);
        $('#jiancha').val(CHECK_POINT);
        $('#xiaxian').val(FLOOR);
        $('#shangxian').val(UPPER);
        $('#danwei').val(UNIT);
        $('#jizhong').val(MODEL_NAME);
        $('#BAN').val(UUID);
        $('#gongzhanhao').val(CQP);
        $('#moban').val(TEMPLATE);
        
        $("#mymodal").modal('show');
    }
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
                url: "../../../controller/OQC-QUALITY/E-CheckConfig.ashx",
                type: "post",
                data: { funcName: 'del', PROCESS_NAME: row.PROCESS_NAME, user: user, ITEM: row.ITEM, MODEL_NAME: row.MODEL_NAME, Cqp: row.CQP, Template: row.TEMPLATE},
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


////添加
function Add() {
    var user = $("#user").text();
    var Processname = $("#Processname").val();
    var CheckPoint = $("#CheckPoint").val();
    var Floor = $("#Floor").val();
    var Upper = $("#Upper").val();
    var Unit = $("#Unit").val();
    var ModelName = $("#ModelName").val();
    var Cqp = $("#Cqp").val();
    var Template = $("#Template").val();
    if (Cqp == "") {
        var error_msg = "CQP工站号,为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Template == "") {
        var error_msg = "模板名称,为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Processname == "") {
        var error_msg = "制程名称,为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (CheckPoint == "") {
        var error_msg = "检查事项-Check Point为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Floor == "") {
        var error_msg = "管控下限为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Upper == "") {
        var error_msg = "管控下限为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Unit == "") {
        var error_msg = "单位为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (ModelName == "") {
        var error_msg = "机种名称为空，请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckConfig.ashx",
        data: { user: user, Processname: Processname, CheckPoint: CheckPoint, Floor: Floor, Upper: Upper, Unit: Unit, ModelName: ModelName, Cqp: Cqp, Template: Template, funcName: 'addTemplateInfo' },
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
                document.getElementById("Processname").value = "";
                document.getElementById("CheckPoint").value = "";
                document.getElementById("Floor").value = "";
                document.getElementById("Upper").value = "";
                document.getElementById("Unit").value = "";
                document.getElementById("ModelName").value = "";
                document.getElementById("Cqp").value = "";
                document.getElementById("Template").value = "";
                $("#ModelName").focus();
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

function SelectShow() {
    show();
}


function insert() {
    var user = $("#user").text();
    var Processname = $("#zhicheng").val();
    var CheckPoint = $("#jiancha").val();
    var Floor = $("#xiaxian").val();
    var Upper = $("#shangxian").val();
    var Unit = $("#danwei").val();
    var ModelName = $("#jizhong").val();
    var NUMID = $("#BAN").val();
    var Cqp = $("#gongzhanhao").val();
    var Template = $("#moban").val();
    if (Cqp == "") {
        var error_msg = "CQP工站号,为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Template == "") {
        var error_msg = "模板名称,为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Processname == "") {
        var error_msg = "制程名称,为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (CheckPoint == "") {
        var error_msg = "检查事项-Check Point为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Floor == "") {
        var error_msg = "管控下限为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Upper == "") {
        var error_msg = "管控下限为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (Unit == "") {
        var error_msg = "单位为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }

    if (ModelName == "") {
        var error_msg = "机种名称为空，请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckConfig.ashx",
        data: { user: user, Processname: Processname, CheckPoint: CheckPoint, Floor: Floor, Upper: Upper, Unit: Unit, ModelName: ModelName, NUMID: NUMID, Cqp: Cqp, Template: Template, funcName: 'UpdateTemplateInfo' },
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
            }
        }
    });

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
        url: "../../../controller/OQC-QUALITY/E-CheckConfig.ashx?funcName=excel&user=" + user + "&Path="+files+"",
        type: "POST",
        data: data,
        async: false,
        contentType: false,
        processData: false,
        success: function (result) {
            if (result.substr(0,2) == 'OK') {

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


function download() {

    var Template = "";
    Template = $("#Template").val();
    if (Template == "") {
        Template = "E-Check";
    }
    let myDate = new Date();
    var date = myDate.toLocaleDateString();

    //var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr><td>编号</td><td>识别卡号</td><td>人员工号</td><td>人员姓名</td><td>职位</td><td>班别</td><td>出勤</td><td>区域</td></tr>";


    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr><td align='center'>工单号</td><td align='center'>机种名称</td><td align='center'>料号</td><td align='center'>年月日</td><td align='center'>线体</td><td align='center'>班别</td><td align='center'>检查人员</td><td align='center'>地点</td><td align='center'>CQP工站号</td><td align='center'>检查项次</td><td align='center'>制程名称</td><td align='center'>检查事项</td><td align='center'>管控上限</td><td align='center'>管控下限</td><td align='center'>8:00-12:00</td><td align='center'>13:00-17:00</td><td align='center'>17:30-19:30</td><td align='center'>20:00-00:00</td><td align='center'>1:00-5:00</td><td align='center'>5:00-7:00</td></tr>";
    for (var i = 0; i < dataObj.length; i++) {
        var j = dataObj[i];

        var row = "<tr><td align='center'></td><td align='center'>" + j.MODEL_NAME + "</td><td align='center'></td><td align='center'>" + date + "</td><td align='center'></td><td align='center'></td><td align='center'></td><td align='center'></td><td align='center'>" + j.CQP + "</td><td align='center'>" + j.ITEM + "</td><td align='center'>" + j.PROCESS_NAME + "</td><td align='center'>" + j.CHECK_POINT + "</td><td align='center'>" + j.UPPER + "</td><td align='center'>" + j.FLOOR + "</td><td align='center'></td><td align='center'></td><td align='center'></td><td align='center'></td><td align='center'></td><td align='center'></td></tr>";
        tableHtml += row;
    }
    tableHtml += "</table></body></html>";
    var excelBlob = new Blob([tableHtml], {
        type: 'application/vnd.ms-excel'
    });
    var oa = document.createElement('a');
    oa.href = URL.createObjectURL(excelBlob);
    oa.download = Template +'.xls';
    document.body.appendChild(oa);
    oa.click();
}





