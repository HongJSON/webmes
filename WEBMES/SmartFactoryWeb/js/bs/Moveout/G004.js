$(document).ready(function () {
    $("#lotno").focus();
    var user = getCookie("Mes3User");
    $('#user').text(user);
    getip();
})

function G06alert(e) {
    $("body").append('<div id="msg"><div id="msg_top">信息<span class="msg_close">×</span></div><div id="msg_cont">' + e + '</div><div class="msg_close" id="msg_clear">确定</div></div>');
    $(".msg_close").click(function () {
        $("#msg").remove();
    });
}

function onKeyDownG06(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 13) { // enter 键
        var lotid = $("#lotno").val();
        //alert("../../../report/creport.aspx?u=" + lotid);
        window.open("../../../report/SLMEScreport.aspx?u=" + lotid + "");
    }
}

function getip() {
    $.get("../../../controller/MoveOut/G004Controller.ashx", { funcName: "getip" }, function (data) {
        $("#ip").text(data);
    }, "text");
}

function login() {
    var lotno = $("#lotno").val();
    lotno = encodeURIComponent(lotno);
    jQuery.ajax({
        url: "../../../controller/MoveOut/G004Controller.ashx?funcName=tmpInsert&lotno=" + lotno,
        type: "post",
        dataType: "json",
        success: function (value) {
            var obj = [];
            for (var i = 0; i < value.length; i++) {
                if (value[i].ERR_CODE == "Y") {
                    G06alert(value[i].ERR_MSG);
                    $("#lotno").val("");
                    $("#lotno").focus();
                    return;
                } else if (value[i].ERR_CODE == "N") {
                }
            }
        }
    });
}
