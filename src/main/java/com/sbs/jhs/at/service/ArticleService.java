package com.sbs.jhs.at.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.ArticleReply;
import com.sbs.jhs.at.util.Util;

@Service
public class ArticleService {
	@Autowired
	private ArticleDao articleDao;

	public List<Article> getForPrintArticles() {
		List<Article> articles = articleDao.getForPrintArticles();

		return articles;
	}

	public Article getForPrintArticleById(int id) {
		Article article = articleDao.getForPrintArticleById(id);

		return article;
	}

	public int write(Map<String, Object> param) {
		articleDao.write(param);

		return Util.getAsInt(param.get("id"));
	}

	public int writeReply(Map<String, Object> param) {
		articleDao.writeReply(param);

		return Util.getAsInt(param.get("id"));
	}

	public List<ArticleReply> getForPrintArticleReplies(@RequestParam Map<String, Object> param) {
		return articleDao.getForPrintArticleReplies(param);
	}

	public void deleteReply(int id) {
		articleDao.deleteReply(id);
	}
}
