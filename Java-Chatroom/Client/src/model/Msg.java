package model;

import java.io.Serializable;
import java.util.Date;

public class Msg implements Serializable {
    /**
     *
     */
    public enum MsgType {
        SignIn, SignUp, LogOut, SignOut, GroupChat, PrivateChat, Response, GroupChatInit, UserInfo, OfflineMsg
    }

    public enum ResponseType {
        Accept, Reject
    }

    private static final long serialVersionUID = 1L;
    private String SendFrom = null;
    private String SendTo = null;
    private Object Content = null; // TODO: reserved
    private java.sql.Timestamp time = null;
    private MsgType tp = null;
    private String Extra = null;

    public void Msg() {
    }

    public Msg(Object... args) {
        for (int i = 0; i < args.length; i++) {
            switch (i) {
                case 0:
                    tp = MsgType.valueOf(args[i].toString());
                    break;
                case 1:
                    SendFrom = (String) args[i];
                    break;
                case 2:
                    SendTo = (String) args[i];
                    break;
                case 3:
                    time = (java.sql.Timestamp) args[i];
                    break;
                case 4:
                    Content = args[i];
                    break;
                case 5:
                    Extra = (String) args[i];
                    break;
                default:
                    break;

            }
        }
    }

    public String GetSendFrom() {
        return SendFrom;
    }

    public String GetSendTo() {
        return SendTo;
    }

    public Object GetContent() {
        return Content;
    }

    public java.sql.Timestamp GetDate() {
        return time;
    }

    public MsgType GetMsgType() {
        return tp;
    }

    public String GetExtra() {
        return Extra;
    }

    public void SetSendFrom(String src) {
        SendFrom = src;
    }

    public void SetSendTo(String dest) {
        SendTo = dest;
    }

    public void SetMsgType(MsgType mtp) {
        tp = mtp;
    }

    public void SetExtra(String ext) {
        Extra = ext;
    }

    public void SetContent(Object content) {

        Content = content;
    }

    public void SetTime(java.sql.Timestamp d) {
        time = d;
    }

    @Override
    public String toString() {
        return tp + SendFrom + SendTo + time + Content + Extra;
    }
}

class MsgStack {
    private Msg mg = null;
    private static MsgStack MyMsgStack = new MsgStack();
    //	private static MsgStack myMsgStack = new MsgStack();
    private MsgStack() {

    }

    public static MsgStack GetMsgStack() {
        return MyMsgStack;
    }

    public synchronized void push(Msg m) {
        try {
            while (mg != null) {
//				System.out.println("stack is full");
                wait();
            }
            notify();
        } catch (InterruptedException e) {
            // TODO: handle exception
            e.printStackTrace();
        } catch (IllegalMonitorStateException e) {
            e.printStackTrace();
        }
        mg = m;
    }

    public synchronized Msg pop() {
        try {
            while (mg == null) {
//				System.out.println("stack is empty");
                wait();
            }
            notify();
        } catch (InterruptedException e) {
            // TODO: handle exception
            e.printStackTrace();
        }
        Msg tmp = mg;
        mg = null;
        return tmp;
    }
}