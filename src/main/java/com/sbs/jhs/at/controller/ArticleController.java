package com.sbs.jhs.at.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sbs.jhs.at.service.ArticleService;

@Controller
public class ArticleController {
	@Autowired
	private ArticleService articleService;
	
	@RequestMapping("/article/list")
	public String showList() {
		int count = articleService.getCount();
		System.out.println(count);
		
		return "article/list";
	}
}
