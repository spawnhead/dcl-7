package com.dcl.modern.contractor.domain.account;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "dcl_account")
public class Account {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "acc_id")
  private Integer id;

  @Column(name = "ctr_id", nullable = false)
  private Integer contractorId;

  @Column(name = "acc_name", length = 100)
  private String name;

  @Column(name = "acc_account", length = 35)
  private String account;

  @Column(name = "cur_id")
  private Integer currencyId;

  @Column(name = "acc_index")
  private Short indexOrder;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }
  public Integer getContractorId() { return contractorId; }
  public void setContractorId(Integer contractorId) { this.contractorId = contractorId; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getAccount() { return account; }
  public void setAccount(String account) { this.account = account; }
  public Integer getCurrencyId() { return currencyId; }
  public void setCurrencyId(Integer currencyId) { this.currencyId = currencyId; }
  public Short getIndexOrder() { return indexOrder; }
  public void setIndexOrder(Short indexOrder) { this.indexOrder = indexOrder; }
}
