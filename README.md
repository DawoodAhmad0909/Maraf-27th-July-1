# Education Management System (QEMS)
## Overview 

The MD27thJ1_db database is a structured relational database designed to manage academic, demographic, and administrative data for schools in Qatar. It provides a centralized model for storing and analyzing information about schools, students, teachers, subjects, classes, enrollments, grades, and attendance.

### Key Tables and Their Roles:

1. schools
Stores basic information about schools including their name, location, education level, and gender type (Boys, Girls, Mixed).

2. students
Contains demographic details and school affiliations of students including nationality, grade level, and parent contact.

3. subjects
Lists all available academic subjects, with metadata such as credit hours and subject type (Core, Religious, etc.).

4. teachers
Maintains records of teachers along with their subject specialization and assigned school.

5. classes
Represents classroom structure including grade level, section, assigned teacher, and academic year.

6. enrollment
Links students to their respective classes for a given academic year and date of enrollment.

7. grades
Records performance data for students per subject, term, and academic year, including both numeric and letter grades.

8. attendance
Tracks student attendance status (Present, Absent, Late) for each date and class.

### Insights Enabled by the Database:

1. Demographic Analysis:Reports like the percentage of non-Qatari students per school help measure diversity.

2. Academic Performance Monitoring:Queries identify students at risk (e.g., low average grades), top-performing subjects by grade level, or students with subject-specific inconsistencies.

3. Attendance Trends:Attendance rates can be compared between Qatari and non-Qatari students or monitored for excessive absences.

4. Teacher Deployment Checks:Ensures that teacher placement aligns (or intentionally contrasts) with school gender-type policies.

5. Classroom Effectiveness:Tracks grade improvements across terms, revealing which classes or teaching strategies show measurable success.

## Objectives 

To digitize and optimize Qatar's K-12 education administration through centralized student data management and analytics

## Database Creation 
``` sql
CREATE DATABASE MD27thJ1_db;
USE MD27thJ1_db;
```
## Table Creation 
### Table:schools
``` sql
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
```
### Table:students
``` sql
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
```
### Table:subjects
``` sql
CREATE TABLE subjects (
        subject_id    INT PRIMARY KEY AUTO_INCREMENT,
        subject_code  TEXT,
        english_name  TEXT,
        arabic_name   TEXT,
        subject_type  TEXT,
        credit_hours  INT
);

SELECT * FROM subjects ;
```
### Table:teachers
``` sql
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
```
### Table:classes
``` sql
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
```
### Table:enrollment
``` sql
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
```
### Table:grades
``` sql
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
```
### Table:attendance
``` sql
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
```
## KEY Queries 

#### 1. List all mixed-gender schools in Al Rayyan district with their principals' contact information.
``` sql
SELECT 
        school_name,principal_name,location,gender_type
FROM schools 
WHERE 
        LOWER(location)='al rayyan'
    AND LOWER(gender_type)='mixed';
```
#### 2. Show the distribution of schools by education level (Primary/Preparatory/Secondary) and gender type (Boys/Girls/Mixed).
``` sql
SELECT 
        education_level,gender_type,COUNT(*) AS Total_schools
FROM schools
GROUP BY education_level,gender_type;
```
#### 3. Find Qatari national students in Grade 10 or above who have an overall grade average below 70%.
``` sql
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
```
#### 4. Calculate the percentage of non-Qatari students per school, ordered from highest to lowest diversity.
``` sql
SELECT 
    sc.school_name,
    COUNT(*) AS total_students,
    COUNT(CASE WHEN s.nationality != 'Qatari' THEN 1 END) AS non_qatari_students,
    COUNT(CASE WHEN s.nationality != 'Qatari' THEN 1 END) * 100.0 / COUNT(*) AS non_qatari_percentage
FROM schools sc
JOIN students s ON sc.school_id = s.school_id
GROUP BY sc.school_name
ORDER BY non_qatari_percentage DESC;
```
#### 5. Identify students who scored 90% or higher in Islamic Studies but below 80% in Mathematics.
``` sql
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
```
#### 6. Show the subject with the highest average grade for each grade level across all schools 
``` sql
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
```
#### 7. Find students with more than 5 unexcused absences in the current academic term.
``` sql
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
```
#### 8. Compare attendance rates between Qatari and non-Qatari students by grade level.
``` sql
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
```
#### 9. List teachers who teach at schools with a different gender type than their own (e.g., male teachers at girls' schools).
``` sql
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
```
#### 10. Find classes where the average grade difference between first and second terms shows improvement greater than 15%.
``` sql
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
```
## Conclusion 

The MD27thJ1_db serves as a comprehensive and scalable school management system tailored for Qatar’s diverse educational ecosystem. By integrating academic, demographic, and operational data, the database supports robust analytics for stakeholders—school administrators, educators, and policymakers—enabling data-driven decisions that can improve educational quality, equity, and efficiency.
