package com.sbs.jhs.at.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.jhs.at.dto.Applyment;
import com.sbs.jhs.at.dto.ResultData;

@Mapper
public interface ApplymentDao {
	List<Applyment> getForPrintApplyments(Map<String, Object> param);

	void writeApplyment(Map<String, Object> param);

	void deleteApplyment(@Param("id") int id);

	Applyment getForPrintApplymentById(@Param("id") int id);

	void modifyApplyment(Map<String, Object> param);

	List<Applyment> getApplymentsByRelId(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId);

	Applyment getApplymentByRelIdAndMemberId(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId, @Param("memberId") int memberId);

	void changeHideStatus(@Param("id") int id, @Param("hideStatus") boolean hideStatus);
}
