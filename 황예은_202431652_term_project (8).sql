/* 
 * 데이터베이스 시스템 Term Project
 * 제출자: [황예은]
 * 학번: [202431652]
 * 날짜: [2025.06.05]
 */

-- ----------------------------------------------------
-- 0. 외래 키 의존성 이해도 체크 (객관식 문제)
-- ----------------------------------------------------

-- 아래 객관식 문제를 풀어 외래 키 의존성과 순서의 이유를 이해했는지 확인하세요.
-- 각 문제의 정답을 주석으로 작성하세요.

-- 문제 1: 왜 regions 테이블을 가장 먼저 생성해야 하는가?
-- a) 외래 키로 다른 테이블을 참조하기 때문
-- b) 다른 테이블에서 regions를 참조하기 때문
-- c) regions가 가장 많은 데이터를 포함하기 때문
-- d) 순서와 상관없음
-- 답안: b
-- 해설: regions 테이블은 countries 테이블에서 외래 키로 참조됩니다. 참조당하는 테이블은 참조하는 테이블보다 먼저 생성되어야 외래 키 제약 조건이 올바르게 설정될 수 있습니다.


-- 문제 2: employees와 departments 테이블 간 상호 참조 관계를 해결하기 위해 어떤 순서로 작업해야 하는가?
-- a) employees를 생성하고 바로 외래 키를 설정한 후 departments 생성
-- b) departments를 생성하고 바로 외래 키를 설정한 후 employees 생성
-- c) 두 테이블을 모두 생성한 후 외래 키를 설정
-- d) 상호 참조 관계는 설정할 수 없음
-- 답안: c
-- 해설: 두 테이블이 서로를 참조하는 관계일 때는, 먼저 테이블 구조만 생성한 후 외래 키 제약 조건은 나중에 ALTER TABLE 명령어로 추가해야 오류 없이 생성할 수 있습니다.


-- 문제 3: job_history 테이블을 employees, jobs, departments 테이블보다 나중에 생성해야 하는 이유는?
-- a) job_history가 이 세 테이블을 외래 키로 참조하기 때문
-- b) job_history가 가장 많은 데이터를 포함하기 때문
-- c) 순서와 상관없음
-- d) job_history가 외래 키를 참조하지 않기 때문
-- 답안: a
-- 해설: job_history는 이 세 테이블의 기본 키를 외래 키로 참조하므로, 참조되는 테이블(employees, jobs, departments)이 먼저 생성되어야 외래 키 제약 조건을 설정할 수 있습니다.


-- 문제 4: 왜 employees 테이블을 외래 키 없이 먼저 생성해야 하는가?
-- a) 데이터가 많아서 먼저 생성해야 하기 때문
-- b) 자기 참조 관계(manager_id)와 상호 참조 관계(departments)가 있기 때문
-- c) 외래 키 설정이 필요 없기 때문
-- d) 순서와 상관없기 때문
-- 답안: b
-- 해설: employees 테이블은 자기 참조(manager_id)와 departments 테이블과의 상호 참조 관계가 있기 때문에, 먼저 테이블을 생성한 후 외래 키는 나중에 추가해야 순환 참조 에러를 피할 수 있습니다.


-- 문제 5: jobs 테이블이 다른 테이블을 참조하지 않음에도 불구하고 employees와 job_history 전에 생성되는 이유는?
-- a) jobs 테이블이 가장 간단하기 때문
-- b) employees와 job_history가 jobs.job_id를 참조하기 때문
-- c) 데이터 크기가 작기 때문
-- d) 순서와 상관없기 때문
-- 답안: b
-- 해설: jobs 테이블은 employees와 job_history 테이블에서 참조되므로, 참조당하는 테이블인 jobs 테이블을 먼저 생성해야 외래 키 제약 조건 설정이 가능합니다.


-- ----------------------------------------------------
-- 1. 데이터베이스 구축 (DDL 작성)
-- 테이블 생성 순서는 외래 키 의존성을 고려해야 합니다.
-- ----------------------------------------------------

CREATE DATABASE hr; -- hr 데이터베이스 생성
USE hr; -- hr 데이터베이스 선택

-- 1.1 regions 테이블 생성
-- countries 테이블이 외래 키로 regions.region_id를 참조하므로 가장 먼저 생성해야 함
CREATE TABLE regions (
 region_id INT UNSIGNED NOT NULL, -- 기본 키
    region_name VARCHAR(25),
    PRIMARY KEY (region_id)
);



-- 1.2 countries 테이블 생성
-- regions 테이블을 외래 키로 참조함
CREATE TABLE countries (
country_id CHAR(2) NOT NULL, -- 기본 키
    country_name VARCHAR(40),
    region_id INT UNSIGNED NOT NULL, -- regions.region_id를 참조
    PRIMARY KEY (country_id)
);

-- 1.3 locations 테이블 생성
-- countries 테이블을 외래 키로 참조함
CREATE TABLE locations (
location_id INT UNSIGNED NOT NULL AUTO_INCREMENT, -- 기본 키
    street_address VARCHAR(40),
    postal_code VARCHAR(12),
    city VARCHAR(30) NOT NULL,
    state_province VARCHAR(25),
    country_id CHAR(2) NOT NULL, -- countries.country_id를 참조
    PRIMARY KEY (location_id)
);

-- 1.4 departments 테이블 생성
-- 아직 외래 키는 걸지 않음 (employees와 상호 참조 관계이므로 나중에 추가)
CREATE TABLE departments (
department_id INT UNSIGNED NOT NULL, -- 기본 키
    department_name VARCHAR(30) NOT NULL,
    manager_id INT UNSIGNED, -- employees.employee_id 참조 예정
    location_id INT UNSIGNED, -- locations.location_id 참조
    PRIMARY KEY (department_id)
);

-- 1.5 jobs 테이블 생성
-- 다른 테이블을 참조하지 않지만, employees와 job_history에서 참조됨 -> 미리 생성
CREATE TABLE jobs (
 job_id VARCHAR(10) NOT NULL, -- 기본 키
    job_title VARCHAR(35) NOT NULL,
    min_salary DECIMAL(8,0) UNSIGNED,
    max_salary DECIMAL(8,0) UNSIGNED,
    PRIMARY KEY (job_id)
);

-- 1.6 employees 테이블 생성
-- 자기 참조(manager_id)와 상호 참조(department_id)가 있으므로 외래 키는 나중에 추가
CREATE TABLE employees (
 employee_id INT UNSIGNED NOT NULL, -- 기본 키
    first_name VARCHAR(20),
    last_name VARCHAR(25) NOT NULL,
    email VARCHAR(25) NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE NOT NULL,
    job_id VARCHAR(10) NOT NULL, -- jobs 테이블 참조 예정
    salary DECIMAL(8,2) NOT NULL,
    commission_pct DECIMAL(2,2),
    manager_id INT UNSIGNED, -- 자기 참조
    department_id INT UNSIGNED,  -- departments 테이블 참조 예정
    PRIMARY KEY (employee_id)
);

-- 1.7 job_history 테이블 생성
-- employees, jobs, departments 테이블 참조 → 가장 마지막에 생성
CREATE TABLE job_history (
employee_id INT UNSIGNED NOT NULL, -- employees 참조
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    job_id VARCHAR(10) NOT NULL, -- jobs 참조
    department_id INT UNSIGNED NOT NULL, -- departments 참조
    PRIMARY KEY (employee_id, start_date)
);

-- 1.8 job_grades 테이블 생성
-- 참조 관계 없음
CREATE TABLE job_grades (
 grade_level CHAR(1), -- 기본 키
    lowest_sal INT NOT NULL,
    highest_sal INT NOT NULL,
    PRIMARY KEY (grade_level)
);

-- 1.9 job_history 테이블 UNIQUE 제약조건 추가
-- 중복 이력 방지를 위해 employee_id와 start_date 조합에 고유성 부여
ALTER TABLE job_history ADD UNIQUE INDEX (
employee_id, start_date
);

-- ----------------------------------------------------
-- 2. 외래 키 제약조건 설정
-- 상호 참조 관계(employees, departments)는 순서에 주의하세요.
-- ----------------------------------------------------

-- 2.1 countries 테이블 외래 키 설정
-- countries.region_id -> regions.region_id
ALTER TABLE countries ADD FOREIGN KEY (region_id) references regions(region_id);

-- 2.2 locations 테이블 외래 키 설정
-- locations.country_id -> countries.country_id
ALTER TABLE locations ADD FOREIGN KEY (country_id) REFERENCES countries(country_id);

-- 2.3 departments 테이블 외래 키 설정
-- departments.location_id -> locations.location_id
ALTER TABLE departments ADD FOREIGN KEY  (location_id) REFERENCES locations(location_id);

-- 2.4 employees 테이블 외래 키 설정 (job_id)
-- employees.job_id -> jobs.job_id
ALTER TABLE employees ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);

-- 2.5 employees 테이블 외래 키 설정 (department_id)
-- 주석: departments 테이블 생성 후 설정 가능 (상호 참조 관계 고려)
-- employees.department_id -> departments.department_id
ALTER TABLE employees ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);

-- 2.6 employees 테이블 외래 키 설정 (manager_id)
-- 주석: 자기 참조 관계
-- employees.manager_id -> employees.employee_id (자기 참조)
ALTER TABLE employees ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- 2.7 departments 테이블 추가 외래 키 설정 (manager_id)
-- 주석: employees 테이블과의 상호 참조 관계 해결
-- departments.manager_id -> employees.employee_id (상호 참조 해결)
ALTER TABLE departments ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

-- 2.8 job_history 테이블 외래 키 설정 (employee_id)
ALTER TABLE job_history ADD FOREIGN KEY (employee_id) REFERENCES employees(employee_id);
-- 2.9 job_history 테이블 외래 키 설정 (job_id)
ALTER TABLE job_history ADD FOREIGN KEY (job_id) REFERENCES jobs(job_id);
-- 2.10 job_history 테이블 외래 키 설정 (department_id)
ALTER TABLE job_history ADD FOREIGN KEY  (department_id) REFERENCES departments(department_id);

-- ----------------------------------------------------
-- 3. SQL 질의 문제 해결
-- ----------------------------------------------------

-- 문제 1: [쉬움] 급여가 높은 상위 5명 사원 조회
-- employees 테이블에서 salary가 가장 높은 상위 5명 사원의 first_name, last_name, salary를 조회하시오.
-- (급여 순으로 내림차순 정렬)

-- 답안:
-- 해결과정: employees 테이블에서 salary 기준으로 내림차순 정렬 후 상위 5개의 행만 추출
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;


-- 문제 2: [쉬움] Sales 부서 사원 조회
-- employees 테이블과 departments 테이블을 JOIN하여 'Sales' 부서(department_name)에 근무하는 
-- 모든 사원의 employee_id, first_name, last_name, job_id를 조회하시오.

-- 답안:
-- 해결과정: employees 테이블과 departments 테이블을 조인하고, 부서명이 'Sales'인 경우만 필터링
SELECT e.employee_id, e.first_name, e.last_name, e.job_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
-- employees 테이블의 부서 ID와 departments 테이블의 부서 ID 연결
WHERE d.department_name = 'Sales';


-- 문제 3: [중간] 부서별 사원 수와 평균 급여 계산
-- 각 부서(department_name)별 사원 수와 평균 급여(salary)를 계산하여 조회하시오.
-- 결과는 부서명을 알파벳 순으로 정렬하고, 사원이 없는 부서는 제외하시오.

-- 답안:
-- 해결과정: 부서 이름 기준으로 그룹화하여 COUNT와 AVG 함수 사용. 부서명이 알파벳 순으로 정렬되며 사원 없는 부서는 제외됨 (INNER JOIN)
SELECT d.department_name, COUNT(e.employee_id) AS employee_count, ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
-- employees와 departments를 부서 ID 기준으로 JOIN
GROUP BY d.department_name
ORDER BY d.department_name;


-- 문제 4: [중간] 2000년 이후 입사 & 부서 평균보다 높은 급여 사원 조회
-- 2000년 이후(2000년 포함) 입사한 사원 중에서, 급여(salary)가 해당 부서의 평균 급여보다 높은 
-- 사원의 employee_id, first_name, last_name, department_id, salary를 조회하시오. (서브쿼리 활용)

-- 답안:
-- 해결과정: hire_date가 2000년 이상인 행들 중, 동일 부서의 평균 급여보다 높은 급여를 받은 사원을 서브쿼리와 함께 필터링

SELECT 
    e.employee_id,                         
    e.first_name,                          
    e.last_name,                           
    e.department_id,                       
    ROUND(e.salary, 2) AS salary-- 급여를 소수점 2자리로 반올림하여 표시
FROM employees e
WHERE hire_date >= '2000-01-01'-- 2000년 1월 1일 이후 입사한 사원만 선택
  AND e.department_id IS NOT NULL-- 부서 ID가 NULL이 아닌 사원만 대상
  AND e.salary > (                       
      SELECT AVG(e2.salary)-- 서브쿼리: 동일 부서의 평균 급여 계산
      FROM employees e2
      WHERE e2.department_id = e.department_id
  )
ORDER BY e.employee_id;-- 사원 ID 기준으로 오름차순 정렬


-- 문제 5: [어려움] 사원의 현재 급여와 이전 직무 제목 조회
-- 각 사원(employee_id, first_name, last_name)의 현재 급여(salary)와 직무 이력(job_history)에 
-- 기록된 이전 직무의 제목(job_title)을 함께 조회하시오. 이전 직무가 없는 사원도 결과에 포함하며, 
-- 이 경우 이전 직무 제목은 NULL로 표시하시오. (JOIN과 LEFT JOIN 활용)

-- 답안:
-- 해결과정: 사원 기준으로 job_history 테이블에서 가장 최근 이력만 추출하고 jobs 테이블과 조인하여 이전 직무명 조회. 과거 직무가 없는 경우 NULL 처리 (LEFT JOIN)
SELECT e.employee_id, e.first_name, e.last_name, e.salary, j.job_title AS previous_job_title
FROM employees e
LEFT JOIN (
    SELECT jh.employee_id, jh.job_id
    FROM job_history jh
    WHERE (jh.employee_id, jh.end_date) IN (
        SELECT employee_id, MAX(end_date)
        FROM job_history
        GROUP BY employee_id-- 가장 최근 직무 이력만 추출
    )
) latest_jh ON e.employee_id = latest_jh.employee_id-- employees와 job_history 최신 이력 JOIN
LEFT JOIN jobs j ON latest_jh.job_id = j.job_id;-- 직무 ID를 기준으로 jobs 테이블과 JOIN하여 이전 직무명 가져옴


-- 문제 6: [중급] 근속 연수 및 보너스 계산
-- 각 사원의 근속 연수를 계산하고, 근속 연수에 따른 보너스를 계산하는 쿼리를 작성하시오.
-- 근속 연수는 현재 날짜와 입사일(hire_date) 기준으로 계산하며, 다음 보너스 비율을 적용하시오:
--   * 25년 이상: 급여의 25%
--   * 20년 이상: 급여의 20%
--   * 15년 이상: 급여의 15%
--   * 10년 이상: 급여의 10%
--   * 그 외: 급여의 5%
-- 결과는 근속 연수를 기준으로 내림차순 정렬하시오.
-- (YEAR, DATEDIFF, ROUND, CONCAT, CASE 함수 활용)

-- 답안:
-- 해결과정: DATEDIFF로 입사일과 현재 날짜 차이 계산 후, 보너스는 CASE 조건에 따라 비율을 나눠 계산. 결과는 근속 연수 내림차순 정렬
SELECT 
    employee_id,
    CONCAT(first_name, ' ', last_name) AS employee_name,
    hire_date,
    FLOOR(DATEDIFF(CURDATE(), hire_date)/365) AS years_of_service,-- 정수형 근속 연수
    ROUND(DATEDIFF(CURDATE(), hire_date)/365, 1) AS exact_years,-- 소수점 포함 근속 연수
    salary,
    ROUND(salary * (
        CASE 
            WHEN DATEDIFF(CURDATE(), hire_date)/365 >= 25 THEN 0.25
            WHEN DATEDIFF(CURDATE(), hire_date)/365 >= 20 THEN 0.20
            WHEN DATEDIFF(CURDATE(), hire_date)/365 >= 15 THEN 0.15
            WHEN DATEDIFF(CURDATE(), hire_date)/365 >= 10 THEN 0.10
            ELSE 0.05
        END), 4) AS service_bonus-- 보너스 계산
FROM employees
ORDER BY years_of_service DESC;


-- 문제 7: [중급-상급] 사원 위치 정보 뷰 생성 및 활용
-- 7-1: 먼저 아래와 같이 사원의 근무 위치 정보를 포함하는 뷰(employee_location_details)를 생성하시오.
-- 뷰는 employees, departments, locations, countries, regions, jobs 테이블을 JOIN하여 생성하시오.

-- CREATE VIEW는 새로운 뷰를 생성, 기존 VIEW가 존재하면 에러 발생
-- CREATE OR REPLACE VIEW는 뷰가 있으면 덮어쓰기, 없으면 새로 생성

-- 해결과정: employees 테이블을 중심으로 jobs, departments, locations, countries, regions 테이블을 JOIN 하여 상세 근무지 정보를 포함하는 뷰 생성
-- employees, jobs, departments, locations, countries, regions 테이블을 JOIN하여 생성

CREATE OR REPLACE VIEW employee_location_details AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.salary,
    j.job_title,          -- 직무명
    d.department_name,    -- 부서명
    l.city,               -- 도시명
    c.country_name,       -- 국가명
    r.region_name         -- 지역명
FROM employees e
LEFT JOIN jobs j ON e.job_id = j.job_id
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN locations l ON d.location_id = l.location_id
LEFT JOIN countries c ON l.country_id = c.country_id
LEFT JOIN regions r ON c.region_id = r.region_id;
SELECT * FROM employee_location_details;


-- 7-2: [초급] 위에서 생성한 뷰를 사용하여 'Americas' 지역(region_name)에 근무하는 
-- 사원 수를 조회하시오.

-- 답안:
-- 해결과정: employee_location_details 뷰에서 region_name이 'Americas'인 레코드만 필터링한 후 집계
SELECT region_name, COUNT(*) AS employee_count
FROM employee_location_details
WHERE region_name = 'Americas'
GROUP BY region_name;


-- 7-3: [중초급] 위에서 생성한 뷰를 사용하여 국가별, 부서별 평균 급여를 조회하시오.
-- 결과는 국가명을 기준으로 오름차순 정렬하고, 각 국가 내에서는 평균 급여를 기준으로 내림차순 정렬하시오.

-- 답안:
-- 해결과정: 뷰에서 country_name, department_name 기준으로 그룹화하여 AVG로 평균 급여 계산. 정렬은 국가명 오름차순, 평균 급여 내림차순
SELECT country_name, department_name, ROUND(AVG(salary), 2) AS avg_salary
FROM employee_location_details
WHERE country_name IS NOT NULL AND department_name IS NOT NULL
GROUP BY country_name, department_name
ORDER BY country_name ASC, avg_salary DESC;


-- 7-4: [중급] 위에서 생성한 뷰를 사용하여 각 지역(region_name)별로 가장 높은 급여를 받는 
-- 사원의 정보(이름, 직무, 부서, 급여)를 조회하시오.

-- 답안:
-- 해결과정: 서브쿼리로 각 region_name별 최고 급여 구하고, 이를 employee_location_details와 조인하여 상세 사원 정보 추출　＋　MAX(salary)를 사용하는 이유는 각 지역(region_name)별로 가장 높은 급여를 받은 사원을 식별하기 위해서입니다.
SELECT eld.region_name, eld.employee_name, eld.job_title, eld.department_name, eld.salary
FROM employee_location_details eld
JOIN (
    SELECT region_name, MAX(salary) AS max_salary-- 각 지역별 최고 급여 추출
    FROM employee_location_details
    GROUP BY region_name
) rmax ON eld.region_name = rmax.region_name AND eld.salary = rmax.max_salary;-- 최고 급여 사원만 필터링
