<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resources/common/include/header.inc"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Home</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/defaults.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/system.css">


	<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-1.11.0.min.js"></script>
	<script type="text/javascript">
	
		$(document).ready(function(){
			if('${ADMIN_ID}' == '') {
				MovePage("login.htm","");
			}else{
				$("#loginBefore").hide();
				$("#loginAfter").show();
				MovePage("contents/list.htm","");
			}
			
		});
		
		function MovePage(url, data) {
			$("#loading").show();
			 
			$.ajax({
				type : "POST",
				url : url,
				data : data,
				success : function(response) {
					$("#loading").hide();
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
		
		/*
		 * insert, update, delete
		 */
		function ProcessPage(url, data, re_url) {
			$("#loading").show();
			$.ajax({
				type : "POST",
				url : url,
				data : data,
				success : function(response) {
					$("#loading").hide();
					alert(response);
					if (re_url.length > 0) {
						MovePage(re_url, data);
					}
				},
				error : function() {
					$("#loading").hide();
					alert("메뉴를 다시 선택해주세요.");
					return false;
				}
			});
		}
		
		function LogOut(){
			$("#loading").show();
			
			$.ajax({
				type : "POST",
				url : "logout.htm",
				data : "",
				success : function(response) {
					$("#loading").hide();
					$("#loginBefore").show();
					$("#loginAfter").hide();
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
	</script>

</head>
<body class="sidebars">
<div id="loading"><img src="${pageContext.request.contextPath}/resources/images/ajax-loader.gif" alt=""></div>
<form name="mainForm" id="mainForm" method="post">
</form>
	<div id="wrapper">
		<div id="container" class="clear-block">
			<div id="header">
				<div id="logo-floater">
					<h1><a href="index.htm"><img src="${pageContext.request.contextPath}/resources/images/logo_uangel.png" width="80px" height="26px" id="logo" /></a></h1>
				</div>
			</div>
			<div id="sidebar-left" class="sidebar">
				<!-- user menu start -->
				<div id="block-user-1" class="clear-block block block-user">
					<h2>Menu</h2>
					<div id="menuList" class="content">
					</div>
				</div>
				<!-- user menu end -->
				<!-- admin menu start -->
				<div id="block-block-2" class="clear-block block block-block">
					<div id="hiddenMenu" class="content">
						<ul>
							<li class="leaf"><a href="#" onclick="javascript:MovePage('user/list.htm','');">User</a></li>
						</ul>
						<ul>
							<li class="leaf"><a href="#" onclick="javascript:MovePage('contents/list.htm','');">Contents</a></li>
						</ul>
						<!-- 
						<ul>
							<li class="leaf"><a href="#" onclick="javascript:MovePage('validate.htm','');">validate</a></li>
						</ul>
						<ul>
							<li class="leaf"><a href="#" onclick="javascript:MovePage('view.htm','');">uxcutor</a></li>
						</ul>
						-->
					</div>
				</div>
				<div id="block-block-3" class="clear-block">
					
					<ul>
						<li id="loginBefore" class="leaf"><a href="#" onclick="javascript:MovePage('login.htm','');">Login</a></li>
						<li id="loginAfter" class="leaf" style="display:none;"><a href="#" onclick="javascript:LogOut();">Logout</a></li>														
					</ul>
										
				</div>
				<!-- admin menu end -->
			</div>
			<!-- center start -->
			<div id="center">
				<div id="squeeze">
					<div class="right-corner">
						<div class="left-corner">
							<h2>UXCUTOR</h2>
					 	</div>
					</div>
				</div>	
			</div>
			
		</div>
		<footer>
			<div id="copyright">
				
				<!-- <span>경기도 성남시 분당구 수내동 9-4 현대오피스빌딩 11F 현대오피스빌딩 모바일파크<br/>
				TEL 031-717-0538, FAX 031-717-2383, E-mail <a href="mailto: kodaji@i-mobilepark.com;"> kodaji@i-mobilepark.com </a> Copyright&copy; MobilePark 2012</span> -->
			</div>
		</footer>
	</div>
</body>
</html>
