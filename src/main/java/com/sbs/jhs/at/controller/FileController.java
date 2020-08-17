package com.sbs.jhs.at.controller;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartRequest;

import com.google.common.base.Joiner;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.service.FileService;
import com.sbs.jhs.at.service.VideoStreamService;
import com.sbs.jhs.at.util.Util;

@Controller
public class FileController {
	@Autowired
	private FileService fileService;
	@Autowired
	private VideoStreamService videoStreamService;

	private LoadingCache<Integer, File> fileCache = CacheBuilder.newBuilder().maximumSize(100)
			.expireAfterAccess(2, TimeUnit.MINUTES).build(new CacheLoader<Integer, File>() {
				@Override
				public File load(Integer fileId) {
					return fileService.getFileById(fileId);
				}
			});

	@RequestMapping(value = "/usr/file/showImg", method = RequestMethod.GET)
	public void showImg3(HttpServletResponse response, int id) throws IOException {

		File file = Util.getCacheData(fileCache, id);

		InputStream in = new ByteArrayInputStream(file.getBody());

		switch (file.getFileExtType2Code()) {
		case "jpg":
			response.setContentType(MediaType.IMAGE_JPEG_VALUE);
			break;
		case "png":
			response.setContentType(MediaType.IMAGE_PNG_VALUE);
			break;
		case "gif":
			response.setContentType(MediaType.IMAGE_GIF_VALUE);
			break;
		}

		IOUtils.copy(in, response.getOutputStream());
	}

	@RequestMapping("/usr/file/streamVideo")
	public ResponseEntity<byte[]> streamVideo(@RequestHeader(value = "Range", required = false) String httpRangeList,
			int id) {
		File file = Util.getCacheData(fileCache, id);

		return videoStreamService.prepareContent(new ByteArrayInputStream(file.getBody()), file.getFileSize(),
				file.getFileExt(), httpRangeList);
	}

	@RequestMapping("/usr/file/doUploadAjax")
	@ResponseBody
	public ResultData uploadAjax(@RequestParam Map<String, Object> param, HttpServletRequest req,
			MultipartRequest multipartRequest) {

		Map<String, MultipartFile> fileMap = multipartRequest.getFileMap();

		List<Integer> fileIds = new ArrayList<>();

		for (String fileInputName : fileMap.keySet()) {
			MultipartFile multipartFile = fileMap.get(fileInputName);

			String[] fileInputNameBits = fileInputName.split("__");

			if (fileInputNameBits[0].equals("file")) {
				byte[] fileBytes = Util.getFileBytesFromMultipartFile(multipartFile);

				if (fileBytes == null || fileBytes.length == 0) {
					continue;
				}

				String relTypeCode = fileInputNameBits[1];
				int relId = Integer.parseInt(fileInputNameBits[2]);
				String typeCode = fileInputNameBits[3];
				String type2Code = fileInputNameBits[4];
				int fileNo = Integer.parseInt(fileInputNameBits[5]);
				String originFileName = multipartFile.getOriginalFilename();
				String fileExtTypeCode = Util.getFileExtTypeCodeFromFileName(multipartFile.getOriginalFilename());
				String fileExtType2Code = Util.getFileExtType2CodeFromFileName(multipartFile.getOriginalFilename());
				String fileExt = Util.getFileExtFromFileName(multipartFile.getOriginalFilename()).toLowerCase();
				int fileSize = (int) multipartFile.getSize();

				boolean fileUpdated = false;

				if (relId != 0) {
					int oldFileId = fileService.getFileId(relTypeCode, relId, typeCode, type2Code, fileNo);

					if (oldFileId > 0) {
						fileService.updateFile(oldFileId, originFileName, fileExtTypeCode, fileExtType2Code, fileExt,
								fileBytes, fileSize);

						fileCache.refresh(oldFileId);
						fileUpdated = true;
					}
				}

				if (fileUpdated == false) {
					int fileId = fileService.saveFile(relTypeCode, relId, typeCode, type2Code, fileNo, originFileName,
							fileExtTypeCode, fileExtType2Code, fileExt, fileBytes, fileSize);

					fileIds.add(fileId);
				}
			}
		}

		int deleteCount = 0;

		for (String inputName : param.keySet()) {
			String[] inputNameBits = inputName.split("__");

			if (inputNameBits[0].equals("deleteFile")) {
				String relTypeCode = inputNameBits[1];
				int relId = Integer.parseInt(inputNameBits[2]);
				String typeCode = inputNameBits[3];
				String type2Code = inputNameBits[4];
				int fileNo = Integer.parseInt(inputNameBits[5]);

				int oldFileId = fileService.getFileId(relTypeCode, relId, typeCode, type2Code, fileNo);

				boolean needToDelete = oldFileId > 0;

				if (needToDelete) {
					fileService.deleteFile(oldFileId);
					fileCache.refresh(oldFileId);
					deleteCount++;
				}
			}
		}

		Map<String, Object> rsDataBody = new HashMap<>();
		rsDataBody.put("fileIdsStr", Joiner.on(",").join(fileIds));
		rsDataBody.put("fileIds", fileIds);

		return new ResultData("S-1", String.format("%d개의 파일을 저장했습니다. %d개의 파일을 삭제했습니다.", fileIds.size(), deleteCount),
				rsDataBody);
	}
}