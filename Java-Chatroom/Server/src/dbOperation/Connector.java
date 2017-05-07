package dbOperation;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.*;
import model.User.Status;

public class Connector {
    private final String url = "jdbc:mysql://localhost:3306/chatroom?"
            + "user=root&password=111222&useUnicode=true&characterEncoding=UTF8";
    private Connection conn = null;
    private String sql;
    private static Connector DBInstance = new Connector();
    private final String UserTableName = "User";
    private final String UserGroupTableName = "UserGroup";
    private final String MsgTableName = "Msg";
    private Statement stmt;
    private ResultSet rs;

    private Connector() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url);
            if (!conn.isClosed()) {
                System.out
                        .println("Connector.Connector:DB connection established");
            }
            stmt = conn.createStatement();
        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    public static Connector GetConnector() {
        return DBInstance;
    }

    @SuppressWarnings("finally")
    public User QueryByID(String id) {
        sql = "select * from " + UserTableName + " where ID='" + id + "';";
        try {
            rs = stmt.executeQuery(sql);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return GetQueryUserTypeResult(rs).get(0);

    }

    public List<User> GetAllUserID(/*String groupID*/) {
        sql = "select * from " + UserTableName;
        try {
            rs = stmt.executeQuery(sql);
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return GetQueryUserTypeResult(rs);
    }

    public boolean ValidateUser(String id, String pwd) {
        sql = "select * from " + UserTableName + " where ID='" + id
                + "' and Password='" + pwd + "';";
        try {
            rs = stmt.executeQuery(sql);
            if (!rs.next()) {
                System.out.println("Connector.ValidateUser: Validation error");
                return false;
            }
            return true;
        } catch (SQLException e) {
            // TODO: handle exception
            e.printStackTrace();
            return false;
        }
    }

    public boolean isUserIDValid(String id) {
        sql = "select * from " + UserTableName + " where ID='" + id + "'";
        try {
            rs = stmt.executeQuery(sql);
            if (!rs.next()) {
                System.out.println("Connector.isUserIDValid: There is no such ID: " + id);
                return false;
            } else {
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void SetUserState(String id, User.Status status) {
        sql = "update " + UserTableName + " set State='"
                + status.toString() + "' where ID='" + id + "'";
        System.out.println(sql);
        try {
            stmt.executeUpdate(sql);
        }catch (SQLException e){
            e.printStackTrace();
        }
    }

    public boolean InsertUser(String id, String pwd, String gender) {
        sql = "insert into " + UserTableName + "(ID,password,gender) "
                + "values('" + id + "', '" + pwd + "', '" + gender + "')";
        try {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            // TODO: handle exception
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public boolean RemoveUser(String id) {
        sql = "delete from " + UserTableName + " where ID='" + id + "'";
        try {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            // TODO: handle exception
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public boolean CloseConnection() {
        /*
         * TODO
		 */
        return true;
    }

    public void WriteMsg(Msg m) {
        String tmp = m.GetContent().toString();
        tmp = tmp.substring(0, tmp.length() - 1);
        sql = "insert into msg value('" + m.GetMsgType() + "','"
                + m.GetSendFrom() + "', '" + m.GetSendTo() + "', '"
                + tmp + "', '" + m.GetDate() + "')";
        System.out.println(sql);
        try {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void removeOfflineMsg(Msg mg) {
        sql = "delete from " + MsgTableName
                + " where SendFrom='"
                + mg.GetSendFrom()
                + "' and SendTo='"
                + mg.GetSendTo()
                + "' and Content='"
                + mg.GetContent()
                + "' and Date='"
                + mg.GetDate()
                + "'";
        System.out.println(sql);
        try {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Msg> CheckMsg(String id) {
        sql = "select * from " + MsgTableName + " where SendTo='" + id + "'";
        try {
            rs = stmt.executeQuery(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return GetQueryMsgResult(rs);
    }

    public List<Group> GetAllGroup(String id) {
        sql = "select * from " + UserGroupTableName + " where UserID='" + id + "'";
        try {
            rs = stmt.executeQuery(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return GetQueryGroupTypeResult(rs);
    }

    @SuppressWarnings("finally")
    private List<Msg> GetQueryMsgResult(ResultSet res) {
        List<Msg> tmp = new ArrayList<Msg>();
        try {
            while (res.next()) {
                Msg tmpMsg = new Msg(Enum.valueOf(Msg.MsgType.class, res.getString("MsgType")),
                        res.getString("SendFrom"),
                        res.getString("SendTo"),
                        res.getTimestamp("Date"),
                        res.getString("Content"));
                tmp.add(tmpMsg);
            }
            res.close();
            for (Msg tmpmsg : tmp) {
                removeOfflineMsg(tmpmsg);
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            return tmp;
        }
    }

    @SuppressWarnings("finally")
    private List<User> GetQueryUserTypeResult(ResultSet res) {
        List<User> tmp = new ArrayList<User>();
        try {
            while (res.next()) {
                User tmpusr = new User(res.getString(1), res.getString(2),
                        res.getString(3), res.getString(4), res.getString(5));
                tmp.add(tmpusr);
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            return tmp;
        }
    }

    @SuppressWarnings("finally")
    private List<Group> GetQueryGroupTypeResult(ResultSet res) {
        List<Group> tmp = new ArrayList<Group>();
        try {
            while (res.next()) {
//                Group.Status statustmp = Group.Status.Depature;
//                statustmp = Enum.valueOf(Group.Status.class, res.getString(5));
                Group tmpusr = new Group(res.getString(2), res.getString(1));
                tmp.add(tmpusr);
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } finally {
            return tmp;
        }
    }
}
