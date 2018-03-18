package clientView;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JButton;
import javax.swing.JTextField;
import javax.swing.JPasswordField;
import javax.swing.JLabel;

import model.ClientBackend;
import model.Msg;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Color;
import javax.swing.UIManager;
import java.awt.SystemColor;

public class Login extends JFrame implements ActionListener {

    private JPanel contentPane;
    private JTextField textField;
    private JPasswordField passwordField;
    private JButton CancelButton;
    private JButton SignInButton;
    private ClientBackend myclientbackend = ClientBackend.getClient();
    private static Login lgView = new Login();

    /**
     * Launch the application.
     */
    // public static void main(String[] args) {
    // EventQueue.invokeLater(new Runnable() {
    // public void run() {
    // try {
    // Login frame = new Login();
    // frame.setVisible(true);
    // } catch (Exception e) {
    // e.printStackTrace();
    // }
    // }
    // });
    // }

    /**
     * Create the frame.
     */
    private Login() {
        setBackground(SystemColor.controlHighlight);
        setForeground(Color.WHITE);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 404, 289);
        contentPane = new JPanel();
        contentPane.setBackground(SystemColor.controlHighlight);
        contentPane.setForeground(Color.WHITE);
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(null);

        CancelButton = new JButton("Cancel");
        // btnNewButton.addActionListener(new ActionListener() {
        // public void actionPerformed(ActionEvent e) {
        // }
        // });
        CancelButton.addActionListener(this);
        CancelButton.setBounds(47, 188, 105, 25);
        contentPane.add(CancelButton);

        SignInButton = new JButton("Sign In");
        SignInButton.setBounds(249, 188, 105, 25);
        SignInButton.addActionListener(this);
        contentPane.add(SignInButton);

        textField = new JTextField();
        textField.setBounds(135, 90, 117, 19);
        contentPane.add(textField);
        textField.setColumns(10);

        passwordField = new JPasswordField();
        passwordField.setBounds(135, 121, 117, 19);
        contentPane.add(passwordField);

        JLabel UserIDLabel = new JLabel("UserID: ");
        UserIDLabel.setBounds(47, 92, 70, 15);
        contentPane.add(UserIDLabel);

        JLabel PWDLabel = new JLabel("Password: ");
        PWDLabel.setBounds(47, 123, 105, 15);
        contentPane.add(PWDLabel);
    }

    public static Login getLgView() {
        return lgView;
    }

    @SuppressWarnings("deprecation")
    @Override
    public void actionPerformed(ActionEvent e) {
        // TODO Auto-generated method stub
        JButton clickButton = (JButton) e.getSource();
        if (CancelButton == clickButton) {
            System.exit(0);
        } else {
            // TODO: Send "Sign in" request to the server.
            try {
                myclientbackend.GenerateMsg(
                        Msg.MsgType.SignIn.toString(), textField.getText(),                 //Modify to SignIn
                        null, null, null, passwordField.getText());
            } catch (Exception e1) {
                // TODO Auto-generated catch block
                e1.printStackTrace();
            }
            // setTitle(passwordField.getText());
        }
    }
}
