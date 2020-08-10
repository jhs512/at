package com.sbs.jhs.at.dto;

import java.sql.Blob;
import java.util.Map;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class File {
	private int id;
	private String regDate;
	private String updateDate;
	private boolean delStatus;
	private String delDate;
	private String typeCode;
	private String type2Code;
	private String relTypeCode;
	private int relId;
	private String fileExtTypeCode;
	private String fileExtType2Code;
	private byte[] body;
	private int fileSize;
	private int fileNo;
	private String fileExt;
	private Map<String, Object> extra;
}
