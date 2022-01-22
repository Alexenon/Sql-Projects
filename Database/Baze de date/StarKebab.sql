USE master
GO
IF exists(
	SELECT *FROM sys.databases WHERE name='StarKebab')
BEGIN
		ALTER DATABASE StarKebab SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE StarKebab
		END
GO
CREATE DATABASE StarKebab
GO

USE StarKebab
GO


CREATE TABLE Clienti(
	Id_Client INT PRIMARY KEY,
	Nume NVARCHAR(20), 
	Prenume NVARCHAR(20),
	Adresa NVARCHAR(20)
)

CREATE TABLE Filiale(
	Id_Filiala INT PRIMARY KEY,
	Nume_Filiala NVARCHAR(20),
	Adresa NVARCHAR(30)
)

CREATE TABLE Angajati(
	Id_Angajat INT PRIMARY KEY,
	Nume NVARCHAR(20), 
	Prenume NVARCHAR(20),
	Varsta INT,
	Id_Filiala INT FOREIGN KEY REFERENCES Filiale(Id_Filiala)
)

CREATE TABLE Produse(
	Id_Produs INT PRIMARY KEY,
	Denumire_Produs NVARCHAR(20),
	Pret FLOAT
)

CREATE TABLE Comenzi(
	Id_Comanda INT PRIMARY KEY,
	Id_Client INT FOREIGN KEY REFERENCES Clienti(Id_Client) NOT NULL,
	Id_Produs INT FOREIGN KEY REFERENCES Produse(Id_Produs) NOT NULL
)


INSERT INTO Clienti VALUES 
	(1, 'Cioara', 'Ana', 'sos.Hancesti'),
	(2, 'Umbra', 'Vadim', 'sos.Muncesti'),
	(3, 'Cioban', 'Irina', 'str.Bucuresti'),
	(4, 'Polonic', 'Vadim', 'str.Tighina'),
	(5, 'Buric', 'Lilia', 'str.Hartoapa')

INSERT INTO Filiale VALUES
	(1, 'Filiala Centru', 'str.Bucuresti 20'),
	(2, 'Filiala Nord', 'str. Hancesti 129'),
	(3, 'Filiala Sud', 'str. Mircea Cel Batran 48')

INSERT INTO Angajati VALUES	
	(1, 'Creanga', 'Marin', 35, 1),
	(2, 'Fericitul', 'Andrei', 29, 3),
	(3, 'Pungas', 'Nina', 32, 2)

INSERT INTO Produse VALUES
	(1, 'Kebab Mic', 30),
	(2, 'Kebab Mare', 40),
	(3, 'Coca Cola', 20),
	(4, 'Fanta', 20),
	(5, 'Sprite', 20)

INSERT INTO Comenzi VALUES
	(1, 1, 1), (2, 1, 2),
	(3, 1, 4), (4, 2, 2), 
	(5, 2, 5), (6, 3, 1),
	(7, 3, 1), (8, 3, 5),
	(9, 4, 1), (10, 4, 3),
	(11, 5, 2), (12, 5, 5)
GO






CREATE INDEX Index_dupa_Id
ON Comenzi(Id_Comanda);

CREATE UNIQUE INDEX Index_Clienti
ON Clienti(Nume, Prenume);

CREATE NONCLUSTERED INDEX Index_Angajati
ON Angajati(Prenume);
GO



CREATE VIEW Informatie_Angajati 
AS
	SELECT Nume, Prenume, Varsta, Nume_Filiala, Adresa 
	FROM Angajati
	INNER JOIN Filiale ON Filiale.Id_Filiala = Angajati.Id_Filiala	-- Legatura cu tabelul Filiale prin cheia straina Id_Filiala
GO

--SELECT * FROM Informatie_Angajati 
GO


CREATE SYNONYM Com
FOR Comenzi
GO
--SELECT * FROM Com



--CREATE LOGIN Denis
--WITH PASSWORD = 'Orice_Parola_Doreste_Denis';
GO


CREATE USER Denis
FOR LOGIN Denis WITH DEFAULT_SCHEMA = [TestSchema]

-- Permitem select, update and insert in tabelul Angajati pentru user Denis
GRANT SELECT, UPDATE, INSERT 
ON dbo.Angajati
TO Denis
WITH GRANT OPTION
GO

-- Permitem select, update and insert in tabelul Angajati doar pentru coloanele Nume, Prenume
GRANT UPDATE(Nume, Prenume) ON dbo.Angajati TO Denis
GO

-- Anulam toate drepturile acordate lui Denis
REVOKE UPDATE ON dbo.Angajati FROM Denis CASCADE;
GO





------------------------------------ Lucru Individual Nr 2 ------------------------------------------------------------



CREATE FUNCTION Salut (@nume AS nvarchar(MAX))
RETURNS nvarchar(MAX) AS 
BEGIN
	RETURN 
		'Salut ' + @nume + ' cum iti merg treburile azi?'
END
GO

--SELECT dbo.Salut('Denis')
GO



CREATE FUNCTION Calcul_Procente(
	@valoare AS int,  
	@procent AS float
	)
RETURNS FLOAT
AS
BEGIN
	RETURN 
		@valoare * @procent / 100
END
GO

--SELECT dbo.Calcul_Procente(8, 100) 
GO




CREATE TRIGGER Trigger_Stergere
ON Comenzi FOR DELETE
AS
    BEGIN
		PRINT 'Ai Sters cu succes'
    END
GO

DELETE FROM Comenzi WHERE Id_Comanda = 12
GO




CREATE PROCEDURE Cautare_Dupa_Denumire_Produs( 
	@Comanda NVARCHAR(MAX) 
	)
AS
	SELECT Nume, Prenume, Denumire_Produs FROM Clienti
	INNER JOIN Comenzi ON Clienti.Id_Client = Comenzi.Id_Client		-- Legatura cu tabelul Comenzi
	INNER JOIN Produse ON Produse.Id_Produs = Comenzi.Id_Produs		-- Legatura cu tabelul Produse
	WHERE Denumire_Produs = @Comanda
GO


EXEC Cautare_Dupa_Denumire_Produs 'Kebab Mic';

-- Verificare
--SELECT * FROM Comenzi
--WHERE Id_Produs = 1
