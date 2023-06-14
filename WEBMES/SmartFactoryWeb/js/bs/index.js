$(document).ready(function () {

    var user = getCookie("Mes3User");
    $('#loginUs').text(user);
    $('#loginUse').text(user);
    $.ajax({
        type: 'post',
        url: 'controller/loginController.ashx',
        data: { user: user, funcName: 'getPrivilege' },
        dataType: 'json',
        async: false, //ajax同步加載導航菜單！！
        jsonp: "callback",
        jsonpCallback: "success_jsonpCallback",
        success: function (data) {
            $('aside').html(data);
            async: false,
            $('aside>div>ul>li>ul').hide();
        }
    })
    
})

$(function () {
    version = Date.now();
    $('ul.sidebar-menu li').click(function (e) {
        var li = $('ul.sidebar-menu li.active');
        li.removeClass('active');
        $(this).addClass('active');

        e.cancelBubble = true;

    });

    $('.myLeftMenu').click(function (e) {
        var url = $(this).attr('data');
        $('#container').load(url);
    });
})

//登出
function logout() {
    console.log("11111");
    deleteCookie('Mes3User');
    deleteCookie('Mes3Password');
    window.location.href = '../login.html';
}

$(function () {
    $('ul.sidebar-menu li').click(function () {
        var li = $('ul.sidebar-menu li.active');
        li.removeClass('active');
        $(this).addClass('active');
    });

    $('.myLeftMenu').click(function (e) {
        var url = $(this).attr('data');
        $("body").toggleClass("sidebar-collapse");
        //var li = $('ul.sidebar-menu li.active');
        //li.removeClass('active');
        //$(this).addClass('active');
/*        $('.sidebar-toggle-btn').pushMenu(options);*/
        //  console.log(url);
        $('#container').load(url);
    });
})




