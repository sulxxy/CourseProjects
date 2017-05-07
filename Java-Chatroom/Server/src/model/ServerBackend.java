package model;

import java.io.IOException;

import model.Msg.MsgType;
import dbOperation.Connector;

public class ServerBackend {
	private Connector DBInstance = Connector.GetConnector();
	private static final ServerBackend myServer = new ServerBackend();
	private static MyServerSocket mySocket = null;

	private ServerBackend() {
		// TODO: Init the server
		// DBInstance = Connector.GetConnector(); //cannot place here!!!!
		mySocket = MyServerSocket.GetMySocket();
		mySocket.start();
	}

	public static ServerBackend getServerBackend() {
		return myServer;
	}

	// public static boolean Query(User usr) {
	// // TODO: check if id is in the database
	// return DBInstance.QueryByID(usr.GetID());
	// }
	//
	// public static boolean Query(String id) {
	// return DBInstance.QueryByID(id);
	// }

	// public static User Register(String id, String pwd, String gender) {
	// TODO: add id to database
	// if (Query(id)) {
	// System.out.println("The ID " + id
	// + " has been existed. Please log in");
	// return null; /* there may be some bug here!!!!!!!! */
	// } else {
	// DBInstance.InsertUser(id, pwd, gender);
	// return new User(id, pwd, gender);
	// }
	// }

	// public boolean Remove(User usr) {
	// // TODO:
	// if (Query(usr)) {
	// DBInstance.RemoveUser(usr.GetID());
	// return true;
	// } else {
	// System.out.println("the user" + usr.GetID() + "doesn't exist.");
	// return false;
	// }
	// }

	public boolean Halt() {
		// TODO: halt the server
		return true;
	}

	// public static User Search(String id){
	// //TODO:
	//
	// }
}
