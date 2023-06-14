$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#getInfo').text(user);
    B004show("");
})


function B004alert(e) {
    $("body").append('<div id="msg"><div id="msg_top">信息<span class="msg_close">×</span></div><div id="msg_cont">' + e + '</div><div class="msg_close" id="msg_clear">确定</div></div>');
    $(".msg_close").click(function () {
        $("#msg").remove();
    });
}

function B004Add() {
    var user = $("#getInfo").text();
    var reasoncode = $("#reasoncode").val();
    var remark = $("#remark").val();
    var ecode = $("#ecode").val();
    if (reasoncode == "")
    {
        B004alert("不良代碼不能為空");
        return;
    }
    if (remark == "") {
        B004alert("不良描述不能為空");
        return;
    }
    if (ecode == "" || ecode.length != 4) {
        B004alert("客戶不良只能為4碼，且不能為空");
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B004Controller.ashx",
        data: { reasoncode: reasoncode, remark: remark, ecode: ecode, user: user, funcName: 'add' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                B004show("");
                B004alert(error_msg);
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                B004alert(error_msg);
            }
        }
    });

}


function B004Update() {
    var user = $("#getInfo").text();
    var reasoncode = $("#reasoncode").val();
    var remark = $("#remark").val();
    var ecode = $("#ecode").val();
    if (reasoncode == "") {
        B004alert("不良代碼不能為空");
        return;
    }
    if (remark == "") {
        B004alert("不良描述不能為空");
        return;
    }
    if (ecode == "" || ecode.length != 4) {
        B004alert("客戶不良只能為4碼，且不能為空");
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B004Controller.ashx",
        data: { reasoncode: reasoncode, remark: remark, ecode: ecode, user: user, funcName: 'update' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                B004show("");
                B004alert(error_msg);
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                B004alert(error_msg);
            }
        }
    });


}
function B004search()
{
    var reasoncode = $("#reasoncode").val();
    B004show(reasoncode);
}

function B004show(reasoncode) {
    jQuery("#jqGrid").GridUnload();
    var user = $("#getInfo").text();
    jQuery("#jqGrid").jqGrid(
		{
		    url: "../../../controller/Base/B004Controller.ashx?funcName=show&&reasoncode="+ reasoncode +"",
		    datatype: "json",//请求数据返回的类型。可选json,xml,txt
		    colNames: ['不良代碼','不良名稱','客戶不良'],//jqGrid的列显示名字
		    colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
			            { name: 'CODE_ID', index: 'CODE_ID', width: 250 },
                        { name: 'CODE_NAME', index: 'CODE_NAME', width: 300 },
                        { name: 'CODE_SIM', index: 'CREATE_DATE', width: 250 },
                        //{ name: 'CODE_SIM', index: 'CREATE_DATE', width: 250 },
                        //{
                        //    label: '删除', name: '', index: 'operate', width: 50, align: 'center',
                        //    formatter: function (cellvalue, options, rowObject) {
                        //        var detail = "<img  onclick='B004del(\"" + rowObject.ORDER_NO + "\",\"" + user + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
                        //        return detail;
                        //    }
                        //}
		    ],
		    height: 300,
		    rowNum: 13,//一页显示多少条
		    rownumbers: true,  //显示行号
		    rowList: [10, 20, 30],//可供用户选择一页显示多少条
		    pager: '#jqGridPager',//表格页脚的占位符(一般是div)的id
		    sortname: 'TYPE',//初始化的时候排序的字段
		    sortorder: "desc",//排序方式,可选desc,asc
		    mtype: "post",//向后台请求数据的ajax的类型。可选post,get
		    viewrecords: true, //顯示總條數
		    caption: "維護信息",//表格的标题名字
		    loadonce: true
		});
    /*创建jqGrid的操作按钮容器*/
    /*可以控制界面上增删改查的按钮是否显示*/
    jQuery("#jqGrid").jqGrid('navGrid', '#jqGridPager', { edit: false, add: false, del: false });
}

function B004Del() {
    var reasoncode = $("#reasoncode").val();
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B004Controller.ashx",
        data: { reasoncode: reasoncode, funcName: 'del' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                B004show();
                B004alert(error_msg);
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                B004alert(error_msg);
            }
        }
    });
}

function B004change() {
    var reasoncode = $("#reasoncode").val();
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B004Controller.ashx",
        data: { reasoncode: reasoncode, funcName: 'change' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                B004show();
                B004alert(error_msg);
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                B004alert(error_msg);
            }
        }
    });
}

function B19order() {
    $.ajax({
        method: "post",
        url: "../../../controller/Base/B19Controller.ashx",
        data: { funcName: 'order' },
        dataType: "json",
        success: function (res) {
            var str = "<option value=''></option>";
            for (var i = 0; i < res.length; i++) {
                str += "<option value='" + res[i].ORDER_NO + "'>" + res[i].ORDER_DESC + "</option>";
            }
                $("#order").html(str);
        }
    });
}