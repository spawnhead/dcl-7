package com.dcl.modern.country.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDateTime;

@Entity
@Table(name = "dcl_country")
public class Country {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "cut_id")
  private Integer id;

  @Column(name = "cut_create_date", nullable = false)
  private LocalDateTime createDate;

  @Column(name = "usr_id_create", nullable = false)
  private Integer createUserId;

  @Column(name = "cut_edit_date", nullable = false)
  private LocalDateTime editDate;

  @Column(name = "usr_id_edit", nullable = false)
  private Integer editUserId;

  @Column(name = "cut_name", nullable = false, length = 50)
  private String name;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }
  public LocalDateTime getCreateDate() { return createDate; }
  public void setCreateDate(LocalDateTime createDate) { this.createDate = createDate; }
  public Integer getCreateUserId() { return createUserId; }
  public void setCreateUserId(Integer createUserId) { this.createUserId = createUserId; }
  public LocalDateTime getEditDate() { return editDate; }
  public void setEditDate(LocalDateTime editDate) { this.editDate = editDate; }
  public Integer getEditUserId() { return editUserId; }
  public void setEditUserId(Integer editUserId) { this.editUserId = editUserId; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
}
