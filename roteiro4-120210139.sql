-- Alfredo Vasconcelos de Andrade - 120210139
-- Banco de Dados 1 - Roteiro 04

-- Questão 1
SELECT * FROM department;

-- Questão 2
SELECT * FROM dependent;

-- Questão 3
SELECT * FROM dept_locations;

-- Questão 4
SELECT * FROM employee;

-- Questão 5
SELECT * FROM project;

-- Questão 6
SELECT * FROM works_on;

-- Questão 7
SELECT fname, lname FROM employee WHERE sex = 'M';

-- Questão 8
SELECT fname FROM employee WHERE sex = 'M' AND superssn IS NULL;

-- Questão 9
SELECT e.fname, s.fname FROM employee AS e, employee AS s WHERE e.superssn = s.ssn;

-- Questão 10
SELECT e.fname FROM employee AS e, employee AS s WHERE e.superssn = s.ssn and s.fname = 'Franklin';

-- Questão 11
SELECT dname, dlocation FROM department AS d, dept_locations AS dl WHERE d.dnumber = dl.dnumber;

-- Questão 12
SELECT d.dname FROM department AS d, dept_locations AS dl WHERE d.dnumber = dl.dnumber and dl.dlocation LIKE 'S%';

-- Questão 13
SELECT e.fname, e.lname, d.dependent_name FROM employee AS e, dependent AS d WHERE e.ssn = d.essn;

-- Questão 14
SELECT (fname || minit || lname) AS full_name, salary FROM employee WHERE salary > 50000;

-- Questão 15
SELECT pname, dname FROM project, department WHERE dnumber = dnum;

-- Questão 16
SELECT pname, fname FROM project, employee, department WHERE dnum = dnumber AND mgrssn = ssn AND pnumber > 30;

-- Questão 17
SELECT pname, fname FROM project, employee, works_on WHERE pno = pnumber AND essn = ssn;

-- Questão 18
SELECT  fname, dependent_name, relationship FROM employee AS e, dependent AS d, project AS p, works_on AS w WHERE e.ssn = d.essn AND w.pno = p.pnumber AND w.essn = e.ssn AND p.pnumber = 91;