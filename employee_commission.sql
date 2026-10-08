CREATE TABLE IF NOT EXISTS departments (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    salary NUMERIC(12,2) CHECK (salary >= 0),
    department_id INT NOT NULL REFERENCES departments(id)
);

CREATE TABLE IF NOT EXISTS commissions (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL REFERENCES employees(id),
    commission_amount NUMERIC(12,2) CHECK (commission_amount >= 0)
);

INSERT INTO departments (id, name)
VALUES
(1, 'Banking'),
(2, 'Insurance'),
(3, 'Services');

INSERT INTO employees (id, name, salary, department_id)
VALUES
(1, 'Chris Gayle', 1000000, 1),
(2, 'Michael Clarke', 800000, 2),
(3, 'Rahul Dravid', 700000, 1),
(4, 'Ricky Pointing', 600000, 2),
(5, 'Albie Morkel', 650000, 2),
(6, 'Wasim Akram', 750000, 3);

INSERT INTO commissions (id, employee_id, commission_amount)
VALUES
(1, 1, 5000),
(2, 2, 3000),
(3, 3, 4000),
(4, 1, 4000),
(5, 2, 3000),
(6, 4, 2000),
(7, 5, 1000),
(8, 6, 5000);


SELECT * FROM departments;

SELECT * FROM employees;

SELECT * FROM commissions;

-- i. Find the employee who gets the highest total commission.
SELECT 
    e.id,
    e.name,
    SUM(c.commission_amount) AS total_commission
FROM employees e
JOIN commissions c
ON e.id = c.employee_id
GROUP BY e.id, e.name
ORDER BY total_commission DESC
LIMIT 1;

-- ii. Find employee with 4th Highest salary from employee table.
SELECT e.id, e.name, e.salary
FROM employees e
ORDER BY e.salary DESC
LIMIT 1 OFFSET 3;

-- iii. Find department that is giving highest commission.
SELECT 
    d.id,
    d.name,
    SUM(c.commission_amount) AS total_commission
FROM departments d 
JOIN employees e 
    ON d.id = e.department_id
JOIN commissions c 
    ON e.id = c.employee_id
GROUP BY d.id, d.name
ORDER BY total_commission DESC
LIMIT 1;

-- iv. Find employees getting commission more than 3000 
--     Display Output in following pattern:  
--     		Chris Gayle, Rahul Dravid  4000
SELECT
    STRING_AGG(e.name, ', ') AS employees,
    c.commission_amount
FROM employees e
JOIN commissions c
    ON e.id = c.employee_id
WHERE c.commission_amount > 3000
GROUP BY c.commission_amount;