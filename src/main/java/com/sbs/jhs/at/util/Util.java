package com.sbs.jhs.at.util;

import java.math.BigInteger;
import java.util.HashMap;
import java.util.Map;

public class Util {
	public static int getAsInt(Object object) {
		if (object instanceof BigInteger) {
			return ((BigInteger) object).intValue();
		} else if (object instanceof Long) {
			return (int) object;
		} else if (object instanceof Integer) {
			return (int) object;
		} else if (object instanceof String) {
			return Integer.parseInt((String) object);
		}

		return -1;
	}

	public static Map<String, Object> getNewMapOf(Map<String, Object> oldMap, String... keys) {
		Map<String, Object> newMap = new HashMap<>();
		
		for ( String key : keys ) {
			newMap.put(key, oldMap.get(key));
		}
		
		return newMap;
	}

}
