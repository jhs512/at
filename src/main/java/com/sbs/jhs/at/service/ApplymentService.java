package com.sbs.jhs.at.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ApplymentDao;
import com.sbs.jhs.at.dto.Applyment;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.util.Util;

@Service
public class ApplymentService {
	@Autowired
	private ApplymentDao applymentDao;
	@Autowired
	private FileService fileService;

	public List<Applyment> getForPrintApplyments(@RequestParam Map<String, Object> param) {
		List<Applyment> applyments = applymentDao.getForPrintApplyments(param);

		List<Integer> applymentIds = applyments.stream().map(applyment -> applyment.getId())
				.collect(Collectors.toList());
		if (applymentIds.size() > 0) {
			Map<Integer, Map<Integer, File>> filesMap = fileService.getFilesMapKeyRelIdAndFileNo("applyment",
					applymentIds, "common", "attachment");

			for (Applyment applyment : applyments) {
				Map<Integer, File> filesMap2 = filesMap.get(applyment.getId());

				if (filesMap2 != null) {
					applyment.getExtra().put("file__common__attachment", filesMap2);
				}
			}
		}

		Member actor = (Member) param.get("actor");

		for (Applyment applyment : applyments) {
			// 출력용 부가데이터를 추가한다.
			updateForPrintInfo(actor, applyment);
		}

		return applyments;
	}

	private void updateForPrintInfo(Member actor, Applyment applyment) {
		applyment.getExtra().put("actorCanDelete", actorCanDelete(actor, applyment));
		applyment.getExtra().put("actorCanModify", actorCanModify(actor, applyment));
	}

	// 액터가 해당 댓글을 수정할 수 있는지 알려준다.
	public boolean actorCanModify(Member actor, Applyment applyment) {
		return actor != null && actor.getId() == applyment.getMemberId() ? true : false;
	}

	// 액터가 해당 댓글을 삭제할 수 있는지 알려준다.
	public boolean actorCanDelete(Member actor, Applyment applyment) {
		return actorCanModify(actor, applyment);
	}

	public int writeApplyment(Map<String, Object> param) {
		applymentDao.writeApplyment(param);
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

	public void deleteApplyment(int id) {
		applymentDao.deleteApplyment(id);
		fileService.deleteFiles("applyment", id);
	}

	public Applyment getForPrintApplymentById(int id) {
		Applyment applyment = applymentDao.getForPrintApplymentById(id);

		Map<Integer, File> filesMap = fileService.getFilesMapKeyFileNo("applyment", id, "common", "attachment");
		Util.putExtraVal(applyment, "file__common__attachment", filesMap);

		return applyment;
	}

	public ResultData modfiyApplyment(Map<String, Object> param) {
		applymentDao.modifyApplyment(param);
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

		Applyment applyment = getForPrintApplymentById(id);

		param.put("file__common__attachment", applyment.getExtra().get("file__common__attachment"));

		return new ResultData("S-1", String.format("%d번 댓글을 수정하였습니다.", Util.getAsInt(param.get("id"))), param);
	}
}
