package com.dcl.modern.currency.application;

import com.dcl.modern.currency.api.CurrencyDtos.CurrencyCreateRequest;
import com.dcl.modern.currency.api.CurrencyDtos.CurrencyResponse;
import com.dcl.modern.currency.api.CurrencyDtos.CurrencyUpdateRequest;
import com.dcl.modern.currency.domain.Currency;
import com.dcl.modern.currency.infrastructure.CurrencyRepository;
import com.dcl.modern.shared.api.NotFoundException;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CurrencyService {

  private final CurrencyRepository repository;

  public CurrencyService(CurrencyRepository repository) {
    this.repository = repository;
  }

  @Transactional(readOnly = true)
  public List<CurrencyResponse> findAll() {
    return repository.findAll().stream().map(this::toResponse).toList();
  }

  @Transactional
  public CurrencyResponse create(CurrencyCreateRequest request) {
    var entity = new Currency();
    entity.setName(request.name().trim());
    entity.setNoRound(request.noRound());
    entity.setSortOrder(request.sortOrder());
    return toResponse(repository.save(entity));
  }

  @Transactional
  public CurrencyResponse update(Integer id, CurrencyUpdateRequest request) {
    var entity = repository.findById(id).orElseThrow(() -> new NotFoundException("Currency not found: " + id));
    entity.setName(request.name().trim());
    entity.setNoRound(request.noRound());
    entity.setSortOrder(request.sortOrder());
    return toResponse(repository.save(entity));
  }

  @Transactional
  public void delete(Integer id) {
    if (!repository.existsById(id)) {
      throw new NotFoundException("Currency not found: " + id);
    }
    repository.deleteById(id);
  }

  private CurrencyResponse toResponse(Currency currency) {
    return new CurrencyResponse(currency.getId(), currency.getName(), currency.getNoRound(), currency.getSortOrder());
  }
}
