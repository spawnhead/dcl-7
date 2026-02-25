package com.dcl.modern.auth.api;

import com.dcl.modern.auth.api.AuthDtos.LoginRequest;
import com.dcl.modern.auth.api.AuthDtos.LoginResponse;
import com.dcl.modern.auth.application.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

  private final AuthService authService;

  public AuthController(AuthService authService) {
    this.authService = authService;
  }

  @PostMapping("/login")
  public LoginResponse login(@RequestBody @Valid LoginRequest request) {
    return authService.login(request);
  }
}
