package com.sbs.jhs.at.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dao.ArticleDao;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.util.Util;

@Service
public class ArticleService {
	@Autowired
	private ArticleDao articleDao;
	
	public int getCount() {
		return 2;
	}
	
	public List<Article> getForPrintArticles() {
		List<Article> articles = articleDao.getForPrintArticles();
		
		return articles;
	}
}



