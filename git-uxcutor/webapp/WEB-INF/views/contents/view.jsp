<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-ui.js"></script>

<Script type="text/javascript">

var availableTags;

$(function() {
	$.ajax({
		url : "uxcutor/autocomplete.json",
		dataType: 'JSON',
		success : function(data) {
			availableTags = data;	
			return false;
		},
		error : function() {
			alert("메뉴를 다시 선택해주세요.");
			return false;
		}
	});
});

function autocomplete() {
    $( ":input" ).autocomplete({
      source: availableTags
    });
}

$(document).ready(function(){
	
 	$("#loadingBar").css({
 		position: 'absolute',
		left: '40%',
		top: '50%'
 	}).fadeIn();
	
	$.ajax({
		type : "POST",
		url : "contents/xmltoHtml.htm",
		data: { xml_url : $("#xml_url").val() },
		success : function(data) {
			$("#createXml").html(data);
			autocomplete();
			$("#loadingBar").hide();
			return false;
		},
		error : function() {
			alert("메뉴를 다시 선택해주세요.");
			$("#loadingBar").hide();
			return false;
		}
	});
	
	$("#createXml").on("click",".minusimageapply",function(){
		
		$(this).click(function(event){
			if(this == event.target){
				$(this).children("ul").hide();
				$(this).addClass("plusimageapply");
				$(this).removeClass("minusimageapply");
			}
		});
	
	});
	
	$("#createXml").on("click",".plusimageapply",function(){
		
		$(this).click(function(event){
			if(this == event.target){
				$(this).children("ul").show();
				$(this).removeClass("plusimageapply");
				$(this).addClass("minusimageapply");
			}
		});
	});
	
});

var act = {
		 goList : function(){ 
            MovePage("contents/list.htm",'');
        },
        goUpdate : function(status){
			 if( status == '0'){
				 if( $("#user_id").val() != $("#ADMIN_ID").val()){
					 alert($("#user_id").val()+" 님이 작업 중입니다.");
					 return false;
				 }
			 }
			 if($("#name").val()==""){
				alert("컨텐츠이름을 입력해 주시기 바랍니다.");
				$("#name").focus();
				return false;
			 }
			 xmlParser.createXml();
			 act.goProcess("contents/update.htm",$("#scForm").serializeArray(),"contents/list.htm");
	     },
	     goDelete : function(){
			 if( status == '0'){
				 if( $("#user_id").val() != $("#ADMIN_ID").val()){
					 alert($("#user_id").val()+" 님이 작업 중입니다.");
					 return false;
				 }
			 }
			 act.goProcess("contents/delete.htm",$("#scForm").serializeArray(),"contents/list.htm");
		  },
		  goProcess : function (url, data, re_url) {
				$("#loading").show();
				$.ajax({
					type : "POST",
					url : url,
					data : data,
					success : function(response) {
						$("#loading").hide();
						var responseArray =  response.split(";");
						var code = responseArray[0];
						var msg = responseArray[1];
						
						if(code=="0"){
							alert(msg);
							MovePage(re_url,'');							
						} else {
							alert(msg);
						}
					},
					error : function(request,status,error) {
						$("#loading").hide();
						alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
						return false;
					}
				});
			}
	} 

var xmlParser = {
		createXml : function(){ 
			var html = $("#createXml");
			var xmlString = "<?xml version='1.0' ?>\n";
			xmlString += "<!DOCTYPE uxcutor SYSTEM 'xcpt.dtd'>\n";
			xmlString += "<uxcutor>\n";
			xmlString += xmlParser.xmlEachUl(html);
			xmlString += "</uxcutor>";
			$("#xmlData").val(xmlString);
       },
       xmlEachUl : function(element){
    		var e_id = element.attr("id");
    		var xmlUl = "";
    	 	$("#"+e_id).children('ul').each(function(index, element) {
    	 		xmlUl += xmlParser.xmlEachLi(element);
    		  }); 
    	 	return xmlUl;
	     },
	   xmlEachLi : function(UlElement){
	    	var xmlLi = "";
	     	$(UlElement).children('li').each(function(index, element) {	
	     		var depthCheckArray =  element.id.split("_");
	     		
	     		for(var i=0;i<depthCheckArray[1];i++){
	     			xmlLi += '\t';
	     		}
	     		
	    		xmlLi += '<'+element.id.split("_",1)+' ';
	     		xmlLi += xmlParser.xmlEachInput(element.id);
	    		xmlLi += '>\n';
	    		xmlLi += xmlParser.xmlEachTextarea(element.id);
	    		xmlLi += xmlParser.xmlEachUl($("#"+element.id));
	    		
	     		for(var i=0;i<depthCheckArray[1];i++){
	     			xmlLi += '\t';
	     		}
	     		
	    		xmlLi += '</'+element.id.split("_",1)+'>\n';
	    	  }); 
	     	return xmlLi;
		  },
		 xmlEachInput : function(LiId){
				var xmlInput = "";
				
			 	$("#"+LiId+" input").each(function(index, element) {
			 		var nameArray =  element.id.split("_");
			 		var nameA = nameArray[0]+"_"+nameArray[1]+"_"+nameArray[2]+"_"+nameArray[3];
			 		//console.log("nameA===["+nameA+"] nameArray===["+element.id+"] LiId==="+LiId);
			 		
			 		if(nameA == LiId && element.value.length > 0 ) {
			 			
			 			xmlInput += nameArray[4]+"=\""+element.value+"\" ";
			 		}
				  }); 
			 	
			 	return xmlInput;
		 },
		 xmlEachTextarea : function(LiId){
			var xmlTextarea = "";
			
		 	$("#"+LiId+" textarea").each(function(index, element) {
		 		var nameArray =  element.id.split("_");
		 		var nameA = nameArray[0]+"_"+nameArray[1]+"_"+nameArray[2]+"_"+nameArray[3];
				if(nameA == LiId && element.value.length > 0 ) {
					xmlTextarea += "<![CDATA[ \n " + element.value +"\n ]]> \n";
				}
			  }); 
		 	
		 	return xmlTextarea;
		}
	} 
    
var strObj = "";
var divDepth = "1";
var maxLength = "1";
var addLength = "0";

function makeEleHtml(data){

	var ni = $("#createXml");
	if(strObj){
		ni = $(strObj);
		divDepth++;
	}
	
	var newdiv = document.createElement('ul');
	maxLength = data.eleList.length;
	var input = "";
	
	for(var i=0;i<data.eleList.length;i++){		
		var item = data.eleList[i]+"_"+divDepth+"_"+i+"_"+addLength;
		
		input += '<li id="'+item+'" class="minusimageapply"><a onclick=\'javascript:nextFunction("'+item+'");return false;\'>'+data.eleList[i]+'</a>';		
		input += ' <a onclick=\'javascript:addFunction("'+item+'", "'+data.attrList[i]+'");return false;\'>[추가]</a>';	
		input += ' <a onclick=\'javascript:delFunction("'+item+'");return false;\'>[삭제]</a>';
		if(data.attrList[i].length>0){
			input +="  <div class='attr'>";
			for(var k=0;k<data.attrList[i].length;k++){
				var name = item+"_"+data.attrList[i][k];
								
				if(data.attrList[i][k]=="acttype"){
					var na = name+"_textarea";
					
					input += "- "+data.attrList[i][k]+' <input type="text" id="'+name+'" value="" onkeyup="TextareaShow(\''+name+'\');"/><br/>';
					input += '<textarea id="'+na+'" style="display:none;"></textarea>';	

				}else{
					input += "- "+data.attrList[i][k]+' <input type="text" id="'+name+'" value=""/></br>';
				}
				
			}	
			input +="</div>";
		}
						
		
		input += '</li>';				
	}
	
	newdiv.innerHTML = input;
	ni.append(newdiv);	  
	
	autocomplete();
}

function delFunction(obj){
	if(confirm("하위 메뉴도 함께 삭제됩니다. 삭제하시겠습니까?")){
		$("#"+obj).remove();
	}
	return false;
	
}

function addFunction(obj, attrObj){		
	
	addLength++;
	
	var str = obj.split("_");
	var i = maxLength++;

	var item = str[0]+"_"+str[1]+"_"+i+"_"+addLength;
	var input = "";
	input += '<li id="'+item+'" class="minusimageapply"><a onclick=\'javascript:nextFunction("'+item+'");return false;\'>'+str[0]+'</a>';	
	input += ' <a onclick=\'javascript:addFunction("'+item+'","'+attrObj+'");return false;\'>[추가]</a>';
	input += ' <a onclick=\'javascript:delFunction("'+item+'");return false;\'>[삭제]</a>';
	attrList = attrObj.split(",");
    if(attrObj.length > 0){
    	input +="<div class='attr'>";
		for(var k=0;k<attrList.length;k++){
			var name = item+"_"+attrList[k];
			
			if(attrList[k]=="acttype"){
				
				var na = name+"_textarea";
				
				input += "- "+attrList[k]+' <input type="text" id="'+name+'" value="" onkeyup="TextareaShow(\''+name+'\');"/><br/>';
				input += '<textarea id="'+na+'" style="display:none;"></textarea>';	
			}else{
				input += "- "+attrList[k]+' <input type="text" id="'+name+'" value=""/><br/>';
			}
		}		
		input +="</div>";
    }
	
	input += '</li>';				
	
	$("#"+obj).after(input);	
	
}


var is_run = 0;

function nextFunction(obj){
	
	$("#popLayer").css("left", $("#"+obj).offset().left-100);
	$("#popLayer").css("top", $("#"+obj).offset().top -75);
	
	if(is_run) return;	
	is_run = 1;
	var str = obj.split("_");
	var value = str[0].substring(0,1).toUpperCase() + str[0].substring(1,str[0].length);
	strObj = $(obj).parent();
	$.ajax({
		type : "GET",
		url : "make.json",
		data: {
			'cName' : value
		},
		dataType: 'JSON',
		success : function(data) {			
			if(data.eleList.length > 0 ) PopLayerHtml(obj, data);
			is_run = 0;
			return false;
		},
		error : function() {
			alert("하위 엘리먼트가 없습니다.");
			is_run = 0;
			return false;
		}
	});
	
}

function PopLayerHtml(id, data){
	var temp = $('#popLayer');
	temp.empty().fadeIn();
	var newdiv = document.createElement('ul');
	
	maxLength = data.eleList.length;
	var input = "";
	for(var i=0;i<maxLength;i++){
		var item = data.eleList[i]+"_"+divDepth+"_"+i;
		
		input += '<li onclick=\'javascript:addChild("'+id+'", "'+item+'", "'+data.attrList[i]+'");return false;\'>'+data.eleList[i]+'</li>';				
	}
	
	input+='<li onclick=\'javascript:closePop();\'>[닫기]</li>';
	
	newdiv.innerHTML = input;
	temp.append(newdiv).show();
	
	return false;
}

function closePop(){
	$("#popLayer").hide();
}

function addChild(id, sub_id, attrObj){
	
	var i = $("#"+id).children("ul").children("li").size();

	var str = id.split("_");
	var input = "";
	var item1 = sub_id.split("_");
	var divDepth = Number(str[1])+1;
	var item = item1[0]+"_"+divDepth+"_"+i+"_"+str[3];

	input += '<li id="'+item+'" class="minusimageapply"><a onclick=\'javascript:nextFunction("'+item+'");return false;\'>'+item1[0]+'</a>';	
	
	   input += ' <a onclick=\'javascript:addFunction("'+item+'","'+attrObj+'");return false;\'>[추가]</a>';
	   input += ' <a onclick=\'javascript:delFunction("'+item+'");return false;\'>[삭제]</a>';
	   
		attrList = attrObj.split(",");
	    if(attrObj.length > 0){
	    	input +="<div class='attr'>";
			for(var k=0;k<attrList.length;k++){
				var name = item+"_"+attrList[k];
				
				if(attrList[k]=="acttype"){
					
					var na = name+"_textarea";
					
					input += "- "+attrList[k]+' <input type="text" id="'+name+'" value="" onkeyup="TextareaShow(\''+name+'\');"/><br/>';
					input += '<textarea id="'+na+'" style="display:none;"></textarea>';	
				}else{
					input += "- "+attrList[k]+' <input type="text" id="'+name+'" value=""/><br/>';
				}
			}		
			input +="</div>";
	    }
	    
		input += '</li>';	
		
		if(i==0){
			var newdiv = document.createElement('ul');
			
			newdiv.innerHTML = input;
			
			$("#"+id).append(newdiv);

		}else{
			$("#"+id).children("ul").append(input);
		}
		$("#popLayer").hide();
		
		autocomplete();
}

function TextareaShow(id){
	var na = id+"_textarea";
	if($("#"+id).val()=="LUA"){		
		$("#"+na).show().after("<br/>").focus();

	}else{
		$("#"+na).hide();
	}
}

</Script>
<form name="scForm" id="scForm" method="post">
<input type="hidden" name="user_id" id="user_id" value="${user_id}" />
<input type="hidden" name="id" id="id" value="${view.id}" />
<input type="hidden" name="ADMIN_ID" id="ADMIN_ID" value="${ADMIN_ID}"/>
<input type="hidden" name="xml_url" id="xml_url" value="${view.xml_url}"/>
<input type="hidden" name="xmlData" id="xmlData" />
<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > Contents
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">컨텐츠 상세보기</h2>
			</div>     
			
			<table cellspacing="0" border="1" summary="스킨 상세보기">
				<colgroup>
					<col width="110"><col><col width="110"><col>
				</colgroup>
				<tbody>
					<tr>
						<th>서비스ID</th>
						<td>${view.id}</td>
					</tr>
					<tr>
						<th>서비스이름</th>
						<td><input id="name"  type="text" name="name" maxlength="32" value="${view.name}"/></td>
					</tr>
					<tr>
						<th>작업상태</th>
						<td>
							<select id="status" name="status">
								<option value="0" <c:if test="${view.status=='0'}">selected</c:if>>작업중</option>
								<option value="1" <c:if test="${view.status=='1'}">selected</c:if>>작업완료</option>
							</select>
						</td>
					</tr>
					<tr>
						<th>xml_url</th>
						<td>${view.xml_url}</td>
					</tr>					
					<tr>
						<th>생성일</th>
						<td><fmt:formatDate value="${view.create_time}" pattern="yyyy-MM-dd" /></td>
					</tr>
					<tr>
						<th>수정일</th>
						<td><fmt:formatDate value="${view.update_time}" pattern="yyyy-MM-dd" /></td>
					</tr>
				</tbody>
			</table>
			
			<div class="clear-block">
				<div id="createXml"></div>
			</div>
			
			<div id="popLayer">
				<ul>
					<li class="close">[닫기]</li>
				</ul>
			</div>
			
			<div id="loadingBar">
				<img alt="xml 로딩중 입니다." src="${pageContext.request.contextPath}/resources/images/ajax-loadingBar.gif" />
			</div>
			
			<!-- div class="form-item" id="save"><a href="javascript:xmlParser.createXml();"> save</a></div-->
			
			<div>
				<a href="#" class="button" onclick="javascript:act.goList();">리스트</a>
				<a href="#" class="button" onclick="javascript:act.goUpdate('${view.status}');">수정</a>
				<a href="#" class="button" onclick="javascript:act.goDelete();">삭제</a>
			</div>
			
		</div>
	</div>
</div>
</form>
