package serverview;
import javax.swing.*;

import java.awt.*;
import java.awt.event.*;

import javax.swing.SwingConstants;

public class Login extends JFrame implements ActionListener{
	private static final int FrameWidth = 300;
	private static final int FrameHeight = 200;
	private static final int ButtonWidth = 90, ButtonHeight = 40;
	private static final int TextWidth = 130, TextHeight = 20;
	private Container ContentPane;
	private JPanel Canvas1, Canvas2, Canvas3;
	private JButton OkButton, CancelButton;
	private JTextField UserId;
	private JPasswordField Password;
	private JLabel IDLabel;
	private JLabel PwdLabel;
	public Login(){
		setSize(FrameWidth, FrameHeight);
		setLayout(new BorderLayout());
//		Canvas1 = new JPanel();
//		Canvas1.add(new JButton("North"));
//		add(Canvas1, BorderLayout.NORTH);
		ContentPane = getContentPane();
		Canvas1 = new JPanel();
		OkButton = new JButton("SignIn");
//		OkButton.setBounds(0, 0, ButtonWidth, ButtonHeight);
		OkButton.addActionListener(this);
		CancelButton = new JButton("Cancel");
//		CancelButton.setBounds(0, 0, ButtonWidth, ButtonHeight);
		CancelButton.addActionListener(this);
		Canvas1.add(OkButton);
		Canvas1.add(CancelButton);
		ContentPane.add(Canvas1, BorderLayout.SOUTH);
		
		Canvas2 = new JPanel();
		Canvas2.setLayout(new BorderLayout());
		IDLabel = new JLabel("UserID:", JLabel.LEFT);
		PwdLabel = new JLabel("Password: ", JLabel.LEFT);
		Container LabelContainer = new Container();
		Box LabelLayout = Box.createVerticalBox();
//		LabelLayout.set;
		LabelContainer.add(LabelLayout);
		LabelLayout.add(IDLabel);
		LabelLayout.add(PwdLabel);
//		Password.setBounds(50, 70, TextWidth, TextHeight);
//		UserId.setBounds(50, 50, TextWidth, TextHeight);
//		Canvas2.add(IDLabelField, BorderLayout.CENTER);
		Canvas2.add(LabelLayout);
		ContentPane.add(Canvas2, BorderLayout.WEST);

		UserId = new JTextField();
		Password = new JPasswordField();
		Password.setBounds(50, 70, TextWidth, TextHeight);
		UserId.setBounds(50, 30, TextWidth, TextHeight);
		Canvas3 = new JPanel();
		Canvas3.setLayout(null);
		Container TextFieldContainer = new Container();
		Box TextFieldLayout = Box.createVerticalBox();
		TextFieldContainer.add(TextFieldLayout);
		TextFieldLayout.add(UserId);
		TextFieldLayout.add(Password);
//		Canvas2.add(IDLabelField, BorderLayout.CENTER);
		Canvas3.add(TextFieldLayout);
		ContentPane.add(Canvas3, BorderLayout.CENTER);

		setResizable(true);
		setVisible(true);
		
	}
	
	@SuppressWarnings("deprecation")
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		JButton ClickButton = (JButton)e.getSource();
		if(ClickButton == OkButton){
			setTitle(UserId.getText());
		}
		else{
			setTitle(Password.getText());
		}
		
	}
	
	public static void main(String[] args){
		Login lg = new Login();
	}
}
