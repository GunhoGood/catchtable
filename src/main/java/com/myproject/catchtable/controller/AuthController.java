package com.myproject.catchtable.controller;

import com.myproject.catchtable.dto.ApiResponse;
import com.myproject.catchtable.dto.LoginRequest;
import com.myproject.catchtable.dto.RegisterRequest;
import com.myproject.catchtable.model.User;
import com.myproject.catchtable.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.ui.Model;
import java.io.File;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/auth")
public class AuthController {

	@Autowired
	private UserService userService;

	// 로그인 페이지
	@GetMapping("/login")
	public String loginPage(HttpServletRequest request, Model model) {
	    // 로그인 이전 페이지 URL 저장 (referer 사용)
	    String referer = request.getHeader("Referer");
	    String redirectUrl = "/catchtable/"; // 기본값은 메인 페이지
	    
	    if (referer != null && !referer.contains("/auth/")) {
	        // /auth/ 경로가 아닌 이전 페이지를 리다이렉트 URL로 설정
	        redirectUrl = referer;
	    }
	    
	    // 쿼리 파라미터로 redirect가 명시적으로 전달된 경우 우선 사용
	    String explicitRedirect = request.getParameter("redirect");
	    if (explicitRedirect != null && !explicitRedirect.trim().isEmpty()) {
	        redirectUrl = explicitRedirect;
	    }
	    
	    model.addAttribute("redirectUrl", redirectUrl);
	    return "login";
	}

	// 회원가입 약관 페이지
	@GetMapping("/terms")
	public String termsPage() {
		return "terms";
	}

	// 회원가입 유형 선택 페이지
	@GetMapping("/select-type")
	public String selectTypePage() {
		return "select-type";
	}

	// 일반 회원가입 페이지
	@GetMapping("/register")
	public String registerPage() {
		return "register";
	}

	// 사업자 회원가입 페이지
	@GetMapping("/business-register")
	public String businessRegisterPage() {
		return "business-register";
	}

	//  기존 로그인 처리 
	@PostMapping("/login")
	@ResponseBody
	public ApiResponse login(@RequestBody LoginRequest request, HttpSession session) {
		try {
			// 사용자 조회
			User user = userService.findByEmail(request.getEmail());
			if (user == null) {
				return ApiResponse.error("존재하지 않는 이메일입니다.");
			}

			// 비밀번호 확인 (실제로는 암호화된 비밀번호와 비교해야 함)
			if (!user.getPassword().equals(request.getPassword())) {
				return ApiResponse.error("비밀번호가 일치하지 않습니다.");
			}

			// 사업자 승인 상태 확인
			if (user.isBusiness()) {
				if (user.isPending()) {
					return ApiResponse.error("계정 승인 대기 중입니다. 관리자 승인을 기다려주세요.");
				}
				if (user.isRejected()) {
					return ApiResponse.error("계정이 거부되었습니다. 사유: " + user.getRejectionReason());
				}
			}

			// 세션에 사용자 정보 저장
			session.setAttribute("userId", user.getUserId());
			session.setAttribute("userEmail", user.getEmail());
			session.setAttribute("userName", user.getName());
			session.setAttribute("userType", user.getUserType());
			session.setAttribute("user", user); // 전체 객체도 저장 (필요시 사용)

			// 세션 유지 시간 설정 (30분)
			session.setMaxInactiveInterval(30 * 60);

			// 로그인 성공
			return new ApiResponse("로그인 성공", user.getUserId());

		} catch (Exception e) {
			return ApiResponse.error("로그인 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	//  일반회원/관리자 전용 로그인 처리
	@PostMapping("/user-login")
	@ResponseBody
	public ApiResponse userLogin(@RequestBody LoginRequest request, HttpSession session) {
		try {
			// 사용자 조회
			User user = userService.findByEmail(request.getEmail());
			if (user == null) {
				return ApiResponse.error("존재하지 않는 이메일입니다.");
			}

			// 비밀번호 확인
			if (!user.getPassword().equals(request.getPassword())) {
				return ApiResponse.error("비밀번호가 일치하지 않습니다.");
			}

			//  일반회원 또는 관리자 계정인지 확인
			if ("BUSINESS".equals(user.getUserType())) {
				return ApiResponse.error("사업자 계정입니다. 사업자 탭에서 로그인해주세요.");
			}

			// 세션에 사용자 정보 저장
			session.setAttribute("userId", user.getUserId());
			session.setAttribute("userEmail", user.getEmail());
			session.setAttribute("userName", user.getName());
			session.setAttribute("userType", user.getUserType());
			session.setAttribute("user", user);

			// 세션 유지 시간 설정 (30분)
			session.setMaxInactiveInterval(30 * 60);

			// 로그인 성공
			return new ApiResponse("로그인 성공", user.getUserId());

		} catch (Exception e) {
			return ApiResponse.error("로그인 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	//사업자 전용 로그인 처리
	@PostMapping("/business-login")
	@ResponseBody
	public ApiResponse businessLogin(@RequestBody LoginRequest request, HttpSession session) {
		try {
			// 사용자 조회
			User user = userService.findByEmail(request.getEmail());
			if (user == null) {
				return ApiResponse.error("존재하지 않는 이메일입니다.");
			}

			// 비밀번호 확인
			if (!user.getPassword().equals(request.getPassword())) {
				return ApiResponse.error("비밀번호가 일치하지 않습니다.");
			}

			//  사업자 계정인지 확인
			if (!"BUSINESS".equals(user.getUserType())) {
				return ApiResponse.error("사업자 계정이 아닙니다. 일반회원 탭에서 로그인해주세요.");
			}

			// 사업자 승인 상태 확인
			if (user.isPending()) {
				return ApiResponse.error("계정 승인 대기 중입니다. 관리자 승인을 기다려주세요.");
			}
			if (user.isRejected()) {
				return ApiResponse.error("계정이 거부되었습니다. 사유: " + user.getRejectionReason());
			}

			// 세션에 사용자 정보 저장
			session.setAttribute("userId", user.getUserId());
			session.setAttribute("userEmail", user.getEmail());
			session.setAttribute("userName", user.getName());
			session.setAttribute("userType", user.getUserType());
			session.setAttribute("user", user);

			// 세션 유지 시간 설정 (30분)
			session.setMaxInactiveInterval(30 * 60);

			// 사업자 로그인 성공
			return new ApiResponse("사업자 로그인 성공", user.getUserId());

		} catch (Exception e) {
			return ApiResponse.error("사업자 로그인 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	// 일반 회원가입 처리
	@PostMapping("/register")
	@ResponseBody
	public ApiResponse register(@RequestBody RegisterRequest request, HttpSession session) {
		try {
			// 입력값 검증
			if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
				return ApiResponse.error("이메일은 필수입니다.");
			}
			if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
				return ApiResponse.error("비밀번호는 필수입니다.");
			}
			if (request.getName() == null || request.getName().trim().isEmpty()) {
				return ApiResponse.error("이름은 필수입니다.");
			}

			// 이메일 중복 체크
			if (userService.isEmailExists(request.getEmail())) {
				return ApiResponse.error("이미 존재하는 이메일입니다.");
			}

			// User 객체 생성
			User user = new User();
			user.setEmail(request.getEmail());
			user.setPassword(request.getPassword()); // 실제로는 암호화해야 함
			user.setName(request.getName());
			user.setPhone(request.getPhone());
			user.setBirthDate(request.getBirthDate());
			user.setGender(request.getGender());
			user.setUserType("USER");
			user.setApprovalStatus("APPROVED"); // 일반 회원은 바로 승인

			// 회원가입 처리
			userService.registerUser(user);

			User registeredUser = userService.findByEmail(request.getEmail());
	        session.setAttribute("userId", registeredUser.getUserId());
	        session.setAttribute("userEmail", registeredUser.getEmail());
	        session.setAttribute("userName", registeredUser.getName());
	        session.setAttribute("userType", registeredUser.getUserType());
	        session.setAttribute("user", registeredUser);
	        
	        return new ApiResponse("회원가입이 완료되었습니다!", "PREFERENCES"); // 특별한 응답 코드
	        
	    } catch (Exception e) {
	        return ApiResponse.error("회원가입 중 오류가 발생했습니다: " + e.getMessage());
	    }
	}

	// 사업자 회원가입 처리
	@PostMapping("/business-register")
	@ResponseBody
	public ApiResponse businessRegister(
	    @RequestParam String email,
	    @RequestParam String password, 
	    @RequestParam String name,
	    @RequestParam String phone,
	    @RequestParam String businessLicenseNumber,
	    @RequestParam(required = false) MultipartFile businessLicenseFile) {
	    
	    try {
	        // 입력값 검증
	        if (email == null || email.trim().isEmpty()) {
	            return ApiResponse.error("이메일은 필수입니다.");
	        }
	        if (password == null || password.trim().isEmpty()) {
	            return ApiResponse.error("비밀번호는 필수입니다.");
	        }
	        if (name == null || name.trim().isEmpty()) {
	            return ApiResponse.error("이름은 필수입니다.");
	        }
	        
	        // 이메일 중복 체크
	        if (userService.isEmailExists(email)) {
	            return ApiResponse.error("이미 사용중인 이메일입니다.");
	        }
	        
	        // User 객체 생성
	        User user = new User();
	        user.setEmail(email);
	        user.setPassword(password); // 실제로는 암호화해야 함
	        user.setName(name);
	        user.setPhone(phone);
	        user.setUserType("BUSINESS");
	        user.setApprovalStatus("PENDING"); // 승인 대기
	        user.setBusinessLicenseNumber(businessLicenseNumber);
	        
	        if (businessLicenseFile != null && !businessLicenseFile.isEmpty()) {
	            String savedFileName = uploadBusinessLicenseFile(businessLicenseFile);
	            if (savedFileName != null) {
	                user.setBusinessLicenseImage(savedFileName);
	                System.out.println("사업자 등록증 파일 업로드 성공: " + savedFileName);
	            } else {
	                return ApiResponse.error("사업자 등록증 파일 업로드에 실패했습니다.");
	            }
	        }
	        
	        // 사업자 회원가입 처리
	        userService.registerBusiness(user);
	        return new ApiResponse("사업자 등록 신청이 완료되었습니다. 관리자 승인을 기다려주세요.");
	        
	    } catch (Exception e) {
	        return ApiResponse.error("사업자 등록 중 오류가 발생했습니다: " + e.getMessage());
	    }
	    
	}
	//파일 업로드 메서드  
	private String uploadBusinessLicenseFile(MultipartFile file) {
	    try {
	        // 업로드 디렉토리 설정
	        String uploadDir = System.getProperty("user.dir") + "/src/main/webapp/uploads/business/";
	        File uploadDirFile = new File(uploadDir);
	        
	        // 디렉토리가 없으면 생성
	        if (!uploadDirFile.exists()) {
	            uploadDirFile.mkdirs();
	            System.out.println("사업자 등록증 업로드 디렉토리 생성: " + uploadDir);
	        }
	        
	        // 파일명 생성 (중복 방지)
	        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();
	        String filePath = uploadDir + fileName;
	        
	        // 실제 파일 저장
	        file.transferTo(new File(filePath));
	        System.out.println("사업자 등록증 파일 저장 완료: " + filePath);
	        
	        return fileName;
	        
	    } catch (Exception e) {
	        System.err.println("사업자 등록증 업로드 오류: " + e.getMessage());
	        e.printStackTrace();
	        return null;
	    }
	}
	// 로그아웃
	@PostMapping("/logout")
	public String logout(HttpSession session) {
		// 세션 무효화
		session.invalidate();
		return "redirect:/"; // 메인페이지로 리다이렉트
	}

	// 로그아웃 (AJAX용)
	@PostMapping("/logout-ajax")
	@ResponseBody
	public ApiResponse logoutAjax(HttpSession session) {
		// 세션 무효화
		session.invalidate();
		return new ApiResponse("로그아웃되었습니다.");
	}

	// 로그인 체크 (AJAX용)
	@GetMapping("/check")
	@ResponseBody
	public ApiResponse checkLogin(HttpSession session) {
		Integer userId = (Integer) session.getAttribute("userId");
		if (userId != null) {
			return new ApiResponse("로그인 상태", userId);
		} else {
			return ApiResponse.error("로그인이 필요합니다.");
		}
	}

	// 이메일 중복체크
	@PostMapping("/check-email")
	@ResponseBody
	public ApiResponse checkEmail(@RequestParam String email) {
		if (userService.isEmailExists(email)) {
			return ApiResponse.error("이미 사용중인 이메일입니다.");
		}
		return new ApiResponse("사용 가능한 이메일입니다.");
	}

	// 이메일 중복체크 - 사업자 
	@PostMapping("/check-business-email")
	@ResponseBody
	public ApiResponse checkBusinessEmail(@RequestParam String email) {
		if (userService.isEmailExists(email)) {
			return ApiResponse.error("이미 사용중인 이메일입니다.");
		}
		return new ApiResponse("사용 가능한 이메일입니다.");
	}
}