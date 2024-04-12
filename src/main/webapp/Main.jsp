<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces = "true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채팅 서비스 메인 페이지</title>

<script>
	function openChatWin() {
		const chatId = document.getElementById("chatId");
		if (chatId.value == "" || chatId.value.length <= 0) {
			alert("대화명을 입력하세요.");
			chatId.focus();
			return;
		}
		window.open("ChatWin.jsp?chatId=" + chatId.value, "", "top=200, left=200, width=510, height=620, menubar=no, toolbar=no, location=no, status=no, scrollbars=no"); //팝업창으로 띄워줄 겁니다
	}
</script>
</head>
<body>
	<div>
		<h2>웹 소켓 채팅 - 대화명 입력</h2>
		<span>대화명 : </span>
		<input type="text" name="chatId" id="chatId" value="${param.chatId }" maxlength="20" >
		<button id="btnAccess" onclick="openChatWin()">채팅 참여</button>
	</div>
</body>
</html>