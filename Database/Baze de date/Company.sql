--CREAREA BAZEI DE DATE
USE master
GO
IF exists(
	SELECT *FROM sys.databases WHERE name='Companie')
BEGIN
		ALTER DATABASE Companie SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE Companie
		END
GO
CREATE DATABASE Companie
GO
USE Companie
GO


CREATE TABLE Departamente (
	Departament_ID int PRIMARY KEY, 
	Manager_ID int, 
	NumeDepartament nvarchar(20), 
	Cod int,
	)
GO


CREATE TABLE Angajati(
	Angajat_ID int PRIMARY KEY, 
	Nume nvarchar(20), 
	Prenume nvarchar(20), 
	Departament_ID int FOREIGN KEY REFERENCES Departamente(Departament_ID), 
	CNP bigint, 
	Strada nvarchar(30), 
	Oraș nvarchar(20),  
	Sex nvarchar(20), 
	DataNașterii date, 
	Salariu int 
	)
GO


CREATE TABLE Proiecte (
	Proiect_ID int PRIMARY KEY, 
	Nume_Proiect nvarchar(30), 
	Buget int, 
	Termen_limita date
	)
GO


CREATE TABLE Angajati_Proiecte (
	Angat_Proiect int PRIMARY KEY, 
	Angajati_ID int FOREIGN KEY REFERENCES Angajati(Angajat_ID), 
	Proiecte_ID int FOREIGN KEY REFERENCES Proiecte(Proiect_ID), 
	NrOreSaptamana int
	)
GO


INSERT INTO Departamente (Departament_ID, Manager_ID, NumeDepartament, Cod) values
	(1, 1, 'Finante', 100),
	(2, 2, 'Alimente', 200),
	(3, 1, 'Securitate', 300),
	(4, 3, 'Marketing', 400),
	(5, 2, 'Reclama', 500)
GO



INSERT INTO Angajati(Angajat_ID, Nume, Prenume, Departament_ID,	CNP, Strada, Oraș, Sex, DataNașterii, Salariu)VALUES
	(1,'Apostol','Andrei',	1,  1, 'Vasile Vasilachi nr.3', 'Chisinau', 'M', '10/29/2002', 3000),
	(2,'Bat', 'Alex', 2, 4, 'Stefan cel Mare nr.56', 'Chisinau', 'M', '5/20/2002',  3500),
	(3,'Bolsoi', 'Valentina', 1, 3, 'Gheorghe Urschi nr.2',  'Chisinau', 'F', '5/4/2002', 2900),
	(4,'Balan', 'Ionut', 2, 4, 'Ulqiora Sifer nr.69', 'Briceni', 'M', '12/13/2002', 4000),
	(5,'Crozu',  'Stas', 1,	5, 'Alecu Ruso nr.7', 'Chisinau', 'M', '1/2/2002', 3500),
	(6,'Bulhac', 'Maxim', 2, 2, 'Mihai Eminescu nr.34', 'Chisinau', 'M', '7/9/2002', 3500)

Go



INSERT INTO Proiecte( Proiect_ID, Nume_Proiect, Buget, Termen_limita) VALUES
	(1,'Constructie_Casa_1', 32000,'1/1/2021'),
	(2,'Restabilire_Sufragerie_1', 23000, '03/04/2022'),
	(3,'Creare_Design', 10000, '6/27/2020')

Go

INSERT INTO Angajati_Proiecte(Angat_Proiect, Angajati_ID, Proiecte_ID, NrOreSaptamana)VALUES 
	(1, 1, 1, 90),
	(2, 2, 2, 100),
	(3, 3, 3, 45),
	(4, 4, 1, 30),
	(5, 5, 2, 80),
	(6, 6, 3, 98)

GO

	


/*
-- Afiseaza toti angajatii care apartin unui Departament anumit
SELECT Nume, Prenume, Departament_ID FROM Angajati
WHERE (Departament_ID = 1)


-- Selecteaza Angajati care au mai de 40 de ore, si se afiseaza crescator dupa numarul de ore
SELECT Angajati.Nume, Angajati.Prenume, Angajati_Proiecte.NrOreSaptamana 
FROM Angajati 
LEFT JOIN Angajati_Proiecte On Angajati_Proiecte.Angajati_ID = Angajati.Angajat_ID
WHERE (NrOreSaptamana > 40)
ORDER BY Angajati_Proiecte.NrOreSaptamana ASC
*/


-- Litere si cifre random
--SELECT char((rand()*25 + 65))
--	 + char((rand()*25 + 65)) 
--	 + char((rand()*25 + 65)) 


--SELECT FLOOR(RAND()*(99+10)-10);
--GO


-- grant all permissions mssql
alter authorization on database :: Companie to SA


-- Create an user Alex for Login Alex on current database
IF NOT EXISTS (SELECT [name]
     FROM [sys].[database_principals]
     WHERE [type] = N'S' AND [name] = N'Alex'
	 )
BEGIN
     CREATE USER Alex
     FOR LOGIN Alex WITH DEFAULT_SCHEMA = [TestSchema]
END
ALTER ROLE [db_ddladmin] ADD MEMBER Alex
GO


-- Create a schema on authorization by Alex and grant select, update and insert
CREATE SCHEMA TestSchema AUTHORIZATION [Alex]
    GRANT SELECT, UPDATE, INSERT 
	ON SCHEMA::TestSchema TO Alex 
GO   

-- Grant select, update and insert on table Angajati to user Alex
GRANT SELECT, UPDATE, INSERT 
ON dbo.Angajati
TO Alex
WITH GRANT OPTION
GO

-- Grant update on fields Nume and Prenume on table Angajati to user Alex
GRANT UPDATE(Nume, Prenume) ON dbo.Angajati TO Alex
GO

-- Revoke update on table Angajati to user Alex on cascade
REVOKE UPDATE ON dbo.Angajati FROM Alex CASCADE;
GO



--SELECT * FROM sys.databases

