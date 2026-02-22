# Commercial Proposal Edit Screen - BEHAVIOR MATRIX

## Overview
This matrix documents all behavioral variations of the Commercial Proposal Edit screen.

---

## 1. Screen Mode Matrix

| Mode | cpr_old_version | cpr_assemble_minsk_store | Grid Type | Features |
|------|-----------------|--------------------------|-----------|----------|
| Regular | "" | "" | ProducesCommercialProposalGrid | DBO links, custom codes |
| Old Version | "1" | "" | ProducesCommercialProposalGrid | Free-text produces |
| Minsk Store | "" | "1" | ProducesForAssembleMinskGrid | Reservation, locked fields |

---

## 2. Minsk Store Mode Field Lock Matrix

| Field | Regular | Minsk Store | Value in Minsk |
|-------|---------|-------------|----------------|
| currencyTable | Editable | Locked | BYN |
| currency | Editable | Locked | BYN |
| cpr_course | Editable | Locked | 1 |
| cpr_sum_transport | Editable | Locked | 0 |
| cpr_sum_assembling | Editable | Locked | 0 |
| priceCondition | Editable | Locked | DDP_2010 |
| deliveryCondition | Editable | Locked | DDP_2010 |
| cpr_nds_by_string | Editable | Locked | "1" |
| cpr_old_version | Editable | Locked | "" |
| cpr_date | Editable | Locked (new) | Current date |
| cpr_final_date | Editable | Locked | cpr_date + 10 days |
| custom_duty | Editable | Locked | 0 |

---

## 3. Produces Grid Column Matrix

### 3.1 Regular Mode Columns

| Column | Visible | Editable | Old Version |
|--------|---------|----------|-------------|
| Number | Yes | No | No |
| Catalog Number | Yes | No | Yes |
| Product Name | Yes | No | Yes (text) |
| Unit | Yes | No | No |
| Count | Yes | Yes | Yes |
| Price Brutto | Yes | Yes | Yes |
| Discount | Yes | Yes | Yes |
| Price Netto | Yes | No | No |
| NDS | Yes | No | No |
| Sum Netto | Yes | No | No |
| Sum Brutto | Yes | No | No |
| Custom Code | Yes | Yes | No |
| Custom Duty % | Yes | No | No |
| Custom Duty | Yes | Yes | No |
| Coefficient | Yes | No | No |

### 3.2 Minsk Store Mode Columns

| Column | Visible | Editable |
|--------|---------|----------|
| Number | Yes | No |
| Catalog Number | Yes | No |
| Product Name | Yes | No |
| Count | Yes | Yes |
| Price | Yes | Yes |
| NDS | Yes | No |
| Sum with NDS | Yes | No |
| Reserved | Yes | Link |

---

## 4. IncoTerm Condition Matrix

### 4.1 Price Condition Effects

| Condition | Case | Cost Column Style | Price Column Style |
|-----------|------|-------------------|-------------------|
| EXW | A | style-checker-long | style-checker-short |
| FCA | B | style-checker-long | style-checker-short |
| DAP | C | style-checker | style-checker |
| DDP | D | style-checker-long | style-checker-short |
| DDP_2010 | E | style-checker-long | style-checker-short |

### 4.2 DDP Custom Code Requirement

| Condition | Custom Code Required |
|-----------|---------------------|
| EXW | No |
| FCA | No |
| DAP | No |
| DDP | Yes (unless Minsk) |
| DDP_2010 | Yes (unless Minsk) |

---

## 5. Calculation Mode Matrix

### 5.1 Normal Calculation (cpr_reverse_calc = "")

| Field | Calculation |
|-------|-------------|
| Price Netto | Price Brutto * (1 - Discount/100) |
| NDS | Price Netto * NDS Rate / 100 |
| Sum Netto | Price Netto * Count |
| Sum Brutto | (Price Netto + NDS) * Count |

### 5.2 Reverse Calculation (cpr_reverse_calc = "1")

| Field | Calculation |
|-------|-------------|
| Price Brutto | Price Netto / (1 - Discount/100) |
| Price Netto | Input directly |
| NDS | Price Netto * NDS Rate / 100 |
| Sum Netto | Price Netto * Count |

### 5.3 Free Prices Mode (cpr_free_prices = "1")

| Field | Editable |
|-------|----------|
| Price Brutto | Yes |
| Price Netto | Yes |
| NDS | Yes |
| Sum Brutto | Yes |

---

## 6. Print Invoice Condition Matrix

### 6.1 Case 1: Foreign Currency Table

| Condition | Required Value |
|-----------|----------------|
| currencyTable | != BYN |
| currency | = BYN |
| All coefficients | >= 1.15 |
| cpr_course | >= recommended (k * 1.05) |
| cpr_nds_by_string | = "1" |

### 6.2 Case 2: BYN Currency Table

| Condition | Required Value |
|-----------|----------------|
| currencyTable | = BYN |
| currency | = BYN |
| All coefficients | >= 1.25 |
| cpr_course | = 1 |
| cpr_nds_by_string | = "1" |

---

## 7. Role-Based Access Matrix

### 7.1 Field Access

| Section | Admin | Economist | Manager |
|---------|-------|-----------|---------|
| Header | Edit | Edit | Edit |
| Currency | Edit | Edit | Edit |
| Mode Flags | Edit | Edit | Edit |
| Produces | Edit | Edit | Edit |
| Price/Delivery | Edit | Edit | Edit |
| Minsk Specific | Edit | Edit | Edit |
| Status | Edit | Edit | Partial |
| Print Invoice | Yes | Yes | No |

### 7.2 Status Field Access

| Field | Admin | Economist | Manager |
|-------|-------|-----------|---------|
| cpr_date_accept | Edit | Edit | Edit |
| cpr_proposal_received_flag | Edit | Edit | Edit |
| cpr_proposal_declined | Edit | Edit | Edit |
| cpr_tender_number | Edit | Edit | Edit |
| cpr_tender_number_editable | Edit | Edit | Edit |
| cpr_block | Edit | Edit | No |

---

## 8. Validation Matrix

### 8.1 Save Validation

| Rule | Condition | Error |
|------|-----------|-------|
| V1 | cpr_course = 0 or empty | error.commercial.course |
| V2 | cpr_final_date < cpr_date | error.commercial.final_date |
| V3 | accepted but no accept date | error.commercial.accepted |
| V4 | accept date < cpr_date | error.commercial.date_accept |
| V5 | tender editable but no number | error.commercial.tender |
| V6 | equal currencies incorrectly set | error.commercial.equalCurrencies |
| V7 | not equal currencies incorrectly set | error.commercial.notEqualCurrencies |
| V8 | empty produce (not old version) | error.commercial.cpr_null_produce |
| V9 | DDP without custom code | error.commercial.DDP |
| V10 | reservation exceeds available | error.commercial.cpr_reserved_error |

### 8.2 Print Invoice Validation

| Rule | Condition | Error |
|------|-----------|-------|
| P1 | purchasePurpose empty | error.commercial.emptyPurchasePurpose |
| P2 | currency conditions not met | Button hidden |

---

## 9. AJAX Grid Behavior Matrix

### 9.1 Regular Produces Grid

| Action | Trigger | Response |
|--------|---------|----------|
| Load | Form show | HTML fragment |
| Add | newProduce | Redirect to dialog |
| Edit | editProduce | Redirect to dialog |
| Delete | ajaxRemoveFromCommercialProposalGrid | HTML fragment |
| Clear All | ajaxDeleteAllProducesCommercialProposalGrid | HTML fragment |
| Recalculate | ajaxRecalcCommercialProposalGrid | HTML fragment |

### 9.2 Minsk Store Grid

| Action | Trigger | Response |
|--------|---------|----------|
| Load | Mode change | HTML fragment |
| Change Price | ajaxChangeSalePriceForAssembleMinskGrid | HTML fragment |
| Delete | ajaxRemoveFromProducesForAssembleMinskGrid | HTML fragment |
| Clear All | ajaxDeleteAllProducesForAssembleMinskGrid | HTML fragment |
| Recalculate | ajaxRecalcForAssembleMinskGrid | HTML fragment |

---

## 10. Number Generation Matrix

| Format | Example |
|--------|---------|
| BYM{YYMM}/{num}-{code} | BYM2602/0001-IVAN |

**Components**:
- BYM: Fixed prefix
- YYMM: Year and month from cpr_date
- num: 4-digit sequence from generator
- code: Uppercase user code

---

## 11. Clone Behavior Matrix

### 11.1 Clone as New Version

| Source Field | Cloned Value |
|--------------|--------------|
| cpr_id | empty |
| cpr_number | empty |
| cpr_date | current date |
| cpr_old_version | "" |
| produces | copied with DBO links |
| cpr_block | "" |
| cpr_proposal_received_flag | "0" |
| cpr_proposal_declined | "0" |
| cpr_date_accept | empty |
| attachments | not copied |

### 11.2 Clone as Old Version

| Source Field | Cloned Value |
|--------------|--------------|
| cpr_id | empty |
| cpr_number | empty |
| cpr_date | current date |
| cpr_old_version | "1" |
| produces | converted to free-text |
| produce.produce | empty |
| produce.lpr_produce_name | from DBO name |
| produce.lpr_catalog_num | from DBO catalog |
| custom codes | cleared |

---

## 12. Reservation Matrix (Minsk Store)

### 12.1 Reservation Access

| User | Can Toggle No Reservation |
|------|---------------------------|
| Admin | Yes |
| Creator | Yes |
| Same Dept Manager | Yes |
| Other | No |

### 12.2 Reservation Validation

| Condition | Validation |
|-----------|------------|
| cpr_no_reservation = "1" | Skip validation |
| cpr_no_reservation = "" | lpr_count <= rest_lpc_count |

---

## 13. Session State Matrix

| Key | Set By | Used By | Cleared By |
|-----|--------|---------|------------|
| CommercialProposal.class | input, edit, clone | All operations | back, process |
| DeferredAttachmentService | input, edit | Attachment ops | back, process |
| ImportData.class | newProduce (Minsk) | backFromSelect | After use |
