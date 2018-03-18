package testServer;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.sql.SQLException;

import model.ServerBackend;

public class Test {
	// User usr1;
	// User usr2;
	// Chatroom cht1;
	
	public static final void main(String[] args) throws SQLException,
			UnknownHostException, Exception {
		// User usr1 = new User("ttt", "111222","male");
		// User usr2 = User.Register("tz", "111222", "female");
		// Server te = new Server();
		// te.Remove(usr1);
		// MySocket mys = new MySocket();
		// Login lg = new Login();
		 ServerBackend myServer = ServerBackend.getServerBackend();
		}
}