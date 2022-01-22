USE master
GO
IF exists(
    SELECT * FROM sys.databases WHERE name='Functionari')
BEGIN
        ALTER DATABASE Functionari SET single_user
        WITH ROLLBACK IMMEDIATE
        DROP DATABASE Functionari
        END
GO
    CREATE DATABASE Functionari
GO
    USE Functionari
GO

CREATE TABLE departamente(
            DepId int PRIMARY KEY,
            Denumire nvarchar(45),
            Oras nvarchar(45)
        )
GO

CREATE TABLE functionari_1(
            Nume nvarchar(45),
            Prenume nvarchar(45),
            Post nvarchar(45),
            Salariu float,
            DepId int FOREIGN KEY REFERENCES departamente(DepId)
        )
GO

CREATE TABLE functionari_2(
            Nume nvarchar(45),
            Prenume nvarchar(45),
            Post nvarchar(45),
            Salariu float,
            DepId int FOREIGN KEY REFERENCES departamente(DepId)
        )
GO

INSERT INTO departamente( DepId, Denumire, Oras) VALUES
        (1, 'it', 'London'), 
        (2, 'contabilitate', 'Chisinau'), 
        (3, 'servicii_tehnice', 'Moscow'), 
        (4, 'it', 'Madrid'), 
        (5, 'contabilitate', 'Orhei'), 
        (6, 'servicii_tehnice', 'New York'), 
        (7, 'it', 'Washington'), 
        (8, 'contabilitate', 'Paris')
GO

INSERT INTO functionari_1(Nume, Prenume, Post, Salariu, DepId) VALUES
        ('Stas', 'Crozu', 'Admin Baza de date', 45000, 1),
        ('Dorin', 'Valac', 'Contabil', 50000, 2),
        ('Valeriu', 'Satbei', 'Contabil', 20000, 2),
        ('Misha', 'Cujba', 'Inginer', 45000, 3),
        ('Efros', 'Gheorge', 'Programator', 5000, 4),
        ('Slobozian', 'Anastasia', 'Contabil', 15000, 5),
        ('Daniel', 'Chitic', 'Inginer', 50000, 6),
		('Andrei', 'Balan', 'Inginer', 70000, 6),
        ('Maxim', 'Bulhac', 'Programator', 20000, 7),
        ('Ulian', 'Draguta', 'Contabil', 35000, 8)


INSERT INTO functionari_2(Nume, Prenume, Post, Salariu, DepId) VALUES
        ('Alex', 'Bat', 'Admin Baza de date', 45000, 1),
        ('Vlad', 'Stici', 'Contabil', 50000, 2),
		('Valeriu', 'Satbei', 'Contabil', 20000, 2),
        ('Alexandru', 'Pai', 'Contabil', 20000, 2),
        ('Petru', 'Covrig', 'Inginer', 45000, 3),
        ('Ion', 'George', 'Programator', 5000, 4),
        ('Maria', 'Anastasia', 'Contabil', 15000, 5),
        ('Andrei', 'Balan', 'Inginer', 50000, 6),
        ('Mihail', 'Bubnac', 'Programator', 20000, 7),
        ('Ulian', 'Draguta', 'Contabil', 35000, 8)





--SELECT Nume, Prenume FROM functionari_1
--UNION --ALL
--SELECT Nume, Prenume FROM functionari_2
--ORDER BY Prenume



--SELECT Nume, Prenume FROM functionari_1
--INTERSECT --ALL
--SELECT Nume, Prenume FROM functionari_2
--ORDER BY Prenume


--SELECT Nume, Prenume FROM functionari_1
--EXCEPT -- ALL
--SELECT Nume, Prenume FROM functionari_2
--ORDER BY Prenume



--SELECT Nume, Prenume FROM functionari_1
--WHERE DepId = ( SELECT DepId
--				FROM functionari_1
--				WHERE Nume = 'Stas'
--				AND Prenume = 'Crozu'
--				)


--SELECT Nume, Prenume, Salariu FROM functionari_1
--WHERE Salariu > ( SELECT MAX(Salariu) 
--				FROM functionari_1
--				WHERE Post = 
--					( SELECT Post
--					FROM functionari_1
--					WHERE Nume = 'Andrei'
--					AND Prenume = 'Balan'
--					)
--				)



				



