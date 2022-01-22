SET DATEFORMAT dmy
GO
USE master
GO
IF EXISTS (SELECT 'true' FROM sys.databases WHERE name = 'CompanieIT')
	BEGIN
		ALTER DATABASE CompanieIT SET SINGLE_USER WITH ROLLBACK IMMEDIATE
			 DROP DATABASE CompanieIT
END
GO
CREATE DATABASE CompanieIT
GO
USE CompanieIT
GO
ALTER AUTHORIZATION ON DATABASE :: CompanieIT TO sa
GO
GO
CREATE TABLE Angajati (
  IdAngajat int NOT NULL PRIMARY KEY,
  nume char(50),
  prenume char(50),
  CNP int UNIQUE CHECK (CNP > 99 AND CNP < 1000),
  strada char(50),
  nr_str char(50),
  gen char(1) CHECK (gen = 'm' OR gen = 'f'),
  data_nast char(50),
  salariu int,
  IdDepartament int
)
CREATE TABLE Departamente (
  IdDepartament int NOT NULL PRIMARY KEY,
  nume_dep char(20)
)
CREATE TABLE Proiecte (
  IdProiect int NOT NULL PRIMARY KEY,
  nume_proiect char(30),
  buget int,
  termen_limita date,
  IdDepartament int
)
CREATE TABLE Ang_Proecte (
  IdAng_Proect int NOT NULL PRIMARY KEY,
  IdProiect int NOT NULL,
  IdAngajat int NOT NULL
)
CREATE TABLE Intretinuti (
  IdIntretinuti int NOT NULL PRIMARY KEY,
  Nume_intretinut char(20),
  prenume_intretinut char(20),
  gen char(1) CHECK (gen = 'm' OR gen = 'f'),
  Data_NS char(20),
  IdAngajat int
)
--Foreign Key
ALTER TABLE Ang_Proecte
ADD FOREIGN KEY (IdAngajat) REFERENCES Angajati
ALTER TABLE Ang_Proecte
ADD FOREIGN KEY (IdProiect) REFERENCES Proiecte

ALTER TABLE Intretinuti
ADD FOREIGN KEY (IdAngajat) REFERENCES Angajati

ALTER TABLE Angajati
ADD FOREIGN KEY (IdDepartament) REFERENCES Departamente

ALTER TABLE Proiecte
ADD FOREIGN KEY (IdDepartament) REFERENCES Departamente




-----inserarea datelor
INSERT INTO Departamente (IdDepartament, nume_dep) VALUES 
    (1, 'Electronica')
  , (2, 'Inginerie')
  , (3, 'Informatica')
  , (4, 'Metalurgie')

INSERT INTO Proiecte (IdProiect, nume_proiect, buget, termen_limita, IdDepartament)VALUES
    (1, 'International', 500000, '20.02.2018', 2)
  , (2, 'Programarea Pasiunea Mea', 65300, '12.01.2018', 1)
  , (3, 'Cel Mai bun Metalurgist', 1442300, '29.09.2018', 1)
  , (4, 'Energie', 25000, '19.11.2018', 4)

INSERT INTO Angajati (IdAngajat, nume, prenume, CNP, strada, nr_str, gen, data_nast, salariu, IdDepartament)VALUES 
	(1, 'Crucerescu', 'Sandu', 345, 'str.Sarmisegetusa', '5/2', 'f', '20.09.1999', 3000, 1)
  , (2, 'Cristea', 'Alexandru', 132, 'str.Grenoble', '32/1', 'f', '20.03.2001', 5000, 1)
  , (3, 'Panco', 'Dan', 876, 'str.Zelinski', '2/1', 'm', '18.02.2000', 10000, 2)
  , (4, 'Turetchi', 'Gabriel', 432, 'bd.Dacie', '6/1', 'm', '18.02.2000', 4500, 3)
  , (5, 'Volosciuc', 'Nicoleta', 312, 'str.Vasile Alecsandri', '23/1', 'f', '10.02.1999', 7500, 1)
  , (6, 'Rogojinaru', 'Tatiana', 138, 'str.Puskin', '32/9', 'f', '19.10.1999', 3500, 4)
  , (7, 'Popov', 'Daniela', 302, 'str.Albisoara', '13/7', 'f', '28.02.2001', 4000, 2)
  , (8, 'Bivol', 'Cristi', 112, 'str.Hancesti', '3/2', 'm', '20.01.1999', 7000, 3)
  , (9, 'Rata', 'Daniel', 122, 'str.Ceucari', '45/1', 'm', '12.02.1999', 6300, 2)
  , (10, 'Castravet', 'Cornelia', 120, 'str.Independentei', '32/1', 'f', '13.06.1997', 12100, 3)
  , (11, 'Covali', 'Eugenia', 123, 'str.Independentei', '32/1', 'f', '13.06.1997', 8000, 4)


INSERT INTO Intretinuti (IdIntretinuti, Nume_intretinut, prenume_intretinut, gen, Data_NS, IdAngajat)VALUES 
    (1, 'Daphine', 'Burkhard', 'f', '19.10.2007', 6)
  , (2, 'Colton', 'Hake', 'm', '28.02.2009', 7)
  , (3, 'Mel', 'Kersh', 'm', '20.01.2009', 8)
  , (4, 'Augustina', 'Sibert', 'f', '12.02.2010', 9)
  , (5, 'Reda', 'Bunker', 'f', '13.06.2011', 10)
  , (6, 'Castravet', 'Cristian', 'm', '13.06.2011', 4)
  , (7, 'Bivol', 'Catalin', 'm', '13.06.2011', 6)

INSERT INTO Ang_Proecte(IdAng_Proect, IdAngajat, idproiect) VALUES 
	      (1, 1, 1)
		 ,(2, 2, 1)
		 ,(3, 3, 1)
		 ,(4, 2, 1)
		 ,(5, 10, 2)
		 ,(6, 9, 2)
		 ,(7, 8, 3)
		 ,(8, 4, 3)
		 ,(9, 5, 4)
		 ,(10, 6, 4)
		 ,(11, 7, 3)


-- Select varsta fiecarui Angajat
--SELECT 
--	Angajati.nume, 
--	Angajati.prenume, 
--	DATEDIFF(YEAR, CONVERT(datetime, data_nast), GETDATE()) AS varsta  
--	FROM Angajati


-- Cati copii are fiecare angajat
--SELECT Angajati.nume, COUNT(Intretinuti.IdAngajat) AS nr_copii
--FROM Intretinuti
--INNER JOIN Angajati ON Angajati.IdAngajat = Intretinuti.IdAngajat
--GROUP BY Angajati.nume
--ORDER BY nr_copii

-- afișați numele si prenumele copiilor pentru fiecare angajat.
--SELECT Angajati.nume, Angajati.prenume, Intretinuti.Nume_intretinut, Intretinuti.prenume_intretinut
--FROM Intretinuti
--INNER JOIN Angajati ON Angajati.IdAngajat = Intretinuti.IdAngajat


CREATE SYNONYM Intr FOR Intretinuti


/* Să se găsească Numele și Prenumele funcționarilor care activează în același departament cu”Covali Eugenia” */

--SELECT nume, prenume FROM Angajati
--WHERE IdDepartament = ( SELECT IdDepartament
--						FROM Angajati
--						WHERE nume='Covali' AND
--						prenume = 'Eugenia')


/* Să se găsească Numele și Prenumele funcționarilor 
care au salariu mai mare decât salariul maximal al ocupanților 
postului în care activează ”Covali Eugenia */

--SELECT nume, prenume FROM Angajati
--WHERE salariu > ( SELECT MAX(salariu)
--						FROM Angajati
--						WHERE IdDepartament = ( SELECT IdDepartament
--												FROM Angajati
--												WHERE nume='Covali' AND
--												prenume = 'Eugenia'
--												)
--				)



/* Să se afle numele și salariile funcționarilor care câștigă 
un salariu mai mare decât media pe un departament, 
dar salariu maxim pe acest departament e mai mic de 10000 */

--SELECT nume, prenume,salariu, IdDepartament
--	FROM Angajati
--	WHERE salariu > (SELECT AVG(salariu) FROM Angajati WHERE salariu < 10000)
--	AND 10000 < (SELECT MAX(salariu) FROM Angajati)
--	AND salariu < 10000
--	ORDER BY salariu
GO



/* Să se afișeze denumirile departamentelor care au cel puțin un funcționar care ridică un salariu mai mare de 8000 */

CREATE VIEW Pers_Depart AS
SELECT nume_dep, COUNT(Angajati.IdDepartament) AS numar_lucratori
FROM Departamente
INNER JOIN Angajati ON Angajati.IdDepartament = Departamente.IdDepartament
GROUP BY nume_dep
GO






BEGIN TRAN Buget_Venit
	
	ALTER TABLE Proiecte ADD Venit FLOAT
	GO
	UPDATE Proiecte SET Venit =  Proiecte.buget * 15 / 100

	ALTER TABLE Proiecte ADD Tva FLOAT
	GO
	UPDATE Proiecte SET Tva =  Proiecte.buget * 18 / 100
	
	ALTER TABLE Proiecte ADD Pret_vinzare_suma FLOAT
	GO
	UPDATE Proiecte SET Pret_vinzare_suma = Proiecte.buget - Proiecte.Tva - Proiecte.Venit
	
COMMIT

GO


-----------------------------------------------------------------------------------
--  Să se mareasca salariul Angajatilor cu 15 % care au un staj de munca mai mare de 2 ani
--  Să se aduge un atribut cu numele prima pentru toți angajații ce au un salariu cuprins între 3000 și 6000
-----------------------------------------------------------------------------------
BEGIN TRAN Tran_Ang

ALTER TABLE Angajati ADD staj INT
GO
UPDATE Angajati SET staj = 1 WHERE salariu <= 3000
UPDATE Angajati SET staj = 2 WHERE salariu BETWEEN 3000 AND 6000
UPDATE Angajati SET staj = 3 WHERE salariu >= 6000 
SAVE TRAN sp_1

UPDATE Angajati SET salariu = salariu + salariu * 0.15 WHERE staj > 2
SAVE TRAN sp_2

UPDATE Angajati SET nume = 'Cristi' WHERE nume = 'Cristea'
SAVE TRAN sp_3

DELETE FROM Angajati WHERE IdAngajat = 11
SAVE TRAN sp_4

ROLLBACK TRAN sp_3
COMMIT TRAN Tran_Ang
GO





CREATE TRIGGER Trigger_Dep
    ON Departamente
    FOR DELETE, INSERT, UPDATE
    AS
    BEGIN
    -- Nu permite modificarea
	RAISERROR ('Nu ai dreptul sa editezi', -- Message text.  
               16, -- Severity.  
               1 -- State.  
			   );  
    END
GO

--UPDATE Departamente SET nume_dep = 'A' WHERE IdDepartament = 1
--SELECT * FROM Departamente
GO


CREATE TRIGGER Trigger_Stergere
ON Departamente FOR DELETE
AS
    BEGIN
		PRINT 'Ai Sters cu succes'
    END
GO





