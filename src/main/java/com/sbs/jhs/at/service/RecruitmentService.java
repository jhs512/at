package com.sbs.jhs.at.service;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dao.RecruitmentDao;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.Job;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.Recruitment;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.util.Util;

@Service
public class RecruitmentService {
	@Autowired
	private RecruitmentDao recruitmentDao;
	@Autowired
	private FileService fileService;

	public List<Recruitment> getForPrintRecruitments() {
		List<Recruitment> recruitments = recruitmentDao.getForPrintRecruitments();

		return recruitments;
	}

	private void updateForPrintInfo(Member actor, Recruitment recruitment) {
		Util.putExtraVal(recruitment, "actorCanDelete", actorCanDelete(actor, recruitment));
		Util.putExtraVal(recruitment, "actorCanModify", actorCanModify(actor, recruitment));
	}

	// 액터가 해당 댓글을 수정할 수 있는지 알려준다.
	public boolean actorCanModify(Member actor, Recruitment recruitment) {
		return actor != null && actor.getId() == recruitment.getMemberId() ? true : false;
	}

	// 액터가 해당 댓글을 삭제할 수 있는지 알려준다.
	public boolean actorCanDelete(Member actor, Recruitment recruitment) {
		return actorCanModify(actor, recruitment);
	}

	public Recruitment getForPrintRecruitmentById(Member actor, int id) {
		Recruitment recruitment = recruitmentDao.getForPrintRecruitmentById(id);

		updateForPrintInfo(actor, recruitment);

		List<File> files = fileService.getFiles("recruitment", recruitment.getId(), "common", "attachment");

		Map<String, File> filesMap = new HashMap<>();

		for (File file : files) {
			filesMap.put(file.getFileNo() + "", file);
		}

		Util.putExtraVal(recruitment, "file__common__attachment", filesMap);

		return recruitment;
	}

	public int write(Map<String, Object> param) {
		recruitmentDao.write(param);
		int id = Util.getAsInt(param.get("id"));

		String fileIdsStr = (String) param.get("fileIdsStr");

		if (fileIdsStr != null && fileIdsStr.length() > 0) {
			List<Integer> fileIds = Arrays.asList(fileIdsStr.split(",")).stream().map(s -> Integer.parseInt(s.trim()))
					.collect(Collectors.toList());

			// 파일이 먼저 생성된 후에, 관련 데이터가 생성되는 경우에는, file의 relId가 일단 0으로 저장된다.
			// 그것을 뒤늦게라도 이렇게 고처야 한다.
			for (int fileId : fileIds) {
				fileService.changeRelId(fileId, id);
			}
		}

		return id;
	}

	public boolean actorCanModify(Member actor, int id) {
		Recruitment recruitment = recruitmentDao.getRecruitmentById(id);

		return actorCanModify(actor, recruitment);
	}

	public ResultData checkActorCanModify(Member actor, int id) {
		boolean actorCanModify = actorCanModify(actor, id);

		if (actorCanModify) {
			return new ResultData("S-1", "가능합니다.", "id", id);
		}

		return new ResultData("F-1", "권한이 없습니다.", "id", id);
	}

	public void modify(Map<String, Object> param) {
		recruitmentDao.modify(param);

		int id = Util.getAsInt(param.get("id"));

		String fileIdsStr = (String) param.get("fileIdsStr");

		if (fileIdsStr != null && fileIdsStr.length() > 0) {
			List<Integer> fileIds = Arrays.asList(fileIdsStr.split(",")).stream().map(s -> Integer.parseInt(s.trim()))
					.collect(Collectors.toList());

			// 파일이 먼저 생성된 후에, 관련 데이터가 생성되는 경우에는, file의 relId가 일단 0으로 저장된다.
			// 그것을 뒤늦게라도 이렇게 고처야 한다.
			for (int fileId : fileIds) {
				fileService.changeRelId(fileId, id);
			}
		}
	}

	public Job getJobByCode(String jobCode) {
		return recruitmentDao.getJobByCode(jobCode);
	}
}
