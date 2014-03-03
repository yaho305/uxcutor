<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script type="text/javascript">
$(document).ready(function(){
	$("a#insert").click(function(){
		$("#auth").val();
		var data = $("#scForm").serializeArray();
		
		if($("#id").val()==""){
			alert("아이디를 입력하여 주시기 바랍니다.");
			$("#id").focus();
			return false;
		}

		if($("#password").val()==""){
			alert("비밀번호를 입력하여 주시기 바랍니다.");
			$("#password").focus();
			return false;
		} 
		
		if($("#password").val().length < 4){
			alert("비밀번호는 4글자 이상 입력할 수 있습니다.");
			$("#password").focus();
			return false;
		}
		
		if($("#password").val().length > 32){
			alert("비밀번호는 최대 32글자까지 입력할 수 있습니다.");
			$("#password").focus();
			return false;
		}		
		
		if($("#repassword").val()==""){
			alert("비밀번호확인을 입력하여 주시기 바랍니다.");
			$("#repassword").focus();
			return false;
		}

		if($("#repassword").val().length > 32){
			alert("비밀번호 확인은 최대 32글자까지 입력할 수 있습니다.");
			$("#repassword").focus();
			return false;
		} 
		
		if($("#password").val() != $("#repassword").val()){
			alert("비밀번호가 동일 하지 않습니다. 다시 입력하여 주시기 바랍니다.");
			$("#password").focus();
			return false;
		}

		if($("#name").val()==""){
			alert("이름을 입력하여 주시기 바랍니다.");
			$("#name").focus();
			return false;
		}
		
		/* if($("#chk").val()==""){
			alert("아이디 중복체크를 확인하여 주시기 바랍니다.");
			$("#id").focus();
			return false;		
		}	 */

		ProcessPage("user/insert.htm",data,"user/list.htm");
	});
});

	function goList()
	{
		var data = $("#scForm").serializeArray();
		MovePage("operator/list.htm", data);
	}
	
	function goCheckId(){
		var id = $("#id").val();
		
		if(id == ""){
			alert("아이디를 입력하여 주시기 바랍니다.");
			$("#id").focus();
			return false;
		}
		popUp("300", "200", $("#scForm"), "operator/check.htm");
	}
	
</script>

<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > User
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">User List</h2>
			</div>       
			<form name="scForm" id="scForm">
				<input type="hidden" name="chk" id="chk" />
				<input type="hidden" name="curPage" id="curPage" value="${curPage}"/>
					<fieldset class="table_field">
						<div class="form_table">
							<table summary="사용자 정보">
								<caption>사용자 정보</caption>
								<colgroup>
								<col width="140"><col>
								<col width="120"><col>
								</colgroup>
								<tbody>
									<tr class="underline">
										<th scope="row"><label for="id">ID</label></th>
										<td>
											<div class="item">
												<input type="text" id="id" name="id" class="i_text" style="ime-mode: disabled;" onKeyDown="onNotText(this);" >
												<!-- <span class="btn_pack medium"><span class="check"></span><a href="#" onClick="goCheckId();">중복체크</a></span> -->
											</div>
										</td>
									</tr>
									<tr class="underline">
										<th scope="row"><label for="password">비밀번호</label></th>
										<td>
											<div class="item">
												<input type="password" id="password" name="password" title="비밀번호는 최대 32자리까지 입력 가능합니다." class="i_text" maxlength="32">
											</div>
										</td>
									</tr>
									<tr class="underline">
										<th scope="row"><label for="repassword">비밀번호 확인</label></th>
										<td>
											<div class="item">
												<input type="password" id="repassword" name="repassword" title="비밀번호 확인" class="i_text" maxlength="32"> 
											</div>
										</td>
									</tr>
									<tr class="underline">
										<th scope="row"><label for="name">이름</label></th>
										<td>
											<div class="item">
												<input type="text" id="name" name="name" title="이름" class="i_text" maxlength="16">
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</fieldset>
				</form>
				<!-- 버튼 -->
				<div class="btn_center">
					<span class="btn_pack medium"><span class="edit"></span><a class="button" href="#" id="insert" onclick="goInsert();">등록</a></span>
					<span class="btn_pack medium"><span class="list"></span><a class="button" href="#" onClick="goList();">목록</a></span>
				</div>
				<!-- //버튼 -->
		</div>
	</div>
</div>
