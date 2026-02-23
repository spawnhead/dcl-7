package com.dcl.modern.auth.api;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(AuthController.class)
@Import(com.dcl.modern.auth.application.AuthService.class)
class AuthControllerTest {

  @Autowired private MockMvc mockMvc;

  @Test
  void shouldLoginAdmin() throws Exception {
    mockMvc
        .perform(
            post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"username\":\"admin\",\"password\":\"admin\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.role").value("ADMIN"));
  }

  @Test
  void shouldLoginSupervisor() throws Exception {
    mockMvc
        .perform(
            post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"username\":\"supervisor\",\"password\":\"supervisor\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.role").value("SUPERVISOR"));
  }

  @Test
  void shouldLoginEditor() throws Exception {
    mockMvc
        .perform(
            post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"username\":\"editor\",\"password\":\"editor\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.role").value("EDITOR"));
  }


  @Test
  void shouldRejectInvalidLogin() throws Exception {
    mockMvc
        .perform(
            post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"username\":\"bad\",\"password\":\"bad\"}"))
        .andExpect(status().isNotFound());
  }
}
