package com.sbs.jhs.at.dto;

import java.util.Map;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@AllArgsConstructor
@NoArgsConstructor
@Data
@ToString(exclude = "body")
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
	private int fileSize;
	private int fileNo;
	private String fileExt;
	private String fileDir;
	private String originFileName;
	private Map<String, Object> extra;
	
	@JsonIgnore
	public String getFilePath(String genFileDirPath) {
		return genFileDirPath + getBaseFileUri();
	}
	
	@JsonIgnore
	public String getBaseFileUri() {
		return "/" + relTypeCode + "/" + fileDir + "/" + getFileName();
	}

	private String getFileName() {
		return id + "." + fileExt;
	}
	
	public String getForPrintGenUrl() {
		return "/gen" + getBaseFileUri() + "?updateDate=" + updateDate;
	}
}
