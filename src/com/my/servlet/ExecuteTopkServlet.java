package com.my.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.my.util.PathdumpUtils;

/**
 * Servlet implementation class ExecuteTopkServlet
 */
@WebServlet("/ExecuteTopkServlet")
public class ExecuteTopkServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int num_of_query = Integer.valueOf(request.getParameter("num_of_query"));	//topk query, user input
		HashMap<String, Object> tree = PathdumpUtils.getAggTree();
		HashMap<String, Object> query = new HashMap<String, Object>();
		String[] str = { "*", "*" };				//linkID and timeRange
		Object[] obj = { num_of_query, str, str };
		query.put("name", "topk_query.py");
		query.put("argv", obj);
		HashMap<String, Object> aggCode = new HashMap<String, Object>();
		int[] topk = { Integer.valueOf(num_of_query) };
		aggCode.put("name", "topk_query_agg.py");
		aggCode.put("argv", topk);
		
		ArrayList<Map<String, Object>> result = PathdumpUtils.executeQuery(tree, query, aggCode);		//execute query, return result
		TreeMap<Integer, ArrayList<HashMap<String, Object>>> output = processData(result);			//turn the result to a treemap, so the sorted data can be displayed
		request.setAttribute("output", output);
		request.setAttribute("num_of_query", num_of_query);
		request.getRequestDispatcher("/pages/topk/executeTopkSuccess.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
	/**
	 * process output data to a treeMap, which is able to display in website
	 */
	public TreeMap<Integer, ArrayList<HashMap<String, Object>>> processData(ArrayList<Map<String, Object>> result){
		TreeMap<Integer, ArrayList<HashMap<String, Object>>> output = new TreeMap<Integer, ArrayList<HashMap<String, Object>>>(
				new Comparator<Integer>() {
					public int compare(Integer a, Integer b) {
						return b - a;
					}
				});
		Iterator<Map<String, Object>> iter = result.iterator();
		int bytes = 0;
		while (iter.hasNext()){
			Map<String, Object> map = iter.next();
			HashMap<String, Object> outMap = new HashMap<String, Object>();
			outMap.put("flowid", map.get("flowid"));
			outMap.put("path", map.get("path"));
			bytes = (Integer)map.get("bytes");
			ArrayList<HashMap<String,Object>> list = output.get(bytes);
			if(list == null){
				list = new ArrayList<HashMap<String,Object>> ();
				list.add(outMap);
				output.put(bytes, list);
			}else{
				list.add(outMap);
				output.put(bytes,list);
			}
		}
		return output;
	}

}
