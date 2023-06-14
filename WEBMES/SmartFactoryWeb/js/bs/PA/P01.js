var lot_id;
var user;
var box_qty;
var qty;
var tableData;
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
    getBoxQty();
    showTmp();
})

function getIP() {
    $.get("../../../controller/PA/P01Controller.ashx", { funcName: "getIP" }, function (data) {
        $("#ip").text(data);
    }, "text");
}

function getBoxQty() {
    $.ajax({
        url: '../../../controller/PA/P01Controller.ashx?funcName=getBoxQty',
        type: "get",
        dataType: "json",
        async: false,
        success: function (res) {
            $("#box_qty").val(res);
        }
    })
}

function checkLotInfo() {
    lot_id = $("#lot_id").val();
    box_qty = $("#box_qty").val();
    qty = $("#qty").val();
    if (lot_id == "") {
        swal({
            text: "請刷入LOT號!",
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    if (qty == box_qty) {
        swal({
            text: "已滿箱，請點擊包裝結箱!",
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        $("#lot_id").val("");
        return;
    }
    $.ajax({
        url: "../../../controller/PA/P01Controller.ashx",
        type: "post",
        data: { funcName: "checkLotInfo", lot_id: lot_id, box_qty: box_qty, user: user },
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.ERR_CODE == "Y") {
                swal({
                    text: data.ERR_MSG,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                });
            } else if (data.ERR_CODE == "N") {
                if ($("#order_no").val() == "") {
                    $("#order_no").val(data.DATA.ORDER_NO);
                    $("#product_id").val(data.DATA.PRODUCT_ID);
                    $("#mo_type").val(data.DATA.MO_TYPE);
                }
                showTmp();
            }
            $("#lot_id").val("").focus();
        }
    })
    if ($("#box_id").val() != "") {
        $("#box_id").val("");
    }
}

//批號輸入框回車事件
$("#lot_id").bind("keypress", function (event) {
    if (event.keyCode == 13) {
        checkLotInfo();
    }
});

//展示臨時表數據
function showTmp() {
    $.ajax({
        url: '../../../controller/PA/P01Controller.ashx?funcName=showTmp',
        type: "get",
        dataType: "json",
        async: false,
        success: function (res) {
            tableData = res;
            if (res.length > 0) {
                $("#box_qty").attr("readonly", "readonly");
                $("#addBtn").removeAttr("disabled");
            } else {
                $("#box_qty").removeAttr("readonly");
                $("#addBtn").attr("disabled", "disabled")
            }
            var sum = 0;
            res.forEach((elem, idx, arr) => {
                sum += (elem.QUANTITY - elem.REMAINING_QTY)
            })
            $("#qty").val(sum);
        }
    })
    $('#tmpTable').bootstrapTable('destroy');
    $('#tmpTable').bootstrapTable({
        theadClasses: "bg-light-blue", //設置表頭顏色
        striped: true, //是否显示行间隔色
        pagination: false, //是否显示分页
        data: tableData,
        columns: [{
            title: 'ID',
            width: 5,
            formatter: function (value, row, index) {
                //返回序号，注意index是从0开始的，所以要加上1
                return index + 1;
            }
        }, {
            field: 'LOT_ID',
            title: 'LOT號'
        }, {
            field: 'ORDER_NO',
            title: '工單'
        }, {
            field: 'PRODUCT_ID',
            title: '料號'
        }, {
            field: 'QUANTITY',
            title: 'LOT數量'
        }, {
            field: 'PA_QTY',
            title: '包裝數量'
        }, {
            field: 'REMAINING_QTY',
            title: '結餘數量'
        }, {
            field: 'CREATE_USER',
            title: '操作人員'
        }, {
            field: 'CREATE_DATE',
            title: '操作日期'
        }]
    });
}

function addBox() {
    box_qty = $("#box_qty").val();
    pack_no = $("#pack_no").val();
    if (pack_no == "") {
        swal({
            text: "請輸入要綁定的號碼牌!",
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        url: "../../../controller/PA/P01Controller.ashx",
        type: "post",
        data: { funcName: "addBox", box_qty: box_qty, user: user },
        dataType: "json",
        async: false,
        success: function (data) {
            if (data.ERR_CODE == "N") {
                $("#box_id").val(data.DATA.BOX_ID);
                showTmp();
                swal({
                    text: "結箱成功!",
                    type: "success",
                    confirmButtonColor: '#3085d6',
                    timer: 1500
                })
            } else {
                swal({
                    text: "結箱失敗，請聯繫IT!",
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    })
}

function clearTmp() {
    swal({
        text: '確定要清空臨時表嗎?',
        type: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
    }).then(function () {
        box_qty = $("#box_qty").val();
        $.ajax({
            url: "../../../controller/PA/P01Controller.ashx",
            type: "post",
            data: { funcName: "clearTmp" },
            dataType: "json",
            async: false,
            success: function (data) {
                if (data.ERR_CODE == "N") {
                    showTmp();
                } else {
                    swal({
                        text: "刪除失敗，請聯繫IT!",
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    })
                }
            }
        })
    })
}