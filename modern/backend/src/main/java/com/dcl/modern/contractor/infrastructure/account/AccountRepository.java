package com.dcl.modern.contractor.infrastructure.account;

import com.dcl.modern.contractor.domain.account.Account;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AccountRepository extends JpaRepository<Account, Integer> {
  List<Account> findByContractorIdOrderByIndexOrderAsc(Integer contractorId);

  void deleteByContractorId(Integer contractorId);
}
