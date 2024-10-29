-- 숫자 내장 함수 
SELECT ABS(17), ABS(-17), CEIL(3.28), FLOOR(4.97);

SELECT 학번,
	SUM(기말성적)::FLOAT/COUNT(*) AS 평균성적
	-- ROUND(SUM(기말성적)::FLOAT/COUNT(*), 2)
FROM 수강2
GROUP BY 학번;

-- 문자 내장 함수
SELECT LENGTH(소속학과), RIGHT(학번, 2), REPEAT(' * ', 나이), CONCAT(소속학과, ' 학과')
FROM 학생;

SELECT SUBSTRING(주소, 1, 2), REPLACE(휴대폰번호, ' - ', ' * ')
FROM 학생;

SELECT 신청날짜, DATE_TRUNC('MONTH', 신청날짜) + INTERVAL '1 MONTH - 1 DAY' AS 마지막날
FROM 수강
WHERE EXTRACT(YEAR FROM 신청날짜) = 2019;

SELECT CURRENT_TIMESTAMP, 신청날짜 - DATE '2019-01-01' AS 일수차이
FROM 수강;

SELECT 신청날짜,
	TO_CHAR(신청날짜, 'Mon/DD/YY') AS 형식1,
	TO_CHAR(신청날짜, 'YYYY"년"MM"월"DD"일"') AS 형식2
FROM 수강;

--저장 프로시저
CREATE OR REPLACE PROCEDURE InsertOrUpdateCourse (
	IN CourseNo VARCHAR(4),
	IN CourseName VARCHAR(20),
	IN CourseRoom CHAR(3),
	IN CourseDept VARCHAR(20),
	IN CourseCredit INT
) 
LANGUAGE plpgsql
AS $$
DECLARE
	Count INT;
BEGIN
	--과목이 이미 존재하는지 확인
	SELECT COUNT(*) INTO Count FROM 과목 WHERE 과목번호 = CourseNo;
	
	IF Count = 0 THEN
		-- 과목이 존재하지 않으면 새 과목 추가
		INSERT INTO 과목 (과목번호, 이름, 강의실, 개설학과, 시수)
		VALUES (CourseNo, CourseName, CourseRoom, CourseDept, CourseCredit);
	ELSE
		-- 과목이 존재하면 기존 과목 업데이트
		UPDATE 과목
		SET 이름 = CourseName, 강의실 = CourseRoom, 개설학과 = CourseDept, 시수 = CourseCredit
		WHERE 과목번호 = CourseNo;
	END IF;
END;
$$;

CALL InsertOrUpdateCourse('c006', '연극학개론', '310', '교양학부', 2);
SELECT * FROM 과목;

CALL InsertOrUpdateCourse('c006', '연극학개론', '410', '교양학부', 2);
SELECT * FROM 과목;



CREATE PROCEDURE SelectAverageOfBestScore (
	IN Score INT,
	OUT Count INT
)
LANGUAGE plpgsql
AS $$
DECLARE
	NoMoreData BOOLEAN DEFAULT FALSE;
	Midterm INT ;
	Final INT ;
	BEST INT ;
	ScoreListCursor CURSOR FOR SELECT 중간성적, 기말성적 FROM 수강;
BEGIN
	-- COUNT 초기화
	Count := 0;
	
	OPEN ScoreListCursor ;
	LOOP
		FETCH ScoreListCursor INTO Midterm, Final ;
		EXIT WHEN NOT FOUND;
		
		IF Midterm > Final THEN
			Best := Midterm;
		ELSE
			Best := Final ;
		END IF ;
		
		IF Best >= Score THEN
			Count := Count +1;
		END IF;
	END LOOP;
	
	CLOSE ScoreListCursor;
END;
$$;

DO $$
DECLARE
	Count INT;
BEGIN
	CALL SelectAverageOfBestScore(95, Count);
	RAISE NOTICE 'Count: %', Count;
END;
$$;


CREATE OR REPLACE FUNCTION insert_or_update_course(
	course_no VARCHAR,
	course_room VARCHAR
) RETURNS VOID LANGUAGE plpgsql AS $$
BEGIN
	IF (SELECT COUNT(*) FROM course WHERE course_no = course_no) = 0 THEN
		INSERT INTO course (course_no, course_room) VALUES (course_no, course_room);
	ELSE
		UPDATE course SET course_room = course_room WHERE course_no = course_no;
	END IF;
END $$;

--트리거
CREATE TABLE 남녀학생총수
( 성별 CHAR(1) NOT NULL DEFAULT 0,
인원수 INT NOT NULL DEFAULT 0,
PRIMARY KEY (성별));
INSERT INTO 남녀학생총수 SELECT '남', COUNT(*) FROM 학생 WHERE 성별 = '남';
INSERT INTO 남녀학생총수 SELECT '여', COUNT(*) FROM 학생 WHERE 성별 = '여';
SELECT * FROM 남녀학생총수 ;

CREATE OR REPLACE FUNCTION AfterInsertStudent()
RETURNS TRIGGER AS $$
BEGIN
	IF(NEW.성별 = '남') THEN
		UPDATE 남녀학생총수 SET 인원수 = 인원수 + 1 WHERE 성별 = '남';
	ELSEIF (NEW.성별 = '여') THEN
		UPDATE 남녀학생총수 SET 인원수 = 인원수 + 1 WHERE 성별 = '여';
	END IF;
	RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER after_insert_student
AFTER INSERT ON 학생 FOR EACH ROW
EXECUTE FUNCTION AfterInsertStudent();

INSERT INTO 학생 
VALUES ('s008', '최동석', '경기 수원', 2, 26, '남', '010-8888-6666', '컴퓨터');

SELECT * FROM 남녀학생총수;

--사용자 정의한 함수
CREATE OR REPLACE FUNCTION Fn_Grade(grade CHAR)
RETURNS TEXT AS $$
BEGIN
	CASE grade
		WHEN 'A' THEN RETURN '최우수';
		WHEN 'B' THEN RETURN '우수';
		WHEN 'C' THEN RETURN '보통';
		ELSE RETURN '미흡';
	END CASE;
END;
$$ LANGUAGE plpgsql;

SELECT 학번, 과목번호, 평가학점, Fn_Grade(평가학점) AS 평가등급 FROM 수강;






