package com.dcl.modern.contractor.infrastructure;

import com.dcl.modern.contractor.domain.Contractor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface ContractorRepository extends JpaRepository<Contractor, Integer> {

  boolean existsByUnpIgnoreCase(String unp);

  boolean existsByUnpIgnoreCaseAndIdNot(String unp, Integer id);

  @Query(
      """
      select c from Contractor c
      where (:ctrName is null or lower(c.name) like lower(concat('%', :ctrName, '%')))
        and (:ctrFullName is null or lower(coalesce(c.fullName, '')) like lower(concat('%', :ctrFullName, '%')))
        and (:ctrEmail is null or lower(coalesce(c.email, '')) like lower(concat('%', :ctrEmail, '%')))
        and (:ctrUnp is null or lower(coalesce(c.unp, '')) like lower(concat('%', :ctrUnp, '%')))
      """)
  Page<Contractor> filter(
      @Param("ctrName") String ctrName,
      @Param("ctrFullName") String ctrFullName,
      @Param("ctrEmail") String ctrEmail,
      @Param("ctrUnp") String ctrUnp,
      Pageable pageable);
}
