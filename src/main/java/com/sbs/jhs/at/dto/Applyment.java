package com.sbs.jhs.at.dto;

import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Applyment {
	private int id;
	private String regDate;
	private String updateDate;
	private boolean delStatus;
	private String delDate;
	private boolean displayStatus;
	private boolean hideStatus;
	private int relId;
	private String relTypeCode;
	private int memberId;
	private String body;
	private Map<String, Object> extra;
}
