CREATE DATABASE dju24;

CREATE TABLE teachers(
	id bigserial,
	first_name varchar(25),
	last_name varchar(50),
	school varchar(50),
	hire_date date,
	salary numeric
);

INSERT INTO teachers (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F,D,Roosevelt H.S.', '2011-10-30', 36200),
		('Lee', 'Reynolds', 'F,D,Roosevelt H.S.', '1993-05-22', 65000),
		('Samuel', 'Cole', 'Meyers M.S.', '2005-08-01', 43500);
SELECT * from teachers;