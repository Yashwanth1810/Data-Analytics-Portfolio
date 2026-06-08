CREATE DATABASE school;
USE school;
CREATE TABLE student1
(student_id INT, student_name VARCHAR(100), dob DATE, age INT CHECK (age>=0 AND age<=99));

DESC student;

INSERT INTO student VALUES(1,"Carolina","2000-10-18","25");
INSERT INTO student VALUES(2,"Tanaka","2004-10-18","21");
INSERT INTO student VALUES(3,"Alex","1980-11-01","41");
INSERT INTO student VALUES(4,"Mitsubishi","1970-11-01","51");

SELECT *
FROM student1;

DROP TABLE student1;

SELECT *
FROM student;

CREATE TABLE course
(course_id INT PRIMARY KEY AUTO_INCREMENT, course_name VARCHAR(100));

INSERT INTO course VALUES
(1,"Physics"),
(2,"Chemistry"),
(3,"Maths");

SELECT *
from course;

CREATE TABLE referenc
(student_id INT,course_id INT);

INSERT INTO referenc VALUES
(1,1),
(1,3),
(2,2),
(2,3),
(3,1),
(3,3),
(4,1),
(4,2),
(4,3);

SELECT * 
FROM referenc;

SELECT student.student_name, course.course_name FROM student
INNER JOIN referenc
ON student.student_id=referenc.student_id
INNER JOIN course
ON referenc.course_id=course.course_id;



