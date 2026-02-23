package com.dcl.modern.contractor.domain.user;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

@Entity
@Table(name = "dcl_contractor_user")
@IdClass(ContractorUserId.class)
public class ContractorUser {

  @Id
  @Column(name = "ctr_id", nullable = false)
  private Integer contractorId;

  @Id
  @Column(name = "usr_id", nullable = false)
  private Integer userId;

  public Integer getContractorId() { return contractorId; }
  public void setContractorId(Integer contractorId) { this.contractorId = contractorId; }
  public Integer getUserId() { return userId; }
  public void setUserId(Integer userId) { this.userId = userId; }
}
