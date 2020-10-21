<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="${job.name} 모집 수정" />
<%@ include file="../part/head.jspf"%>
<%@ include file="../../part/toastuiEditor.jspf"%>
<script>
	function RecruitmentModifyForm__submit(form) {
		if (isNowLoading()) {
			alert('처리중입니다.');
			return;
		}

		var fileInput1 = form["file__recruitment__" + param.id + "__common__attachment__1"];
		var fileInput2 = form["file__recruitment__" + param.id + "__common__attachment__2"];
		var fileInput3 = form["file__recruitment__" + param.id + "__common__attachment__3"];

		var deleteFileInput1 = form["deleteFile__recruitment__" + param.id + "__common__attachment__1"];
		var deleteFileInput2 = form["deleteFile__recruitment__" + param.id + "__common__attachment__2"];
		var deleteFileInput3 = form["deleteFile__recruitment__" + param.id + "__common__attachment__3"];

		if (fileInput1 && deleteFileInput1) {
			if (deleteFileInput1.checked) {
				fileInput1.value = '';
			}
		}

		if (fileInput2 && deleteFileInput2) {
			if (deleteFileInput2.checked) {
				fileInput2.value = '';
			}
		}

		if (fileInput3 && deleteFileInput3) {
			if (deleteFileInput3.checked) {
				fileInput3.value = '';
			}
		}

		form.title.value = form.title.value.trim();

		var bodyEditor = $(form).find('.toast-editor.input-body').data('data-toast-editor');

		var body = bodyEditor.getMarkdown().trim();

		if (body.length == 0) {
			bodyEditor.focus();
			alert('상세내용을 입력해주세요.');

			return;
		}

		form.body.value = body;

		var maxSizeMb = 50;
		var maxSize = maxSizeMb * 1024 * 1024 //50MB

		if (fileInput1 && fileInput1.value) {
			if (fileInput1.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		if (fileInput2 && fileInput2.value) {
			if (fileInput2.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		if (fileInput3 && fileInput3.value) {
			if (fileInput3.files[0].size > maxSize) {
				alert(maxSizeMb + "MB 이하의 파일을 업로드 해주세요.");
				return;
			}
		}

		var startUploadFiles = function(onSuccess) {
			var needToUpload = false;

			if (!needToUpload) {
				needToUpload = fileInput1 && fileInput1.value.length > 0;
			}

			if (!needToUpload) {
				needToUpload = deleteFileInput1 && deleteFileInput1.checked;
			}

			if (!needToUpload) {
				needToUpload = fileInput2 && fileInput2.value.length > 0;
			}

			if (!needToUpload) {
				needToUpload = deleteFileInput2 && deleteFileInput2.checked;
			}

			if (!needToUpload) {
				needToUpload = fileInput3 && fileInput3.value.length > 0;
			}

			if (!needToUpload) {
				needToUpload = deleteFileInput3 && deleteFileInput3.checked;
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

		startLoading();
		startUploadFiles(function(data) {
			var fileIdsStr = '';

			if (data && data.body && data.body.fileIdsStr) {
				fileIdsStr = data.body.fileIdsStr;
			}

			form.fileIdsStr.value = fileIdsStr;

			if (bodyEditor.inBodyFileIdsStr) {
				form.fileIdsStr.value += bodyEditor.inBodyFileIdsStr;
			}

			if (fileInput1) {
				fileInput1.value = '';
			}

			if (fileInput2) {
				fileInput2.value = '';
			}

			if (fileInput3) {
				fileInput3.value = '';
			}

			form.submit();
		});
	}
</script>
<style>
.recruitment-modify-box td:empty {
  background-color: #efefef;
}
</style>
<form class="table-box table-box-vertical recruitment-modify-box con form1" method="POST" action="${job.code}-doModify" onsubmit="RecruitmentModifyForm__submit(this); return false;">
    <input type="hidden" name="body" />
    <input type="hidden" name="fileIdsStr" />
    <input type="hidden" name="redirectUri" value="/usr/recruitment/${job.code}-detail?id=${recruitment.id}" />
    <input type="hidden" name="id" value="${recruitment.id}" />
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
                <th>모집상태</th>
                <td>${recruitment.forPrintCompleteStatusHanName}</td>
            </tr>
            <tr>
                <th>제목</th>
                <td>${recruitment.forPrintTitle}</td>
            </tr>
            <tr>
                <th>작품명</th>
                <td>${recruitment.extra.artworkName}</td>
            </tr>
            <tr>
                <th>제작사</th>
                <td>${recruitment.extra.productionName}</td>
            </tr>
            <tr>
                <th>배역명</th>
                <td>${recruitment.extra.actingRoleName}</td>
            </tr>
            <tr>
                <th>배역성별</th>
                <td>${recruitment.extra.actingRoleGender}</td>
            </tr>
            <tr>
                <th>배역나이</th>
                <td>${recruitment.extra.actingRoleAge}</td>
            </tr>
            <tr>
                <th>배역직업</th>
                <td>${recruitment.extra.actingRoleJob}</td>
            </tr>
            <tr>
                <th>배역씬수</th>
                <td>${recruitment.extra.actingRoleScenesCount}</td>
            </tr>
            <tr>
                <th>배역촬영수</th>
                <td>${recruitment.extra.actingRoleShootingsCount}</td>
            </tr>
            <tr>
                <th>출연료</th>
                <td>${recruitment.extra.actingRolePay}</td>
            </tr>
            <tr class="none">
                <th>제목</th>
                <td>
                    <div class="form-control-box">
                        <input type="text" value="${recruitment.title}" name="title" placeholder="제목을 입력해주세요." />
                    </div>
                </td>
            </tr>
            <tr>
                <th>상세내용</th>
                <td>
                    <div class="form-control-box">
                        <script type="text/x-template">${recruitment.body}</script>
                        <div data-relTypeCode="recruitment" data-relId="${recruitment.id}" class="toast-editor input-body"></div>
                    </div>
                </td>
            </tr>
            <c:forEach var="i" begin="1" end="3" step="1">
                <c:set var="fileNo" value="${String.valueOf(i)}" />
                <c:set var="file" value="${recruitment.extra.file__common__attachment[fileNo]}" />
                <tr>
                    <th>첨부파일 ${fileNo} ${appConfig.getAttachmentFileExtTypeDisplayName('recruitment', i)}</th>
                    <td>
                        <div class="form-control-box">
                            <input type="file" accept="${appConfig.getAttachemntFileInputAccept('recruitment', i)}" name="file__recruitment__${recruitment.id}__common__attachment__${fileNo}">
                        </div>
                        <c:if test="${file != null && file.fileExtTypeCode == 'video'}">
                            <div class="video-box">
                                <video preload="auto" controls src="${file.forPrintGenUrl}"></video>
                            </div>
                        </c:if>
                        <c:if test="${file != null && file.fileExtTypeCode == 'img'}">
                            <div class="img-box img-box-auto">
                                <img src="${file.forPrintGenUrl}">
                            </div>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th>첨부파일 ${fileNo} 삭제</th>
                    <td>
                        <div class="form-control-box">
                            <label> <input type="checkbox" name="deleteFile__recruitment__${recruitment.id}__common__attachment__${fileNo}" value="Y" /> 삭제
                            </label>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <div class="btn-box margin-top-20">
        <button type="submit" class="btn btn-primary">수정</button>
        <a class="btn btn-info" href="${listUrl}">리스트</a>
    </div>
</form>
<%@ include file="../part/foot.jspf"%>