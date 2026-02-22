package com.dcl.modern.country.api;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import java.time.LocalDateTime;

public class CountryDtos {

  public record CountryResponse(
      Integer id,
      String name,
      LocalDateTime createDate,
      Integer createUserId,
      LocalDateTime editDate,
      Integer editUserId) {}

  public record CountryCreateRequest(@NotBlank @Size(max = 50) String name) {}

  public record CountryUpdateRequest(@NotBlank @Size(max = 50) String name) {}
}
