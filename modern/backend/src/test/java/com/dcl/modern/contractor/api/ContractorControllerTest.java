package com.dcl.modern.contractor.api;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorFormResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse.FilterDefaults;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse.Lookups;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorPermissions;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorRow;
import com.dcl.modern.contractor.api.ContractorDtos.LookupValue;
import com.dcl.modern.contractor.application.ContractorService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(ContractorController.class)
@Import(com.dcl.modern.shared.api.ApiExceptionHandler.class)
class ContractorControllerTest {

  @Autowired private MockMvc mockMvc;

  @MockBean private ContractorService service;

  @Test
  void shouldReturnLookups() throws Exception {
    org.mockito.Mockito.when(service.lookups("ADMIN"))
        .thenReturn(
            new ContractorLookupsResponse(
                new FilterDefaults("", "", "", "", "", "", null, null),
                new Lookups(
                    java.util.List.of(new LookupValue("1", "Admin")),
                    java.util.List.of(new LookupValue("1", "Sales"))),
                new ContractorPermissions(true, true, true, true)));

    mockMvc
        .perform(get("/api/contractors/lookups").header("X-Role", "ADMIN"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.permissions.canCreate").value(true))
        .andExpect(jsonPath("$.permissions.canDelete").value(true));
  }

  @Test
  void shouldReturnDataPage() throws Exception {
    org.mockito.Mockito.when(service.data(any(ContractorDataRequest.class)))
        .thenReturn(
            new ContractorDataResponse(
                java.util.List.of(
                    new ContractorRow("1", "A", "AF", "Addr", "1", "2", "a@x", "bank", "0", false)),
                1,
                15,
                false));

    mockMvc
        .perform(
            post("/api/contractors/data")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"page\":1,\"pageSize\":15}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.items[0].ctrName").value("A"));
  }

  @Test
  void shouldOpenCreateForm() throws Exception {
    org.mockito.Mockito.when(service.openCreate(eq("contractors")))
        .thenReturn(
            new ContractorFormResponse(
                null,
                "contractors",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                1,
                1,
                1,
                0,
                "mainPanel",
                true,
                java.util.List.of(),
                java.util.List.of(),
                java.util.List.of()));

    mockMvc
        .perform(get("/api/contractors/create/open").param("returnTo", "contractors"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.isNewDoc").value(true));
  }

  @Test
  void shouldCreateContractor() throws Exception {
    org.mockito.Mockito.when(service.create(any(ContractorSaveRequest.class)))
        .thenReturn(
            new ContractorSaveResponse(10, "contractors", "/references/contractors", "Контрагент успешно сохранен"));

    mockMvc
        .perform(
            post("/api/contractors/create/save")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.ctrId").value(10));
  }

  @Test
  void shouldUpdateContractor() throws Exception {
    org.mockito.Mockito.when(service.update(eq(5), any(ContractorSaveRequest.class)))
        .thenReturn(
            new ContractorSaveResponse(5, "contractors", "/references/contractors", "Контрагент успешно сохранен"));

    mockMvc
        .perform(
            put("/api/contractors/5/edit/save")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.ctrId").value(5));
  }

  @Test
  void shouldForbidBlockForUser() throws Exception {
    mockMvc
        .perform(
            post("/api/contractors/block")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrId\":1,\"block\":1}"))
        .andExpect(status().isForbidden());
  }

  @Test
  void shouldAllowDeleteForAdmin() throws Exception {
    mockMvc
        .perform(delete("/api/contractors/1").header("X-Role", "ADMIN"))
        .andExpect(status().isNoContent());
  }
}
