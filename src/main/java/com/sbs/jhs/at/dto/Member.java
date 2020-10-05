package com.sbs.jhs.at.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Member {
	private int id;
	private String regDate;
	private String updateDate;
	private boolean delStatus;
	private String delDate;
	private boolean authStatus;
	private String loginId;
	
	@JsonIgnore
	private String loginPw;
	private String name;
	private String nickname;
	private String email;
	private String cellphoneNo;
}
