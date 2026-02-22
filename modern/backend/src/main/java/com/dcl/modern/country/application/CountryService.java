package com.dcl.modern.country.application;

import com.dcl.modern.country.api.CountryDtos.CountryCreateRequest;
import com.dcl.modern.country.api.CountryDtos.CountryResponse;
import com.dcl.modern.country.api.CountryDtos.CountryUpdateRequest;
import com.dcl.modern.country.domain.Country;
import com.dcl.modern.country.infrastructure.CountryRepository;
import com.dcl.modern.shared.api.NotFoundException;
import java.time.LocalDateTime;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CountryService {

  private final CountryRepository repository;

  public CountryService(CountryRepository repository) {
    this.repository = repository;
  }

  @Transactional(readOnly = true)
  public List<CountryResponse> findAll() {
    return repository.findAll().stream().map(this::toResponse).toList();
  }

  @Transactional
  public CountryResponse create(CountryCreateRequest request, Integer userId) {
    var now = LocalDateTime.now();
    var entity = new Country();
    entity.setName(request.name().trim());
    entity.setCreateDate(now);
    entity.setCreateUserId(userId);
    entity.setEditDate(now);
    entity.setEditUserId(userId);

    return toResponse(repository.save(entity));
  }

  @Transactional
  public CountryResponse update(Integer id, CountryUpdateRequest request, Integer userId) {
    var entity = repository.findById(id).orElseThrow(() -> new NotFoundException("Country not found: " + id));
    entity.setName(request.name().trim());
    entity.setEditDate(LocalDateTime.now());
    entity.setEditUserId(userId);
    return toResponse(repository.save(entity));
  }

  @Transactional
  public void delete(Integer id) {
    if (!repository.existsById(id)) {
      throw new NotFoundException("Country not found: " + id);
    }
    repository.deleteById(id);
  }

  private CountryResponse toResponse(Country country) {
    return new CountryResponse(
        country.getId(),
        country.getName(),
        country.getCreateDate(),
        country.getCreateUserId(),
        country.getEditDate(),
        country.getEditUserId());
  }
}
