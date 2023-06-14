$(document).ready(function () {
    var user = getCookie("Mes3User");
    $('#user').text(user);
    $("#TYPE1").hide(); $("#TYPE2").hide(); $("#TYPE3").hide(); $("#TYPE4").hide(); $("#TYPE5").hide();
    $("#TYPE6").hide(); $("#TYPE7").hide(); $("#TYPE8").hide(); $("#TYPE9").hide(); $("#TYPE10").hide();
    $("#TYPE11").hide(); $("#TYPE12").hide(); $("#TYPE13").hide(); $("#TYPE14").hide(); $("#TYPE15").hide();
    $("#TYPE16").hide(); $("#TYPE17").hide(); $("#TYPE18").hide(); $("#TYPE19").hide(); $("#TYPE20").hide();
/*    dataObj = [];*/
    GetTemplate();
})
function GetTemplate() {
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O03.ashx",
        data: { funcName: 'ShowTemplate' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res != null) {
                var str = "<option value=''></option>";

                for (var i = 0; i < res.length; i++) {
                    str += "<option value='" + res[i].TEMPLATE + "'>" + res[i].TEMPLATE + "</option>";
                }
                $("#Template").html(str);
            }
        }
    });
}

function GetType(){
    GetQTY();
    GetLabel();
    GetType1();
}
////定義全局變量
//var dataObj;  // 數據對象數據

function GetType1() {
    var Template = $("#Template").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O03.ashx",
        data: { Template:Template,funcName: 'GetType' },
        dataType: "text",
        async: false,
        success: function (res) {
            console.log(res);
            $("#table").html(res);
        }
    });
}

function GetQTY() {

    var Template = $("#Template").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O03.ashx",
        data: {  Template: Template, funcName: 'GetQTY' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                $("#TYPE1").hide(); $("#TYPE2").hide(); $("#TYPE3").hide(); $("#TYPE4").hide(); $("#TYPE5").hide();
                $("#TYPE6").hide(); $("#TYPE7").hide(); $("#TYPE8").hide(); $("#TYPE9").hide(); $("#TYPE10").hide();
                $("#TYPE11").hide(); $("#TYPE12").hide(); $("#TYPE13").hide(); $("#TYPE14").hide(); $("#TYPE15").hide();
                $("#TYPE16").hide(); $("#TYPE17").hide(); $("#TYPE18").hide(); $("#TYPE19").hide(); $("#TYPE20").hide();

                for (var i = 1; i <=res[0].ERR_MSG; i++) {
                    var Type = "TYPE";
                    Type = Type+i;
                    $("#" + Type + "").show();
                }
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });
}

function GetLabel() {
    var Template = $("#Template").val();
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O03.ashx",
        data: { Template: Template, funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        success: function (res) {
                var html = "<option></option>";
                var Type = "Typ";
                for (var i =0; i < res.length; i++) {
                    var TYPE = Type + (i + 1);
                    $("#" + TYPE + "").text(res[i].TITLE);
                }
    
        }
    });
}


function Add() {
    var user = $("#user").text();
    var Template = $("#Template").val();
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); var Type13 = $("#Type13").val(); var Type14 = $("#Type14").val(); var Type15 = $("#Type15").val();
    var Type16 = $("#Type16").val(); var Type17 = $("#Type17").val(); var Type18 = $("#Type18").val(); var Type19 = $("#Type19").val(); var Type20 = $("#Type20").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O03.ashx",
        data: { Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Type13: Type13, Type14: Type14, Type15: Type15, Type16: Type16, Type17: Type17, Type18: Type18, Type19: Type19, Type20: Type20, user: user, Template: Template, funcName: 'addTemplateInfo' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
                document.getElementById("Type1").value = ""; document.getElementById("Type2").value = "";
                document.getElementById("Type3").value = "";
                document.getElementById("Type4").value = "";
                document.getElementById("Type5").value = "";
                document.getElementById("Type6").value = "";
                document.getElementById("Type7").value = "";
                document.getElementById("Type8").value = "";
                document.getElementById("Type9").value = "";
                document.getElementById("Type10").value = "";
                document.getElementById("Type11").value = "";
                document.getElementById("Type12").value = ""; document.getElementById("Type13").value = ""; document.getElementById("Type14").value = ""; document.getElementById("Type15").value = "";
                document.getElementById("Type16").value = ""; document.getElementById("Type17").value = ""; document.getElementById("Type18").value = ""; document.getElementById("Type19").value = "";
                document.getElementById("Type20").value = "";
                GetType1();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });


}



function SelectShow() {
    var Template = $("#Template").val();
    if (Template == "") {
        var error_msg = "模板号为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    GetQTY();
    GetLabel();
    GetType1();
}


function Delete() {
    var user = $("#user").text();
    var Template = $("#Template").val();
    if (Template == "") {
        var error_msg = "模板号为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }
    var Type1 = $("#Type1").val(); var Type2 = $("#Type2").val(); var Type3 = $("#Type3").val(); var Type4 = $("#Type4").val(); var Type5 = $("#Type5").val();
    var Type6 = $("#Type6").val(); var Type7 = $("#Type7").val(); var Type8 = $("#Type8").val(); var Type9 = $("#Type9").val(); var Type10 = $("#Type10").val();
    var Type11 = $("#Type11").val(); var Type12 = $("#Type12").val(); var Type13 = $("#Type13").val(); var Type14 = $("#Type14").val(); var Type15 = $("#Type15").val();
    var Type16 = $("#Type16").val(); var Type17 = $("#Type17").val(); var Type18 = $("#Type18").val(); var Type19 = $("#Type19").val(); var Type20 = $("#Type20").val();

    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O03.ashx",
        data: { Type1: Type1, Type2: Type2, Type3: Type3, Type4: Type4, Type5: Type5, Type6: Type6, Type7: Type7, Type8: Type8, Type9: Type9, Type10: Type10, Type11: Type11, Type12: Type12, Type13: Type13, Type14: Type14, Type15: Type15, Type16: Type16, Type17: Type17, Type18: Type18, Type19: Type19, Type20: Type20, user: user, Template: Template, funcName: 'delete' },
        dataType: "json",
        async: false,
        success: function (res) {
            if (res[0].ERR_CODE == "N") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
                document.getElementById("Type1").value = ""; document.getElementById("Type2").value = "";
                document.getElementById("Type3").value = "";
                document.getElementById("Type4").value = "";
                document.getElementById("Type5").value = "";
                document.getElementById("Type6").value = "";
                document.getElementById("Type7").value = "";
                document.getElementById("Type8").value = "";
                document.getElementById("Type9").value = "";
                document.getElementById("Type10").value = "";
                document.getElementById("Type11").value = "";
                document.getElementById("Type12").value = ""; document.getElementById("Type13").value = ""; document.getElementById("Type14").value = ""; document.getElementById("Type15").value = "";
                document.getElementById("Type16").value = ""; document.getElementById("Type17").value = ""; document.getElementById("Type18").value = ""; document.getElementById("Type19").value = "";
                document.getElementById("Type20").value = "";
                GetType1();
            }
            else if (res[0].ERR_CODE == "Y") {
                var error_msg = res[0].ERR_MSG;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        }
    });
}


function download() {

    var Template = "";
    Template = $("#Template").val();
    if (Template == "") {
        Template = "E-Check";
    }
    var LOG = "";
    let myDate = new Date();
    var date = myDate.toLocaleDateString();
    var tableHtml = "<html><head><meta charset='UTF-8'></head><body><table border=1><tr>";
    var tableHtmlEnd = "</tr>";
    $.ajax({
        method: "post",
        url: "../../../controller/OQC-QUALITY/O03.ashx",
        data: { Template: Template, funcName: 'GetLabel' },
        dataType: "json",
        async: false,
        success: function (res) {
            var html = "<option></option>";
            var Type = "Typ";
           
            for (var i = 0; i < res.length; i++) {
                var TYPE = "<td align='center'>" + res[i].TITLE+"</td>";
                LOG = LOG + TYPE;
            }

        }
    });
    tableHtml = tableHtml + LOG+ tableHtmlEnd;
    tableHtml += "</table></body></html>";
    var excelBlob = new Blob([tableHtml], {
        type: 'application/vnd.ms-excel'
    });
    var oa = document.createElement('a');
    oa.href = URL.createObjectURL(excelBlob);
    oa.download = Template + '.xls';
    document.body.appendChild(oa);
    oa.click();
}

function importExcel() {
    var fileUpload = $("#fileinp").get(0);
    var files = fileUpload.files;
    var data = new FormData();
    var user = $("#user").text();

    var Template = $("#Template").val();
    if (Template == "") {
        var error_msg = "模板号为空,请检查!";
        swal({
            text: error_msg,
            type: "error",
            confirmButtonColor: '#3085d6'
        })
        return;
    }


    if (files.length == 0) {
        alert("请先下载模板上传数据!!!");
        return;
    }
    for (var i = 0; i < files.length; i++) {
        data.append(files[i].name, files[i]);
    }
    var t = document.getElementById('txt');


    $.ajax({
        url: "../../../controller/OQC-QUALITY/O03.ashx?funcName=excel&user=" + user + "&Template=" + Template + "&Path=" + files + "",
        type: "POST",
        data: data,
        async: false,
        contentType: false,
        processData: false,
        success: function (result) {
            if (result.substr(0, 2) == 'OK') {

                var error_msg = result;
                swal({
                    text: error_msg,
                    type: "success",
                    confirmButtonColor: '#3085d6'
                })
            } else {

                var error_msg = result;
                swal({
                    text: error_msg,
                    type: "error",
                    confirmButtonColor: '#3085d6'
                })
            }
        },
    });
    document.getElementById("fileinp").value = "";
    GetType1();
}





