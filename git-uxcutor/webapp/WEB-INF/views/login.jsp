<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">

$(document).ready(function(){
	
	if('${loginCheck}' == 'F') {
		alert("아이디/비밀번호가 확인 되지 않습니다.");
	}
	
	$("#login").click(function(){
		if(!$("#id").val()){
			alert("아이디를 입력해주세요.");
			$("#id").focus();
	 		return false;
		} else if(!$("#password").val()){
			alert("비밀번호를 입력해주세요. ");
			$("#password").focus();
			return false; 
		} else {
			var data = $("#sendForm").serializeArray();

			$.ajax({
				type : "POST",
				url : "loginForm.htm",
				data : data,
				success : function(response) {
					$("#loading").hide();
					$("#loginBefore").hide();
					$("#loginAfter").show();
					$("#center").html(response);
					return false;
				},
				error : function() {
					$("#loading").hide();
					alert("메뉴를 다시 선택해주세요.");
					return false;
				}
			});
			
			
		}
	});	
});

function goFindPassword()
{
	window.open("", "popup", "width=850px,height=600"
			+ "px,menubar=no,status=no,scrollbars=no,location=no,resizable=no");
	$("form").attr({
		action : "findPasswordForm.htm",
		method : "POST",
		target : "popup"
	}).submit();
	
	
}

</script>
<form name="sendForm" id="sendForm" method="post">
<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > LOGIN
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">User Login</h2>
			</div>                            

			<!-- /clear-block -->
			<div class="clear-block">
				<div>
					<div class="form-item" id="edit-name-wrapper">
						<label id="edit-name">Id
						<span class="form-required" title="This field is required.">*</span>
						</label>
						<input type="text" name="id" id="id" size="20" value="test" class="form-text required">						
					</div>
					<div class="description">Enter your id.</div>
							
					<div class="form-item" id="edit-pass-wrapper">
						<label id="edit-pass">Password
						<span class="form-required" title="This field is required.">*</span>
						</label>
						<input type="password" name="password" id="password" maxlength="20" size="20" value="1234" class="form-text required">						
					</div>
					<div class="description">Enter your password.</div>
				</div>	
				
				<div class="form-item">	
					<a href="#" id="login" class="form-submit">Log in</a>
				</div>
			</div>
			<!-- clear-block/ -->
			
		</div>
	</div>
</div>
</form>