--CREAREA BAZEI DE DATE
USE master
GO
IF exists(
	SELECT *FROM sys.databases WHERE name='Asus_Company')
BEGIN
		ALTER DATABASE Asus_Company SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE Asus_Company
		END
GO
CREATE DATABASE Asus_Company
GO
USE Asus_Company
GO



CREATE TABLE Laptops(
	Id_Laptop INT PRIMARY KEY,
	model NVARCHAR(20),
	price INT,
	screen_size NVARCHAR(20),
	resolution	NVARCHAR(20),
	cpu NVARCHAR(20),
	ram INT,
	storage INT,
)

CREATE TABLE Monitors(
	Id_Laptop INT,
	model NVARCHAR(20),
	price INT,
	screen_size NVARCHAR(20),
	resolution NVARCHAR(20)
)

CREATE TABLE Desktops(
	Id_Laptop INT,
	model NVARCHAR(20),
	price INT,
	cpu NVARCHAR(20),
	ram INT,
	storage NVARCHAR(20),
	Id_monitor INT
)

CREATE TABLE Networks(
	Id_Laptop INT
)


INSERT INTO Laptops VALUES 
	(1, '', 3000, '', '', 'i7', '4', 500),
	(2, '', 3000, '', '', 'i7', '4', 500),
	(3, '', 3000, '', '', 'i7', '4', 500),
	(4, '', 3000, '', '', 'i7', '4', 500),
	(5, '', 3000, '', '', 'i7', '4', 500)

INSERT INTO Monitors VALUES
	(1, '', 200, '', ''),
	(2, '', 200, '', ''),
	(3, '', 200, '', ''),
	(4, '', 200, '', ''),
	(5, '', 200, '', '')

INSERT INTO Desktops VALUES
	(1, '', 3000, '', 4, 'i7', 2),
	(2, '', 3000, '', 3, 'i7', 3),
	(3, '', 3000, '', 3, 'i7', 1),
	(4, '', 3000, '', 3, 'i7', 1),
	(5, '', 3000, '', 2, 'i7', 5)









/*

Pentru a avea o relatie in 1NF, trebuie efectuate urmatoarele operat¸ii:
	-Eliminarea grupurilor repetitive din fiecare relatie.
	-Identificarea tuplelor ce ar putea avea duplicate ın coloana
	printr-o cheie.
	-Crearea unei noi scheme de relat¸ie avand ca atribute:
	identificatorul de la punctul precedent, si valoarea repetata ca
	atribut atomic.


*/