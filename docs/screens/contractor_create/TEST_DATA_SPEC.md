# N3a1 Contractor create — Test data spec

## Required reference data
- Countries: >=1 record.
- Reputations: >=1 record including default (for `loadDefaultForCtc`).
- Users: includes current user.
- Currencies: >=1 record.

## Data sets
1. **Happy path** contractor:
   - unique UNP, valid email, required fields set.
2. **Duplicate UNP**:
   - existing contractor with same UNP.
3. **Accounts edge**:
   - default row with account + empty currency.
   - custom row with account only / currency only.
   - `accAccount` length 36.
4. **Role checks**:
   - admin and non-admin test users (for user-grid delete and readonly flags).

## Expected observable results
- Save success returns contractor id and return context.
- Validation failures keep form/tab and show field/business errors.
