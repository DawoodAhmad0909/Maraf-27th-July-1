CREATE DATABASE MD27thJ1_db;
USE MD27thJ1_db;

CREATE TABLE schools (
	school_id       INT PRIMARY KEY AUTO_INCREMENT,
	school_name     TEXT,
	school_code     TEXT,
	location        TEXT,
	principal_name  TEXT,
	education_level TEXT,
	gender_type     TEXT
);

SELECT * FROM schools ;

INSERT INTO schools (school_name, school_code, location, principal_name, education_level, gender_type) VALUES
	('Al Bayan Secondary School for Girls', 'SEC-G-001', 'Al Rayyan', 'Dr. Fatima Al-Mohannadi', 'Secondary', 'Girls'),
	('Omar Bin Al Khattab Preparatory School for Boys', 'PREP-B-005', 'Doha', 'Mr. Ali Al-Sulaiti', 'Preparatory', 'Boys'),
	('Al Andalus Primary School', 'PRI-MX-012', 'Al Wakrah', 'Ms. Noora Al-Ansari', 'Primary', 'Mixed'),
	('Qatar Science and Technology School', 'SEC-MX-008', 'Education City', 'Dr. Khalid Al-Hamar', 'Secondary', 'Mixed');

CREATE TABLE students (
	student_id     INT PRIMARY KEY AUTO_INCREMENT,
	qatari_id      TEXT,
	english_name   TEXT,
	arabic_name    TEXT,
	birth_date     DATE,
	gender         TEXT,
	nationality    TEXT,
	school_id      INT,
	grade_level    INT,
	academic_year  TEXT,
	parent_contact TEXT,
	FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

SELECT * FROM students ;

INSERT INTO students (qatari_id, english_name, arabic_name, birth_date, gender, nationality, school_id, grade_level, academic_year, parent_contact) VALUES
	('12345678901', 'Mohammed Ahmed', 'محمد أحمد', '2010-05-15', 'Male', 'Qatari', 2, 7, '2023-2024', '66123456'),
	('23456789012', 'Aisha Khalid', 'عائشة خالد', '2012-11-22', 'Female', 'Qatari', 1, 10, '2023-2024', '55234567'),
	('34567890123', 'Nasser Ibrahim', 'ناصر إبراهيم', '2011-03-08', 'Male', 'Egyptian', 4, 9, '2023-2024', '77345678'),
	('45678901234', 'Fatima Abdulrahman', 'فاطمة عبدالرحمن', '2013-07-30', 'Female', 'Qatari', 3, 4, '2023-2024', '33456789');
	
CREATE TABLE subjects (
	subject_id    INT PRIMARY KEY AUTO_INCREMENT,
	subject_code  TEXT,
	english_name  TEXT,
	arabic_name   TEXT,
	subject_type  TEXT,
	credit_hours  INT
);

SELECT * FROM subjects ;

INSERT INTO subjects (subject_code, english_name, arabic_name, subject_type, credit_hours) VALUES 
	('MATH-001', 'Mathematics', 'الرياضيات', 'Core', 5),
	('ARAB-001', 'Arabic Language', 'اللغة العربية', 'Core', 5),
	('ISLM-001', 'Islamic Studies', 'التربية الإسلامية', 'Religious', 4),
	('SCI-001', 'Science', 'العلوم', 'Core', 4),
	('ENG-001', 'English Language', 'اللغة الإنجليزية', 'Core', 4),
	('QHST-001', 'Qatar History', 'تاريخ قطر', 'Core', 3),
	('PE-001', 'Physical Education', 'التربية البدنية', 'Core', 2);

CREATE TABLE teachers (
	teacher_id      INT PRIMARY KEY AUTO_INCREMENT,
	qatari_id       TEXT,
	english_name    TEXT,
	arabic_name     TEXT,
	gender          TEXT,
	specialization  TEXT,
	hire_date       DATE,
	school_id       INT,
	FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

SELECT * FROM teachers ;

INSERT INTO teachers (qatari_id, english_name, arabic_name, gender, specialization, hire_date, school_id) VALUES 
	('98765432109', 'Salem Al-Mannai', 'سالم المناعي', 'Male', 'Mathematics', '2018-09-01', 2),
	('87654321098', 'Mariam Al-Sada', 'مريم السادة', 'Female', 'Arabic Literature', '2020-02-15', 1),
	('76543210987', 'Dr. Hassan Ali', 'د. حسن علي', 'Male', 'Physics', '2015-08-20', 4),
	('65432109876', 'Noora Al-Kuwari', 'نورة الكواري', 'Female', 'Elementary Education', '2019-10-05', 3);

CREATE TABLE classes (
	class_id             INT PRIMARY KEY AUTO_INCREMENT,
	class_name           TEXT,
	grade_level          INT,
	section              TEXT,
	academic_year        TEXT,
	school_id            INT,
	homeroom_teacher_id  INT,
	FOREIGN KEY (homeroom_teacher_id) REFERENCES teachers(teacher_id),
	FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

SELECT * FROM classes ;

INSERT INTO classes (class_name, grade_level, section, academic_year, school_id, homeroom_teacher_id) VALUES 
	('Grade 10-A', 10, 'A', '2023-2024', 1, 2),
	('Grade 7-B', 7, 'B', '2023-2024', 2, 1),
	('Grade 4-C', 4, 'C', '2023-2024', 3, 4),
	('Grade 9-D', 9, 'D', '2023-2024', 4, 3);

CREATE TABLE enrollment (
	enrollment_id   INT PRIMARY KEY AUTO_INCREMENT,
	student_id      INT,
	class_id        INT,
	academic_year   TEXT,
	enrollment_date DATE,
	FOREIGN KEY (class_id) REFERENCES classes(class_id),
	FOREIGN KEY (student_id) REFERENCES students(student_id)
);

SELECT * FROM enrollment ;

INSERT INTO enrollment (student_id, class_id, academic_year, enrollment_date) VALUES 
	(1, 2, '2023-2024', '2023-08-20'),
	(2, 1, '2023-2024', '2023-08-20'),
	(3, 4, '2023-2024', '2023-08-21'),
	(4, 3, '2023-2024', '2023-08-19');

CREATE TABLE grades (
	grade_id       INT PRIMARY KEY AUTO_INCREMENT,
	student_id     INT,
	subject_id     INT,
	academic_year  TEXT,
	term           TEXT,
	grade          DECIMAL (10,2),
	grade_letter   TEXT,
	FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
	FOREIGN KEY (student_id) REFERENCES students(student_id)
);

SELECT * FROM grades ;

INSERT INTO grades (student_id, subject_id, academic_year, term, grade, grade_letter) VALUES 
	(1, 1, '2023-2024', 'First', 92.5, 'A'),
	(1, 2, '2023-2024', 'First', 88.0, 'B+'),
	(2, 5, '2023-2024', 'First', 95.0, 'A'),
	(3, 3, '2023-2024', 'First', 78.5, 'C+');

CREATE TABLE attendance (
	attendance_id  INT PRIMARY KEY AUTO_INCREMENT,
	student_id     INT,
	class_id       INT,
	date           DATE,
	status         TEXT,
	FOREIGN KEY (class_id) REFERENCES classes(class_id),
	FOREIGN KEY (student_id) REFERENCES students(student_id)
);

SELECT * FROM attendance ;

INSERT INTO attendance (student_id, class_id, date, status) VALUES 
	(1, 2, '2023-09-10', 'Present'),
	(1, 2, '2023-09-11', 'Late'),
	(2, 1, '2023-09-10', 'Present'),
	(4, 3, '2023-09-10', 'Absent');

-- 1. List all mixed-gender schools in Al Rayyan district with their principals' contact information.
SELECT 
	school_name,principal_name,location,gender_type
FROM schools 
WHERE 
	LOWER(location)='al rayyan'
    AND LOWER(gender_type)='mixed';

-- 2. Show the distribution of schools by education level (Primary/Preparatory/Secondary) and gender type (Boys/Girls/Mixed).
SELECT 
	education_level,gender_type,COUNT(*) AS Total_schools
FROM schools
GROUP BY education_level,gender_type;

-- 3. Find Qatari national students in Grade 10 or above who have an overall grade average below 70%.
SELECT 
    s.english_name,s.nationality,s.grade_level,
    ROUND(AVG(g.grade), 2) AS average_grade
FROM students s
JOIN grades g ON s.student_id = g.student_id
WHERE 
    s.nationality = 'Qatari' 
    AND s.grade_level >= 10
GROUP BY s.english_name,s.nationality,s.grade_level
HAVING AVG(g.grade) < 70;

-- 4. Calculate the percentage of non-Qatari students per school, ordered from highest to lowest diversity.
SELECT 
    sc.school_name,
    COUNT(*) AS total_students,
    COUNT(CASE WHEN s.nationality != 'Qatari' THEN 1 END) AS non_qatari_students,
    COUNT(CASE WHEN s.nationality != 'Qatari' THEN 1 END) * 100.0 / COUNT(*) AS non_qatari_percentage
FROM schools sc
JOIN students s ON sc.school_id = s.school_id
GROUP BY sc.school_name
ORDER BY non_qatari_percentage DESC;
    
-- 5. Identify students who scored 90% or higher in Islamic Studies but below 80% in Mathematics.
SELECT 
    s.english_name,
    s.nationality,
    isl.grade AS islamic_grade,
    math.grade AS math_grade
FROM students s
JOIN grades isl ON s.student_id = isl.student_id
JOIN subjects sub_isl ON isl.subject_id = sub_isl.subject_id
JOIN grades math ON s.student_id = math.student_id
JOIN subjects sub_math ON math.subject_id = sub_math.subject_id
WHERE 
    sub_isl.english_name = 'Islamic Studies'
    AND isl.grade >= 90
    AND sub_math.english_name = 'Mathematics'
    AND math.grade < 80;
    
-- 6. Show the subject with the highest average grade for each grade level across all schools.
SELECT 
    grade_level,subject_name,average_grade
FROM (
    SELECT 
        s.grade_level,
        sub.english_name AS subject_name,
        ROUND(AVG(g.grade), 2) AS average_grade,
        RANK() OVER (PARTITION BY s.grade_level ORDER BY AVG(g.grade) DESC) AS rank_in_grade
    FROM students s
    JOIN grades g ON s.student_id = g.student_id
    JOIN subjects sub ON g.subject_id = sub.subject_id
    GROUP BY s.grade_level, sub.english_name
) AS ranked_subjects
WHERE rank_in_grade = 1
ORDER BY grade_level;
    
-- 7. Find students with more than 5 unexcused absences in the current academic term.
SELECT 
    s.english_name AS Student_name,s.grade_level,
    COUNT(a.attendance_id) AS unexcused_absences
FROM students s
JOIN attendance a ON s.student_id = a.student_id
JOIN enrollment e ON s.student_id = e.student_id
WHERE 
    a.status = 'Absent'
    AND e.academic_year = '2023-2024'
GROUP BY s.student_id, s.english_name, s.grade_level
HAVING COUNT(a.attendance_id) > 5
ORDER BY unexcused_absences DESC;
    
-- 8. Compare attendance rates between Qatari and non-Qatari students by grade level.
SELECT 
    s.grade_level,
    SUM(CASE WHEN s.nationality = 'Qatari' THEN 1 ELSE 0 END) AS qatari_students,
    SUM(CASE WHEN s.nationality != 'Qatari' THEN 1 ELSE 0 END) AS non_qatari_students,
    ROUND(100 * SUM(CASE WHEN s.nationality = 'Qatari' AND a.status = 'Present' THEN 1 ELSE 0 END) / 
          NULLIF(SUM(CASE WHEN s.nationality = 'Qatari' THEN 1 ELSE 0 END), 0), 2) AS qatari_attendance_rate,
    ROUND(100 * SUM(CASE WHEN s.nationality != 'Qatari' AND a.status = 'Present' THEN 1 ELSE 0 END) / 
          NULLIF(SUM(CASE WHEN s.nationality != 'Qatari' THEN 1 ELSE 0 END), 0), 2) AS non_qatari_attendance_rate,
    ROUND(
        (100 * SUM(CASE WHEN s.nationality = 'Qatari' AND a.status = 'Present' THEN 1 ELSE 0 END) / 
         NULLIF(SUM(CASE WHEN s.nationality = 'Qatari' THEN 1 ELSE 0 END), 0)) -
        (100 * SUM(CASE WHEN s.nationality != 'Qatari' AND a.status = 'Present' THEN 1 ELSE 0 END) / 
         NULLIF(SUM(CASE WHEN s.nationality != 'Qatari' THEN 1 ELSE 0 END), 0)),
    2) AS attendance_rate_difference
FROM students s
JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.grade_level
ORDER BY s.grade_level;

-- 9. List teachers who teach at schools with a different gender type than their own (e.g., male teachers at girls' schools).
SELECT 
    t.english_name AS teacher_name,
    t.gender AS teacher_gender,
    s.school_name,
    s.gender_type AS school_gender_type
FROM teachers t
JOIN schools s ON t.school_id = s.school_id
WHERE 
    (t.gender = 'Male' AND s.gender_type = 'Girls') OR
    (t.gender = 'Female' AND s.gender_type = 'Boys');
    
-- 10. Find classes where the average grade difference between first and second terms shows improvement greater than 15%.
WITH term_grades AS (
    SELECT 
        c.class_id,
        c.class_name,
        c.grade_level,
        c.section,
        s.school_name,
        g.term,
        ROUND(AVG(g.grade),2) AS avg_grade
    FROM classes c
    JOIN enrollment e ON c.class_id = e.class_id
    JOIN grades g ON e.student_id = g.student_id
    JOIN schools s ON c.school_id = s.school_id
    WHERE 
        g.term IN ('First', 'Second')
        AND g.academic_year = '2023-2024'
    GROUP BY c.class_id, c.class_name, c.grade_level, c.section, s.school_name, g.term
),
term_comparison AS (
    SELECT 
        t1.class_id,
        t1.class_name,
        t1.grade_level,
        t1.section,
        t1.school_name,
        t1.avg_grade AS first_term_avg,
        t2.avg_grade AS second_term_avg,
		t2.avg_grade - t1.avg_grade AS improvement
    FROM term_grades t1
    JOIN term_grades t2 ON t1.class_id = t2.class_id
    WHERE 
        t1.term = 'First'
        AND t2.term = 'Second'
)
SELECT 
    class_name,
    grade_level,
    section,
    school_name,
	first_term_avg,
    second_term_avg,
    improvement
FROM term_comparison
WHERE improvement > 15
ORDER BY improvement DESC;