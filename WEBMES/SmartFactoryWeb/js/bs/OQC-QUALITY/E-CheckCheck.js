$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
/*    dataObj = [];*/
    show();
})
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
        clearBtn: true,//清除按钮
        forceParse: 0
    });
    $('#datetimepicker').focus(function () {
        $(this).blur();//不可输入状态
    })
});
$(function () {
    $("#datetimepicker1").datetimepicker({
        format: 'yyyy-mm-dd',
        language: 'zh-CN',
        weekStart: 1,
        todayBtn: 1,//显示‘今日’按钮
        autoclose: 1,
        todayHighlight: 1,
        startView: 2,
        minView: 2,
        clearBtn: true,//清除按钮
        forceParse: 0
    });
    $('#datetimepicker1').focus(function () {
        $(this).blur();//不可输入状态
    })
});
function SelectShow() {
    show();
}



function Insert() {
    $("#mymodal").modal('show');
    GetModel();

}
function GetModel() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { funcName: 'ShowModel' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].MODEL_NAME + "'>" + res[i].MODEL_NAME + "</option>";
                }
                $("#jizhong").html(str);
            }
        }
    });
}
function GetTemplate() {
    var ModelName = $("#jizhong").val();
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { ModelName: ModelName,funcName: 'GetTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "<option value=''></option>";

            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].TEMPLATE + "'>" + res[i].TEMPLATE + "</option>";
            }
            $("#moban").html(str);
        }
    });
}
function GetCqp() {
    var ModelName = $("#jizhong").val();
    var Template = $("#moban").val();
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { ModelName: ModelName, Template: Template, funcName: 'GetCqp' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "<option value=''></option>";

            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].CQP + "'>" + res[i].CQP + "</option>";
            }
            $("#gongzhanhao").html(str);
        }
    });
}
function GetProcess() {
    var ModelName = $("#jizhong").val();
    var Template = $("#moban").val();
    var Cqp = $("#gongzhanhao").val();
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Cqp == "") {
        var error_msg = "请选择工站号!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { ModelName: ModelName, Template: Template, Cqp: Cqp, funcName: 'GetProcess' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "<option value=''></option>";

            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].PROCESS_NAME + "'>" + res[i].PROCESS_NAME + "</option>";
            }
            $("#zhicheng").html(str);
        }
    });
}
function GetPoint() {
    var ModelName = $("#jizhong").val();
    var Template = $("#moban").val();
    var Cqp = $("#gongzhanhao").val();
    var PROCESS_NAME = $("#zhicheng").val();
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Cqp == "") {
        var error_msg = "请选择工站号!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (PROCESS_NAME == "") {
        var error_msg = "请选择制程!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { ModelName: ModelName, Template: Template, Cqp: Cqp, PROCESS_NAME: PROCESS_NAME, funcName: 'GetPoint' },
        dataType: "json",
        async: false,
        success: function (res) {
            var str = "<option value=''></option>";

            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].CHECK_POINT + "'>" + res[i].CHECK_POINT + "</option>";
            }
            $("#jiancha").html(str);
        }
    });
}
function GetFu() {
    var ModelName = $("#jizhong").val();
    var Template = $("#moban").val();
    var Cqp = $("#gongzhanhao").val();
    var PROCESS_NAME = $("#zhicheng").val();
    var CheckPoint = $("#jiancha").val();
    if (ModelName == "") {
        var error_msg = "请选择机种!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Template == "") {
        var error_msg = "请选择模板!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (Cqp == "") {
        var error_msg = "请选择工站号!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (PROCESS_NAME == "") {
        var error_msg = "请选择制程!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (CheckPoint == "") {
        var error_msg = "请选择检查事项!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { ModelName: ModelName, Template: Template, Cqp: Cqp, PROCESS_NAME: PROCESS_NAME, CheckPoint: CheckPoint, funcName: 'CheckPoint' },
        dataType: "json",
        async: false,
        success: function (res) {

            $('#shangxian').val(res[0].ERR_CODE);
            $('#xiaxian').val(res[0].ERR_MSG);
            $('#danwei').val(res[0].ERR_MSG1)
        }
    });
}
function show() {
    var Processname = $("#Processname").val();
    var CheckPoint = $("#CheckPoint").val();
    var ModelName = $("#ModelName").val();
    var Cqp = $("#Cqp").val();
    var Template = $("#Template").val();
    var datetimepicker = document.getElementById("datetimepicker").value;
    var url = "../../../controller/OQC-QUALITY/E-CheckCheck.ashx?funcName=show&&Processname=" + Processname + "&datetimepicker=" + datetimepicker + "&CheckPoint=" + CheckPoint + "&Cqp=" + Cqp + "&Template=" + Template + "&ModelName=" + ModelName;
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
            field: 'YEAR_DATE',
                title: '日期',
                width: 400
            }, {
            field: 'CLASS_TYPE',
                title: '班别',
                width: 120
            },{
            field: 'MODEL_NAME',
            title: '机种',
            width: 120
        }, {
            field: 'CQP',
            title: 'CQP工站',
            width: 120
        }, {
            field: 'PROCESS_NAME',
            title: '制程',
            width: 120
        }, {
            field: 'TEMPLATE',
            title: '模板',
            width: 120
        }, {
            field: 'CHECK_POINT',
            title: '检查事项',
            width: 170
        }, {
            field: 'UPPER',
            title: '上限',
            width: 35
        }, {
            field: 'FLOOR',
            title: '下限',
            width: 35
        }, {
            field: 'UNIT',
            title: '单位',
            width: 70
            }, {
            field: 'WORK_ORDER',
                title: '工单',
                width: 120
            }, {
            field: 'PART_NO',
                title: '料号',
                width: 120
            }, {
            field: 'CHECK_USER',
                title: '检查人员',
                width: 120
            }, {
            field: 'PLACE',
                title: '地点',
                width: 100
            }, {
            field: 'TIME1',
            title: '8:00-12:00',
                width: 200
            }, {
            field: 'TIME2',
            title: '13:00-17:00',
                width: 200
            }, {
            field: 'TIME3',
            title: '17:30-19:30',
                width: 200
            },{
            field: 'TIME4',
            title: '20:00-00:00',
            width: 200
        }, {
            field: 'TIME5',
            title: '1:00-5:00',
            width: 120
        }, {
            field: 'TIME6',
            title: '5:00-7:00',
            width: 200
        }, {
            field: 'EMP_NAME',
            title: '创建人员',
            width: 120
            }, {
                field: 'CREATE_DATE',
                title: '创建时间',
                width: 300
            }, {
            field: '编辑',
            title: '编辑',
            width: 40,
            events: operateDownEvents,//给按钮注册事件
            formatter: addAutoAssy//表格中增加按钮
        }]
    });
}
window.operateDownEvents = {
    'click #autoAssy': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        $("#mymodal1").modal('show');
        $("#datetimepicker2").val(row.YEAR_DATE);
        $("#jizhong1").val(row.MODEL_NAME);
        $("#moban1").val(row.TEMPLATE);
        $("#gongzhanhao1").val(row.CQP);
        $("#zhicheng1").val(row.PROCESS_NAME);
        $("#jiancha1").val(row.CHECK_POINT);
        $("#shangxian1").val(row.UPPER);
        $("#xiaxian1").val(row.FLOOR);
        $("#danwei1").val(row.UNIT);
        $("#gongdan1").val(row.WORK_ORDER);
        $("#liaohao1").val(row.PART_NO);
        $("#banbie1").val(row.CLASS_TYPE);
        $("#jianchayuanyuan1").val(row.CHECK_USER);
        $("#didian1").val(row.PLACE);
        $("#time11").val(row.TIME1);
        $("#time21").val(row.TIME2);
        $("#time31").val(row.TIME3);
        $("#time41").val(row.TIME4);
        $("#time51").val(row.TIME5);
        $("#time61").val(row.TIME6);
       
    }
}



function addAutoAssy(value, row, index) {
    return [
        '<img id="autoAssy" src="../../../img/edit.png" style="cursor: pointer"/>'
    ].join('');
}
function insertNew() {
    var user = $("#user").text();
    var datetimepicker1 = document.getElementById("datetimepicker1").value;
    var ModelName = $("#jizhong").val();
    var Template = $("#moban").val();
    var Cqp = $("#gongzhanhao").val();
    var Processname = $("#zhicheng").val();
    var CheckPoint = $("#jiancha").val();
    var Upper = $("#shangxian").val();
    var Floor = $("#xiaxian").val();
    var Unit = $("#danwei").val();

    var gongdan = $("#gongdan").val();
    var liaohao = $("#liaohao").val();
    var banbie = $("#banbie").val();
    var jianchayuanyuan = $("#jianchayuanyuan").val();
    var didian = $("#didian").val();
    var time1 = $("#time1").val();
    var time2 = $("#time2").val();
    var time3 = $("#time3").val();
    var time4 = $("#time4").val();
    var time5 = $("#time5").val();
    var time6 = $("#time6").val();
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
    if (datetimepicker1 == "") {
        var error_msg = "日期为空,请检查!";
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
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { time6: time6, time5: time5, time4: time4, time3: time3, time2: time2, time1: time1, didian: didian, jianchayuanyuan: jianchayuanyuan, banbie: banbie, liaohao: liaohao, gongdan: gongdan, datetimepicker1: datetimepicker1, user: user, Processname: Processname, CheckPoint: CheckPoint, Floor: Floor, Upper: Upper, Unit: Unit, ModelName: ModelName,Cqp: Cqp, Template: Template, funcName: 'insertNew' },
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


function insertNew1() {
    var user = $("#user").text();
    var datetimepicker1 = document.getElementById("datetimepicker1").value;

    var datetimepicker1 = $("#datetimepicker2").val();

    var ModelName = $("#jizhong1").val();
    var Template = $("#moban1").val();
    var Cqp = $("#gongzhanhao1").val();
    var Processname = $("#zhicheng1").val();
    var CheckPoint = $("#jiancha1").val();
    var Upper = $("#shangxian1").val();
    var Floor = $("#xiaxian1").val();
    var Unit = $("#danwei1").val();

    var gongdan = $("#gongdan1").val();
    var liaohao = $("#liaohao1").val();
    var banbie = $("#banbie1").val();
    var jianchayuanyuan = $("#jianchayuanyuan1").val();
    var didian = $("#didian1").val();
    var time1 = $("#time11").val();
    var time2 = $("#time21").val();
    var time3 = $("#time31").val();
    var time4 = $("#time41").val();
    var time5 = $("#time51").val();
    var time6 = $("#time61").val();
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
    if (datetimepicker1 == "") {
        var error_msg = "日期为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/E-CheckCheck.ashx",
        data: { time6: time6, time5: time5, time4: time4, time3: time3, time2: time2, time1: time1, didian: didian, jianchayuanyuan: jianchayuanyuan, banbie: banbie, liaohao: liaohao, gongdan: gongdan, datetimepicker1: datetimepicker1, user: user, Processname: Processname, CheckPoint: CheckPoint, Floor: Floor, Upper: Upper, Unit: Unit, ModelName: ModelName, Cqp: Cqp, Template: Template, funcName: 'insertNew1' },
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
                $("#mymodal1").modal('hide');
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
