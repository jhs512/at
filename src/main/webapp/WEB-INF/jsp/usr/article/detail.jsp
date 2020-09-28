<%@ page import="com.sbs.jhs.at.util.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.name} 게시물 상세내용" />
<%@ include file="../part/head.jspf"%>
<%@ include file="../../part/toastuiEditor.jspf"%>

<div class="article-detail-box table-box table-box-vertical con">
	<table>
		<colgroup>
			<col class="table-first-col">
		</colgroup>
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
				<td>${article.forPrintTitle}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
				    <script type="text/x-template">${article.body}</script>
                    <div class="toast-editor toast-editor-viewer"></div>
				</td>
			</tr>
			<c:forEach var="i" begin="1" end="3" step="1">
				<c:set var="fileNo" value="${String.valueOf(i)}" />
				<c:set var="file" value="${article.extra.file__common__attachment[fileNo]}" />
				<c:if test="${file != null}">
					<tr>
						<th>첨부파일 ${fileNo}</th>
						<td>
							<c:if test="${file.fileExtTypeCode == 'video'}">
								<div class="video-box">
									<video controls src="/usr/file/streamVideo?id=${file.id}&updateDate=${file.updateDate}"></video>
								</div>
							</c:if>
							<c:if test="${file.fileExtTypeCode == 'img'}">
								<div class="img-box img-box-auto">
									<img src="/usr/file/img?id=${file.id}&updateDate=${file.updateDate}" alt="" />
								</div>
							</c:if>
						</td>
					</tr>
				</c:if>
			</c:forEach>
		</tbody>
	</table>
</div>

<div class="btn-box con margin-top-20">
	<c:if test="${article.extra.actorCanModify}">
		<a class="btn btn-info" href="${board.code}-modify?id=${article.id}&listUrl=${Util.getUriEncoded(listUrl)}">수정</a>
	</c:if>
	<c:if test="${article.extra.actorCanDelete}">
		<a class="btn btn-danger" href="${board.code}-doDelete?id=${article.id}" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;">삭제</a>
	</c:if>

	<a href="${listUrl}" class="btn btn-info">목록</a>
</div>

<c:if test="${isLogined}">
	<h2 class="con">댓글 작성</h2>

	<script>
		function WriteReplyForm__submit(form) {
			if (isNowLoading()) {
				alert('처리중입니다.');
			}

			form.body.value = form.body.value.trim();
			if (form.body.value.length == 0) {
				alert('댓글을 입력해주세요.');
				form.body.focus();
				return;
			}

			startLoading();

			var startUploadFiles = function(onSuccess) {
				var needToUpload = false;

				if (needToUpload == false) {
					needToUpload = form.file__reply__0__common__attachment__1 && form.file__reply__0__common__attachment__1.value.length > 0;
				}

				if (needToUpload == false) {
					needToUpload = form.file__reply__0__common__attachment__2 && form.file__reply__0__common__attachment__2.value.length > 0;
				}

				if (needToUpload == false) {
					needToUpload = form.file__reply__0__common__attachment__3 && form.file__reply__0__common__attachment__3.value.length > 0;
				}

				if (needToUpload == false) {
					onSuccess();
					return;
				}

				var fileUploadFormData = new FormData(form);

				$.ajax({
					url : './../file/doUploadAjax',
					data : fileUploadFormData,
					processData : false,
					contentType : false,
					dataType : "json",
					type : 'POST',
					success : onSuccess
				});
			}

			var startWriteReply = function(fileIdsStr, onSuccess) {

				$.ajax({
					url : './../reply/doWriteReplyAjax',
					data : {
						fileIdsStr : fileIdsStr,
						body : form.body.value,
						relTypeCode : form.relTypeCode.value,
						relId : form.relId.value
					},
					dataType : "json",
					type : 'POST',
					success : onSuccess
				});
			};

			startUploadFiles(function(data) {

				var idsStr = '';
				if (data && data.body && data.body.fileIdsStr) {
					idsStr = data.body.fileIdsStr;
				}

				startWriteReply(idsStr, function(data) {

					if (data.msg) {
						alert(data.msg);
					}

					form.body.value = '';

					if (form.file__reply__0__common__attachment__1) {
						form.file__reply__0__common__attachment__1.value = '';
					}

					if (form.file__reply__0__common__attachment__2) {
						form.file__reply__0__common__attachment__2.value = '';
					}

					if (form.file__reply__0__common__attachment__3) {
						form.file__reply__0__common__attachment__3.value = '';
					}

					endLoading();
				});
			});
		}
	</script>

	<form class="table-box table-box-vertical con form1" onsubmit="WriteReplyForm__submit(this); return false;">
		<input type="hidden" name="relTypeCode" value="article" />
		<input type="hidden" name="relId" value="${article.id}" />

		<table>
			<colgroup>
				<col class="table-first-col">
			</colgroup>
			<tbody>
				<tr>
					<th>내용</th>
					<td>
						<div class="form-control-box">
							<textarea maxlength="300" name="body" placeholder="내용을 입력해주세요." class="height-300"></textarea>
						</div>
					</td>
				</tr>
				<c:forEach var="i" begin="1" end="3" step="1">
					<c:set var="fileNo" value="${String.valueOf(i)}" />
					<c:set var="fileExtTypeCode" value="${appConfig.getAttachmentFileExtTypeCode('reply', i)}" />
					<tr>
						<th>첨부${fileNo} ${appConfig.getAttachmentFileExtTypeDisplayName('reply', i)}</th>
						<td>
							<div class="form-control-box">
								<input type="file" accept="${appConfig.getAttachemntFileInputAccept('article', i)}" name="file__reply__0__common__attachment__${fileNo}">
							</div>
						</td>
					</tr>
				</c:forEach>
				<tr class="tr-do">
					<th>작성</th>
					<td>
						<input class="btn btn-primary" type="submit" value="작성">
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</c:if>

<h2 class="con">댓글 목록</h2>

<style>
.reply-list-box .media-box > * {
    margin-top:10px;    
}

.reply-list-box .media-box > *:empty {
    display:none;
}

.reply-list-box .media-box > :first-chidl {
    margin-top:10px;
} 
</style>

<div class="reply-list-box table-box table-box-data con">
	<table>
		<colgroup>
			<col class="table-first-col">
			<col width="100">
			<col width="140">
			<col>
			<col width="180">
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
.reply-modify-form-modal-actived, reply-modify-form-modal-actived>body {
    overflow: hidden;
}

.reply-modify-form-modal {
    display: none;
}

.reply-modify-form-modal-actived .reply-modify-form-modal {
    display: flex;
}

.reply-modify-form-modal .video-box {
    width: 100px;
}

.reply-modify-form-modal .img-box {
    width: 100px;
}
</style>

<div class="popup-1 reply-modify-form-modal">
	<div>
		<h1>댓글 수정</h1>
		<form action="" class="form1 padding-10 table-box table-box-vertical" onsubmit="ReplyList__submitModifyForm(this); return false;">
			<input type="hidden" name="id" />
			<table>
				<colgroup>
					<col class="table-first-col">
				</colgroup>
				<tbody>
					<tr>
						<th>내용</th>
						<td>
							<div class="form-control-box">
								<textarea name="body" placeholder="내용을 입력해주세요."></textarea>
							</div>
						</td>
					</tr>

					<c:forEach var="i" begin="1" end="3" step="1">
						<c:set var="fileNo" value="${String.valueOf(i)}" />
						<c:set var="fileExtTypeCode" value="${appConfig.getAttachmentFileExtTypeCode('article', i)}" />

						<tr>
							<th>첨부${fileNo}</th>
							<td>
								<div class="form-control-box">
									<input type="file" accept="${appConfig.getAttachemntFileInputAccept('article', i)}" data-name="file__reply__0__common__attachment__${fileNo}">
								</div>
								<div style="width: 100%" class="video-box video-box-file-${fileNo}"></div>
								<div style="width: 100%" class="img-box img-box-auto img-box-file-${fileNo}"></div>
							</td>
						</tr>

						<tr>
							<th>첨부${fileNo} 삭제</th>
							<td>
								<div class="form-control-box">
									<label>
										<input type="checkbox" data-name="deleteFile__reply__0__common__attachment__${fileNo}" value="Y" />
										삭제
									</label>
								</div>
							</td>
						</tr>
					</c:forEach>
					<tr class="tr-do">
						<th>수정</th>
						<td>
							<button class="btn btn-primary" type="submit">수정</button>
							<button class="btn btn-info" type="button" onclick="ReplyList__hideModifyFormModal();">취소</button>
						</td>
					</tr>
				</tbody>
			</table>

		</form>
	</div>
</div>

<script>
	var ReplyList__$box = $('.reply-list-box');
	var ReplyList__$tbody = ReplyList__$box.find('tbody');

	var ReplyList__lastLodedId = 0;

	function ReplyList__submitModifyForm(form) {
		if (isNowLoading()) {
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
		var fileInput3 = form['file__reply__' + id + '__common__attachment__3'];

		var deleteFileInput1 = form["deleteFile__reply__" + id + "__common__attachment__1"];
		var deleteFileInput2 = form["deleteFile__reply__" + id + "__common__attachment__2"];
		var deleteFileInput3 = form["deleteFile__reply__" + id + "__common__attachment__3"];

		if (fileInput1 && deleteFileInput1 && deleteFileInput1.checked) {
			fileInput1.value = '';
		}

		if (fileInput2 && deleteFileInput2 && deleteFileInput2.checked) {
			fileInput2.value = '';
		}

		if (fileInput3 && deleteFileInput3 && deleteFileInput3.checked) {
			fileInput3.value = '';
		}

		startLoading();

		// 파일 업로드 시작
		var startUploadFiles = function() {
			var needToUpload = false;

			if (needToUpload == false) {
				needToUpload = fileInput1 && fileInput1.value.length > 0;
			}

			if (needToUpload == false) {
				needToUpload = deleteFileInput1 && deleteFileInput1.checked;
			}

			if (needToUpload == false) {
				needToUpload = fileInput2 && fileInput2.value.length > 0;
			}

			if (needToUpload == false) {
				needToUpload = deleteFileInput2 && deleteFileInput2.checked;
			}

			if (needToUpload == false) {
				needToUpload = fileInput3 && fileInput3.value.length > 0;
			}

			if (needToUpload == false) {
				needToUpload = deleteFileInput3 && deleteFileInput3.checked;
			}

			if (needToUpload == false) {
				onUploadFilesComplete();
				return;
			}

			var fileUploadFormData = new FormData(form);

			$.ajax({
				url : './../file/doUploadAjax',
				data : fileUploadFormData,
				processData : false,
				contentType : false,
				dataType : "json",
				type : 'POST',
				success : onUploadFilesComplete
			});
		}

		// 파일 업로드 완료시 실행되는 함수
		var onUploadFilesComplete = function(data) {

			var fileIdsStr = '';
			if (data && data.body && data.body.fileIdsStr) {
				fileIdsStr = data.body.fileIdsStr;
			}

			startModifyReply(fileIdsStr);
		};

		// 댓글 수정 시작
		var startModifyReply = function(fileIdsStr) {
			$.post('../reply/doModifyReplyAjax', {
				id : id,
				body : body,
				fileIdsStr : fileIdsStr
			}, onModifyReplyComplete, 'json');
		};

		// 댓글 수정이 완료되면 실행되는 함수
		var onModifyReplyComplete = function(data) {
			if (data.resultCode && data.resultCode.substr(0, 2) == 'S-') {
				// 성공시에는 기존에 그려진 내용을 수정해야 한다.!!
				$('.reply-list-box tbody > tr[data-id="' + id + '"]').data('data-originBody', body);
				$('.reply-list-box tbody > tr[data-id="' + id + '"] .reply-body').empty().append(getHtmlEncoded(body).replaceAll('\n', '<br>'));

				$('.reply-list-box tbody > tr[data-id="' + id + '"] .video-box').empty();
				$('.reply-list-box tbody > tr[data-id="' + id + '"] .img-box').empty();

				if (data && data.body && data.body.file__common__attachment) {
					for ( var fileNo in data.body.file__common__attachment) {
						var file = data.body.file__common__attachment[fileNo];

						if (file.fileExtTypeCode == 'video') {
							var html = '<video preload="none" controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
							$('.reply-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].video-box').append(html);
						} else {
							var html = '<img src="/usr/file/img?id=' + file.id + '&updateDate=' + file.updateDate + '">';
							$('.reply-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].img-box').append(html);
						}
					}
				}
			}

			if (data.msg) {
				alert(data.msg);
			}

			ReplyList__hideModifyFormModal();
			endLoading();
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

			if ($el.prop('type') == 'file') {
				$el.val('');
			} else if ($el.prop('type') == 'checkbox') {
				$el.prop('checked', false);
			}
		});

		for (var fileNo = 1; fileNo <= 3; fileNo++) {
			$('.reply-modify-form-modal .video-box-file-' + fileNo).empty();

			var videoName = 'reply__' + id + '__common__attachment__' + fileNo;

			var $videoBox = $('.reply-list-box [data-video-name="' + videoName + '"]');

			if ($videoBox.length > 0) {
				$('.reply-modify-form-modal .video-box-file-' + fileNo).append($videoBox.html());
			}

			$('.reply-modify-form-modal .img-box-file-' + fileNo).empty();

			var imgName = 'reply__' + id + '__common__attachment__' + fileNo;

			var $imgBox = $('.reply-list-box [data-img-name="' + imgName + '"]');

			if ($imgBox.length > 0) {
				$('.reply-modify-form-modal .img-box-file-' + fileNo).append($imgBox.html());
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
	    if (isNowLoading()) {
            alert('처리중입니다.');
        }
		
		if (confirm('삭제 하시겠습니까?') == false) {
			return;
		}

		var $tr = $(el).closest('tr');

		var id = $tr.attr('data-id');

		startLoading();

		$.post('./../reply/doDeleteReplyAjax', {
			id : id
		}, function(data) {
		    if ( data.msg ) {
                alert(data.msg);
            }

			if ( data.resultCode.substr(0, 2) == 'S-' ) {
				$tr.remove();
			}

			endLoading();
		}, 'json');
	}

	function ReplyList__getMediaHtml(reply) {
		var html = '';
		for (var fileNo = 1; fileNo <= 3; fileNo++) {
            var file = null;
            if (reply.extra.file__common__attachment && reply.extra.file__common__attachment[fileNo]) {
                file = reply.extra.file__common__attachment[fileNo];
            }

            html += '<div class="video-box" data-video-name="reply__' + reply.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';

            if (file && file.fileExtTypeCode == 'video') {
                html += '<video  preload="none" controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '"></video>';
            }

            html += '</div>';

            html += '<div class="img-box img-box-auto" data-img-name="reply__' + reply.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';

            if (file && file.fileExtTypeCode == 'img') {
                html += '<img src="/usr/file/img?id=' + file.id + '&updateDate=' + file.updateDate + '">';
            }

            html += '</div>';
        }

        return '<div class="media-box">' + html + "</div>";
	}

	function ReplyList__drawReply(reply) {
		var html = '';
		html += '<tr data-id="' + reply.id + '">';
		html += '<td>' + reply.id + '</td>';
		html += '<td class="visible-on-md-up">' + reply.regDate + '</td>';
		html += '<td class="visible-on-md-up">' + reply.extra.writer + '</td>';
		html += '<td>';
		html += '<div class="reply-body">' + reply.forPrintBody + '</div>';

		html += ReplyList__getMediaHtml(reply);

		html += '</td>';
		html += '<td>';

		if (reply.extra.actorCanDelete) {
			html += '<button class="btn btn-danger" type="button" onclick="ReplyList__delete(this);">삭제</button>';
		}

		if (reply.extra.actorCanModify) {
			html += '<button class="btn btn-info" type="button" onclick="ReplyList__showModifyFormModal(this);">수정</button>';
		}

		html += '</td>';

		html += '<td class="visible-on-sm-down">';


    html += '<div class="flex flex-row-wrap flex-ai-c">';
        html += '<span class="badge badge-primary bold margin-right-10">' + reply.id + '</span>';
        html += '<div class="writer">' + reply.extra.writer + '</div>';
        html += '&nbsp;|&nbsp;';
        html += '<div class="reg-date">' + reply.regDate + '</div>';
        html += '<div class="width-100p"></div>';
        html += '<div class="body flex-1-0-0 margin-top-10 reply-body">' + reply.forPrintBody + '</div>';
        html += ReplyList__getMediaHtml(reply);
        html += '</div>';

        html += '<div class="margin-top-10 btn-inline-box">';

        if (reply.extra.actorCanDelete) {
            html += '<button class="btn btn-danger" type="button" onclick="ReplyList__delete(this);">삭제</button>';
        }

        if (reply.extra.actorCanModify) {
            html += '<button class="btn btn-info" type="button" onclick="ReplyList__showModifyFormModal(this);">수정</button>';
        }

        html += '</div>';

        html += '</td>';
        html += '</tr>';

        var $tr = $(html);
        $tr.data('data-originBody', reply.body);
        ReplyList__$tbody.prepend($tr);
    }

    ReplyList__loadMore();
</script>

<%@ include file="../part/foot.jspf"%>