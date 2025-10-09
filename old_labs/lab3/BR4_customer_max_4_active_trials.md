# Business Rule Specifications

## Rule Information

| Feature           | Value                     |
|-------------------|---------------------------|
| Rule Statement    | Deleting a Customer is **RESTRICTED** if any Sales exist for that customer. If deletion is permitted, perform **NULLIFY** on `Trials.customer_id`.                |
| Constraint        | Enforced when deleting a row in **Customers**.                         |
| Type              | [X] Database Oriented     |
|                   | [X] Application Oriented  |
|                   |                           |
| Category          | [ ] Field Specific        |
|                   | [X] Relationship Specific |
|                   |                           |
| Test On           | [ ] Insert                |
|                   | [X] Delete                |
|                   | [ ] Update                |


## Structures Affected

| Feature           | Value                     |
|-------------------|---------------------------|
| Field Names       | sale_customer_id, customer_id (in Trials)                          |
| Table Names       | Sales, Trials, Customers                       |


## Field Elements Affected
Mark each element which is affected by this rule.

### Physical Elements
- [ ] Data Type
- [ ] Length
- [ ] Character Support

### Logical Elements
- [ ] Key Type
- [ ] Key Structure
- [ ] Uniqueness
- [X] Null Support
- [ ] Values Entered By
- [ ] Range of Values
- [X] Edit Rule


## Relationship Characteristics Affected
- [ ] Deletion rule
- [ ] Type of participation
- [ ] Degree of participation

    
## Action Taken
Before insert (or clearing a return date), count active Trials for `trial_customer_id`; **reject** the 5th.


## Notes
Implements the business policy “up to 4 rugs at a time to try”.


