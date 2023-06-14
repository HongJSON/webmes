$(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    getIP();
    show();
})
function getIP() {
    $.get("../../../controller/Base/B006Controller.ashx", { funcName: "getIP" }, function (data) {
        $("#ip").text(data);
    }, "text");
}
function show() {
    let upn = $("#upn").val();
    let order = $("#order").val();
    let status = $("#status").val();
    let user = $("#user").val();
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: '../../../controller/Base/B006Controller.ashx?funcName=show&upn=' + upn + '&order=' + order + '&status=' + status + '&user=' + user,
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
            field: 'UPN',
            title: '料號'
        }, {
            field: 'ORDER_NO',
            title: '工单'
        }, {
            field: 'STATUS',
            title: '待料狀態'
        }, {
            field: 'CREATE_USER',
            title: '創建人員'
        }, {
            field: 'OPERATE',
            title: '操作',
            width: 20,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }]
    });
}
