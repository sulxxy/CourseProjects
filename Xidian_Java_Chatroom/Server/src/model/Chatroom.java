package model;

import java.util.ArrayList;

public class Chatroom {
	private ArrayList<User> GroupMembers;
	private String ID;

	public Chatroom(User Admin) {
		GroupMembers = new ArrayList<User>();
		GroupMembers.add(Admin);
	}

	public String GetChatroomID() {
		return ID;
	}

	public boolean Register(User id) {
		if (GroupMembers.contains(id)) {
			System.out.println(id + " has been in the chat group");
			return false;
		} else {
			GroupMembers.add(id);
			return true;
		}
	}

	public void SendMessage(User Sender, String msg) {
		for (User user : GroupMembers) {
			if (!user.GetID().equals(Sender.GetID()))
				user.Notify(msg);
		}
	}
}
