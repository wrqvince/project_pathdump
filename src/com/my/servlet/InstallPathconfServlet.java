package com.my.servlet;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.my.util.PathdumpUtils;

/**
 * Servlet implementation class InstallPathconfServlet
 */
@WebServlet("/InstallPathconfServlet")
public class InstallPathconfServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HashMap<String, Object> query = new HashMap<String, Object>();
		query.put("name", "pathconf_check.py");
		String[] argv = {};
		query.put("argv", argv);
		HashMap<String, Object> tree = PathdumpUtils.getAggTree();
		String interval = "0.0";
		String retval = PathdumpUtils.installQuery(tree, query, interval);
		if(retval.equals("[{\"ubuntu\": true}]")){
			request.getSession().setAttribute("ifInstallSuccess", "Install query success");
		}else{
			request.getSession().setAttribute("ifInstallSuccess", "You have already installed query");
		}
		request.getSession().setAttribute("installPathFlag", true);
		request.getRequestDispatcher("/index.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
