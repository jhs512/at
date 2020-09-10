<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="배역 리스트" />
<%@ include file="../part/head.jspf"%>
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
            <c:forEach items="${actingRoles}" var="actingRole">
                <tr>
                    <td>${actingRole.id}</td>
                    <td>${actingRole.regDate}</td>
                    <td>
                        <a href="${actingRole.getDetailLink()}" class="block width-100p text-overflow-el">${actingRole.forPrintTitle}</a>
                    </td>
                    <td class="visible-on-sm-down">
                        <a href="${actingRole.getDetailLink()}" class="flex flex-row-wrap flex-ai-c">
                            <span class="badge badge-primary bold margin-right-10">${actingRole.id}</span>
                            <div class="title flex-1-0-0 text-overflow-el">${actingRole.forPrintTitle}</div>
                            <div class="width-100p"></div>
                            <div class="writer">${actingRole.extra.writer}</div>
                            &nbsp;|&nbsp;
                            <div class="reg-date">${actingRole.regDate}</div>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<div class="btn-box con margin-top-20">
    <a class="btn btn-primary" href="./write">배역추가</a>
</div>
<%@ include file="../part/foot.jspf"%>