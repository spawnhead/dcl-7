# Commercial Proposal Edit Screen - SNAPSHOT

## Screen Identity
- **Screen Name**: Commercial Proposal Edit (Create/Edit CP)
- **Legacy JSP**: `src/main/webapp/jsp/CommercialProposal.jsp` (1951 lines)
- **Struts Action**: `/CommercialProposalAction` (session-scoped)
- **Action Class**: `net.sam.dcl.action.CommercialProposalAction`
- **Form Bean**: `net.sam.dcl.form.CommercialProposalForm`
- **Mode**: Create + Edit (unified screen)

## Source Trace
| Aspect | Legacy Source |
|--------|---------------|
| Main JSP | `src/main/webapp/jsp/CommercialProposal.jsp` |
| Action | `src/main/java/net/sam/dcl/action/CommercialProposalAction.java` |
| Produce Dialog | `src/main/webapp/jsp/CommercialProposalProduce.jsp` |
| Produces Grid (AJAX) | `src/main/webapp/ajax/ProducesCommercialProposalGrid.jsp` |
| Minsk Store Grid (AJAX) | `src/main/webapp/ajax/ProducesForAssembleMinskGrid.jsp` |
| Reserved Info Grid (AJAX) | `src/main/webapp/ajax/ReservedInfoGrid.jsp` |
| Struts Config | `struts-config.xml` - `/CommercialProposalAction` mapping |

## Entry Points
1. **Create New**: `CommercialProposalAction.input()` - from CP list "New" button
2. **Edit Existing**: `CommercialProposalAction.edit()` - from CP list row click
3. **Clone New Version**: `CommercialProposalAction.cloneLikeNewVersion()`
4. **Clone Old Version**: `CommercialProposalAction.cloneLikeOldVersion()`

## Screen Modes

### Mode 1: Regular CP
Standard commercial proposal with DBO produce links.

### Mode 2: Minsk Store Assemble (`cpr_assemble_minsk_store = "1"`)
Special mode for goods stored in Minsk warehouse:
- Currency locked to BYN
- Course locked to 1
- Price condition locked to DDP
- NDS by string locked to "1" (Yes)
- Custom fields: guaranty, prepay, delay_days, provider_delivery, consignee

### Mode 3: Old Version (`cpr_old_version = "1"`)
Free-text produces without DBO links.

---

## Screen Sections

### 1. Header Section
| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| cpr_number | Text (readonly) | `form.cpr_number` | Auto-generated: `BYM{YYMM}/{num}-{code}` |
| contractor | ServerList (Contractor) | `form.contractor` | Required |
| contactPerson | ServerList (ContactPerson) | `form.contactPerson` | Filtered by contractor |
| cpr_date | Date | `form.cpr_date` | Default: current date |
| blank | ServerList (Blank) | `form.blank` | Print template |
| cpr_img_name | Text | `form.cpr_img_name` | Image name |

### 2. Currency Section
| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| currency | ServerList (Currency) | `form.currency` | Print currency |
| currencyTable | ServerList (Currency) | `form.currencyTable` | Table currency |
| cpr_course | Input | `form.cpr_course` | Exchange rate |
| cpr_nds | Input | `form.cpr_nds` | NDS rate % |
| cpr_nds_by_string | Checkbox | `form.cpr_nds_by_string` | NDS line-by-line |
| cpr_free_prices | Checkbox | `form.cpr_free_prices` | Free prices mode |
| cpr_reverse_calc | Checkbox | `form.cpr_reverse_calc` | Reverse calculation |
| cpr_donot_calculate_netto | Checkbox | `form.cpr_donot_calculate_netto` | Don't calculate netto |

### 3. Mode Flags Section
| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| cpr_old_version | Checkbox | `form.cpr_old_version` | Old format (free-text) |
| cpr_assemble_minsk_store | Checkbox | `form.cpr_assemble_minsk_store` | Minsk store mode |
| cpr_no_reservation | Checkbox | `form.cpr_no_reservation` | No reservation |

### 4. Produces Grid (Main Table)
**Grid ID**: `gridProduces`
**AJAX URL**: `CommercialProposalAction.ajaxProducesCommercialProposalGrid()`

**Columns (Regular Mode)**:
| Column | Field | Type | Editable |
|--------|-------|------|----------|
| № | number | Text | N |
| Catalog № | catalogNumber | Text | Y (old version) |
| Product Name | produceFullName | Link | N |
| Unit | unitName | Text | N |
| Count | lpr_count | Input | Y |
| Price brutto | lpr_price_brutto | Input | Y |
| Discount | lpr_discount | Input | Y |
| Price netto | lpr_price_netto | Text | N |
| NDS | lpr_nds | Text | N |
| Sum netto | lpr_sum_netto | Text | N |
| Sum brutto | lpr_sum_brutto | Text | N |
| Custom code | code | Input | Y |
| Custom duty % | custom_duty_percent | Text | N |
| Custom duty | custom_duty | Input | Y |
| Coefficient | lpr_coeficient | Text | N |
| Actions | - | Buttons | - |

**Grid Actions**:
- `newProduce` - Add new line
- `editProduce` - Edit line
- `deleteProduce` - Delete line
- `importExcel` - Import from Excel
- `uploadTemplate` - Upload Excel template

### 5. Minsk Store Grid (AJAX)
**Grid ID**: `gridProducesForAssembleMinsk`
**AJAX URL**: `CommercialProposalAction.ajaxProducesForAssembleMinskGrid()`
**Visible When**: `cpr_assemble_minsk_store = "1"`

**Columns**:
| Column | Field | Type |
|--------|-------|------|
| № | number | Text |
| Catalog № | catalogNumber | Text |
| Product Name | produceFullName | Text |
| Count | lpr_count | Input |
| Price | sale_price_parking_trans_custom | Input |
| NDS | lpr_nds | Text |
| Sum with NDS | lpr_sum_brutto | Text |
| Reserved | reservedInfo | Link (AJAX) |

### 6. Price/Delivery Conditions Section
| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| priceCondition | ServerList (IncoTerm) | `form.priceCondition` | Price condition |
| deliveryCondition | ServerList (IncoTerm) | `form.deliveryCondition` | Delivery condition |
| cpr_country | Text | `form.cpr_country` | Country |
| cpr_pay_condition | Textarea | `form.cpr_pay_condition` | Payment conditions |
| cpr_pay_condition_invoice | Textarea | `form.cpr_pay_condition_invoice` | Invoice payment conditions |
| cpr_delivery_address | Text | `form.cpr_delivery_address` | Delivery address |
| cpr_delivery_term | Text | `form.cpr_delivery_term` | Delivery term |
| cpr_delivery_term_invoice | Text | `form.cpr_delivery_term_invoice` | Invoice delivery term |
| cpr_sum_transport | Input | `form.cpr_sum_transport` | Transport sum |
| cpr_all_transport | Checkbox | `form.cpr_all_transport` | All transport |
| cpr_sum_assembling | Input | `form.cpr_sum_assembling` | Assembly sum |

### 7. Charges Grid
| Column | Field | Type |
|--------|-------|------|
| Name | name | Text |
| Sum | sum | Input |

### 8. Minsk Store Specific Section
**Visible When**: `cpr_assemble_minsk_store = "1"`

| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| cpr_guaranty_in_month | Input | `form.cpr_guaranty_in_month` | Guaranty months |
| cpr_prepay_percent | Input | `form.cpr_prepay_percent` | Prepay % |
| cpr_prepay_sum | Input | `form.cpr_prepay_sum` | Prepay sum |
| cpr_delay_days | Input | `form.cpr_delay_days` | Delay days |
| consignee | ServerList (Contractor) | `form.consignee` | Consignee |
| contactPersonSeller | ServerList | `form.contactPersonSeller` | Seller contact |
| contactPersonCustomer | ServerList | `form.contactPersonCustomer` | Customer contact |
| cpr_provider_delivery | Checkbox | `form.cpr_provider_delivery` | Provider delivery |
| cpr_provider_delivery_address | Text | `form.cpr_provider_delivery_address` | Provider address |
| cpr_delivery_count_day | Input | `form.cpr_delivery_count_day` | Delivery days |

### 9. Additional Info Section
| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| cpr_concerning | Text | `form.cpr_concerning` | Subject |
| cpr_concerning_invoice | Text | `form.cpr_concerning_invoice` | Invoice subject |
| cpr_preamble | Textarea | `form.cpr_preamble` | Preamble |
| cpr_add_info | Textarea | `form.cpr_add_info` | Additional info |
| cpr_final_date | Date | `form.cpr_final_date` | Valid until |
| cpr_final_date_invoice | Date | `form.cpr_final_date_invoice` | Invoice valid until |
| cpr_final_date_above | Checkbox | `form.cpr_final_date_above` | Final date above |
| user | ServerList (User) | `form.user` | Manager |
| executor | ServerList (User) | `form.executor` | Executor |
| cpr_executor_flag | Checkbox | `form.cpr_executor_flag` | Executor flag |
| purchasePurpose | ServerList | `form.purchasePurpose` | Purchase purpose |
| cpr_comment | Textarea | `form.cpr_comment` | Comment |

### 10. Status Section
| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| cpr_date_accept | Date | `form.cpr_date_accept` | Accept date |
| cpr_proposal_received_flag | Checkbox | `form.cpr_proposal_received_flag` | Accepted |
| cpr_proposal_declined | Checkbox | `form.cpr_proposal_declined` | Declined |
| cpr_tender_number | Text | `form.cpr_tender_number` | Tender number |
| cpr_tender_number_editable | Checkbox | `form.cpr_tender_number_editable` | Tender editable |
| facsimile_flag | Checkbox | `form.facsimile_flag` | Facsimile |

### 11. Attachments Section
**Grid**: `attachmentsGrid`
**Actions**:
- `deferredAttach` - Add attachment
- `downloadAttachment` - Download
- `deleteAttachment` - Delete

### 12. Print Parameters Section
| Field | Type | Source Binding | Notes |
|-------|------|----------------|-------|
| cpr_print_scale | Select | `form.cpr_print_scale` | Print scale % |
| cpr_contract_scale | Select | `form.cpr_contract_scale` | Contract scale % |
| cpr_invoice_scale | Select | `form.cpr_invoice_scale` | Invoice scale % |
| include_exps | Checkbox | `form.include_exps` | Include expenses |
| show_unit | Checkbox | `form.show_unit` | Show units |

---

## Form Actions (Dispatch Methods)

| Action | Method | Forward | Description |
|--------|--------|---------|-------------|
| input | `input()` | form | Create new CP |
| edit | `edit()` | form | Load existing CP |
| cloneLikeNewVersion | `cloneLikeNewVersion()` | form | Clone (new format) |
| cloneLikeOldVersion | `cloneLikeOldVersion()` | form | Clone (old format) |
| process | `process()` | back | Save and return |
| reload | `reload()` | form | Refresh form |
| reloadWithClean | `reloadWithClean()` | form | Clean produces |
| reloadPrice | `reloadPrice()` | form | Reload price condition |
| print | `print()` | form | Save and print |
| printInvoice | `printInvoice()` | form | Print invoice |
| printContract | `printContract()` | form | Print contract |
| back | `back()` | back | Cancel |
| newContractor | `newContractor()` | newContractor | Create contractor |
| newContactPerson | `newContactPerson()` | newContactPerson | Create contact |
| newProduce | `newProduce()` | newProduce/edit | Add produce |
| editProduce | `editProduce()` | editProduce | Edit produce |
| importExcel | `importExcel()` | importExcel | Import Excel |
| uploadTemplate | `uploadTemplate()` | uploadTemplate | Upload template |
| deferredAttach | `deferredAttach()` | deferredAttach | Add attachment |
| deleteAttachment | `deleteAttachment()` | form | Delete attachment |
| downloadAttachment | `downloadAttachment()` | - | Download attachment |

---

## AJAX Actions

| Action | Method | Parameters | Description |
|--------|--------|------------|-------------|
| ajaxProducesCommercialProposalGrid | `ajaxProducesCommercialProposalGrid()` | - | Get produces grid |
| ajaxDeleteAllProducesCommercialProposalGrid | `ajaxDeleteAllProducesCommercialProposalGrid()` | - | Clear all produces |
| ajaxRemoveFromCommercialProposalGrid | `ajaxRemoveFromCommercialProposalGrid()` | number | Remove produce |
| ajaxProducesForAssembleMinskGrid | `ajaxProducesForAssembleMinskGrid()` | - | Minsk store grid |
| ajaxDeleteAllProducesForAssembleMinskGrid | `ajaxDeleteAllProducesForAssembleMinskGrid()` | - | Clear Minsk produces |
| ajaxRemoveFromProducesForAssembleMinskGrid | `ajaxRemoveFromProducesForAssembleMinskGrid()` | number | Remove Minsk produce |
| ajaxChangeSalePriceForAssembleMinskGrid | `ajaxChangeSalePriceForAssembleMinskGrid()` | priceId, salePrice | Change price |
| ajaxChangeNDSByString | `ajaxChangeNDSByString()` | ndsByString | Toggle NDS mode |
| ajaxChangeFreePrices | `ajaxChangeFreePrices()` | freePrices | Toggle free prices |
| ajaxChangeReverseCalc | `ajaxChangeReverseCalc()` | reverseCalc | Toggle reverse calc |
| ajaxChangeCalculate | `ajaxChangeCalculate()` | calculateNtto | Toggle netto calc |
| ajaxChangeCourse | `ajaxChangeCourse()` | course | Change course |
| ajaxChangeNDS | `ajaxChangeNDS()` | nds | Change NDS rate |
| ajaxChangeCurrency | `ajaxChangeCurrency()` | currencyId | Change currency |
| ajaxRecalcCommercialProposalGrid | `ajaxRecalcCommercialProposalGrid()` | - | Recalculate grid |
| ajaxRecalcForAssembleMinskGrid | `ajaxRecalcForAssembleMinskGrid()` | - | Recalculate Minsk |
| ajaxGetTotal | `ajaxGetTotal()` | - | Get total sum |
| ajaxGetReputation | `ajaxGetReputation()` | contractor-id | Get contractor reputation |

---

## Business Rules

### Number Generation
```
Format: BYM{YYMM}/{num}-{code}
Example: BYM2602/0001-IVAN
```

### Minsk Store Mode Rules
When `cpr_assemble_minsk_store = "1"`:
- `currencyTable` = BYN (locked)
- `currency` = BYN (locked)
- `cpr_course` = 1 (locked)
- `cpr_sum_transport` = 0 (locked)
- `cpr_sum_assembling` = 0 (locked)
- `priceCondition` = DDP_2010 (locked)
- `deliveryCondition` = DDP_2010 (locked)
- `cpr_nds_by_string` = "1" (locked)
- `cpr_old_version` = "" (locked)
- `cpr_date` = current date (locked for new)
- `cpr_final_date` = cpr_date + 10 days (locked)
- All custom_duty = 0

### Course Validation
- Course must be >= 0
- Warning if course < recommended (k * 1.05)
- Recommended course shown as hint

### DDP Validation
If `priceCondition` or `deliveryCondition` is DDP/DDP_2010:
- Custom code is required (unless Minsk store mode)
- Pink highlight for missing custom code

### Print Invoice Conditions
Available when:
- `currencyTable` != BYN AND `currency` = BYN AND all coefficients >= 1.15 AND course >= recommended
- OR `currencyTable` = BYN AND `currency` = BYN AND all coefficients >= 1.25 AND course = 1
- AND `cpr_nds_by_string` = "1"

---

## Role-Based Access

### Form Read-Only Conditions
- `formReadOnly = true` when `cpr_block = "1"`
- Minsk store mode has additional readonly fields

### Section Access
| Section | Admin | Economist | Manager |
|---------|-------|-----------|---------|
| Header | Edit | Edit | Edit |
| Currency | Edit | Edit | Edit |
| Produces | Edit | Edit | Edit |
| Price/Delivery | Edit | Edit | Edit |
| Status | Edit | Edit | Partial |
| Print Invoice | Yes | Yes | No |

---

## Session State
- CP bean stored in session: `StoreUtil.putSession(request, CommercialProposal.class)`
- Form is session-scoped
- Attachments use `DeferredAttachmentService`

## Dependent Screens
- **CommercialProposalProduce.jsp** - Produce edit dialog
- **Contractor Edit** - Via `newContractor` forward
- **ContactPerson Edit** - Via `newContactPerson` forward
- **Excel Import** - Via `importExcel` forward
