package com.sbs.jhs.at.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.ArticleReply;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.service.ArticleService;
import com.sbs.jhs.at.util.Util;

@Controller
public class ArticleController {
	@Autowired
	private ArticleService articleService;

	@RequestMapping("/usr/article/list")
	public String showList(Model model) {
		List<Article> articles = articleService.getForPrintArticles();

		model.addAttribute("articles", articles);

		return "article/list";
	}

	@RequestMapping("/usr/article/detail")
	public String showDetail(Model model, @RequestParam Map<String, Object> param) {
		int id = Integer.parseInt((String) param.get("id"));

		Article article = articleService.getForPrintArticleById(id);

		model.addAttribute("article", article);

		return "article/detail";
	}

	@RequestMapping("/usr/article/write")
	public String showWrite() {
		return "article/write";
	}

	@RequestMapping("/usr/article/doWrite")
	public String doWrite(@RequestParam Map<String, Object> param) {
		int newArticleId = articleService.write(param);

		String redirectUrl = (String) param.get("redirectUrl");
		redirectUrl = redirectUrl.replace("#id", newArticleId + "");

		return "redirect:" + redirectUrl;
	}

	@RequestMapping("/usr/article/doWriteReplyAjax")
	@ResponseBody
	public ResultData doWriteReplyAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) {
		Map<String, Object> rsDataBody = new HashMap<>();
		param.put("memberId", request.getAttribute("loginedMemberId"));
		int newArticleReplyId = articleService.writeReply(param);
		rsDataBody.put("articleReplyId", newArticleReplyId);

		return new ResultData("S-1", String.format("%d번 댓글이 생성되었습니다.", newArticleReplyId), rsDataBody);
	}

	@RequestMapping("/usr/article/getForPrintArticleReplies")
	@ResponseBody
	public ResultData getForPrintArticleReplies(@RequestParam Map<String, Object> param, HttpServletRequest req) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");
		Map<String, Object> rsDataBody = new HashMap<>();

		param.put("actor", loginedMember);
		List<ArticleReply> articleReplies = articleService.getForPrintArticleReplies(param);
		rsDataBody.put("articleReplies", articleReplies);

		return new ResultData("S-1", String.format("%d개의 댓글을 불러왔습니다.", articleReplies.size()), rsDataBody);
	}

	@RequestMapping("/usr/article/doDeleteReplyAjax")
	@ResponseBody
	public ResultData doDeleteReplyAjax(int id, HttpServletRequest req) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");
		ArticleReply articleReply = articleService.getForPrintArticleReplyById(id);

		if (articleService.actorCanDelete(loginedMember, articleReply) == false) {
			return new ResultData("F-1", String.format("%d번 댓글을 삭제할 권한이 없습니다.", id));
		}

		articleService.deleteReply(id);

		return new ResultData("S-1", String.format("%d번 댓글을 삭제하였습니다.", id));
	}

	@RequestMapping("/usr/article/doModifyReplyAjax")
	@ResponseBody
	public ResultData doModifyReplyAjax(@RequestParam Map<String, Object> param, HttpServletRequest req, int id) {
		Member loginedMember = (Member) req.getAttribute("loginedMember");
		ArticleReply articleReply = articleService.getForPrintArticleReplyById(id);

		if (articleService.actorCanModify(loginedMember, articleReply) == false) {
			return new ResultData("F-1", String.format("%d번 댓글을 수정할 권한이 없습니다.", id));
		}

		Map<String, Object> modfiyReplyParam = Util.getNewMapOf(param, "id", "body");
		ResultData rd = articleService.modfiyReply(modfiyReplyParam);

		return rd;
	}
}
