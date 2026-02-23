package com.dcl.modern.country.infrastructure;

import com.dcl.modern.country.domain.Country;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CountryRepository extends JpaRepository<Country, Integer> {}
