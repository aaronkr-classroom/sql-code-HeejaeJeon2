SELECT * FROM 학생;

-- 트랜잭션
BEGIN; -- START FRANSATION;
DELETE FROM 학생 WHERE 학생.성별 = '남';
DELETE FROM 학생 WHERE 학생.성별 = '여';
SELECT * FROM 학생;
ROLLBACK;

BEGIN;
UPDATE 학생 SET 이름 = '홍길순' WHERE 학번 = 's002';
COMMIT;