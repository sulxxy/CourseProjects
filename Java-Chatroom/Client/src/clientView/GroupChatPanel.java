package clientView;

import model.*;

import javax.swing.*;
import javax.swing.text.BadLocationException;
import javax.swing.text.StyledDocument;
import java.awt.event.*;
import java.lang.*;

public class GroupChatPanel extends JFrame implements Runnable {
    private JPanel contentPane;
    private JButton buttonClose;
    private JButton buttonSend;
    private JTextPane ChatPane;
    private JTextPane InputPane;
    private JPanel ListPanel;
    private JList UserList;
    private ClientBackend myClientBackend = ClientBackend.getClient();
    private Msg mg = null;
    private Group myGroup;
    DefaultListModel listModel;

    public GroupChatPanel(Group id) {
        myGroup = id;
        listModel = new DefaultListModel();
        UserList = new JList(listModel);
        ListPanel.add(UserList);
//        contentPane.add(ListPanel);
        setContentPane(contentPane);
        getRootPane().setDefaultButton(buttonClose);
        buttonClose.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
            }
        });

        buttonSend.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onOK();
            }
        });


        UserList.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    PrivateChatPanel UserPrivateChatPanel;
                    User usrtmp = (User) UserList.getSelectedValue();
                    if (WindowMap.getInstance().getById(usrtmp.GetID()) == null) {
                        UserPrivateChatPanel = new PrivateChatPanel(usrtmp);
                        WindowMap.getInstance().add(usrtmp.GetID(), UserPrivateChatPanel);
                    } else {
                        UserPrivateChatPanel = (PrivateChatPanel) WindowMap.getInstance().getById(usrtmp.GetID());
                    }
                    new Thread(UserPrivateChatPanel).start();
                }
            }
        });
// call onCancel() when cross is clicked
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                onCancel();
            }
        });

// call onCancel() on ESCAPE
        contentPane.registerKeyboardAction(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
            }
        }, KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0), JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
    }

    private void onOK() {
// add your code here
        String tmp = InputPane.getText() + "\n";
        try {
            myClientBackend.GenerateMsg(Msg.MsgType.GroupChat, myClientBackend.GetUser().GetID(), myGroup.getGroupID(), null, tmp, null);
            DisplayMsg(null);
        } catch (Exception e) {
            e.printStackTrace();
        }
//        dispose();
    }

    public synchronized void DisplayMsg(Msg mg) {
        StyledDocument doc;
        try {
            if (mg != null) {
                doc = ChatPane.getStyledDocument();
                doc.insertString(doc.getLength(), mg.GetDate().toString() + "\n", null);
                doc.insertString(doc.getLength(), mg.GetSendFrom() + ": ", null);
                doc.insertString(doc.getLength(), mg.GetContent().toString() + "\n", null);
            } else {
                doc = InputPane.getStyledDocument();
                int i = doc.getLength();
                doc.remove(0,i);
            }
        } catch (BadLocationException e) {
            e.printStackTrace();
        }
    }

    public void AddJList(java.util.List<User> Usr) {
        for (User tmp : Usr) {
            listModel.addElement(tmp);
        }
    }

    private void onCancel() {
// add your code here if necessary
        dispose();
    }

    public void run() {
//        GroupChatPanel dialog = new GroupChatPanel();
        this.pack();
        this.setVisible(true);
    }

    public static void main(String[] args) {
//        GroupChatPanel dialog = new GroupChatPanel();
//        dialog.pack();
//        dialog.setVisible(true);
    }

}
