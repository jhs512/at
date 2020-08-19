package com.sbs.jhs.at.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dao.ActingRoleDao;
import com.sbs.jhs.at.dto.ActingRole;

@Service
public class ActingRoleService {
	@Autowired
	private ActingRoleDao actingRoleDao;

	public List<ActingRole> getRoles() {
		return actingRoleDao.getRoles();
	}

}
