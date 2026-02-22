package com.dcl.modern.currency.api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class CurrencyDtos {

  public record CurrencyResponse(Integer id, String name, Short noRound, Short sortOrder) {}

  public record CurrencyCreateRequest(
      @NotBlank @Size(max = 10) String name,
      Short noRound,
      Short sortOrder) {}

  public record CurrencyUpdateRequest(
      @NotBlank @Size(max = 10) String name,
      Short noRound,
      Short sortOrder) {}
}
