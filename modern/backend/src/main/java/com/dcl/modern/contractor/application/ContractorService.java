package com.dcl.modern.contractor.application;

import com.dcl.modern.contractor.api.ContractorDtos.ContractorBlockRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorFormResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse.FilterDefaults;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse.Lookups;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorRow;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveResponse;
import com.dcl.modern.contractor.api.ContractorDtos.LookupValue;
import com.dcl.modern.contractor.domain.Contractor;
import com.dcl.modern.contractor.infrastructure.ContractorRepository;
import com.dcl.modern.shared.api.NotFoundException;
import java.util.List;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
public class ContractorService {

  private final ContractorRepository repository;

  public ContractorService(ContractorRepository repository) {
    this.repository = repository;
  }

  @Transactional(readOnly = true)
  public ContractorLookupsResponse lookups(boolean canCreate) {
    return new ContractorLookupsResponse(
        new FilterDefaults("", "", "", "", "", "", null, null),
        new Lookups(
            List.of(new LookupValue("1", "Admin"), new LookupValue("2", "User")),
            List.of(new LookupValue("1", "Sales"), new LookupValue("2", "Logistics"))),
        canCreate);
  }

  @Transactional(readOnly = true)
  public ContractorDataResponse data(ContractorDataRequest request) {
    var page = request.page() == null ? 1 : request.page();
    var pageSize = request.pageSize() == null ? 15 : request.pageSize();
    var result =
        repository.filter(
            normalize(request.ctrName()),
            normalize(request.ctrFullName()),
            normalize(request.ctrEmail()),
            normalize(request.ctrUnp()),
            PageRequest.of(page - 1, pageSize));

    var items = result.getContent().stream().map(this::toRow).toList();
    return new ContractorDataResponse(items, page, pageSize, result.hasNext());
  }

  @Transactional(readOnly = true)
  public ContractorFormResponse openCreate(String returnTo) {
    return new ContractorFormResponse(
        null,
        normalizeReturnTo(returnTo),
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
        true);
  }

  @Transactional
  public ContractorSaveResponse create(ContractorSaveRequest request) {
    validateUnpForCreate(request.ctrUnp());
    var entity = new Contractor();
    apply(entity, request);
    var saved = repository.save(entity);
    return saveResponse(saved.getId(), request.returnTo());
  }

  @Transactional(readOnly = true)
  public ContractorFormResponse openEdit(Integer ctrId, String returnTo, String tab) {
    var entity =
        repository
            .findById(ctrId)
            .orElseThrow(() -> new NotFoundException("Contractor not found: " + ctrId));
    return new ContractorFormResponse(
        entity.getId(),
        normalizeReturnTo(returnTo),
        nullToEmpty(entity.getName()),
        nullToEmpty(entity.getFullName()),
        nullToEmpty(entity.getEmail()),
        nullToEmpty(entity.getUnp()),
        nullToEmpty(entity.getPhone()),
        nullToEmpty(entity.getFax()),
        nullToEmpty(entity.getBankProps()),
        nullToEmpty(entity.getIndexValue()),
        nullToEmpty(entity.getRegion()),
        nullToEmpty(entity.getPlace()),
        nullToEmpty(entity.getStreet()),
        nullToEmpty(entity.getBuilding()),
        nullToEmpty(entity.getAddInfo()),
        1,
        1,
        1,
        entity.getBlock() == null ? 0 : Integer.valueOf(entity.getBlock()),
        tab == null || tab.isBlank() ? "mainPanel" : tab,
        false);
  }

  @Transactional
  public ContractorSaveResponse update(Integer ctrId, ContractorSaveRequest request) {
    validateUnpForUpdate(request.ctrUnp(), ctrId);
    var entity =
        repository
            .findById(ctrId)
            .orElseThrow(() -> new NotFoundException("Contractor not found: " + ctrId));
    apply(entity, request);
    repository.save(entity);
    return saveResponse(entity.getId(), request.returnTo());
  }

  @Transactional
  public void block(ContractorBlockRequest request) {
    var entity =
        repository
            .findById(request.ctrId())
            .orElseThrow(() -> new NotFoundException("Contractor not found: " + request.ctrId()));
    entity.setBlock(request.block().shortValue());
    repository.save(entity);
  }

  @Transactional
  public void delete(Integer ctrId) {
    if (!repository.existsById(ctrId)) {
      throw new NotFoundException("Contractor not found: " + ctrId);
    }
    repository.deleteById(ctrId);
  }

  private void validateUnpForCreate(String unp) {
    var normalized = normalize(unp);
    if (normalized != null && repository.existsByUnpIgnoreCase(normalized)) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Контрагент с таким УНП уже существует");
    }
  }

  private void validateUnpForUpdate(String unp, Integer ctrId) {
    var normalized = normalize(unp);
    if (normalized != null && repository.existsByUnpIgnoreCaseAndIdNot(normalized, ctrId)) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Контрагент с таким УНП уже существует");
    }
  }

  private void apply(Contractor entity, ContractorSaveRequest request) {
    entity.setName(request.ctrName().trim());
    entity.setFullName(request.ctrFullName().trim());
    entity.setEmail(trimNullable(request.ctrEmail()));
    entity.setUnp(trimNullable(request.ctrUnp()));
    entity.setPhone(trimNullable(request.ctrPhone()));
    entity.setFax(trimNullable(request.ctrFax()));
    entity.setBankProps(trimNullable(request.ctrBankProps()));
    entity.setIndexValue(trimNullable(request.ctrIndex()));
    entity.setRegion(trimNullable(request.ctrRegion()));
    entity.setPlace(trimNullable(request.ctrPlace()));
    entity.setStreet(trimNullable(request.ctrStreet()));
    entity.setBuilding(trimNullable(request.ctrBuilding()));
    entity.setAddInfo(trimNullable(request.ctrAddInfo()));
    entity.setBlock(request.ctrBlock() == null ? 0 : request.ctrBlock().shortValue());
  }

  private ContractorSaveResponse saveResponse(Integer ctrId, String returnTo) {
    var normalized = normalizeReturnTo(returnTo);
    var redirect = "contract".equals(normalized) ? "/contracts/new" : "/references/contractors";
    return new ContractorSaveResponse(ctrId, normalized, redirect, "Контрагент успешно сохранен");
  }

  private String normalize(String value) {
    if (value == null || value.isBlank()) {
      return null;
    }
    return value.trim();
  }

  private String trimNullable(String value) {
    var normalized = normalize(value);
    return normalized == null ? "" : normalized;
  }

  private String normalizeReturnTo(String returnTo) {
    return "contract".equalsIgnoreCase(returnTo) ? "contract" : "contractors";
  }

  private ContractorRow toRow(Contractor c) {
    var address =
        String.join(
                " ",
                List.of(
                    nullToEmpty(c.getIndexValue()),
                    nullToEmpty(c.getRegion()),
                    nullToEmpty(c.getPlace()),
                    nullToEmpty(c.getStreet()),
                    nullToEmpty(c.getBuilding()),
                    nullToEmpty(c.getAddInfo())))
            .trim();
    return new ContractorRow(
        String.valueOf(c.getId()),
        c.getName(),
        c.getFullName(),
        address,
        c.getPhone(),
        c.getFax(),
        c.getEmail(),
        c.getBankProps(),
        c.getBlock() == null ? "" : String.valueOf(c.getBlock()),
        false);
  }

  private String nullToEmpty(String value) {
    return value == null ? "" : value;
  }
}
