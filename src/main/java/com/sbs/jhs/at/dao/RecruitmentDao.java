package com.sbs.jhs.at.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.jhs.at.dto.Job;
import com.sbs.jhs.at.dto.Recruitment;

@Mapper
public interface RecruitmentDao {
	List<Recruitment> getForPrintRecruitments();

	Recruitment getForPrintRecruitmentById(@Param("id") int id);
	
	Recruitment getRecruitmentById(@Param("id") int id);

	void write(Map<String, Object> param);

	void modify(Map<String, Object> param);

	Job getJobByCode(String jobCode);

	void delete(int id);
}
