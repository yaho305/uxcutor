<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<input type="hidden" name="curPage" id="curPage" value="${pageHandler.curPage}"/>
<c:if test="${pageHandler.numbPageUrlList.size() >0}"> 
<div class="paginate">
	<a href="#" class="pre_end" onclick="javascript:goPage('${pageHandler.startPage}');return false;">처음</a>
	<a href="#" class="pre" onclick="javascript:goPage('${pageHandler.prevPage}');return false;">이전</a>
	<c:forEach items="${pageHandler.numbPageUrlList}" var="numbPageList">
		<c:choose>
			<c:when test="${pageHandler.curPage == numbPageList.pageNumb}">
				<strong>${numbPageList.pageNumb}</strong>
			</c:when>
			<c:otherwise>
				<a href="#" onclick="javascript:goPage('${numbPageList.pageNumb}');return false;">${numbPageList.pageNumb}</a>
			</c:otherwise>
		</c:choose>
	</c:forEach>
	<a href="#" class="next" onclick="javascript:goPage('${pageHandler.nextPage}');return false;">다음</a>
	<a href="#" class="next_end" onclick="javascript:goPage('${pageHandler.endPage}');return false;">끝</a>
</div>
</c:if>
