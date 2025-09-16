# Field Specifications

## General Elements

| Field                 | Value                             |
|-----------------------|-----------------------------------|
| Field Name            | MovieTitle                        |
| Parent Table          | Movies                            |
| Alias(es)             | Title                             |
| Specification Type    | [x] Unique                        |
|                       | [ ] Generic                       |
|                       | [ ] Replica                       |
|                       |                                   |
| Source Specification  | Official movie title from source data|
| Shared By             | -                                  |
| Description           | Human-readable title of the movie. |


## Physical Elements

| Field                 | Value                             |
|-----------------------|-----------------------------------|
| Data Type             | VARCHAR                           |
| Length                | 200                               |
| Decimal Places        | -                                 |
| Character Support     | [x] Letters (A-Z)                 |
|                       | [x] Numbers (0-9)                 |
|                       | [x] Keyboard (.,/$#%)             |
|                       | [x] Special (©®™Σπ)               |


## Logical Elements

| Field                 | Value                             |
|-----------------------|-----------------------------------|
| Key Type              | [x] Non                           |
|                       | [ ] Primary                       |   
|                       | [ ] Foreign                       |
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
| Range of Values       | 1–200 characters, trimmed         |
| Edit Rule             | [x] Enter now, edits allowed      |
|                       | [ ] Enter now, edits not allowed  |
|                       | [ ] Enter later, edits allowed    |
|                       | [ ] Enter later, edits not allowed|
|                       | [ ] Not determined at this time   |

## Notes
