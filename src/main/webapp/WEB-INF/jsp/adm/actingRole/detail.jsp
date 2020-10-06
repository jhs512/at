<%@ page import="com.sbs.jhs.at.util.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="배역정보" />
<%@ include file="../part/head.jspf"%>

<div class="actingRole-detail-box table-box table-box-vertical con">
	<table>
		<colgroup>
			<col class="table-first-col">
		</colgroup>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${actingRole.id}</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${actingRole.regDate}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${actingRole.forPrintTitle}</td>
			</tr>
			<tr>
				<th>artworkId</th>
				<td>${actingRole.artworkId}</td>
			</tr>
			<tr>
				<th>name</th>
				<td>${actingRole.name}</td>
			</tr>
			
			<tr>
				<th>age</th>
				<td>${actingRole.age}</td>
			</tr>
			
			<tr>
				<th>gender</th>
				<td>${actingRole.gender}</td>
			</tr>
			
			<tr>
				<th>character</th>
				<td>${actingRole.character}</td>
			</tr>
			
			<tr>
				<th>scenesCount</th>
				<td>${actingRole.scenesCount}</td>
			</tr>
			<tr>
				<th>scriptStatus</th>
				<td>${actingRole.scriptStatus}</td>
			</tr>
			<tr>
				<th>auditionStatus</th>
				<td>${actingRole.auditionStatus}</td>
			</tr>
			<tr>
				<th>shootingsCount</th>
				<td>${actingRole.shootingsCount}</td>
			</tr>
			<tr>
				<th>etc</th>
				<td>${actingRole.etc}</td>
			</tr>
		</tbody>
	</table>
</div>

<div class="btn-box con margin-top-20">
	<a class="btn btn-info" href="modify?id=${actingRole.id}&listUrl=${Util.getUriEncoded(listUrl)}">수정</a>
	<a class="btn btn-danger" href="doDelete?id=${actingRole.id}&listUrl=${Util.getUriEncoded(listUrl)}" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;">삭제</a>
	
	<a href="${listUrl}" class="btn btn-info">목록</a>
</div>

<%@ include file="../part/foot.jspf"%>