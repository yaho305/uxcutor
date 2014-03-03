<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<Script type="text/javascript">

$(document).ready(function(){
	if('${ADMIN_ID}' == '') {
		$("#center").html("");
		alert("로그인 후 이용해 주세요");
		MovePage("login.htm","");
		return false;
	}
});


var act = {
		 goView : function(id,user_id,status){ 
			
			 
			 if( status == '0'){
				 if( user_id != $("#ADMIN_ID").val()){
					 alert(user_id+" 님이 작업 중입니다.");
					 return false;
				 }
			 }
			 
			 $("#id").val(id);
			 MovePage("contents/view.htm",$("#sendForm").serializeArray());
			 return false;
       },
		 goTest : function(id){ 
			 //MovePage("contents/test.htm",$("#sendForm").serializeArray());
			 MovePage("contents/test.htm",$("#sendForm").serializeArray());
			 return false;
       },
       goInsertForm : function(){ 
			 MovePage("contents/insertForm.htm",$("#sendForm").serializeArray());
			 return false;
       }
   } 
   
function goPage(curPage){

	$("#curPage").val(curPage);
	var data = $("#sendForm").serializeArray();
	MovePage("contents/list.htm", data);
	return false;
}

function goDownLoad(filename){

	$("input[name='filename']").val(filename);
	$("#sendForm").submit();
}

</Script>

<form name="sendForm" id="sendForm" method="post" action="contents/download.htm">
<input type="hidden" name="id" id="id"/>
<input type="hidden" name="curPage" id="curPage" value="${pageHandler.curPage}"/>
<input type="hidden" name="ADMIN_ID" id="ADMIN_ID" value="${ADMIN_ID}"/>
<input type="hidden" name="filename"/>
<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > Contents
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">컨텐츠 리스트</h2>
			</div>       
		<table width="650" cellspacing="0" cellpadding="0" border="1" >
			<thead>
			    <tr height="22" align="center"  >
			        <td width="80" >컨텐츠ID</td>
			        <td>컨텐츠명</td>
			        <td width="100" >상태</td>
			        <td width="100" >작업자</td>
			        <td width="120" >생성일</td>
			        <td width="120" >수정일</td>
			        <td width="80" >다운로드</td>
			    </tr>  
		    </thead>      
			
			<c:choose>
				<c:when test="${empty list}">
					<tr height="22" align="center">
						<td colspan="5">컨텐츠가 없습니다.</td>
					</tr>
				</c:when>	
				<c:otherwise>
					<c:forEach items="${list}" var="contents">
						<tr height="22" align="center">
						   <td>${contents.id}</td>
						   <td><a href="#" onclick="javascript:act.goView('${contents.id}','${contents.user_id}','${contents.status}');">${contents.name}</a></td>
						   <td><c:if test="${contents.status=='0'}">작업중</c:if><c:if test="${contents.status=='1'}">완료</c:if></td>
						   <td><c:if test="${contents.status=='0'}">${contents.user_name}</c:if></td>
						   <td><fmt:formatDate value="${contents.create_time}" pattern="yyyy-MM-dd" /></td>
						   <td><fmt:formatDate value="${contents.update_time}" pattern="yyyy-MM-dd" /></td>
						   <td><c:if test="${fn:length(contents.xml_url)>0}">
						   		<a href="#" onclick="javascript:goDownLoad('${contents.xml_url}');">Down</a>
						   </c:if></td>
						</tr>			
					</c:forEach>
				</c:otherwise>					
			</c:choose>
			
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
		
		<div align="right">
			<div>

				<a href="#" class="button" onclick="javascript:act.goInsertForm();">등록</a>
			</div>
		</div>		
		</div>
	</div>
</div>
</form>
