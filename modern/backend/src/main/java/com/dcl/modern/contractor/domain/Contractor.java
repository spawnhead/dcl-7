package com.dcl.modern.contractor.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "dcl_contractor")
public class Contractor {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "ctr_id")
  private Integer id;

  @Column(name = "ctr_name", nullable = false, length = 200)
  private String name;

  @Column(name = "ctr_full_name", length = 300)
  private String fullName;

  @Column(name = "ctr_email", length = 40)
  private String email;

  @Column(name = "ctr_bank_props", length = 800)
  private String bankProps;

  @Column(name = "ctr_unp", length = 15)
  private String unp;

  @Column(name = "ctr_phone", length = 100)
  private String phone;

  @Column(name = "ctr_fax", length = 100)
  private String fax;

  @Column(name = "ctr_block")
  private Short block;

  @Column(name = "ctr_index", length = 20)
  private String indexValue;

  @Column(name = "ctr_region", length = 50)
  private String region;

  @Column(name = "ctr_place", length = 50)
  private String place;

  @Column(name = "ctr_street", length = 50)
  private String street;

  @Column(name = "ctr_building", length = 10)
  private String building;

  @Column(name = "ctr_add_info", length = 1000)
  private String addInfo;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getFullName() { return fullName; }
  public void setFullName(String fullName) { this.fullName = fullName; }
  public String getEmail() { return email; }
  public void setEmail(String email) { this.email = email; }
  public String getBankProps() { return bankProps; }
  public void setBankProps(String bankProps) { this.bankProps = bankProps; }
  public String getUnp() { return unp; }
  public void setUnp(String unp) { this.unp = unp; }
  public String getPhone() { return phone; }
  public void setPhone(String phone) { this.phone = phone; }
  public String getFax() { return fax; }
  public void setFax(String fax) { this.fax = fax; }
  public Short getBlock() { return block; }
  public void setBlock(Short block) { this.block = block; }
  public String getIndexValue() { return indexValue; }
  public void setIndexValue(String indexValue) { this.indexValue = indexValue; }
  public String getRegion() { return region; }
  public void setRegion(String region) { this.region = region; }
  public String getPlace() { return place; }
  public void setPlace(String place) { this.place = place; }
  public String getStreet() { return street; }
  public void setStreet(String street) { this.street = street; }
  public String getBuilding() { return building; }
  public void setBuilding(String building) { this.building = building; }
  public String getAddInfo() { return addInfo; }
  public void setAddInfo(String addInfo) { this.addInfo = addInfo; }
}
