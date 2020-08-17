package com.sbs.jhs.at.config;

public class AppConfig {
	public String getAttachmentFileExtTypeCode(String relTypeCode, int fileNo) {
		if (fileNo > 2) {
			return "img";
		}

		return "video";
	}

	public String getAttachmentFileExtTypeDisplayName(String relTypeCode, int fileNo) {
		String fileExtTypeCode = getAttachmentFileExtTypeCode(relTypeCode, fileNo);

		switch (fileExtTypeCode) {
		case "img":
			return "이미지";
		default:
			return "비디오";
		}
	}

	public String getAttachemntFileInputAccept(String relTypeCode, int fileNo) {
		String fileExtTypeCode = getAttachmentFileExtTypeCode(relTypeCode, fileNo);

		switch (fileExtTypeCode) {
		case "img":
			return "image/gif,image/jpeg,image/png";
		default:
			return "video/mp4,video/quicktime";
		}
	}

}