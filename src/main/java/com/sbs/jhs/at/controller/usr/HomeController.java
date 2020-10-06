package com.sbs.jhs.at.controller.usr;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	@RequestMapping("/usr/home/main")
	public String showMain() {
	    return "redirect:/usr/recruitment/actor-list";
	}
	
	@RequestMapping("/")
	public String showIndex() {
		return "usr/home/main";
	}
}
