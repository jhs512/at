package com.sbs.jhs.at.service;

import java.io.UnsupportedEncodingException;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.sbs.jhs.at.dto.ResultData;

@Service
public class MailService {
	@Autowired
	private JavaMailSender sender;
	@Value("${custom.emailFrom}")
	private String emailFrom;
	@Value("${custom.emailFromName}")
	private String emailFromName;

	private static class MailHandler {
		private JavaMailSender sender;
		private MimeMessage message;
		private MimeMessageHelper messageHelper;

		public MailHandler(JavaMailSender sender) throws MessagingException {
			this.sender = sender;
			this.message = this.sender.createMimeMessage();
			this.messageHelper = new MimeMessageHelper(message, true, "UTF-8");
		}

		public void setFrom(String mail, String name) throws UnsupportedEncodingException, MessagingException {
			messageHelper.setFrom(mail, name);
		}

		public void setTo(String mail) throws MessagingException {
			messageHelper.setTo(mail);
		}

		public void setSubject(String subject) throws MessagingException {
			messageHelper.setSubject(subject);
		}

		public void setText(String text) throws MessagingException {
			messageHelper.setText(text, true);
		}

		public void send() {
			try {
				sender.send(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public ResultData send(String email, String title, String body) {

		MailHandler mail;
		try {
			mail = new MailHandler(sender);
			mail.setFrom(emailFrom.replaceAll(" ", ""), emailFromName);
			mail.setTo(email);
			mail.setSubject(title);
			mail.setText(body);
			mail.send();
		} catch (Exception e) {
			e.printStackTrace();
			return new ResultData("F-1", "메일이 실패하였습니다.");
		}

		return new ResultData("S-1", "메일이 발송되었습니다.");
	}
}