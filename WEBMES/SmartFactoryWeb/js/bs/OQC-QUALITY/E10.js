$(document).ready(function () {
    //var user = "12650378";
    var user = getCookie("Mes3User");
    $('#user').text(user);
    GetPdline();
    GetTemplate();
    GetModel();
    Show();

})
function E10MKeydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var JJMo = $("#JJMo").val()

        if (JJMo == '') {
            var error_msg = "请输入机种!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }

        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/E10.ashx",
            data: { JJMo: JJMo, funcName: 'ShowModelJJ' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res != null) {
                    var str = "<option value=''></option>";

                    for (var i = 0; i < res.length; i++) {
                        str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
                    }
                    $("#ModelName").html(str);
                    $('#JJMo').val("");
                }
            }
        });
    }
}
function GetModel() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { funcName: 'ShowModel' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
                }
                $("#ModelName").html(str);
            }
        }
    });
}
function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { funcName: 'ShowPdline' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
                }
                $("#PdlineName").html(str);
            }
        }
    });
}
function GetTemplate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { funcName: 'ShowTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
                }
                $("#ProjectName").html(str);
            }
        }
    });
}
function E10Keydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var JJ = $("#JJ").val()

        if (JJ == '') {
            var error_msg = "请输入线体!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        $.ajax({
            method: "post",
            url: "../../../controller/OQC-QUALITY/E10.ashx",
            data: { JJ: JJ, funcName: 'ShowPdlineJJ' },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res != null) {
                    var str = "<option value=''></option>";

                    for (var i = 0; i < res.length; i++) {
                        str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
                    }
                    $("#PdlineName").html(str);
                    $('#JJ').val("");
                }
            }
        });
    }
}
function GetProcess() {
    var user = $("#user").text();
    var ProjectName = $("#ProjectName").val();
    if (ProjectName == "") {
        var error_msg = "请选择制程名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { ProjectName: ProjectName, funcName: 'GetProcess' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res.length == 0) {
                var error_msg = "根据制程名称未查询到点检制程!";
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            }
            else {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].CHECK_NAME + "'>" + res[i].CHECK_NAME + "</option>";
                }
                $("#Check_Name").html(str);
            }
        }
    });

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { ProjectName: ProjectName, funcName: 'GetProcessFrequency' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res.length == 0) {
                var error_msg = "根据制程名称未查询到点检制程!";
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            }
            else {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].FREQUENCY + "'>" + res[i].FREQUENCY + "</option>";
                }
                $("#Frequency").html(str);
            }
        }
    });
}
function GetProcessL() {
    var user = $("#user").text();
    var ProjectName = $("#ProjectName").val();
    var Check_Name = $("#Check_Name").val();
    if (ProjectName == "") {
        var error_msg = "请选择制程名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Name == "") {
        var error_msg = "请选择点检制程名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { Check_Name: Check_Name, ProjectName: ProjectName, funcName: 'GetProcessL' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res.length == 0) {
                var error_msg = "未查询到点检事项!";
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            }
            else {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].CHECK_ITEM + "'>" + res[i].CHECK_ITEM + "</option>";
                }
                $("#Check_Item").html(str);
            }
        }
    });
}
function Add() {
    var user = $("#user").text();
    var ProjectName = $("#ProjectName").val();
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    var Frequency = $("#Frequency").val();
    var Check_Name = $("#Check_Name").val();
    var Check_Item = $("#Check_Item").val();
    var Unit = $("#Unit").val();
    var Check_Qty = $("#Check_Qty").val();
    var Upper = $("#Upper").val();
    var Floor = $("#Floor").val();
    var xz = document.getElementById("isAutoAssy");
    var isAutoAssy = xz.checked;
    if (PdlineName == "") {
        var error_msg = "请选择线体名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ProjectName == "") {
        var error_msg = "请选择制程名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Name == "") {
        var error_msg = "请选择点检制程名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Item == "") {
        var error_msg = "请选择检查事项!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Unit == "") {
        var error_msg = "请输入单位!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Check_Qty == "") {
        var error_msg = "请输入抽检数量!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Upper == "") {
        var error_msg = "请输入点检上限!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Floor == "") {
        var error_msg = "请输入点检下限!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Frequency == "") {
        var error_msg = "请选择点检频率!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { isAutoAssy: isAutoAssy, ModelName: ModelName, user: user, ProjectName: ProjectName, PdlineName: PdlineName, Frequency: Frequency,Check_Name: Check_Name, Check_Item: Check_Item, Unit: Unit, Check_Qty: Check_Qty, Upper: Upper, Floor: Floor, funcName: 'Add'
        },
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
                Show();
            }
            else if (res[0].ERR_CODE == "Y") {

                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                Show();
            }
        }
    });
}

function SelectShow() {
    Show();
}




function Show() {
    var PdlineName = $("#PdlineName").val();
    var ProjectName = $("#ProjectName").val();
    var ModelName = $("#ModelName").val();



    var url = "../../../controller/OQC-QUALITY/E10.ashx?funcName=show&&PdlineName=" + PdlineName + "&&ModelName=" + ModelName + "&&ProjectName=" + ProjectName;
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
        // height: 800,        //就是这里，加上就可以固定表头
        fixedColumns: true,
        fixedNumber: 1,//固定列数
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        pageSize: 100,
        columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
            { field: 'PDLINE_NAME', title: "线体", align: 'center', width: 100, },
            { field: 'MODEL_NAME', title: "机种", align: 'center', width: 100, },

        { field: 'PROJECT_NAME', title: "制程名称", align: 'center', width: 100, },
            { field: 'CHECK_NAME', title: "点检制程名称", align: 'center', width: 100, },
            { field: 'CHECK_ITEM', title: "检查事项", align: 'center', width: 100, },
            { field: 'UNIT', title: "单位", align: 'center', width: 100, },
            { field: 'CHECK_QTY', title: "抽检数量", align: 'center', width: 100, },
            { field: 'UPPER', title: "上限数值", align: 'center', width: 100, },
            { field: 'FLOOR', title: "下限数值", align: 'center', width: 100, },
            { field: 'FREQUENCY', title: "点检频率", align: 'center', width: 100, },
            { field: 'STATUS', title: "状态", align: 'center', width: 100, },


        { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },
        { field: 'OPERATE', title: '刪除', align: 'center', width: 20, events: operateDownEvents1, formatter: addAutoAssy1 }]
    });
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
        $("#mymodal").modal('show');
        PTYPE1 = row.PROJECT_ID;

        $('#LModelName').val(row.MODEL_NAME);
        $('#LPdlineName').val(row.PDLINE_NAME);
        $('#LProjectName').val(row.PROJECT_NAME);
        $('#LFrequency').val(row.FREQUENCY);
        $('#LCheck_Name').val(row.CHECK_NAME);
        $('#LCheck_Item').val(row.CHECK_ITEM);
        $('#LUnit').val(row.UNIT);
        $('#LCheck_Qty').val(row.CHECK_QTY);
        $('#LUpper').val(row.UPPER);
        $('#LFloor').val(row.FLOOR);

        var chk = document.getElementById('isAutoAssy1');
        if (row.STATUS == "Y") {
            chk.checked = true;


        } else {
            chk.checked = false;

        }
    }
}
var PTYPE1;
var PTYPE2;
var PTYPE3;

function insert() {
    var user = $("#user").text();
    var ID = PTYPE1;
    var ProjectName = $("#LProjectName").val();
    var PdlineName = $("#LPdlineName").val();
    var ModelName = $("#LModelName").val();
    var Frequency = $("#LFrequency").val();
    var Check_Name = $("#LCheck_Name").val();
    var Check_Item = $("#LCheck_Item").val();
    var Unit = $("#LUnit").val();
    var Check_Qty = $("#LCheck_Qty").val();
    var Upper = $("#LUpper").val();
    var Floor = $("#LFloor").val();
    var xz = document.getElementById("isAutoAssy1");
    var isAutoAssy = xz.checked;
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { isAutoAssy: isAutoAssy, ModelName: ModelName, user: user, ProjectName: ProjectName, PdlineName: PdlineName, Frequency: Frequency, Check_Name: Check_Name, Check_Item: Check_Item, Unit: Unit, Check_Qty: Check_Qty, Upper: Upper, Floor: Floor, funcName: 'UpdateTemplateInfo1' },
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
                Show();
            }
            else if (res[0].ERR_CODE == "Y") {

                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                $("#mymodal").modal('hide');
                Show();

            }
        }
    });
}

function addAutoAssy1(value, row, index) {
    return [
        '<img id="delete" src="../../../img/del.png" style="cursor: pointer" title="单击删除当前数据" />'
    ].join('');
}
window.operateDownEvents1 = {
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
                url: "../../../controller/OQC-QUALITY/E10.ashx",
                type: "post",
                data: { funcName: 'del', ModelName: row.MODEL_NAME, user: user, NUMBER_ID: row.PROJECT_ID, ProjectName: row.PROJECT_NAME, PdlineName: row.PDLINE_NAME, Check_Name: row.CHECK_NAME, Check_Item: row.CHECK_ITEM,  },
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
                    Show();
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
}


function download() {

    var TemplateN = "E-CHECK";
    var LOG = "";
    let myDate = new Date();
    var date = myDate.toLocaleDateString();
    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr>";
    var tableHtmlEnd = "</tr>";
    var TYPE = "<td align='center'>线体</td><td align='center'>机种</td><td align='center'>制程名称</td><td align='center'>点检制程名称</td><td align='center'>检查事项</td><td align='center'>单位</td><td align='center'>抽检数量</td><td align='center'>管控上限</td><td align='center'>管控下限</td><td align='center'>点检频率</td>";
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
        url: "../../../controller/OQC-QUALITY/E10.ashx?funcName=excel&user=" + user + "&Path=" + files + "",
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
    Show();
}


function SelectDown() {
    var user = $("#user").text();
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E10.ashx",
        data: { PdlineName: PdlineName, ModelName: ModelName, funcName: 'ShowDown' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var excelBlob = new Blob([res[0].ERR_MSG], {
                    type: 'application/vnd.ms-excel'
                });
                var oa = document.createElement('a');
                oa.href = URL.createObjectURL(excelBlob);
                oa.download = ModelName + "_" + PdlineName + '.xls';
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
