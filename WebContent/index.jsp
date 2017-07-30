<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>pathdump</title>
<base href="http://localhost:8080/project_pathdump/">
<link href="static/css/bootstrap.min.css" rel="stylesheet">
<style>
body {
	padding-top: 50px;
}

.carousel {
	height: 600px;
	background-color: #000;
}

.carousel .item {
	height: 600px;
	background-color: #000;
}

.carousel img {
	width: 100%;
}

</style>
</head>
<body>
	<%
	    String mess=(String)session.getAttribute("ifInstallSuccess");
	    if("".equals(mess)  || mess==null){
	    }
	 else{%>
	    <script type="text/javascript">
	        alert("<%=mess%>");
		</script>
	<% }
	    session.setAttribute("ifInstallSuccess", "");
		Boolean topkFlag = false;
		Boolean pathConfFlag = false;
		Boolean installPathFlag = false;
		if(getServletContext().getAttribute("topkFlag") != null){
			topkFlag =(Boolean)getServletContext().getAttribute("topkFlag"); 
		}
		if(getServletContext().getAttribute("pathConfFlag") != null){
			pathConfFlag = (Boolean)getServletContext().getAttribute("pathConfFlag");
		}
		if(getServletContext().getAttribute("installPathFlag") != null){
			installPathFlag = (Boolean)getServletContext().getAttribute("installPathFlag"); 
		}
		//if(request.getParameter("installPathFlag") != null){
		//	installPathFlag = Boolean.valueOf(request.getParameter("installPathFlag")); 
		//}
		%>


	<nav class="navbar navbar-default navbar-fixed-top">
	<div class="container">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<p class="navbar-brand" href="#">
				Pathdump</p>
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<ul class="nav navbar-nav">
			<li class="dropdown">
				<a href="pages/register/register.jsp">register queries</a>
			</li>		
			<li class="dropdown">
				<a href="pages/query/show_query.jsp">show queries</a>
			</li>	
			
				<%
				if(topkFlag){
			%>
			<li class="dropdown"><a href="#" class="dropdown-toggle"
				data-toggle="dropdown" role="button" aria-haspopup="true"
				aria-expanded="false">topk query<span class="caret"></span></a>
				<ul class="dropdown-menu">
					<li><a href="#" data-toggle="modal" data-target="#execute_topk">execute</a></li>
				</ul></li>
			<%}
				if(pathConfFlag){
				%>
			<li class="dropdown"><a href="#" class="dropdown-toggle"
				data-toggle="dropdown" role="button" aria-haspopup="true"
				aria-expanded="false">path conformance<span class="caret"></span></a>
				<ul class="dropdown-menu">
					<%
					System.out.println(installPathFlag);

					if(!installPathFlag) {%>
					<li><a href="InstallPathconfServlet">install</a></li>
					<li class="disabled"><a href="javascript:void(0)">show results</a></li>
					<li class="disabled"><a href="javascript:void(0)">uninstall</a></li>
					<%}else{ %>
					<li class="disabled"><a href="javascript:void(0)">install</a></li>
					<li><a href="pages/pathconf/executePathconf.jsp">show results</a></li>
					<li><a href="UninstallPathconfServlet">uninstall</a></li>
					<%} %>
				</ul></li>
				<%} %>
		</ul>
	</div>
	</nav>

	<!-- show main interface -->
	<div id="carousel-generic" class="carousel slide" data-ride="carousel">
		<ol class="carousel-indicators">
			<li data-target="#carousel-generic" data-slide-to="0" class="active"></li>
			<li data-target="#carousel-generic" data-slide-to="1"></li>
		</ol>
		<div class="carousel-inner" role="listbox">
			<div class="item active">
				<img alt="slide 1" src="static/img/network2.jpg">
				<div class="carousel-caption" style="color: black;">
					<h1>Pathdump</h1>
					<p>Pathdump is a small-scaled network debug application</p>
				</div>
			</div>
			<div class="item">
				<img alt="slide 2" src="static/img/network3.png"
					style="height: 450px;">
				<div class="carousel-caption">
					<h1>Pathdump</h1>
					<p>Pathdump is a small-scaled network debug application</p>
				</div>
			</div>
		</div>
	</div>
	<!-- execute topk modal -->
		<div class="modal fade" id="execute_topk">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
					</button>
					<h4 class="modal-title">topk</h4>
				</div>
				<form action="ExecuteTopkServlet">  
				<div class="modal-body">
                	<div class="form-group">  
                    	number of query:<input type="text" class="form-control" autocomplete="off" id="num_of_query" name="num_of_query"> 
                 	</div>  
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					<button type="submit" class="btn btn-primary" >Execute</button> 
				</div>
            	</form>
			</div>
		</div>
	</div>
	
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="static/js/jquery-3.2.1.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="static/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		function rtopkClick(){
			var xhr = new XMLHttpRequest();
			xhr.open("GET", "RegisterTopkServlet?filename1=topk_query.py&filename2=topk_query_agg.py", true);
			xhr.send();
			xhr.onreadystatechange = function(){
				if(xhr.readyState == 4 && xhr.status == 200){
					alert(xhr.responseText);
				}
			}
		}
		function rpathconfClick(){
			var xhr = new XMLHttpRequest();
			xhr.open("GET", "RegisterPathconfServlet?filename=pathconf_check.py", true);
			xhr.send();
			xhr.onreadystatechange = function(){
				if(xhr.readyState == 4 && xhr.status == 200){
					alert(xhr.responseText);
				}
			}
		}
		function ipathconfClick(){
			var xhr = new XMLHttpRequest();
			xhr.open("GET", "InstallPathconfServlet", true);
			xhr.send();
			xhr.onreadystatechange = function(){
				if(xhr.readyState == 4 && xhr.status == 200){
					alert(xhr.responseText);
					<%application.setAttribute("installPathFlag",true);%>;
					window.location.href ="index.jsp";
				}
			}
		}
		function uipathconfClick(){
			var xhr = new XMLHttpRequest();
			xhr.open("GET", "UninstallPathconfServlet", true);
			xhr.send();
			xhr.onreadystatechange = function(){
				if(xhr.readyState == 4 && xhr.status == 200){
					alert(xhr.responseText);
					<%application.setAttribute("installPathFlag",false);%>;
					window.location.href ="index.jsp";
				}
			}
		}
	</script>
	
</body>
</html>