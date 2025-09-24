# Business Rule Specifications

## Rule Information

| Feature           | Value                     |
|-------------------|---------------------------|
| Rule Statement    | A customer may have at most **4** concurrent trials (rows where `trial_actual_return_date IS NULL`).                    |
| Constraint        | Validate on insert/update of **Trials**.                         |
| Type              | [ ] Database Oriented     |
|                   | [X] Application Oriented  |
|                   |                           |
| Category          | [ ] Field Specific        |
|                   | [X] Relationship Specific |
|                   |                           |
| Test On           | [X] Insert                |
|                   | [ ] Delete                |
|                   | [X] Update                |


## Structures Affected

| Feature           | Value                     |
|-------------------|---------------------------|
| Field Names       | trial_customer_id, trial_actual_return_date                          |
| Table Names       | Trials                       |


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
- [X] Range of Values
- [ ] Edit Rule


## Relationship Characteristics Affected
- [X] Deletion rule
- [ ] Type of participation
- [ ] Degree of participation

    
## Action Taken
- Enforce **ON DELETE RESTRICT** for `Sales.customer_id` FK.  
- Enforce **ON DELETE SET NULL** for `Trials.customer_id` FK.  

## Notes


