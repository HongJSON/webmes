var elot_id;
$(function () {
    user = getCookie("Mes3User");
    if (user != undefined && user != null) {
        $('#user').text(user);
    } else {
        swal({
            text: '未檢測到登陸信息，即將跳轉登陸！',
            type: 'warning',
            confirmButtonColor: '#3085d6',
        }).then(function () {
            window.location.href = "../../../login.html";
        })
    }
    getIP();
    showTmp();
})

//批號輸入框回車事件
$("#elot_id").bind("keypress", function (event) {
    if (event.keyCode == 13) {
        insertTmp();
    }
});

//  包裝點收
function paReceive() {
    elot_id = $("#elot_id").val();
    $.ajax({
        url: "../../../controller/PA/P03Controller.ashx",
        type: "post",
        data: { funcName: "PAReceive", elot_id: elot_id, user: user },
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.ERR_CODE == "N") {
                $("#elot_id").val("");
                showTmp();
                $("#qty").val("");
                swal({
                    text: data.ERR_MSG,
                    type: "success",
                    confirmButtonColor: '#3085d6',
                    timer: 1500
                })
            } else {
                swal({
                    text: data.ERR_MSG,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    })
}

//  檢查刷入ELOT資料
function insertTmp() {
    elot_id = $("#elot_id").val();
    if (elot_id == "") {
        swal({
            text: "請刷入ELOT！",
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        url: "../../../controller/PA/P03Controller.ashx",
        type: "post",
        data: { funcName: "insertTmp", elot_id: elot_id },
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.ERR_CODE == "N") {
                showTmp();
                $("#qty").val(data.ERR_MSG);
            } else {
                $("#elot_id").val("");
                swal({
                    text: data.ERR_MSG,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    })
}

function getIP() {
    $.get("../../../controller/PA/P03Controller.ashx", { funcName: "getIP" }, function (data) {
        $("#ip").text(data);
    }, "text");
}

function showTmp() {
    elot_id = $("#elot_id").val();
    $('#tmpTable').bootstrapTable('destroy');
    $('#tmpTable').bootstrapTable('destroy');
    $('#tmpTable').bootstrapTable({
        url: '../../../controller/PA/P03Controller.ashx?funcName=showTmp&elot_id=' + elot_id,
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: false, //是否显示分页
        columns: [{
            title: 'ID',
            width: 5,
            formatter: function (value, row, index) {
                //返回序号，注意index是从0开始的，所以要加上1
                return index + 1;
            }
        }, {
            field: 'LOT_ID',
            title: 'LOT_ID'
        }, {
            field: 'PRODUCT_ID',
            title: 'PRODUCT_ID'
        }, {
            field: 'PA_FLAG',
            title: 'PA_FLAG',
            width: 20
        }]
    });
}

function clearTmp() {
    $("#elot_id").val("");
    showTmp();
}