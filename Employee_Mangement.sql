
                    -- Employee Management System SQL  --


-- Create Departments Table
CREATE TABLE Departments 
(
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Create Employees Table
CREATE TABLE Employees 
(
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10, 2),
    join_date DATE,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

-- Create Attendance Table
CREATE TABLE Attendance 
(
    att_id INT PRIMARY KEY,
    emp_id INT,
    date DATE,
    status VARCHAR(10), -- Present / Absent / Leave
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Create Payroll Table
CREATE TABLE Payroll
 (
    payroll_id INT PRIMARY KEY,
    emp_id INT,
    month VARCHAR(10),
    base_salary DECIMAL(10, 2),
    bonus DECIMAL(10, 2),
    total_salary DECIMAL(10, 2),
    FOREIGN KEY (emp_id) REFERENCES Employees(emp_id)
);

-- Insert sample data into Departments
INSERT INTO Departments VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'Engineering');

-- Insert sample data into Employees
INSERT INTO Employees VALUES
(101, 'Alice', 1, 50000, '2022-01-10'),
(102, 'Bob', 2, 60000, '2021-11-20'),
(103, 'Charlie', 3, 70000, '2023-02-15');

-- Insert sample data into Attendance
INSERT INTO Attendance VALUES
(1, 101, '2025-07-01', 'Present'),
(2, 101, '2025-07-02', 'Present'),
(3, 102, '2025-07-01', 'Absent'),
(4, 103, '2025-07-01', 'Present'),
(5, 103, '2025-07-02', 'Leave');

-- Insert sample data into Payroll
INSERT INTO Payroll VALUES
(1, 101, 'July', 50000, 2000, 52000),
(2, 102, 'July', 60000, 0, 60000),
(3, 103, 'July', 70000, 3000, 73000);


-- 1. Department-wise Salary Distribution
SELECT 
    d.department_name,
    SUM(e.salary) AS total_salary,
    AVG(e.salary) AS avg_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name;


-- 2. Attendance Percentage for July
SELECT 
    e.emp_id,
    e.emp_name,
    ROUND(SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attendance_percentage
FROM Employees e
JOIN Attendance a ON e.emp_id = a.emp_id
WHERE strftime('%m', a.date) = '07'
GROUP BY e.emp_id, e.emp_name;


-- 3. Bonus Classification Using CASE
SELECT 
    emp_id,
    base_salary,
    bonus,
    total_salary,
    CASE 
        WHEN bonus >= 3000 THEN 'Excellent Bonus'
        WHEN bonus >= 1000 THEN 'Good Bonus'
        ELSE 'No Bonus'
    END AS bonus_category
FROM Payroll;


-- 4. Employees Who Never Took Leave
SELECT emp_id, emp_name
FROM Employees
WHERE emp_id NOT IN (
    SELECT emp_id FROM Attendance WHERE status = 'Leave'
);
