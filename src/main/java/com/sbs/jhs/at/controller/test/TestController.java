package com.sbs.jhs.at.controller.test;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.tomcat.util.http.fileupload.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sbs.jhs.at.service.AttrService;
import com.sbs.jhs.at.service.FileService;
import com.sbs.jhs.at.util.Util;

@Controller
public class TestController {
	@Autowired
	private FileService fileService;
	@Autowired
	private AttrService attrService;

	@RequestMapping(value = "/test/img", method = RequestMethod.GET)
	public void showImg(HttpServletResponse response) throws IOException {
		InputStream in = getClass().getResourceAsStream("/test-file/1.jpg");
		response.setContentType(MediaType.IMAGE_JPEG_VALUE);
		IOUtils.copy(in, response.getOutputStream());
	}

	@RequestMapping(value = "/test/getAttr", method = RequestMethod.GET)
	@ResponseBody
	public String getAttr(HttpServletResponse response) throws IOException {
		attrService.setValue("member__4__common__a", "안녕", null);

		return attrService.getValue("member__4__common__a");
	}
	
	@RequestMapping(value = "/test/setAttr", method = RequestMethod.GET)
	@ResponseBody
	public String setAttr(HttpServletResponse response) throws IOException {
		// updatedMenuList
		
		Map<String, Object> menuUiData = new LinkedHashMap<>();
		menuUiData.put("menuList", new ArrayList<>());
		((List)menuUiData.get("menuList")).add(new HashMap());
		((List)menuUiData.get("menuList")).add(new HashMap());
		
		((Map)((List)menuUiData.get("menuList")).get(0)).put("age", 11);
		((Map)((List)menuUiData.get("menuList")).get(0)).put("name", "홍길동");
		
		((Map)((List)menuUiData.get("menuList")).get(1)).put("age", 22);
		((Map)((List)menuUiData.get("menuList")).get(1)).put("name", "홍길순");
		
		attrService.setValue("system__0__common__menuUi", Util.toJsonStr(menuUiData), null);

		return attrService.getValue("system__0__common__menuUi");
	}
}
