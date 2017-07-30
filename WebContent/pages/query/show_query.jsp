<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.TreeMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>shou queries</title>
<base href="http://localhost:8080/project_pathdump/">
<link href="static/css/bootstrap.min.css" rel="stylesheet">
<style>
#table-container1 {
	height: 270px;
	width: 100%;
	overflow: auto;
	margin-bottom: 30px;
}
#table-container2 {
	height: 270px;
	width: 100%;
	overflow: auto;
	margin-bottom: 30px;
}
</style>
</head>
<body>
	<%
		ArrayList<String> list = (ArrayList<String>) request.getSession().getAttribute("queryName");
		ArrayList<String> aggList = (ArrayList<String>) request.getSession().getAttribute("queryAggName");
	%>
		<h1>
			Result <small style="color: gray; font-size: medium;">registered queries<br></small>
		</h1>
		<div class="container" id="table-container1">
			<div class="panel panel-default">
				<!-- Table -->
				<table class="table table-hover" align="center" width="100%">
					<tr>
						<th>Query Name</th>
						<th>process</th>
						
					</tr>

					<% if(list != null){
						Iterator<String> iter = list.iterator(); 
						while (iter.hasNext()){
					%>
					<tr>
						<th align="center"><%=iter.next() %></th>
						<th align="center"><a>remove</a></th>
					</tr>
					<%}} %>
				</table>
			</div>
		</div>
		<br>
		<div class="container" id="table-container2">
			<div class="panel panel-default">
				<!-- Table -->
				<table class="table table-hover" align="center" width="100%">
					<tr>
						<th>Aggregation Name</th>
						<th>process</th>
						
					</tr>

					<% if(aggList != null){
						Iterator<String> iter2 = aggList.iterator(); 
						while (iter2.hasNext()){
					%>
					<tr>
						<th align="center"><%=iter2.next() %></th>
						<th align="center"><a>remove</a></th>
					</tr>
					<%}} %>
				</table>
			</div>
		</div>
	<div style="margin-bottom: 50px; margin-right:30px; float: right">
		<a id="backBtn" class="btn btn-primary" href="index.jsp">back home</a>
	</div>
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="static/js/jquery-3.2.1.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/jqPaginator.js"></script>

</body>
</html>