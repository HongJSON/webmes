(function ($) {
    var Qrcode = function (tempBtn) {
        var _this_ = this;
        var isWeiboWebView = /__weibo__/.test(navigator.userAgent);

        if (isWeiboWebView) {
            if (window.WeiboJSBridge) {
                _this_.bridgeReady(tempBtn);
            } else {
                document.addEventListener('WeiboJSBridgeReady', function () {
                    _this_.bridgeReady(tempBtn);
                });
            }
        } else {
            _this_.nativeReady(tempBtn);
        }
    };

    Qrcode.prototype = {
        nativeReady: function (tempBtn) {
            $('[node-type=jsbridge]', tempBtn).on('click', function (e) {
                e.stopPropagation();
            });

            $(tempBtn).bind('click', function (e) {
                $(this).find('input[node-type=jsbridge]').trigger('click');
            });

            $(tempBtn).bind('change', this.getImgFile);
        },
        bridgeReady: function (tempBtn) {
            $(tempBtn).bind('click', this.weiBoBridge);
        },
        weiBoBridge: function () {
            window.WeiboJSBridge.invoke('scanQRCode', null, function (params) {
                //得到扫码的结果
                $('.result-qrcode').append(params.result + '<br/>');
            });
        },
        getImgFile: function () {
            var _this_ = this;
            var inputDom = $(this).find('input[node-type=jsbridge]');
            var imgFile = inputDom[0].files;
            var oFile = imgFile[0];
            var oFReader = new FileReader();
            var rFilter = /^(?:image\/bmp|image\/cis\-cod|image\/gif|image\/ief|image\/jpeg|image\/jpeg|image\/jpeg|image\/pipeg|image\/png|image\/svg\+xml|image\/tiff|image\/x\-cmu\-raster|image\/x\-cmx|image\/x\-icon|image\/x\-portable\-anymap|image\/x\-portable\-bitmap|image\/x\-portable\-graymap|image\/x\-portable\-pixmap|image\/x\-rgb|image\/x\-xbitmap|image\/x\-xpixmap|image\/x\-xwindowdump)$/i;

            if (imgFile.length === 0) {
                return;
            }

            if (!rFilter.test(oFile.type)) {
                alert("选择正确的图片格式!");
                return;
            }

            oFReader.onload = function (oFREvent) {

                qrcode.decode(oFREvent.target.result);
                qrcode.callback = function (data) {
                    var tt = data;
                    data = utf8Decode(tt);
                    //得到扫码的结果
                    $('.result-qrcode').append(data + '<br/>');
                };
            };

            oFReader.readAsDataURL(oFile);
        },
        destory: function () {
            $(tempBtn).off('click');
        }
    };

    Qrcode.init = function (tempBtn) {
        var _this_ = this;

        tempBtn.each(function () {
            new _this_($(this));
        });
    };
    window.Qrcode = Qrcode;
})(window.Zepto ? Zepto : jQuery);


function utf8Decode(inputStr) {
    var outputStr = "";
    var code1, code2, code3, code4;
    if (inputStr) {
        for (var i = 0; i < inputStr.length; i++) {
            code1 = inputStr.charCodeAt(i);
            if (code1 < 128) {
                outputStr += String.fromCharCode(code1);
            }
            else if (code1 < 224) {
                code2 = inputStr.charCodeAt(++i);
                outputStr += String.fromCharCode(((code1 & 31) << 6) | (code2 & 63));
            }
            else if (code1 < 240) {
                code2 = inputStr.charCodeAt(++i);
                code3 = inputStr.charCodeAt(++i);
                outputStr += String.fromCharCode(((code1 & 15) << 12) | ((code2 & 63) << 6) | (code3 & 63));
            }
            else {
                code2 = inputStr.charCodeAt(++i);
                code3 = inputStr.charCodeAt(++i);
                code4 = inputStr.charCodeAt(++i);
                outputStr += String.fromCharCode(((code1 & 7) << 18) | ((code2 & 63) << 12) | ((code3 & 63) << 6) | (code2 & 63));
            }
        }
    }
    return outputStr;
}
