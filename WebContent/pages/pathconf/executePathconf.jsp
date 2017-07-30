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

.table-head {
	padding-right: 17px;
}

.table-body {
	width: 100%;
	height: 450px;
	overflow-y: scroll;
}

.table-head table, .table-body table {
	width: 100%;
}
</style>
</head>
<body>
	<%
		ArrayList<Map<String, Object>> list = (ArrayList<Map<String, Object>>) request.getSession()
				.getAttribute("result");
	%>
	<div style="float: left">
		<h1>
			Result <small style="color: gray; font-size: medium;">paths
				violate a policy<br>
			</small>
		</h1>
	</div>
	<div style="float: right; margin-right: 1100px; margin-top: 20px;">
		<button id="startBtn" class="btn btn-primary">start</button>
		<button id="stopBtn" class="btn btn-primary">stop</button>
	</div>
	<div class="container" id="table-container">
		<div class="panel panel-default">
			<!-- Table -->
			<div class="table-head" style="height: 36px">
				<table class="table table-hover" align="center" width="100%">
					<colgroup>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
					</colgroup>
					<thead>
						<tr>
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
			<div class="table-body">
				<table class="table table-hover" align="center" width="100%">
				<%
				if (list != null) {
					Iterator<Map<String, Object>> iter = list.iterator();
					while (iter.hasNext()) {
						StringBuffer path = new StringBuffer();
						Map<String, Object> map = (Map<String, Object>) iter.next();
						Map<String, String> flowid = (Map<String, String>) map.get("flowid");
						JSONArray pathArray = (JSONArray) map.get("path");
						for (int i = 1; i < pathArray.size() - 2; i++) {
							path.append(pathArray.get(i) + ", ");
						}
						path.append(pathArray.get(pathArray.size() - 2));
				%>
					<colgroup>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
						<col width="100"></col>
					</colgroup>
					<tbody>
						<tr>
							<th align="center"><%=flowid.get("dport")%></th>
							<th align="center"><%=flowid.get("sip")%></th>
							<th align="center"><%=flowid.get("dip")%></th>
							<th align="center"><%=flowid.get("sport")%></th>
							<th align="center"><%=flowid.get("proto")%></th>
							<th align="center"><%=path%></th>
						</tr>
						<%
							}
							}
						%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<div style="margin-bottom: 50px; margin-right:30px; float: right">
		<button id="backBtn" class="btn btn-primary">back home</button>
	</div>
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="static/js/jquery-3.2.1.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/jqPaginator.js"></script>

	<script type="text/javascript">
		var result = "${sessionScope.stop}";
		$(function() {
			$("#stopBtn").click(function() {
				window.open("ExecutePathconfServlet?method=stop", "_self");
			});
			$("#startBtn").click(function() {
				window.location.href = "ExecutePathconfServlet?method=start";
			});
			$("#backBtn").click(function(){
				window.location.href = "ExecutePathconfServlet?method=clear";
			});

		});

		if (result != "stop" && result != "") {
			setInterval(function() {
				window.location.href = "ExecutePathconfServlet?method=start";
			}, 5000);
		}
	</script>
</body>
</html>