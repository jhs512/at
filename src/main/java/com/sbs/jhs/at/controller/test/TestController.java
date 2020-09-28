package com.sbs.jhs.at.controller.test;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

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

	@RequestMapping(value = "/test/img2", method = RequestMethod.GET)
	public void showImg2(HttpServletResponse response) throws IOException {
		InputStream in = new ByteArrayInputStream(fileService.getFileBodyById(1));
		response.setContentType(MediaType.IMAGE_JPEG_VALUE);
		IOUtils.copy(in, response.getOutputStream());
	}

	@RequestMapping(value = "/test/getAttr", method = RequestMethod.GET)
	@ResponseBody
	public String getAttr(HttpServletResponse response) throws IOException {
		attrService.setValue("member__4__common__a", "안녕", null);

		return attrService.getValue("member__4__common__a");
	}
}
