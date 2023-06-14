$(document).ready(function () {
    //var user = "12650378";

    var user = getCookie("Mes3User");
    $('#user').text(user);
    $('#type').text("点检|点检修改");
    GetBuNo();
})
function GetBuNo() {
    var user = $("#user").text();
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { user: user, funcName: 'ShowBuNo' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $('#Section_Name').val(res[0].ERR_MSG);
                $('#type').text(res[0].ERR_SN);
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
function E06Keydown(event) {
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
                url: "../../../controller/E-CHECK/E06.ashx",
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
                        $('#PdlineName').val(res[0].ERR_MSG.split('|')[0]);
                        $('#ModelName').val(res[0].ERR_MSG.split('|')[1]);
                        $('#ProjectNo').val(res[0].ERR_MSG.split('|')[2]);
                        $('#ProjectName').val(res[0].ERR_MSG.split('|')[3]);

                        GetProcess();
                    }
                }
            });
        }
    }
}




function GetPdline() {
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
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
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { funcName: 'ShowTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TEMPLATE + "'>" + res[i].TEMPLATE + "</option>";
                }
                $("#ProjectName").html(str);
            }
        }
    });
}
//function E06Keydown(event) {
//    var e = event || window.event || arguments.callee.caller.arguments[0];
//    if (event.keyCode == "13") {
//        var JJ = $("#JJ").val()

//        if (JJ == '') {
//            var error_msg = "请输入线体!";
//            swal({
//                text: error_msg,
//                type: "error",
//                confirmButtonColor: '#3085d6'
//            })
//            return;
//        }
//        $.ajax({
//            method: "post",
//            url: "../../../controller/E-CHECK/E06.ashx",
//            data: { JJ: JJ, funcName: 'ShowPdlineJJ' },
//            dataType: "json",
//            async: false,
//            success: function (res) {
//                if (res != null) {
//                    var str = "<option value=''></option>";

//                    for (var i = 0; i < res.length; i++) {
//                        str += "<option value='" + res[i].PDLINE_NAME + "'>" + res[i].PDLINE_NAME + "</option>";
//                    }
//                    $("#PdlineName").html(str);
//                    $('#JJ').val("");
//                }
//            }
//        });
//    }
//}

function ShowProcess() {
    var PdlineName = $("#PdlineName").val();
    var ModelName = $("#ModelName").val();

    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { ModelName: ModelName, PdlineName: PdlineName, funcName: 'ShowProject' },
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

function ShowPdline() {
    var PdlineName = $("#PdlineName").val();

    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { PdlineName: PdlineName, funcName: 'ShowModel' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
                }
                $("#ModelName").html(str);
            } else {
                var error_msg = "此线体未维护机种对应上下线信息";
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });


    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { PdlineName: PdlineName, funcName: 'ShowProcess' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].PROCESS_NAME + "'>" + res[i].PROCESS_NAME + "</option>";
                }
                $("#ProcessName").html(str);
            }
        }
    });
}
//function ShowProject() {
//    var Section_Name = $("#Section_Name").val();
//    var PdlineName = $("#PdlineName").val();
//    var ProcessName = $("#ProcessName").val();
//    var Template = $("#Template").val();
//    $.ajax({
//        method: "post",
//        url: "../../../controller/E-CHECK/E06.ashx",
//        data: { Section_Name: Section_Name, PdlineName: PdlineName, ProcessName:ProcessName,Template: Template, funcName: 'ShowProject' },
//        dataType: "json",
//        async: false,
//        success: function (res) {
//            if (res != null) {
//                var str = "<option value=''></option>";

//                for (var i = 0; i < res.length; i++) {
//                    str += "<option value='" + res[i].PROJECT_NAME + "'>" + res[i].PROJECT_NAME + "</option>";
//                }
//                $("#ProjectName").html(str);
//            } else {
//                var error_msg = "此人员部门无操作此模板权限";
//                swal({
//                    text: error_msg,
//                    type: "error",
//                    confirmButtonColor: '#3085d6'
//                })
//            }
//        }
//    });
//}
var TemplateQty;
var Typ1; var Typ2; var Typ3; var Typ4; var Typ5;

$(function () {
    $("#datetimepicker").datetimepicker({
        format: 'yyyy-mm-dd',
        language: 'zh-CN',
        weekStart: 1,
        todayBtn: 1,//显示‘今日’按钮
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        minView: 2,
        linked: true,
        /*        startDate: new Date(),*/
        clearBtn: true,//清除按钮
        forceParse: 0
    });
    GetDate();
});
function GetDate() {
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { funcName: 'GetDate' },
        dataType: "json",
        async: false,
        success: function (res) {
            $("#datetimepicker").val(res[0].ERR_MSG);
            $("#dataType").val(res[0].ERR_CODE);
            Datetime = res[0].ERR_TIME;
        }
    });
}
function GetProcess() {
    var user = $("#user").text();
    var type = $("#type").text();
    var ProjectName = $("#ProjectName").val();
    var Section_Name = $("#Section_Name").val();
    var PdlineName = $("#PdlineName").val();
    var ProjectNo = $("#ProjectNo").val();
    var ModelName = $("#ModelName").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var dataType = $("#dataType").val();
    if (dataType == "--请选择--") {
        var error_msg = "请选择班别!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (PdlineName == "") {
        var error_msg = "请选择线体!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (ProjectNo == "") {
        var error_msg = "请刷入工站序号!";
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
        var error_msg = "请选择项目名称!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { ProjectNo: ProjectNo, ModelName: ModelName, type: type, user: user, datetimepicker: datetimepicker, dataType: dataType, PdlineName: PdlineName, Section_Name: Section_Name, ProjectName: ProjectName, funcName: 'GetProcess' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $('#DnNo').val(res[0].ERR_MSG);
                Show();
            }
            else if (res[0].ERR_CODE == "Y") {

                setTimeout(function () {
                    var error_msg = res[0].ERR_MSG;
                    swal({
                        text: error_msg,
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    })
                }, 1);



       
            }
        }
    });
}

function Show() {
    var DnNo = $("#DnNo").val();
    var ProjectName = $("#ProjectName").val();
    var Section_Name = $("#Section_Name").val();
    var dataType = $("#dataType").val();

    if (dataType == "白班") {
        var url = "../../../controller/E-CHECK/E06.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: 'PROJECT_NO', title: '工站序号', align: 'center', width: 20, },
            { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
            { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
            { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
            { field: 'FREQUENCY', title: '抽检频率', align: 'center', width: 20, },
            { field: 'UNIT', title: '单位', align: 'center', width: 20, },
            { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
            { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },
            { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
            { field: 'TYPE1', title: '08:00-10:00', align: 'center', width: 20, },
            { field: 'TYPE2', title: '10:00-12:00', align: 'center', width: 20, },
            { field: 'TYPE3', title: '13:00-15:00', align: 'center', width: 20, },
            { field: 'TYPE4', title: '15:00-17:00', align: 'center', width: 20, },
            { field: 'TYPE5', title: '17:00-19:00', align: 'center', width: 20, },
            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
    if (dataType == "夜班") {
        var url = "../../../controller/E-CHECK/E06.ashx?funcName=show&&Section_Name=" + Section_Name + "&&DnNo=" + DnNo;
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
            { field: 'PROJECT_NO', title: '工站序号', align: 'center', width: 20, },
            { field: 'CHECK_NO', title: '点检序号', align: 'center', width: 20, },
            { field: 'CHECK_NAME', title: '点检制程事项', align: 'center', width: 20, },
            { field: 'CHECK_ITEM', title: '检查项目', align: 'center', width: 20, },
            { field: 'FREQUENCY', title: '抽检频率', align: 'center', width: 20, },
            { field: 'UNIT', title: '单位', align: 'center', width: 20, },
            { field: 'CHECK_QTY', title: '抽测数量', align: 'center', width: 20, },
            { field: 'FLOOR', title: '点检下限', align: 'center', width: 20, },
            { field: 'UPPER', title: '点检上限', align: 'center', width: 20, },
            { field: 'TYPE1', title: '20:00-22:00', align: 'center', width: 20, },
            { field: 'TYPE2', title: '22:00-24:00', align: 'center', width: 20, },
            { field: 'TYPE3', title: '01:00-03:00', align: 'center', width: 20, },
            { field: 'TYPE4', title: '03:00-05:00', align: 'center', width: 20, },
            { field: 'TYPE5', title: '06:00-08:00', align: 'center', width: 20, },
            { field: '编辑', title: '编辑', align: 'center', width: 20, events: operateDownEvents, formatter: addAutoAssy },]
        });
    }
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
        PTYPE1 = row.NUMBER_ID;
        PTYPE2 = row.WORK_NO;
        PTYPE3 = row.PROJECT_NAME;
        $('#Remark').val(row.REMARK);
        $('#Check_No').val(row.CHECK_NO);
        $('#Check_Name').val(row.CHECK_NAME);
        $('#Check_Item').val(row.CHECK_ITEM);
        $('#Unit').val(row.UNIT);
        $('#Check_Qty').val(row.CHECK_QTY);
        $('#Upper').val(row.UPPER);
        $('#Floor').val(row.FLOOR);
        $('#Project_No').val(row.PROJECT_NO);
        $('#Type1').val(row.TYPE1);
        $('#Type2').val(row.TYPE2);
        $('#Type3').val(row.TYPE3);
        $('#Type4').val(row.TYPE4);
        $('#Type5').val(row.TYPE5);
        $('#Frequency').val(row.FREQUENCY);
        var dataType = $("#dataType").val();
        var type = $("#type").text();

        if (dataType == "白班") {
            $("#Typ1").text("08:00-10:00");
            $("#Typ2").text("10:00-12:00");
            $("#Typ3").text("13:00-15:00");
            $("#Typ4").text("15:00-17:00");
            $("#Typ5").text("17:00-19:00");
        }
        if (dataType == "夜班") {
            $("#Typ1").text("20:00-22:00");
            $("#Typ2").text("22:00-24:00");
            $("#Typ3").text("01:00-03:00");
            $("#Typ4").text("03:00-05:00");
            $("#Typ5").text("06:00-08:00");
        }
        $.ajax({
            method: "post",
            url: "../../../controller/E-CHECK/E06.ashx",
            data: { funcName: 'GetDate' },
            dataType: "json",
            async: false,
            success: function (res) {
                Datetime = res[0].ERR_TIME;
            }
        });
        if (type == "点检" || type == "异常") {
            if (row.TYPE1 == "" || row.TYPE1 ==null) {
                if (row.FREQUENCY == "12") {
                    if (dataType == "白班") {
                        if (Datetime < 12 || Datetime >= 8) {
                            document.getElementById("Type1").disabled = false;
                        }
                    }
                    if (dataType == "夜班") {
                        if (Datetime < 24 || Datetime >= 20) {
                            document.getElementById("Type1").disabled = false;
                        }
                    }
                } else {
                    document.getElementById("Type1").disabled = true;

                }
            }
            else {
                var TYPE1 = $("#Typ1").text();
                var start = TYPE1.split('-')[0].split(':')[0];
                var end = TYPE1.split('-')[1].split(':')[0];
                if (end < start) {
                    if (Datetime >= start || Datetime < end) {
                        document.getElementById("Type1").disabled = false;
                    } else {
                        document.getElementById("Type1").disabled = true;
                    }
                }
                if (end > start) {
                    if (Datetime >= start && Datetime < end) {
                        document.getElementById("Type1").disabled = false;
                    }
                    else {
                        document.getElementById("Type1").disabled = true;
                    }
                }
            }
            if (row.TYPE2 == "/") {
                document.getElementById("Type2").disabled = true;
            } else {
                var TYPE2 = $("#Typ2").text();
                var start = TYPE2.split('-')[0].split(':')[0];
                var end = TYPE2.split('-')[1].split(':')[0];
                if (end < start) {
                    if (Datetime >= start || Datetime < end) {
                        document.getElementById("Type2").disabled = false;
                    } else {
                        document.getElementById("Type2").disabled = true;
                    }
                }
                if (end > start) {
                    if (Datetime >= start && Datetime < end) {
                        document.getElementById("Type2").disabled = false;
                    }
                    else {
                        document.getElementById("Type2").disabled = true;
                    }
                }
            }

            if (row.TYPE3 == "/") {
                document.getElementById("Type3").disabled = true;
            } else {
                var TYPE3 = $("#Typ3").text();
                var start = TYPE3.split('-')[0].split(':')[0];
                var end = TYPE3.split('-')[1].split(':')[0];
                if (end < start) {
                    if (Datetime >= start || Datetime < end) {
                        document.getElementById("Type3").disabled = false;
                    } else {
                        document.getElementById("Type3").disabled = true;
                    }
                }
                if (end > start) {
                    if (Datetime >= start && Datetime < end) {
                        document.getElementById("Type3").disabled = false;
                    }
                    else {
                        document.getElementById("Type3").disabled = true;
                    }
                }
            }

            if (row.TYPE4 == "/") {
                document.getElementById("Type4").disabled = true;
            } else {
                var TYPE4 = $("#Typ4").text();
                var start = TYPE4.split('-')[0].split(':')[0];
                var end = TYPE4.split('-')[1].split(':')[0];
                if (end < start) {
                    if (Datetime >= start || Datetime < end) {
                        document.getElementById("Type4").disabled = false;
                    } else {
                        document.getElementById("Type4").disabled = true;
                    }
                }
                if (end > start) {
                    if (Datetime >= start && Datetime < end) {
                        document.getElementById("Type4").disabled = false;
                    }
                    else {
                        document.getElementById("Type4").disabled = true;
                    }
                }
            }
            if (row.TYPE5 == "/") {
                document.getElementById("Type5").disabled = true;
            } else {
                var TYPE5 = $("#Typ5").text();
                var start = TYPE5.split('-')[0].split(':')[0];
                var end = TYPE5.split('-')[1].split(':')[0];
                if (end < start) {
                    if (Datetime >= start || Datetime < end) {
                        document.getElementById("Type5").disabled = false;
                    } else {
                        document.getElementById("Type5").disabled = true;
                    }
                }
                if (end > start) {
                    if (Datetime >= start && Datetime < end) {
                        document.getElementById("Type5").disabled = false;
                    }
                    else {
                        document.getElementById("Type5").disabled = true;
                    }
                }
            }
        }
    }
}
var Datetime;





var PTYPE1;
var PTYPE2;
var PTYPE3;

function insert() {
    var user = $("#user").text();
    var ID = PTYPE1;
    var DnNo = PTYPE2;
    var Pro = PTYPE3;
    var Remark = $("#Remark").val();
    var ModelName = $("#ModelName").val();
    var Check_No = $("#Check_No").val();
    var Check_Name = $("#Check_Name").val();
    var Check_Item = $("#Check_Item").val();
    var Unit = $("#Unit").val();
    var Check_Qty = $("#Check_Qty").val();
    var Upper = $("#Upper").val();
    var Floor = $("#Floor").val();
    var Project_No = $("#Project_No").val();
    var Section_Name = $("#Section_Name").val();
    var xz = document.getElementById("isAutoAssy");
    var isAutoAssy = xz.checked;
    var PdlineName = $("#PdlineName").val();
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { ProjectNo: Project_No, PdlineName: PdlineName, Check_No: Check_No, Check_Name: Check_Name, Check_Item: Check_Item, Unit: Unit, Check_Qty: Check_Qty, Upper: Upper, Floor: Floor, ModelName: ModelName, Remark: Remark, Section_Name: Section_Name, isAutoAssy: isAutoAssy, TemplateQty: TemplateQty, Pro: Pro, DnNo: DnNo, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, ID: ID, funcName: 'UpdateTemplateInfo1' },
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
                if (error_msg == "NG,输入值不在允许范围内!" || error_msg == "NG,输入值为NG,请确认!") {
                    $("#mymodal1").modal('show');
                    var chk = document.getElementById('isAutoAssy');
                    chk.checked = true;
                }
                else {
                    swal({
                        text: error_msg,
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    })
                    $("#mymodal").modal('hide');
                    Show();
                }
            }
        }
    });
}


function Save() {
    var user = $("#user").text();
    var ID = $("#Id").val();
    var DnNo = $("#Mo").val();
    var Pro = $("#Pro").val();

    //var xz = document.getElementById("isAutoAssy");
    //var isAutoAssy = xz.checked;
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); var Type13 = $("#Type13").val(); var Type14 = $("#Type14").val(); var Type15 = $("#Type15").val();
    var Type16 = $("#Type16").val(); var Type17 = $("#Type17").val(); var Type18 = $("#Type18").val(); var Type19 = $("#Type19").val(); var Type20 = $("#Type20").val();
    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { TemplateQty: TemplateQty, Pro: Pro, DnNo: DnNo, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Type13: Type13, Type14: Type14, Type15: Type15, Type16: Type16, Type17: Type17, Type18: Type18, Type19: Type19, Type20: Type20, ID: ID, funcName: 'Save' },
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
function Clear() {
    $("#mymodal1").modal('hide');
    $("#mymodal").modal('hide');
}
function insert1() {
    var user = $("#user").text();
    var ID = PTYPE1;
    var DnNo = PTYPE2;
    var Pro = PTYPE3;
    var xz = document.getElementById("isAutoAssy");
    var isAutoAssy = xz.checked;
    var Section_Name = $("#Section_Name").val();
    var Remark = $("#Remark").val();
    var ModelName = $("#ModelName").val();
    var Check_No = $("#Check_No").val();
    var Check_Name = $("#Check_Name").val();
    var Check_Item = $("#Check_Item").val();
    var Unit = $("#Unit").val();
    var Check_Qty = $("#Check_Qty").val();
    var Upper = $("#Upper").val();
    var Floor = $("#Floor").val();
    var PdlineName = $("#PdlineName").val();
    var Project_No = $("#Project_No").val();
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();

    $.ajax({
        method: "post",
        url: "../../../controller/E-CHECK/E06.ashx",
        data: { ProjectNo: Project_No, PdlineName: PdlineName, ModelName: ModelName, Remark: Remark, Section_Name: Section_Name, isAutoAssy: isAutoAssy, TemplateQty: TemplateQty, Pro: Pro, DnNo: DnNo, user: user, Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Check_No: Check_No, Check_Name: Check_Name, Check_Item: Check_Item, Unit: Unit, Check_Qty: Check_Qty, Upper: Upper, Floor: Floor, ModelName: ModelName, ID: ID, funcName: 'UpdateTemplateInfo1L' },
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
                $("#mymodal1").modal('hide');
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
                $("#mymodal1").modal('hide');

                Show();
            }
        }
    });
}

