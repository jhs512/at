package com.sbs.jhs.at.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ResultData {
	private String resultCode;
	private String msg;
	private Object body;

	public ResultData(String resultCode, String msg) {
		this(resultCode, msg, null);
	}
}
