<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces = "true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅창</title>

<style>
	
</style>
<script>
	// 웹소켓 객체 생성!
	const webSock = new WebSocket("ws://localhost:8080/ws/ChatServer");
	
	let chatWin, chatId, chatMsg;
	
	//페이지 로딩 시 객체 초기화
	window.onload = function() {
		// 윈도우가 로딩되는 순간에 전역변수로 할당
		chatWin = document.getElementById("chatWin");
		chatId = document.getElementById("chatId");
		chatMsg = document.getElementById("chatMsg");
	};
	
	// 소켓 연결 시 메시지 출력
	webSock.onopen = function(e) {
		chatWin.innerHTML += "웹소켓 서버에 연결 되었습니다.<br>";
		chatWin.innerHTML += "${param.chatId} 님이 입장하셨습니다.<br>";
	};
	
	
	webSock.onmessage = function(e) {
		console.log("메시지 : " + e.data);
		
		let arrMsg = e.data.split("|"); //대화명 | 메시지 분리해서 배열에 저장
		let sender = arrMsg[0]; //대화명
		let msg = arrMsg[1]; //메시지
		if (msg != "") {
			msg = msg.trim();
			//귓속말일 경우
			if (msg.match("/")) { //메세지 중에 / 문자가 있으면 귓속말 이에요
				const tmpMsg = "\/" + chatId.value;
				if (msg.match(tmpMsg)) {
					let tmpTO = msg.replace(tmpMsg, "[귓속말] : ");
					chatWin.innerHTML += "<div class='chatMsg'>" + sender + " " + tmpTO + "</div>";
				}
			} else { //일반 대화일 경우
				chatWin.innerHTML += "<div class='chatMsg'>" + sender + " : " + msg + "</div>";
			}
		}
		chatWin.scrollTop = chatWin.scrollHeight;
	};
	
	//소켓 종료 시 메시지 출력
	webSock.onclose = function(e) {
		chatWin.innerHTML += "${param.chatId} 님이 채팅을 종료합니다.<br>";
		chatWin.innerHTML += "웹소켓 서버와의 연결이 종료 되었습니다.<br>";
	};
	
	// 엔터키 클릭 시 메시지 전송 처리
	function keyPress() {
		if (window.event.keyCode == 13) {	//엔터키
			sendMsg();
		}
	}
	
	//메세지 전송
	function sendMsg() {
		if (chatWin == null) chatWin = document.getElementById("chatWin");
		
		chatWin.innerHTML += "<div class='myMsgDiv' style='width:100%; text-align:right;'><span class='myMsg'>" + chatMsg.value + "</span></div>";
		webSock.send(chatId.value + "|" + chatMsg.value);
		chatMsg.value = "";
		chatWin.scrollTop = chatWin.scrollHeight;
	}
	
	//소켓 연결 종료
	function sockClose() {
		const flag = confirm("채팅을 종료합니다.");
		if (flag) {
			webSock.close();
			window.close();
		}
	}
</script>

</head>
<body>
	<div>
		<span>대화명 : </span>
		<input type="text" name="chatId" id="chatId" value="${param.chatId }" readonly />
		<button id="btnClose" onclick="sockClose()">채팅 종료</button>
	</div>
	<div id="chatWin"></div>
	<div>
		<input type="text" name="chatMsg" id="chatMsg" onkeyup="keyPress()"> <!-- 한글은 2byte이기 때문에 깨질 수 있으니 keydown 하면 안되고 keyup 해야해-->
		<button id="btnSend" onclick="sendMsg()">전송</button>
	</div>
</body>
</html>