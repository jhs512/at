package com.sbs.jhs.at.service;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestParam;

import com.sbs.jhs.at.dao.ReplyDao;
import com.sbs.jhs.at.dto.File;
import com.sbs.jhs.at.dto.Member;
import com.sbs.jhs.at.dto.Reply;
import com.sbs.jhs.at.dto.ResultData;
import com.sbs.jhs.at.util.Util;

@Service
public class ReplyService {
	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private FileService fileService;

	public List<Reply> getForPrintReplies(@RequestParam Map<String, Object> param) {
		List<Reply> replies = replyDao.getForPrintReplies(param);

		List<Integer> replyIds = replies.stream().map(reply -> reply.getId()).collect(Collectors.toList());
		if (replyIds.size() > 0) {
			Map<Integer, File> filesMap = fileService.getFilesMapKeyRelId("reply", replyIds, "common", "attachment", 1);

			for (Reply reply : replies) {
				File file = filesMap.get(reply.getId());

				if (file != null) {
					reply.getExtra().put("file__common__attachment__1", file);
				}
			}
			
			filesMap = fileService.getFilesMapKeyRelId("reply", replyIds, "common", "attachment", 2);

			for (Reply reply : replies) {
				File file = filesMap.get(reply.getId());

				if (file != null) {
					reply.getExtra().put("file__common__attachment__2", file);
				}
			}
		}

		Member actor = (Member) param.get("actor");

		for (Reply reply : replies) {
			// 출력용 부가데이터를 추가한다.
			updateForPrintInfo(actor, reply);
		}

		return replies;
	}

	private void updateForPrintInfo(Member actor, Reply reply) {
		reply.getExtra().put("actorCanDelete", actorCanDelete(actor, reply));
		reply.getExtra().put("actorCanModify", actorCanModify(actor, reply));
	}

	// 액터가 해당 댓글을 수정할 수 있는지 알려준다.
	public boolean actorCanModify(Member actor, Reply reply) {
		return actor != null && actor.getId() == reply.getMemberId() ? true : false;
	}

	// 액터가 해당 댓글을 삭제할 수 있는지 알려준다.
	public boolean actorCanDelete(Member actor, Reply reply) {
		return actorCanModify(actor, reply);
	}

	public int writeReply(Map<String, Object> param) {
		replyDao.writeReply(param);
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

	public void deleteReply(int id) {
		replyDao.deleteReply(id);
		fileService.deleteFiles("reply", id);
	}

	public Reply getForPrintReplyById(int id) {
		return replyDao.getForPrintReplyById(id);
	}

	public ResultData modfiyReply(Map<String, Object> param) {
		replyDao.modifyReply(param);
		return new ResultData("S-1", String.format("%d번 댓글을 수정하였습니다.", Util.getAsInt(param.get("id"))), param);
	}
}
