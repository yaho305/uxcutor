<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<Script type="text/javascript">
$(document).ready(function(){
	if('${ADMIN_ID}' == '') {
		$("#center").html("");
		alert("로그인 후 이용해 주세요");
		MovePage("login.htm","");
		return false;
	}
});

	function goDetail(id){
		 $("#id").val(id);
		MovePage('user/updateForm.htm',$("#sendForm").serializeArray());
	}
	
	function goPage(curPage){

		$("#curPage").val(curPage);
		var data = $("#sendForm").serializeArray();
		MovePage("user/list.htm", data);
		return false;
	}
</Script>
<form name="sendForm" id="sendForm" method="post">
<input type="hidden" name="id" id="id"/>
<input type="hidden" name="curPage" id="curPage" value="${pageHandler.curPage}"/>
<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > User
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">User List</h2>
			</div>       
		<table>
			<thead>
				 <tr height="22" align="center"  >
			        <td width="40" >ID</td>
			        <td>name</td>
			        <td width="80" >create_time</td>
			    </tr> 
			</thead>
		    <tbody> 
			
				<c:choose>
					<c:when test="${empty list}">
						<tr height="22" align="center">
							<td colspan="5">서비스가 없습니다.</td>
						</tr>
					</c:when>	
					<c:otherwise>
						<c:forEach items="${list}" var="user">
							<tr height="22" align="center" onclick="javascript:goDetail('${user.id}');" style="cursor:hand">
							   <td width="150">${user.id}</td>
							   <td>${user.name}</td>
							   <td width="100"><fmt:formatDate value="${user.create_time}" pattern="yyyy-MM-dd" /></td>
							</tr>			
						</c:forEach>
					</c:otherwise>					
				</c:choose>
				
			</tbody>
		</table>
		
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
		
		<div>
			<a href="#" class="button" onclick="javascript:MovePage('user/insertForm.htm','');">regist</a>
		</div>	
	</div>
	</div>
</div>
</form>
