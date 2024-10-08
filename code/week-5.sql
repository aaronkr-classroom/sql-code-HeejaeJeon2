-- SHOW DATAVASES; --MySQL에서만 사용

-- 데이터베이스 생성
-- DROP DATABASE IF EXISTS univDB;

CREATE DATABASE univDB;

-- SQL 명령어를 실행할 대상인 기본 데이터베이스를 univDB로 지정
-- USE univDB;

-- 학생 테이블생성
CREATE TABLE 학생
	( 학번 CHAR(4) NOT NULL,
	이름 VARCHAR(20) NOT NULL,
	주소 VARCHAR(50) NULL DEFAULT '미정',
	학년 INT NOT NULL,
	나이 INT NULL,
	성별 CHAR(1) NOT NULL,
	휴대폰번호 CHAR(14) NULL,
	소속학과 VARCHAR(20) NULL,
	PRIMARY KEY (학번) );

-- 과목 테이블 생성
CREATE TABLE 과목
	( 과목번호 char(4) NOT NULL PRIMARY KEY,
	이름 VARCHAR(20) NOT NULL,
	강의실 CHAR(3) NOT NULL,
	개설학과 VARCHAR(20) NOT NULL,
	시수 INT NOT NULL );

-- 수강 테이블 생성
CREATE TABLE 수강
	( 학번 CHAR(6) NOT NULL,
	과목번호 CHAR(4) NOT NULL,
	신청날짜 DATE NOT NULL,
	중간성적 INT NULL DEFAULT 0,
	기말성적 INT NULL DEFAULT 0,
	평가학점 CHAR(1) NULL,
PRIMARY KEY( 학번, 과목번호) );

-- 학생 테이블입력
INSERT INTO 학생 VALUES ( 's001', '김연아', '서울 서초', 4, 23, '여', '010-1111-2222', '컴퓨터' );
INSERT INTO 학생 VALUES ( 's002', '홍길동', DEFAULT, 1, 26, '남', NULL, '통계' );
INSERT INTO 학생 VALUES ('s003', '이승엽', NULL, 3, 30, '남', NULL, '정보통신' );
INSERT INTO 학생 VALUES ('s004', '이영애', '경기 분당', 2, NULL, '여', '010-4444-5555', '정보통신' );
INSERT INTO 학생 VALUES ('s005', '송윤아', '경기 분당', 4, 23, '여', '010-6666-7777', '컴퓨터' );
INSERT INTO 학생 VALUES ('s006', '홍길동', '서울 종로', 2, 26, '남', '010-8888-9999', '컴퓨터' );
INSERT INTO 학생 VALUES ('s007', '이온진', '경기 과천', 1, 23, '여', '010-2222-3333', '경영' );

-- 괴목 테이블 입력
INSERT INTO 과목
VALUES
	('c001', '데이터베이스', '126', '컴퓨터', 3),
	('c002', '정보보호', '137', '정보통신', 3),
	('c003', '모바일웹', '128', '컴퓨터', 3),
	('c004', '철학개론', '117', '철학', 2),
	('c005', '전공글쓰기', '120', '교양학부', 1);

-- 수강 테이블 입력
INSERT INTO 수강
VALUES 
	('s001', 'c002', '2019-09-03', 93, 98, 'A'),
	('s004', 'c005', '2019-03-03', 72, 78, 'C'),
	('s003', 'c002', '2017-09-06', 85, 82, 'B'),
	('s002', 'c001', '2018-03-10', 31, 50, 'F'),
	('s001', 'c004', '2019-03-05', 82, 89, 'B'),
	('s004', 'c003', '2020-09-03', 91, 94, 'A'),
	('s001', 'c005', '2020-09-03', 74, 79, 'C'),
	('s003', 'c001', '2019-03-03', 81, 82, 'B'),
	('s004', 'c002', '2018-03-05', 92, 95, 'A');
	
-- 테이블 확인하기
TABLE 학생; -- SELECT * FROM 학생;
TABLE 과목;
TABLE 수강;

-- SELECT문
SELECT 이름, 주소 FROM 학생;

SELECT DISTINCT 소속학과 FROM 학생;

SELECT 이름, 학년, 소속학과, 휴대폰번호 FROM 학생
WHERE 학년 >=2 AND 소속학과 = '컴퓨터';

SELECT 이름, 학년, 소속학과, 휴대폰번호 FROM 학생
WHERE (학년 BETWEEN 1 AND 3) OR NOT (소속학과 = '컴퓨터');

SELECT 이름, 학년, 소속학과 FROM 학생
WHERE 소속학과 = '컴퓨터' OR 소속학과 = '정보통신'
ORDER BY 학년 DESC;

SELECT * FROM 학생
ORDER BY 학년 ASC, 이름 DESC;
LIMIT 3;

-- 집계 함수
SELECT COUNT(*) FROM 학생;
SELECT COUNT(주소) FROM 학생;

SELECT AVG(나이) 남학생평균나이 FROM 학생
WHERE 성별 = '남';

SELECT 성별, MAX(나이) 최고나이, MIN(나이) 최저나이 FROM 학생
GROUP BY 성별;

SELECT 나이, COUNT(*) 나이별 FROM 학생
GROUP BY 나이 ORDER BY 나이 DESC;

SELECT 학년, COUNT(*) 학년별  FROM 학생
GROUP BY 학년
HAVING COUNT(*) >=2
ORDER BY 학년 DESC;

--데이터 검색하기
SELECT 학번, 이름 FROM 학생
WHERE 이름 LIKE '이%';

SELECT 이름, 휴대폰번호 FROM 학생
WHERE 휴대폰번호 LIKE '%22%';

SELECT 이름, 주소 FROM 학생
WHERE 주소 IS NULL;

SELECT 학번 FROM 학생 WHERE 성별 = '여'
UNION
SELECT 학번 FROM 수강 WHERE 평가학점='A';

SELECT 이름 FROM 학생
WHERE 이름 IN ('홍길동', '홍길순');

-- JOIN
SELECT * FROM 학생, 수강;
SELECT * FROM 학생 CROSS JOIN 수강;

-- 상대평가 계산하기
SELECT 학생.학번, 이름, 과목번호, 중간성적, 중간성적+(중간성적*0.1) AS 변환중간성적
FROM 학생 JOIN 수강 ON 학생.학번 = 수강.학번
WHERE 과목번호 = 'c002';

-- 테이블 3개의 조인
SELECT 학생.학번, 학생.이름, 수강.과목번호
FROM (학생 JOIN 수강 ON 학생.학번 = 수강.학번) JOIN 과목 ON 수강.과목번호 = 과목.과목번호
WHERE 과목.이름 = '정보보호'; -- c002

--OUTER JOINs
SELECT 학생.학번, 이름, 평가학점
FROM 학생 LEFT OUTER JOIN 수강 ON 학생.학번 = 수강.학번
ORDER BY 학생.학번;

SELECT H.학번 AS B, 이름, 평가학점
FROM 학생 AS H RIGHT OUTER JOIN 수강 AS S ON H.학번 = S.학번
ORDER BY B;

SELECT H.학번 AS B, 이름, 평가학점
FROM 학생 AS H FULL OUTER JOIN 수강 AS S ON H.학번 = S.학번
ORDER BY B;

--INSERT 위에 했습니다.

TABLE 학생;

--UPDATE
UPDATE 학생
SET 주소='대전대학교'
WHERE 학번='s002';

TABLE 학생;

UPDATE 학생
SET 학년=학년 + 1, 소속학과 = '자유전공학부'
WHERE 학년 = 4;

--DELETE
DELETE FROM 학생
WHERE 이름 = '이승엽';

