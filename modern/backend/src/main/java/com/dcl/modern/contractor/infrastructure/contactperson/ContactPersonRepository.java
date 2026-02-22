package com.dcl.modern.contractor.infrastructure.contactperson;

import com.dcl.modern.contractor.domain.contactperson.ContactPerson;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContactPersonRepository extends JpaRepository<ContactPerson, Integer> {
  List<ContactPerson> findByContractorIdOrderByIdAsc(Integer contractorId);

  void deleteByContractorId(Integer contractorId);
}
