-- 1. 테이블 생성하기 (4개)



CREATE TABLE course (
    id INT,
    name VARCHAR(255),
    teacher_id INT
);

INSERT INTO course (id, name, teacher_id) VALUES
(1, 'Database design', 1),
(2, 'English literature', 2),
(3, 'Python programming', 3);



CREATE TABLE student (
    id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

INSERT INTO student (id, first_name, last_name) VALUES
(1, 'Shreya', 'Bain'),
(2, 'Rianna', 'Foster'),
(3, 'Yosef', 'Naylor');



CREATE TABLE student_course (
    student_id INT,
    course_id INT
);

INSERT INTO student_course (student_id, course_id) VALUES
(1,2),
(1,3),
(2,1),
(2,2),
(2,3),
(3,1);



CREATE TABLE teacher (
    id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255)
);

INSERT INTO teacher (id, first_name, last_name) VALUES
(1, 'Taylah', 'Booker'),
(2, 'Sarah-Louise', 'Blake');

TABLE course;
TABLE student;
TABLE student_course;
TABLE teacher;



-- 2. 조인문 사용하기 (3개)

SELECT s.id AS student_id, s.first_name, s.last_name, sc.course_id
FROM student s
JOIN student_course sc ON s.id = sc.student_id;

SELECT c.id AS course_id, c.name AS course_name, t.first_name AS teacher_first_name, t.last_name AS teacher_last_name
FROM course c
JOIN teacher t ON c.teacher_id = t.id;

SELECT c.id AS course_id, c.name AS course_name, sc.student_id
FROM course c
JOIN student_course sc ON c.id = sc.course_id;

-- 3. SELECT문을 사용하여 데이터 탐색하기 (3개)

SELECT s.first_name, s.last_name
FROM student s
JOIN student_course sc ON s.id = sc.student_id
JOIN course c ON sc.course_id = c.id
WHERE c.name = 'Database design';

SELECT c.id AS course_id, c.name AS course_name
FROM course c
JOIN teacher t ON c.teacher_id = t.id
WHERE t.first_name = 'Taylah' AND t.last_name = 'Booker';

SELECT 'Student' AS type, s.first_name, s.last_name
FROM student s
WHERE s.last_name LIKE 'B%'
UNION ALL
SELECT 'Teacher' AS type, t.first_name, t.last_name
FROM teacher t
WHERE t.last_name LIKE 'B%';
