SELECT
  i.instrument_id,
  i.instrument_type,
  s.student_name
FROM instruments AS i
LEFT JOIN rentals  AS r ON r.instrument_id = i.instrument_id
                        AND r.return_date IS NULL
LEFT JOIN students AS s ON s.student_id    = r.student_id
ORDER BY i.instrument_id;
