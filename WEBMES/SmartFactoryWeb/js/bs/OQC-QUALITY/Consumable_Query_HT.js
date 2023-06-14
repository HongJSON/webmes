$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    Show();
})
function ShowSn() {
    var LabelType = $("#LabelType").val();
    if (LabelType == "无条码")
    {
        $('#CheckSn').hide();
    }
    if (LabelType== "有条码")
    {
        $('#CheckSn').show();
    }
}

function Add() {
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    var Process_Name = $("#Process_Name").val();
    var Consumable_Type = $("#Consumable_Type").val();
    var LabelType = $("#LabelType").val();
    var Sn = $("#Sn").val();
    var Check_Type = $("#Check_Type").val();
    var Remark = $("#Remark").val();
    var user = $("#user").text();
    if (LabelType == "有条码") {
        if (Sn == "") {
            var error_msg = "请输入条码!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
    }
    if (Check_Type == '') {
        var error_msg = "请选择刷入类型!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (LabelType == '--请选择--') {
        var error_msg = "请刷入条码类型!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Consumable_Type == '') {
        var error_msg = "请刷入物料类型!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Process_Name == '') {
        var error_msg = "请刷入工站!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ModelName == '') {
        var error_msg = "请刷入机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (PdlineName == '') {
        var error_msg = "请刷入线体!";
            swal({
                text: error_msg,
                type: "error",
                confirmButtonColor: '#3085d6'
            })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/Consumable_Query_HT.ashx",
        data: { user:user,Remark: Remark, Sn: Sn, Check_Type: Check_Type, ModelName: ModelName, Process_Name: Process_Name, Consumable_Type: Consumable_Type, LabelType: LabelType, PdlineName: PdlineName, funcName: 'Add' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "Y") {
                    var error_msg = res[0].ERR_MSG;
                    swal({
                        text: error_msg,
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    })
                Show();
            }
            else {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "success",
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
function Consumable_Query_HT1(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        setTimeout(function () {
        }, 1);
        var Label = $("#Label1").val()
        if (Label == '') {
            var error_msg = "请输入二维码!";

            setTimeout(function () {
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }, 1);

            document.getElementById("Label1").value = "";
            $("#Label1").focus();

        }
        else {

            $('#Consumable_Type').val(Label);


        }
    }
}

function Consumable_Query_HT(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        setTimeout(function () {
        }, 1);
        var Label = $("#Label").val()
        if (Label == '') {
            var error_msg = "请输入二维码!";

            setTimeout(function () {
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }, 1);

            document.getElementById("Label").value = "";
            $("#Label").focus();

        }
        else {
            $.ajax({
                method: "post",
                url: "../../../controller/OQC-QUALITY/Consumable_Query_HT.ashx",
                data: { Label: Label, funcName: 'ShowLabel' },
                dataType: "json",
                async: false,
                success: function (res) {
                    if (res[0].ERR_CODE == "Y") {
                        setTimeout(function () {
                            var error_msg = res[0].ERR_MSG;
                            swal({
                                text: error_msg,
                                type: "error",
                                confirmButtonColor: '#3085d6'
                            })
                        }, 1);
                        document.getElementById("Label").value = "";
                        $("#Label").focus();
                    }
                    else {
                        $('#PdlineName').val(Label.split('|')[0]);
                        $('#ModelName').val(Label.split('|')[1]);
                        $('#Process_Name').val(Label.split('|')[2]);
                    }
                }
            });
        }
    }
}
function Show() {
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();
    var Process_Name = $("#Process_Name").val();
    var Consumable_Type = $("#Consumable_Type").val();


    var url = "../../../controller/OQC-QUALITY/Consumable_Query_HT.ashx?funcName=show&&ModelName=" + ModelName + "&&Process_Name=" + Process_Name + "&&Consumable_Type=" + Consumable_Type + "&&PdlineName=" + PdlineName;
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
        // height: 800,        //就是这里，加上就可以固定表头
        fixedColumns: true,
        fixedNumber: 1,//固定列数
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        pageSize: 1000,
        columns: [{ title: 'ID', align: 'center', width: 15, formatter: function (value, row, index) { return index + 1; } },
            { field: 'PDLINE_NAME', title: '线体', align: 'center', width: 100, },
            { field: 'MODEL_NAME', title: '机种', align: 'center', width: 100, },
            { field: 'PROCESS_NAME', title: '制程名称', align: 'center', width: 100, },
            { field: 'CONSUMABLE_TYPE', title: '物料类型', align: 'center', width: 100, },
            { field: 'SN', title: '条码', align: 'center', width: 100, },
            { field: 'REMARK', title: '备注', align: 'center', width: 100, },
            { field: 'CREATE_DATE', title: '创建时间', align: 'center', width: 100, },
            { field: 'EMP_NAME', title: '创建人员', align: 'center', width: 100, },
            { field: 'UPDATE_DATE', title: '修改时间', align: 'center', width: 100, },
            { field: 'EMP_NAME1', title: '修改人员', align: 'center', width: 100, },]
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
                url: "../../../controller/OQC-QUALITY/Consumable_Query_HT.ashx",
                type: "post",
                data: { funcName: 'del', PdlineName: row.PDLINE_NAME, user: user, ModelName: row.MODEL_NAME, Process_Name: row.PROCESS_NAME, Consumable_Type: row.CONSUMABLE_TYPE, Sn: row.SN},
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
                        Show();
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

