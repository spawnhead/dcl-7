package com.dcl.modern.contractor.api;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import java.util.List;

public class ContractorDtos {

  public record LookupValue(String id, String name) {}

  public record ContractorLookupsResponse(FilterDefaults defaults, Lookups lookups, boolean canCreate) {
    public record FilterDefaults(
        String ctrName,
        String ctrFullName,
        String ctrAccount,
        String ctrAddress,
        String ctrEmail,
        String ctrUnp,
        LookupValue user,
        LookupValue department) {}

    public record Lookups(List<LookupValue> users, List<LookupValue> departments) {}
  }

  public record ContractorDataRequest(
      String ctrName,
      String ctrFullName,
      String ctrAccount,
      String ctrAddress,
      String ctrEmail,
      String ctrUnp,
      LookupValue user,
      LookupValue department,
      @Min(1) Integer page,
      @Min(1) @Max(100) Integer pageSize) {}

  public record ContractorRow(
      String ctrId,
      String ctrName,
      String ctrFullName,
      String ctrAddress,
      String ctrPhone,
      String ctrFax,
      String ctrEmail,
      String ctrBankProps,
      String ctrBlock,
      boolean occupied) {}

  public record ContractorDataResponse(
      List<ContractorRow> items,
      Integer page,
      Integer pageSize,
      boolean hasNextPage) {}

  public record ContractorBlockRequest(@NotNull Integer ctrId, @NotNull @Min(0) @Max(1) Integer block) {}

  public record ContractorFormResponse(
      Integer ctrId,
      String returnTo,
      String ctrName,
      String ctrFullName,
      String ctrEmail,
      String ctrUnp,
      String ctrPhone,
      String ctrFax,
      String ctrBankProps,
      String ctrIndex,
      String ctrRegion,
      String ctrPlace,
      String ctrStreet,
      String ctrBuilding,
      String ctrAddInfo,
      Integer countryId,
      Integer reputationId,
      Integer currencyId,
      Integer ctrBlock,
      String activeTab,
      boolean isNewDoc) {}

  public record ContractorSaveRequest(
      @NotBlank @Size(max = 200) String ctrName,
      @NotBlank @Size(max = 300) String ctrFullName,
      @Size(max = 40) String ctrEmail,
      @Size(max = 15) String ctrUnp,
      @Size(max = 100) String ctrPhone,
      @Size(max = 100) String ctrFax,
      @Size(max = 800) String ctrBankProps,
      @Size(max = 20) String ctrIndex,
      @Size(max = 50) String ctrRegion,
      @Size(max = 50) String ctrPlace,
      @Size(max = 50) String ctrStreet,
      @Size(max = 10) String ctrBuilding,
      @Size(max = 1000) String ctrAddInfo,
      @NotNull Integer countryId,
      @NotNull Integer reputationId,
      Integer currencyId,
      Integer ctrBlock,
      String returnTo,
      String activeTab) {}

  public record ContractorSaveResponse(Integer ctrId, String returnTo, String redirectTo, String message) {}
}
