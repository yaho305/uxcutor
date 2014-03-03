<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-ui.js"></script>

<script type="text/javascript">

var availableTags;

$(document).ready(function(){
	
	//$("#make").click(function(){
		
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
	//});
	
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

var eleInnerHtml = "";
var attrInnerHtml = "";
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
					
					input += "- "+data.attrList[i][k]+'=<input type="text" id="'+name+'" value="" onblur="TextareaShow(\''+name+'\');"/>';
					input += '<textarea id="'+na+'" style="display:none;"></textarea><br/>';	

				}else{
					input += "- "+data.attrList[i][k]+'=<input type="text" id="'+name+'" value=""/></br>';
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
		var i = $("#"+obj).parent().children("li").size();
		
		if(i==1){
			$("#"+obj).parent("ul").remove();
		}else{
			$("#"+obj).remove();
		}
		
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
				
				input += "- "+attrList[k]+'=<input type="text" id="'+name+'" value="" onblur="TextareaShow(\''+name+'\');"/>';
				input += '<textarea id="'+na+'" style="display:none;"></textarea><br/>';	
			}else{
				input += "- "+attrList[k]+'=<input type="text" id="'+name+'" value=""/><br/>';
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
			
			console.log("success");
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
				
				input += "- "+attrList[k]+'=<input type="text" id="'+name+'" value="" onblur="TextareaShow(\''+name+'\');"/>';
				input += '<textarea id="'+na+'" style="display:none;"></textarea><br/>';	
			}else{
				input += "- "+attrList[k]+'=<input type="text" id="'+name+'" value=""/><br/>';
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
	
	if($("#"+id).val()=="LUA"){
		var na = id+"_textarea";
		$("#"+na).show();
	}
	
}

function autocomplete() {
	
    $( ":input" ).autocomplete({
      source: availableTags
    });
    
}

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

function xmlParserSave(){
	
	var html = $("#createXml");
	
	var xmlString = "<?xml version='1.0' ?>\n<uxcutor>\n";
	xmlString += xmlEachUl(html);
	xmlString += "</uxcutor>";
	
	console.log(xmlString);
			
}

function xmlEachUl(element){
	
	var e_id = element.attr("id");
	var xmlUl = "";
	
 	$("#"+e_id).children('ul').each(function(index, element) {
 		xmlUl += xmlEachLi(element);
	  }); 
 	
 	//console.log("xmlUl: "+xmlUl);
 	return xmlUl;
}

function xmlEachLi(UlElement){
	
	var xmlLi = "";
	
 	$(UlElement).children('li').each(function(index, element) {	
 		var depthCheckArray =  element.id.split("_");
 		
 		for(var i=0;i<depthCheckArray[1];i++){
 			xmlLi += '\t';
 		}
 		
		xmlLi += '<'+element.id.split("_",1)+' ';
 		xmlLi += xmlEachInput(element.id);
		xmlLi += '>\n';
		
		//var attrArray = element.id.querySelectorAll('textarea');
		//if(attrArray.length > 0 ){
			xmlLi += xmlEachTextarea(element.id);
		//	xmlLi += '\n';
		//}
		
		xmlLi += xmlEachUl($("#"+element.id));
		
 		for(var i=0;i<depthCheckArray[1];i++){
 			xmlLi += '\t';
 		}
 		
		xmlLi += '</'+element.id.split("_",1)+'>\n';
	  }); 
 	//console.log("xmlLi: "+xmlLi);
 	return xmlLi;
}

function xmlEachInput(LiId){
	
	var xmlInput = "";
	
 	$("#"+LiId+" input").each(function(index, element) {
 		var nameArray =  element.id.split("_");
 		if(nameArray[0] == LiId.split("_",1) && element.value.length > 0 ) xmlInput += nameArray[3]+"=\""+element.value+"\" ";
	  }); 
 	
 	//console.log("xmlInput: "+xmlInput);
 	return xmlInput;
}

function xmlEachTextarea(LiId){
	
	var xmlTextarea = "";
	
 	$("#"+LiId+" textarea").each(function(index, element) {
 		var nameArray =  element.id.split("_");
		if(nameArray[0] == LiId.split("_",1) && element.value.length > 0 ) {
			xmlTextarea += "<![CDATA[ \n " + element.value +"\n ]]> \n";
		}
	  }); 
 	
 	//console.log("xmlInput: "+xmlInput);
 	return xmlTextarea;
}
	
</script>
<form name="makeForm" id="makeForm" method="post">
<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > xml make
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">Xml Make</h2>
			</div>                            

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
			
			<div class="form-item" id="save"><a href="javascript:xmlParserSave();"> save</a></div>
				
		</div>
	</div>
</div>
</form>