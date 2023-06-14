$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
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

function Add() {
    var user = $("#user").text();
    var ary_lot = $("#ary_lot").val();
    var quantity = $("#quantity").val();
    if (ary_lot=="") {
        var error_msg = "請輸入大對LOT";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (quantity=="") {
        var error_msg = "請輸入數量";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (isNaN(quantity)) {
        var error_msg = "輸入的數量不全是數字";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    } else {
        $.ajax({
            method: "post",
            url: "../../../controller/Base/B005Controller.ashx",
            data: { ary_lot: ary_lot, quantity: quantity, user: user, funcName: 'confirm' },
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
                document.getElementById("ary_lot").value = "";
                document.getElementById("quantity").value = "";
                $("#ary_lot").focus();
                show();
            }
        });
    }
}



function show() {
    var url = "";
    var user = $("#user").text();
    var ary_lot = $("#ary_lot").val();
    if (ary_lot == "") {
        url = "../../../controller/Base/B005Controller.ashx?funcName=show";
    }
    else {
        url = "../../../controller/Base/B005Controller.ashx?funcName=search&&ary_lot=" + ary_lot + "";
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
            field: 'ARY_LOT',
            title: '大對LOT'
        }, {
            field: 'FLAG',
            title: '狀態'
        }, {
            field: 'QUANTITY',
            title: '大對LOT總數'
        }, {
            field: 'QUANTITY_CREATED',
            title: '已下線數'
        }, {
            field: 'CREATE_USER',
            title: '修改人員'
        }, {
            field: 'CREATE_DATE',
            title: '修改時間'
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
            text: '確定要關閉此大對LOT嗎?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            var user = $("#user").text();
            $.ajax({
                url: "../../../controller/Base/B005Controller.ashx",
                type: "post",
                data: { funcName: 'del', ary_lot: row.ARY_LOT, user: user },
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
