package clientView;

import model.*;

import javax.swing.*;
import java.awt.event.*;

public class MainPanel extends JFrame implements Runnable{
    private JPanel contentPane;
    private JPanel InfoPane;
    private JTabbedPane MyTabbedPane;
    private JPanel FriendListPane;
    private JList FriendList;
    private DefaultListModel FriendListModel;
    private JPanel GroupListPane;
    private JList GroupList;
    private DefaultListModel GroupListModel;
    private static MainPanel myMainPanel = new MainPanel();

    private MainPanel() {
        FriendListModel = new DefaultListModel();
        FriendList = new JList(FriendListModel);
        FriendListPane.add(FriendList);
        GroupListModel = new DefaultListModel();
        GroupList = new JList(GroupListModel);
        GroupListPane.add(GroupList);
        setContentPane(contentPane);
        addWindowListener(new WindowAdapter() {
            @Override
            public void windowIconified(WindowEvent e) {                         //minimize to system tray
                setVisible(false);
            }
        });
        GroupList.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    GroupChatPanel myChatPanel;
                    Group tmp = (Group) GroupList.getSelectedValue();
                    if(WindowMap.getInstance().getById(tmp.getGroupID()) == null) {
                        myChatPanel = new GroupChatPanel(tmp);
                        System.out.println("MainPanel.MainPanel" + tmp.getGroupID());
                        WindowMap.getInstance().add(tmp.getGroupID(), myChatPanel);
                    }else{
                        myChatPanel =(GroupChatPanel)WindowMap.getInstance().getById(tmp.getGroupID());
                    }
                    new Thread(myChatPanel).start();
                    try {
                        ClientBackend.getClient().GenerateMsg(Msg.MsgType.GroupChatInit, tmp.getGroupID());
                    } catch (Exception e1) {
                        e1.printStackTrace();
                    }
                }
            }
        });

        FriendList.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if(e.getClickCount() == 2){
                    User tmp = (User)FriendList.getSelectedValue();
                    PrivateChatPanel myChatPanel;
                    if(WindowMap.getInstance().getById(tmp.GetID()) == null) {
                        myChatPanel = new PrivateChatPanel(tmp);
                        System.out.println("MainPanel.MainPanel" + tmp.GetID());
                        WindowMap.getInstance().add(tmp.GetID(), myChatPanel);
                    }else{
                        myChatPanel =(PrivateChatPanel)WindowMap.getInstance().getById(tmp.GetID());
                    }
                    new Thread(myChatPanel).start();
                }
            }
        });
    }
    public static MainPanel getMainPanel(){
        return  myMainPanel;
    }


    public void AddGroupList(java.util.List<Group> grouplist){
       for(Group tmp:grouplist){
           GroupListModel.addElement(tmp);
       }
    }
    public void AddFriendList(java.util.List<User> friendlist){
        for(User tmp:friendlist){
            FriendListModel.addElement(tmp);
        }
    }
    public void run(){
//        MainPanel dialog = new MainPanel();
        pack();
        setVisible(true);

//        System.exit(0);
    }
}
