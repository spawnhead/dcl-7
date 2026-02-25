package com.dcl.modern.auth.api;

import jakarta.validation.constraints.NotBlank;

public class AuthDtos {

  public record LoginRequest(@NotBlank String username, @NotBlank String password) {}

  public record LoginResponse(String token, Integer userId, String username, String role) {}
}
