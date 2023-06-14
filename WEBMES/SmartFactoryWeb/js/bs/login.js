$(document).ready(function () {
    var username = getCookie('Mes3User');
    var password = getCookie('Mes3Password');
    $('#user').val(username);
    $('#password').val(password);
})

//登录
login = function () {
    var rem = $('input:checkbox').prop('checked');
    $.ajax({
        type: 'post',
        url: 'controller/loginController.ashx',
        data:{user:$('#user').val(),password:$('#password').val(),funcName:'login'},
        dataType: 'json',
        //jsonp: "callback",
        //jsonpCallback: "success_jsonpCallback",
        success: function (data) {
          
            if (data == 'success') {
                var time = null;
               
                if (rem) {
                    time = 7;
                }
                setCookie('Mes3User', $('#user').val(), time);
                setCookie('Mes3Password', $('#password').val(), time);
                window.location.href = '../index.html?rd=' + Date.now();
            } else {
                bootbox.alert(data);
            }
        }
    })
}
