# Business Rule Specifications

## Rule Information

| Feature           | Value                     |
|-------------------|---------------------------|
| Rule Statement    | A sale’s `sale_price` must be **≥** the rug’s original price **OR** the sale must occur **≥ 2 years** after `rug_date_acquired`. Original price = `Rugs.rug_original_price`.                    |
| Constraint        | Validate when inserting or updating a row in **Sales**.                         |
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
| Field Names       | sale_price, sale_date, rug_original_price, rug_date_acquired                          |
| Table Names       | Sales, Rugs                         |


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
- [ ] Values Entered By
- [ ] Range of Values
- [ ] Edit Rule


## Relationship Characteristics Affected
- [ ] Deletion rule
- [ ] Type of participation
- [ ] Degree of participation

    
## Action Taken
Implement a check (trigger or application logic):
`(NEW.sale_price >= R.rug_original_price) OR (NEW.sale_date >= R.rug_date_acquired + INTERVAL '2 years')`
where `R` is the parent row in **Rugs** for `NEW.sale_inventory_number`.


## Notes
`net_on_sale` is **derived** in reports (`sale_price - rug_original_price`) and is **not stored**.


