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
<title>executeTopk</title>
<base href="http://localhost:8080/project_pathdump/">
<link href="static/css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">
	#table-container {
		height: 550px;
		width: 100%;
		overflow: auto;
		margin-bottom: 30px;
	}
	.table-head{padding-right:17px;}
	.table-body{width:100%; height:450px;overflow-y:scroll;}
	.table-head table,.table-body table{width:100%;}
</style>
</head>
<body>
	<%
		TreeMap<Integer, ArrayList<HashMap<String, Object>>> output = (TreeMap<Integer, ArrayList<HashMap<String, Object>>>) request
				.getAttribute("output");
		Integer num = (Integer) request.getAttribute("num_of_query");
	%>
		<h1>
			Result <small style="color: gray; font-size: medium;">top<font
				color="red"><%=num%></font> query:<br></small>
		</h1>
	<div class="container" id="table-container">
		<div class="panel panel-default">
			<div class="table-head" style="height: 36px">
				<table class="table table-hover" align="center" width="100%">
					<colgroup>
						<col width="100"></col>
						<col width="100"></col>
						<col width="200"></col>
						<col width="200"></col>
						<col width="200"></col>
						<col width="200"></col>
						<col width="100"></col>
						<col width="*"></col>
         			</colgroup>
					<thead>
						<tr>
							<th>No.</th>
							<th>bytes</th>
							<th>destination port</th>
							<th>source ip</th>
							<th>destination ip</th>
							<th>source port</th>
							<th>protocol</th>
							<th>path</th>
						</tr>
					</thead>
				</table>
			</div>
			<!-- Table -->
			<div class="table-body">
				<table class="table table-hover" align="center" width="100%" >
					<colgroup>
              			<col width="100"></col>
						<col width="100"></col>
						<col width="200"></col>
						<col width="200"></col>
						<col width="200"></col>
						<col width="200"></col>
						<col width="100"></col>
						<col width="*"></col>
         			 </colgroup>
					<%
						Iterator<Entry<Integer, ArrayList<HashMap<String, Object>>>> iter = output.entrySet().iterator();
						int bytes = 0;
						int count = 0;
						ArrayList<HashMap<String, Object>> value = null;
						while (iter.hasNext()) {
							Entry<Integer, ArrayList<HashMap<String, Object>>> entry = (Entry<Integer, ArrayList<HashMap<String, Object>>>) iter.next();
							bytes = (Integer) entry.getKey();
							value = (ArrayList<HashMap<String, Object>>) entry.getValue();
							Iterator<HashMap<String, Object>> arrIter = value.iterator();
							while(arrIter.hasNext()){
								count ++;
								HashMap<String, Object> m = arrIter.next();
								HashMap<String, String> flowid = (HashMap<String, String>) m.get("flowid");
							
					%>
					<tbody>
						<tr>
							<th align="center"><%=count %></th>
							<th><%=bytes%></th>
							<th align="center"><%=flowid.get("dport")%></th>
							<th align="center"><%=flowid.get("sip")%></th>
							<th align="center"><%=flowid.get("dip")%></th>
							<th align="center"><%=flowid.get("sport")%></th>
							<th align="center"><%=flowid.get("proto")%></th>
							<th align="center"><%=m.get("path")%></th>
						</tr>
					</tbody>
					<%
						}
						}
					%>
				</table>
			</div>
		</div>
	</div>
	<div style="margin-bottom: 50px;float: right;margin-right: 30px">
		<a id="backBtn" class="btn btn-primary" href="index.jsp">back home</a>
	</div>
<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="static/js/jquery-3.2.1.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/jqPaginator.js"></script>
</body>
</html>