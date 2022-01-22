USE [master]
GO
IF EXISTS (SELECT *FROM sys.databases WHERE name='Lombard')
	BEGIN
	alter database Lombard set single_user
	with rollback immediate
	drop database Lombard
	END
	
GO
 
 -- Crearea si manipularea bazei de date;
  
create database Lombard
GO
USE Lombard
GO

  -- Crearea tabelelor in baza de date;

 create table Clienti
  (      Id_Client INT PRIMARY KEY,
         Nume nchar(20),
         Prenume nchar(20),
         IDNP int,
         Adresa nchar(20),
         Nr_Telefon int
        )
GO

 create table Obiecte
  (      Id_Obiect INT PRIMARY KEY,
         Nume_Obiect nchar(20),
         Cost int,
         Comision int,
         Id_Client int FOREIGN KEY references Clienti(Id_Client)
        )  
GO

 create table Contracte
  (      Id_Contract int,
         Id_Obiect int FOREIGN KEY references Obiecte(Id_Obiect),
         Data_Primire date,
         Data_Expirare date
        )
GO

  -- Inserarea datelor in tabele;


 insert into Clienti (Id_Client, Nume, Prenume, IDNP, Adresa, Nr_Telefon) values
  
  (1, 'Belinchi', 'Max', 123919475, 'Frumoasa 78 ', 079148818 ),
  (2, 'Bat', 'Alex', 911827684, 'Sciusev 24', 067148098 ),
  (3, 'Apostol', 'Aliona', 647969120, 'Bernardari 34', 079148832 ),
  (4, 'Chitic', 'Maria', 167808720, 'Kogalniceanu 84', 079248896 ),
  (5, 'Cebotari', 'Tania', 234519475, 'Bucuresti 9', 079242318 ),
  (6, 'Ciobanu', 'Andrei', 938491000, 'Prepelitei 49', 079187818 ),
  (7, 'Batman', 'Tania', 718703582, 'Sahurului 32', 079148048 ),
  (8, 'Hindic', 'Maria', 185164720, 'Codru 102', 079148818 ),
  (9, 'Stici', 'Sergiu', 785694570, 'Olimpia 4', 079148986 ),
  (10, 'Pictor', 'Vasile', 552423744, 'Muncesti 20', 079623518 ),
  (11, 'Ureche', 'Anton', 677076457, 'Hancesti 45', 079540698 ),
  (12, 'Pescaru', 'Alina', 770714743, 'Adreal 24', 079148818 ),
  (13, 'Vanatoru', 'Nastea', 758334424, 'Dealurilor 24', 079148843 ),
  (14, 'Piscina', 'Arina', 924965406, 'Creanga 20', 079148818 ),
  (15, 'Vasilachi', 'Valentina', 555175301, 'Frunza 100', 079145628 ),
  (16, 'Bolsoi', 'Valeria', 748372438, 'Muncesti 34', 069148879 ),
  (17, 'Pescaru', 'Maria', 167118108, 'Frumoasa 2', 069148800 ),
  (18, 'Nasuc', 'Ana', 123919854, 'Bucuresti 41', 079148112 ),
  (19, 'Mortal', 'Nastea', 743919455, 'Voda 34', 069148943 ),
  (20, 'Turksih', 'Grigorie', 846392130, 'Sciusev 124', 079148134 )
GO

 insert into Obiecte(Id_Obiect, Nume_Obiect, Cost, Comision, Id_Client) values
  
  (1, 'Ceas', 2400, 100, 1),
  (2, 'Telefon', 15000, 100, 5),
  (3, 'Laptop', 24500, 100, 4),
  (4, 'Ceas', 560, 100, 2),
  (5, 'Bijuterie', 2000, 100, 6),
  (6, 'Inel', 200, 100, 10),
  (7, 'Inel', 400, 100, 3),
  (8, 'Ceas', 480, 100, 4),
  (9, 'Telefon', 6700, 100, 7),
  (10, 'Bricheta', 200, 100, 9),
  (11, 'Laptop', 106200, 100, 8),
  (12, 'Ceas', 600, 100, 16),
  (13, 'Ipod', 330, 100, 13),
  (14, 'Ceas', 510, 100, 12),
  (15, 'Ipad', 10200, 100, 19),
  (16, 'Ceas', 900, 100, 18),
  (17, 'Bijuterie', 8000, 100, 20),
  (18, 'Bijuterie', 330, 100, 14),
  (19, 'Ipad', 9200, 100, 17),
  (20, 'Telefon', 19999, 100, 11)
GO 

 insert into Contracte(Id_Contract, Id_Obiect, Data_Primire, Data_Expirare) values
 
  (1, 1, '2019.03.10', '2019.03.20'),
  (2, 2, '2019.03.11', '2019.03.21'),
  (3, 3, '2019.03.15', '2019.03.25'),
  (4, 4, '2019.03.17', '2019.03.27'),
  (5, 5, '2019.03.20', '2019.03.30'),
  (6, 6, '2019.03.24', '2019.04.04'),
  (7, 7, '2019.03.27', '2019.04.07'),
  (8, 8, '2019.04.01', '2019.04.10'),
  (9, 9, '2019.04.05', '2019.04.15'),
  (10, 10, '2019.04.07', '2019.04.17'),
  (11, 11, '2019.09.09', '2019.04.19'),
  (12, 12, '2019.04.11', '2019.04.21'),
  (13, 13, '2019.04.14', '2019.04.24'),
  (14, 14, '2019.04.16', '2019.04.26'),
  (15, 15, '2019.04.18', '2019.04.28'),
  (16, 16, '2019.04.20', '2019.04.30'),
  (17, 17, '2019.04.23', '2019.05.03'),
  (18, 18, '2019.04.26', '2019.05.06'),
  (19, 19, '2019.04.27', '2019.05.07'),
  (20, 20, '2019.04.27', '2019.05.07')
GO  
  
  


