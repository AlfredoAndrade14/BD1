-- Alfredo Vasconcelos de Andrade - 120210139
-- Banco de Dados 1 - Roteiro 05

-- Questão 1
SELECT COUNT(*) FROM employee WHERE sex = 'F';

-- Questão 2
SELECT AVG(salary) FROM employee WHERE sex = 'M' AND address LIKE '% TX';

-- Questão 3
SELECT superssn AS ssn_supervisor, COUNT(*) AS qtd_supervisionados FROM employee GROUP BY(superssn) ORDER BY qtd_supervisionados;

-- Questão 4
SELECT s.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM employee AS e INNER JOIN employee AS s on s.ssn = e.superssn GROUP BY(s.ssn) ORDER BY(qtd_supervisionados);

-- Questão 5
SELECT s.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM employee AS e LEFT JOIN employee AS s on s.ssn = e.superssn  GROUP BY(s.ssn);

-- Questão 6
SELECT MIN(COUNT) AS qtd FROM (SELECT COUNT(*) FROM works_on GROUP BY(pno)) AS quantidade;

-- Questão 7
SELECT pno AS num_projeto, qtd_func FROM ((SELECT pno, COUNT(*) FROM works_on GROUP BY(pno)) AS q JOIN (SELECT MIN(num) AS qtd_func FROM (SELECT COUNT(*) AS num FROM works_on GROUP BY(pno)) AS foo) AS n on q.COUNT = n.qtd_func);

-- Questão 8
SELECT w.pno AS num_proj, AVG(e.salary) AS media_sal FROM works_on AS w INNER JOIN employee AS e on w.essn = e.ssn GROUP BY(pno);

-- Questão 9
SELECT w.pno AS proj_num, pname AS proj_nome, AVG(e.salary) AS media_sal FROM project AS p INNER JOIN (works_on AS w INNER JOIN employee AS e on w.essn = e.ssn) on w.pno = p.pnumber GROUP BY(w.pno,p.pname);

-- Questão 10
SELECT e.fname, e.salary FROM employee AS e LEFT JOIN works_on AS w on w.pno = 92 WHERE salary > ALL (SELECT f.salary FROM employee AS f JOIN works_on AS t ON f.ssn=t.essn AND t.pno = 92) GROUP BY(e.fname, e.salary);

-- Questão 11
SELECT ssn, COUNT(w.pno) AS qtd_proj FROM employee AS e LEFT JOIN works_on AS w on w.essn = e.ssn GROUP BY(e.ssn) ORDER BY(qtd_proj);

-- Questão 12
SELECT pno AS num_proj, COUNT(*) AS qtd_func FROM employee AS e LEFT OUTER JOIN works_on AS w on w.essn = e.ssn GROUP BY(w.pno)  HAVING COUNT(*) < 5 ORDER BY(qtd_func);

-- Questão 13
SELECT fname FROM employee WHERE ssn IN (SELECT essn FROM dependent) AND ssn IN(SELECT essn FROM works_on WHERE pno IN (SELECT pnumber FROM project WHERE plocation = 'Sugarland'));

-- Questão 14
SELECT dname FROM department AS d WHERE NOT EXISTS(SELECT dnum FROM project AS p WHERE d.dnumber = p.dnum);

-- Questão 15
SELECT e.fname, e.lname FROM employee AS e WHERE ssn != '123456789' AND NOT EXISTS(SELECT * FROM works_on AS w WHERE w.pno IN (SELECT pno FROM works_on WHERE essn = '123456789' AND NOT EXISTS (SELECT * FROM works_on AS t WHERE t.essn = ssn AND t.pno = w.pno)));

-- Questão 16
