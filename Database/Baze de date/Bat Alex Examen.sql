----------------------------------------------------------------------------------------
--
--	  Bat Alex 
--	  B-1832
--    Biletul Nr 25
--
----------------------------------------------------------------------------------------


--CREAREA BAZEI DE DATE
USE master
GO
IF exists(
	SELECT * FROM sys.databases WHERE name='Centru_Creatie')
BEGIN
		ALTER DATABASE Centru_Creatie SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE Centru_Creatie
		END
GO
CREATE DATABASE Centru_Creatie
GO

USE Centru_Creatie
GO


/* Crearea Tabelelor */
CREATE TABLE Grupe(
	Id_Grupa INT PRIMARY KEY,
	Denumire NVARCHAR(20), 
)
GO

CREATE TABLE Antrenori(
	Id_Antrenor INT PRIMARY KEY,
	Nume NVARCHAR(20), 
	Prenume NVARCHAR(20),
	Varsta NVARCHAR(20)
)
GO

CREATE TABLE Activitati(
	Id_Activitate INT PRIMARY KEY,
	Denumire NVARCHAR(20), 
)
GO

CREATE TABLE Activitati_Desfasurate(
	Id_Activitate_Desfasurata INT IDENTITY(1,1) PRIMARY KEY,  -- Pune Id-ul automat
	Id_Antrenor INT FOREIGN KEY REFERENCES Antrenori(Id_Antrenor),
	Id_Activitate INT FOREIGN KEY REFERENCES Antrenori(Id_Antrenor),
	Id_Grupa INT FOREIGN KEY REFERENCES Grupe(Id_Grupa),
	Data_Activitatii DATE
)

CREATE TABLE Copii(
	Id_Copil INT PRIMARY KEY,
	Nume NVARCHAR(20), 
	Prenume NVARCHAR(20), 
	Varsta INT,
	Id_Grupa INT FOREIGN KEY REFERENCES Grupe(Id_Grupa)
)
GO

/* Inserarea in tabele */
INSERT INTO Grupe VALUES
	(1, 'Grupa-1'),
	(2, 'Grupa-2'),
	(3, 'Grupa-3')

INSERT INTO Copii VALUES
	(1, 'Druta', 'Alexandra', 5, 1),
	(2, 'Moara', 'Liviu', 6, 1),
	(3, 'Nastase', 'Grigorie', 6, 2),
	(4, 'Calin', 'Mihai', 5, 3),
	(5, 'Slovac', 'Paul', 6, 3)

INSERT INTO Antrenori VALUES
	(1, 'Cioara', 'Ana', 22),
	(2, 'Umbra', 'Vadim', 31),
	(3, 'Cioban', 'Irina', 40),
	(4, 'Polonic', 'Vasile', 35),
	(5, 'Popescu', 'Maria', 28)

INSERT INTO Activitati VALUES
	(1, 'Ora de Dansuri'),
	(2, 'Ora de Jocuri'),
	(3, 'Ora de Pictare'),
	(4, 'Ora de Engleza')

/* 
	Permite ca mai multi Antrenori sa desfasoare mai multe activitati la mai multe grupe odata
*/
INSERT INTO Activitati_Desfasurate(Id_Antrenor, Id_Activitate, Id_Grupa, Data_Activitatii) VALUES
	(1, 1, 1, '2020.12.17'),	
	(1, 1, 2, '2020.12.17'),	-- Antenor 1, Activitatea 1, Grupa 1 si 2
	(2, 2, 3, '2020.12.18'),	  
	(3, 2, 3, '2020.12.18'),	-- Antrenor 2 si 3, Activitatea 2, Grupa 3   
	(4, 3, 1, '2020.12.19'),	-- Antrenor 4, Activitatea 3, Grupa 1
	(5, 2, 2, '2020.12.19')  	-- Antrenor 5, Activitatea 4, Grupa 2
GO
	
/* Nu numara randurile inserate */
SET NOCOUNT ON;
GO

/* Vedere care afiseaza tot din Activitati_Desfasurate */
CREATE VIEW	v1 
AS
	SELECT 
		Activitati.Denumire, 
		Antrenori.Nume, 
		Antrenori.Prenume, 
		Grupe.Id_Grupa, 
		Data_Activitatii 
		FROM Activitati_Desfasurate
	INNER JOIN Antrenori ON Antrenori.Id_Antrenor = Activitati_Desfasurate.Id_Antrenor
	INNER JOIN Grupe ON Grupe.Id_Grupa = Activitati_Desfasurate.Id_Grupa
	INNER JOIN Activitati ON Activitati.Id_Activitate = Activitati_Desfasurate.Id_Activitate
GO


--SELECT * FROM v1
GO

/* Tranzacție care exclude toate activitățile desfășurate la o anumită dată */
BEGIN TRANSACTION Stergere_Dupa_Data;

	DECLARE @Data nvarchar(20)
	SET @Data = '2020.12.18' -- Lucreaza
	--SET @Data = '2020.18.28' -- Eroare

	/* Daca exista sterge, in caz contrar va afisa o eroare */
	IF EXISTS(SELECT * FROM Activitati_Desfasurate WHERE Data_Activitatii = @Data)
		BEGIN
			DELETE FROM Activitati_Desfasurate 
				WHERE Data_Activitatii = @Data
		END
	ELSE
		RAISERROR('Nu exista eveniment la asa data', 16, 1)

COMMIT;  
GO


--SELECT * FROM v1
GO