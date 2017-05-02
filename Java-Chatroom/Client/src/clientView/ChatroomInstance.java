package clientView;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.IOException;

import static java.lang.Thread.sleep;

/**
 * Created by lxxy on 2015/5/5.
 */
public class ChatroomInstance implements Runnable {
    private MainPanel myMainPanel;
    private Tray myTray;
    private static ChatroomInstance myChatromInstance = new ChatroomInstance();

    private ChatroomInstance() {
        myMainPanel = MainPanel.getMainPanel();
        myTray = Tray.getMyTray();
        new Thread(myMainPanel).start();
        new Thread(myTray).start();
    }

    public static ChatroomInstance getMyChatromInstance() {
        return myChatromInstance;
    }

    public void run() {
        ChatroomInstance mytray = ChatroomInstance.getMyChatromInstance();
    }

}
