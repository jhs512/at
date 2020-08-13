package com.sbs.jhs.at.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.sbs.jhs.at.dto.File;

@Mapper
public interface FileDao {

	void save(Map<String, Object> param);
	
	void update(Map<String, Object> param);

	void changeRelId(@Param("id") int id, @Param("relId") int relId);

	List<File> getFilesRelTypeCodeAndRelIdsAndTypeCodeAndType2CodeAndFileNo(@Param("relTypeCode") String relTypeCode,
			@Param("relIds") List<Integer> relIds, @Param("typeCode") String typeCode,
			@Param("type2Code") String type2Code, @Param("fileNo") int fileNo);

	File getFileById(@Param("id") int id);

	void deleteFiles(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId);

	List<File> getFilesRelTypeCodeAndRelIdsAndTypeCodeAndType2Code(@Param("relTypeCode") String relTypeCode,
			@Param("relIds") List<Integer> relIds, @Param("typeCode") String typeCode,
			@Param("type2Code") String type2Code);

	List<File> getFilesRelTypeCodeAndRelIdAndTypeCodeAndType2Code(@Param("relTypeCode") String relTypeCode,
			@Param("relId") int relId, @Param("typeCode") String typeCode, @Param("type2Code") String type2Code);

	Integer getFileId(@Param("relTypeCode") String relTypeCode, @Param("relId") int relId,
			@Param("typeCode") String typeCode, @Param("type2Code") String type2Code, @Param("fileNo") int fileNo);

	void deleteFile(@Param("id") int id);
}
