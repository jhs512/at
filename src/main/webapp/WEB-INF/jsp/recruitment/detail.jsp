<%@ page import="com.sbs.jhs.at.util.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="${job.name} 모집 상세내용" />
<%@ include file="../part/head.jspf"%>
<%@ include file="../part/toastuiEditor.jspf"%>
<script>
    var ApplymentList__needToLoadMore = '${needToLoadMore}' == 'true';
    var actorIsWriter = '${actorIsWriter}' == 'true';
</script>
<style>
.visible-actor-is-writer {
    display: <%=(boolean) request.getAttribute("actorIsWriter") ? "inline" : "none"%>;
}

.visible-actor-is-not-writer {
    display: <%=(boolean) request.getAttribute("actorIsWriter") ? "none" : "inline"%>;
}
</style>
<style>
.recruitment-detail-box td:empty {
    background-color: #efefef;
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
				<td><span class="badge badge-primary bold">${recruitment.id}</span></td>
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
				<th>배역캐릭터</th>
				<td>${Util.safeHtmlNl2Br(recruitment.extra.actingRoleCharacter)}</td>
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
			<tr>
				<th>특이 사항</th>
				<td>
					<script type="text/x-template">${recruitment.body}</script>
					<div class="toast-editor toast-editor-viewer"></div>
				</td>
			</tr>
			<c:forEach var="i" begin="1" end="${appConfig.getMaxAttachmentFileNo('recruitment')}" step="1">
				<c:set var="fileNo" value="${String.valueOf(i)}" />
				<c:set var="file" value="${recruitment.extra.file__common__attachment[fileNo]}" />
				<c:if test="${file != null}">
					<tr>
						<th>첨부 파일 ${fileNo}</th>
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
	<c:if test="${recruitment.extra.actorCanSetComplete}">
		<a class="btn btn-danger" href="${job.code}-doSetComplete?id=${recruitment.id}&redirectUri=${Util.getUriEncoded(listUrl)}" onclick="if ( confirm('모집완료처리 하시겠습니까?\n더 이상 지원자들이 지원할 수 없습니다.') == false ) return false;">모집완료</a>
	</c:if>
	<c:if test="${recruitment.extra.actorCanModify}">
		<a class="btn btn-info" href="${job.code}-modify?id=${recruitment.id}&listUrl=${Util.getUriEncoded(listUrl)}">수정</a>
	</c:if>
	<c:if test="${recruitment.extra.actorCanDelete}">
		<a class="btn btn-danger" href="${job.code}-doDelete?id=${recruitment.id}&redirectUri=${Util.getUriEncoded(listUrl)}" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;">삭제</a>
	</c:if>
	<a href="${listUrl}" class="btn btn-info">리스트</a>
</div>
<c:if test="${actorIsWriter}">
	<h2 class="con">해당 배역 신청</h2>
	<div class="con">작성자는 신청할 수 없습니다.</div>
</c:if>
<c:if test="${needToShowApplymentWriteForm && recruitment.completeStatus == false}">
	<script>
        function WriteApplymentForm__submit(form) {
            if (isNowLoading()) {
                alert('처리중입니다.');
            }

            form.body.value = form.body.value.trim();

            if (form.file__applyment__0__common__attachment__1 && form.file__applyment__0__common__attachment__1.value == '') {
                form.file__applyment__0__common__attachment__1.focus();
                alert('파일을 업로드 해주세요.');

                return;
            }

            startLoading();

            var startUploadFiles = function(onSuccess) {
                var needToUpload = false;

                if (needToUpload == false && form.file__applyment__0__common__attachment__1) {
                    needToUpload = form.file__applyment__0__common__attachment__1 && form.file__applyment__0__common__attachment__1.value.length > 0;
                }

                if (needToUpload == false && form.file__applyment__0__common__attachment__2) {
                    needToUpload = form.file__applyment__0__common__attachment__2 && form.file__applyment__0__common__attachment__2.value.length > 0;
                }

                if (needToUpload == false && form.file__applyment__0__common__attachment__3) {
                    needToUpload = form.file__applyment__0__common__attachment__3 && form.file__applyment__0__common__attachment__3.value.length > 0;
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

            var startWriteApplyment = function(fileIdsStr, onSuccess) {

                $.ajax({
                    url : './../applyment/doWriteApplymentAjax',
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

                startWriteApplyment(idsStr, function(data) {

                    if (data.msg) {
                        alert(data.msg);
                    }

                    form.body.value = '';

                    if (form.file__applyment__0__common__attachment__1) {
                        form.file__applyment__0__common__attachment__1.value = '';
                    }

                    if (form.file__applyment__0__common__attachment__2) {
                        form.file__applyment__0__common__attachment__2.value = '';
                    }

                    if (form.file__applyment__0__common__attachment__3) {
                        form.file__applyment__0__common__attachment__3.value = '';
                    }

                    endLoading();

                    // 자동 리스트 갱신모드가 아닐 경우 수동으로 이번 한번만 갱신해준다.
                    if (ApplymentList__needToLoadMore == false) {
                        ApplymentList__loadMore();
                    }
                });
            });
        }
    </script>
	<h1 class="con">해당 배역 신청</h1>
	<form class="table-box table-box-vertical con form1 write-applyment-form" onsubmit="WriteApplymentForm__submit(this); return false;">
		<input type="hidden" name="relTypeCode" value="recruitment" />
		<input type="hidden" name="relId" value="${recruitment.id}" />
		<table>
			<colgroup>
				<col class="table-first-col">
			</colgroup>
			<tbody>
				<tr class="none">
					<th>인사말(30자 제한)</th>
					<td>
						<div class="form-control-box">
							<textarea maxlength="50" name="body" placeholder="인사말을 입력해주세요." class="height-50"></textarea>
						</div>
					</td>
				</tr>
				<c:forEach var="i" begin="1" end="${appConfig.getForUploadMaxAttachmentFileNo('applyment')}" step="1">
					<c:set var="fileNo" value="${String.valueOf(i)}" />
					<c:set var="fileExtTypeCode" value="${appConfig.getAttachmentFileExtTypeCode('applyment', i)}" />
					<tr>
						<th>${appConfig.getAttachmentFileInputDisplayName('applyment', i)}</th>
						<td>
							<div class="form-control-box">
								<input type="file" accept="${appConfig.getAttachemntFileInputAccept('recruitment', i)}" name="file__applyment__0__common__attachment__${fileNo}">
							</div>
						</td>
					</tr>
				</c:forEach>
				<tr class="tr-do">
					<th>신청</th>
					<td>
						<div class="btn-inline-box">
							<input class="btn btn-primary" type="submit" value="신청">
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</c:if>
<style>
.applyment-list-box tr .btn-toggle-applyment::after {
    content: "목록에서 숨기기";
}
.applyment-list-box tr .btn-toggle-applyment {
    background-color:#dc3540;
}

.applyment-list-box tr.hide {
    display: none;
}

.applyment-list-box.show-hide-items tr.hide {
    display: table-row;
}

@media ( max-width:800px ) {
    .applyment-list-box.show-hide-items tr.hide {
	    display: block;
	}
}

.applyment-list-box tr.hide .btn-toggle-applyment::after {
    content: "숨김 해제하기";
}
.applyment-list-box tr.hide .btn-toggle-applyment {    
    background-color:#17a2b8;
}
</style>
<h2 class="con">
	<span class="visible-actor-is-not-writer">본인 신청내역</span>
	<span class="visible-actor-is-writer">실시간 접수내역</span>
	<span class="visible-actor-is-writer applyments-count">(0건)</span>
</h2>
<div class="con">
	<label class="visible-actor-is-writer">
		<input type="checkbox" onchange="$('.applyment-list-box').toggleClass('show-hide-items');" />
		숨김처리한 내용 보기
		<span class="hidden-applyments-count">(0건)</span>
	</label>
</div>
<div class="applyment-list-box table-box table-box-data con margin-top-20">
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
				<th>신청일</th>
				<th>신청자</th>
				<th>지원배역 연기영상</th>
				<th>비고</th>
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
    display: none;
}

.applyment-modify-form-modal-actived .applyment-modify-form-modal {
    display: flex;
}

.applyment-modify-form-modal .video-box {
    width: 100px;
}

.applyment-modify-form-modal .img-box {
    width: 100px;
}
</style>
<div class="popup-1 applyment-modify-form-modal">
	<div>
		<h1>신청 수정</h1>
		<form action="" class="form1 table-box table-box-vertical" onsubmit="ApplymentList__submitModifyForm(this); return false;">
			<input type="hidden" name="id" />
			<table>
				<colgroup>
					<col class="table-first-col">
				</colgroup>
				<tbody>
					<tr>
						<th>인사말(30자 제한)</th>
						<td>
							<div class="form-control-box">
								<textarea maxlength="50" name="body" placeholder="내용을 입력해주세요." class="height-50"></textarea>
							</div>
						</td>
					</tr>
					<c:forEach var="i" begin="1" end="${appConfig.getForUploadMaxAttachmentFileNo('applyment')}" step="1">
						<c:set var="fileNo" value="${String.valueOf(i)}" />
						<c:set var="fileExtTypeCode" value="${appConfig.getAttachmentFileExtTypeCode('recruitment', i)}" />
						<tr>
							<th>
								<div class="form-control-box">첨부${fileNo}</div>
							</th>
							<td>
								<div class="form-control-box">
									<input type="file" accept="${appConfig.getAttachemntFileInputAccept('recruitment', i)}" data-name="file__applyment__0__common__attachment__${fileNo}">
								</div>
								<div style="width: 100%" class="video-box video-box-file-${fileNo}"></div>
								<div style="width: 100%" class="img-box img-box-auto img-box-file-${fileNo}"></div>
							</td>
						</tr>
						<tr>
							<th>
								<div class="form-control-box">첨부${fileNo} 삭제</div>
							</th>
							<td>
								<div class="form-control-box">
									<label>
										<input type="checkbox" data-name="deleteFile__applyment__0__common__attachment__${fileNo}" value="Y" />
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
							<button class="btn btn-info" type="button" onclick="ApplymentList__hideModifyFormModal();">취소</button>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
</div>
<script>
    var ApplymentList__$box = $('.applyment-list-box');
    var ApplymentList__$tbody = ApplymentList__$box.find('tbody');

    var ApplymentList__lastLodedId = 0;

    function ApplymentList__submitModifyForm(form) {
        if (isNowLoading()) {
            alert('처리중입니다.');
            return;
        }

        form.body.value = form.body.value.trim();

        var id = form.id.value;
        var body = form.body.value;

        var fileInput1 = form['file__applyment__' + id + '__common__attachment__1'];
        var fileInput2 = form['file__applyment__' + id + '__common__attachment__2'];
        var fileInput3 = form['file__applyment__' + id + '__common__attachment__3'];

        var deleteFileInput1 = form["deleteFile__applyment__" + id + "__common__attachment__1"];
        var deleteFileInput2 = form["deleteFile__applyment__" + id + "__common__attachment__2"];
        var deleteFileInput3 = form["deleteFile__applyment__" + id + "__common__attachment__3"];

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

            startModifyApplyment(fileIdsStr);
        };

        // 신청 수정 시작
        var startModifyApplyment = function(fileIdsStr) {
            $.post('../applyment/doModifyApplymentAjax', {
                id : id,
                body : body,
                fileIdsStr : fileIdsStr
            }, onModifyApplymentComplete, 'json');
        };

        // 신청 수정이 완료되면 실행되는 함수
        var onModifyApplymentComplete = function(data) {
            if (data.resultCode && data.resultCode.substr(0, 2) == 'S-') {
                // 성공시에는 기존에 그려진 내용을 수정해야 한다.!!
                $('.applyment-list-box tbody > tr[data-id="' + id + '"]').data('data-originBody', body);
                var selector;

                selector = '.applyment-list-box tbody > tr[data-id="' + id + '"] .applyment-body'
                $(selector).empty().append(body);

                selector = '.applyment-list-box tbody > tr[data-id="' + id + '"] .video-box'
                $(selector).empty();

                selector = '.applyment-list-box tbody > tr[data-id="' + id + '"] .img-box';
                $(selector).empty();

                if (data && data.body && data.body.file__common__attachment) {
                    for ( var fileNo in data.body.file__common__attachment) {
                        var file = data.body.file__common__attachment[fileNo];

                        if (file.fileExtTypeCode == 'video') {
                            var html = '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '">video not supported</video>';
                            selector = '.applyment-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].video-box';
                            $(selector).append(html);
                        } else {
                            var html = '<img src="/usr/file/img?id=' + file.id + '&updateDate=' + file.updateDate + '">';
                            selector = '.applyment-list-box tbody > tr[data-id="' + id + '"] [data-file-no="' + fileNo + '"].img-box';
                            $(selector).append(html);
                        }
                    }
                }
            }

            if (data.msg) {
                alert(data.msg);
            }

            ApplymentList__hideModifyFormModal();
            endLoading();

            // 자동 리스트 갱신모드가 아닐 경우 수동으로 이번 한번만 갱신해준다.
            if (ApplymentList__needToLoadMore == false) {
                ApplymentList__loadMore();
            }
        };

        startUploadFiles();
    }

    function ApplymentList__toggleItem(el) {
        var $tr = $(el).closest('tr');
        var id = $tr.attr('data-id');

        if ($tr.hasClass('hide')) {
            $.post('/usr/applyment/doSetVisible', {
                id : id,
                value : 'show'
            }, function(data) {
                $tr.removeClass('hide');

                ApplymentList__hiddenApplymentsCount--;
                $('.hidden-applyments-count').text('(' + ApplymentList__hiddenApplymentsCount + '건)');

            }, 'json');
        } else if ($tr.addClass('hide')) {
            $.post('/usr/applyment/doSetVisible', {
                id : id,
                value : 'hide'
            }, function(data) {
                $tr.addClass('hide');

                ApplymentList__hiddenApplymentsCount++;
                $('.hidden-applyments-count').text('(' + ApplymentList__hiddenApplymentsCount + '건)');
            }, 'json');
        }
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

            if ($el.prop('type') == 'file') {
                $el.val('');
            } else if ($el.prop('type') == 'checkbox') {
                $el.prop('checked', false);
            }
        });

        for (var fileNo = 1; fileNo <= 3; fileNo++) {
            $('.applyment-modify-form-modal .video-box-file-' + fileNo).empty();

            var videoName = 'applyment__' + id + '__common__attachment__' + fileNo;

            var $videoBox = $('.applyment-list-box [data-video-name="' + videoName + '"]');

            if ($videoBox.length > 0) {
                $('.applyment-modify-form-modal .video-box-file-' + fileNo).append($videoBox.html());
            }

            $('.applyment-modify-form-modal .img-box-file-' + fileNo).empty();

            var imgName = 'applyment__' + id + '__common__attachment__' + fileNo;

            var $imgBox = $('.applyment-list-box [data-img-name="' + imgName + '"]');

            if ($imgBox.length > 0) {
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
    var ApplymentList__loadMoreInterval = 1 * 1000;
    var ApplymentList__applymentsCount = 0;
    var ApplymentList__hiddenApplymentsCount = 0;

    function ApplymentList__loadMoreCallback(data) {
        if (data.body.applyments && data.body.applyments.length > 0) {
            ApplymentList__lastLodedId = data.body.applyments[data.body.applyments.length - 1].id;
            ApplymentList__drawApplyments(data.body.applyments);
        }

        if (ApplymentList__needToLoadMore) {
            setTimeout(ApplymentList__loadMore, ApplymentList__loadMoreInterval);
        }
    }

    function ApplymentList__loadMore() {

        $.get('../applyment/getForPrintApplyments', {
            recruitmentId : param.id,
            from : ApplymentList__lastLodedId + 1
        }, ApplymentList__loadMoreCallback, 'json');
    }

    function ApplymentList__getMediaHtml(applyment) {
		var html = '';
		for (var fileNo = 1; fileNo <= 3; fileNo++) {
            var file = null;
            if (applyment.extra.file__common__attachment && applyment.extra.file__common__attachment[fileNo]) {
                file = applyment.extra.file__common__attachment[fileNo];
            }

            html += '<div class="video-box" data-video-name="applyment__' + applyment.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';

            if (file && file.fileExtTypeCode == 'video') {
                html += '<video controls src="/usr/file/streamVideo?id=' + file.id + '&updateDate=' + file.updateDate + '"></video>';
            }

            html += '</div>';

            html += '<div class="img-box img-box-auto" data-img-name="applyment__' + applyment.id + '__common__attachment__' + fileNo + '" data-file-no="' + fileNo + '">';

            if (file && file.fileExtTypeCode == 'img') {
                html += '<img src="/usr/file/img?id=' + file.id + '&updateDate=' + file.updateDate + '">';
            }

            html += '</div>';
        }

        return '<div class="media-box">' + html + "</div>";
	}

    function ApplymentList__drawApplyments(applyments) {
        for (var i = 0; i < applyments.length; i++) {
            var applyment = applyments[i];
            ApplymentList__drawApplyment(applyment);
        }
    }

    function ApplymentList__delete(el) {
        if (isNowLoading()) {
            alert('처리중입니다.');
        }
        
        if (confirm('삭제 하시겠습니까?') == false) {
            return;
        }

        var $tr = $(el).closest('tr');

        var id = $tr.attr('data-id');

        startLoading();

        $.post('./../applyment/doDeleteApplymentAjax', {
            id : id
        }, function(data) {
            if ( data.msg ) {
                alert(data.msg);
            }

			if ( data.resultCode.substr(0, 2) == 'S-' ) {
			    ApplymentList__applymentsCount--;
	            $('.applyments-count').text('(' + ApplymentList__applymentsCount + '건)');
	            $tr.remove();
			}
			
            endLoading();
        }, 'json');
    }

    function ApplymentList__drawApplyment(applyment) {
        ApplymentList__applymentsCount++;
        $('.applyments-count').text('(' + ApplymentList__applymentsCount + '건)');

        var html = '';
        var trClassStr = '';

        if (applyment.hideStatus) {
            trClassStr = 'hide';
            ApplymentList__hiddenApplymentsCount++;
            $('.hidden-applyments-count').text('(' + ApplymentList__hiddenApplymentsCount + '건)');
        }
        html += '<tr data-id="' + applyment.id + '" class="' + trClassStr + '">';
        html += '<td><span class="badge badge-primary bold">' + applyment.id + '</span></td>';
        html += '<td>' + applyment.regDate + '</td>';
        html += '<td>';
        html += '<div><strong>' + applyment.extra.writer + '</strong></div>';
        html += '<div>' + (applyment.extra.writerCellphoneNo ? applyment.extra.writerCellphoneNo : '전화번호없음') + '</div>';
        html += '<div>' + (applyment.extra.writerEmail ? applyment.extra.writerEmail : '이메일없음') + '</div>';
        html += '</td>';
        html += '<td>';
        html += '<div class="applyment-body">' + applyment.body + '</div>';

        html += ApplymentList__getMediaHtml(applyment);
        
        html += '</td>';
        html += '<td>';

        if (applyment.extra.actorCanDelete) {
            html += '<button class="btn btn-danger" type="button" onclick="ApplymentList__delete(this);">삭제</button>';
        }

        if (applyment.extra.actorCanModify) {
            html += '<button class="btn btn-info" type="button" onclick="ApplymentList__showModifyFormModal(this);">수정</button>';
        }

        if (applyment.extra.actorCanToggle) {
            html += '<button class="btn btn-info btn-toggle-applyment" type="button" onclick="ApplymentList__toggleItem(this);"></button>';
        }

        html += '</td>';

        html += '<td class="visible-on-sm-down">';

		html += '<div class="flex flex-row-wrap flex-ai-c">';
		html += '<span class="badge badge-primary bold margin-right-10">' + applyment.id + '</span>';
		html += '<div class="writer">' + applyment.extra.writer + '</div>';
		html += '&nbsp;|&nbsp;';
		html += '<div class="reg-date">' + applyment.regDate + '</div>';
		html += '<div class="width-100p"></div>';
		html += '<div class="body flex-1-0-0 margin-top-10 applyment-body">' + applyment.forPrintBody + '</div>';
		html += ApplymentList__getMediaHtml(applyment);
		html += '</div>';

		html += '<div class="margin-top-10 btn-inline-box">';

		if (applyment.extra.actorCanDelete) {
			html += '<button class="btn btn-danger" type="button" onclick="ApplymentList__delete(this);">삭제</button>';
		}

		if (applyment.extra.actorCanModify) {
			html += '<button class="btn btn-info" type="button" onclick="ApplymentList__showModifyFormModal(this);">수정</button>';
		}

		if (applyment.extra.actorCanToggle) {
            html += '<button class="btn btn-info btn-toggle-applyment" type="button" onclick="ApplymentList__toggleItem(this);"></button>';
        }

		html += '</div>';
        
        html += '</td>';
        
        html += '</tr>';

        var $tr = $(html);
        $tr.data('data-originBody', applyment.body);
        ApplymentList__$tbody.prepend($tr);
    }

    ApplymentList__loadMore();
</script>
<%@ include file="../part/foot.jspf"%>