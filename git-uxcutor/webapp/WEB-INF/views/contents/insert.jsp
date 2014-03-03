<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-ui.js"></script>

<Script type="text/javascript">

var availableTags;

$(document).ready(function(){
		
	$.ajax({
		type : "GET",
		url : "make.json",
		dataType: 'JSON',
		success : function(data) {
			
			if(data.eleList.length > 0 ) makeEleHtml(data);
			return false;
		},
		error : function() {
			alert("메뉴를 다시 선택해주세요.");
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

var act = {
		 goList : function(){ 
            MovePage("contents/list.htm",'');
        },
		 goInsert : function(){ 
			 
			 xmlParser.createXml();
			 
			 if($("#user_id").val()==""){
					alert("로그인 후 등록해 주시기 바랍니다.");
					return false;
			 }
			 if($("#name").val()==""){
				alert("컨텐츠이름을 입력해 주시기 바랍니다.");
				$("#name").focus();
				return false;
			 }
			 if($("#xmlData").val()==""){
					alert("xmlData를 입력해 주시기 바랍니다.");
					$("#createXml").focus();
					return false;
			 }
			 
			 act.goProcess("contents/insert.htm",$("#scForm").serializeArray(),"contents/list.htm");
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
			
			console.log(xmlString);
			
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
			 		if(nameArray[0] == LiId.split("_",1) && element.value.length > 0 ) xmlInput += nameArray[4]+"=\""+element.value+"\" ";
				  }); 
			 	
			 	return xmlInput;
		 },
		 xmlEachTextarea : function(LiId){
			var xmlTextarea = "";
			
		 	$("#"+LiId+" textarea").each(function(index, element) {
		 		var nameArray =  element.id.split("_");
				if(nameArray[0] == LiId.split("_",1) && element.value.length > 0 ) {
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
<input type="hidden" name="user_id" id="user_id" value="${ADMIN_ID}" />
<input type="hidden" name="status" id="status" value="1" />
<input type="hidden" name="xmlData" id="xmlData" />
<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > Contents
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">컨텐츠 생성</h2>
			</div>     
			
			<table cellspacing="0" border="1" summary="컨텐츠 생성">
				<colgroup>
					<col width="110"><col><col width="110"><col>
				</colgroup>
				<tbody>
					<tr>
						<th>컨텐츠이름</th>
						<td>
							<div>
								<input id="name"  type="text" name="name" maxlength="32"/>
							</div>
						</td>
					</tr>									
				</tbody>
			</table>
			
			<!-- /clear-block -->
			<div class="clear-block">
				<!-- div class="form-item">	
					<a href="#" id="make" class="form-submit">uxcutor</a>&nbsp;&nbsp;<a href="#" id="addMake" class="form-submit">add</a>
				</div-->
				<div class="form-item" id="eleHtml"></div>
				<div class="form-item" id="attrtHtml"></div>
			</div>
			<div class="clear-block">
				
				<div id="createXml"></div>
			</div>
			<!-- clear-block/ -->
			
			<div id="popLayer">
			<ul>
			<li class="close">[닫기]</li></ul>
			</div>
			
			<!-- div class="form-item" id="save"><a href="javascript:xmlParser.createXml();"> save</a></div-->
						
			<div align="right">
				<div>
					<a href="#" class="button" onclick="javascript:act.goList();">리스트</a>
					<a href="#" class="button" onclick="javascript:act.goInsert();">등록</a>
				</div>
			</div>
		</div>
	</div>
</div>
</form>
