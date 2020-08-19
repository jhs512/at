<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${job.name} 모집 리스트" />
<%@ include file="../part/head.jspf"%>

<!-- PC용 -->
<div class="table-box con visible-on-md-up">
	<table>
		<colgroup>
			<col width="100" />
			<col width="200" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>배역</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${recruitments}" var="recruitment">
				<tr>
					<td>${recruitment.id}</td>
					<td>${recruitment.regDate}</td>
					<td><a href="${recruitment.getDetailLink(job.code)}">${recruitment.forPrintTitle}</a></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<!-- 모바일 용 -->
<div class="table-box con visible-on-sm-down">
	<table>
		<thead>
			<tr>
				<th>번호</th>
				<th>제목</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${recruitments}" var="recruitment">
				<tr>
					<td>${recruitment.id}</td>
					<td><a href="${recruitment.getDetailLink(job.code)}">${recruitment.forPrintTitle}</a>
						<br /> 날짜 : ${recruitment.regDate} <br /> 작성 :
						${recruitment.extra.writer}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>

<style>
.btn-box:empty {
	display: none;
}
</style>

<div class="btn-box con margin-top-20">
	<c:if test="${actorCanWrite}">
		<a class="btn btn-primary" href="./${job.code}-write">새 모집공고</a>
	</c:if>
</div>

<%@ include file="../part/foot.jspf"%>