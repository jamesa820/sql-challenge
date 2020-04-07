-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/e8XTHG
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE departments 
(
    dept_no VARCHAR(30)   PRIMARY KEY NOT NULL,
    dept_name VARCHAR(30)   NOT NULL
);

CREATE TABLE dept_emp 
(
    emp_no INTEGER   NOT NULL,
    dept_no VARCHAR(30)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

CREATE TABLE dept_manager 
(
    dept_no VARCHAR(30)   NOT NULL,
    emp_no FOREIGN KEY  NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

CREATE TABLE employees 
(
    emp_no INTEGER PRIMARY KEY NOT NULL,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    gender VARCHAR   NOT NULL,
    hire_date DATE   NOT NULL
);

CREATE TABLE salaries 
(
    emp_no INTEGER   NOT NULL,
    salary INTEGER   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

CREATE TABLE titles 
(
    emp_no INTEGER   NOT NULL,
    title VARCHAR(30)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);
---------------------------------------------------------------------------------------------------------------------------------------
--1. List the following details of each employee: employee number, last name, first name, gender, and salary.

CREATE VIEW employee_details AS
SELECT employees.emp_no,
       employees.last_name,
       employees.first_name,
       employees.gender,
       salaries.salary
FROM employees
LEFT JOIN salaries
ON employees.emp_no=salaries.emp_no

----------------------------------------------------------------------------------------------------------------------------------------
--2. List employees who were hired in 1986.
SELECT 
emp_no,
last_name,
first_name,
hire_date
FROM employees
WHERE hire_date BETWEEN '1985-12-31' and '1987-01-01';
-----------------------------------------------------------------------------------------------------------------------------------------
--3. List the manager of each department with the following information: department number, department name
--the manager's employee number, last name, first name,and start and end employment dates.

ALTER TABLE dept_manager
	ADD CONSTRAINT fk_dept_manager_employees FOREIGN KEY (emp_no) REFERENCES employees(emp_no);

ALTER TABLE dept_manager
    ADD CONSTRAINT fk_dept_manager_departments FOREIGN KEY (dept_no) REFERENCES departments(dept_no);

SELECT dept_manager.dept_no,
       departments.dept_name,
       dept_manager.emp_no,
       employees.last_name,
       employees.first_name,
       dept_manager.from_date,
       to_date
FROM employees
LEFT JOIN dept_manager
ON employees.emp_no=dept_manager.emp_no
RIGHT JOIN departments
ON departments.dept_no=dept_manager.dept_no

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
--employees.emp_no.last_name.first_name
--(link emp_no)dept_emp.dept_no
--(link by dept_no) for department.dept_name

ALTER TABLE dept_emp
	ADD CONSTRAINT fk_dept_emp_employees FOREIGN KEY (emp_no) REFERENCES employees(emp_no);

ALTER TABLE dept_emp
    ADD CONSTRAINT fk_dept_emp_departments FOREIGN KEY (dept_no) REFERENCES departments(dept_no);

SELECT dept_emp.dept_no,
       departments.dept_name,
       dept_emp.emp_no,
       employees.last_name,
       employees.first_name,
FROM employees
LEFT JOIN dept_emp
ON employees.emp_no=dept_emp.emp_no
RIGHT JOIN departments
ON departments.dept_no=dept_emp.dept_no


--5. List all employees whose first name is "Hercules" and last names begin with "B."

SELECT first_name,last_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%'

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT departments.dept_name,
       dept_emp.emp_no,
       employees.last_name,
       employees.first_name
FROM employees
LEFT JOIN dept_emp
ON employees.emp_no=dept_emp.emp_no
RIGHT JOIN departments
ON departments.dept_no=dept_emp.dept_no
WHERE dept_emp.dept_no = 'd007'

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.

SELECT departments.dept_name,
       dept_emp.emp_no,
       employees.last_name,
       employees.first_name
FROM employees
LEFT JOIN dept_emp
ON employees.emp_no=dept_emp.emp_no
RIGHT JOIN departments
ON departments.dept_no=dept_emp.dept_no
WHERE dept_emp.dept_no = 'd005'
OR dept_emp.dept_no = 'd007';


--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

SELECT last_name, COUNT (last_name) AS "name frequency"
FROM employees
GROUP BY last_name
ORDER BY "name frequency" DESC;