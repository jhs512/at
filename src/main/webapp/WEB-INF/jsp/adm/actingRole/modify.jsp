<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sbs.jhs.at.util.Util"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="배역추가" />
<%@ include file="../part/head.jspf"%>
<%@ include file="../../part/toastuiEditor.jspf"%>

<script>
	function ActingRoleModifyForm__submit(form) {
		if (isNowLoading()) {
			alert('처리중입니다.');
			return;
		}

		startLoading();

        form.submit();
	}
</script>
<form name="acting-role-modify-form" method="POST" class="table-box table-box-vertical con form1" action="doModify" onsubmit="ActingRoleModifyForm__submit(this); return false;">
	<input type="hidden" name="id" value="${actingRole.id}">
	<input type="hidden" name="redirectUri" value="detail?id=${actingRole.id}">
	<table>
		<colgroup>
			<col class="table-first-col">
			<col />
		</colgroup>
		<tbody>
            <tr>
				<th>배역번호</th>
				<td>
					${actingRole.id}
				</td>
			</tr>
            <tr>
				<th>작품</th>
				<td>
					${actingRole.extra.artworkName}
				</td>
			</tr>
            <tr>
				<th>이름</th>
				<td>
					<div class="form-control-box">
						<input value="${actingRole.name}" type="text" placeholder="이름을 입력해주세요." name="name" maxlength="100" />
					</div>
				</td>
			</tr>
            <tr>
                <th>나이</th>
                <td>
                    <div class="form-control-box">
                        <input value="${actingRole.age}" type="text" placeholder="나이를 입력해주세요." name="age" maxlength="100" />
                    </div>
                </td>
            </tr>
            <tr>
                <th>성별</th>
                <td>
                    <div class="form-control-box">
                        <select name="gender">
                            <option value="">미정</option>
                            <option value="남">남</option>
                            <option value="여">여</option>
                        </select>
                        <script>
                        $('form[name="acting-role-modify-form"] select[name="gender"]').val('${actingRole.gender}');
                        </script>
                    </div>
                </td>
            </tr>
            <tr>
                <th>캐릭터</th>
                <td>
                    <div class="form-control-box">
                        <textarea maxlength="300" name="character" placeholder="캐릭터를 입력해주세요." class="height-300">${actingRole.character}</textarea>
                    </div>
                </td>
            </tr>
            <tr>
                <th>씬수</th>
                <td>
                    <div class="form-control-box">
                        <input type="text" placeholder="씬수를 입력해주세요." name="scenesCount" maxlength="100" value="${actingRole.scenesCount}" />
                    </div>
                </td>
            </tr>
            <tr>
                <th>대사유무</th>
                <td>
                    <div class="form-control-box">
                        <select name="scriptStatus">
                            <option value="1">있음</option>
                            <option value="0">없음</option>
                        </select>
                        <script>
                        $('form[name="acting-role-modify-form"] select[name="scriptStatus"]').val('${Util.getOneOrZero(actingRole.scriptStatus)}');
                        </script>
                    </div>
                </td>
            </tr>
            <tr>
                <th>오디션유무</th>
                <td>
                    <div class="form-control-box">
                        <select name="auditionStatus">
                            <option value="1">있음</option>
                            <option value="0">없음</option>
                        </select>
                        <script>
                        $('form[name="acting-role-modify-form"] select[name="auditionStatus"]').val('${Util.getOneOrZero(actingRole.auditionStatus)}');
                        </script>
                    </div>
                </td>
            </tr>
            <tr>
                <th>촬영수</th>
                <td>
                    <div class="form-control-box">
                        <input type="text" placeholder="촬영수를 입력해주세요." name="shootingsCount" maxlength="100" value="${actingRole.shootingsCount}" />
                    </div>
                </td>
            </tr>
            <tr>
                <th>캐릭터</th>
                <td>
                    <div class="form-control-box">
                        <textarea maxlength="300" name="etc" placeholder="기타를 입력해주세요." class="height-300">${actingRole.etc}</textarea>
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