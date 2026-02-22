package com.dcl.modern.contractor.infrastructure.user;

import com.dcl.modern.contractor.domain.user.ContractorUser;
import com.dcl.modern.contractor.domain.user.ContractorUserId;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ContractorUserRepository extends JpaRepository<ContractorUser, ContractorUserId> {
  List<ContractorUser> findByContractorIdOrderByUserIdAsc(Integer contractorId);

  void deleteByContractorId(Integer contractorId);
}
