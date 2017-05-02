package testClient;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import model.ClientBackend;
import clientView.Login;


public class Test {
    public static void main(String[] args) throws Exception {
        ClientBackend myClient = ClientBackend.getClient();
        Login lg = Login.getLgView();
        lg.setVisible(true);
    }

}
