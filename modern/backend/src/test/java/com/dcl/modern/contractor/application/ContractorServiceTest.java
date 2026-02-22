package com.dcl.modern.contractor.application;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import com.dcl.modern.contractor.api.ContractorDtos.ContractorSaveRequest;
import com.dcl.modern.contractor.domain.Contractor;
import com.dcl.modern.contractor.infrastructure.ContractorRepository;
import org.junit.jupiter.api.Test;
import org.springframework.web.server.ResponseStatusException;

class ContractorServiceTest {

  private final ContractorRepository repository = org.mockito.Mockito.mock(ContractorRepository.class);
  private final ContractorService service = new ContractorService(repository);

  @Test
  void shouldRejectDuplicateUnpOnCreate() {
    when(repository.existsByUnpIgnoreCase("123456")).thenReturn(true);

    var request =
        new ContractorSaveRequest(
            "A",
            "AA",
            null,
            "123456",
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
            "mainPanel");

    var ex = assertThrows(ResponseStatusException.class, () -> service.create(request));
    assertEquals(400, ex.getStatusCode().value());
  }

  @Test
  void shouldSaveWhenUnpUnique() {
    when(repository.existsByUnpIgnoreCase("123456")).thenReturn(false);
    var entity = new Contractor();
    entity.setId(77);
    when(repository.save(any(Contractor.class))).thenReturn(entity);

    var request =
        new ContractorSaveRequest(
            "A",
            "AA",
            null,
            "123456",
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
            "mainPanel");

    var result = service.create(request);
    assertEquals(77, result.ctrId());
  }
}
