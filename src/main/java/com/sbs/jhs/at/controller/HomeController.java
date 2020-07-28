package com.sbs.jhs.at.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

// boolean, char, byte, short, int, long, float, double
// int[]
// Article
// Map
// List<Integer>
// List<Array>

@Controller
public class HomeController {
	@RequestMapping("/home/boolean")
	@ResponseBody
	public boolean showBoolean() {
		return false;
	}

	@RequestMapping("/home/char")
	@ResponseBody
	public char showChar() {
		return '갉';
	}

	@RequestMapping("/home/byte")
	@ResponseBody
	public byte showByte() {
		return 127;
	}

	@RequestMapping("/home/short")
	@ResponseBody
	public short showShort() {
		return 32767;
	}

	@RequestMapping("/home/int")
	@ResponseBody
	public int showInt() {
		return Integer.MAX_VALUE;
	}

	@RequestMapping("/home/long")
	@ResponseBody
	public long showLong() {
		return Long.MAX_VALUE;
	}

	@RequestMapping("/home/float")
	@ResponseBody
	public float showFloat() {
		return 3.14f;
	}

	@RequestMapping("/home/double")
	@ResponseBody
	public double showDouble() {
		return Math.PI;
	}

	@RequestMapping("/home/intArr")
	@ResponseBody
	public int[] showIntArr() {
		int[] arr = new int[10];
		arr[0] = 10;
		arr[1] = 20;
		arr[2] = 30;

		return arr;
	}

	@RequestMapping("/home/intList")
	@ResponseBody
	public List<Integer> showIntList() {
		List<Integer> list = new ArrayList<>();
		list.add(10);
		list.add(20);
		list.add(30);
		return list;
	}

	@RequestMapping("/home/article")
	@ResponseBody
	public Article showArticle() {
		System.out.println(new Article(1, "2020-07-28 12:12:12", "제목", "내용"));
		return new Article(1, "2020-07-28 12:12:12", "제목", "내용");
	}
	
	@RequestMapping("/home/articleList")
	@ResponseBody
	public List<Article> showArticleList() {
		List<Article> list = new ArrayList<>();
		list.add(new Article(1, "2020-07-28 12:12:12", "제목1", "내용1"));
		list.add(new Article(2, "2020-07-28 13:12:12", "제목2", "내용2"));
		return list;
	}
	
	@RequestMapping("/home/map")
	@ResponseBody
	public Map<String, Object> showMap() {
		Map<String, Object> map = new HashMap<>();
		map.put("철수나이", 12);
		map.put("영희나이", 12);
		map.put("영수나이", 12);
		map.put("게시물", new Article(2, "2020-07-28 13:12:12", "제목2", "내용2"));
		
		return map;
	}
}

@NoArgsConstructor
@AllArgsConstructor
@Data
class Article {
	private int id;
	private String regDate;
	private String title;
	private String body;
}
