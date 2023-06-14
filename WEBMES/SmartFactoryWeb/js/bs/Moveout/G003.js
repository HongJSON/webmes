$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    document.getElementById("INPUT").src = "/img/IMAGE_INPUT.gif";
    getIP();
    //进行遍历插入基础下拉数据
    insertinto();

    $("#ddl_fa").change(function () {
        var ddl_fa = document.getElementById("ddl_fa").value;
        var x = document.getElementById("ddl_eqp");
        document.getElementById("ddl_eqp").innerHTML = "";
        var ddl_f = document.getElementById("ddl_f").value;

        if (ddl_f == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
            swal({
                text: '請先選擇機種',
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        if (ddl_fa == "") {
            var audiong = document.getElementById('musicng');
            if (musicng.paused) {
                musicng.currentTime = 0;
                musicng.play();
            }
            document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
            swal({
                text: '請先選擇廠別',
                type: "error",
                confirmButtonColor: '#3085d6'
            })
            return;
        }
        $.ajax({
            method: "post",
            url: "../../../controller/Moveout/G003Controller.ashx",
            data: { ddl_fa: ddl_fa, funcName: 'select_ddleqp' },
            //dataType: "json",
            async: false,
            success: function (res) {
                //                alert(1);
                var dt = JSON.parse(res);
                for (i = 0; i < dt.length; i++) {
                    x.options.add(new Option(dt[i].EQP_ID, dt[i].EQP_ID));
                }
            }
        });
        GetWok();
    });
    $("#ddlWok").change(function () {
        init_wok();
    });
    $("#arylot").change(function () {
        getAryLotNum();
    });
})

function insertinto() {
    document.getElementById("ddl_f").innerHTML = "";
    document.getElementById("ddl_fa").innerHTML = "";
    document.getElementById("arylot").innerHTML = "";
    var n = document.getElementById("ddl_f");
    var k = document.getElementById("ddl_fa");
    var z = document.getElementById("arylot");
    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { funcName: 'select_GetMotype' },
        //dataType: "json",
        async: false,
        success: function (res) {
            var dt = JSON.parse(res);
            n.options.add(new Option("", ""));
            for (i = 0; i < dt.length; i++) {
                n.options.add(new Option(dt[i].MO_TYPE, dt[i].MO_TYPE));
            }
        }
    });
    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { funcName: 'select_GetSite' },
        //dataType: "json",
        async: false,
        success: function (res) {
            var dt = JSON.parse(res);
            k.options.add(new Option("", ""));
            for (i = 0; i < dt.length; i++) {
                k.options.add(new Option(dt[i].SITE, dt[i].SITE));
            }
        }
    });
    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { funcName: 'select_GetAryLot' },
        //dataType: "json",
        async: false,
        success: function (res) {
            var dt = JSON.parse(res);
            z.options.add(new Option("", ""));
            for (i = 0; i < dt.length; i++) {
                z.options.add(new Option(dt[i].ARY_LOT, dt[i].ARY_LOT));
            }
        }
    });

}

function getIP() {
    $.get("../../../controller/MoveOut/G003Controller.ashx", { funcName: "getIP" }, function (data) {
        $("#ip").text(data);
    }, "text");
}
function getAryLotNum()
{
    var arylot = document.getElementById("arylot").value;
    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { arylot: arylot, funcName: 'select_getAryLotNum' },
        //dataType: "json",
        async: false,
        success: function (res) {
            if (res.length > 0) {
                var dt = JSON.parse(res);
                document.getElementById("arylotnum").value = dt[0]["ARYLOTNUM"];
                $("#lotnum").focus();
            }
        }
    });
}


function GetWok() {
    var ddl_fa = document.getElementById("ddl_fa").value;
    var ddl_f = document.getElementById("ddl_f").value;
    var x = document.getElementById("ddlWok");
    document.getElementById("ddlWok").innerHTML = "";
    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { ddl_fa: ddl_fa, ddl_f: ddl_f, funcName: 'select_GetWok' },
        //dataType: "json",
        async: false,
        success: function (res) {
            var dt = JSON.parse(res);
            x.options.add(new Option("", ""));
            for (i = 0; i < dt.length; i++) {
                x.options.add(new Option(dt[i].ORDER_NO, dt[i].ORDER_NO));
            }
        }
    });
}

function init_wok() {
    var ddlWok = document.getElementById("ddlWok").value;
    var strProductId = "";
    var y = document.getElementById("ddlProcess");
    document.getElementById("ddlProcess").innerHTML = "";

    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { ddlWok: ddlWok, funcName: 'select_ddlWok' },
        //dataType: "json",
        async: false,
        success: function (res) {
            if (res.length > 0) {
                var dt = JSON.parse(res);
                strProductId = dt[0]["PRODUCT_ID"];
                document.getElementById("tbwokqty").value = dt[0]["QUANTITY"];
                document.getElementById("tbQty").value = dt[0]["LEFTQUANTITYS"];
                document.getElementById("tbProductid").value = dt[0]["PRODUCT_ID"];
                $("#lotnum").focus();
            }
        }
    });

    //绑定ddlProcess这个字段下拉框
    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { ddlWok: ddlWok, funcName: 'select_ddlProcess' },
        //dataType: "json",
        async: false,
        success: function (res) {
            var dt = JSON.parse(res);
            if (res.length > 0) {
                for (i = 0; i < dt.length; i++) {
                    y.options.add(new Option(dt[i].PROCESS_NAME, dt[i].PROCESS_NAME));
                }
            } else {
                var audiong = document.getElementById('musicng');
                if (musicng.paused) {
                    musicng.currentTime = 0;
                    musicng.play();
                }
                document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
                swal({
                    text: '請聯繫 NPI 綁定工單流程',
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
                return;
            }
        }
    });

}

function btn_offline_Click() {
    var userid = getCookie("Mes3User");
    var ddlProcess = document.getElementById("ddlProcess").value;//過帳流程
    var ddl_f = document.getElementById("ddl_f").value;//機種
    var ddlWok = document.getElementById("ddlWok").value;//工單
    var ddl_fa = document.getElementById("ddl_fa").value;//廠別
    var lotnum = document.getElementById("lotnum").value;
    var ddl_eqp = document.getElementById("ddl_eqp").value;
    var arylot = document.getElementById("arylot").value;
    //var arylotnum = document.getElementById("arylotnum").value;
    if (ddl_f == "")
    {
        var audiong = document.getElementById('musicng');
        if (musicng.paused) {
            musicng.currentTime = 0;
            musicng.play();
        }
        document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
        swal({
            text: '請先選擇機種',
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    } else if (ddl_fa == "")
    {
        var audiong = document.getElementById('musicng');
        if (musicng.paused) {
            musicng.currentTime = 0;
            musicng.play();
        }
        document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
        swal({
            text: '請先選擇廠別',
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    } else if (ddlWok == "") {
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
    } else if (arylot == "")
    {
        var audiong = document.getElementById('musicng');
        if (musicng.paused) {
            musicng.currentTime = 0;
            musicng.play();
        }
        document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
        swal({
            text: '請先選擇ARYLOT',
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    $.ajax({
        method: "post",
        url: "../../../controller/Moveout/G003Controller.ashx",
        data: { ddlWok: ddlWok, lotnum: lotnum, ddl_f: ddl_f, ddl_fa: ddl_fa, ddl_eqp: ddl_eqp, arylot: arylot, userid: userid, funcName: 'btn_offline' },
        //dataType: "json",
        async: false,
        success: function (res) {
            if (res.length > 0) {
                //alert(res.substring(0, 4));
                if (res.substring(0, 4) == "下線成功") {
                    
                    document.getElementById("runcar_id").value = res.substring(4, 20);
                    init_wok(); getAryLotNum();
                    var audiong = document.getElementById('musicok');
                    if (musicok.paused) {
                        musicok.currentTime = 0;
                        musicok.play();
                    }
                    document.getElementById("INPUT").src = "/img/IMAGE_OK.gif";
                    document.getElementById("lotnum").value = "";
                } else {
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
                    document.getElementById("lotnum").value = "";
                    $("#lotnum").focus();
                }
            }
        }
    });
}

function print_Click() {
    var lotid = document.getElementById("runcar_id").value;
    if (lotid == "") {
        swal({
            text: 'RUNCARD號为空',
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        var audiong = document.getElementById('musicng');
        if (musicng.paused) {
            musicng.currentTime = 0;
            musicng.play();
        }
        document.getElementById("INPUT").src = "/img/IMAGE_NG.gif";
        return;
    }
    //  var lotid = $("#runcar_id").val();
    window.open("../../../report/SLMEScreport.aspx?u=" + lotid + "");
}