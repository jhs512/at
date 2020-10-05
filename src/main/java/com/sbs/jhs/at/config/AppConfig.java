package com.sbs.jhs.at.config;

import org.springframework.stereotype.Component;

import com.sbs.jhs.at.dto.Member;

@Component
public class AppConfig {
	public int getMaxAttachmentFileNo(String relTypeCode) {
		return 10;
	}

	public int getForUploadMaxAttachmentFileNo(String relTypeCode) {
		switch (relTypeCode) {
		case "applyment":
			return 1;
		default:
			return 3;
		}
	}

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
			return "video/mp4,video/quicktime,video/x-msvideo";
		}
	}

	public boolean actorCanWrite(String relTypeCode, Member actor) {
		switch (relTypeCode) {
		case "recruitment":
			return actor.getId() == 1 || actor.getId() == 2;
		}

		return false;
	}

	public String getAttachmentFileInputDisplayName(String relTypeCode, int fileNo) {
		switch (relTypeCode) {
		case "applyment":
			if (fileNo == 1) {
				return "해당 배역 1분 연기";
			}
			break;
		}

		String name = "첨부 " + fileNo + " " + getAttachmentFileExtTypeDisplayName(relTypeCode, fileNo);

		return name;
	}

	public int getModifyAvailablePeriodSeconds() {
		return 60 * 60 * 1;
	}

	public int getModifyAvailablePerioMinutes() {
		return getModifyAvailablePeriodSeconds() / 60;
	}

}