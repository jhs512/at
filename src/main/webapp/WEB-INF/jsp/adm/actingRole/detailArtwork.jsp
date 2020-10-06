<%@ page import="com.sbs.jhs.at.util.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="작품정보" />
<%@ include file="../part/head.jspf"%>

<div class="artwork-detail-box table-box table-box-vertical con">
	<table>
		<colgroup>
			<col class="table-first-col">
		</colgroup>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${artwork.id}</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${artwork.regDate}</td>
			</tr>
			<tr>
				<th>name</th>
				<td>${artwork.name}</td>
			</tr>
			
			<tr>
				<th>productionName</th>
				<td>${artwork.productionName}</td>
			</tr>
			
			<tr>
				<th>directorName</th>
				<td>${artwork.directorName}</td>
			</tr>
			
			<tr>
				<th>etc</th>
				<td>${artwork.etc}</td>
			</tr>
		</tbody>
	</table>
</div>

<div class="btn-box con margin-top-20">
	<a class="btn btn-info" href="modifyArtwork?id=${artwork.id}&listUrl=${Util.getUriEncoded(listUrl)}">수정</a>
	<a class="btn btn-danger" href="doDeleteArtwork?id=${artwork.id}&listUrl=${Util.getUriEncoded(listUrl)}" onclick="if ( confirm('삭제하시겠습니까?') == false ) return false;">삭제</a>
	
	<a href="${listUrl}" class="btn btn-info">목록</a>
</div>

<%@ include file="../part/foot.jspf"%>