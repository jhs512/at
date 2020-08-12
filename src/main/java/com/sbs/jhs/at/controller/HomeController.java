package com.sbs.jhs.at.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	@Autowired
	@RequestMapping("/usr/home/main")
	public String showMain() {
		return "home/main";
	}
}
