package com.sbs.jhs.at.service;

import java.sql.Blob;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dao.FileDao;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.util.Util;

@Service
public class FileService {
	@Autowired
	private FileDao fileDao;
	
	public int saveFile(String relTypeCode, int relId, String typeCode, String type2Code, int fileNo,
			String originFileName, String fileExtTypeCode, String fileExtType2Code, String fileExt, byte[] body,
			int fileSize) {

		Map<String, Object> param = new HashMap();
		param.put("relTypeCode", relTypeCode);
		param.put("relId", relId);
		param.put("typeCode", typeCode);
		param.put("type2Code", type2Code);
		param.put("fileNo", fileNo);
		param.put("originFileName", originFileName);
		param.put("fileExtTypeCode", fileExtTypeCode);
		param.put("fileExtType2Code", fileExtType2Code);
		param.put("fileExt", fileExt);
		param.put("body", body);
		param.put("fileSize", fileSize);

		fileDao.save(param);

		return Util.getAsInt(param.get("id"));
	}

	public void changeRelId(int id, int relId) {
		fileDao.changeRelId(id, relId);
	}

	public Map<Integer, File> getFilesMapKeyRelId(String relTypeCode, List<Integer> relIds, String typeCode,
			String type2Code, int fileNo) {
		List<File> files = fileDao.getFiles(relTypeCode, relIds, typeCode, type2Code, fileNo);
		Map<Integer, File> map = new HashMap<>();

		for (File file : files) {
			map.put(file.getRelId(), file);
		}

		return map;
	}

	public byte[] getFileBodyById(int id) {
		File file = fileDao.getFileById(id);
		System.out.println("body : " + file.getBody());
		return file.getBody();
	}

	public void deleteFiles(String relTypeCode, int relId) {
		fileDao.deleteFiles(relTypeCode, relId);
	}

	public File getFileById(int id) {
		return fileDao.getFileById(id);
	}

}
