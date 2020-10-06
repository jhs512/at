<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="작품 리스트" />
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
            <c:forEach items="${artworks}" var="artwork">
                <tr>
                    <td>${artwork.id}</td>
                    <td>${artwork.regDate}</td>
                    <td>
                        <a href="${artwork.getDetailLink()}" class="block width-100p text-overflow-el">${artwork.forPrintTitle}</a>
                    </td>
                    <td class="visible-on-sm-down">
                        <a href="${artwork.getDetailLink()}" class="flex flex-row-wrap flex-ai-c">
                            <span class="badge badge-primary bold margin-right-10">${artwork.id}</span>
                            <div class="title flex-1-0-0 text-overflow-el">${artwork.forPrintTitle}</div>
                            <div class="width-100p"></div>
                            <div class="writer">${artwork.extra.writer}</div>
                            &nbsp;|&nbsp;
                            <div class="reg-date">${artwork.regDate}</div>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<div class="btn-box con margin-top-20">
    <a class="btn btn-primary" href="./writeArtwork">작품추가</a>
</div>
<%@ include file="../part/foot.jspf"%>