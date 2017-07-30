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
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top">
	<div class="container">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<p class="navbar-brand" href="#">
				Pathdump</p>
		</div>
		</div>
		</nav>
	<h1>
		Register <small style="color: gray; font-size: medium;">queries<br></small>
	</h1>
	
	<div class="container">
		<div class="row-fluid">
			
				<form action="RegisterServlet" class="form-horizontal" role="form" enctype="multipart/form-data" method="post">
					<fieldset>
						<legend>Select Query Name</legend>
						<div class="form-group">
							<label for="disabledSelect" class="col-sm-2 control-label">Query Name</label>
							<div class="col-sm-10">
<!-- 								<select id="querySelect" class="form-control" name="querySelect"> -->
<!-- 									<option>topk_query.py</option> -->
<!-- 									<option>pathconf_check.py</option> -->
<!-- 									<option>null</option> -->
<!-- 								</select> -->
									<input type="file" name="queryfile" id="queryfile" >
							</div>
						</div>
					</fieldset>
				
					<fieldset>
						<legend>Select Query Aggregation Name</legend>
						<div class="form-group">
							<label for="AggSelect" class="col-sm-2 control-label">Aggregation Name</label>
							<div class="col-sm-10">
<!-- 								<select id="aggSelect" class="form-control" name="aggSelect"> -->
<!-- 									<option>topk_query_agg.py</option> -->
<!-- 									<option>null</option> -->
<!-- 								</select> -->
									<input type="file" name="aggfile" id="aggfile">
							</div>
						</div>
					</fieldset>
					<fieldset>
						<legend>Choose User Application</legend>
						<div class="form-group">
							<label for="AggSelect" class="col-sm-2 control-label">User Application</label>
							<div class="col-sm-10">
<!-- 								<select id="execute" class="form-control" name="execute"> -->
<!-- 									<option>topk</option> -->
<!-- 									<option>path conformance</option> -->
<!-- 								</select> -->
								<input type="file" name="executefile" id="executefile">
							</div>
						</div>
					</fieldset>
					<div style="float: right;">
						<button type="submit" class="btn btn-primary">Register</button>
					</div>
				</form>
			
		</div>
	</div>

	

	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="static/js/jquery-3.2.1.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="static/js/bootstrap.min.js"></script>
	<script src="static/js/jqPaginator.js"></script>
</body>
</html>