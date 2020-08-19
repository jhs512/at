package com.sbs.jhs.at.dto;

import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class ActingRole {
	private int id;
	private String regDate;
	private String updateDate;
	private String artworkId;
	private String realName;
	private String name;
	private String pay;
	private String age;
	private boolean scriptStatus;
	private String gender;
	private int scenesCount;
	private int shootingsCount;
	private String character;
	private String etc;
	private Map<String, Object> extra;
	
	public String getTitle() {
		String artworkName = extra != null ? (String)extra.get("artworkName") : "";
		String directorName = extra != null ? (String)extra.get("directorName") : "";
		
		String title = artworkName + "(" + directorName + "감독), " + name + "역";
		
		return title;
	}
}
