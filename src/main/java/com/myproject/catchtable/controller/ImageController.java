package com.myproject.catchtable.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLDecoder;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.util.FileCopyUtils;

@Controller
@RequestMapping("/uploads")
public class ImageController {

	@GetMapping("/reviews/{fileName:.+}")
	public void showImage(@PathVariable String fileName, HttpServletResponse response) {
		try {
			// URL ���ڵ� (�ѱ� ���ϸ� ó��)
			String decodedFileName = URLDecoder.decode(fileName, "UTF-8");

			String uploadDir = System.getProperty("user.dir") + "/src/main/webapp/uploads/reviews/";
			File file = new File(uploadDir + decodedFileName);

			// ����� �α�
			System.out.println("=== �̹��� ���� ����� ===");
			System.out.println("��û�� ���ϸ�: " + fileName);
			System.out.println("���ڵ��� ���ϸ�: " + decodedFileName);
			System.out.println("���ε� ���丮: " + uploadDir);
			System.out.println("��ü ���: " + uploadDir + decodedFileName);
			System.out.println("���� ���� ����: " + file.exists());
			System.out.println("���� ũ��: " + (file.exists() ? file.length() + " bytes" : "N/A"));
			System.out.println("=======================");

			if (file.exists() && file.isFile()) {
				// ���� Ȯ���ڿ� ���� MIME Ÿ�� ����
				String mimeType = getMimeType(decodedFileName);

				response.setContentType(mimeType);
				response.setContentLength((int) file.length());
				response.setHeader("Cache-Control", "max-age=3600"); // 1�ð� ĳ��

				// ���� ��Ʈ������ ����
				FileInputStream fileInputStream = new FileInputStream(file);
				FileCopyUtils.copy(fileInputStream, response.getOutputStream());
				fileInputStream.close();

				System.out.println("�̹��� ���� ����: " + decodedFileName);

			} else {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				System.out.println("������ ã�� �� ����: " + uploadDir + decodedFileName);

				// ���丮 �� ���� ��� ��� (������)
				File dir = new File(uploadDir);
				if (dir.exists() && dir.isDirectory()) {
					System.out.println("���丮 �� ���� ���:");
					String[] files = dir.list();
					if (files != null) {
						for (String f : files) {
							System.out.println("  - " + f);
						}
					}
				} else {
					System.out.println("���ε� ���丮�� �������� ����: " + uploadDir);
				}
			}

		} catch (IOException e) {
			System.err.println("�̹��� ���� ����: " + e.getMessage());
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} catch (Exception e) {
			System.err.println("����ġ ���� ����: " + e.getMessage());
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * ���� Ȯ���ڿ� ���� MIME Ÿ�� ��ȯ
	 */
	private String getMimeType(String fileName) {
		String lowerFileName = fileName.toLowerCase();

		if (lowerFileName.endsWith(".jpg") || lowerFileName.endsWith(".jpeg")) {
			return "image/jpeg";
		} else if (lowerFileName.endsWith(".png")) {
			return "image/png";
		} else if (lowerFileName.endsWith(".gif")) {
			return "image/gif";
		} else if (lowerFileName.endsWith(".webp")) {
			return "image/webp";
		} else if (lowerFileName.endsWith(".svg")) {
			return "image/svg+xml";
		} else {
			return "image/jpeg"; // �⺻��
		}
	}

	@GetMapping("/business/{fileName:.+}")
	public void showBusinessLicense(@PathVariable String fileName, HttpServletResponse response) {
		try {
			String decodedFileName = URLDecoder.decode(fileName, "UTF-8");
			String uploadDir = System.getProperty("user.dir") + "/src/main/webapp/uploads/business/";
			File file = new File(uploadDir + decodedFileName);
			
			System.out.println("=== ����� ����� ���� ===");
			System.out.println("��û ����: " + decodedFileName);
			System.out.println("��ü ���: " + uploadDir + decodedFileName);
			System.out.println("���� ����: " + file.exists());

			if (file.exists() && file.isFile()) {
				String mimeType = getMimeType(decodedFileName);
				response.setContentType(mimeType);
				response.setContentLength((int) file.length());

				FileInputStream fileInputStream = new FileInputStream(file);
				FileCopyUtils.copy(fileInputStream, response.getOutputStream());
				fileInputStream.close();

			} else {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			}

		} catch (Exception e) {
			System.err.println("����� ����� ���� ����: " + e.getMessage());
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
}