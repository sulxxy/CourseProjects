package model;

import java.io.*;
import java.io.ObjectOutputStream;
import java.net.*;
import java.util.*;

import dbOperation.Connector;

import javax.xml.ws.Response;

public class MyServerSocket extends Thread {
    private ServerSocket MyServerSocket;
    private static MyServerSocket mySocket = new MyServerSocket();

    private MyServerSocket() {
        try {
            MyServerSocket = new ServerSocket(10000);
            System.out.println("Server is starting...");

        } catch (IOException ie) {
            ie.printStackTrace();
        }
    }

    public static MyServerSocket GetMySocket() {
        return mySocket;
    }

    public void run() {
        while (true) {
            Socket mySocket;
            MsgStack myMsgStack = new MsgStack();
            try {
                mySocket = MyServerSocket.accept();
                ObjectInputStream MyBufferReader = new ObjectInputStream(
                        mySocket.getInputStream());
                ObjectOutputStream MyPrintWriter = new ObjectOutputStream(
                        mySocket.getOutputStream());
                ServerSocketWriterThread WriteThread = new ServerSocketWriterThread(MyPrintWriter, myMsgStack);
                Thread MyServerSocketWriterThread = new Thread(WriteThread);
                ServerSocketReaderThread ReadThread = new ServerSocketReaderThread(MyBufferReader, WriteThread, myMsgStack);
                Thread MyServerSocketReaderThread = new Thread(ReadThread);
                MyServerSocketReaderThread.start();
                MyServerSocketWriterThread.start();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }

        }
    }
}

class ServerSocketReaderThread implements Runnable {
    protected Connector DBInstance = Connector.GetConnector();
    protected MsgStack MyMsgStack = null;
    protected WriterMap MyWriterMap = WriterMap.getInstance();
    protected ServerSocketWriterThread MyServerSocketWriterThread;
    ObjectInputStream MyBufferReader = null;
    private Msg mg = null;

    private User SignIn(String id, String password) {
        /*
         * TODO 1. check whether id is legal
         * TODO 2. change the user state to Online ( or Busy , Departure)
         * TODO 3. modify the DB
         * TODO 4. check the offline message
         * TODO 5. if the user has been online, do nothing
		 */
        User tmp = DBInstance.QueryByID(id);
        if (tmp == null) {
            System.out
                    .println("ServerBackend.SignIn: the id doesn't exist. Please check and input again.");
            return null;
        } else if (tmp.GetState() != User.Status.Offline) {
            System.out
                    .println("ServerBackend.SignIn: you has been logged in. You cannot log in again.");
            tmp = null;
            return tmp;
        } else {
            /*
             * TODO Validate User info
			 */
            if (DBInstance.ValidateUser(id, password)) {
                tmp.SetStatus(User.Status.Online);
                DBInstance.SetUserState(id, User.Status.Online);
                /*
                 * TODO update database receive offline message
				 */
                System.out.println("MyServerSocket.SignIn:suc");
                return tmp;
            } else {
                return null;
            }
        }
    }

    public void SignOut(String id) {
        /*
         * TODO 1. check whether the id is legal (maybe not necessary)
		 * TODO 2. change the user state to offline
		 * TODO 3. update user database state
		 * TODO 4. record sign out time
		 */
        DBInstance.SetUserState(id, User.Status.Offline);


    }

    public Object DisposeMsg(Msg m) {
        Msg.MsgType mtp = m.GetMsgType();
        String id = m.GetSendFrom();
        switch (mtp) {
            case SignIn:
                /*
                TODO 1. Sign in
                TODO 2. return a user instance
                 */
                User tmp = SignIn(id, m.GetExtra());
                    /*
                    TODO Send Error response to user client
                    TODO Send SignIn Accept response to user client
                    TODO Send User Friends and Groups Information
                    TODO Send User's offline message
                     */
                if (tmp != null) {
                    MyWriterMap.add(tmp.GetID(), MyServerSocketWriterThread);
                    List<Msg> myMsgList = new ArrayList<>();
                    Msg userInfoMsg = new Msg(Msg.MsgType.UserInfo, null, null, null, tmp, null);
                    //TODO MODIFY method GetAllUserID() LATER
                    Msg userFriendsInfoMsg = new Msg(Msg.MsgType.UserInfo, null, null, null, DBInstance.GetAllUserID(), null);
                    Msg userGroupsInfoMsg = new Msg(Msg.MsgType.UserInfo, null, null, null, DBInstance.GetAllGroup(tmp.GetID()), null);
                    Msg OfflineMsg = new Msg(Msg.MsgType.OfflineMsg, null, null, null, DBInstance.CheckMsg(tmp.GetID()), null);
                    myMsgList.add(userInfoMsg);
                    myMsgList.add(userFriendsInfoMsg);
                    myMsgList.add(userGroupsInfoMsg);
                    myMsgList.add(OfflineMsg);
                    MyServerSocketWriterThread.SetMsg(Msg.MsgType.SignIn, null, null, null, myMsgList, null);
                } else {
                    MyServerSocketWriterThread.SetMsg(Msg.MsgType.SignIn, null, null, null, tmp, null);
                }
                break;
            case SignOut:
                /*
                TODO 1. change User state to Offline
                TODO 2. disconnect with each other
                 */
                SignOut(id);
                break;
            case SignUp:
                /*
                TODO 1. Create new User in the DB and execute validation
                 */
                break;
            case LogOut:
                /*
                TODO 1. Delete User Info from DB
                 */
                break;
            case GroupChat:
                List<ServerSocketWriterThread> MyWriterThreadList = MyWriterMap.getAllSocketThread();
                for (ServerSocketWriterThread s : MyWriterThreadList) {
                    s.SetMsg(Msg.MsgType.GroupChat, mg.GetSendFrom(), mg.GetSendTo(), null, mg.GetContent(), null);
                }
                break;
            case PrivateChat:
                ServerSocketWriterThread MyWriterThread = MyWriterMap.getById(mg.GetSendTo());
                if (WriterMap.getInstance().getById(mg.GetSendTo()) != null)
                    MyWriterThread.SetMsg(Msg.MsgType.PrivateChat, mg.GetSendFrom(), mg.GetSendTo(), null, mg.GetContent(), null);
                else{
                    //not online, write to database
                    mg.SetTime(new java.sql.Timestamp(new java.util.Date().getTime()));
                    DBInstance.WriteMsg(mg);
                }
                break;
            case GroupChatInit:
                List<User> UserList = new ArrayList<>();
                for (User tmpusr : DBInstance.GetAllUserID()) {
                    UserList.add(tmpusr);
                }
                MyServerSocketWriterThread.SetMsg(Msg.MsgType.GroupChatInit, null, mg.GetSendFrom(), null, UserList, null);

                break;
            default:
                return false;
        }

        return true;
    }


    public ServerSocketReaderThread(ObjectInputStream is, ServerSocketWriterThread os, MsgStack msgStack) {
        MyServerSocketWriterThread = os;
        MyBufferReader = is;
        MyMsgStack = msgStack;
    }

    public void run() {
        try {
            while (true) {
                System.out.println("MyServerSocket.ServerSocketReaderThread.run()");
                mg = (Msg) MyBufferReader.readObject();
                DisposeMsg(mg);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                MyBufferReader.close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

}

class ServerSocketWriterThread implements Runnable {
    private ObjectOutputStream MyPrintWriter;
    private Msg mg = null;
    private MsgStack MyMsgStack;

    public ServerSocketWriterThread(ObjectOutputStream s, MsgStack msgStack) {
        MyMsgStack = msgStack;
        MyPrintWriter = s;
    }

    public void SetMsg(Object... args) {
        //TODO Send response message to user client
        Msg m = new Msg(args);
        java.sql.Timestamp d = new java.sql.Timestamp(new java.util.Date().getTime());
        m.SetTime(d);
//        switch (m.GetMsgType()) {
//            case Response:
//                User usr = ((User) content);
//                if (usr != null)
//                    m.SetContent(usr);
//                break;
//            case PrivateChat:
//                String str = (String) content;
//                m.SetContent(str);
//                break;
//            default:
//                break;
//        }
        MyMsgStack.push(m);

    }

    public void SetMsgbak(Msg.MsgType tp, Object content) {
        //TODO Send response message to user client
        Msg m = new Msg();
        java.sql.Timestamp d = new java.sql.Timestamp(new java.util.Date().getTime());
        m.SetTime(d);
        m.SetMsgType(tp);
        switch (tp) {
            case Response:
                User usr = ((User) content);
                if (usr != null)
                    m.SetContent(usr);
                break;
            case PrivateChat:
                String str = (String) content;
                m.SetContent(str);
                break;
            default:
                break;
        }
        MyMsgStack.push(m);

    }

    public void run() {
        try {
            while (true) {
                System.out
                        .println("MyServerSocket.ServerSocketWriterThread.run()");
                mg = MyMsgStack.pop();
                MyPrintWriter.writeObject(mg);
                MyPrintWriter.flush();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                MyPrintWriter.close();
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }
}

class WriterMap {
    private HashMap<String, ServerSocketWriterThread> map;
    private static WriterMap instance = new WriterMap();

    private WriterMap() {
        map = new HashMap<String, ServerSocketWriterThread>();
    }

    public synchronized static WriterMap getInstance() {
        return instance;
    }

    public synchronized void add(String id, ServerSocketWriterThread out) {
        if (this.getById(id) == null) {
            map.put(id, out);
        }
    }

    public synchronized void remove(String id) {
        map.remove(id);
    }

    public synchronized ServerSocketWriterThread getById(String id) {
        return map.get(id);
    }

    public synchronized List<ServerSocketWriterThread> getAllSocketThread() {
        List<ServerSocketWriterThread> list = new ArrayList<ServerSocketWriterThread>();
        for (Map.Entry<String, ServerSocketWriterThread> entry : map.entrySet()) {
            list.add(entry.getValue());
        }
        return list;
    }

    public synchronized List<String> getAllUser() {
        List<String> list = new ArrayList<String>();
        for (Map.Entry<String, ServerSocketWriterThread> entry : map.entrySet()) {
            list.add(entry.getKey());
        }
        return list;
    }
}
