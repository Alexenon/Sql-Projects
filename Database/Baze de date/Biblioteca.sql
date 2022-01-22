USE master
GO
IF exists(
	SELECT * FROM sys.databases WHERE name='Biblioteca')
BEGIN
		ALTER DATABASE Biblioteca SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE Biblioteca
		END
GO
CREATE DATABASE Biblioteca
GO
USE Biblioteca
GO


CREATE TABLE Carti(
	Id_Carte INT IDENTITY(1,1) PRIMARY KEY,
	Denumire_Carte VARCHAR(MAX),
	Nume_Autor VARCHAR(MAX),
	Pret_Carte INT,
	Data_Editare DATE
)
GO

CREATE TABLE Cititori(
	Id_Cititor INT IDENTITY(1,1) PRIMARY KEY,
	Nume_Cititor VARCHAR(MAX),
	Id_Carte INT,
	Data_Chirie DATE
)
GO


BEGIN TRAN AdaugareTabele
	INSERT INTO Carti VALUES 
		('Istorie si adevar', 'Mihail Drumes', 150, '2002.12.12'),
		('Scufita Rosie', 'Ion Creanga', 200, '2017.04.01'),
		('Dragostea', 'Gabriela Garcia', 100, '2015.07.10'),
		('Undeva in istorie', 'Mircea Eliade', 80, '2010.09.15'),
		('Enigma Otiliei', 'Gheorge Calinescu', 220, '2000.08.20')
	INSERT INTO Cititori VALUES
		('Bat Alex', 1, '2018.04.01'),
		('Stici Vlad', 4, '2018.04.10'),
		('Crozu Stas', 2, '2018.05.21'),
		('Lungu Petru', 3, '2018.06.11'),
		('Balan Ion', 1, '2018.06.30'),
		('Bolsoi Valentina', 1, '2018.07.01'),
		('Apostol Andrei', 5, '2018.08.16'),
		('Corovai Vasile', 4, '2018.09.27'),
		('Satbei Ion', 3, '2018.12.31'),
		('Ursu Adrian', 2, '2019.01.05'),
		('Leu Maxim', 2, '2019.02.20')
COMMIT
GO


CREATE VIEW Diapazon AS
	SELECT * FROM Cititori
	WHERE Data_Chirie BETWEEN '2018.05.21' AND '2018.12.31'
GO


CREATE VIEW Vedere AS
	SELECT Cititori.Nume_Cititor, Carti.Denumire_Carte FROM Cititori
	INNER JOIN Carti
	ON (Carti.Id_Carte = Cititori.Id_Carte)
	WHERE Carti.Denumire_Carte LIKE '%istorie%'
GO


BEGIN TRAN 
	SELECT Carti.Denumire_Carte, COUNT(Cititori.Id_Carte) AS [NumarCititori] FROM Cititori
	INNER JOIN Carti
	ON (Carti.Id_Carte = Cititori.Id_Carte)
	GROUP BY Denumire_Carte
	ORDER BY [NumarCititori]
	COMMIT TRAN
GO


BEGIN TRAN
	SELECT Nume_Cititor, COUNT(Id_Carte) FROM Cititori
	GROUP BY Nume_Cititor
COMMIT TRAN
GO


















