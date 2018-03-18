package model;
import clientView.*;
import sun.rmi.runtime.Log;

import javax.swing.*;
import java.util.*;

public class ClientBackend {
	private static ClientBackend myClient = new ClientBackend();
	private static Msg myMsg;
	private MyClientSocket mySocket = null;
	private static User MyUser;               //TODO:instantiation after login succeeded.
	private MsgStack msgStack = null;
	private WindowMap myWindowMap = WindowMap.getInstance();
	private ClientBackend(){
		msgStack = MsgStack.GetMsgStack();
		mySocket = MyClientSocket.GetMySocket();
		mySocket.start();
	}
	public static ClientBackend getClient(){
		return myClient;
	}
//	public  Login getLgView(){
//		return lgView;
//	}
	public void SetUser(User u){
		MyUser = u;
	}
	public User GetUser(){
		return MyUser;
	}
	public void SendMsg(Msg mg) throws Exception{
		java.sql.Timestamp d = new java.sql.Timestamp(new java.util.Date().getTime());
		mg.SetTime(d);
		msgStack.push(mg);
	}
	public Msg GenerateMsg(Object ...args) throws Exception{
		myMsg = new Msg(args);
		SendMsg(myMsg);
		return myMsg;
	}
}


