package com.dcl.modern.contractor.domain.contactperson;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "dcl_contact_person")
public class ContactPerson {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "cps_id")
  private Integer id;

  @Column(name = "ctr_id", nullable = false)
  private Integer contractorId;

  @Column(name = "cps_name", nullable = false, length = 200)
  private String name;

  @Column(name = "cps_phone", length = 150)
  private String phone;

  @Column(name = "cps_fax", length = 150)
  private String fax;

  @Column(name = "cps_email", length = 50)
  private String email;

  @Column(name = "cps_position", length = 150)
  private String position;

  @Column(name = "cps_block")
  private Short block;

  @Column(name = "cps_fire")
  private Short fire;

  public Integer getId() { return id; }
  public void setId(Integer id) { this.id = id; }
  public Integer getContractorId() { return contractorId; }
  public void setContractorId(Integer contractorId) { this.contractorId = contractorId; }
  public String getName() { return name; }
  public void setName(String name) { this.name = name; }
  public String getPhone() { return phone; }
  public void setPhone(String phone) { this.phone = phone; }
  public String getFax() { return fax; }
  public void setFax(String fax) { this.fax = fax; }
  public String getEmail() { return email; }
  public void setEmail(String email) { this.email = email; }
  public String getPosition() { return position; }
  public void setPosition(String position) { this.position = position; }
  public Short getBlock() { return block; }
  public void setBlock(Short block) { this.block = block; }
  public Short getFire() { return fire; }
  public void setFire(Short fire) { this.fire = fire; }
}
