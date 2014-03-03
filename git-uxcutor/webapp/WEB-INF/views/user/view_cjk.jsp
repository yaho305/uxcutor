<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<script type="text/javascript">

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



function makeAttrHtml(data){
	
	attrInnerHtml += "<table>";
	
	for(var i=0;i<data.attrList.length;i++){
		attrInnerHtml += "<tr><td>"+data.attrList[i]+"</td><td><input type='text' name='"+data.attrList[i]+"'</td></tr>";
	}
	attrInnerHtml += "</table>";
	document.getElementById("attrtHtml").innerHTML = attrInnerHtml;
}

$(document).ready(function(){
	
	$("#addMake").click(function(){
		
			$.ajax({
				type : "GET",
				url : "make.json",
				dataType: 'JSON',
				success : function(data) {
					
					if(data.eleList.length > 0 ) makeTable(data);
					return false;
				},
				error : function() {
					alert("메뉴를 다시 선택해주세요.");
					return false;
				}
			});
	});
});

var tableCount = 0;
var tblcal = "";

function makeTable(data){
	tableCount ++;
	tblcal = document.createElement('table');
	tblcal.style.textAlign = 'left';
    tblcal.setAttribute('id', 'tbl_Uxcutor'+tableCount);
    tblcal.setAttribute('border', '1');
    tblcal.setAttribute('width', '100');
    var tbltr = tblcal.insertRow();
    tbltr.setAttribute('id', 'tr_Uxcutor'+tableCount);
    var tbltd = tbltr.insertCell();
    tbltd.setAttribute('id', 'td_Uxcutor'+tableCount);
    
    //var trcal = document.createElement('tr');
   
    //trcal.setAttribute('id', 'tr_Uxcutor'+tableCount);
    //var tdcal = document.createElement('td');
   
    //tdcal.setAttribute('id', 'td_Uxcutor'+tableCount);
    
    //trcal.appendChild(tdcal);
    //tblcal.appendChild(trcal);
        
    
    document.makeForm.checkId.value = tableCount;
    
    var tableHtml = "<table id='tbl_Uxcutor'"+tableCount+" border='1'><tr id='tr_Uxcutor'"+tableCount+"><td id='td_Uxcutor'"+tableCount+">";
    makeDataSet(data); 
    tableHtml += "</td></tr></table>";
    
    document.getElementById("eleHtml").appendChild(tblcal);
}

function makeDataSet(data){
	
	var eleInnerHtml = "";
	
    eleInnerHtml += "<select name='"+strFunction+"' onChange='nextFunction(this.value,"+tableCount+")'>";
   
	eleInnerHtml += "<option value=''>선택하세요</option>";
	for(var i=0;i<data.eleList.length;i++){
		eleInnerHtml += "<option value="+data.eleList[i]+">"+data.eleList[i]+"</option>";
	}
	eleInnerHtml += "</select>";
	
	if(data.attrList.length > 0 ) eleInnerHtml += "&nbsp;&nbsp;<a href='#'> view </a>&nbsp;&nbsp;";
	else eleInnerHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	
	tblcal.innerHTML = eleInnerHtml;
}


var strFunction = "Uxcutor";

function makeEleHtml(data){
	
	var new_td1 = document.createElement('td');
	//new_td1.setAttribute('id', 'td_Uxcutor'+tableCount);
	var new_td2 = document.createElement('td');
	
	new_td1.insertBefore(new_td2);
	//new_td1.insertAfter(new_td2);

    var formtable = document.getElementById('tbl_Uxcutor'+document.makeForm.checkId.value);
    var formtd = document.getElementById('td_Uxcutor'+document.makeForm.checkId.value);
    
    var eleInnerHtml = "";
	
    eleInnerHtml += "<select name='"+strFunction+"' onChange='nextFunction(this.value,"+tableCount+")'>";
   
	eleInnerHtml += "<option value=''>선택하세요</option>";
	for(var i=0;i<data.eleList.length;i++){
		eleInnerHtml += "<option value="+data.eleList[i]+">"+data.eleList[i]+"</option>";
	}
	eleInnerHtml += "</select>";
	
	if(data.attrList.length > 0 ) eleInnerHtml += "&nbsp;&nbsp;<a href='#'> view </a>&nbsp;&nbsp;";
	else eleInnerHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	
	new_td1.innerHTML = eleInnerHtml;
	
	formtable.insertBefore(new_td1,formtd);

}

function nextFunction(value,id){
	
	document.makeForm.checkId.value = id;
	
	value = value.substring(0,1).toUpperCase() + value.substring(1,value.length);
	strFunction = value;
	
	$.ajax({
		type : "GET",
		url : "make.json",
		data: {
			'cName' : value
		},
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
}

function delTable(){
	document.getElementByid('poTable').deleteRow(2);
}

</script>
</head>
<body>
<form name="makeForm" id="makeForm" method="post">
<input type="hidden" name="checkId">
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
					<!-- <a href="#" id="make" class="form-submit"> </a>-->uxcutor&nbsp;&nbsp;<a href="#" id="addMake" class="form-submit">add</a>&nbsp;&nbsp;<a href="javascript:delTable();" id="delMake">del</a>
				</div>
				
				
				<span id='eleHtml'></span>
				
					
			</div>
			<div class="clear-block">
				<div class="form-item" id="attrtHtml"></div>
			</div>
		</div>
	</div>
</div>
</form>
</body>
</html>