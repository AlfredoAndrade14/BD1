-- Alfredo Vasconcelos de Andrade - 120210139
-- Banco de Dados 1 - Roteiro 09

-- 1.
-- A) VIEW vw_dptmgr
CREATE VIEW vw_dptmgr AS SELECT d.dnumber, e.fname AS mgrname FROM department AS d, employee AS e WHERE d.mgrssn = e.ssn;

-- B) VIEW vw_empl_houston
CREATE VIEW vw_empl_houston AS SELECT ssn, fname FROM employee WHERE address LIKE '%, Houston, TX';

-- C) VIEW vw_deptstats
CREATE VIEW vw_deptstats AS SELECT dnumber, dname, COUNT(*) AS num_employee FROM department, employee WHERE dno = dnumber GROUP BY dnumber;

-- D) VIEW vw_projstats
CREATE VIEW vw_projstats AS SELECT pno, COUNT(*) AS num_employee FROM works_on GROUP BY pno;

-- 2.
-- Consultas de A
SELECT * FROM vw_dptmgr;
SELECT dnumber FROM vw_dptmgr;
SELECT mgrname FROM vw_dptmgr;

-- Consultas de B
SELECT * FROM vw_empl_houston;
SELECT ssn FROM vw_empl_houston;
SELECT fname FROM vw_empl_houston;

-- consultas de C
SELECT * FROM vw_deptstats;
SELECT dnumber FROM vw_deptstats;
SELECT dname FROM vw_deptstats;
SELECT num_employee FROM vw_deptstats;

-- Consultas de D
SELECT * FROM vw_projstats;
SELECT pno FROM vw_projstats;
SELECT num_employee FROM vw_projstats;

-- 3.
DROP VIEW vw_dptmgr;
DROP VIEW vw_empl_houston;
DROP VIEW vw_deptstats;
DROP VIEW vw_projstats;

-- 4.
CREATE OR REPLACE FUNCTION check_age (check_ssn VARCHAR(9))
RETURNS VARCHAR(7) AS $$
DECLARE age SMALLINT;
BEGIN
    SELECT date_part('year',AGE(CURRENT_DATE, bdate)) FROM employee INTO age WHERE ssn = check_ssn;
    IF (age >= 50) THEN RETURN 'SENIOR';
    ELSIF (age < 0) THEN RETURN 'INVALID';
    ELSIF (age < 50) THEN RETURN 'YOUNG';
    ELSE RETURN 'UNKNOWN';
    END IF;   
END; $$ LANGUAGE plpgsql;

-- 5.
CREATE OR REPLACE FUNCTION check_mgr() RETURNS trigger AS $check_mgr$
    DECLARE
        mgr_dno INTEGER;
        mgr_type VARCHAR(7);
        mgr_subs SMALLINT;
    BEGIN
        SELECT e.dno, check_age(e.ssn), count(*) INTO mgr_dno, mgr_type, mgr_subs FROM employee AS e, employee AS s WHERE e.ssn = NEW.mgrssn AND s.superssn = e.ssn GROUP BY e.ssn;
        
        IF (mgr_dno <> NEW.dnumber OR mgr_dno IS NULL) THEN
            RAISE EXCEPTION 'manager must be a department''s employee';
        END IF;

        IF (mgr_type <> 'SENIOR') THEN
            RAISE EXCEPTION 'manager must be a SENIOR employee';
        END IF;

        IF (mgr_subs = 0) THEN
            RAISE EXCEPTION 'manager must have supevisees';
        END IF;

        RETURN NEW;
    END;
$check_mgr$ LANGUAGE plpgsql;

CREATE TRIGGER check_mgr 
BEFORE INSERT OR UPDATE ON 
department FOR EACH ROW EXECUTE PROCEDURE check_mgr();