package com.sbs.jhs.at.dto;

import java.util.LinkedHashMap;
import java.util.Map;

import lombok.Data;

@Data
public class ResultData {
	private String resultCode;
	private String msg;
	private Object body;

	public ResultData(String resultCode, String msg) {
		this(resultCode, msg, null);
	}

	public ResultData(String resultCode, String msg, Object body) {
		this.resultCode = resultCode;
		this.msg = msg;
		this.body = body;
	}

	public boolean isFail() {
		return isSuccess() == false;
	}

	public boolean isSuccess() {
		return resultCode.startsWith("S-");
	}

	public ResultData(String resultCode, String msg, String bodyParam1Key, String bodyParam1Value) {
		this(resultCode, msg, bodyParam1Key, bodyParam1Value, null, null);
	}

	public ResultData(String resultCode, String msg, String bodyParam1Key, String bodyParam1Value, String bodyParam2Key,
			String bodyParam2Value) {
		this(resultCode, msg, bodyParam1Key, bodyParam1Value, bodyParam2Key, bodyParam2Value, null, null);
	}

	public ResultData(String resultCode, String msg, String bodyParam1Key, String bodyParam1Value, String bodyParam2Key,
			String bodyParam2Value, String bodyParam3Key, String bodyParam3Value) {
		this(resultCode, msg, bodyParam1Key, bodyParam1Value, bodyParam2Key, bodyParam2Value, bodyParam3Key,
				bodyParam3Value, null, null);
	}

	public ResultData(String resultCode, String msg, String bodyParam1Key, String bodyParam1Value, String bodyParam2Key,
			String bodyParam2Value, String bodyParam3Key, String bodyParam3Value, String bodyParam4Key,
			String bodyParam4Value) {
		this(resultCode, msg);

		Map<String, Object> body = new LinkedHashMap<>();

		if (bodyParam1Key != null) {
			body.put(bodyParam1Key, bodyParam1Value);
		}

		if (bodyParam2Key != null) {
			body.put(bodyParam2Key, bodyParam2Value);
		}

		if (bodyParam3Key != null) {
			body.put(bodyParam3Key, bodyParam3Value);
		}

		if (bodyParam4Key != null) {
			body.put(bodyParam4Key, bodyParam4Value);
		}

		if (body.isEmpty() == false) {
			this.body = body;
		}
	}
}
