package com.sbs.jhs.at.service;

import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.sbs.jhs.at.dao.FileDao;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.util.Util;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class FileService {
	@Value("${custom.genFileDirPath}")
	private String genFileDirPath;

	@Autowired
	private FileDao fileDao;

	private int saveFile(String relTypeCode, int relId, String typeCode, String type2Code, int fileNo, String fileDir,
			String originFileName, String fileExtTypeCode, String fileExtType2Code, String fileExt, byte[] body,
			int fileSize) {

		Map<String, Object> param = new HashMap();
		param.put("relTypeCode", relTypeCode);
		param.put("relId", relId);
		param.put("typeCode", typeCode);
		param.put("type2Code", type2Code);
		param.put("fileNo", fileNo);
		param.put("fileDir", fileDir);
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
		List<File> files = fileDao.getFilesRelTypeCodeAndRelIdsAndTypeCodeAndType2CodeAndFileNo(relTypeCode, relIds,
				typeCode, type2Code, fileNo);
		Map<Integer, File> map = new HashMap<>();

		for (File file : files) {
			map.put(file.getRelId(), file);
		}

		return map;
	}

	public void deleteFiles(String fileIdsStr) {
		if (fileIdsStr != null && fileIdsStr.length() > 0) {
			List<Integer> fileIds = Arrays.asList(fileIdsStr.split(",")).stream().map(s -> Integer.parseInt(s.trim()))
					.collect(Collectors.toList());

			for (int fileId : fileIds) {
				deleteFile(fileId);
			}
		}
	}

	public void deleteFiles(String relTypeCode, int relId) {
		fileDao.deleteFiles(relTypeCode, relId);
	}

	public File getFileById(int id) {
		return fileDao.getFileById(id);
	}

	public Map<Integer, Map<Integer, File>> getFilesMapKeyRelIdAndFileNo(String relTypeCode, List<Integer> relIds,
			String typeCode, String type2Code) {
		List<File> files = fileDao.getFilesRelTypeCodeAndRelIdsAndTypeCodeAndType2Code(relTypeCode, relIds, typeCode,
				type2Code);
		Map<Integer, File> map = new HashMap<>();

		Map<Integer, Map<Integer, File>> rs = new LinkedHashMap<>();

		for (File file : files) {
			if (rs.containsKey(file.getRelId()) == false) {
				rs.put(file.getRelId(), new LinkedHashMap<>());
			}

			rs.get(file.getRelId()).put(file.getFileNo(), file);
		}

		return rs;
	}

	public List<File> getFiles(String relTypeCode, int relId, String typeCode, String type2Code) {
		List<File> files = fileDao.getFilesRelTypeCodeAndRelIdAndTypeCodeAndType2Code(relTypeCode, relId, typeCode,
				type2Code);
		return files;
	}

	public int getFileId(String relTypeCode, int relId, String typeCode, String type2Code, int fileNo) {
		Integer id = fileDao.getFileId(relTypeCode, relId, typeCode, type2Code, fileNo);

		if (id == null) {
			return -1;
		}

		return id;
	}

	private void updateFile(int id, String fileDir, String originFileName, String fileExtTypeCode,
			String fileExtType2Code, String fileExt, byte[] fileBytes, int fileSize) {

		Map<String, Object> param = new HashMap();
		param.put("fileDir", fileDir);
		param.put("originFileName", originFileName);
		param.put("fileExtTypeCode", fileExtTypeCode);
		param.put("fileExtType2Code", fileExtType2Code);
		param.put("fileExt", fileExt);
		param.put("body", fileBytes);
		param.put("fileSize", fileSize);
		param.put("id", id);

		fileDao.update(param);
	}

	public void deleteFile(int id) {
		// 기존 파일 정보 불러오기
		File oldFile = getFileById(id);

		// 기존 파일이 디스크에 저장되어 있다면 삭제
		String filePath = oldFile.getFilePath(genFileDirPath);

		java.io.File ioFile = new java.io.File(filePath);
		if (ioFile.exists()) {
			boolean ioFileDeleteRs = ioFile.delete();
		}

		fileDao.deleteFile(id);
	}

	public Map<Integer, File> getFilesMapKeyFileNo(String relTypeCode, int relId, String typeCode, String type2Code) {
		List<File> files = getFiles(relTypeCode, relId, typeCode, type2Code);

		Map<Integer, File> filesMap = new HashMap<>();

		for (File file : files) {
			filesMap.put(file.getFileNo(), file);
		}

		return filesMap;
	}

	public int saveFileOnDisk(MultipartFile multipartFile, String relTypeCode, int relId, String typeCode,
			String type2Code, int fileNo, String originFileName, String fileExtTypeCode, String fileExtType2Code,
			String fileExt, int fileSize) {

		// 새 파일이 저장될 폴더명 생성(연_월)
		String fileDir = Util.getNowYearMonthDateStr();

		// DB에 파일정보 등록(먼저 수행하는 이유는 파일을 생성할 때 파일명이 file 테이블의 주키 이기 때문에)
		int fileId = saveFile(relTypeCode, relId, typeCode, type2Code, fileNo, fileDir, originFileName, fileExtTypeCode,
				fileExtType2Code, fileExt, null, fileSize);

		// 새 파일이 저장될 폴더(io파일) 객체 생성
		String targetDirPath = genFileDirPath + "/" + relTypeCode + "/" + fileDir;
		java.io.File targetDir = new java.io.File(targetDirPath);

		// 새 파일이 저장될 폴더가 존재하지 않는다면 생성
		if (targetDir.exists() == false) {
			targetDir.mkdirs();
		}

		String targetFileName = fileId + "." + fileExt;
		String targetFilePath = targetDirPath + "/" + targetFileName;

		// 파일 생성(업로드된 파일을 지정된 경로롤 옮김)
		try {
			multipartFile.transferTo(new java.io.File(targetFilePath));
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}

		return fileId;
	}

	public void updateFileOnDisk(MultipartFile multipartFile, int oldFileId, String originFileName,
			String fileExtTypeCode, String fileExtType2Code, String fileExt, int fileSize) {
		// 기존 파일 정보 불러오기
		File oldFile = getFileById(oldFileId);

		// 기존 파일이 디스크에 저장되어 있다면 삭제
		String filePath = oldFile.getFilePath(genFileDirPath);

		java.io.File ioFile = new java.io.File(filePath);
		if (ioFile.exists()) {
			boolean ioFileDeleteRs = ioFile.delete();
		}

		// 새 파일이 저장될 폴더명 생성(연_월)
		String fileDir = Util.getNowYearMonthDateStr();

		// 새 파일이 저장될 폴더(io파일) 객체 생성
		String targetDirPath = genFileDirPath + "/" + oldFile.getRelTypeCode() + "/" + fileDir;
		java.io.File targetDir = new java.io.File(targetDirPath);

		// 새 파일이 저장될 폴더가 존재하지 않는다면 생성
		if (targetDir.exists() == false) {
			targetDir.mkdirs();
		}

		String targetFileName = oldFile.getId() + "." + fileExt;
		String targetFilePath = targetDirPath + "/" + targetFileName;

		// 파일 생성(업로드된 파일을 지정된 경로롤 옮김)
		try {
			multipartFile.transferTo(new java.io.File(targetFilePath));
		} catch (IllegalStateException | IOException e) {
			e.printStackTrace();
		}

		// 바뀐 파일의 정보를 DB에 업데이트
		updateFile(oldFileId, fileDir, originFileName, fileExtTypeCode, fileExtType2Code, fileExt, null, fileSize);
	}

}
