$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    document.getElementById("INPUT").src = "/img/IMAGE_INPUT.gif";
    getIP();
    //进行遍历插入基础下拉数据
    insertinto();
    $("#ddl_mo").change(function () {
        getMoNum();
    });
    $("#ddl_halfpart").change(function () {
        var ddl_mo = document.getElementById("ddl_mo").value;//工單
        if (ddl_mo == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
            swal({
                text: '請先選擇工單',
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        getHalfPartId();
    });
})
function getmo() {
    $.ajax({
        url: "../../../controller/Repair/R06Controller.ashx",
        type: "post",
        data: { funcName: 'select_GetMo' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            for (let i = 0 ; i < res.length ; i++) {
                html += "<option value = '" + res[i].ORDER_NO + "'>" + res[i].SHOWMO + "</option>";
            }
            $("#ddl_mo").html(html);
        }
    })
}

function gethalfpart() {
    $.ajax({
        url: "../../../controller/Repair/R06Controller.ashx",
        type: "post",
        data: { funcName: 'select_GetHalfPart' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            for (let i = 0 ; i < res.length ; i++) {
                html += "<option value = '" + res[i].HALFPART + "'>" + res[i].HALFPART + "</option>";
            }
            $("#ddl_halfpart").html(html);
        }
    })
}

function insertinto() {
    getmo();
    gethalfpart();
}

function getIP() {
    $.get("../../../controller/Repair/R06Controller.ashx", { funcName: "getIP" }, function (data) {
        $("#ip").text(data);
    }, "text");
}

function getMoNum()
{
    var ddl_mo = document.getElementById("ddl_mo").value;
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R06Controller.ashx",
        data: { ddl_mo: ddl_mo, funcName: 'select_getMoNum' },
        //dataType: "json",
        async: false,
        success: function (res) {
            if (res.length > 0) {
                var dt = JSON.parse(res);
                document.getElementById("ddl_monum").value = dt[0]["MONUM"];
            }
        }
    });
}
function getHalfPartId() {
    var ddl_mo = document.getElementById("ddl_mo").value;
    var ddl_halfpart = document.getElementById("ddl_halfpart").value;
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R06Controller.ashx",
        data: { ddl_mo: ddl_mo, ddl_halfpart: ddl_halfpart, funcName: 'select_GetHalfPartId' },
        //dataType: "json",
        async: false,
        success: function (res) {
            if (res.length > 0) {
                var dt = JSON.parse(res);
                if (dt == "") {
                    document.getElementById("ddl_halfpartid").value = "";
                } else {
                    document.getElementById("ddl_halfpartid").value = dt[0]["HALFPARTID"];
                }
            }
        }
    });
}

function btn_offline_Click() {
    var userid = getCookie("Mes3User");
    var ddl_mo = document.getElementById("ddl_mo").value;//工單
    var ddl_monum = document.getElementById("ddl_monum").value;//剩餘結箱數量
    var ddl_halfpart = document.getElementById("ddl_halfpart").value;//帶料狀態
    var ddl_halfpartid = document.getElementById("ddl_halfpartid").value;//半品料號
    var type = $("input[name='rad1']:checked").val();//退庫類型
    var ddl_storeloc = document.getElementById("ddl_storeloc").value;//退庫倉別
    var repairtype = document.getElementById("repairtype").value;//维修项目
    var rejectednum = document.getElementById("rejectednum").value;//結箱數量
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R06Controller.ashx",
        data: { ddl_mo: ddl_mo, ddl_monum: ddl_monum, ddl_halfpart: ddl_halfpart, ddl_halfpartid: ddl_halfpartid, type: type, ddl_storeloc: ddl_storeloc, repairtype: repairtype, rejectednum: rejectednum, userid: userid, funcName: 'btn_offline' },
        //dataType: "json",
        async: false,
        success: function (res) {
            if (res.length > 0) {
                //alert(res.substring(0, 4));
                if (res.substring(0, 4) == "結箱成功") {
                    
                    document.getElementById("rejectedid").value = res.substring(4, 20);
                     getMoNum();
                    var audiong = document.getElementById('musicok');
                    if (musicok.paused) {
                        musicok.currentTime = 0;
                        musicok.play();
                    }
                    document.getElementById("INPUT").src = "/img/IMAGE_OK.gif";
                    document.getElementById("rejectednum").value = "";
                } else {
                    getMoNum();
                    swal({
                        text: res,
                        type: 'error',
                        confirmButtonColor: '#3085d6',
                    })
                    var audiong = document.getElementById('musicng');
                    if (musicng.paused) {
                        musicng.currentTime = 0;
                        musicng.play();
                    }
                    document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
                    document.getElementById("rejectednum").value = "";
                    $("#rejectednum").focus();
                }
            }
        }
    });
    show();
}

function enter_click(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0]
    if (e && e.keyCode == 13) {
        console.log("触发产品回车事件");
        var userid = getCookie("Mes3User");
        var ddl_mo = document.getElementById("ddl_mo").value;//工單
        var ddl_monum = document.getElementById("ddl_monum").value;//剩餘結箱數量
        var ddl_halfpart = document.getElementById("ddl_halfpart").value;//帶料狀態
        var ddl_halfpartid = document.getElementById("ddl_halfpartid").value;//半品料號
        var type = $("input[name='rad1']:checked").val();//退庫類型
        var ddl_storeloc = document.getElementById("ddl_storeloc").value;//退庫倉別
        var repairtype = document.getElementById("repairtype").value;//维修项目
        var rejectednum = document.getElementById("rejectednum").value;//結箱數量
        if (ddl_mo == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
            setTimeout(function () {
                swal({
                    text: "請選擇工單",
                    type: "error",
                    confirmButtonColor: '#3085d6'
                });
            }, 100);
          
            return;
        } else if (ddl_halfpart == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
      
            setTimeout(function () {
                swal({
                    text: "請選擇帶料狀態",
                    type: "error",
                    confirmButtonColor: '#3085d6'
                });
            }, 100);
            return;
        } else if (type == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
            setTimeout(function () {
                swal({
                    text: "請選擇退庫類型",
                    type: "error",
                    confirmButtonColor: '#3085d6'
                });
            }, 100);
   
            return;
        } else if (ddl_storeloc == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
            setTimeout(function () {
                swal({
                    text: "請選擇退庫倉別",
                    type: "error",
                    confirmButtonColor: '#3085d6'
                });
            }, 100);
  
            return;
        } else if (type == "R4" || type == "R5") {
            if (repairtype == "NULL") {
                var audiong = document.getElementById('musicng');
                if (musicng.paused) {
                    musicng.currentTime = 0;
                    musicng.play();
                }
                document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
                setTimeout(function () {
                    swal({
                        text: "請選擇维修项目",
                        type: "error",
                        confirmButtonColor: '#3085d6'
                    });
                }, 100);
    
                return;
            }
        } else if (rejectednum == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
            setTimeout(function () {
                swal({
                    text: "請輸入結箱數量",
                    type: "error",
                    confirmButtonColor: '#3085d6'
                });
            }, 100);
   
            return;
        }
        $.ajax({
            method: "post",
            url: "../../../controller/Repair/R06Controller.ashx",
            data: { ddl_mo: ddl_mo, ddl_monum: ddl_monum, ddl_halfpart: ddl_halfpart, ddl_halfpartid: ddl_halfpartid, type: type, ddl_storeloc: ddl_storeloc, repairtype: repairtype, rejectednum: rejectednum, userid: userid, funcName: 'btn_tmp' },
            //dataType: "json",
            async: false,
            success: function (res) {
                if (res.length > 0) {
                    //alert(res.substring(0, 4));
                    if (res.substring(0, 4) == "刷入成功") {

                  
                        getMoNum();
            
                        var audiong = document.getElementById('musicok');
                        if (musicok.paused) {
                            musicok.currentTime = 0;
                            musicok.play();
                        }
                       
                        document.getElementById("INPUT").src = "/img/IMAGE_OK.gif";
                        document.getElementById("rejectednum").value = "";
                    } else {
                        getMoNum();
                     
                        setTimeout(function () {
                            swal({
                                text: res,
                                type: "error",
                                confirmButtonColor: '#3085d6'
                            });
                        }, 100);

              
                        var audiong = document.getElementById('musicng');
                        if (musicng.paused) {
                            musicng.currentTime = 0;
                            musicng.play();
                        }
                        document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
                        document.getElementById("rejectednum").value = "";
                        $("#rejectednum").focus();
                      
                    }
                }
             
            }
        });
        show();

    }
}

function show() {
    var userid = getCookie("Mes3User");
  
    $('#table').bootstrapTable('destroy');
    $('#table').bootstrapTable({
        url: '../../../controller/Repair/R06Controller.ashx?funcName=show&userid=' + userid,
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
            field: 'ORDER_NO',
            title: '工單'
        }, {
            field: 'LH_ID',
            title: '料號'
        }, {
            field: 'STORELOC',
            title: '倉別'
        }, {
            field: 'REJECTED_QTY',
            title: '數量'
        }, {
            field: 'REPAIRTYPE',
            title: '维修项目'
        }, {
            field: 'STATUS',
            title: '帶料狀態'
        }, {
            field: 'TYPEID',
            title: '退庫類型'
        }, {
            field: 'CREATE_USER',
            title: '人員'
        }, {
            field: 'OPERATE',
            title: '操作',
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
        swal({
            text: '確定要刪除此行數據嗎?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
        }).then(function () {
            $.ajax({
                url: "../../../controller/Repair/R06Controller.ashx",
                type: "post",
                data: { funcName: "rowDelete", ORDER_NO: row.ORDER_NO, userid: row.CREATE_USER, REJECTED_QTY: row.REJECTED_QTY },
                dataType: "json",
                async: false,
                success: function (res) {
                    swal({
                        text: res.MSG,
                        type: "success",
                        confirmButtonColor: '#3085d6'
                    })
                    var audiong = document.getElementById('musicok');
                    if (musicok.paused) {
                        musicok.currentTime = 0;
                        musicok.play();
                    }
                    document.getElementById("INPUT").src = "/img/IMAGE_OK.gif";
                    getMoNum();
                    show();
                    return;
                }
            })
        }, function (dismiss) {
            //取消後的操作
        })
    }
};

function pageshow(info) {
    if (info == "R4" || info == "R5") {
        $('#repairtype').show();
    }
    else {
        $('#repairtype').hide();
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Repair/R06Controller.ashx",
        data: { info: info, funcName: 'select_GetStoreLoc' },
        dataType: "json",
        success: function (res) {
            var str = '';
            for (var i = 0; i < res.length; i++) {
                str += '<option value="' + res[i].LOC + '">' + res[i].LOC + '</option>';
            }
            $("#ddl_storeloc").empty();
            $("#ddl_storeloc").html(str);
        }
    });

}