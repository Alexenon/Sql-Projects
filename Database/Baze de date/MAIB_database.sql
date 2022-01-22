USE [master]
GO
IF EXISTS (SELECT *FROM sys.databases WHERE name='MAIB_database')
	BEGIN
	alter database MAIB_database set single_user
	with rollback immediate
	drop database MAIB_database
	END
GO

CREATE DATABASE MAIB_database
GO
USE MAIB_database
GO

CREATE TABLE Useri(
	Id_User INT IDENTITY(1,1) PRIMARY KEY,
	Nume nvarchar(30) NOT NULL,
	Prenume nvarchar(30) NOT NULL,
	Email nvarchar(30) NOT NULL,
	Varsta int NOT NULL,
	IDNP nvarchar(30) NOT NULL,
	InCont float default 0 NOT NULL
)

CREATE TABLE Servicii(
	Id_Serviciu INT IDENTITY(1,1) PRIMARY KEY,
	Denumire nvarchar(30) NOT NULL,
	Pret float NOT NULL
)
GO

CREATE TABLE Tranzactii(
	Id_Tranzactie INT IDENTITY(1,1) PRIMARY KEY,
	Id_User_Transmite int FOREIGN KEY REFERENCES Useri(Id_User) NOT NULL,
	Id_User_Primeste int FOREIGN KEY REFERENCES Useri(Id_User) NOT NULL,
	Suma int CHECK(Suma>=0) NOT NULL,
	Data_Tranzactie datetime NOT NULL
)


INSERT INTO Useri VALUES ('Bat', 'Alex', 'BatAlex@mail.ru', 10, '2005001020710', DEFAULT)
GO


SELECT * FROM Useri


