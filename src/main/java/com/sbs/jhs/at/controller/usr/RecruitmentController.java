package com.sbs.jhs.at.controller.usr;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.config.AppConfig;
import com.sbs.jhs.at.dto.ActingRole;
import com.sbs.jhs.at.dto.Job;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.Recruitment;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.service.ActingRoleService;
import com.sbs.jhs.at.service.RecruitmentService;
import com.sbs.jhs.at.util.Util;

@Controller
public class RecruitmentController {
	@Autowired
	private RecruitmentService recruitmentService;
	@Autowired
	private AppConfig appConfig;
	@Autowired
	private ActingRoleService actingRoleService;

	@RequestMapping("/usr/recruitment/{jobCode}-list")
	public String showList(Model model, @PathVariable("jobCode") String jobCode, HttpServletRequest req) {
		Job job = recruitmentService.getJobByCode(jobCode);
		model.addAttribute("job", job);

		Member loginedMember = (Member) req.getAttribute("loginedMember");
		model.addAttribute("actorCanWrite", appConfig.actorCanWrite("usr/recruitment", loginedMember));

		List<Recruitment> recruitments = recruitmentService.getForPrintRecruitments();

		model.addAttribute("usr/recruitments", recruitments);

		return "usr/recruitment/list";
	}

	@RequestMapping("/usr/recruitment/{jobCode}-detail")
	public String showDetail(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req,
			@PathVariable("jobCode") String jobCode, String listUrl) {
		if (listUrl == null) {
			listUrl = "./" + jobCode + "-list";
		}
		model.addAttribute("listUrl", listUrl);

		Job job = recruitmentService.getJobByCode(jobCode);
		model.addAttribute("job", job);

		int id = Integer.parseInt((String) param.get("id"));

		Member loginedMember = (Member) req.getAttribute("loginedMember");

		Recruitment recruitment = recruitmentService.getForPrintRecruitmentById(loginedMember, id);

		model.addAttribute("usr/recruitment", recruitment);

		boolean actorIsWriter = recruitment.getMemberId() == loginedMember.getId();
		model.addAttribute("needToLoadMore", actorIsWriter);
		model.addAttribute("needToShowApplymentWriteForm", !actorIsWriter);
		model.addAttribute("actorIsWriter", actorIsWriter);

		return "usr/recruitment/detail";
	}

	@RequestMapping("/usr/recruitment/{jobCode}-modify")
	public String showModify(Model model, @RequestParam Map<String, Object> param, HttpServletRequest req,
			@PathVariable("jobCode") String jobCode, String listUrl) {
		model.addAttribute("listUrl", listUrl);

		Job job = recruitmentService.getJobByCode(jobCode);
		model.addAttribute("job", job);

		List<ActingRole> roles = actingRoleService.getRoles();
		model.addAttribute("roles", roles);

		int id = Integer.parseInt((String) param.get("id"));

		Member loginedMember = (Member) req.getAttribute("loginedMember");
		Recruitment recruitment = recruitmentService.getForPrintRecruitmentById(loginedMember, id);

		model.addAttribute("usr/recruitment", recruitment);

		return "usr/recruitment/modify";
	}

	@RequestMapping("/usr/recruitment/{jobCode}-write")
	public String showWrite(@PathVariable("jobCode") String jobCode, Model model, String listUrl) {
		if (listUrl == null) {
			listUrl = "./" + jobCode + "-list";
		}

		List<ActingRole> roles = actingRoleService.getRoles();
		model.addAttribute("roles", roles);

		model.addAttribute("listUrl", listUrl);
		Job job = recruitmentService.getJobByCode(jobCode);
		model.addAttribute("job", job);

		return "usr/recruitment/write";
	}

	@RequestMapping("/usr/recruitment/{jobCode}-doModify")
	public String doModify(@RequestParam Map<String, Object> param, HttpServletRequest req, int id,
			@PathVariable("jobCode") String jobCode, Model model) {
		Map<String, Object> newParam = Util.getNewMapOf(param, "title", "body", "fileIdsStr", "usr/recruitmentId",
				"id");
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		ResultData checkActorCanModifyResultData = recruitmentService.checkActorCanModify(loginedMember, id);

		if (checkActorCanModifyResultData.isFail()) {
			model.addAttribute("historyBack", true);
			model.addAttribute("msg", checkActorCanModifyResultData.getMsg());

			return "common/redirect";
		}

		recruitmentService.modify(newParam);

		String redirectUri = (String) param.get("redirectUri");

		return "redirect:" + redirectUri;
	}

	@RequestMapping("/usr/recruitment/{jobCode}-doSetComplete")
	public String doSetComplete(String redirectUri, int id, HttpServletRequest req,
			@PathVariable("jobCode") String jobCode, Model model) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");
		ResultData checkActorCanModifyResultData = recruitmentService.checkActorCanModify(loginedMember, id);

		if (checkActorCanModifyResultData.isFail()) {
			model.addAttribute("historyBack", true);
			model.addAttribute("msg", checkActorCanModifyResultData.getMsg());

			return "common/redirect";
		}

		recruitmentService.setComplete(id);

		return "redirect:" + redirectUri;
	}

	@RequestMapping("/usr/recruitment/{jobCode}-doWrite")
	public String doWrite(@RequestParam Map<String, Object> param, HttpServletRequest req,
			@PathVariable("jobCode") String jobCode, Model model) {
		Job job = recruitmentService.getJobByCode(jobCode);

		Map<String, Object> newParam = Util.getNewMapOf(param, "title", "body", "fileIdsStr", "roleTypeCode", "roleId");
		int loginedMemberId = (int) req.getAttribute("loginedMemberId");
		newParam.put("jobId", job.getId());
		newParam.put("memberId", loginedMemberId);
		int newRecruitmentId = recruitmentService.write(newParam);

		String redirectUri = (String) param.get("redirectUri");
		redirectUri = redirectUri.replace("#id", newRecruitmentId + "");

		return "redirect:" + redirectUri;
	}

	@RequestMapping("/usr/recruitment/{jobCode}-doDelete")
	public String doDelete(@RequestParam Map<String, Object> param, @RequestParam("id") int id, HttpServletRequest req,
			@PathVariable("jobCode") String jobCode, Model model) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");

		ResultData checkActorCanDeleteResultData = recruitmentService.checkActorCanDelete(loginedMember, id);

		if (checkActorCanDeleteResultData.isFail()) {
			model.addAttribute("historyBack", true);
			model.addAttribute("msg", checkActorCanDeleteResultData.getMsg());

			return "common/redirect";
		}

		ResultData deleteResultData = recruitmentService.delete(id);
		model.addAttribute("msg", deleteResultData.getMsg());
		String redirectUri = (String) param.get("redirectUri");

		if (redirectUri == null || redirectUri.length() == 0) {
			redirectUri = jobCode + "-list";
		}

		model.addAttribute("redirectUri", redirectUri);

		return "common/redirect";
	}
}
