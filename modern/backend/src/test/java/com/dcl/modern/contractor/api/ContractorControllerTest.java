package com.dcl.modern.contractor.api;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
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
import java.util.Locale;
import org.junit.jupiter.api.BeforeEach;
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

  @BeforeEach
  void setUpPermissions() {
    org.mockito.Mockito.when(service.permissionsForRole(anyString()))
        .thenAnswer(
            invocation -> {
              var role = invocation.getArgument(0, String.class);
              if (role == null) {
                return new ContractorPermissions(false, false, false, false);
              }
              return permissionsForRole(role.trim().toUpperCase(Locale.ROOT));
            });
  }


  private ContractorPermissions permissionsForRole(String role) {
    return switch (role) {
      case "ADMIN" -> new ContractorPermissions(true, true, true, true);
      case "SUPERVISOR" -> new ContractorPermissions(true, true, false, false);
      case "EDITOR" -> new ContractorPermissions(false, true, false, false);
      default -> new ContractorPermissions(false, false, false, false);
    };
  }

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
  void shouldReturnSupervisorLookupsPermissions() throws Exception {
    org.mockito.Mockito.when(service.lookups("SUPERVISOR"))
        .thenReturn(
            new ContractorLookupsResponse(
                new FilterDefaults("", "", "", "", "", "", null, null),
                new Lookups(java.util.List.of(), java.util.List.of()),
                new ContractorPermissions(true, true, false, false)));

    mockMvc
        .perform(get("/api/contractors/lookups").header("X-Role", "SUPERVISOR"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.permissions.canCreate").value(true))
        .andExpect(jsonPath("$.permissions.canBlock").value(false))
        .andExpect(jsonPath("$.permissions.canDelete").value(false));
  }

  @Test
  void shouldReturnEditorLookupsPermissions() throws Exception {
    org.mockito.Mockito.when(service.lookups("EDITOR"))
        .thenReturn(
            new ContractorLookupsResponse(
                new FilterDefaults("", "", "", "", "", "", null, null),
                new Lookups(java.util.List.of(), java.util.List.of()),
                new ContractorPermissions(false, true, false, false)));

    mockMvc
        .perform(get("/api/contractors/lookups").header("X-Role", "EDITOR"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.permissions.canEdit").value(true))
        .andExpect(jsonPath("$.permissions.canCreate").value(false));
  }


  @Test
  void shouldReturnEditorLookupsPermissionsForLowercaseHeader() throws Exception {
    org.mockito.Mockito.when(service.lookups("editor"))
        .thenReturn(
            new ContractorLookupsResponse(
                new FilterDefaults("", "", "", "", "", "", null, null),
                new Lookups(java.util.List.of(), java.util.List.of()),
                new ContractorPermissions(false, true, false, false)));

    mockMvc
        .perform(get("/api/contractors/lookups").header("X-Role", "editor"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.permissions.canEdit").value(true))
        .andExpect(jsonPath("$.permissions.canCreate").value(false));
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
        .perform(get("/api/contractors/create/open").param("returnTo", "contractors").header("X-Role", "ADMIN"))
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
                .header("X-Role", "ADMIN")
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
                .header("X-Role", "ADMIN")
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
  void shouldForbidCreateOpenForUser() throws Exception {
    mockMvc.perform(get("/api/contractors/create/open")).andExpect(status().isForbidden());
  }

  @Test
  void shouldForbidCreateSaveForUser() throws Exception {
    mockMvc
        .perform(
            post("/api/contractors/create/save")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isForbidden());
  }

  @Test
  void shouldForbidEditOpenForUser() throws Exception {
    mockMvc.perform(get("/api/contractors/1/edit/open")).andExpect(status().isForbidden());
  }

  @Test
  void shouldForbidEditSaveForUser() throws Exception {
    mockMvc
        .perform(
            put("/api/contractors/5/edit/save")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isForbidden());
  }


  @Test
  void shouldAllowEditOpenForEditorRole() throws Exception {
    org.mockito.Mockito.when(service.openEdit(eq(1), eq(null), eq(null)))
        .thenReturn(
            new ContractorFormResponse(
                1,
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
                false,
                java.util.List.of(),
                java.util.List.of(),
                java.util.List.of()));

    mockMvc
        .perform(get("/api/contractors/1/edit/open").header("X-Role", "EDITOR"))
        .andExpect(status().isOk());
  }

  @Test
  void shouldForbidBlockForSupervisorRole() throws Exception {
    mockMvc
        .perform(
            post("/api/contractors/block")
                .header("X-Role", "SUPERVISOR")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrId\":1,\"block\":1}"))
        .andExpect(status().isForbidden());
  }

  @Test
  void shouldForbidDeleteForSupervisorRole() throws Exception {
    mockMvc
        .perform(delete("/api/contractors/1").header("X-Role", "SUPERVISOR"))
        .andExpect(status().isForbidden());
  }


  @Test
  void shouldAllowCreateSaveForSupervisorRole() throws Exception {
    org.mockito.Mockito.when(service.create(any(ContractorSaveRequest.class)))
        .thenReturn(
            new ContractorSaveResponse(11, "contractors", "/references/contractors", "Контрагент успешно сохранен"));

    mockMvc
        .perform(
            post("/api/contractors/create/save")
                .header("X-Role", "SUPERVISOR")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.ctrId").value(11));
  }

  @Test
  void shouldForbidCreateSaveForEditorRole() throws Exception {
    mockMvc
        .perform(
            post("/api/contractors/create/save")
                .header("X-Role", "EDITOR")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isForbidden());
  }

  @Test
  void shouldAllowEditSaveForEditorRole() throws Exception {
    org.mockito.Mockito.when(service.update(eq(6), any(ContractorSaveRequest.class)))
        .thenReturn(
            new ContractorSaveResponse(6, "contractors", "/references/contractors", "Контрагент успешно сохранен"));

    mockMvc
        .perform(
            put("/api/contractors/6/edit/save")
                .header("X-Role", "EDITOR")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.ctrId").value(6));
  }

  @Test
  void shouldForbidBlockForEditorRole() throws Exception {
    mockMvc
        .perform(
            post("/api/contractors/block")
                .header("X-Role", "EDITOR")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrId\":1,\"block\":1}"))
        .andExpect(status().isForbidden());
  }



  @Test
  void shouldAllowCreateOpenForLowercaseSupervisorRole() throws Exception {
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
        .perform(get("/api/contractors/create/open").param("returnTo", "contractors").header("X-Role", "supervisor"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.isNewDoc").value(true));
  }

  @Test
  void shouldAllowCreateSaveForLowercaseSupervisorRole() throws Exception {
    org.mockito.Mockito.when(service.create(any(ContractorSaveRequest.class)))
        .thenReturn(
            new ContractorSaveResponse(12, "contractors", "/references/contractors", "Контрагент успешно сохранен"));

    mockMvc
        .perform(
            post("/api/contractors/create/save")
                .header("X-Role", "supervisor")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.ctrId").value(12));
  }


  @Test
  void shouldAllowEditOpenForMixedCaseEditorRole() throws Exception {
    org.mockito.Mockito.when(service.openEdit(eq(2), eq(null), eq(null)))
        .thenReturn(
            new ContractorFormResponse(
                2,
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
                false,
                java.util.List.of(),
                java.util.List.of(),
                java.util.List.of()));

    mockMvc
        .perform(get("/api/contractors/2/edit/open").header("X-Role", "eDiToR"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.ctrId").value(2));
  }

  @Test
  void shouldAllowEditSaveForMixedCaseEditorRole() throws Exception {
    org.mockito.Mockito.when(service.update(eq(7), any(ContractorSaveRequest.class)))
        .thenReturn(
            new ContractorSaveResponse(7, "contractors", "/references/contractors", "Контрагент успешно сохранен"));

    mockMvc
        .perform(
            put("/api/contractors/7/edit/save")
                .header("X-Role", "eDiToR")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrName\":\"A\",\"ctrFullName\":\"AA\",\"countryId\":1,\"reputationId\":1}"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.ctrId").value(7));
  }

  @Test
  void shouldForbidBlockForLowercaseEditorRole() throws Exception {
    mockMvc
        .perform(
            post("/api/contractors/block")
                .header("X-Role", "editor")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"ctrId\":1,\"block\":1}"))
        .andExpect(status().isForbidden());
  }

  @Test
  void shouldForbidDeleteForLowercaseSupervisorRole() throws Exception {
    mockMvc
        .perform(delete("/api/contractors/1").header("X-Role", "supervisor"))
        .andExpect(status().isForbidden());
  }

  @Test
  void shouldAllowDeleteForAdmin() throws Exception {
    mockMvc
        .perform(delete("/api/contractors/1").header("X-Role", "ADMIN"))
        .andExpect(status().isNoContent());
  }
}
