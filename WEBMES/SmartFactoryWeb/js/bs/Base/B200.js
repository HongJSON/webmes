var urlB161 = "../../../controller/Base/B200Controller.ashx?"
$(document).ready(function () {
    var lh_user = getCookie("Mes3User");
    var lh_user2 = $("#getInfo").text();
    //if (lh_user2 != "") {
    //    return;
    //}
    //$("#Text1").val("");
    //$("#Text2").val("");
    //$("#Text3").val("");
    //$("#Text4").val("");
    
    showtemp();
})

function checkboxOnclick(checkbox) {
    var boxes = document.getElementsByName("items");
    if (checkbox.checked == true) {

        for (i = 0; i < boxes.length; i++) {
            boxes[i].checked = true;
        }

    } else {

        for (i = 0; i < boxes.length; i++) {
            boxes[i].checked = false;
        }

    }

}


function showtemp() {
    $('#result').remove();
    $.ajax({
        method: "post",
        url: urlB161 + "funcName=showtemp",
        //dataType: "json",
        success: function (dt) {
            var result = JSON.parse(dt);
            $('#result').remove();
            $("#result1").append(" <div id=\"result\"  style=\"background-color:#fff; width:1000px; margin-left:20px;\">");
            for (var i = 0; i < result.length; i++) {
                $("#result").append(
                    "<label style='width:220px;'>"
                        + "<input name='items' type='checkbox'  value="
                            + result[i].TREEID
                        + ">"
                            + result[i].TREENAME
                    + "</label>" + "&nbsp;&nbsp;"
                );
                //每三个进行换行
                if ((i + 1) % 4 == 0) {
                    $("#result").append("<br>");
                }
                if (i == result.length-1) {
                    //alert(i);
                    break;
                }
            }
            $("#result").append("</div>");
        }
    });
}

function onKeyDown(event) {
    var e = event || window.event || arguments.callee.caller.arguments[0];
    if (e && e.keyCode == 27) { // 按 Esc 要做的事情 
    }
    if (e && e.keyCode == 113) { // 按 F2 //要做的事情 
    }
    if (e && e.keyCode == 13) { // enter 键

        gonghao();
    }
}

function gonghao() {

    var Text1 = $("#Text1").val().trim(); //工号
    if (Text1 == "") {
        alert("不能为空");
        return;
    }
    $.ajax({
        method: "post",
        url: urlB161 + "funcName=selectuser&Text1=" + Text1,
        //        dataType: "json",
        success: function (result) {
            var dt = JSON.parse(result);

            $("#Text2").val(dt[0].NAME_IN_CHINESE);
            $("#Text3").val(dt[0].MI);
        }
    });
    $.ajax({
        method: "post",
        url: urlB161 + "funcName=selectqx&Text1=" + Text1,
        //        dataType: "json",
        success: function (res) {
            if (res == "admin") {
                document.getElementById('Chkadmin').checked = true;

            } else {
                var array = res.split(";");
                var boxes = document.getElementsByName("items");
                for (i = 0; i < boxes.length; i++) {

                    for (var j = 0; j < array.length; j++) {
                        if (boxes[i].value == array[j]) {

                            boxes[i].checked = true;
                            break
                        }
                    }
                }

            }
        }
    });
}

function insert() {
    var Text1 = $("#Text1").val().trim(); //工号
    var Text3 = $("#Text3").val().trim(); //密码
    var Text4 = $("#Text4").val().trim(); //确认密码
    if (Text1 == "") {
        alert("不能为空");
        return;
    }
    if (Text3 == "") {
        alert("密码不能为空");
        return;
    }
    if (Text3 == Text4) {
        edit(true);
    } else {
        alert("密码不一致");
        return;
    }
}
function update() {
    var Text1 = $("#Text1").val().trim(); //工号
    if (Text1 == "") {
        alert("不能为空");
        return;
    }
    edit(false);
}
function edit(msg) {
    var str = "";
    var str1 = "";
    var Text1 = $("#Text1").val().trim(); //工号
    var Text2 = $("#Text2").val().trim(); //姓名
    var Text3 = $("#Text3").val().trim(); //密码
    if (Chkadmin.Checked) {
        str = "admin";
    }
    else {
        $("input[name=items]:checkbox:checked").each(function () {
            str1 = str1 + $(this).val() + ";";
        });
        if (str1 == "") {
            alert("請給該用戶賦予一定的權限");
            return;
        } else {
            str = str1;
        }
    }
    if (str != "") {
        $.ajax({
            method: "post",
            url: urlB161 + "funcName=edit&Text1=" + Text1 + "&Text2=" + Text2 + "&Text3=" + Text3 + "&str1=" + str1 + "&msg=" + msg,
            //        dataType: "json",
            success: function (result) {
                alert(result);
                $("#Text1").val("");
                $("#Text2").val("");
                $("#Text3").val("");
                $("#Text4").val("");
                showtemp();
                return;
            }
        });
    }

}




