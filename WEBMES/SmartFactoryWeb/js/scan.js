//�Ƿ�ɹ�����getUserMedia��ʶ
var gUM = false;
//����getContext����
var gCtx = null;
// ����������
var imageData = null;
//��Ƶչʾ����
var v = document.getElementById("v");
var n = navigator;
// ����Ԫ��
var gCanvas = document.getElementById("qr-canvas");
gCtx = gCanvas.getContext('2d');
qrcode.callback = function (e) {
	//����ص�
	alert(e);
}
//��ͬgetUserMedia����
if (n.getUserMedia) {
	// �ƶ��豸�򿪺�������ͷ�� facingMode: "environment"�� 
	n.getUserMedia({ video: { facingMode: "environment" } }, success, error);
}
else
	if (n.mediaDevices.getUserMedia) {
		n.mediaDevices.getUserMedia({ video: { facingMode: "environment" }, audio: false })
			.then(success)
			.catch(error);
	}
	else
		if (n.webkitGetUserMedia) {
			webkit = true;
			n.webkitGetUserMedia({ video: { facingMode: "environment" } }, success, error);
		}
		else
			if (n.mozGetUserMedia) {
				moz = true;
				n.mozGetUserMedia({ video: { facingMode: "environment" } }, success, error);
			}
//getUserMedia���óɹ�
function success(stream) {
	v = document.getElementById("v");
	try {
		v.srcObject = stream;
	} catch {
		//�����Ǽ���д��
		let compatibleURL = window.URL || window.webkitURL;
		v.src = compatibleURL.createObjectURL(stream);
	}
	gUM = true;
	setTimeout(captureToCanvas, 500);
}
//getUserMedia����ʧ��
function error(error) {
	gUM = false;
	return;
}

//����Ƶ���ŵ�����
function captureToCanvas() {
	if (gUM) {
		gCtx.drawImage(v, 0, 0);

		setTimeout(captureToCanvas, 500);

		imageData = gCtx.getImageData(0, 0, 600, 800);

		const code = jsQR(imageData.data, imageData.width, imageData.height, {
			inversionAttempts: "dontInvert",
		});

		alert('code.data:' + code.data);

		if (code) {
			window.location.href = code.data;
		} else {
			alert("ʶ�����")
		}
	}
}