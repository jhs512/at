package com.sbs.jhs.at.controller.adm;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sbs.jhs.at.dto.ActingRole;
import com.sbs.jhs.at.dto.Artwork;
import com.sbs.jhs.at.service.ActingRoleService;

@Controller
public class ActingRoleController {
	@Autowired
	private ActingRoleService actingRoleService;

	@RequestMapping("/adm/actingRole/list")
	public String showList(Model model) {
		List<ActingRole> actingRoles = actingRoleService.getForPrintRoles();

		model.addAttribute("actingRoles", actingRoles);

		return "adm/actingRole/list";
	}
	
	@RequestMapping("/adm/actingRole/write")
	public String showWrite(Model model) {
		List<Artwork> artworks = actingRoleService.getArtworks();
		
		model.addAttribute("artworks", artworks);
		
		return "adm/actingRole/write";
	}
}
