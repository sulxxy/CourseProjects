package model;

import javax.swing.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by lxxy on 2015/5/4.
 */

public class WindowMap {
    private HashMap<String, JFrame> map;
    private static WindowMap instance = new WindowMap();

    private WindowMap() {
        map = new HashMap<String, JFrame>();
    }

    public synchronized static WindowMap getInstance() {
        return instance;
    }

    public synchronized void add(String id, JFrame window) {
        if (this.getById(id) == null)
            map.put(id, window);
    }

    public synchronized void remove(String id) {
        map.remove(id);
    }

    public synchronized JFrame getById(String id) {
        return map.get(id);
    }

    public synchronized List<JFrame> getAllSocketThread() {
        List<JFrame> list = new ArrayList<JFrame>();
        for (Map.Entry<String, JFrame> entry : map.entrySet()) {
            list.add(entry.getValue());
        }
        return list;
    }

    public synchronized List<String> getAllUser() {
        List<String> list = new ArrayList<String>();
        for (Map.Entry<String, JFrame> entry : map.entrySet()) {
            list.add(entry.getKey());
        }
        return list;
    }
}