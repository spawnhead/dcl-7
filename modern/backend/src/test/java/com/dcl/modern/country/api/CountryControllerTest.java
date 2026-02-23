package com.dcl.modern.country.api;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.dcl.modern.country.api.CountryDtos.CountryCreateRequest;
import com.dcl.modern.country.api.CountryDtos.CountryResponse;
import com.dcl.modern.country.api.CountryDtos.CountryUpdateRequest;
import com.dcl.modern.country.application.CountryService;
import java.time.LocalDateTime;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(CountryController.class)
@Import(com.dcl.modern.shared.api.ApiExceptionHandler.class)
class CountryControllerTest {

  @Autowired private MockMvc mockMvc;

  @MockBean private CountryService service;

  @Test
  void shouldListCountries() throws Exception {
    var now = LocalDateTime.now();
    org.mockito.Mockito.when(service.findAll())
        .thenReturn(List.of(new CountryResponse(1, "Belarus", now, 1, now, 1)));

    mockMvc
        .perform(get("/api/countries"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$[0].id").value(1))
        .andExpect(jsonPath("$[0].name").value("Belarus"));
  }

  @Test
  void shouldCreateCountry() throws Exception {
    var now = LocalDateTime.now();
    org.mockito.Mockito.when(service.create(any(CountryCreateRequest.class), eq(7)))
        .thenReturn(new CountryResponse(2, "Poland", now, 7, now, 7));

    mockMvc
        .perform(
            post("/api/countries")
                .header("X-User-Id", "7")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"name\":\"Poland\"}"))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.id").value(2));
  }

  @Test
  void shouldValidateCreateRequest() throws Exception {
    mockMvc
        .perform(post("/api/countries").contentType(MediaType.APPLICATION_JSON).content("{\"name\":\"\"}"))
        .andExpect(status().isBadRequest());
  }

  @Test
  void shouldUpdateCountry() throws Exception {
    var now = LocalDateTime.now();
    org.mockito.Mockito.when(service.update(eq(5), any(CountryUpdateRequest.class), eq(9)))
        .thenReturn(new CountryResponse(5, "Lithuania", now, 1, now, 9));

    mockMvc
        .perform(
            put("/api/countries/5")
                .header("X-User-Id", "9")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"name\":\"Lithuania\"}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.name").value("Lithuania"));
  }

  @Test
  void shouldDeleteCountry() throws Exception {
    mockMvc.perform(delete("/api/countries/3")).andExpect(status().isNoContent());
  }
}
