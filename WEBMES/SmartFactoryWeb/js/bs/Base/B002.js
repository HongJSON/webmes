$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    getStep();
    getLine();
})


function lineChange() {
    var line = $("#line").val();
    var strLine = line.toString();
    if (strLine != "") {
        if (strLine.indexOf("B") != -1 || strLine.indexOf("F2") != -1 || strLine == "EGL-01") {
            $("#site").val("B棟");
            $("#site").attr("disabled", "disabled");
        }
        else {
            if (strLine == "NULL") {
                $("#site").val("");
                $("#site").removeAttr("disabled");
            }
            else {
                $("#site").val("A棟");
                $("#site").attr("disabled", "disabled");
            }
        }
    }
    else {
        $("#site").val("");
        $("#site").removeAttr("disabled");
    }
}


function getStep() {
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B002Controller.ashx",
        data: { funcName: 'getStep' },
        dataType: "json",
        success: function (res) {
            var str = "<option value=''></option>";
            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].STEP_ID + "'>" + res[i].STEP_DESC + "</option>";
            }
            $("#step").html(str);
        }
    });
}


function getLine() {
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B002Controller.ashx",
        data: { funcName: 'getLine' },
        dataType: "json",
        success: function (res) {
            var str = "<option value=''></option>";
            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].LINE_CODE + "'>" + res[i].LINE_CODE + "</option>";
            }
            $("#line").html(str);
        }
    });
}


function Add() {
    var user = $("#getInfo").text();
    var step = $("#step").val();
    var desc = $("#desc").val();
    var line = $("#line").val();
    var eqp = $("#eqp").val();
    var site = $("#site").val();
    var pos = $("#pos").val();
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B002Controller.ashx",
        data: { step: step, desc: desc, line: line, eqp: eqp, site: site, pos: pos, user: user, funcName: 'confirm' },
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
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
            show();
        }
    });

}



function show(type) {
    var url = "";
    if (type == "search") {
        var step = $("#step").val();
        var line = $("#line").val();
        var site = $("#site").val();
        url = "../../../controller/Base/B002Controller.ashx?funcName=search&&step=" + step + "&&line=" + line + "&&site=" + site + "";
    }
    else {
        url = "../../../controller/Base/B002Controller.ashx?funcName=show";
    }
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: url,
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: true, //是否显示分页
        columns: [{
            title: 'ID',
            width: 5,
            formatter: function (value, row, index) {
                return index + 1;
            }
        }, {
            field: 'LINE_ID',
            title: '線體'
        }, {
            field: 'STEP_ID',
            title: '站點'
        }, {
            field: 'EQP_ID',
            title: '机台編碼'
        }, {
            field: 'EQP_DESC',
            title: '機台描述'
        }, {
            field: 'EQP_STATION',
            title: '機台位置'
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
    '<img id="delete" src="../../../img/del.png" style="cursor: pointer" title="單擊刪除此行數據" />'
    ].join('');
}

window.operateEvents = {
    'click #delete': function (e, value, row, index) {
        console.log(row);
        let user = $("#user").text();
        console.log(user);
        swal({
            text: '確定要刪除此行數據嗎?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            $.ajax({
                url: "../../../controller/Base/B002Controller.ashx",
                type: "post",
                data: { funcName: 'del', eqp: row.EQP_ID, line: row.LINE_ID },
                dataType: "json",
                async: false,
                success: function (res) {
                    var error_msg = "";
                    if (res[0].ERR_CODE == "N") {
                        error_msg = res[0].ERR_MSG;
                    }
                    else if (res[0].ERR_CODE == "Y") {
                        error_msg = res[0].ERR_MSG;
                    }

                    swal({
                        text: res.MSG,
                        type: "success",
                        confirmButtonColor: '#3085d6'
                    })
                    show();
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
};
