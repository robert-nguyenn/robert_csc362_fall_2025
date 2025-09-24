# Field Specifications

## General Elements

| Field                 | Value                             |
|-----------------------|-----------------------------------|
| Field Name            | ConsumerID                        |
| Parent Table          | Ratings                            |
| Alias(es)             |                              |
| Specification Type    | [ ] Unique                        |
|                       | [ ] Generic                       |
|                       | [x] Replica                       |
|                       |                                   |
| Source Specification  | Replica of Consumers.ConsumerID (foreign key) |
| Shared By             | References Consumers.ConsumerID                                  |
| Description           | Identifies which consumer submitted the rating. |


## Physical Elements

| Field                 | Value                             |
|-----------------------|-----------------------------------|
| Data Type             | INT                               |
| Length                | -                               |
| Decimal Places        | 0                                 |
| Character Support     | [ ] Letters (A-Z)                 |
|                       | [x] Numbers (0-9)                 |
|                       | [ ] Keyboard (.,/$#%)             |
|                       | [ ] Special (©®™Σπ)               |


## Logical Elements

| Field                 | Value                             |
|-----------------------|-----------------------------------|
| Key Type              | [ ] Non                           |
|                       | [ ] Primary                       |   
|                       | [x] Foreign                       |
|                       | [ ] Alternate                     |
|                       |                                   |
| Key Structure         | [x] Simple                        |
|                       | [ ] Composite                     |
|                       |                                   |
| Uniqueness            | [x] Non-unique                    |
|                       | [ ] Unique                        |
|                       |                                   |
| Null Support          | [ ] Nulls OK                      |
|                       | [x] No nulls                      |
|                       |                                   |
| Values Entered By     | [x] User                          |
|                       | [ ] System                        |
|                       |                                   |
| Required Value        | [ ] No                            |
|                       | [x] Yes                           |
|                       |                                   |
| Range of Values       | Must match an existing Consumers.ConsumerID         |
| Edit Rule             | [ ] Enter now, edits allowed      |
|                       | [x] Enter now, edits not allowed  |
|                       | [ ] Enter later, edits allowed    |
|                       | [ ] Enter later, edits not allowed|
|                       | [ ] Not determined at this time   |

## Notes
