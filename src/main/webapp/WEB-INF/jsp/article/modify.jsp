<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시물 상세내용" />
<%@ include file="../part/head.jspf"%>


<script>
	var ArticleModifyForm__submitDone = false;
	function ArticleModifyForm__submit(form) {

		var fileInput1 = form["file__article__" + param.id
				+ "__common__attachment__1"];
		var fileInput2 = form["file__article__" + param.id
				+ "__common__attachment__2"];

		if (ArticleModifyForm__submitDone) {
			alert('처리중입니다.');
			return;
		}

		form.title.value = form.title.value.trim();

		if (form.title.value.length == 0) {
			form.title.focus();
			alert('제목을 입력해주세요.');

			return;
		}

		form.body.value = form.body.value.trim();

		if (form.body.value.length == 0) {
			form.body.focus();
			alert('내용을 입력해주세요.');

			return;
		}

		var maxSizeMb = 50;
		var maxSize = maxSizeMb * 1024 * 1024 //50MB

		if (fileInput1.value) {
			if (fileInput1.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		if (fileInput2.value) {
			if (fileInput2.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		var startUploadFiles = function(onSuccess) {
			if (fileInput1.value.length == 0 && fileInput2.value.length == 0) {
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

		ArticleModifyForm__submitDone = true;
		startUploadFiles(function(data) {
			var fileIdsStr = '';

			if (data && data.body && data.body.fileIdsStr) {
				fileIdsStr = data.body.fileIdsStr;
			}

			form.fileIdsStr.value = fileIdsStr;
			fileInput1.value = '';
			fileInput2.value = '';

			form.submit();
		});
	}
</script>
<form class="table-box con form1" method="POST" action="doModify"
	onsubmit="ArticleModifyForm__submit(this); return false;">
	<input type="hidden" name="fileIdsStr" /> <input type="hidden"
		name="redirectUri" value="/usr/article/detail?id=${article.id}" /> <input
		type="hidden" name="id" value="${article.id}" />
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
				<td>
					<div class="form-control-box">
						<input type="text" value="${article.title}" name="title"
							placeholder="제목을 입력해주세요." />
					</div>
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>
					<div class="form-control-box">
						<textarea name="body" placeholder="내용을 입력해주세요.">${article.body}</textarea>
					</div>
				</td>
			</tr>
			<tr>
				<th>첨부 파일 1</th>
				<td>
					<div class="form-control-box">
						<input type="file" accept="video/*"
							name="file__article__${article.id}__common__attachment__1" />
					</div> <c:if
						test="${article.extra.file__common__attachment['1'] != null}">
						<div class="video-box">
							<video controls
								src="/usr/file/streamVideo?id=${article.extra.file__common__attachment['1'].id}">video
								not supported
							</video>
						</div>
					</c:if>
				</td>
			</tr>
			<tr>
				<th>첨부 파일 1 삭제</th>
				<td>
					<div class="form-control-box">
						<label><input type="checkbox"
							name="deleteFile__article__${article.id}__common__attachment__1"
							value="Y" /> 삭제 </label>
					</div>
				</td>
			</tr>
			<tr>
				<th>첨부 파일 2</th>
				<td>
					<div class="form-control-box">
						<input type="file" accept="video/*"
							name="file__article__${article.id}__common__attachment__2" />
					</div> <c:if
						test="${article.extra.file__common__attachment['2'] != null}">
						<div class="video-box">
							<video controls
								src="/usr/file/streamVideo?id=${article.extra.file__common__attachment['2'].id}">video
								not supported
							</video>
						</div>
					</c:if>
				</td>
			</tr>
			<tr>
				<th>첨부 파일 2 삭제</th>
				<td>
					<div class="form-control-box">
						<label><input type="checkbox"
							name="deleteFile__article__${article.id}__common__attachment__2"
							value="Y" /> 삭제 </label>
					</div>
				</td>
			</tr>
		</tbody>
	</table>

	<div class="btn-box margin-top-20">
		<button type="submit" class="btn btn-primary">수정</button>
	</div>
</form>

<%@ include file="../part/foot.jspf"%>