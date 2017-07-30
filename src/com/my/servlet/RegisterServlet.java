package com.my.servlet;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.my.util.PathdumpUtils;
import com.oreilly.servlet.MultipartRequest;

/**
 * Servlet implementation class RegisterServlet
 */
@MultipartConfig
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String root = this.getServletContext().getRealPath("/"); 
		MultipartRequest mr = new MultipartRequest(request, root); 
		File queryFile = mr.getFile("queryfile");
		File aggFile = mr.getFile("aggfile");
		String queryData = "";	//get file content of agg_query
		String queryName = "";
		String queryAggName = "";
		if(queryFile != null){
			queryName = queryFile.getName();
			queryData = getFileContent(queryFile);
		}
		String aggData = ""; 	//get file content of query
		if(aggFile != null){
			queryAggName = mr.getFile("aggfile").getName();
			aggData = getFileContent(aggFile);		
		}
		
		ArrayList<String> list = null;
		// register query.py
		String queryContent = PathdumpUtils.registerQuery(queryData, queryName);
		list = (ArrayList<String>) this.getServletContext().getAttribute("queryName");
		if (list == null) {
			list = new ArrayList<String>();
			list.add(queryName);
		} else {
			list.add(queryName);
		}
		
		// register query_agg.py, could be null
		ArrayList<String> aggList = (ArrayList<String>) this.getServletContext().getAttribute("queryAggName");
		if (queryAggName.equals("")) {
			if (queryContent.equals("[true]")) {
				this.getServletContext().setAttribute("queryName", list);
				this.getServletContext().setAttribute("queryAggName", aggList);
				this.getServletContext().setAttribute("pathConfFlag", true);
			}
		} else {
			if (aggList == null) {
				aggList = new ArrayList<String>();
				aggList.add(queryAggName);
			} else {
				aggList.add(queryAggName);
			}
			String queryAggContent = PathdumpUtils.registerQuery(aggData, queryAggName);
			if (queryContent.equals("[true]") && queryAggContent.equals("[true]")) {
				this.getServletContext().setAttribute("queryName", list);
				this.getServletContext().setAttribute("queryAggName", aggList);
				this.getServletContext().setAttribute("topkFlag", true);
			}
		}
		response.sendRedirect(request.getContextPath() + "/index.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	public String getFileContent(File fileName){
		BufferedReader br = null;
		StringBuffer sb = null;
		try {
			br = new BufferedReader(new FileReader(fileName));
			sb = new StringBuffer();
			String line = br.readLine();
			while (line != null) {
				sb.append("\n").append(line);
				line = br.readLine();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if(br != null){
				try {
					br.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
		
		
		return sb.toString();
	}
	
}
