USE [master]
GO
IF EXISTS (SELECT *FROM sys.databases WHERE name='Companie')
	BEGIN
	alter database Companie set single_user
	with rollback immediate
	drop database Companie
	END
GO

CREATE DATABASE Companie
GO
USE Companie
GO


CREATE OR ALTER FUNCTION PretTotal(
	@Procentaj AS FLOAT,
	@Pret AS FLOAT
)
RETURNS FLOAT
AS
BEGIN
	RETURN @Pret + @Pret / 100 * @Procentaj
END
GO

CREATE TABLE Useri(
	Id_User INT IDENTITY(1,1) PRIMARY KEY,
	Nume nvarchar(30) NOT NULL,
	Email nvarchar(30) NOT NULL,
	Parola nvarchar(30) NOT NULL
)

CREATE TABLE deletedUseri(
	Id_User INT,
	Nume nvarchar(30) NOT NULL,
	Email nvarchar(30) NOT NULL,
	Parola nvarchar(30) NOT NULL
)
GO

CREATE TABLE Agenti(
	Id_Agent INT IDENTITY(1,1) PRIMARY KEY,
	Nume nvarchar(30) NOT NULL,
	Prenume nvarchar(30) NOT NULL,
	Salariu int NOT NULL,
	Varsta int,
	Staj int,
	Procent float NOT NULL,
	)

CREATE TABLE Produse(
	Id_Produs INT PRIMARY KEY,
	Denumire nvarchar(30) NOT NULL,
	Pret float NOT NULL
	)

CREATE TABLE Agenti_Produse(
	Id_Agent_Produs INT IDENTITY(1,1) PRIMARY KEY,
	Id_Agent int FOREIGN KEY REFERENCES Agenti(Id_Agent) NOT NULL,
	Id_Produs int FOREIGN KEY REFERENCES Produse(Id_Produs) NOT NULL,
	inStoc BIT DEFAULT 0 NOT NULL,
	PretTotal decimal(10, 2) NOT NULL
	)

INSERT INTO Agenti VALUES 
	('Covrig', 'Petru', 5600, 19, 2, 2.2),
	('Crozu', 'Stas', 8400, 23, 1, 1.2),
	('Zgardan', 'Razvan', 5600, 19, 0, 3.4),
	('Balan', 'Elena', 11000, 33, 6, 6.7),
	('Kalasnikov', 'Andrei', 25600, 63, 11, 3.3),
	('Paunescu', 'Alexei', 18000, 62, 15, 4.8)


INSERT INTO Produse VALUES
	(1, 'Suruburi', 10.70),
	(2, 'Cuie', 11.20),
	(3, 'Sfori', 23.99),
	(4, 'Gresie', 49.59),
	(5, 'Faianta', 69.99)
GO

/* Useri */
INSERT INTO Useri VALUES
	('Nume1', 'Email', 'Parola'),
	('Nume2', 'Email', 'Parola'),
	('Nume3', 'Email', 'Parola'),
	('Nume4', 'Email', 'Parola'),
	('Nume5', 'Email', 'Parola'),
	('Nume6', 'Email', 'Parola'),
	('s', 's', 's')

/* Vanzarile primului Agent */
INSERT INTO Agenti_Produse VALUES
	(1, 1, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 1), (SELECT Pret FROM Produse WHERE Id_Produs = 1))),
	(1, 2, 0, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 1), (SELECT Pret FROM Produse WHERE Id_Produs = 2))),
	(1, 3, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 1), (SELECT Pret FROM Produse WHERE Id_Produs = 3))),
	(1, 4, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 1), (SELECT Pret FROM Produse WHERE Id_Produs = 4))),
	(1, 5, 0, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 1), (SELECT Pret FROM Produse WHERE Id_Produs = 5)))

/* Vanzarile la a doilea Agent */
INSERT INTO Agenti_Produse VALUES
	(2, 1, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 2), (SELECT Pret FROM Produse WHERE Id_Produs = 1))),
	(2, 2, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 2), (SELECT Pret FROM Produse WHERE Id_Produs = 2))),
	(2, 3, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 2), (SELECT Pret FROM Produse WHERE Id_Produs = 3))),
	(2, 4, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 2), (SELECT Pret FROM Produse WHERE Id_Produs = 4))),
	(2, 5, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 2), (SELECT Pret FROM Produse WHERE Id_Produs = 5)))

/* Vanzarile la a treilea Agent */
INSERT INTO Agenti_Produse VALUES
	(3, 1, 0, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 3), (SELECT Pret FROM Produse WHERE Id_Produs = 1))),
	(3, 2, 0, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 3), (SELECT Pret FROM Produse WHERE Id_Produs = 2))),
	(3, 3, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 3), (SELECT Pret FROM Produse WHERE Id_Produs = 3))),
	(3, 4, 0, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 3), (SELECT Pret FROM Produse WHERE Id_Produs = 4))),
	(3, 5, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 3), (SELECT Pret FROM Produse WHERE Id_Produs = 5)))

/* Vanzarile la a patrulea Agent */
INSERT INTO Agenti_Produse VALUES
	(4, 1, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 4), (SELECT Pret FROM Produse WHERE Id_Produs = 1))),
	(4, 2, 0, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 4), (SELECT Pret FROM Produse WHERE Id_Produs = 2))),
	(4, 3, 0, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 4), (SELECT Pret FROM Produse WHERE Id_Produs = 3))),
	(4, 4, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 4), (SELECT Pret FROM Produse WHERE Id_Produs = 4))),
	(4, 5, 1, dbo.PretTotal((SELECT Procent FROM Agenti WHERE Id_Agent = 4), (SELECT Pret FROM Produse WHERE Id_Produs = 5)))
GO



----------------------------------------------------------------SELECT---------------------------------------------------------------


/* Vedere despre oferte */
CREATE VIEW Oferte AS
	SELECT P.Denumire, P.Pret, A.Nume, A.Prenume, A.Procent, AP.PretTotal AS 'PretTotal', AP.inStoc FROM Agenti_Produse AP
	INNER JOIN Produse P ON P.Id_Produs = AP.Id_Produs
	INNER JOIN Agenti A ON A.Id_Agent = AP.Id_Agent
	--ORDER BY P.Denumire, AP.PretTotal
GO

/* Vizualizarea ofertelor */
--SELECT * FROM Oferte 
--ORDER BY Denumire, PretTotal
--GO


--USE Companie
--GO

CREATE OR ALTER TRIGGER AfterDELETETrigger ON Useri
AFTER DELETE AS 
DECLARE @UserID INT,
       @UserNume VARCHAR(50),
	   @UserEmail VARCHAR(50),
	   @UserParola VARCHAR(50)
	
	SELECT @UserID = del.Id_User FROM DELETED del;
	SELECT @UserNume  = del.Nume FROM DELETED del;
	SELECT @UserEmail = del.Email FROM DELETED del;
	SELECT @UserParola = del.Parola FROM DELETED del;

	IF(@UserNume <> NULL)
	BEGIN
		INSERT INTO deletedUseri VALUES (@UserID, @UserNume, @UserEmail, @UserParola);
	END
	PRINT ('Userul cu ID-ul = ' + CAST(@USERID as varchar(10)) + ' a fost sters!');
GO


CREATE OR ALTER PROCEDURE StergereUser
    @idUser int 
AS
	INSERT INTO deletedUseri SELECT * FROM Useri WHERE Id_User = @idUser;
    DELETE FROM Useri WHERE Id_User = @idUser;
RETURN 0 
GO

--EXEC StergereUser 1
--SELECT * FROM deletedUseri
--GO



CREATE VIEW SalariuMediu 
AS
SELECT AVG(Salariu) AS 'Salariu_Mediu' FROM Agenti
GO

/* Info despre Agent */
CREATE PROCEDURE InfoAgent 
	@numeAgent nvarchar(max) = NULL
AS
	SELECT * FROM Agenti 
	WHERE Prenume = @numeAgent
GO

--EXEC InfoAgent Stas
GO

/* Pretul mediu al unui produs */
CREATE PROCEDURE pretMediuProdus 
	@denumireProdus nvarchar(max) = NULL
AS
	SELECT CAST(AVG(PretTotal) AS DECIMAL(10,2)) AS 'Pret_Mediu' FROM Agenti_Produse AP
	WHERE AP.Id_Produs = (SELECT Id_Produs FROM Produse WHERE Denumire = @denumireProdus)
GO

--EXEC pretMediuProdus 'Cuie'
GO





                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          