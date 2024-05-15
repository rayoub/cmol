package edu.kumc.cmol.app;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.cli.Option;

public class OptionComparator implements Comparator<Option> {
 
    private static final Map<String, Integer> _map = new HashMap<String, Integer>();
    
    static {
        _map.put("a",1);
        _map.put("q",2);
        _map.put("r",3);
        _map.put("s",4);
        _map.put("i",5);
        _map.put("j",6);
        _map.put("k",7);
        _map.put("d",8);
        _map.put("?",9);
    }

    public int compare(Option x, Option y) {
        return Integer.compare(_map.get(x.getOpt()), _map.get(y.getOpt()));
    }
}
