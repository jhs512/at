<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="아이디/비번찾기" />
<%@ include file="../part/head.jspf"%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>
<h2 class="con">아이디 찾기</h2>
<script>
	function MemberFindLoginIdForm__submit(form) {
		if (isNowLoading()) {
			alert('처리중입니다.');
			return;
		}

		form.name.value = form.name.value.trim();
		form.name.value = form.name.value.replaceAll('-', '');
		form.name.value = form.name.value.replaceAll('_', '');
		form.name.value = form.name.value.replaceAll(' ', '');

		if (form.name.value.length == 0) {
			form.name.focus();
			alert('이름을 입력해주세요.');

			return;
		}

		form.email.value = form.email.value.trim();
		form.email.value = form.email.value.replaceAll(' ', '');

		if (form.email.value.length == 0) {
			form.email.focus();
			alert('이메일을 입력해주세요.');

			return;
		}

		form.submit();
		startLoading();
	}
</script>
<form method="POST" class="table-box table-box-vertical con form1" action="doFindLoginId" onsubmit="MemberFindLoginIdForm__submit(this); return false;">
    <input type="hidden" name="redirectUri" value="${param.redirectUri}">
    <table>
        <colgroup>
            <col class="table-first-col">
        </colgroup>
        <tbody>
            <tr>
                <th>이름(실명)</th>
                <td>
                    <div class="form-control-box">
                        <input type="text" placeholder="이름을 입력해주세요. 입력해주세요." name="name" maxlength="30" autofocus="autofocus" />
                    </div>
                </td>
            </tr>
            <tr>
                <th>이메일주소</th>
                <td>
                    <div class="form-control-box">
                        <input type="email" placeholder="이메일을 입력해주세요." name="email" maxlength="50" />
                    </div>
                </td>
            </tr>
            <tr class="tr-do">
                <th>찾기</th>
                <td>
                    <button class="btn btn-primary" type="submit">찾기</button>
                    <button class="btn btn-info" onclick="history.back();" type="button">취소</button>
                </td>
            </tr>
        </tbody>
    </table>
</form>
<h2 class="con">비번 찾기</h2>
<%@ include file="../part/foot.jspf"%>