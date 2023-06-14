
$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#getInfo').text(user);


    //$("#drpprocess").change(function () {
    //    var drpprocess = document.getElementById("drpprocess").value;
    
    //    $.ajax({
    //        method: "post",
    //        url: "../../../controller/Base/B003Controller.ashx",
    //        data: { drpprocess: drpprocess, funcName: 'drpprocess_SelectedIndexChanged' },
    //        dataType: "json",
    //        async: false,
    //        success: function (res) {
    //            if (res.length>0) {
    //                var dt = JSON.parse(res);
    //                var drpprocess
    //            }
    //        }
    //    });
    //});
})

function img_qry_Click() {
    var tb_product = document.getElementById("tb_product").value.trim();
    var drpprocess = document.getElementById("drpprocess").value.trim();
    if (tb_product == "" || drpprocess == "") {
        alert("請輸入查詢條件");
        return;
    }
    jQuery("#jqGridRepairStep").GridUnload();
    //jQuery("#jqGridOfflineLot").trigger("reloadGrid"); 
    jQuery("#jqGridRepairStep").jqGrid(
    {
        url: "../../../controller/Base/B003Controller.ashx?funcName=Gridview1&tb_product=" + tb_product + "&drpprocess=" + drpprocess,
        datatype: "json",//请求数据返回的类型。可选json,xml,txt
        colNames: ['流程名稱', '流程順序', '站點代碼', '站點名稱', '站點屬性'],//jqGrid的列显示名字
        colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
            { name: 'PROCESS_NAME', index: 'PROCESS_NAME', width: 90 },
            { name: 'PROCESS_ID', index: 'PROCESS_ID', width: 100 },
            { name: 'STEP_ID', index: 'STEP_ID', width: 100 },
               { name: 'STEP_DESC', index: 'STEP_DESC', width: 100 },
            { name: 'STEP_BMATERIAL', index: 'STEP_BMATERIAL', width: 100 }
        ],
        height: 445,
        rowNum: 20,//一页显示多少条
        rownumbers: true,  //显示行号
        rowList: [20, 30, 40],//可供用户选择一页显示多少条
        pager: '#jqGridPagerRepairStep',//表格页脚的占位符(一般是div)的id
        sortname: 'ORDER_NO',//初始化的时候排序的字段
        sortorder: "desc",//排序方式,可选desc,asc
        mtype: "post",//向后台请求数据的ajax的类型。可选post,get
        viewrecords: true, //顯示總條數
        caption: "下線臨時表信息",//表格的标题名字
        loadonce: true
    });
    //$("#table").bootstrapTable('destroy').bootstrapTable({
    //    url: "../../../controller/Base/B003Controller.ashx?funcName=Gridview1&tb_product=" + tb_product + "&drpprocess=" + drpprocess,
    //    method: 'get',
    //    async: false,
    //    dataType: 'json',
    //    classes: 'table',//边框
    //    theadClasses: "bg-light-blue", //設置表頭顏色
    //    striped: true, //是否显示行间隔色
    //    clickToSelect: true, //是否启用点击选中行
    //    //height: 500, //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
    //    //uniqueId: "MODEL_ID", //每一行的唯一标识，一般为主键列

    //    pageSize: 10,                       //每页的记录行数（*）
    //    pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
    //    paginationPreText: "上一頁",
    //    paginationNextText: "下一頁",
    //    paginationFirstText: "首頁",
    //    paginationLastText: "尾頁",
    //    clickToSelect: true, //是否启用点击选中行
    //    striped: true, //是否显示行间隔色
    //    cache: false, //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
    //    pagination: true, //是否显示分页（*）
    //    responseHandler: function (data) {
    //        datas = data;
    //        document.getElementById("LabNum").innerText = data.length;
    //        return datas;
    //    },
    //    columns: [
    //      {
    //          field: 'checked',
    //          checkbox: true,
    //          rowspan: 1,
    //      }, {
    //          field: 'PROCESS_NAME',
    //          title: '流程名稱',
    //          width: 120
    //      }, {
    //          field: 'PROCESS_ID',
    //          title: '流程順序',
    //          width: 70
    //      }, {
    //          field: 'STEP_ID',
    //          title: '站點代碼',
    //          width: 70
    //      }, {
    //          field: 'STEP_DESC',
    //          title: '站點名稱',
    //          width: 70
    //      }, {
    //          field: 'STEP_BMATERIAL',
    //          title: '站點屬性',
    //          width: 70
    //      }]
    //}).bootstrapTable('load', datas);

    tb_product_TextChanged();
    document.getElementById("drpprocess").value = drpprocess;

}


function onKeyDown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 13) { // enter 键
        tb_product_TextChanged();
    }
}

function tb_product_TextChanged() {
    var tb_product = document.getElementById("tb_product").value.trim();
    var x = document.getElementById("drpprocess");
    document.getElementById("drpprocess").innerHTML = "";
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B003Controller.ashx",
        data: { tb_product: tb_product, funcName: 'tb_product_TextChanged' },
        //dataType: "json",
        async: false,
        success: function (res) {

            if (res.length > 2) {
                var dt = JSON.parse(res);
                for (i = 0; i < dt.length; i++) {
                    x.options.add(new Option(dt[i].PROCESS_NAME, dt[i].PROCESS_NAME));
                }
            }else{
                getprocess()
            }  
        }
    });

}


function getprocess() {
   
    var x = document.getElementById("drpprocess");
    document.getElementById("drpprocess").innerHTML = "";
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B003Controller.ashx",
        data: { funcName: 'getprocess' },
        //dataType: "json",
        async: false,
        success: function (res) {
            var dt = JSON.parse(res);
            x.options.add(new Option("", ""));
            for (i = 0; i < dt.length; i++) {
                x.options.add(new Option(dt[i].PROCESS_NAME, dt[i].PROCESS_NAME));
            }
        }
    });

}


function add_Click() {
    var tb_product = document.getElementById("tb_product").value.trim();
    var drpprocess = document.getElementById("drpprocess").value.trim();
    if (tb_product == "" || drpprocess == "") {
        alert("請輸入添加信息");
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B003Controller.ashx",
        data: { tb_product: tb_product, drpprocess:drpprocess,funcName: 'add_Click' },
        //dataType: "json",
        async: false,
        success: function (res) {
            if (res = "OK") {
                alert("關聯機種流程成功");
                document.getElementById("lbprocess").value = "";
            } else {
                alert(res);
            }
            
        }
    });

}
function img_delete2_Click() {
    var tb_product = document.getElementById("tb_product").value.trim();
    var drpprocess = document.getElementById("drpprocess").value.trim();
    if (tb_product == "" || drpprocess == "") {
        alert("請輸入刪除信息");
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B003Controller.ashx",
        data: { tb_product: tb_product, drpprocess: drpprocess, funcName: 'img_delete2_Click' },
        //dataType: "json",
        async: false,
        success: function (res) {
            alert(res);

        }
    });

}