<%@ page import="com.sbs.jhs.at.util.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${job.name} 모집 상세내용" />
<%@ include file="../part/head.jspf"%>

<style>
.table-first-col {
	width: 100px;
}

.table-first-col-tight {
	width: 100px;
}

@media ( max-width :800px ) {
	.table-first-col {
		width: 65px;
	}
	.table-first-col-tight {
		width: 30px;
	}
}
</style>

<div class="recruitment-detail-box table-box con">
	<table>
		<colgroup>
			<col class="table-first-col">
		</colgroup>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${recruitment.id}</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${recruitment.regDate}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${recruitment.title}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${recruitment.body}</td>
			</tr>
			<c:forEach var="i" begin="1" end="3" step="1">
				<c:set var="fileNo" value="${String.valueOf(i)}" />
				<c:set var="file"
					value="${recruitment.extra.file__common__attachment[fileNo]}" />
				<c:if test="${file != null}">
					<tr>
						<th>첨부파일 ${fileNo}</th>
						<td><c:if test="${file.fileExtTypeCode == 'video'}">
								<div class="video-box">
									<video controls
										src="/usr/file/streamVideo?id=${file.id}&updateDate=${file.updateDate}">video
										not supported
									</video>
								</div>
							</c:if> <c:if test="${file.fileExtTypeCode == 'img'}">
								<div class="img-box img-box-auto">
									<img
										src="/usr/file/showImg?id=${file.id}&updateDate=${file.updateDate}"
										alt="" />
								</div>
							</c:if></td>
					</tr>
				</c:if>
			</c:forEach>
		</tbody>
	</table>
</div>

<div class="btn-box con margin-top-20">
	<c:if test="${recruitment.extra.actorCanModify}">
		<a class="btn btn-info"
			href="${job.code}-modify?id=${recruitment.id}&listUrl=${Util.getUriEncoded(listUrl)}">수정</a>
	</c:if>
	<c:if test="${recruitment.extra.actorCanDelete}">
		<a class="btn btn-info" href="${job.code}-doDelete?id=${recruitment.id}"
			onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;">삭제</a>
	</c:if>

	<a href="${listUrl}" class="btn btn-info">리스트</a>
</div>

<c:if test="${isLogined}">
	<h2 class="con">해당 배역 신청</h2>

	<script>
		var RecruitmentWriteApplymentForm__submitDone = false;
		function RecruitmentWriteApplymentForm__submit(form) {
			if ( RecruitmentWriteApplymentForm__submitDone ) {
				alert('처리중입니다.');
			}
			
			form.body.value = form.body.value.trim();
			if (form.body.value.length == 0) {
				alert('내용을 입력해주세요.');
				form.body.focus();
				return;
			}

			RecruitmentWriteApplymentForm__submitDone = true;

			var startUploadFiles = function(onSuccess) {
				var needToUpload = false;

				if ( needToUpload == false ) {
					needToUpload = form.file__applyment__0__common__attachment__1.value.length > 0;
				}
				
				if ( needToUpload == false ) {
					needToUpload = form.file__applyment__0__common__attachment__2.value.length > 0;
				}

				if ( needToUpload == false ) {
					needToUpload = form.file__applyment__0__common__attachment__3.value.length > 0;
				}
				
				if ( needToUpload == false ) {
					onSuccess();
					return;
				}

				var fileUploadFormData = new FormData(form); 
				
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

			var startWriteApplyment = function(fileIdsStr, onSuccess) {

				$.ajax({
					url : './../applyment/doWriteApplymentAjax',
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

				startWriteApplyment(idsStr, function(data) {
					
					if ( data.msg ) {
						alert(data.msg);
					}
					
					form.body.value = '';
					
					if ( form.file__applyment__0__common__attachment__1 ) {
						form.file__applyment__0__common__attachment__1.value = '';
					}
					
					if ( form.file__applyment__0__common__attachment__2 ) {
						form.file__applyment__0__common__attachment__2.value = '';
					}

					if ( form.file__applyment__0__common__attachment__3 ) {
						form.file__applyment__0__common__attachment__3.value = '';
					}
					
					RecruitmentWriteApplymentForm__submitDone = false;
				});
			});
		}
	</script>

	<form class="table-box con form1"
		onsubmit="RecruitmentWriteApplymentForm__submit(this); return false;">
		<input type="hidden" name="relTypeCode" value="recruitment" /> <input
			type="hidden" name="relId" value="${recruitment.id}" />

		<table>
			<colgroup>
				<col class="table-first-col">
			</colgroup>
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
				<c:forEach var="i" begin="1" end="3" step="1">
					<c:set var="fileNo" value="${String.valueOf(i)}" />
					<c:set var="fileExtTypeCode"
						value="${appConfig.getAttachmentFileExtTypeCode('applyment', i)}" />
					<tr>
						<th>첨부${fileNo}
							${appConfig.getAttachmentFileExtTypeDisplayName('applyment', i)}</th>
						<td>
							<div class="form-control-box">
								<input type="file"
									accept="${appConfig.getAttachemntFileInputAccept('recruitment', i)}"
									name="file__applyment__0__common__attachment__${fileNo}">
							</div>
						</td>
					</tr>
				</c:forEach>
				<tr>
					<th>작성</th>
					<td><input class="btn btn-primary" type="submit" value="작성">
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</c:if>

<h2 class="con">신청 리스트</h2>

<div class="applyment-list-box table-box con">
	<table>
		<colgroup>
			<col class="table-first-col table-first-col-tight">
			<col width="180" class="visible-on-md-up">
			<col width="180" class="visible-on-md-up">
			<col>
			<col width="200" class="visible-on-md-up">
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th class="visible-on-md-up">날짜</th>
				<th class="visible-on-md-up">작성자</th>
				<th>내용</th>
				<th class="visible-on-md-up">비고</th>
			</tr>
		</thead>
		<tbody>

		</tbody>
	</table>
</div>

<style>
.applyment-modify-form-modal-actived, applyment-modify-form-modal-actived>body {
	overflow: hidden;
}

.applyment-modify-form-modal {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.4);
	display: none;
	z-index: 20;
}

.applyment-modify-form-modal>div {
	position: absolute;
	left: 50%;
	top: 50%;
	transform: translateX(-50%) translateY(-50%);
	max-width: 100vw;
	min-width: 320px;
	max-height: 100vh;
	overflow-y: auto;
	border: 3px solid black;
	box-sizing: border-box;
}

.applyment-modify-form-modal-actived .applyment-modify-form-modal {
	display: flex;
}

.applyment-modify-form-modal .form-control-label {
	width: 60px;
}

.applyment-modify-form-modal .form-control-box {
	flex: 1 0 0;
}

.applyment-modify-form-modal .video-box {
	width: 100px;
}
</style>

<div class="applyment-modify-form-modal">
	<div class="bg-white">
		<h1 class="text-align-center">신청 수정</h1>
		<form action="" class="form1 padding-10"
			onsubmit="ApplymentList__submitModifyForm(this); return false;">
			<input type="hidden" name="id" />
			<div class="form-row">
				<div class="form-control-label">내용</div>
				<div class="form-control-box">
					<textarea name="body" placeholder="내용을 입력해주세요."></textarea>
				</div>
			</div>

			<c:forEach var="i" begin="1" end="3" step="1">
				<c:set var="fileNo" value="${String.valueOf(i)}" />
				<c:set var="fileExtTypeCode"
					value="${appConfig.getAttachmentFileExtTypeCode('recruitment', i)}" />

				<div class="form-row">
					<div class="form-control-label">첨부${fileNo}</div>
					<div class="form-control-box">
						<input type="file"
							accept="${appConfig.getAttachemntFileInputAccept('recruitment', i)}"
							data-name="file__applyment__0__common__attachment__${fileNo}">
					</div>
					<div style="width: 100%" class="video-box video-box-file-${fileNo}"></div>
					<div style="width: 100%"
						class="img-box img-box-auto img-box-file-${fileNo}"></div>
				</div>

				<div class="form-row">
					<div class="form-control-label">첨부${fileNo} 삭제</div>
					<div class="form-control-box">
						<label><input type="checkbox"
							data-name="deleteFile__applyment__0__common__attachment__${fileNo}"
							value="Y" /> 삭제 </label>
					</div>
				</div>
			</c:forEach>
			<div class="form-row">
				<div class="form-control-label">수정</div>
				<div class="form-control-box">
					<button class="btn btn-primary" type="submit">수정</button>
					<button class="btn btn-info" type="button"
						onclick="ApplymentList__hideModifyFormModal();">취소</button>
				</div>
			</div>
		</form>
	</div>
</div>

<script>
	var ApplymentList__$box = $('.applyment-list-box');
	var ApplymentList__$tbody = ApplymentList__$box.find('tbody');

	var ApplymentList__lastLodedId = 0;

	var ApplymentList__submitModifyFormDone = false;

	function ApplymentList__submitModifyForm(form) {
		if (ApplymentList__submitModifyFormDone) {
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

		var fileInput1 = form['file__applyment__' + id + '__common__attachment__1'];
		var fileInput2 = form['file__applyment__' + id + '__common__attachment__2'];
		var fileInput3 = form['file__applyment__' + id + '__common__attachment__3'];

		var deleteFileInput1 = form["deleteFile__applyment__" + id
			+ "__common__attachment__1"];
		var deleteFileInput2 = form["deleteFile__applyment__" + id
			+ "__common__attachment__2"];
		var deleteFileInput3 = form["deleteFile__applyment__" + id
			+ "__common__attachment__3"];

		if (fileInput1 && deleteFileInput1 && deleteFileInput1.checked) {
			fileInput1.value = '';
		}

		if (fileInput2 && deleteFileInput2 && deleteFileInput2.checked) {
			fileInput2.value = '';
		}

		if (fileInput3 && deleteFileInput3 && deleteFileInput3.checked) {
			fileInput3.value = '';
		}

		ApplymentList__submitModifyFormDone = true;

		// 파일 업로드 시작
		var startUploadFiles = function() {
			var needToUpload = false;

			if ( needToUpload == false ) {
				needToUpload = fileInput1 && fileInput1.value.length > 0;
			}

			if ( needToUpload == false ) {
				needToUpload = deleteFileInput1 && deleteFileInput1.checked;
			}

			if ( needToUpload == false ) {
				needToUpload = fileInput2 && fileInput2.value.length > 0;
			}

			if ( needToUpload == false ) {
				needToUpload = deleteFileInput2 && deleteFileInput2.checked;
			}

			if ( needToUpload == false ) {
				needToUpload = fileInput3 && fileInput3.value.length > 0;
			}

			if ( needToUpload == false ) {
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

			startModifyApplyment(fileIdsStr);
		};

		// 신청 수정 시작
		var startModifyApplyment = function(fileIdsStr) {
			$.post('../applyment/doModifyApplymentAjax', {
				id : id,
				body : body,
				fileIdsStr: fileIdsStr
			}, onModifyApplymentComplete, 'json');
		};

		// 신청 수정이 완료되면 실행되는 함수
		var onModifyApplymentComplete = function(data) {
			if (data.resultCode && data.resultCode.substr(0, 2) == 'S-') {
				// 성공시에는 기존에 그려진 내용을 수정해야 한다.!!
				$('.applyment-list-box tbody > tr[data-id="' + id + '"]').data('data-originBody', body);
				$('.applyment-list-box tbody > tr[data-id="' + id + '"] .applyment-body').empty().append(body);

				$('.applyment-list-box tbody > tr[data-id="' + id + '"] .video-box').empty();
				$('.applyment-list-box tbody > tr[data-id="' + id + '"] .img-box').empty();

				if ( data && data.body && data.body.file__common__attachment ) {
					for ( var fileNo in data.body.file__common__attachment ) {
						var file = data.body.file__common__attachment[fileNo];

						if ( file.fileExtTypeCode == 'video' ) {
							var html = '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
							$('.applyment-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].video-box').append(html);
						}
						else {
							var html = '<img src="/usr/file/showImg?id=' + file.id + '&updateDate=' + file.updateDate + '">';
							$('.applyment-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].img-box').append(html);
						}
					}
				}
			}

			if ( data.msg ) {
				alert(data.msg);
			}

			ApplymentList__hideModifyFormModal();
			ApplymentList__submitModifyFormDone = false;
		};

		startUploadFiles();
	}

	function ApplymentList__showModifyFormModal(el) {
		$('html').addClass('applyment-modify-form-modal-actived');
		var $tr = $(el).closest('tr');
		var originBody = $tr.data('data-originBody');

		var id = $tr.attr('data-id');

		var form = $('.applyment-modify-form-modal form').get(0);

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

		for ( var fileNo = 1; fileNo <= 3; fileNo++ ) {
			$('.applyment-modify-form-modal .video-box-file-' + fileNo).empty();
			
			var videoName = 'applyment__' + id + '__common__attachment__' + fileNo;

			var $videoBox = $('.applyment-list-box [data-video-name="' + videoName + '"]');
			
			if ( $videoBox.length > 0 ) {
				$('.applyment-modify-form-modal .video-box-file-' + fileNo).append($videoBox.html());
			}

			$('.applyment-modify-form-modal .img-box-file-' + fileNo).empty();

			var imgName = 'applyment__' + id + '__common__attachment__' + fileNo;

			var $imgBox = $('.applyment-list-box [data-img-name="' + imgName + '"]');
			
			if ( $imgBox.length > 0 ) {
				$('.applyment-modify-form-modal .img-box-file-' + fileNo).append($imgBox.html());
			}
		}

		form.id.value = id;
		form.body.value = originBody;
	}

	function ApplymentList__hideModifyFormModal() {
		$('html').removeClass('applyment-modify-form-modal-actived');
	}

	// 1초
	ApplymentList__loadMoreInterval = 1 * 1000;

	function ApplymentList__loadMoreCallback(data) {
		if (data.body.applyments && data.body.applyments.length > 0) {
			ApplymentList__lastLodedId = data.body.applyments[data.body.applyments.length - 1].id;
			ApplymentList__drawApplyments(data.body.applyments);
		}

		setTimeout(ApplymentList__loadMore, ApplymentList__loadMoreInterval);
	}

	function ApplymentList__loadMore() {

		$.get('../applyment/getForPrintApplyments', {
			recruitmentId : param.id,
			from : ApplymentList__lastLodedId + 1
		}, ApplymentList__loadMoreCallback, 'json');
	}

	function ApplymentList__drawApplyments(applyments) {
		for (var i = 0; i < applyments.length; i++) {
			var applyment = applyments[i];
			ApplymentList__drawApplyment(applyment);
		}
	}

	function ApplymentList__delete(el) {
		if (confirm('삭제 하시겠습니까?') == false) {
			return;
		}

		var $tr = $(el).closest('tr');

		var id = $tr.attr('data-id');

		$.post('./../applyment/doDeleteApplymentAjax', {
			id : id
		}, function(data) {
			$tr.remove();
		}, 'json');
	}

	function ApplymentList__drawApplyment(applyment) {
		var html = '';
		html += '<tr data-id="' + applyment.id + '">';
		html += '<td>' + applyment.id + '</td>';
		html += '<td class="visible-on-md-up">' + applyment.regDate + '</td>';
		html += '<td class="visible-on-md-up">' + applyment.extra.writer + '</td>';
		html += '<td>';
		html += '<div class="applyment-body">' + applyment.body + '</div>';
		html += '<div class="visible-on-sm-down">날짜 : ' + applyment.regDate + '</div>';
		html += '<div class="visible-on-sm-down">작성 : ' + applyment.extra.writer + '</div>';

		for ( var fileNo = 1; fileNo <= 3; fileNo++ ) {
			var file = null;
			if ( applyment.extra.file__common__attachment && applyment.extra.file__common__attachment[fileNo] ) {
				file = applyment.extra.file__common__attachment[fileNo];
			}
			
			html += '<div class="video-box" data-video-name="applyment__' + applyment.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';

			if ( file && file.fileExtTypeCode == 'video' ) {
				html += '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
			}

			html += '</div>';

			html += '<div class="img-box img-box-auto" data-img-name="applyment__' + applyment.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';

			if ( file && file.fileExtTypeCode == 'img' ) {
				html += '<img src="/usr/file/showImg?id=' + file.id + '&updateDate=' + file.updateDate + '">';
	        }

			html += '</div>';
		}

		html += '<div class="visible-on-sm-down margin-top-10">';

		if (applyment.extra.actorCanDelete) {
			html += '<button class="btn btn-danger" type="button" onclick="ApplymentList__delete(this);">삭제</button>';
		}
		
		if (applyment.extra.actorCanModify) {
			html += '<button class="btn btn-info" type="button" onclick="ApplymentList__showModifyFormModal(this);">수정</button>';
		}
		
		html += '</div>';
		
		html += '</td>';
		html += '<td class="visible-on-md-up">';

		if (applyment.extra.actorCanDelete) {
			html += '<button class="btn btn-danger" type="button" onclick="ApplymentList__delete(this);">삭제</button>';
		}
		
		if (applyment.extra.actorCanModify) {
			html += '<button class="btn btn-info" type="button" onclick="ApplymentList__showModifyFormModal(this);">수정</button>';
		}
		
		html += '</td>';
		html += '</tr>';

		var $tr = $(html);
		$tr.data('data-originBody', applyment.body);
		ApplymentList__$tbody.prepend($tr);
	}

	ApplymentList__loadMore();
</script>

<%@ include file="../part/foot.jspf"%>