package com.dcl.modern.contractor.application;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveRequest;
import com.dcl.modern.contractor.domain.Contractor;
import com.dcl.modern.contractor.infrastructure.ContractorRepository;
import com.dcl.modern.contractor.infrastructure.account.AccountRepository;
import com.dcl.modern.contractor.infrastructure.contactperson.ContactPersonRepository;
import com.dcl.modern.contractor.infrastructure.user.ContractorUserRepository;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.web.server.ResponseStatusException;

class ContractorServiceTest {

  private final ContractorRepository repository = org.mockito.Mockito.mock(ContractorRepository.class);
  private final ContractorUserRepository userRepository = org.mockito.Mockito.mock(ContractorUserRepository.class);
  private final AccountRepository accountRepository = org.mockito.Mockito.mock(AccountRepository.class);
  private final ContactPersonRepository contactPersonRepository = org.mockito.Mockito.mock(ContactPersonRepository.class);

  private final ContractorService service =
      new ContractorService(repository, userRepository, accountRepository, contactPersonRepository);

  @Test
  void shouldRejectDuplicateUnpOnCreate() {
    when(repository.existsByUnpIgnoreCase("123456")).thenReturn(true);

    var request = baseRequest("123456");

    var ex = assertThrows(ResponseStatusException.class, () -> service.create(request));
    assertEquals(400, ex.getStatusCode().value());
  }

  @Test
  void shouldSaveWhenUnpUnique() {
    when(repository.existsByUnpIgnoreCase("123456")).thenReturn(false);
    var entity = new Contractor();
    entity.setId(77);
    when(repository.save(any(Contractor.class))).thenReturn(entity);

    var request = baseRequest("123456");

    var result = service.create(request);
    assertEquals(77, result.ctrId());
  }


  @Test
  void shouldReturnPermissionsByRole() {
    var admin = service.permissionsForRole("ADMIN");
    var supervisor = service.permissionsForRole("SUPERVISOR");
    var editor = service.permissionsForRole("EDITOR");
    var user = service.permissionsForRole("USER");

    assertEquals(true, admin.canCreate());
    assertEquals(true, admin.canDelete());

    assertEquals(true, supervisor.canCreate());
    assertEquals(true, supervisor.canEdit());
    assertEquals(false, supervisor.canBlock());
    assertEquals(false, supervisor.canDelete());

    assertEquals(false, editor.canCreate());
    assertEquals(true, editor.canEdit());
    assertEquals(false, editor.canBlock());
    assertEquals(false, editor.canDelete());

    assertEquals(false, user.canCreate());
    assertEquals(false, user.canEdit());
  }


  @Test
  void shouldNormalizeRoleInputBeforePermissionsCheck() {
    var paddedSupervisor = service.permissionsForRole("  supervisor  ");
    var nullRole = service.permissionsForRole(null);

    assertEquals(true, paddedSupervisor.canCreate());
    assertEquals(false, paddedSupervisor.canBlock());
    assertEquals(false, paddedSupervisor.canDelete());

    assertEquals(false, nullRole.canCreate());
    assertEquals(false, nullRole.canEdit());
  }


  @Test
  void shouldHandleMixedCaseRoleInput() {
    var mixedCaseEditor = service.permissionsForRole("eDiToR");

    assertEquals(true, mixedCaseEditor.canEdit());
    assertEquals(false, mixedCaseEditor.canCreate());
    assertEquals(false, mixedCaseEditor.canDelete());
  }

  private ContractorSaveRequest baseRequest(String unp) {
    return new ContractorSaveRequest(
        "A",
        "AA",
        null,
        unp,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        1,
        1,
        1,
        0,
        "contractors",
        "mainPanel",
        List.of(),
        List.of(),
        List.of());
  }
}
