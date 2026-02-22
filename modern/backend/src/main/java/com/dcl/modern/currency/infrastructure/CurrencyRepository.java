package com.dcl.modern.currency.infrastructure;

import com.dcl.modern.currency.domain.Currency;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CurrencyRepository extends JpaRepository<Currency, Integer> {}
