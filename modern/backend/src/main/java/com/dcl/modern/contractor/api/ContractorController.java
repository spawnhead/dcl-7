package com.dcl.modern.contractor.api;

import com.dcl.modern.contractor.api.ContractorDtos.ContractorBlockRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorFormResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveResponse;
import com.dcl.modern.contractor.application.ContractorService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/contractors")
public class ContractorController {

  private final ContractorService service;

  public ContractorController(ContractorService service) {
    this.service = service;
  }

  @GetMapping("/lookups")
  public ContractorLookupsResponse lookups(
      @RequestHeader(name = "X-Role", defaultValue = "USER") String role) {
    // Traceability: ContractorsAction#input + users/departments serverList lookups.
    return service.lookups(isAdmin(role));
  }

  @PostMapping("/data")
  public ContractorDataResponse data(@RequestBody @Valid ContractorDataRequest request) {
    return service.data(request);
  }

  @GetMapping("/create/open")
  public ContractorFormResponse openCreate(
      @RequestParam(name = "returnTo", required = false) String returnTo) {
    return service.openCreate(returnTo);
  }

  @PostMapping("/create/save")
  public ContractorSaveResponse create(@RequestBody @Valid ContractorSaveRequest request) {
    return service.create(request);
  }

  @GetMapping("/{ctrId}/edit/open")
  public ContractorFormResponse openEdit(
      @PathVariable Integer ctrId,
      @RequestParam(name = "returnTo", required = false) String returnTo,
      @RequestParam(name = "tab", required = false) String tab) {
    return service.openEdit(ctrId, returnTo, tab);
  }

  @PutMapping("/{ctrId}/edit/save")
  public ContractorSaveResponse update(
      @PathVariable Integer ctrId,
      @RequestBody @Valid ContractorSaveRequest request) {
    return service.update(ctrId, request);
  }

  @PostMapping("/block")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void block(
      @RequestBody @Valid ContractorBlockRequest request,
      @RequestHeader(name = "X-Role", defaultValue = "USER") String role) {
    ensureAdmin(role);
    service.block(request);
  }

  @DeleteMapping("/{ctrId}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(
      @PathVariable Integer ctrId,
      @RequestHeader(name = "X-Role", defaultValue = "USER") String role) {
    ensureAdmin(role);
    service.delete(ctrId);
  }

  private void ensureAdmin(String role) {
    if (!isAdmin(role)) {
      throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Admin role required");
    }
  }

  private boolean isAdmin(String role) {
    return "ADMIN".equalsIgnoreCase(role);
  }
}
