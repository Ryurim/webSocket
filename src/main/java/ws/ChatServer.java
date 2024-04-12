package ws;

import java.io.IOException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import jakarta.websocket.OnClose;
import jakarta.websocket.OnError;
import jakarta.websocket.OnMessage;
import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/ChatServer") //웹서블릿 annotation과 동일한 역할을 함!
public class ChatServer {
	private static Set<Session> clients = Collections.synchronizedSet(new HashSet<Session>());
	
	@OnOpen
	public void onOpen(Session session) {
		System.out.println("웹소켓 연결 : " + session.getId());
		clients.add(session);
	}
	
	@OnMessage
	public void onMessage(String msg, Session session) throws IOException {
		System.out.println(
				String.format("메세지 전송 -> %s : %s", session.getId(), msg)
		);
		synchronized(clients) { //웹소켓에 메세지 전달 
			for (Session client : clients) {
				if (!client.equals(session)) { // 내가 아닌 사람에게만 메세지 전송. 내거는 내 유아이에서만 바뀌면 돼. 네트워크를 탈 필요 X
					client.getBasicRemote().sendText(msg);
				}
			}
		}
	}
	
	@OnClose
	public void onClose(Session session) {
		System.out.println("웹소켓 종료 : " + session.getId());
		clients.remove(session);
	}
	
	@OnError
	public void onError(Throwable e) {
		System.out.println("에러 발생 : " + e.getMessage());
		e.printStackTrace();
	}
}
