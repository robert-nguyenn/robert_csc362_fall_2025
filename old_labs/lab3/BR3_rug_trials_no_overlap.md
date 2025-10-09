# Business Rule Specifications

## Rule Information

| Feature           | Value                     |
|-------------------|---------------------------|
| Rule Statement    | For a given `trial_inventory_number`, the date range **[trial_start_date, COALESCE(trial_actual_return_date, trial_expected_return_date)]** must **not overlap** any other Trial for the same rug.                  |
| Constraint        | Validate on insert/update of **Trials** and when setting `trial_actual_return_date`.                         |
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
| Field Names       | trial_inventory_number, trial_start_date, trial_expected_return_date, trial_actual_return_date                          |
| Table Names       | Trials                         |


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
- [ ] Null Support
- [X] Values Entered By
- [X] Range of Values
- [X] Edit Rule


## Relationship Characteristics Affected
- [ ] Deletion rule
- [ ] Type of participation
- [ ] Degree of participation

    
## Action Taken
Add an overlap check per `trial_inventory_number`: an exclusion constraint on date ranges or trigger/app logic to reject intersecting ranges.


## Notes
Guarantees a rug is never double-loaned.


