package com.dcl.modern.auth.application;

import com.dcl.modern.auth.api.AuthDtos.LoginRequest;
import com.dcl.modern.auth.api.AuthDtos.LoginResponse;
import com.dcl.modern.shared.api.NotFoundException;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

  public LoginResponse login(LoginRequest request) {
    var username = request.username().trim();
    var password = request.password().trim();

    // Phase 0 baseline auth. Traceability target: legacy login flow (to be refined with roles matrix).
    if ("admin".equalsIgnoreCase(username) && "admin".equals(password)) {
      return new LoginResponse("dev-token-admin", 1, "admin", "ADMIN");
    }
    if ("user".equalsIgnoreCase(username) && "user".equals(password)) {
      return new LoginResponse("dev-token-user", 2, "user", "USER");
    }
    if ("supervisor".equalsIgnoreCase(username) && "supervisor".equals(password)) {
      return new LoginResponse("dev-token-supervisor", 3, "supervisor", "SUPERVISOR");
    }
    if ("editor".equalsIgnoreCase(username) && "editor".equals(password)) {
      return new LoginResponse("dev-token-editor", 4, "editor", "EDITOR");
    }

    throw new NotFoundException("Invalid credentials");
  }
}
