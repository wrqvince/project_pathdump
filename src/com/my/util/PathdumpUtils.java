package com.my.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import net.dongliu.requests.RawResponse;
import net.dongliu.requests.Requests;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class PathdumpUtils {
	private static String url = "http://192.168.137.139:5000/pathdump";

	/**
	 * Read the content of a file, according to the path of this file
	 * 
	 * @param filePath
	 * @return
	 */
	public static String readFile(String filePath) {
		FileReader reader = null;
		BufferedReader br = null;
		StringBuffer sb = null;
		String str = null;
		try {
			// read file content from file
			sb = new StringBuffer("");

			reader = new FileReader(filePath);
			br = new BufferedReader(reader);

			while ((str = br.readLine()) != null) {
				sb.append(str + "\n");
			}
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				reader.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
			try {
				br.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return sb.toString();
	}

	/**
	 * Http get method
	 * 
	 * @param api
	 * @param filename
	 * @param data
	 * @return
	 */
	public static RawResponse sendGetRequest(HashMap<String, Object> data) {
		Map<String, Object> headers = new HashMap<>();
		headers.put("Content-Type", "application/json");
		// change map to json object
		Charset cs = Charset.forName("gbk");
		JSONObject jsonData = JSONObject.fromObject(data); // change HashMap to
															// Json string.
		return Requests.get(url).headers(headers).requestCharset(cs)// request
																	// encode
				.body(jsonData.toString())// content of query.py
				.send().withCharset(cs);// receive encode
	}

	/**
	 * Http post method
	 * 
	 * @param api
	 * @param filename
	 * @param data
	 * @return
	 */
	public static RawResponse sendPostRequest(HashMap<String, Object> data) {
		Map<String, Object> headers = new HashMap<>();
		headers.put("Content-Type", "application/json");
		// change map to json object
		Charset cs = Charset.forName("gbk");
		JSONObject jsonData = JSONObject.fromObject(data); // change HashMap to
															// Json string.
		return Requests.post(url).headers(headers).requestCharset(cs)// request
																		// encode
				.body(jsonData.toString())// content of query.py
				.send().withCharset(cs);// receive encode

	}

	public static String registerQuery(String queryContent, String queryName) {
		HashMap<String, Object> query = new HashMap<String, Object>();
//		String queryContent = PathdumpUtils.readFile(queryPath);
		query.put("api", "registerQuery");
		query.put("data", queryContent);
		query.put("name", queryName);
		
		RawResponse result = PathdumpUtils.sendGetRequest(query);
		String content = result.readToText();
		if (result.getStatusCode() == 200) {
			return content;
		} else {
			return null;
		}
	}

	public static ArrayList<Map<String, Object>> executeQuery(HashMap<String, Object> tree,
			HashMap<String, Object> query, HashMap<String, Object> aggCode) {
		JSONArray hosts = checkSource(tree, (String) query.get("name"));
		HashMap<String, Object> req = new HashMap<String, Object>();
		req = buildReq("execQuery", tree, query, aggCode, null);
		RawResponse result = PathdumpUtils.sendGetRequest(req);
		String content = result.readToText();
		ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = str2jsonArrayList(content,1);

		if (result.getStatusCode() == 200) {
			return list;
		} else {
			return null;
		}
	}
	
	public static String installQuery(HashMap<String, Object> tree,
			HashMap<String, Object> query, String interval){
		HashMap<String, Object> req = new HashMap<String, Object>();
		req = buildReq("installQuery", tree, query, null , interval);
		RawResponse result = PathdumpUtils.sendPostRequest(req);
		String content = result.readToText();
		ArrayList<Map<String, Object>> str2jsonArrayList = str2jsonArrayList(content,0);
		return content;
	}
	
	public static String uninstallQuery(HashMap<String, Object> tree,
			HashMap<String, Object> query){
		HashMap<String, Object> req = new HashMap<String, Object>();
		req = buildReq("uninstallQuery", tree, query, null, null);
		RawResponse result = PathdumpUtils.sendPostRequest(req);
		String content = result.readToText();
		ArrayList<Map<String, Object>> str2jsonArrayList = str2jsonArrayList(content,0);
		return content;
	}
	
	public static HashMap<String, Object> buildReq(String api, HashMap<String, Object> tree,
			HashMap<String, Object> query, HashMap<String, Object> aggCode, String interval) {
		HashMap<String, Object> req = new HashMap<String, Object>();
		req.put("api", api);
		req.put("tree", tree);
		req.put("query", query);
		if (aggCode != null) {
			req.put("aggcode", aggCode);
		}
		if (interval != null) {
			req.put("interval", interval);
		}
		return req;
	}

	public static JSONArray checkSource(HashMap<String, Object> tree, String fileName) {
		HashMap<String, Object> req = new HashMap<String, Object>();
		req.put("api", "check_source");
		req.put("tree", tree);
		req.put("name", "topk_query.py");

		RawResponse result = PathdumpUtils.sendPostRequest(req);
		String content = result.readToText();
		JSONArray json = JSONArray.fromObject(content);
		return json;
	}

	public static boolean sendSource(JSONArray hosts, HashMap<String, Object> tree, String fileName) {
		if (SourceAvailableAt(hosts))
			return true;
		HashMap<String, Object> sendTree = removeHostFromTree(hosts, tree);
		HashMap<String, Object> req = new HashMap<String, Object>();
		req.put("api", "send_source");
		req.put("tree", sendTree);
		req.put("name", fileName);
		RawResponse result = PathdumpUtils.sendPostRequest(req);
		String content = result.readToText();	//[true] or [false]
		ArrayList list = str2jsonArrayList(content,0);
		boolean flag = (boolean)list.get(0);
		return flag;
	}

	public static HashMap<String, Object> removeHostFromTree(JSONArray hosts, HashMap<String, Object> tree) {
		HashMap<String, Object> sendTree = new HashMap<String, Object>();
		sendTree = (HashMap<String, Object>) tree.clone();
		for (int i = 0; i < hosts.size(); i++) {
			HashMap<String, Object> object = Json2Map(hosts.getString(i));
			Iterator<Entry<String, Object>> iter = object.entrySet().iterator();
			while (iter.hasNext()) {
				Entry<String, Object> next = iter.next();
				String host = (String) next.getKey();
				boolean val = (boolean) next.getValue();
				String parent = (String) ((HashMap) sendTree.get(host)).get("parent");
				String[] child = (String[]) ((HashMap) sendTree.get(host)).get("child");
				ArrayList<String> newChild = (ArrayList<String>) ((HashMap) sendTree.get(parent)).get("child");
				if (child.length > 0) {
					for (int j = 0; j < child.length; j++) {
						newChild.add(child[i]);
						String newParent = (String) ((HashMap) sendTree.get(child[i])).get("parent");
						newParent = parent;
					}
				}
				newChild.remove(host);

			}
		}

		return sendTree;
	}

	public static boolean SourceAvailableAt(JSONArray hosts) {
		for (int i = 0; i < hosts.size(); i++) {
			HashMap<String, Object> object = Json2Map(hosts.getString(i));
			Iterator<Entry<String, Object>> iter = object.entrySet().iterator();
			while (iter.hasNext()) {
				Entry<String, Object> next = iter.next();
				if ((boolean) next.getValue() != true)
					return false;
			}
		}
		return true;
	}
	
	/**
	 * Get aggregation tree
	 * 
	 * @return
	 */
	public static HashMap<String, Object> getAggTree() {
		HashMap<String, Object> queryGetAggTree = new HashMap<String, Object>();
		String[] groupnodes = { "controller" };
		queryGetAggTree.put("api", "getAggTree");
		queryGetAggTree.put("groupnodes", groupnodes);

		RawResponse result = PathdumpUtils.sendGetRequest(queryGetAggTree);
		String content = result.readToText();
		content = content.substring(1, content.length() - 1);

		// change jsonString to hashmap object
		HashMap<String, Object> map = Json2Map(content);
		if (result.getStatusCode() == 200) {
			return map;
		} else {
			return null;
		}
	}
	
	public static String getFlowCollectionDir(){
		HashMap<String, Object> req = new HashMap<String, Object>();
		req.put("api", "getFlowCollDir");
		RawResponse result = PathdumpUtils.sendGetRequest(req);
		String content = result.readToText();
		content = content.substring(2,content.length()-2);
		if (result.getStatusCode() == 200) {
			return content;
		} else {
			return null;
		}
	}
	
	public static ArrayList<Map<String,Object>> startFlowcoll(){
		String dirpath = getFlowCollectionDir();
		HashMap<String, Object> req = new HashMap<String, Object>();
		req.put("api", "startFlowcoll");
		req.put("dirpath", dirpath);
		RawResponse result = PathdumpUtils.sendGetRequest(req);
		String content = result.readToText();
		
		ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		list = str2jsonMapList(content);
		return list;
		
	}
	
	public static String stopFlowcoll(){
		HashMap<String, Object> req = new HashMap<String, Object>();
		req.put("api", "stopFlowcoll");
		RawResponse result = PathdumpUtils.sendGetRequest(req);
		String content = result.readToText();
		
		return content;
	}

	public static ArrayList<Map<String, Object>> str2jsonArrayList(String content,int index) {
		ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		JSONArray json = JSONArray.fromObject(content);
		for (int i = 0; i < json.size(); i++) {
			JSONArray innerJson = JSONArray.fromObject(json.get(i));
			list.add(Json2Map(innerJson.getString(index)));
		}
		return list;
	}

	public static ArrayList<Map<String, Object>> str2jsonMapList(String content) {
		ArrayList<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		JSONArray json = JSONArray.fromObject(content);
		for (int i = 0; i < json.size(); i++) {
			JSONArray innerJson = JSONArray.fromObject(json.get(i));
			if(innerJson.size()==0) return null;
			for(int j=0;j<innerJson.size();j++){
				list.add(Json2Map(innerJson.getString(j)));
			}
		}
		return list;
	}
	
	public static HashMap<String, Object> Json2Map(String jsonStr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		// parse most outside level
		JSONObject json = JSONObject.fromObject(jsonStr);
		for (Object k : json.keySet()) {
			Object v = json.get(k);
			// if inner level is still json
			if (v instanceof JSONObject) {
				map.put(k.toString(), Json2Map(v.toString()));
			} else {
				map.put(k.toString(), v);
			}
		}
		return map;
	}
}
