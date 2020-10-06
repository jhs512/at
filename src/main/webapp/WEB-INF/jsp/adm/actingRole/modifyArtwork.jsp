<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sbs.jhs.at.util.Util"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="배역추가" />
<%@ include file="../part/head.jspf"%>
<%@ include file="../../part/toastuiEditor.jspf"%>

<script>
	function ArtworkModifyForm__submit(form) {
		if (isNowLoading()) {
			alert('처리중입니다.');
			return;
		}

		startLoading();

        form.submit();
	}
</script>
<form name="acting-role-modify-form" method="POST" class="table-box table-box-vertical con form1" action="doModifyArtwork" onsubmit="ArtworkModifyForm__submit(this); return false;">
	<input type="hidden" name="id" value="${artwork.id}">
	<input type="hidden" name="redirectUri" value="detailArtwork?id=${artwork.id}">
	<table>
		<colgroup>
			<col class="table-first-col">
			<col />
		</colgroup>
		<tbody>
            <tr>
				<th>번호</th>
				<td>
					${artwork.id}
				</td>
			</tr>
            <tr>
				<th>이름</th>
				<td>
					<div class="form-control-box">
						<input value="${artwork.name}" type="text" placeholder="이름을 입력해주세요." name="name" maxlength="100" />
					</div>
				</td>
			</tr>
			<tr>
				<th>감독명</th>
				<td>
					<div class="form-control-box">
						<input value="${artwork.directorName}" type="text" placeholder="감독명을 입력해주세요." name="directorName" maxlength="100" />
					</div>
				</td>
			</tr>
			<tr>
				<th>제작사명</th>
				<td>
					<div class="form-control-box">
						<input value="${artwork.productionName}" type="text" placeholder="제작사명을 입력해주세요." name="productionName" maxlength="100" />
					</div>
				</td>
			</tr>
            <tr>
                <th>기타</th>
                <td>
                    <div class="form-control-box">
                        <textarea maxlength="300" name="etc" placeholder="기타를 입력해주세요." class="height-300">${artwork.etc}</textarea>
                    </div>
                </td>
            </tr>
			<tr class="tr-do">
				<th>수정</th>
				<td>
					<button class="btn btn-primary" type="submit">수정</button>
					<a class="btn btn-info" href="${listUrl}">리스트</a>
				</td>
			</tr>
		</tbody>
	</table>
</form>

<%@ include file="../part/foot.jspf"%>