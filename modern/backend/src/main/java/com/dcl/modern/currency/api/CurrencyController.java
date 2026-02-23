package com.dcl.modern.currency.api;

import com.dcl.modern.currency.api.CurrencyDtos.CurrencyCreateRequest;
import com.dcl.modern.currency.api.CurrencyDtos.CurrencyResponse;
import com.dcl.modern.currency.api.CurrencyDtos.CurrencyUpdateRequest;
import com.dcl.modern.currency.application.CurrencyService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/currencies")
public class CurrencyController {

  private final CurrencyService service;

  public CurrencyController(CurrencyService service) {
    this.service = service;
  }

  @GetMapping
  public List<CurrencyResponse> findAll() {
    // Traceability: legacy list screen Currencies.jsp + currency.jsp.
    return service.findAll();
  }

  @PostMapping
  @ResponseStatus(HttpStatus.CREATED)
  public CurrencyResponse create(@RequestBody @Valid CurrencyCreateRequest request) {
    return service.create(request);
  }

  @PutMapping("/{id}")
  public CurrencyResponse update(@PathVariable Integer id, @RequestBody @Valid CurrencyUpdateRequest request) {
    return service.update(id, request);
  }

  @DeleteMapping("/{id}")
  @ResponseStatus(HttpStatus.NO_CONTENT)
  public void delete(@PathVariable Integer id) {
    service.delete(id);
  }
}
