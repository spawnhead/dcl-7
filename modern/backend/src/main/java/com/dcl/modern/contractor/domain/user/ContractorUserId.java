package com.dcl.modern.contractor.domain.user;

import java.io.Serializable;

public class ContractorUserId implements Serializable {
  private Integer contractorId;
  private Integer userId;

  public ContractorUserId() {}

  public ContractorUserId(Integer contractorId, Integer userId) {
    this.contractorId = contractorId;
    this.userId = userId;
  }

  @Override
  public int hashCode() {
    return java.util.Objects.hash(contractorId, userId);
  }

  @Override
  public boolean equals(Object obj) {
    if (this == obj) return true;
    if (!(obj instanceof ContractorUserId other)) return false;
    return java.util.Objects.equals(contractorId, other.contractorId)
        && java.util.Objects.equals(userId, other.userId);
  }
}
