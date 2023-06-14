var datas;

$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    getIP();
    getAuth_User();
    $("#lotid").focus();
})

function getIP() {
    $.ajax({
        method: "get",
        url: "../../../controller/OQC/Q01Controller.ashx",
        data: { funcName: 'getIP' },
        dataType: "text",
        async: false,
        success: function (res) {
            $("#ip").text(res);
        }
    });
}

function getAuth_User() {
    $.ajax({
        method: "get",
        url: "../../../controller/OQC/Q01Controller.ashx",
        data: { funcName: 'getAuth_User' },
        dataType: "text",
        async: false,
        success: function (res) {
            $("#auth_user").text(res);
        }
    });
}
function getCnt() {
    $.ajax({
        method: "get",
        url: "../../../controller/OQC/Q01Controller.ashx",
        data: { funcName: 'GetCnt' },
        dataType: "text",
        async: false,
        success: function (res) {
            console.log(res);
            $("#cnt").text(res);
        }
    });
}

function onKeyDownLotid(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情
    }
    if (e && e.keyCode == 13) { // enter 键  
        check();
    }
    if (e && e.keyCode == 9) { // TAB 键  
    }
}

function check() {
    var lotid = $("#lotid").val();
    var user = $("#user").text();
    if (lotid == "") {
        alert("請刷入LOT");
        ("#lotid").val("").focus();
        $("#cnt").val("");
        return;
    }
    $("#lotid").val("").focus();
    $("#cnt").val("");
    $.ajax({
        method: "get",
        url: "../../../controller/OQC/Q01Controller.ashx",
        data: { funcName: 'check', lotid: lotid, user: user },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                alert(res[0].ERR_MSG);
                return;
            } else {
                //$("#cnt").val(res.length);
                  getCnt();
                showTable();
            }
        }
    });
}
function showTable() {
    jQuery("#jqGridRepairStep").GridUnload();
    //jQuery("#jqGridOfflineLot").trigger("reloadGrid"); 
    jQuery("#jqGridRepairStep").jqGrid(
        {
            url: "../../../controller/OQC/Q01Controller.ashx?funcName=show",       //请求后台的URL（*）
            datatype: "json",//请求数据返回的类型。可选json,xml,txt
            colNames: ['LOT_ID', 'LOTIN_QTY', 'CREATE_USER', 'CREATE_DATE','操作'],//jqGrid的列显示名字
            colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
                        { name: 'LOT_ID', index: 'LOT_ID', width: 120, align: 'center' },
                        { name: 'IN_QTY', index: 'IN_QTY', width: 135, align: 'center' },
                        { name: 'CREATE_USER', index: 'CREATE_USER', width: 120, align: 'center' },
                        { name: 'CREATE_DATE', index: 'CREATE_DATE', width: 100, align: 'center' },
                 
                        {
                            label: '删除', name: '', index: '', width: 50, align: 'center',
                            formatter: function (cellvalue, options, rowObject) {
                                var detail = "<img  onclick='btn_delPro(\"" + rowObject.LOT_ID + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
                                return detail;
                            },
                        }
            ],
            height: 250,
            rowNum: 10,//一页显示多少条
            rownumbers: true,  //显示行号
            rowList: [20, 30, 40],//可供用户选择一页显示多少条
            pager: '#jqGridPagerRepairStep',//表格页脚的占位符(一般是div)的id
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

function show() {
    $("#table").bootstrapTable('destroy').bootstrapTable({
        url: "../../../controller/OQC/Q01Controller.ashx?funcName=show",       //请求后台的URL（*）
        method: 'get',
        async: false,
        dataType: 'json',
        classes: 'table',//边框
        toolbar: '#toolbar', //工具按钮用哪个容器
        striped: true, //是否显示行间隔色
        cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
        singleSelect: true,
        pagination: true, //是否显示分页（*）
        sortable: true, //是否启用排序
        sortOrder: "desc", //排序方式
        sexportDataType: 'all',   //导出文件方式  支持: 'basic', 'all', 'selected'. basic：本页数据，all，获取服务器所有数据，selected,本页选择行数据
        showExport: true,  //是否显示导出按钮
        buttonsAlign: "right",  //按钮位置
        exportTypes: ['excel'],  //导出文件支持: 'json', 'xml', 'png', 'csv', 'txt', 'sql'，'doc', 'excel', 'xlsx', 'pdf'
        Icons: 'glyphicon-export',//导出文件图标
        //queryParams: oTableInit.queryParams, //传递参数（*）
        search: true, //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
        strictSearch: true,
        showColumns: true, //是否显示所有的列
        showRefresh: true, //是否显示刷新按钮
        minimumCountColumns: 2, //最少允许的列数
        pageSize: 10,                       //每页的记录行数（*）
        pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
        paginationPreText: "上一頁",
        paginationNextText: "下一頁",
        paginationFirstText: "首頁",
        paginationLastText: "尾頁",
        clickToSelect: true, //是否启用点击选中行
        //height: 500, //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
        //uniqueId: "MODEL_ID", //每一行的唯一标识，一般为主键列
        showToggle: true, //是否显示详细视图和列表视图的切换按钮
        //cardView: false, //是否显示详细视图
        //detailView: false, //是否显示父子表
        responseHandler: function (data) {
            datas = data;
            return datas;
        },
        columns: [{
            title : 'ID',
            width: 25,
            formatter: function (value, row, index) {
                //获取每页显示的数量
                var pageSize = $('#table').bootstrapTable('getOptions').pageSize;
                //获取当前是第几页  
                var pageNumber = $('#table').bootstrapTable('getOptions').pageNumber;
                //返回序号，注意index是从0开始的，所以要加上1
                return pageSize * (pageNumber - 1) + index + 1;
            }
        }, {
            field: 'LOT_ID',
            title: 'LOT_ID',
            width: 100
        }, {
            field: 'IN_QTY',
            title: 'LOT數量',
            width: 50
        }, {
            field: 'CREATE_USER',
            title: '結批人員',
            width: 50
        }, {
            field: 'CREATE_DATE',
            title: '結批時間',
            width: 100
        }, {
            field: 'operate',
            title: '操作',
            width: 30,
            events: operateEvents,//给按钮注册事件
            formatter: addFunctionAlty//表格中增加按钮  
        }]
    }).bootstrapTable('load', datas);
}

function addFunctionAlty(value, row, index) {
    return [
    '<button id="delete" type="button" class="btn btn-default">刪除</button>'
    ].join('');
}
function btn_delPro(lot_id){
    $.ajax({
        method: "get",
        url: "../../../controller/OQC/Q01Controller.ashx",
        data: { funcName: 'deleteRow', lotid: lot_id },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                alert("發生異常！");
                return;
            } else {
                $("#lotid").val("").focus();
                $("#cnt").val("");
                getCnt();
                showTable();
            }
        }
    });
}
window.operateEvents = {
    'click #delete': function (e, value, row, index) {
        console.log(row);
        $.ajax({
            method: "get",
            url: "../../../controller/OQC/Q01Controller.ashx",
            data: { funcName: 'deleteRow', lotid: row.LOT_ID },
            dataType: "json",
            async: false,
            success: function (res) {
                if (res[0].ERR_CODE == "N") {
                    alert("發生異常！");
                    return;
                } else {
                    $("#lotid").val("").focus();
                    $("#cnt").val("");
                    showTable();
                }
            }
        });
    }
};

function addELot() {
    $("#lotid").val("").focus();
    $("#cnt").val("");
    $.ajax({
        method: "get",
        url: "../../../controller/OQC/Q01Controller.ashx",
        data: { funcName: 'addELot' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                alert(res[0].ERR_MSG);
                return;
            } else {
                var elot = res[0].ERR_MSG;
                var user = $("#user").text();
                $("#elot").val(elot);
                $.ajax({
                    method: "get",
                    url: "../../../controller/OQC/Q01Controller.ashx",
                    data: { funcName: 'saveELot', elot: elot, user: user },
                    dataType: "json",
                    async: false,
                    success: function (res) {
                        if (res[0].ERR_CODE == "N") {
                            alert(res[0].ERR_MSG);
                            jQuery("#jqGridRepairStep").html("")
                            return;
                        } else {
                            alert(res[0].ERR_MSG);
                            jQuery("#jqGridRepairStep").html("")
                        }
                    }
                });
            }
        }
    });
}

function printELot() {
    var elot = $("#elot").val();
    window.open("../../../report/creportOQC.aspx?u=" + elot + "");
    $("#elot").val("").focus();
}

function clearTmp() {
    $.ajax({
        method: "get",
        url: "../../../controller/OQC/Q01Controller.ashx",
        data: { funcName: 'clearTmp' },
        dataType: "json",
        async: false,
        success: function (res) {
            $("#lotid").val("").focus();
            jQuery("#jqGridRepairStep").html("")
            console.log(res);
            if (res[0].ERR_CODE == "Y") {
                swal({
                    text: res[0].ERR_MSG,
                    icon: "success",
                    button: "確認",
                });
            }
        }
    });
}