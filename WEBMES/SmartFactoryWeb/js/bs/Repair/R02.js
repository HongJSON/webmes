$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#getInfo').text(user);
})
function R02keydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var item = $("#item").val()
        var boxid = $("#boxid").val()
        if (boxid == "") {
            alert("请輸入箱號");
            return;
        }
        if (item == "") {
            alert("請選擇箱號打包類別");
            return;
        }
        add();
    }
}
function add() {
    var item = $("#item").val()
    var boxid = $("#boxid").val()
    var userid = $("#getInfo").text()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R02Controller.ashx",
        data: { 'funcName': 'add', 'boxid': boxid, 'item': item, 'userid': userid },
        dataType: "json",
        success: function (res) {
            if (res.ERR_CODE == "N") {
                $("#boxid").val("");
                $("#boxid").focus();
                show();
                return;
            } else if (res.ERR_CODE == "Y") {
                R02alert(res.ERR_MSG)
                $("#boxid").val("");
                $("#boxid").focus();
                return;
            }
        }
    })
}
function show() {
    var userid = $("#getInfo").text()
    jQuery("#jqGridRepairStep").GridUnload();
    jQuery("#jqGridRepairStep").jqGrid(
        {
            url: "../../../controller/Repair/R02Controller.ashx?funcName=show&userid=" + userid,
            datatype: "json",//请求数据返回的类型。可选json,xml,txt
            colNames: ['工單','箱号', '料号', '數量', '倉別', '操作'],//jqGrid的列显示名字
            colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
                        { name: 'ORDER_NO', index: 'ORDER_NO', width: 120, align: 'center' },
                        { name: 'REJECTED_ID', index: 'REJECTED_ID', width: 120, align: 'center' },
                        { name: 'PRODUCT_ID', index: 'PRODUCT_ID', width: 135, align: 'center' },
                        { name: 'RJ_QTY', index: 'RJ_QTY', width: 120, align: 'center' },
                        { name: 'STORE_LOC', index: 'STORE_LOC', width: 100, align: 'center' },
                        {
                            label: '删除', name: '', index: '', width: 50, align: 'center',
                            formatter: function (cellvalue, options, rowObject) {
                                var detail = "<img  onclick='btn_delPro(\"" + rowObject.REJECTED_ID + "\",\"" + rowObject.PRODUCT_ID + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
                                return detail;
                            },
                        }
            ],
            height: 250,
            rowNum: 10,//一页显示多少条
            rownumbers: true,  //显示行号
            rowList: [20, 30, 40],//可供用户选择一页显示多少条
            pager: '#jqGridPagerRepairStep',//表格页脚的占位符(一般是div)的id
            sortname: 'REJECTED_ID',//初始化的时候排序的字段
            sortorder: "desc",//排序方式,可选desc,asc
            mtype: "post",//向后台请求数据的ajax的类型。可选post,get
            viewrecords: true, //顯示總條數
            caption: "临时表",//表格的标题名字
            loadonce: true
        });
    /*创建jqGrid的操作按钮容器*/
    /*可以控制界面上增删改查的按钮是否显示*/
    jQuery("#jqGridRepairStep").jqGrid('navGrid', '#jqGridPagerRepairStep', { edit: false, add: false, del: false, search: true, searchtext: "查找" },
    {//SEARCH
        closeOnEscape: true, multipleSearch: true, closeAfterSearch: true, showQuery: true, refreshstate: 'current'
    })
    $('#jqGridRepairStep').jqGrid('navButtonAdd', "#jqGridPagerRepairStep",
                    {
                        title: "导出",
                        caption: "导出",
                        onClickButton:
                            function () {
                                doExport('#jqGridRepairStep', { type: 'xlsx' });
                            }
                    });;
}
function btn_delPro(REJECTED_ID, PRODUCT_ID) {
    var flag = confirm("確定要刪除該條記錄嗎!");
    if (!flag) {
        return;
    }
    var userid = $("#getInfo").text()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R02Controller.ashx",
        data: { 'REJECTED_ID': REJECTED_ID, 'funcName': 'btn_delPro', 'PRODUCT_ID': PRODUCT_ID, 'userid': userid },
        dataType: "json",
        success: function (res) {
         
                if (res.ERR_CODE == "Y") {
                    show();
                    R02alert("刪除成功");
                } else if (res.ERR_CODE == "N") {
                    R02alert(res.ERR_MSG);
                }
          
        }
    });
}
function btn_clear() {
    var flag = confirm("確定要清空嗎!");
    if (!flag) {
        return;
    }
    var userid = $("#getInfo").text()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R02Controller.ashx",
        data: { 'userid': userid, 'funcName': 'clear'},
        dataType: "json",
        success: function (res) {
                if (res.ERR_CODE == "Y") {
                    show();
                   
                    R02alert("清空成功");
                } else if (res.ERR_CODE == "N") {
                    R02alert(res.ERR_MSG);
                }
            
        }
    });
}
function btn_Click() {
    var flag = confirm("確定要拆箱嗎!");
    if (!flag) {
        return;
    }
    var item = $("#item").val()
    var userid = $("#getInfo").text()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R02Controller.ashx",
        data: { 'userid': userid, 'item': item, 'funcName': 'btn_Click' },
        dataType: "json",
        success: function (res) {
      
                if (res.ERR_CODE == "Y") {
                    show();
                    $("#boxid").val("");
                    $("#boxid").focus();
                    R02alert("拆箱成功");
                } else if (res.ERR_CODE == "N") {
                    R02alert(res.ERR_MSG);
                }
           
        }
    });
}
function R02alert(e) {
    $("body").append('<div id="msg"><div id="msg_top">信息<span class="msg_close">×</span></div><div id="msg_cont">' + e + '</div><div class="msg_close" id="msg_clear">确定</div></div>');
    $(".msg_close").click(function () {
        $("#msg").remove();
    });
}