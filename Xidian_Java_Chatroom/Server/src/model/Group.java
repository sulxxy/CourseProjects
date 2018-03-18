package model;

import java.io.Serializable;

/**
 * Created by lxxy on 2015/5/6.
 */
public class Group implements Serializable {
    private String GroupID;
    private String Admin;

    public Group(String id, String admin){
        GroupID = id;
        Admin = admin;
    }
    public String getGroupID() {
        return GroupID;
    }

    public String getAdmin() {
        return Admin;
    }
    public String toString(){
        return GroupID;
    }
}
