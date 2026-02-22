package com.dcl.modern;

import static org.assertj.core.api.Assertions.assertThat;

import com.dcl.modern.contractor.infrastructure.ContractorRepository;
import com.dcl.modern.country.infrastructure.CountryRepository;
import com.dcl.modern.currency.infrastructure.CurrencyRepository;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

@SpringBootTest(
    properties = {
      "spring.autoconfigure.exclude="
          + "org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,"
          + "org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,"
          + "org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration"
    })
class DclModernBackendApplicationTests {

  @MockBean private CountryRepository countryRepository;
  @MockBean private CurrencyRepository currencyRepository;
  @MockBean private ContractorRepository contractorRepository;

  @Test
  void contextLoads() {
    assertThat(countryRepository).isNotNull();
    assertThat(currencyRepository).isNotNull();
    assertThat(contractorRepository).isNotNull();
  }
}
