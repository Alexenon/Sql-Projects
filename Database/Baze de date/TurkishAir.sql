/*
View the Database Scheme here: https://s3-us-west-2.amazonaws.com/cbunkstatic/Schema.png
*/

--CREAREA BAZEI DE DATE
USE master

SET DATEFORMAT dmy
SET NOCOUNT OFF

GO
IF exists(
	SELECT *FROM sys.databases WHERE name='TurkishAir')
BEGIN
		ALTER DATABASE TurkishAir SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE TurkishAir
		END
GO
CREATE DATABASE TurkishAir
GO
USE TurkishAir

--CREAREA TABELELOR

CREATE TABLE Classes(
	Id_Class INT PRIMARY KEY,
	class_type NVARCHAR(10)
)
GO

CREATE TABLE Baggages(
	Id_Baggage INT PRIMARY KEY,
	bag_type NVARCHAR(20),			
)
GO

CREATE TABLE Countries(
	Id_Country NVARCHAR(3) PRIMARY KEY CHECK (LEN(Id_Country) = 2),   
	country_name NVARCHAR(20) NOT NULL
)

CREATE TABLE Cities(
	Id_City INT PRIMARY KEY,
	city_name NVARCHAR(30),
	Id_Country NVARCHAR(3) FOREIGN KEY REFERENCES Countries(Id_Country)
)
GO

CREATE TABLE Planes(
	Id_Plane INT PRIMARY KEY NOT NULL,
	plane_name NVARCHAR(20) UNIQUE NOT NULL,
	model NVARCHAR(20) NOT NULL,
	capacity INT NOT NULL CHECK(capacity > 80 AND capacity < 200),
	is_working BIT NOT NULL,
	is_available BIT NOT NULL		
)
GO

CREATE TABLE Pilots(
	Id_Pilot INT PRIMARY KEY NOT NULL,
	first_name NVARCHAR(20) NOT NULL,
	last_name NVARCHAR(20) NOT NULL,
	age INT CHECK(age > 18 AND age < 50),
	sallary INT
) 
GO

CREATE TABLE Stewardess(
	Id_Stewardess INT PRIMARY KEY,
	first_name NVARCHAR(20) NOT NULL,
	last_name NVARCHAR(20) NOT NULL,		
	age INT CHECK(age > 18 AND age < 50),							
	sallary INT
)
GO

CREATE TABLE Flights(
	Id_Flight INT PRIMARY KEY,				-- GETDATE() + Id_Plane + Id_City
	flight_name NVARCHAR(40) NOT NULL,
	city_a INT FOREIGN KEY REFERENCES Cities(Id_City) NOT NULL,
	city_b INT FOREIGN KEY REFERENCES Cities(Id_City) NOT NULL,
	start_flight DATETIME NOT NULL,
	end_flight DATETIME NOT NULL,
	Id_Plane INT FOREIGN KEY REFERENCES Planes(Id_Plane) 
    /* UNIQUE */
)
GO

CREATE TABLE Pilots_Flights(
	Id_Flight INT FOREIGN KEY REFERENCES Flights(Id_Flight),
	Id_Pilot INT FOREIGN KEY REFERENCES Pilots(Id_Pilot)
)

GO

CREATE TABLE Stewardess_Flights(
	Id_Flight INT FOREIGN KEY REFERENCES Flights(Id_Flight),
	Id_Stewardess INT FOREIGN KEY REFERENCES Stewardess(Id_Stewardess)
)

GO

CREATE TABLE Passengers(
	Id_Passenger INT PRIMARY KEY,
	first_name NVARCHAR(20),
	last_name NVARCHAR(20),
	phone NVARCHAR(20),
	email NVARCHAR(20),	

	CONSTRAINT MG CHECK(
		CHARINDEX('@', email) > 1 AND 
		LEN(email) > 6 AND 
		LEN(phone) > 6
		)
)
GO

CREATE TABLE Info_Passengers(
	Id INT PRIMARY KEY,
	Categorie NVARCHAR(20),
)
GO

CREATE TABLE Travel_Type(
	travel_type INT PRIMARY KEY,
	travel_name NVARCHAR(20)
)
GO

CREATE TABLE Tickets(
	Id_Ticket INT PRIMARY KEY,
	Id_Passenger INT FOREIGN KEY REFERENCES Passengers(Id_Passenger),
    Id_Class INT FOREIGN KEY REFERENCES Classes(Id_Class),
    Id_Info INT FOREIGN KEY REFERENCES Info_Passengers(Id),
    Id_Bagaj_Type INT FOREIGN KEY REFERENCES Baggages(Id_Baggage),
    travel_type INT FOREIGN KEY REFERENCES Travel_Type(travel_type),
	price INT,
	Id_Flight INT FOREIGN KEY REFERENCES Flights(Id_Flight)
)

GO

CREATE TRIGGER countries_validate ON Countries AFTER INSERT, UPDATE AS
	BEGIN
		UPDATE Countries
		SET Id_Country = UPPER(Id_Country) 
	END
GO


--Calculeaza suma biletului
--Suma depinde de: clasa, tipul bagajului, tipul calatoriei
CREATE TRIGGER price_calc ON Tickets AFTER INSERT AS
	BEGIN
	DECLARE @Id_Ticket int, @Id_Passenger int, @Id_Class int, @Id_Info int, 
			@Id_Bagaj_Type int, @travel_type int, @price int, @Id_Flight int

		DECLARE cursor_price CURSOR FOR SELECT * from Tickets

		OPEN cursor_price
					FETCH NEXT FROM cursor_price INTO @Id_Ticket, @Id_Passenger, @Id_Class, 
											@Id_Info, @Id_Bagaj_Type, @travel_type, 
											@price, @Id_Flight
		WHILE @@FETCH_STATUS = 0
		BEGIN
			
			DECLARE @coef float = 0

			--Clasa
			--Econom
			IF @Id_Class = 1 SET @coef = 1
			--Bussiness
			ELSE IF @Id_Class = 2 SET @coef = 1.5


			--Tipul bagajului
			--mic
			IF @Id_Bagaj_Type = 1 SET @coef = @coef * 1

			--mediu
			ELSE IF @Id_Bagaj_Type = 2 SET @coef = @coef * 1.2

			--mare
			ELSE IF @Id_Bagaj_Type = 3 SET @coef = @coef * 1.3

			--animal
			ELSE IF @Id_Bagaj_Type = 4 SET @coef = @coef * 1.5


			--Tipul calatoriei
			--Dus-intors
			If @travel_type = 1 SET @coef = @coef * 1.9

			--Singura directie
			ELSE IF @travel_type = 2 SET @coef = @coef * 1

			--Multisegment
			ELSE IF @travel_type = 3 SET @coef = @coef * 2

			UPDATE Tickets
			SET price = @price * @coef
			WHERE Id_Ticket = @Id_Ticket

			FETCH NEXT FROM cursor_price INTO @Id_Ticket, @Id_Passenger, @Id_Class, 
											@Id_Info, @Id_Bagaj_Type, @travel_type, 
											@price, @Id_Flight
		END
		
		CLOSE cursor_price
		DEALLOCATE cursor_price
	END
GO

INSERT INTO Classes VALUES
    (1, 'Econom'),
    (2, 'Bussiness'),
    (3, 'First')
    

INSERT INTO Baggages VALUES
    (1, 'mic'),
    (2, 'mediu'),
    (3, 'mare'),
    (4, 'animal')

INSERT INTO Countries VALUES
    ('MD', 'Moldova'),
    ('RO', 'Romania'),
    ('RU', 'Russia')
    
INSERT INTO Cities VALUES
    (1, 'Chisinau', 'MD'),
    (2, 'Bucuresti', 'RO'),
    (3, 'Moscova', 'RU')
    
INSERT INTO Planes VALUES 
    (1, 'Boeing T900', 'Boeing', 150, 1, 1),
    (2, 'Airbus H94', 'Airbus', 180, 1, 1)
    
    
INSERT INTO Stewardess VALUES
    (1, 'Kenedy', 'Mark', 30, 4000),
    (2, 'Green', 'Anna', 28, 4000),
    (3, 'Black', 'Angela', 22, 4000),
    (4, 'Brown', 'Marcela', 27, 4000)
    

INSERT INTO Pilots VALUES
    (1, 'Skylar', 'Donaldson', 30, 18000),
    (2, 'Jonas', 'Daniel', 31, 16000),
    (3, 'Julian', 'Barton', 30, 8600),
    (4, 'Douglas', 'Henson', 28, 940)


INSERT INTO Flights VALUES
    (1, 'Bucuresti-Moscova', 2, 3, '2020-03-03 10:12:23', '2020-09-03 10:12:23', 1),
    (2, 'Bucuresti-Chisinau', 2, 1, '2020-09-03 10:12:23', '2020-09-03 10:12:23', 2),
    (3, 'Chisinau-Moscova', 1, 3, '2020-09-03 10:12:23', '2020-09-03 10:12:23', 2),
    (4, 'Moscova-Chisinau', 1, 3, '2020-09-03 10:12:23', '2020-09-03 10:12:23', 2)
    
    
INSERT INTO Pilots_Flights VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (3, 4)


INSERT INTO Stewardess_Flights VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (3, 4)
    
INSERT INTO Passengers VALUES
    (1, 'Ceausescu', 'Ion', 079871284, 'Ceausescu@gmail.com'),
    (2, 'Butureanu', 'Mihai', 318491841, 'Butureanu@gmail.com'),
    (3, 'Magdacescu', 'Vasile', 310485774, 'Magdacescu@gmail.com'),
    (4, 'Mmmmmmmm', 'Hhhhhhh', 54485774, 'FDgdacescu@gmail.com')

INSERT INTO Info_Passengers VALUES
	(1,'Infant'),
	(2,'Copil'),
    (3,'Adult')

INSERT INTO Travel_Type(travel_type, travel_name) VALUES
    (1, 'Dus-intors'),
    (2, 'Singura directie'),
    (3, 'Multisegment')
    
INSERT INTO Tickets VALUES
	(1, 1, 2, 3, 1, 2, 800, 1),
	(2, 1, 1, 3, 2, 1, 500, 2),
	(3, 3, 1, 2, 3, 3, 500, 3),
	(4, 4, 2, 3, 4, 2, 500, 4),
	(5, 4, 2, 3, 4, 2, 500, 4)


CREATE INDEX Flights_index
ON Flights(Id_Flight, flight_name, city_a, city_b, Id_Plane)

CREATE INDEX Planes_index
ON Planes(Id_Plane, plane_name, model)

CREATE INDEX Passengers_index
ON Passengers(Id_Passenger)

CREATE INDEX Tickets_Index
ON Tickets(Id_Ticket, Id_Passenger, Id_Class, Id_Info, Id_Bagaj_Type, travel_type, price, Id_Flight)

CREATE INDEX Pilots_Index
ON Pilots(Id_Pilot)

CREATE INDEX Stewardess_Index
ON Stewardess(Id_Stewardess)

CREATE INDEX Baggages_Index
ON Baggages(Id_Baggage)

	
GO


--Numarul de bilete procurate si nr bilete disponibile pentru fiecare zbor
CREATE VIEW locuri_disponibile AS
	SELECT COUNT(t.Id_Ticket) AS tickets, p.capacity - COUNT(t.Id_Ticket) AS available_tickets, t.Id_Flight 
		FROM Tickets t, Flights f, Planes p
		WHERE t.Id_Flight = f.Id_Flight 
			AND f.Id_Plane = p.Id_Plane
		GROUP BY t.Id_Flight, p.capacity
GO


--Metoda care schimba state-ul la avion pentru zborul indicat
CREATE PROCEDURE change_plane_state(@Id_Flight INT, @state bit)
	AS
		UPDATE Planes
		SET is_available = @state
		WHERE Planes.Id_Plane = (SELECT Id_Plane FROM Flights WHERE Id_Flight = @Id_Flight) 
GO
-- EXEC change_plane_state @Id_Flight = 1, @state = 1


CREATE TRIGGER triger1
ON Flights
AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	 UPDATE Planes
       SET is_available = 
       (CASE WHEN GETDATE() BETWEEN
               (SELECT start_flight FROM Flights) AND
               (SELECT end_flight FROM Flights) THEN 1
           ELSE 0
       END)
       WHERE Planes.Id_Plane = (SELECT Id_Plane FROM Flights)
END
GO






--Toate informatiile despre fiecare persoana pentru fiecare zbor
CREATE VIEW passengers_flight AS
	SELECT p.Id_Passenger, CONCAT(p.first_name, ' ', p.last_name) AS Passenger_name, p.phone, 
			f.flight_name, f.city_a, f.city_b, f.start_flight, f.end_flight, 
			t.price,
			c.class_type
	FROM Tickets t, Passengers p, Flights f, Classes c
		WHERE t.Id_Passenger = p.Id_Passenger  
			AND t.Id_Flight = f.Id_Flight
			AND t.Id_Class = c.Id_Class
GO
	
	 




/* Selecteaza toti passagerii care au zboruri azi */
--SELECT p.first_name, p.last_name, F.start_flight, F.end_flight 
--FROM Passengers P, Flights F, Tickets T
--WHERE  T.Id_Passenger = P.Id_Passenger AND
--	   T.Id_Flight = F.Id_Flight AND
--	   F.start_flight = GETDATE();
GO


--Numarul de piloti
--SELECT Id_Flight, COUNT(Id_Pilot) AS 'Nr de piloti' FROM Pilots_Flights 
--GROUP BY Id_Flight

--Numarul de de stewardese
--SELECT Id_Flight, COUNT(Id_Stewardess) AS 'Nr de stewardese' FROM Stewardess_Flights
--GROUP BY Id_Flight
--SELECT i.Categorie, COUNT(t.Id_Info) FROM Tickets t, Info_Passengers i
--WHERE i.Id = t.Id_Info
--GROUP BY i.Categorie
GO



/* Selecteaza toate zborurile care duc spre Moscova */
CREATE VIEW v1 
AS
	SELECT Flights.flight_name, Cities.city_name AS Decolare FROM Flights
	INNER JOIN Cities ON Cities.Id_City = Flights.city_a
	WHERE city_a = 1
GO


CREATE VIEW v2 AS
SELECT Id_Passenger, first_name, last_name, phone FROM Passengers
WHERE Id_Passenger <> 4
GO


CREATE PROCEDURE Modificare_Vedere
AS
	INSERT INTO v2 VALUES 
		(6, 'Butoi', 'Ion', 843243424),
		(7, 'Ana', 'Ion', 843243424),
		(8, 'Portocala', 'Ion', 843243424)

	--DELETE FROM v2 WHERE Id_Passenger = 6

	--SELECT COUNT(Id_Passenger) AS Persoane_Ion FROM v2
	--WHERE last_name = 'Ion' 


	UPDATE v2 SET first_name = 'Mandarina' WHERE first_name = 'Portocala'

	UPDATE v2 SET first_name = 'Mmmmmmmm' WHERE first_name = 'Portocala'   /* Nu lucreaza, tuplul e sters deja */

	--DELETE FROM v2 WHERE first_name = 'Mandarina'

	DELETE FROM v2 WHERE Id_Passenger = 4

	SELECT * FROM v2

	SELECT * FROM Passengers
GO




EXEC Modificare_Vedere


 


