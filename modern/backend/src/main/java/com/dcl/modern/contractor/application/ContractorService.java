package com.dcl.modern.contractor.application;

import com.dcl.modern.contractor.api.ContractorDtos.ContractorAccountRow;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorBlockRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorContactPersonRow;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorDataResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorFormResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse.FilterDefaults;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorLookupsResponse.Lookups;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorPermissions;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorRow;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveRequest;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveResponse;
import com.dcl.modern.contractor.api.ContractorDtos.ContractorUserRow;
import com.dcl.modern.contractor.api.ContractorDtos.LookupValue;
import com.dcl.modern.contractor.domain.Contractor;
import com.dcl.modern.contractor.domain.account.Account;
import com.dcl.modern.contractor.domain.contactperson.ContactPerson;
import com.dcl.modern.contractor.domain.user.ContractorUser;
import com.dcl.modern.contractor.infrastructure.ContractorRepository;
import com.dcl.modern.contractor.infrastructure.account.AccountRepository;
import com.dcl.modern.contractor.infrastructure.contactperson.ContactPersonRepository;
import com.dcl.modern.contractor.infrastructure.user.ContractorUserRepository;
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
  private final ContractorUserRepository userRepository;
  private final AccountRepository accountRepository;
  private final ContactPersonRepository contactPersonRepository;

  public ContractorService(
      ContractorRepository repository,
      ContractorUserRepository userRepository,
      AccountRepository accountRepository,
      ContactPersonRepository contactPersonRepository) {
    this.repository = repository;
    this.userRepository = userRepository;
    this.accountRepository = accountRepository;
    this.contactPersonRepository = contactPersonRepository;
  }

  @Transactional(readOnly = true)
  public ContractorLookupsResponse lookups(String role) {
    var permissions = permissionsForRole(role);
    return new ContractorLookupsResponse(
        new FilterDefaults("", "", "", "", "", "", null, null),
        new Lookups(
            List.of(new LookupValue("1", "Admin"), new LookupValue("2", "User")),
            List.of(new LookupValue("1", "Sales"), new LookupValue("2", "Logistics"))),
        permissions);
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
        true,
        List.of(new ContractorUserRow(1, "Текущий пользователь")),
        List.of(
            new ContractorAccountRow("", "", null, 1, true),
            new ContractorAccountRow("", "", null, 2, true),
            new ContractorAccountRow("", "", null, 3, true)),
        List.of());
  }

  @Transactional
  public ContractorSaveResponse create(ContractorSaveRequest request) {
    validateUnpForCreate(request.ctrUnp());
    validateAccounts(request.accounts());
    var entity = new Contractor();
    apply(entity, request);
    var saved = repository.save(entity);
    syncChildren(saved.getId(), request);
    return saveResponse(saved.getId(), request.returnTo());
  }

  @Transactional(readOnly = true)
  public ContractorFormResponse openEdit(Integer ctrId, String returnTo, String tab) {
    var entity =
        repository
            .findById(ctrId)
            .orElseThrow(() -> new NotFoundException("Contractor not found: " + ctrId));

    var users =
        userRepository.findByContractorIdOrderByUserIdAsc(ctrId).stream()
            .map(u -> new ContractorUserRow(u.getUserId(), "User " + u.getUserId()))
            .toList();

    var accounts =
        accountRepository.findByContractorIdOrderByIndexOrderAsc(ctrId).stream()
            .map(
                a ->
                    new ContractorAccountRow(
                        nullToEmpty(a.getName()),
                        nullToEmpty(a.getAccount()),
                        a.getCurrencyId(),
                        a.getIndexOrder() == null ? 0 : Integer.valueOf(a.getIndexOrder()),
                        a.getIndexOrder() != null && a.getIndexOrder() <= 3))
            .toList();

    var contacts =
        contactPersonRepository.findByContractorIdOrderByIdAsc(ctrId).stream()
            .map(
                cp ->
                    new ContractorContactPersonRow(
                        cp.getName(),
                        nullToEmpty(cp.getPhone()),
                        nullToEmpty(cp.getFax()),
                        nullToEmpty(cp.getEmail()),
                        nullToEmpty(cp.getPosition()),
                        cp.getBlock() == null ? 0 : Integer.valueOf(cp.getBlock()),
                        cp.getFire() == null ? 0 : Integer.valueOf(cp.getFire())))
            .toList();

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
        false,
        users,
        accounts,
        contacts);
  }

  @Transactional
  public ContractorSaveResponse update(Integer ctrId, ContractorSaveRequest request) {
    validateUnpForUpdate(request.ctrUnp(), ctrId);
    validateAccounts(request.accounts());
    var entity =
        repository
            .findById(ctrId)
            .orElseThrow(() -> new NotFoundException("Contractor not found: " + ctrId));
    apply(entity, request);
    repository.save(entity);
    syncChildren(ctrId, request);
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
    userRepository.deleteByContractorId(ctrId);
    accountRepository.deleteByContractorId(ctrId);
    contactPersonRepository.deleteByContractorId(ctrId);
    repository.deleteById(ctrId);
  }

  private void syncChildren(Integer contractorId, ContractorSaveRequest request) {
    userRepository.deleteByContractorId(contractorId);
    accountRepository.deleteByContractorId(contractorId);
    contactPersonRepository.deleteByContractorId(contractorId);

    var users = request.users() == null ? List.<ContractorUserRow>of() : request.users();
    for (var user : users) {
      var entity = new ContractorUser();
      entity.setContractorId(contractorId);
      entity.setUserId(user.userId());
      userRepository.save(entity);
    }

    var accounts = request.accounts() == null ? List.<ContractorAccountRow>of() : request.accounts();
    for (var row : accounts) {
      if ((row.accAccount() == null || row.accAccount().isBlank())
          && (row.currencyId() == null)) {
        continue;
      }
      var entity = new Account();
      entity.setContractorId(contractorId);
      entity.setName(normalize(row.accName()));
      entity.setAccount(normalize(row.accAccount()));
      entity.setCurrencyId(row.currencyId());
      entity.setIndexOrder((short) row.accIndex().intValue());
      accountRepository.save(entity);
    }

    var contacts = request.contactPersons() == null ? List.<ContractorContactPersonRow>of() : request.contactPersons();
    for (var row : contacts) {
      var entity = new ContactPerson();
      entity.setContractorId(contractorId);
      entity.setName(row.cpsName().trim());
      entity.setPhone(normalize(row.cpsPhone()));
      entity.setFax(normalize(row.cpsFax()));
      entity.setEmail(normalize(row.cpsEmail()));
      entity.setPosition(normalize(row.cpsPosition()));
      entity.setBlock((short) (row.cpsBlock() == null ? 0 : row.cpsBlock().intValue()));
      entity.setFire((short) (row.cpsFire() == null ? 0 : row.cpsFire().intValue()));
      contactPersonRepository.save(entity);
    }
  }


  public ContractorPermissions permissionsForRole(String role) {
    var normalized = role == null ? "" : role.trim();
    if ("ADMIN".equalsIgnoreCase(normalized)) {
      return new ContractorPermissions(true, true, true, true);
    }
    if ("SUPERVISOR".equalsIgnoreCase(normalized)) {
      return new ContractorPermissions(true, true, false, false);
    }
    if ("EDITOR".equalsIgnoreCase(normalized)) {
      return new ContractorPermissions(false, true, false, false);
    }
    return new ContractorPermissions(false, false, false, false);
  }

  private void validateUnpForCreate(String unp) {
    var normalized = normalize(unp);
    if (normalized != null && repository.existsByUnpIgnoreCase(normalized)) {
      throw new ResponseStatusException(
          HttpStatus.BAD_REQUEST, "Контрагент с таким УНП уже существует");
    }
  }

  private void validateUnpForUpdate(String unp, Integer ctrId) {
    var normalized = normalize(unp);
    if (normalized != null && repository.existsByUnpIgnoreCaseAndIdNot(normalized, ctrId)) {
      throw new ResponseStatusException(
          HttpStatus.BAD_REQUEST, "Контрагент с таким УНП уже существует");
    }
  }

  private void validateAccounts(List<ContractorAccountRow> accounts) {
    if (accounts == null) {
      return;
    }
    for (var row : accounts) {
      var hasAccount = row.accAccount() != null && !row.accAccount().isBlank();
      var hasCurrency = row.currencyId() != null;
      if (row.isDefault()) {
        if (hasAccount && !hasCurrency) {
          throw new ResponseStatusException(
              HttpStatus.BAD_REQUEST,
              "Для default-счета при заполненном счете требуется валюта");
        }
      } else if (hasAccount != hasCurrency) {
        throw new ResponseStatusException(
            HttpStatus.BAD_REQUEST,
            "Для custom-счета необходимо заполнить и счет, и валюту");
      }
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
