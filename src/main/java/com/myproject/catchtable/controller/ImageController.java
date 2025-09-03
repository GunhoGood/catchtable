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
			// URL 디코딩 (한글 파일명 처리)
			String decodedFileName = URLDecoder.decode(fileName, "UTF-8");

			String uploadDir = System.getProperty("user.dir") + "/src/main/webapp/uploads/reviews/";
			File file = new File(uploadDir + decodedFileName);

			// 디버깅 로그
			System.out.println("=== 이미지 서빙 디버깅 ===");
			System.out.println("요청된 파일명: " + fileName);
			System.out.println("디코딩된 파일명: " + decodedFileName);
			System.out.println("업로드 디렉토리: " + uploadDir);
			System.out.println("전체 경로: " + uploadDir + decodedFileName);
			System.out.println("파일 존재 여부: " + file.exists());
			System.out.println("파일 크기: " + (file.exists() ? file.length() + " bytes" : "N/A"));
			System.out.println("=======================");

			if (file.exists() && file.isFile()) {
				// 파일 확장자에 따른 MIME 타입 설정
				String mimeType = getMimeType(decodedFileName);

				response.setContentType(mimeType);
				response.setContentLength((int) file.length());
				response.setHeader("Cache-Control", "max-age=3600"); // 1시간 캐시

				// 파일 스트림으로 전송
				FileInputStream fileInputStream = new FileInputStream(file);
				FileCopyUtils.copy(fileInputStream, response.getOutputStream());
				fileInputStream.close();

				System.out.println("이미지 서빙 성공: " + decodedFileName);

			} else {
				response.setStatus(HttpServletResponse.SC_NOT_FOUND);
				System.out.println("파일을 찾을 수 없음: " + uploadDir + decodedFileName);

				// 디렉토리 내 파일 목록 출력 (디버깅용)
				File dir = new File(uploadDir);
				if (dir.exists() && dir.isDirectory()) {
					System.out.println("디렉토리 내 파일 목록:");
					String[] files = dir.list();
					if (files != null) {
						for (String f : files) {
							System.out.println("  - " + f);
						}
					}
				} else {
					System.out.println("업로드 디렉토리가 존재하지 않음: " + uploadDir);
				}
			}

		} catch (IOException e) {
			System.err.println("이미지 서빙 오류: " + e.getMessage());
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		} catch (Exception e) {
			System.err.println("예상치 못한 오류: " + e.getMessage());
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}

	/**
	 * 파일 확장자에 따른 MIME 타입 반환
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
			return "image/jpeg"; // 기본값
		}
	}

	@GetMapping("/business/{fileName:.+}")
	public void showBusinessLicense(@PathVariable String fileName, HttpServletResponse response) {
		try {
			String decodedFileName = URLDecoder.decode(fileName, "UTF-8");
			String uploadDir = System.getProperty("user.dir") + "/src/main/webapp/uploads/business/";
			File file = new File(uploadDir + decodedFileName);
			
			System.out.println("=== 사업자 등록증 서빙 ===");
			System.out.println("요청 파일: " + decodedFileName);
			System.out.println("전체 경로: " + uploadDir + decodedFileName);
			System.out.println("파일 존재: " + file.exists());

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
			System.err.println("사업자 등록증 서빙 오류: " + e.getMessage());
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
}