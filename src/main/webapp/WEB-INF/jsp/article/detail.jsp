<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="게시물 상세내용" />
<%@ include file="../part/head.jspf"%>

<div class="table-box con">
	<table>
		<tbody>
			<tr>
				<th>번호</th>
				<td>${article.id}</td>
			</tr>
			<tr>
				<th>날짜</th>
				<td>${article.regDate}</td>
			</tr>
			<tr>
				<th>제목</th>
				<td>${article.title}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${article.body}</td>
			</tr>
		</tbody>
	</table>
</div>

<c:if test="${isLogined}">
	<h2 class="con">댓글 작성</h2>

	<script>
		function ArticleWriteReplyForm__submit(form) {
			form.body.value = form.body.value.trim();
			if (form.body.value.length == 0) {
				alert('댓글을 입력해주세요.');
				form.body.focus();
				return;
			}

			$.post('./doWriteReplyAjax', {
				articleId : param.id,
				body : form.body.value
			}, function(data) {

			}, 'json');
			form.body.value = '';
		}
	</script>

	<form class="table-box con form1" action=""
		onsubmit="ArticleWriteReplyForm__submit(this); return false;">

		<table>
			<tbody>
				<tr>
					<th>내용</th>
					<td>
						<div class="form-control-box">
							<textarea maxlength="300" name="body" placeholder="내용을 입력해주세요."
								class="height-300"></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th>작성</th>
					<td><input type="submit" value="작성"></td>
				</tr>
			</tbody>
		</table>
	</form>

</c:if>

<h2 class="con">댓글 리스트</h2>

<div class="article-reply-list-box table-box con">
	<table>
		<colgroup>
			<col width="80">
			<col width="180">
			<col width="180">
			<col>
			<col width="200">
		</colgroup>
		<thead>
			<tr>
				<th>번호</th>
				<th>날짜</th>
				<th>작성자</th>
				<th>내용</th>
				<th>비고</th>
			</tr>
		</thead>
		<tbody>

		</tbody>
	</table>
</div>

<script>
	var ArticleReplyList__$box = $('.article-reply-list-box');
	var ArticleReplyList__$tbody = ArticleReplyList__$box.find('tbody');

	var ArticleReplyList__lastLodedId = 0;

	function ArticleReplyList__loadMore() {

		$
				.get(
						'getForPrintArticleReplies',
						{
							articleId : param.id,
							from : ArticleReplyList__lastLodedId + 1
						},
						function(data) {
							if (data.body.articleReplies
									&& data.body.articleReplies.length > 0) {
								ArticleReplyList__lastLodedId = data.body.articleReplies[data.body.articleReplies.length - 1].id;
								ArticleReplyList__drawReplies(data.body.articleReplies);
							}

							setTimeout(ArticleReplyList__loadMore, 2000);
						}, 'json');
	}

	function ArticleReplyList__drawReplies(articleReplies) {
		for (var i = 0; i < articleReplies.length; i++) {
			var articleReply = articleReplies[i];
			ArticleReplyList__drawReply(articleReply);
		}
	}

	function ArticleReplyList__delete(el) {
		if ( confirm('삭제 하시겠습니까?') == false ) {
			return;
		}
		
		var $tr = $(el).closest('tr');
		
		var id = $tr.attr('data-id');

		$.post(
			'./doDeleteReplyAjax',
			{
				id:id
			},
			function(data) {
				$tr.remove();
			},
			'json'
		);
	}

	function ArticleReplyList__drawReply(articleReply) {
		var html = '';
		html += '<tr data-id="' + articleReply.id + '">';
		html += '<td>' + articleReply.id + '</td>';
		html += '<td>' + articleReply.regDate + '</td>';
		html += '<td>' + articleReply.extra.writer + '</td>';
		html += '<td>' + articleReply.body + '</td>';
		html += '<td><button onclick="ArticleReplyList__delete(this);">삭제</button></td>';
		html += '</tr>';

		ArticleReplyList__$tbody.prepend(html);
	}

	ArticleReplyList__loadMore();
</script>

<%@ include file="../part/foot.jspf"%>