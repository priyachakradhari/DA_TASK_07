
CREATE TABLE Emp (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(50),
    Gender VARCHAR(10),
    Salary INT,
    JoinDate DATE
);

Insert into emp(EmployeeID, Name, Department, Gender, Salary, JoinDate) values
(1, 'Amit Kumar', 'HR', 'Male', 45000, '2020-01-15'),
(2, 'Priya Sharma', 'Finance', 'Female', 60000, '2019-03-20'),
(3, 'Ravi Verma', 'IT', 'Male', 75000, '2021-07-01'),
(4, 'Sneha Roy', 'IT', 'Female', 70000, '2022-01-10'),
(5, 'Rahul Mehta', 'Marketing', 'Male', 50000, '2018-11-25'),
(6, 'Anjali Desai', 'HR', 'Female', 48000, '2020-06-18'),
(7, 'Vikas Yadav', 'Finance', 'Male', 62000, '2019-09-12'),
(8, 'Meena Joshi', 'Marketing', 'Female', 52000, '2021-04-05');

select * from emp;


-- 📌 Basic SELECT & WHERE
-- Show all columns of all employees.
select * from emp;

-- Display only the names and salaries of all employees.
select Name, Salary from emp;

-- List the employees who are in the Finance department.
select * from emp
where department = 'Finance';

-- Show employees whose salary is greater than 60,000.
select * from emp
where salary >60000;

-- Find employees who joined before 1st Jan 2020.
select * from emp
where JoinDate>'2020-01-01';

--📌 ORDER BY & LIMIT

-- List employees sorted by salary in descending order.
select * from emp
order by salary desc;

-- Find the top 3 highest paid employees.
select Top 3* from emp
order by salary desc;

-- Show employees from IT department sorted by JoinDate ascending.
select * from emp
where department = 'IT'
order by JoinDate;

-- 📌 Aggregation (COUNT, AVG, MIN, MAX)

-- What is the average salary of all employees?
select avg(salary) as Avg_salary from emp;

-- How many employees work in the HR department?
select count(EmployeeID) from emp
where Department = 'HR';

-- What is the maximum salary in the company?
select max(salary) from emp;

-- What is the total salary paid to Marketing department?
select sum(salary) from emp where department ='Marketing';

--📌 GROUP BY
--Show the number of employees in each department.
select department, count(*) from emp
group by department;

-- Show the average salary by department.
select department,avg(salary) as avg_salary from emp
group by department;

-- Count the number of male and female employees.
select gender, count(*) from emp
group by gender ;

--📌 DATE Functions
--List employees who joined in 2021.
select * from emp
where Year(JoinDate) = '2021';

-- Show the name and month of joining for each employee.
-- (Hint: use MONTH(JoinDate) or FORMAT(JoinDate, 'MMMM') in SQL Server)
select name, Format(JoinDate, 'MMMM') as month from emp;

-- 📌 Filtering with IN, BETWEEN, LIKE
-- Show employees who work in IT or HR departments.
select * from emp
where Department in ('IT','HR');

-- Show employees whose salary is between 50,000 and 70,000.
select * from emp
where salary between 50000 and 70000;

-- List employees whose name starts with 'A'.
select * from emp
where Name like 'A%';

