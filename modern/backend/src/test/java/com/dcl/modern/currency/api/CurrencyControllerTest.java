package com.dcl.modern.currency.api;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.dcl.modern.currency.api.CurrencyDtos.CurrencyCreateRequest;
import com.dcl.modern.currency.api.CurrencyDtos.CurrencyResponse;
import com.dcl.modern.currency.api.CurrencyDtos.CurrencyUpdateRequest;
import com.dcl.modern.currency.application.CurrencyService;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(CurrencyController.class)
@Import(com.dcl.modern.shared.api.ApiExceptionHandler.class)
class CurrencyControllerTest {

  @Autowired private MockMvc mockMvc;

  @MockBean private CurrencyService service;

  @Test
  void shouldListCurrencies() throws Exception {
    org.mockito.Mockito.when(service.findAll())
        .thenReturn(List.of(new CurrencyResponse(1, "USD", (short) 0, (short) 1)));

    mockMvc
        .perform(get("/api/currencies"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$[0].name").value("USD"));
  }

  @Test
  void shouldCreateCurrency() throws Exception {
    org.mockito.Mockito.when(service.create(any(CurrencyCreateRequest.class)))
        .thenReturn(new CurrencyResponse(2, "EUR", (short) 1, (short) 2));

    mockMvc
        .perform(
            post("/api/currencies")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"name\":\"EUR\",\"noRound\":1,\"sortOrder\":2}"))
        .andExpect(status().isCreated())
        .andExpect(jsonPath("$.id").value(2));
  }

  @Test
  void shouldUpdateCurrency() throws Exception {
    org.mockito.Mockito.when(service.update(eq(5), any(CurrencyUpdateRequest.class)))
        .thenReturn(new CurrencyResponse(5, "BYN", (short) 0, (short) 3));

    mockMvc
        .perform(
            put("/api/currencies/5")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"name\":\"BYN\",\"noRound\":0,\"sortOrder\":3}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.name").value("BYN"));
  }

  @Test
  void shouldDeleteCurrency() throws Exception {
    mockMvc.perform(delete("/api/currencies/5")).andExpect(status().isNoContent());
  }
}
