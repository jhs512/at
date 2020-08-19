package com.sbs.jhs.at.dto;

import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Artwork {
	private int id;
	private String regDate;
	private String updateDate;
	private String name;
	private String directorName;
	private String productionName;
	private String etc;
	private Map<String, Object> extra;
}
