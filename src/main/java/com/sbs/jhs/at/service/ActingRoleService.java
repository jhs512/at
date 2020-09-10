package com.sbs.jhs.at.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dao.ActingRoleDao;
import com.sbs.jhs.at.dto.ActingRole;
import com.sbs.jhs.at.dto.Article;
import com.sbs.jhs.at.dto.Artwork;

@Service
public class ActingRoleService {
	@Autowired
	private ActingRoleDao actingRoleDao;

	public List<ActingRole> getRoles() {
		return actingRoleDao.getRoles();
	}

	public List<ActingRole> getForPrintRoles() {
		return actingRoleDao.getRoles();
	}

	public List<Artwork> getArtworks() {
		return actingRoleDao.getArtworks();
	}

}
