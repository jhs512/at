package com.sbs.jhs.at.dao;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface FileDao {

	void save(Map<String, Object> param);

}
