<%@ page language="java" isELIgnored="false" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/style.min.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jstree.min.js"></script>
<Script type="text/javascript">



$(document).ready(function(){
 	$.ajax({
 		url : "uxcutor/tree_data.json",
		dataType: 'JSON',
		success : function(node) {
			
		    $('#jstree').jstree({
		    	"themes" : {
		    		"theme" : "classic", "dots" : true, "icons" : true
				},
		    	'core' : {
		    	'data' : node
		   	 	},
			   	"plugins" : [ "themes" ]
			});
		    
			return false;
		},
	});
});
$(function () {
    
    // 7 bind to events triggered on the tree
    $('#jstree').on("changed.jstree", function (e, data) {
		var cName = data.node.text;
		
		cName= cName.substring(0,1).toUpperCase() + cName.substring(1,cName.length);
		
		
		
		var parent = $('#jstree').jstree('get_selected');
		//var newNode = { state: "open", data: "11111111111111111" };
		
		var newNode = { 
				'text' :  'test'
		};
		
		console.log(newNode);
		
		console.log($('#jstree').jstree("create_node", parent, newNode, 'last', function() { alert("added"); }, true));
		
		//$('#jstree').jstree("create", parent, 'last', newNode, false, true)
		
		//$('#jstree').jstree("create_node", parent, newNode, position, function() { alert("added"); }, true);
		
		//$('#jstree').jstree("create", $('#jstree').jstree('get_selected'), position, newNode);
		
/* 	  	$.ajax({
			url : "contents/data.json",
			dataType: 'JSON',
			data: {"cName" : cName, "id" : data.selected},
			success : function(node) {
				
			    $('#jstree').jstree("create", null, "last",{
			    	"attr" : {
			    		
			    	}
				});
			    
				return false;
			},
		}); */
    });
    
  });
</Script>

<div id="squeeze">
	<div class="right-corner">
		<div class="left-corner">
			<div class="breadcrumb">
				Menu > xml make
			</div>   
			<div id="tabs-wrapper" class="clear-block"> 
				<h2 class="with-tabs">Xml Make</h2>
			</div>                            

			<div id="jstree"></div>
			
		</div>
	</div>
</div>

  
