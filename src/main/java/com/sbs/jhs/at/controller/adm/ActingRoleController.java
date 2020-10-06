package com.sbs.jhs.at.controller.adm;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dto.ActingRole;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.Artwork;
import com.sbs.jhs.at.dto.Board;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.service.ActingRoleService;
import com.sbs.jhs.at.util.Util;

@Controller
public class ActingRoleController {
	@Autowired
	private ActingRoleService actingRoleService;
	
	@RequestMapping("/adm/actingRole/artworkList")
	public String showArtworkList(Model model) {
		List<Artwork> artworks = actingRoleService.getArtworks();

		model.addAttribute("artworks", artworks);

		return "adm/actingRole/artworkList";
	}
	
	@RequestMapping("/adm/actingRole/writeArtwork")
	public String showWriteArtwork(Model model) {
		return "adm/actingRole/writeArtwork";
	}
	
	@RequestMapping("/adm/actingRole/doWriteArtwork")
	public String doWriteArtwork(@RequestParam Map<String, Object> param, HttpServletRequest req, Model model) {
		Map<String, Object> newParam = Util.getNewMapOf(param, "name", "productionName", "directorName", "etc");
		int newArtworkId = actingRoleService.writeArtwork(newParam);

		String redirectUri = (String) param.get("redirectUri");
		redirectUri = redirectUri.replace("#id", newArtworkId + "");

		return "redirect:" + redirectUri;
	}
	
	@RequestMapping("/adm/actingRole/detailArtwork")
	public String showDetailArtwork(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req, String listUrl) {
		if ( listUrl == null ) {
			listUrl = "./artworkList";
		}
		model.addAttribute("listUrl", listUrl);
				
		int id = Integer.parseInt((String) param.get("id"));

		Member loginedMember = (Member)req.getAttribute("loginedMember");
		Artwork artwork = actingRoleService.getForPrintArtworkById(loginedMember, id);

		model.addAttribute("artwork", artwork);

		return "adm/actingRole/detailArtwork";
	}
	
	@RequestMapping("/adm/actingRole/modifyArtwork")
	public String showModifyArtwork(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req, String listUrl) {
		if ( listUrl == null ) {
			listUrl = "./list";
		}
		model.addAttribute("listUrl", listUrl);
				
		int id = Integer.parseInt((String) param.get("id"));

		Member loginedMember = (Member)req.getAttribute("loginedMember");
		Artwork artwork = actingRoleService.getForPrintArtworkById(loginedMember, id);

		model.addAttribute("artwork", artwork);

		return "adm/actingRole/modifyArtwork";
	}
	
	@RequestMapping("/adm/actingRole/doModifyArtwork")
	public String doModifyArtwork(@RequestParam Map<String, Object> param, HttpServletRequest req, Model model) {
		Map<String, Object> newParam = Util.getNewMapOf(param, "id", "name", "productionName", "directorName", "etc");
		actingRoleService.modifyArtwork(newParam);

		String redirectUri = (String) param.get("redirectUri");
		
		return "redirect:" + redirectUri;
	}
	
	@RequestMapping("/adm/actingRole/doDeleteArtwork")
	public String doModifyArtwork(int id, String listUrl) {
		actingRoleService.deleteArtwork(id);

		return "redirect:" + listUrl;
	}

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
	
	@RequestMapping("/adm/actingRole/doWrite")
	public String doWrite(@RequestParam Map<String, Object> param, HttpServletRequest req, Model model) {
		Map<String, Object> newParam = Util.getNewMapOf(param, "artworkId", "name", "age", "gender", "character", "scenesCount", "scriptStatus", "auditionStatus", "shootingsCount", "etc");
		int newActingRoleId = actingRoleService.write(newParam);

		String redirectUri = (String) param.get("redirectUri");
		redirectUri = redirectUri.replace("#id", newActingRoleId + "");

		return "redirect:" + redirectUri;
	}
	
	@RequestMapping("/adm/actingRole/doModify")
	public String doModify(@RequestParam Map<String, Object> param, HttpServletRequest req, Model model) {
		Map<String, Object> newParam = Util.getNewMapOf(param, "id", "artworkId", "name", "age", "gender", "character", "scenesCount", "scriptStatus", "auditionStatus", "shootingsCount", "etc");
		actingRoleService.modify(newParam);

		String redirectUri = (String) param.get("redirectUri");
		
		return "redirect:" + redirectUri;
	}
	
	@RequestMapping("/adm/actingRole/doDelete")
	public String doModify(int id, String listUrl) {
		actingRoleService.delete(id);

		return "redirect:" + listUrl;
	}
	
	@RequestMapping("/adm/actingRole/detail")
	public String showDetail(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req, String listUrl) {
		if ( listUrl == null ) {
			listUrl = "./list";
		}
		model.addAttribute("listUrl", listUrl);
				
		int id = Integer.parseInt((String) param.get("id"));
		
		Member loginedMember = (Member)req.getAttribute("loginedMember");

		ActingRole actingRole = actingRoleService.getForPrintActingRoleById(loginedMember, id);

		model.addAttribute("actingRole", actingRole);

		return "adm/actingRole/detail";
	}
	
	@RequestMapping("/adm/actingRole/modify")
	public String showModify(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req, String listUrl) {
		if ( listUrl == null ) {
			listUrl = "./list";
		}
		model.addAttribute("listUrl", listUrl);
				
		int id = Integer.parseInt((String) param.get("id"));
		
		Member loginedMember = (Member)req.getAttribute("loginedMember");

		ActingRole actingRole = actingRoleService.getForPrintActingRoleById(loginedMember, id);

		model.addAttribute("actingRole", actingRole);

		return "adm/actingRole/modify";
	}
}
