package com.dcl.modern.country.api;

import com.dcl.modern.country.api.CountryDtos.CountryCreateRequest;
import com.dcl.modern.country.api.CountryDtos.CountryResponse;
import com.dcl.modern.country.api.CountryDtos.CountryUpdateRequest;
import com.dcl.modern.country.application.CountryService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/countries")
public class CountryController {

  private final CountryService service;

  public CountryController(CountryService service) {
    this.service = service;
  }

  @GetMapping
  public List<CountryResponse> findAll() {
    // Traceability: legacy list screen Countries.jsp (docs/screens/countries/spec.md).
    return service.findAll();
  }

  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  public CountryResponse create(
      @RequestBody @Valid CountryCreateRequest request,
      @RequestHeader(name = "X-User-Id", defaultValue = "1") Integer userId) {
    return service.create(request, userId);
  }

  @PutMapping("/{id}")
  public CountryResponse update(
      @PathVariable Integer id,
      @RequestBody @Valid CountryUpdateRequest request,
      @RequestHeader(name = "X-User-Id", defaultValue = "1") Integer userId) {
    return service.update(id, request, userId);
  }

  @DeleteMapping("/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@PathVariable Integer id) {
    service.delete(id);
  }
}
