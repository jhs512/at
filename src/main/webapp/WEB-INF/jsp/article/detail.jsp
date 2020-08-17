<%@ page import="com.sbs.jhs.at.util.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 상세내용" />
<%@ include file="../part/head.jspf"%>

<div class="table-box con">
	<table>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${article.id}</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${article.regDate}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${article.title}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${article.body}</td>
			</tr>
			<c:if test="${article.extra.file__common__attachment['1'] != null}">
				<tr>
					<th>첨부 파일 1</th>
					<td>
						<div class="video-box">
							<video controls
								src="/usr/file/streamVideo?id=${article.extra.file__common__attachment['1'].id}&updateDate=${article.extra.file__common__attachment['1'].updateDate}">video
								not supported
							</video>
						</div>
					</td>
				</tr>
			</c:if>
			<c:if test="${article.extra.file__common__attachment['2'] != null}">
				<tr>
					<th>첨부 파일 2</th>
					<td>
						<div class="video-box">
							<video controls
								src="/usr/file/streamVideo?id=${article.extra.file__common__attachment['2'].id}&updateDate=${article.extra.file__common__attachment['2'].updateDate}">video
								not supported
							</video>
						</div>
					</td>
				</tr>
			</c:if>
		</tbody>
	</table>
</div>

<div class="btn-box con margin-top-20">
	<c:if test="${article.extra.actorCanModify}">
		<a class="btn btn-info" href="${board.code}-modify?id=${article.id}&listUrl=${Util.getUriEncoded(listUrl)}">수정</a>
	</c:if>
	<c:if test="${article.extra.actorCanDelete}">
		<a class="btn btn-info" href="${board.code}-doDelete?id=${article.id}"
			onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;">삭제</a>
	</c:if>
	
	<a href="${listUrl}" class="btn btn-info">리스트</a>
</div>

<c:if test="${isLogined}">
	<h2 class="con">댓글 작성</h2>

	<script>
		var ArticleWriteReplyForm__submitDone = false;
		function ArticleWriteReplyForm__submit(form) {
			if ( ArticleWriteReplyForm__submitDone ) {
				alert('처리중입니다.');
			}
			form.body.value = form.body.value.trim();
			if (form.body.value.length == 0) {
				alert('댓글을 입력해주세요.');
				form.body.focus();
				return;
			}

			ArticleWriteReplyForm__submitDone = true;

			var startUploadFiles = function(onSuccess) {
				if ( form.file__reply__0__common__attachment__1.value.length == 0 && form.file__reply__0__common__attachment__2.value.length == 0 ) {
					onSuccess();
					return;
				}

				var fileUploadFormData = new FormData(form); 
				
				fileUploadFormData.delete("relTypeCode");
				fileUploadFormData.delete("relId");
				fileUploadFormData.delete("body");

				$.ajax({
					url : './../file/doUploadAjax',
					data : fileUploadFormData,
					processData : false,
					contentType : false,
					dataType:"json",
					type : 'POST',
					success : onSuccess
				});
			}

			var startWriteReply = function(fileIdsStr, onSuccess) {

				$.ajax({
					url : './../reply/doWriteReplyAjax',
					data : {
						fileIdsStr: fileIdsStr,
						body: form.body.value,
						relTypeCode: form.relTypeCode.value,
						relId: form.relId.value
					},
					dataType:"json",
					type : 'POST',
					success : onSuccess
				});
			};

			startUploadFiles(function(data) {
				
				var idsStr = '';
				if ( data && data.body && data.body.fileIdsStr ) {
					idsStr = data.body.fileIdsStr;
				}

				startWriteReply(idsStr, function(data) {
					
					if ( data.msg ) {
						alert(data.msg);
					}
					
					form.body.value = '';
					form.file__reply__0__common__attachment__1.value = '';
					form.file__reply__0__common__attachment__2.value = '';
					ArticleWriteReplyForm__submitDone = false;
				});
			});
		}
	</script>

	<form class="table-box con form1"
		onsubmit="ArticleWriteReplyForm__submit(this); return false;">
		<input type="hidden" name="relTypeCode" value="article" /> <input
			type="hidden" name="relId" value="${article.id}" />

		<table>
			<tbody>
				<tr>
					<th>내용</th>
					<td>
						<div class="form-control-box">
							<textarea maxlength="300" name="body" placeholder="내용을 입력해주세요."
								class="height-300"></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th>첨부1 비디오</th>
					<td>
						<div class="form-control-box">
							<input type="file" accept="video/*"
								name="file__reply__0__common__attachment__1">
						</div>
					</td>
				</tr>
				<tr>
					<th>첨부2 비디오</th>
					<td>
						<div class="form-control-box">
							<input type="file" accept="video/*"
								name="file__reply__0__common__attachment__2">
						</div>
					</td>
				</tr>
				<tr>
					<th>작성</th>
					<td>
						<input type="submit" value="작성">
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</c:if>


<h2 class="con">댓글 리스트</h2>

<div class="reply-list-box table-box con">
	<table>
		<colgroup>
			<col width="80">
			<col width="180">
			<col width="180">
			<col>
			<col width="200">
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>작성자</th>
				<th>내용</th>
				<th>비고</th>
			</tr>
		</thead>
		<tbody>

		</tbody>
	</table>
</div>

<style>
.reply-modify-form-modal {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.4);
	display: none;
}

.reply-modify-form-modal-actived .reply-modify-form-modal {
	display: flex;
}

.reply-modify-form-modal .form-control-label {
	width: 120px;
}

.reply-modify-form-modal .form-control-box {
	flex: 1 0 0;
}

.reply-modify-form-modal .video-box {
	width: 100px;
}
</style>

<div class="reply-modify-form-modal flex flex-ai-c flex-jc-c">
	<form action="" class="form1 bg-white padding-10"
		onsubmit="ReplyList__submitModifyForm(this); return false;">
		<input type="hidden" name="id" />
		<div class="form-row">
			<div class="form-control-label">내용</div>
			<div class="form-control-box">
				<textarea name="body" placeholder="내용을 입력해주세요."></textarea>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 1</div>
			<div class="form-control-box">
				<input type="file" accept="video/*"
					data-name="file__reply__0__common__attachment__1" />
			</div>
			<div class="video-box video-box-file-1"></div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 1 삭제</div>
			<div class="form-control-box">
				<label><input type="checkbox"
					data-name="deleteFile__reply__0__common__attachment__1" value="Y" />
					삭제 </label>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 2</div>
			<div class="form-control-box">
				<input type="file" accept="video/*"
					data-name="file__reply__0__common__attachment__2" />
			</div>
			<div class="video-box video-box-file-2"></div>
		</div>
		<div class="form-row">
			<div class="form-control-label">첨부파일 2 삭제</div>
			<div class="form-control-box">
				<label><input type="checkbox"
					data-name="deleteFile__reply__0__common__attachment__2" value="Y" />
					삭제 </label>
			</div>
		</div>
		<div class="form-row">
			<div class="form-control-label">수정</div>
			<div class="form-control-box">
				<button type="submit">수정</button>
				<button type="button" onclick="ReplyList__hideModifyFormModal();">취소</button>
			</div>
		</div>
	</form>
</div>

<script>
	var ReplyList__$box = $('.reply-list-box');
	var ReplyList__$tbody = ReplyList__$box.find('tbody');

	var ReplyList__lastLodedId = 0;

	var ReplyList__submitModifyFormDone = false;

	function ReplyList__submitModifyForm(form) {
		if (ReplyList__submitModifyFormDone) {
			alert('처리중입니다.');
			return;
		}

		form.body.value = form.body.value.trim();

		if (form.body.value.length == 0) {
			alert('내용을 입력해주세요.');
			form.body.focus();

			return;
		}

		var id = form.id.value;
		var body = form.body.value;

		var fileInput1 = form['file__reply__' + id + '__common__attachment__1'];
		var fileInput2 = form['file__reply__' + id + '__common__attachment__2'];

		var deleteFileInput1 = form["deleteFile__reply__" + id
			+ "__common__attachment__1"];
		var deleteFileInput2 = form["deleteFile__reply__" + id
			+ "__common__attachment__2"];

		if (deleteFileInput1.checked) {
			fileInput1.value = '';
		}

		if (deleteFileInput2.checked) {
			fileInput2.value = '';
		}

		ReplyList__submitModifyFormDone = true;

		// 파일 업로드 시작
		var startUploadFiles = function() {
			if (fileInput1.value.length == 0 && fileInput2.value.length == 0) {
				if (deleteFileInput1.checked == false
						&& deleteFileInput2.checked == false) {
					onUploadFilesComplete();
					return;
				}
			}

			var fileUploadFormData = new FormData(form); 
			
			$.ajax({
				url : './../file/doUploadAjax',
				data : fileUploadFormData,
				processData : false,
				contentType : false,
				dataType:"json",
				type : 'POST',
				success : onUploadFilesComplete
			});
		}

		// 파일 업로드 완료시 실행되는 함수
		var onUploadFilesComplete = function(data) {
			
			var fileIdsStr = '';
			if ( data && data.body && data.body.fileIdsStr ) {
				fileIdsStr = data.body.fileIdsStr;
			}

			startModifyReply(fileIdsStr);
		};

		// 댓글 수정 시작
		var startModifyReply = function(fileIdsStr) {
			$.post('../reply/doModifyReplyAjax', {
				id : id,
				body : body,
				fileIdsStr: fileIdsStr
			}, onModifyReplyComplete, 'json');
		};

		// 댓글 수정이 완료되면 실행되는 함수
		var onModifyReplyComplete = function(data) {
			if (data.resultCode && data.resultCode.substr(0, 2) == 'S-') {
				// 성공시에는 기존에 그려진 내용을 수정해야 한다.!!
				var $tr = $('.reply-list-box tbody > tr[data-id="' + id + '"] .reply-body');
				$tr.empty().append(body);

				var $tr = $('.reply-list-box tbody > tr[data-id="' + id + '"] .video-box').empty();

				if ( data && data.body && data.body.file__common__attachment ) {
					for ( var fileNo in data.body.file__common__attachment ) {
						var file = data.body.file__common__attachment[fileNo];

						var html = '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
						$('.reply-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].video-box').append(html);
					}
				}
			}

			if ( data.msg ) {
				alert(data.msg);
			}

			ReplyList__hideModifyFormModal();
			ReplyList__submitModifyFormDone = false;
		};

		startUploadFiles();
	}

	function ReplyList__showModifyFormModal(el) {
		$('html').addClass('reply-modify-form-modal-actived');
		var $tr = $(el).closest('tr');
		var originBody = $tr.data('data-originBody');

		var id = $tr.attr('data-id');

		var form = $('.reply-modify-form-modal form').get(0);

		$(form).find('[data-name]').each(function(index, el) {
			var $el = $(el);

			var name = $el.attr('data-name');
			name = name.replaceAll('__0__', '__' + id + '__');
			$el.attr('name', name);

			if ( $el.prop('type') == 'file' ) {
				$el.val('');
			}
			else if ( $el.prop('type') == 'checkbox' ) {
				$el.prop('checked', false);
			}
		});

		for ( var fileNo = 1; fileNo <= 2; fileNo++ ) {
			$('.reply-modify-form-modal .video-box-file-' + fileNo).empty();
			
			var videoName = 'reply__' + id + '__common__attachment__' + fileNo;

			var $videoBox = $('.reply-list-box [data-video-name="' + videoName + '"]');
			
			if ( $videoBox.length > 0 ) {
				$('.reply-modify-form-modal .video-box-file-' + fileNo).append($videoBox.html());
			}
		}

		form.id.value = id;
		form.body.value = originBody;
	}

	function ReplyList__hideModifyFormModal() {
		$('html').removeClass('reply-modify-form-modal-actived');
	}

	// 1초
	ReplyList__loadMoreInterval = 1 * 1000;

	function ReplyList__loadMoreCallback(data) {
		if (data.body.replies && data.body.replies.length > 0) {
			ReplyList__lastLodedId = data.body.replies[data.body.replies.length - 1].id;
			ReplyList__drawReplies(data.body.replies);
		}

		setTimeout(ReplyList__loadMore, ReplyList__loadMoreInterval);
	}

	function ReplyList__loadMore() {

		$.get('../reply/getForPrintReplies', {
			articleId : param.id,
			from : ReplyList__lastLodedId + 1
		}, ReplyList__loadMoreCallback, 'json');
	}

	function ReplyList__drawReplies(replies) {
		for (var i = 0; i < replies.length; i++) {
			var reply = replies[i];
			ReplyList__drawReply(reply);
		}
	}

	function ReplyList__delete(el) {
		if (confirm('삭제 하시겠습니까?') == false) {
			return;
		}

		var $tr = $(el).closest('tr');

		var id = $tr.attr('data-id');

		$.post('./../reply/doDeleteReplyAjax', {
			id : id
		}, function(data) {
			$tr.remove();
		}, 'json');
	}

	function ReplyList__drawReply(reply) {
		var html = '';
		html += '<tr data-id="' + reply.id + '">';
		html += '<td>' + reply.id + '</td>';
		html += '<td>' + reply.regDate + '</td>';
		html += '<td>' + reply.extra.writer + '</td>';
		html += '<td>';
		html += '<div class="reply-body">' + reply.body + '</div>';

		for ( var fileNo = 1; fileNo <= 2; fileNo++ ) {
			html += '<div class="video-box" data-video-name="reply__' + reply.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';

			if ( reply.extra.file__common__attachment && reply.extra.file__common__attachment[fileNo] ) {
				var file = reply.extra.file__common__attachment[fileNo];

				html += '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
	        }
			else {
			}

			html += '</div>';
		}
		
		html += '</td>';
		html += '<td>';

		if (reply.extra.actorCanDelete) {
			html += '<button type="button" onclick="ReplyList__delete(this);">삭제</button>';
		}
		
		if (reply.extra.actorCanModify) {
			html += '<button type="button" onclick="ReplyList__showModifyFormModal(this);">수정</button>';
		}
		
		html += '</td>';
		html += '</tr>';

		var $tr = $(html);
		$tr.data('data-originBody', reply.body);
		ReplyList__$tbody.prepend($tr);
	}

	ReplyList__loadMore();
</script>

<%@ include file="../part/foot.jspf"%>