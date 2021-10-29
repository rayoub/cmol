package edu.kumc.qci.app;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.cli.Option;

public class OptionComparator implements Comparator<Option> {
 
    private static final Map<String, Integer> _map = new HashMap<String, Integer>();

    // build -
    // 1. truncate tables
    // 2. get xmls we don't already have 
    // 3. import into tables
    
    // update
    // 1. get xmls we don't already have 
    // 2. import into tables
    
    static {
        _map.put("g",1);
        _map.put("i",2);
        _map.put("c",3);
        _map.put("d",4);
        _map.put("?",5);
    }

    public int compare(Option x, Option y) {
        return Integer.compare(_map.get(x.getOpt()), _map.get(y.getOpt()));
    }
}
