<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="신규 오디션 리스트" />
<%@ include file="../part/head.jspf"%>
<!-- PC용 -->
<div class="table-box table-box-data con">
	<table>
		<colgroup>
			<col width="100" />
			<col width="200" />
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>제목</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${recruitments}" var="recruitment">
				<tr>
					<td>${recruitment.id}</td>
					<td>${recruitment.regDate}</td>
					<td>
						<a href="${recruitment.getDetailLink(job.code)}" class="block width-100p text-overflow-el">${recruitment.forPrintTitle}</a>
					</td>
					<td class="visible-on-sm-down">
						<a href="${recruitment.getDetailLink(job.code)}" class="flex flex-row-wrap flex-ai-c">
							<span class="badge badge-primary bold margin-right-10">${recruitment.id}</span>
							<div class="title flex-1-0-0 text-overflow-el">${recruitment.forPrintTitle}</div>
							<div class="width-100p"></div>
							<div class="writer">${recruitment.extra.writer}</div>
							&nbsp;|&nbsp;
							<div class="reg-date">${recruitment.regDate}</div>
						</a>
					</td>
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
		<a class="btn btn-primary" href="./${job.code}-write">신규 모집</a>
	</c:if>
</div>
<%@ include file="../part/foot.jspf"%>