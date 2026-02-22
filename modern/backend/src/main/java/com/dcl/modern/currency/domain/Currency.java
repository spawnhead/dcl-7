package com.dcl.modern.currency.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "dcl_currency")
public class Currency {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "cur_id")
  private Integer id;

  @Column(name = "cur_name", nullable = false, length = 10)
  private String name;

  @Column(name = "cur_no_round")
  private Short noRound;

  @Column(name = "cur_sort_order")
  private Short sortOrder;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public Short getNoRound() { return noRound; }
  public void setNoRound(Short noRound) { this.noRound = noRound; }
  public Short getSortOrder() { return sortOrder; }
  public void setSortOrder(Short sortOrder) { this.sortOrder = sortOrder; }
}
