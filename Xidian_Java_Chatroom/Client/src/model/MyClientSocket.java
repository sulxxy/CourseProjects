package model;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

import clientView.*;

import javax.swing.*;

public class MyClientSocket extends Thread {
    private Socket soc = null;
    private ObjectInputStream MyClientReader;
    private ObjectOutputStream MyClientWriter;
    private static MyClientSocket mySocket = new MyClientSocket();

    private MyClientSocket() {
    }

    public static MyClientSocket GetMySocket() {
        return mySocket;
    }

    public Socket GetSocket() {
        return soc;
    }

    public void run() {
        try {
            soc = new Socket("127.0.0.1", 10000);
            if (soc.isConnected()) {
                System.out.println("Client has connected to Server");
            }
            MyClientWriter = new ObjectOutputStream(soc.getOutputStream());
            MyClientReader = new ObjectInputStream(soc.getInputStream());
            new ClientSocketWriterThread(MyClientWriter).start();
            new ClientSocketReaderThread(MyClientReader).start();

        } catch (IOException ie) {
            ie.printStackTrace();
        }
    }
}

class ClientSocketReaderThread extends Thread {
    private ObjectInputStream MyClientReader;
    private Msg mg = null;
    java.util.List<User> FriendList;
    java.util.List<Group> GroupList;
    java.util.List<Msg> OfflineMsg;

    public ClientSocketReaderThread(ObjectInputStream s) {
        MyClientReader = s;
    }

    public void run() {
        try {
            while (true) {
                System.out.println("ClientSocketReader.run()");
                mg = (Msg) MyClientReader.readObject();
                //TODO dispose message
                if (mg != null)
                    ResolvMsg(mg);
            }
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            try {
                MyClientReader.close();
            } catch (IOException e2) {
                // TODO: handle exception
                e2.printStackTrace();
            }
        }
    }

    public void ResolvMsg(Msg mg) {
        String winID;
        switch (mg.GetMsgType()) {
            case SignIn:
//                java.util.List<User> tmp = (java.util.List<User>) mg.GetContent();
                if (mg.GetContent() != null) {
                    java.util.List<Msg> MsgList = (java.util.List<Msg>) mg.GetContent();
                    User owner = (User) MsgList.get(0).GetContent();
                    FriendList = (java.util.List<User>) MsgList.get(1).GetContent();
                    GroupList = (java.util.List<Group>) MsgList.get(2).GetContent();
                    OfflineMsg = (java.util.List<Msg>) MsgList.get(3).GetContent();
                    ClientBackend.getClient().SetUser(owner);
                    Login.getLgView().dispose();
                    ChatroomInstance myMainInstance = ChatroomInstance.getMyChatromInstance();
                    Thread myChatroomInstanceThread = new Thread(myMainInstance);
                    MainPanel.getMainPanel().AddFriendList(FriendList);
                    MainPanel.getMainPanel().AddGroupList(GroupList);
                    myChatroomInstanceThread.start();
                    for (Msg tmpmsg : OfflineMsg) {
//                        System.out.println("sdfsd");
                        ResolvMsg(tmpmsg);
                    }
                } else {
                    JOptionPane.showMessageDialog(Login.getLgView(), "Validation Failed.", "Error", JOptionPane.ERROR_MESSAGE);
                }
                break;
            case GroupChatInit:
                winID = mg.GetSendTo();
                java.util.List<User> userList = (java.util.List<User>) mg.GetContent();
                ((GroupChatPanel) WindowMap.getInstance().getById(winID)).AddJList(userList);
                break;
            case GroupChat:
                winID = mg.GetSendTo();
                if (WindowMap.getInstance().getById(winID) == null) {
                    Tray.getMyTray().setTrayShine(mg, SearchGroupList(GroupList, mg));
                }
                ((GroupChatPanel) WindowMap.getInstance().getById(winID)).DisplayMsg(mg);
                break;
            case PrivateChat:
                if (WindowMap.getInstance().getById(mg.GetSendFrom()) == null) {
                    Tray.getMyTray().setTrayShine(mg, SearchFriendList(FriendList, mg));
                }
                ((PrivateChatPanel) (WindowMap.getInstance().getById(mg.GetSendFrom()))).DisplayMsg(mg);
                System.out.println("MyClientSocket.ResolvMsg: " + mg.GetSendFrom());
                break;
           /*
           TODO other cases
            */
            default:
                break;
        }
    }

    public synchronized User SearchFriendList(List<User> list, Msg mg) {
        for (User tmp : list) {
            if (mg.GetSendFrom().equals(tmp.GetID())) {
                return tmp;
            }
        }
        return null;
    }

    public synchronized Group SearchGroupList(List<Group> list, Msg mg) {
        for (Group tmp : list) {
            if (mg.GetSendTo().equals(tmp.getGroupID())) {
                return tmp;
            }
        }
        return null;
    }
}

class ClientSocketWriterThread extends Thread {
    private ObjectOutputStream MyClientWriter;
    private Msg mg;
    private MsgStack myMsgStack = null;

    public ClientSocketWriterThread(ObjectOutputStream s) {
        myMsgStack = MsgStack.GetMsgStack();
        MyClientWriter = s;
    }

    public void run() {
        try {
            while (true) {
                mg = myMsgStack.pop();
                System.out.println("ClientSocketWriter.run()");
                MyClientWriter.writeObject(mg);
                MyClientWriter.flush();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                MyClientWriter.close();
            } catch (IOException e2) {
                // TODO: handle exception
                e2.printStackTrace();
            }
        }
    }
}
