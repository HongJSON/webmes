$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#getInfo').text(user);
    //deleteTmpTable();
    getStepm();
})
function deleteTmpTable()
{
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R01Controller.ashx",
        data: {  'funcName': 'deleteTmpTable' },
        dataType: "json",
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                return;
            } else if (res[0].ERR_CODE == "Y") {
                R06alert(res[0].ERR_MSG)

            }
        }
    })
}
function R06select() {
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R01Controller.ashx",
        data: { 'funcName': 'R06select' },
        dataType: "json",
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#Label15").text("");
                $("#Label19").text("");
                $("#txtShow").text("");
                $("#Label14").text("");
                $("#Remaind1").text("");
                $("#txtSap").val("");
                $("#celltype").val("");
                $("#tborder").val("");
                $("#RepairType").text("");
                $("#Label13").text("");
                $("#AB").text("");
                $("#txt_productcode").val("");
                $("#ddl_lotType").val("");
                show();
                return;
            } else if (res[0].ERR_CODE == "Y") {
                R06alert(res[0].ERR_MSG)

            }
        }
    })
}
//enter键按下触发
function R01keydown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (event.keyCode == "13") {
        var lotid = $("#lotid").val()
        var stepm = $("#stepm").val()
        var item = $("#item").val()
        if (lotid == '') {
            alert("请输入lot号");
            return;
        }
        if (stepm == '') {
            alert("請選擇站點");
            return;
        }
        if (item == '') {
            alert("請選擇待料狀態");
            return;
        }
        
        //通过lot号初始数据
        $.ajax({
            method: "post",
            url: "../../../controller/Repair/R01Controller.ashx",
            data: { 'lotid': lotid,'funcName': 'lotid_enter','stepm':stepm,'item':item },
            dataType: "json",
            success: function (res) {
                if (res[0].ERR_CODE == "Y") {
                    $("#order").val(res[0].order);
                    $("#product").val(res[0].product);
                    show();
                } else {
                    R06alert(res[0].ERR_MSG);
                }
                
                
            }
        })
    }
}
//獲取站點
function getStepm() {
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R01Controller.ashx",
        data: {'funcName': 'stepms' },
        dataType: "json",
        success: function (res) {
            var option = "";
            for (var i = 0 ; i < res.length; i++) {
                option += " <option value='" + res[i].STEPM_ID + "'>" + res[i].STEPM_ID + "</option>";
            }
            $("#stepm").html(option)
        }
    })
}

function btnEnter_Click(ddl_materialtype, ddl_lotType, txt_productcode) {
    var ddl_materialtype = $("#ddl_materialtype").val();
    var ddl_lotType = $("#ddl_lotType").val();
    var txt_productcode = $("#txt_productcode").val();
    var lh_user = $("#getInfo").text()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R01Controller.ashx",
        data: { 'ddl_materialtype': ddl_materialtype, 'ddl_lotType': ddl_lotType, 'txt_productcode': txt_productcode , 'lh_user': lh_user ,'funcName': 'btnEnter_Click' },
        dataType: "json",
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#Label15").text(res[0].Label15);
                $("#Label19").text(res[0].Label19);
                $("#txtShow").text(res[0].txtShow);
                $("#Label14").text(res[0].Label14);
                $("#Remaind1").text(res[0].Remaind1);
                $("#txtSap").val(res[0].txtSap);
                $("#celltype").val(res[0].celltype);
                $("#tborder").val(res[0].tborder);
                $("#RepairType").text(res[0].repairtype);
                $("#Label13").text(res[0].Label13);              
                $("#AB").text(res[0].AB);
                $("#txt_productcode").val("");
                show();
                return;
            } else if (res[0].ERR_CODE == "Y") {
                R06alert(res[0].ERR_MSG)
                $("#txt_productcode").val("");
                $("#txt_productcode").focus();

            }
        }
    })
}
function show() {
    var lh_user = $("#getInfo").text()
    jQuery("#jqGridRepairStep").GridUnload();
    //jQuery("#jqGridOfflineLot").trigger("reloadGrid"); 
    jQuery("#jqGridRepairStep").jqGrid(
        {
            url: "../../../controller/Repair/R01Controller.ashx?funcName=show&lh_user=" + lh_user,
            datatype: "json",//请求数据返回的类型。可选json,xml,txt
            colNames: ['工單編碼', 'LOT號', '料件狀態', '來源站點', '不良代碼', '數量', '料號', '操作'],//jqGrid的列显示名字
            colModel: [ //jqGrid每一列的配置信息。包括名字，索引，宽度,对齐方式.....
                        { name: 'ORDER_NO', index: 'ORDER_NO', width: 120, align: 'center' },
                        { name: 'LOT_ID', index: 'LOT_ID', width: 135, align: 'center' },
                        { name: 'ITEM', index: 'ITEM', width: 120, align: 'center' },
                        { name: 'STEPM_ID', index: 'STEPM_ID', width: 100, align: 'center' },
                        { name: 'REASON_CODE', index: 'REASON_CODE', width: 100, align: 'center' },
                         { name: 'NGQTY', index: 'NGQTY', width: 100, align: 'center' },
                          { name: 'PRODUCT_ID', index: 'PRODUCT_ID', width: 130, align: 'center' },
                        {
                            label: '删除', name: '', index: '', width: 50, align: 'center',
                            formatter: function (cellvalue, options, rowObject) {
                                var detail = "<img  onclick='btn_delPro(\"" + rowObject.LOT_ID + "\",\"" + rowObject.STEPM_ID + "\",\"" + rowObject.REASON_CODE + "\")'' src='../../../img/cal.gif' style='padding:0px 10px'>";
                                return detail;
                            },
                        }
            ],
            height: 250,
            rowNum: 10,//一页显示多少条
            rownumbers: true,  //显示行号
            rowList: [20, 30, 40],//可供用户选择一页显示多少条
            pager: '#jqGridPagerRepairStep',//表格页脚的占位符(一般是div)的id
            sortname: 'PRODUCT_ID',//初始化的时候排序的字段
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
function btn_delPro(lotid,stepm,code) {
    var flag = confirm("確定要刪除該條記錄嗎!");
    if (!flag) {
        return;
    }
    var lh_user = $("#getInfo").text()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R01Controller.ashx",
        data: { 'lotid': lotid, 'funcName': 'btn_delPro', 'stepm': stepm,'code':code },
        dataType: "json",
        success: function (res) {
            for (var i = 0; i < res.length; i++) {
                if (res[i].ERR_CODE == "Y") {
                    show();
                    R06alert("刪除成功");
                } else if (res[i].ERR_CODE == "N") {
                    R06alert(res[i].ERR_MSG);

                }
            }
        }
    });
}
function Button2_Click() {
    var flag = confirm("確定要清空嗎!");
    if (!flag) {
        return;
    }
    var lh_user = $("#getInfo").text()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R01Controller.ashx",
        data: { 'funcName': 'Button2_Click' },
        dataType: "json",
        success: function (res) {
            for (var i = 0; i < res.length; i++) {
                if (res[i].ERR_CODE == "N") {
                    $("#Label15").text("");
                    $("#Label19").text("");
                    $("#txtShow").text("");
                    $("#Label14").text("");
                    $("#Remaind1").text("");
                    $("#txtSap").val("");
                    $("#celltype").val("");
                    $("#tborder").val("");
                    $("#RepairType").text("");
                    $("#Label13").text("");
                    $("#AB").text("");
                    $("#txt_productcode").val("");
                    $("#ddl_materialtype").val("");
                    $("#ddl_lotType").val("");
                    //------
                    $("#item").val("");
                    $("#stepm").val("");
                    $("#order").val("");
                    $("#product").val("");
                    $("#lotid").val("");
                    show();
                    R06alert("刪除成功");
                } else if (res[i].ERR_CODE == "Y") {
                    R06alert(res[i].ERR_MSG);

                }
            }
        }
    });
}
function btn_Elot_Click() {
    var flag = confirm("確定要點收嗎!");
    if (!flag) {
        return;
    }
    var lh_user = $("#getInfo").text()
    //var ddl_materialtype = $("#ddl_materialtype").val()
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R01Controller.ashx",
        data: { 'lh_user':lh_user,  'funcName': 'btn_Elot_Click' },
        dataType: "json",
        success: function (res) {
            for (var i = 0; i < res.length; i++) {
                if (res[i].ERR_CODE == "N") {
                    show();
                    $("#Label15").text("");
                    $("#Label19").text("");
                    $("#txtShow").text("");
                    $("#Label14").text("");
                    $("#Remaind1").text("");
                    $("#txtSap").val("");
                    $("#celltype").val("");
                    $("#tborder").val("");
                    $("#RepairType").text("");
                    $("#Label13").text("");
                    $("#AB").text("");
                    $("#txt_productcode").val("");
                    $("#ddl_materialtype").val("");
                    $("#ddl_lotType").val("");
                
                    //------
                    $("#item").val("");
                    $("#stepm").val("");
                    $("#order").val("");
                    $("#product").val("");
                    $("#lotid").val("");
                    show();
                    R06alert("點收成功");
                } else if (res[i].ERR_CODE == "Y") {
                    R06alert(res[i].ERR_MSG);
                    show();
                }
            }
        }
    });
}
function R06alert(e) {
    $("body").append('<div id="msg"><div id="msg_top">信息<span class="msg_close">×</span></div><div id="msg_cont">' + e + '</div><div class="msg_close" id="msg_clear">确定</div></div>');
    $(".msg_close").click(function () {
        $("#msg").remove();
    });
}
