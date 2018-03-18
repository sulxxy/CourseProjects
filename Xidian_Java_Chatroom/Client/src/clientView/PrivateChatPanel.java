package clientView;

import model.ClientBackend;
import model.Msg;
import model.User;

import javax.swing.*;
import javax.swing.text.BadLocationException;
import javax.swing.text.StyledDocument;
import java.awt.event.*;

public class PrivateChatPanel extends JFrame implements Runnable{
    private JPanel contentPane;
    private JButton buttonOK;
    private JButton buttonCancel;
    private JTextPane ChatPane;
    private JTextPane InputPane;
    private ClientBackend myClientBackend = ClientBackend.getClient();
    private User destUser;

    public PrivateChatPanel(User usr) {
        destUser = usr;
        setContentPane(contentPane);
        getRootPane().setDefaultButton(buttonOK);

        buttonOK.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onOK();
            }
        });

        buttonCancel.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                onCancel();
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
            Msg tmpmsg = myClientBackend.GenerateMsg(Msg.MsgType.PrivateChat, myClientBackend.GetUser().GetID(), destUser.GetID(), null, tmp, null);
            DisplayMsg(tmpmsg);
        } catch (Exception e) {
            e.printStackTrace();
        }
//        dispose();
    }

    public void DisplayMsg(Msg mg) {
//        System.out.println("PrivateCHatPanel.DIspose" + mg);
        StyledDocument doc = ChatPane.getStyledDocument();
        try {
            doc.insertString(doc.getLength(), mg.GetDate().toString() + "\n", null);
            doc.insertString(doc.getLength(), mg.GetSendFrom() + ": ", null);
            doc.insertString(doc.getLength(), mg.GetContent().toString() + "\n", null);
        } catch (BadLocationException e) {
            e.printStackTrace();
        }
    }
    private void onCancel() {
// add your code here if necessary
        dispose();
    }

    public void run(){
        pack();
        setVisible(true);

    }
    public static void main(String[] args) {
//        PrivateChatPanel dialog = new PrivateChatPanel();
//        dialog.pack();
//        dialog.setVisible(true);
    }
}
