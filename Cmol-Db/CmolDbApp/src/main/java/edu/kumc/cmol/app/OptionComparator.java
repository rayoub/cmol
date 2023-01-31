package edu.kumc.cmol.app;

import java.util.Comparator;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.cli.Option;

public class OptionComparator implements Comparator<Option> {
 
    private static final Map<String, Integer> _map = new HashMap<String, Integer>();
    
    static {
        _map.put("g",1);
        _map.put("i",2);
        _map.put("c",3);
        _map.put("t",4);
        _map.put("n",5);
        _map.put("d",6);
        _map.put("?",7);
    }

    public int compare(Option x, Option y) {
        return Integer.compare(_map.get(x.getOpt()), _map.get(y.getOpt()));
    }
}
