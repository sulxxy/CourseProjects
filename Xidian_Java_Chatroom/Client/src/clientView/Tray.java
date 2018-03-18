package clientView;

import model.Group;
import model.Msg;
import model.User;
import model.WindowMap;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.IOException;
import java.util.ArrayList;

import static java.lang.Thread.sleep;

/**
 * Created by lxxy on 2015/5/6.
 */
public class Tray implements Runnable {
    private SystemTray MyTray;
    private TrayIcon myTrayIcon;
    private ImageIcon TrayImage;
    private ImageIcon TrayBlank;
    private MainPanel myMainPanel;
    private static Tray myTray = new Tray();
    private Boolean Shineflag;
    private java.util.List<Object> objectList;

    private Tray() {
        Shineflag = true;
        objectList = new ArrayList<>();
        myMainPanel = MainPanel.getMainPanel();
        initTray();
    }

    public static Tray getMyTray() {
        return myTray;
    }

    private void initTray() {
        MyTray = SystemTray.getSystemTray();
        try {
            TrayImage = new ImageIcon(ImageIO.read(getClass().getClassLoader().getResource("images/tray.jpg")));
            TrayBlank = new ImageIcon("");
            myTrayIcon = new TrayIcon(TrayImage.getImage(), "chatroom");
            myTrayIcon.setImageAutoSize(true);
            MyTray.add(myTrayIcon);
        } catch (AWTException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        myTrayIcon.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    myMainPanel.setExtendedState(JFrame.NORMAL);
                    myMainPanel.pack();
                    myMainPanel.setVisible(true);
                }
            }
        });
    }

    public synchronized void setTrayShine(Msg mg, Object obj) {
        MouseAdapter ShineAdapter = new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                    Shineflag = false;
                switch (mg.GetMsgType()){
                    case SignIn:
                        break;
                    case SignUp:
                        break;
                    case LogOut:
                        break;
                    case SignOut:
                        break;
                    case GroupChat:
                        Group tmpgrp = (Group)obj;
                        GroupChatPanel myGroupChatPanel = new GroupChatPanel(tmpgrp);
                        WindowMap.getInstance().add(mg.GetSendTo(), myGroupChatPanel);
                        new Thread(myGroupChatPanel).start();
                        break;
                    case PrivateChat:
                        User tmp = (User)obj;
                        PrivateChatPanel myPrivateChatPanel = new PrivateChatPanel(tmp);
                        WindowMap.getInstance().add(mg.GetSendFrom(), myPrivateChatPanel);
                        new Thread(myPrivateChatPanel).start();
                        break;
                    case Response:
                        break;
                    case GroupChatInit:
                        break;
                    case UserInfo:
                        break;
                }
            }
        };
        myTrayIcon.addMouseListener(ShineAdapter);
        try {
            while(Shineflag) {
                myTrayIcon.setImage(TrayBlank.getImage());
                sleep(400);
                myTrayIcon.setImage(TrayImage.getImage());
                sleep(400);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Shineflag = true;
        myTrayIcon.removeMouseListener(ShineAdapter);
    }

    public void run() {
        Tray mytray = Tray.getMyTray();
    }

    public static void main(String[] args){
        Tray mytray = Tray.getMyTray();
//        mytray.setTrayShine();
    }
}
