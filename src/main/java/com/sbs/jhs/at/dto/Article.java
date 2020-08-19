package com.sbs.jhs.at.dto;

import java.util.Map;

import org.springframework.web.util.HtmlUtils;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Article {
	private int id;
	private String regDate;
	private String updateDate;
	private boolean delStatus;
	private String delDate;
	private boolean displayStatus;
	private String title;
	private String body;
	private int memberId;
	private int boardId;
	private Map<String, Object> extra;

	@JsonProperty("forPrintBody")
	public String getForPrintBody() {
		String bodyForPrint = HtmlUtils.htmlEscape(body);
		bodyForPrint = bodyForPrint.replace("\n", "<br>");

		return bodyForPrint;
	}

	@JsonProperty("forPrintTitle")
	public String getForPrintTitle() {
		String titleForPrint = HtmlUtils.htmlEscape(title);
	
		return titleForPrint;
	}

	public String getDetailLink(String boardCode) {
		return "/usr/article/" + boardCode + "-detail?id=" + id;
	}
}
