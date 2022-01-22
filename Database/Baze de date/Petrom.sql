--CREAREA BAZEI DE DATE
USE master
GO
IF exists(
	SELECT *FROM sys.databases WHERE name='Petrom')
BEGIN
		ALTER DATABASE Petrom SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE Petrom
		END
GO
CREATE DATABASE Petrom
GO

USE Petrom
GO


CREATE TABLE Carduri(
	Id_Card INT PRIMARY KEY,
	Nume_Card NVARCHAR(20),
	Procent_Reducere FLOAT
)

CREATE TABLE Clienti(
	Id_Client INT PRIMARY KEY,
	Nume NVARCHAR(20), 
	Prenume NVARCHAR(20),
	Varsta INT,
	Id_Card INT FOREIGN KEY REFERENCES Carduri(Id_Card) NOT NULL,
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

CREATE TABLE Servicii(
	Id_Serviciu INT PRIMARY KEY,
	Denumire_Serviciu NVARCHAR(40),
	Pret INT,
	Id_Client INT FOREIGN KEY REFERENCES Clienti(Id_Client) NOT NULL,
	Id_Filiala INT FOREIGN KEY REFERENCES Filiale(Id_Filiala)
)

CREATE TABLE Combustibil(
	Id_Combustibil INT PRIMARY KEY,
	Tipul NVARCHAR(20),
	Pret FLOAT
)

CREATE TABLE Alimentare(
	Id_Alimentare INT PRIMARY KEY,
	Id_Combustibil INT FOREIGN KEY REFERENCES Combustibil(Id_Combustibil),
	Capacitate INT,
	Statia INT CHECK(Statia <= 4),
	Id_Client INT FOREIGN KEY REFERENCES Clienti(Id_Client),
	Id_Angajat INT FOREIGN KEY REFERENCES Angajati(Id_Angajat)
)
GO


INSERT INTO Carduri VALUES
	(1, 'Standart', 0),
	(2, 'Cashback', 7.5),
	(3, 'FinComBank', 5.0),
	(4, 'PrePay', 2.5),
	(5, 'Client-Fidel', 10.0)

INSERT INTO Clienti VALUES 
	(1, 'Cioara', 'Ana', 43, 1),
	(2, 'Umbra', 'Vadim', 28, 4),
	(3, 'Cioban', 'Irina', 31, 3),
	(4, 'Polonic', 'Vasile', 56, 2),
	(5, 'Aux', 'Lilia', 19, 4),
	(6, 'Gologan', 'Stas', 19, 4),
	(7, 'Tutu', 'Dumitru', 19, 4),
	(8, 'Trafan', 'Andrei', 19, 4),
	(9, 'Polonic', 'Ion', 19, 4)

INSERT INTO Filiale VALUES
	(1, 'Filiala Centru', 'str.Bucuresti 20'),
	(2, 'Filiala Nord', 'str. Hancesti 129'),
	(3, 'Filiala Sud', 'str. Mircea Cel Batran 48')

INSERT INTO Angajati VALUES	
	(1, 'Creanga', 'Marin', 35, 1),
	(2, 'Fericitul', 'Andrei', 29, 3),
	(3, 'Pungas', 'Nina', 32, 2)

INSERT INTO Servicii VALUES
	(1, 'Savurarea unei cafele aromate', 25, 1, 1),
	(2, 'Curatarea automobilului', 50, 1, 1),
	(3, 'Achizitionarea vinietelor', 60, 2, 3),
	(4, 'Receptionarea castigurilor loto', 10, 2, NULL),
	(5, 'Navigarea gratuita pe internet', NULL, 3, NULL),
	(6, 'Savurarea unui Sandwich', 20, 3, 1)

INSERT INTO Combustibil VALUES
	(1, 'Benzina 92', 17.99),
	(2, 'Benzina 95', 18.66),
	(3, 'Benzina 95 PREMIUM', 20.00),
	(4, 'Diesel', 16.50),
	(5, 'Gaz', 15.00)

INSERT INTO Alimentare VALUES
	(1, 1, 20, 3, NULL, NULL),
	(2, 5, 10, 1, NULL, 2),
	(3, 3, 50, 1, 1, NULL),
	(4, 4, 16, 2, NULL, 1),
	(5, 3, 13, 4, 2, 3)
GO




CREATE INDEX Primul_Index
ON Servicii(Denumire_Serviciu);

--CREATE UNIQUE INDEX Doilea_Index
--ON Clienti(Nume, Prenume);

CREATE NONCLUSTERED INDEX Patrulea_Index
	ON Angajati(Prenume);

CREATE INDEX Cincelea_Index ON Angajati(Varsta)
  WITH (
		--IGNORE_DUP_KEY = ON,
		PAD_INDEX = ON,
		ONLINE = ON,
		RESUMABLE = ON,
		MAX_DURATION = 10 MINUTES
		);
GO


--EXEC sp_helpindex Clienti     Vizualizarea indecsilor



------------------------------------------------------------
--  Selectarea tuturor clientilor care au comis un serviciu 
------------------------------------------------------------
--SELECT C.Nume, C.Prenume, S.Denumire_Serviciu, S.Pret FROM Clienti C
--INNER JOIN Servicii S ON C.Id_Client = S.Id_Client
--INNER JOIN Carduri ON Carduri.Id_Card = C.Id_Card


--------------------------------------------------
--	Selectarea sumei totale a tuturor serviciilor 
--------------------------------------------------
--SELECT SUM(Pret) AS Suma FROM Servicii
GO



-------------------------------------------------------
--	Crearea unei functii scalare pentru calcul procente

--	SELECT dbo.function_name (fara [dbo] nu doreste)
-------------------------------------------------------
CREATE FUNCTION Calcul_Procente(
	@value AS int,  
	@procent AS float
	)
RETURNS FLOAT
AS
BEGIN
	RETURN 
		@value - (@value * @procent / 100)
END
GO



 

----------------------------------------------------------------
--  Selectarea pretului, a reducerii si a pretului dupa reducere 
----------------------------------------------------------------
CREATE VIEW PretCuReducere AS
	SELECT 
		/*  Concatinarea Pretului + 'LEI' */
		CONCAT(Servicii.Pret, ' Lei') AS Pret, 
		/*  Concatinarea Procentului + '%' */
		CONCAT(Carduri.Procent_Reducere, '%') AS Procente, 
		/* Calcularea pretului final apeland functia Calcul_Procente */
		dbo.Calcul_Procente(Servicii.Pret, Carduri.Procent_Reducere) AS 'Pret Final'  
	FROM Servicii
	INNER JOIN Clienti ON Servicii.Id_Client = Clienti.Id_Client
	INNER JOIN Carduri ON Carduri.Id_Card = Clienti.Id_Card
	WHERE Pret IS NOT NULL
GO



-----------------------------------------
--  Trigger care nu poti sterge din tabel 
-----------------------------------------
CREATE TRIGGER Trigger_name
ON Servicii 
INSTEAD OF DELETE
AS
	PRINT 'Nu se poate de sters'
GO




------------------------------------------------------
-- Functie care delimiteaza cuvintele utilizand spatiu 
------------------------------------------------------
CREATE FUNCTION Delimiter
(
    @string VARCHAR(MAX),
    @delimiter VARCHAR(1)
)
RETURNS @list TABLE(tuple VARCHAR(100))
AS
BEGIN
        WHILE LEN(@string) > 0
        BEGIN
			/* Insereaza in tuplu primele (n-1) litere cautand indexul lor dupa gasirea delimitatorului */
            INSERT INTO @list(tuple)
            SELECT left(@string, charindex(@delimiter, @string+',') -1) as tuple
		
			/* Sterge din string de la 1 pana la delimitator caractere*/
            SET @string = stuff(@string, 1, charindex(@delimiter, @string + @delimiter), '')
        END
    RETURN 
END
GO



SET NOCOUNT ON;


-------------------------------------------------------
-- SQL Dynamic
-------------------------------------------------------
DECLARE
	@table NVARCHAR(MAX),
	@sql NVARCHAR(MAX);

SET @table = 'Angajati';
SET @sql = N'SELECT * FROM ' + QUOTENAME(@table);

--EXEC sp_executesql @sql
GO





---------------------------------------------------
-- Procedura selecteaza TOP N valori dintr-un tabel
---------------------------------------------------
CREATE OR ALTER PROCEDURE sp_query
(
	@table_name NVARCHAR(MAX),
	@size TINYINT,
	@column_name NVARCHAR(MAX)
)
AS
BEGIN
	DECLARE 
		@sql NVARCHAR(MAX),
		@convert NVARCHAR(MAX);

	SET @convert = CAST(@size as nvarchar(max));
		
	SET @sql = N'SELECT TOP ' + @convert
	+ ' * FROM ' + @table_name 
	+ ' ORDER BY ' + @column_name

	EXEC sp_executesql @sql
END
GO

--EXEC sp_query 'Clienti', 4, 'Nume'
GO





CREATE OR ALTER PROCEDURE Adauga
(	
	@NumeTabel nvarchar(max), 
	@nRows int
)
AS	
	DECLARE 
		@Nume nvarchar(max),
		@Prenume nvarchar(max),
		@Counter int,
		@sql nvarchar(max),
		@RowsInTable int
	
	DECLARE @CountResults TABLE (CountReturned INT)
	
	/* Inserez in tabelul dat valoarea de la EXEC(@sql) */
	SET @sql = 'SELECT COUNT(*) FROM ' + @NumeTabel
	INSERT INTO @CountResults EXEC(@sql)
	SET @Counter = (SELECT CountReturned FROM @CountResults) + 1
	SET @RowsInTable = (SELECT CountReturned FROM @CountResults)

	WHILE( @Counter <= @nRows )
	BEGIN
		SET @Nume = CONCAT('''', (SELECT Nume FROM Clienti WHERE Id_Client = FLOOR(RAND()*@RowsInTable+1)), '''')
		SET @Prenume = CONCAT('''', (SELECT Prenume FROM Clienti WHERE Id_Client = FLOOR(RAND()*@RowsInTable+1)), '''')
		
		SET @sql = 'INSERT INTO ' + @NumeTabel + ' VALUES (' 
			+ CAST(@Counter as nvarchar(max))				  -- Id
			+ ',' + @Nume + ',' + @Prenume					  -- Nume, Prenume
			+ ',' + CAST(FLOOR(RAND()*(65-16+1)+16) as nvarchar(max))	-- Random(16, 65) pentru Varsta  
			+ ',' + CAST(FLOOR(RAND()*5+1) as nvarchar(max))	  -- Random(1,5) pentru Numar Card
			+ ')'

		EXEC sp_executesql @sql  
		PRINT @sql
		SET @Counter = @Counter  + 1
	END
GO


/* NumeTabel, nRanduri */
--EXEC Adauga 'Clienti', 100
--SELECT * FROM Clienti


/* Ideas
	- Try NEWID() 
	- Alternative of Array
	- More parameters
	- If / Case
	- Dynamic Sql = Declare @variable table
				
			  Tabel
		/    /    \    \
	Col_1  Col_2  Col_3  Col_4
	    \    \     /    /
			  Insert
*/




GO

CREATE PROCEDURE Adauga_Frumos
(
	@NumeTabel nvarchar(max), 
	@nRows int
)	
AS
	DECLARE @sqlStatement nvarchar(max),
			@Nume_Coloana nvarchar(max),
			@Tipul_de_date nvarchar(max),
			@RowsInTable int,
			@RowCount int = 1;

	DECLARE @Informatie_Coloane TABLE
	(
		Id_Coloana int,
		Nume_Coloana nvarchar(max),
		Tipul_De_Date nvarchar(max)
	)

	/* Inserez in variabila de tip tabel */
	INSERT INTO @Informatie_Coloane
		SELECT ORDINAL_POSITION, COLUMN_NAME, DATA_TYPE
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME = @NumeTabel
	
	SET @RowsInTable = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @NumeTabel)
	SET @SqlStatement = ''

	WHILE @RowCount <= @RowsInTable
		BEGIN
			
			/* Eroare Dublicate Value For Primary Key */
			DECLARE @IdTabel nvarchar(max) = (SELECT Nume_Coloana FROM @Informatie_Coloane WHERE Id_Coloana = 1) 
			SET @Nume_Coloana = (SELECT Nume_Coloana FROM @Informatie_Coloane WHERE Id_Coloana = @RowCount)
			SET @Tipul_de_date = (SELECT Tipul_de_date FROM @Informatie_Coloane WHERE Id_Coloana = @RowCount)

			IF (@Tipul_de_date = 'nvarchar') OR (@Tipul_de_date = 'varchar')
				SET @Tipul_de_date += '(max)'

			SET @SqlStatement += 'DECLARE @' 
				+ @Nume_Coloana + ' ' + @Tipul_de_date
				+ char(10)
			
			SET @RowCount = @RowCount + 1
		END

	/* While Loop */
	SET @SqlStatement += 'SET @' + @IdTabel + ' = (SELECT COUNT(*) FROM ' + @NumeTabel + ') + 1' 
		+ char(10) + 'WHILE @' + @IdTabel + ' <= ' + LTRIM(STR(@nRows)) + char(10)
		+ 'BEGIN ' + char(10)


	SET @RowCount = 2
	WHILE @RowCount <= @RowsInTable
		BEGIN
			SET @Nume_Coloana = (SELECT Nume_Coloana FROM @Informatie_Coloane WHERE Id_Coloana = @RowCount)
			SET @SqlStatement += '   SET @' + @Nume_Coloana
				+ ' = (SELECT ' + @Nume_Coloana
				+ ' FROM ' + @NumeTabel
				+ ' WHERE ' + @IdTabel + ' = ' 
				+ LTRIM(STR(FLOOR(RAND()*(10-5+1)+5)))  -- Taie spatii la string-ul format de random
				+ ')' + char(10)

			SET @RowCount = @RowCount + 1
		END


	/* Insert Into */
	SET @SqlStatement += '   INSERT INTO ' + @NumeTabel + ' VALUES('
	SET @RowCount = 1;
	WHILE @RowCount <= @RowsInTable
		BEGIN

			DECLARE @count2 int = 2;  
			WHILE @count2 < @RowsInTable
				BEGIN
					SET @Nume_Coloana = '@' + (SELECT Nume_Coloana FROM @Informatie_Coloane WHERE Id_Coloana = @RowCount)
					SET @count2 += @count2 +1
				END
			
			IF @RowCount <> @RowsInTable
				SET @SqlStatement += @Nume_Coloana + ','
			ELSE
				SET @SqlStatement += @Nume_Coloana + ')'

			
			SET @RowCount = @RowCount + 1
		END
	
	SET @SqlStatement += char(10) + '   SET @' + @IdTabel + ' = @' + @IdTabel + ' + 1'
	SET @SqlStatement += char(10) + 'END'

	PRINT @SqlStatement
	--SELECT * FROM @Informatie_Coloane
GO


EXEC Adauga_Frumos 'Clienti', 35
	
/*
DECLARE @Id_Client int = (SELECT Id_Client FROM Clienti WHERE Id_Client = 7)
DECLARE @Nume nvarchar(max) = (SELECT Nume FROM Clienti WHERE Id_Client = 8)
DECLARE @Prenume nvarchar(max) = (SELECT Prenume FROM Clienti WHERE Id_Client = 5)
DECLARE @Varsta int = (SELECT Varsta FROM Clienti WHERE Id_Client = 6)
DECLARE @Id_Card int = (SELECT Id_Card FROM Clienti WHERE Id_Client = 4)

INSERT INTO Clienti VALUES (@Id_Client,@Nume,@Prenume,@Varsta,@Id_Card)
PRINT @Id_Client 
PRINT @Nume
PRINT @Prenume
PRINT @Varsta
PRINT @Id_Card
*/



/* 

				+ char(32)
				+ '= (SELECT ' + @Nume_Coloana
				+ ' FROM ' + @NumeTabel
				+ ' WHERE ' + @IdTabel + ' = ' 
				+ LTRIM(STR(FLOOR(RAND()*(10-5+1)+5)))  -- Taie spatii la string-ul format de random
				+ ')' + char(10)
*/



