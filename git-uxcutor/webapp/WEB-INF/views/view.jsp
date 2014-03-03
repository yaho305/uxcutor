<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery-ui.js"></script>

<script type="text/javascript">

var availableTags;

$(document).ready(function(){
	
	$("#make").click(function(){
		
			$.ajax({
				type : "GET",
				url : "make.json",
				dataType: 'JSON',
				success : function(data) {
					
					if(data.eleList.length > 0 ) makeEleHtml(data);
					//if(data.attrList.length > 0) makeAttrHtml(data);	
					
					return false;
				},
				error : function() {
					alert("메뉴를 다시 선택해주세요.");
					return false;
				}
			});
	});
	
	
	
});
var eleInnerHtml = "";
var attrInnerHtml = "";
var strObj = "";
var divDepth = "1";
var maxLength = "1";

function makeEleHtml(data){

	var ni = $("#test");
	if(strObj){
		ni = $(strObj);
		divDepth++;
	}
	
	var newdiv = document.createElement('ul');
	var level = "level"+divDepth;
	newdiv.setAttribute("class", level);
	
	maxLength = data.eleList.length;
	var input = "";
	for(var i=0;i<data.eleList.length;i++){
		var item = level+"_item"+i;
		input += '<li>';
		input += '<a id="'+item+'" onclick=\'javascript:nextFunction("'+item+'", "'+data.eleList[i]+'");return false;\'>'+data.eleList[i]+'</a> ';
		
		for(var k=0;k<data.attrList[i].length;k++){
			if(k==0){
				input +="(&nbsp;";
			}
			input += data.attrList[i][k]+'=<input type="text"/> &nbsp;';
			if(k==data.attrList[i].length-1){
				input +=")";
			}
		}	
		
		
		//input += '<a onclick=\'javascript:delFunction("'+item+'");return false;\'>[x]</a>';
		//input += '<a onclick=\'javascript:addFunction("'+item+'", "'+data.eleList[i]+'");return false;\'>[+]</a>';		
		input += '</li>';				
	}
	
	newdiv.innerHTML = input;
	ni.append(newdiv);
	
	//var html = '<ui class="level1"><li><a id="level1_item0" onclick=\'javascript:nextFunction("level1_item0", "ctypes");return false;\'>ctypes</a> </li><li><a id="level1_item1" onclick=\'javascript:nextFunction("level1_item1", "variables");return false;\'>variables</a> </li><li><a id="level1_item2" onclick=\'javascript:nextFunction("level1_item2", "mmfs");return false;\'>mmfs</a> </li><li><a id="level1_item3" onclick=\'javascript:nextFunction("level1_item3", "functions");return false;\'>functions</a> </li><li><a id="level1_item4" onclick=\'javascript:nextFunction("level1_item4", "index");return false;\'>index</a>name=<input type="text"></data> &nbsp;id=<input type="text"></data> &nbsp;)</li><li><a id="level1_item5" onclick=\'javascript:nextFunction("level1_item5", "service");return false;\'>service</a>name=<input type="text"></data> &nbsp;id=<input type="text"></data></li></ul>';
	//$("#test").html(html);
	
	autocomplete();
	
}

function makeAttrHtml(data){
	
	attrInnerHtml += "<table style='border:1px'>";
	
	for(var i=0;i<data.attrList.length;i++){
		attrInnerHtml += "<tr><td>"+data.attrList[i]+"</td><td><input type='text' name='"+data.attrList[i]+"'</td></tr>";
	}
	attrInnerHtml += "</table>";
	document.getElementById("attrtHtml").innerHTML = attrInnerHtml;
}

var is_run = 0;

function nextFunction(obj, value){
	
	if(is_run) return;	
	is_run = 1;
	
	value = value.substring(0,1).toUpperCase() + value.substring(1,value.length);
	console.log("value==="+value);
	strObj = $("#"+obj).parent();
	
	$.ajax({
		type : "GET",
		url : "make.json",
		data: {
			'cName' : value
		},
		dataType: 'JSON',
		success : function(data) {
			
			//if(data.eleList.length > 0 ) makeEleHtml(data);
			if(data.eleList.length > 0 ) PopLayerHtml(obj, data);
			//if(data.attrList.length > 0) makeAttrHtml(data);
			console.log("success");
			is_run = 0;
			return false;
		},
		error : function() {
			alert("메뉴를 다시 선택해주세요.");
			is_run = 0;
			return false;
		}
	});
	
}

function PopLayerHtml(obj, data){
	
	$('.layer').fadeIn();
	var temp = $('#layer1');
	temp.empty();
	var newdiv = document.createElement('ul');
	
	maxLength = data.eleList.length;
	var input = "";
	for(var i=0;i<data.eleList.length;i++){
		
		input += '<li onclick=\'javascript:addChild("'+obj+'", "'+data.eleList[i]+'");return false;\'>'+data.eleList[i]+'</li>';				
	}
	
	newdiv.innerHTML = input;
	temp.append(newdiv);
			
	temp.show();		
	/*
	if (temp.outerHeight() < $(document).height() ) temp.css('margin-top', '-'+temp.outerHeight()/2+'px');
	else temp.css('top', '0px');
	if (temp.outerWidth() < $(document).width() ) temp.css('margin-left', '-'+temp.outerWidth()/2+'px');
	else temp.css('left', '0px');	
	*/	
	return false;
}

function addChild(obj, value){
	
	console.log("obj==="+obj);
	console.log("value==="+value);
	
	var newdiv = document.createElement('ul');
	var str = obj.split("_item");
	
	var levelnum = str[0].split("level");
	levelnum = levelnum+1;
	
	
	var level = "level"+levelnum;
	newdiv.setAttribute("class", level);
	
	
	var i = maxLength++;
	var item = str[0]+"_item"+i;
	
	var input = "";
	
		input += '<li>';
		input += '<a id="'+item+'" onclick=\'javascript:nextFunction("'+item+'", "'+value+'");return false;\'>'+value+'</a> ';
		
		//input += '<a onclick=\'javascript:delFunction("'+item+'");return false;\'>[x]</a>';
		//input += '<a onclick=\'javascript:addFunction("'+item+'", "'+data.eleList[i]+'");return false;\'>[+]</a>';		
		input += '</li>';				
			
	newdiv.innerHTML = input;
	var ni = $("#"+obj).parent();
	ni.append(newdiv);
	$(".layer").hide();
}

function delFunction(obj){
	$("#"+obj).parent().remove();
	return false;
	
}

function addFunction(obj, value){
	var newdiv = $("#"+obj).parent().parent();
	
	var str = obj.split("_item");
	var i = maxLength++;
	console.log(obj);
	var item = str[0]+"_item"+i;
	
	var ni = '<li>';	
	ni += '<a id="'+item+'" onclick=\'javascript:nextFunction("'+item+'", "'+value+'");return false;\'>'+value+'</a>';
	ni += '<a onclick=\'javascript:delFunction("'+item+'");return false;\'>[x]</a>';
	ni += '<a onclick=\'javascript:addFunction("'+item+'", "'+value+'");return false;\'>[+]</a>';
	ni += '</li>';				
	newdiv.append(ni);
	
	maxLength++;

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
				<div class="form-item">	
					<a href="#" id="make" class="form-submit">uxcutor</a>&nbsp;&nbsp;<a href="#" id="addMake" class="form-submit">add</a>
				</div>
				<div class="form-item" id="eleHtml"></div>
				<div class="form-item" id="attrtHtml"></div>
			</div>
			<div class="clear-block">
				
				<div id="test"></div>
			</div>
			<!-- clear-block/ -->
			
			<div class="layer">
				<div class="bg">
					<div id="layer1" style="display:none;"></div>
				</div>
			</div>
		</div>
	</div>
</div>
</form>