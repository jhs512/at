package com.sbs.jhs.at.dto;

import java.util.Map;

import org.springframework.web.util.HtmlUtils;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.sbs.jhs.at.util.Util;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Recruitment {
	private int id;
	private String regDate;
	private String updateDate;
	private boolean delStatus;
	private String delDate;
	private boolean displayStatus;
	private String title;
	private String body;
	private int memberId;
	private int jobId;
	private boolean completeStatus;
	private String completeDate;
	private int roleId;
	private String roleTypeCode;
	private Map<String, Object> extra;

	public String getDetailLink(String jobCode) {
		return "/usr/recruitment/actor-detail?id=" + id;
	}

	@JsonProperty("forPrintBody")
	public String getForPrintBody() {
		String bodyForPrint = HtmlUtils.htmlEscape(body);
		bodyForPrint = bodyForPrint.replace("\n", "<br>");

		return bodyForPrint;
	}

	@JsonProperty("forPrintTitle")
	public String getForPrintTitle() {
		if (this.title != null && this.title.length() > 0) {
			return HtmlUtils.htmlEscape(title);
		}

		String artworkName = "";
		if (extra != null) {
			artworkName = Util.ifNull(extra.get("artworkName"), "작품명x");
		}

		String directorName = "";
		if (extra != null) {
			directorName = Util.ifNull(extra.get("directorName"), "감독정보x");
		}

		String actingRoleName = "";
		if (extra != null) {
			actingRoleName = Util.ifNull(extra.get("actingRoleName"), "이름정보x");
		}

		String actingRoleGender = "";
		if (extra != null) {
			actingRoleGender = Util.ifNull(extra.get("actingRoleGender"), "성별정보x");
		}

		String actingRoleAge = "";
		if (extra != null) {
			actingRoleAge = Util.ifNull(extra.get("actingRoleAge"), "나이정보x");
		}

		String actingRoleJob = "";
		if (extra != null) {
			actingRoleJob = Util.ifNull(extra.get("actingRoleJob"), "직업정보x");
		}

		StringBuilder sb = new StringBuilder();
		sb.append(getForPrintCompleteStatusHanName("[", "]"));
		sb.append(" <span style='font-weight:bold;'>" + artworkName + "</span>");
		sb.append("(" + directorName + ")");
		sb.append("/<span style='font-weight:bold;'>" + actingRoleName + "</span>");
		sb.append("/" + actingRoleGender);
		sb.append("/" + actingRoleAge);
		sb.append("/" + actingRoleJob);

		return sb.toString();
	}

	public String getForPrintCompleteStatusHanName() {
		return getForPrintCompleteStatusHanName("", "");
	}

	public String getForPrintCompleteStatusHanName(String wrapBefore, String wrapAfter) {
		return completeStatus
				? "<span style='color:red; font-weight:bold;'>" + wrapBefore + "모집완료" + wrapAfter + "</span>"
				: "<span style='color:green; font-weight:bold;'>" + wrapBefore + "모집중" + wrapAfter + "</span>";
	}
}
