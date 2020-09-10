package com.sbs.jhs.at.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.sbs.jhs.at.dto.ActingRole;
import com.sbs.jhs.at.dto.Artwork;

@Mapper
public interface ActingRoleDao {

	List<ActingRole> getRoles();

	List<Artwork> getArtworks();

}
