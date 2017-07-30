package com.my.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.my.util.PathdumpUtils;

/**
 * Servlet implementation class ExecutePathconfServlet
 */
@WebServlet("/ExecutePathconfServlet")
public class ExecutePathconfServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String method = request.getParameter("method");
		if(method.equals("stop")){
			String isStoped = PathdumpUtils.stopFlowcoll();
			System.out.println("stop: " + isStoped);
			request.getSession().setAttribute("stop", "stop");
			request.getRequestDispatcher("/pages/pathconf/executePathconf.jsp").forward(request, response);
		}else if(method.equals("start")){
			ArrayList<Map<String, Object>> list = PathdumpUtils.startFlowcoll();
			request.getSession().setAttribute("stop", "start");
			request.getSession().setAttribute("result", list);
			request.getRequestDispatcher("/pages/pathconf/executePathconf.jsp").forward(request, response);
		}else{
			request.getSession().setAttribute("result", null);
			request.getRequestDispatcher("/index.jsp").forward(request, response);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
