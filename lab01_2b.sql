/* Lab 1.2 — Robert Nguyen
   Create database `school` and the `instructors` table (Figure 7.22). */

DROP DATABASE IF EXISTS school;
CREATE DATABASE school;
USE school;

CREATE TABLE instructors (
  instructor_id INT AUTO_INCREMENT PRIMARY KEY,
  instructor_first_name VARCHAR(30) NOT NULL,
  instructor_last_name  VARCHAR(30) NOT NULL,
  instructor_campus_phone CHAR(8) NOT NULL
);

INSERT INTO instructors (instructor_first_name, instructor_last_name, instructor_campus_phone) VALUES
('Kira',    'Bently',  '363-9948'),
('Timothy', 'Ennis',   '527-4992'),
('Shannon', 'Black',   '336-5992'),
('Estela',  'Rosales', '322-6992');

SELECT instructor_id, instructor_first_name, instructor_last_name, instructor_campus_phone
FROM instructors;
