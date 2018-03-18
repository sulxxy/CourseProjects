package model;

import java.io.Serializable;
import java.util.ArrayList;

public class User implements Serializable {

	public enum Status {
		Online, Offline, Depature, Busy
	}

	private static final long serialVersionUID = 1L;
	private String ID = null;
	private String password = null;
	private String username = null;
	private String gender = null;
	private Status state = Status.Depature;
	private ArrayList<Chatroom> chatrooms;

	public User(String ...args) {
		for(int i = 0; i < args.length; i++){
			switch (i){
				case 0:
					ID = args[i];
					break;
				case 1:
					password = args[i];
					break;
				case 2:
					username = args[i];
					break;
				case 3:
					gender = args[i];
					break;
				case 4:
					state = Status.valueOf(args[i]);
					break;
				default:
					break;
			}
		}
		chatrooms = new ArrayList<Chatroom>();
	}

//	public static User Register(String id, String pwd, String gender) {
//		return ServerBackend.Register(id, pwd, gender);
//	}

	public Status GetState() {
		return state;
	}

	public void SetStatus(Status s) {
		state = s;
	}

	public String GetID() {
		return ID;
	}

	public String GetGender(){
		return gender;
	}
	
//	public boolean SignIn() {
//		return ServerBackend.SignIn(this);
//	}

//	public boolean SignOut() {
//		//TODO
//		return true;
//	}

//	public void Notify(String msg) {
//		System.out.println(ID + " has received msg: " + msg);
//	}
//
//	public void SendMsg(Chatroom id, String msg) {
//		if (chatrooms.contains(id)) {
//			id.SendMessage(this, msg);
//		} else {
//			System.out
//					.println("You're not in the chat group. You cannot send message.");
//		}
//	}

//	public Chatroom CreateChatroom() {
//		Chatroom tmp = new Chatroom(this);
//		chatrooms.add(tmp);
//		return tmp;
//	}
//
//	public boolean JoinChatroom(Chatroom id) {
//		return id.Register(this);
//	}

	@Override
	public String toString(){
		return ID;
	}
}
