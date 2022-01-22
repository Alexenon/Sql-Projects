--CREAREA BAZEI DE DATE
USE master
GO
IF exists(
	SELECT *FROM sys.databases WHERE name='Companie_Asigurari')
BEGIN
		ALTER DATABASE Companie_Asigurari SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE Companie_Asigurari
		END
GO
CREATE DATABASE Companie_Asigurari
GO
USE Companie_Asigurari
GO



--CREAREA TABELELOR
CREATE TABLE Filiale(
			ID_Filiala int PRIMARY KEY,
			Nume nvarchar(20),
			Adresa nvarchar(40),
			Telefon nvarchar(12),
			Email nvarchar(35)   CONSTRAINT MK UNIQUE
			)
GO

CREATE TABLE Agenti_Asigurari(
			IDNP_Agent bigint PRIMARY KEY,
			ID_Filiala int FOREIGN KEY REFERENCES Filiale(ID_Filiala),
			Nume nvarchar(20),
			Prenume nvarchar(20),
			Adresa nvarchar(40)  CONSTRAINT ML DEFAULT 'Chisinau',
			Telefon nvarchar(12),
			Email nvarchar(35)
			)
GO

CREATE TABLE Tip_Asigurari(
			ID_Assig int PRIMARY KEY,
			Nume nvarchar(25),
			Procentaj_Client float,
			Procentaj_Agent float
			)
GO

CREATE TABLE Persoane(
			IDNP_Pers bigint PRIMARY KEY,
			Nume nvarchar(10),
			Prenume nvarchar(10),
			Adresa nvarchar(60),
			Telefon nvarchar(12)
			)
GO

CREATE TABLE Contracte(
			ID_Contract int PRIMARY KEY,
			Data_Contract date,
			IDNP_Pers bigint FOREIGN KEY REFERENCES Persoane(IDNP_Pers),
			Suma_Total int CONSTRAINT CK CHECK(Suma_Total>0),
			ID_Asig int FOREIGN KEY REFERENCES Tip_Asigurari(ID_Assig),
			ID_Filiala int FOREIGN KEY REFERENCES Filiale(ID_Filiala),
			IDNP_Agent bigint FOREIGN KEY REFERENCES Agenti_Asigurari(IDNP_Agent)
			)
GO

CREATE TABLE Useri(
		Id_User int PRIMARY KEY IDENTITY(1,1) NOT NULL,
		Name varchar(50) NOT NULL,
		Email varchar(50) NOT NULL,
		Password varchar(50) NOT NULL
		)
GO

-- Tabel pentru teste adaugatoare
CREATE TABLE TableTest (
	--Auto Increment incepand cu 1, si adaugand 1, si nu necesita sa fie introdus la inserare
    Id_Person int IDENTITY(1,1) PRIMARY KEY,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int
	CONSTRAINT TestConstr CHECK (Age<=100)
	CONSTRAINT TestName UNIQUE	(LastName, FirstName)
	)


-- DEZACTIVEAZA Constrangerea "TestConstr" si STERGE Constrangerea "TestName"
ALTER TABLE TableTest NOCHECK CONSTRAINT TestConstr
ALTER TABLE TableTest DROP CONSTRAINT TestName
--Adauga o coloana cu denumirea "TestColumn" si necesita sa fie introdusa in tabel
ALTER TABLE TableTest ADD TestColumn int



--INSERAREA DATELOR IN TABELE

	INSERT INTO TableTest VALUES
		( 'Zefir', 'Sorin', 119, 555),
		( 'Ashot', 'Valeriu', 35, 666),
		( 'Moara', 'Cristi', 44, 777)
GO

	INSERT INTO Filiale (ID_Filiala, Nume, Adresa, Telefon, Email) VALUES
				(1, 'OFICIUL CENTRAL', 'str. Sfatul Tarii 59', '022-26-10-33', 'klassica_asig@asigurari1.com'),
				(2, 'OT 1 Chisinau', 'bd. Grigore Vieru 9', '022-87-44-70', 'klassica_asig@asigurari2.com'),
				(3, 'OT Balti', 'str. M. Viteazul 34A', '069-472-200','klassica_asig@asigurari3.com'),
				(4, 'PV 1 Balti', 'str. I. Franco 19/A', '069-472-200', 'klassica_asig@asigurari4.com'),
				(5, 'PV Anenii Noi', 'Punctul Vamal „Harbovat-Vama”', '069-144-480', 'klassica_asig@asigurari5.com'),
				(6, 'OT Drochia', 'str. Independentei 6', '069-472-200', 'klassica_asig@asigurari6.com'),
				(7, 'OT Causeni', 'str. Mihai Eminescu 24AF', '0243-21-598', 'klassica_asig@asigurari7.com')
GO

	INSERT INTO Agenti_Asigurari (IDNP_Agent, ID_Filiala, Nume, Prenume, Adresa, Telefon, Email) VALUES  
				(12345678901, 5, 'Crivonos', 'Stas', 'Stefan Voda, Crocmaz', '060742475', 'king_amon@gmail.com'),
				(84637592649, 5, 'Munteanu', 'Mihai', 'Stefan Voda Tudora', '060382945', 'mntmihai@mail.ru'),
				(87654365748, 2, 'Valac', 'Dorin', 'Chisinau, Ciocana str Burebista 199', '060191588', 'dorin__@mail.ru'),
				(87656783845, 1, 'Bat', 'Alex', 'Chisinau, Botanica Sarmigezetuza 23', '060645365', 'alex_xenon@gmail.com'),
				(94828471839, 6, 'Lescinschii', 'Andries', 'Chisinau, Centru str Ismail 26', '078473657', 'lesc_andy284@gmail.com')
GO

	INSERT INTO Tip_Asigurari (ID_Assig, Nume, Procentaj_Client, Procentaj_Agent) VALUES 
				(1, 'RCA', 5.7, 1.1),
				(2, 'Carte Verde', 4.3, 0.3),
				(3, 'Asigurare Medicala', 7.5, 0.7),
				(4, 'Asigurare Casco', 6.4, 1)
GO

	INSERT INTO Persoane (IDNP_Pers, Nume, Prenume, Adresa, Telefon) VALUES 
			 (1, 'Zefir', 'Sorin', 'Falesti', '079159438'),
			 (2, 'Oaie', 'Mircea', 'Falesti', '079575996'),
			 (3, 'Lascu', 'Aid', 'Bucovat', '079562117'),
			 (4, 'Coatu', 'Andrei', 'Bucuresti', '079232995'),
			 (5, 'Druta', 'Alexandra', 'Ungheni', '079845702'),
			 (6, 'Moara', 'Liviu', 'Soroca', '079664676'),
			 (7, 'Varga', 'Bogdana', 'Leuseni', '079841676'),
			 (8, 'Nastase', 'Grigorie', 'Comrat', '079464118'),
			 (9, 'Calin', 'Mihai', 'Bucuresti', '079335441'),
			 (10, 'Magaru', 'Calin', 'Ialoveni', '079624045'),
			 (11, 'Ahot', 'Valeriu', 'Ocnita', '079460070'),
			 (12, 'Coi', 'Bogdana', 'Bucuresti', '079731680'),
			 (13, 'Varga', 'Dumitru', 'Drochia', '079642650'),
			 (14, 'Cernat', 'Alex', 'Aneni', '079408836'),
			 (15, 'Mouse', 'Ioan', 'Comrat', '079587425'),
			 (16, 'Calin', 'Teofil', 'Balti', '079873107'),
			 (17, 'Moara', 'Cristi', 'Crivat', '079389909'),
			 (18, 'Lascu', 'Alexandru', 'Briceni', '079785986'),
			 (19, 'Baraboi', 'Ion', 'Ialoveni', '079484825'),
			 (20, 'Mouse', 'Alina', 'Drochia', '079706836'),
			 (21, 'Aripa', 'Aida', 'Crivat', '079879773'),
			 (22, 'Banana', 'Ioan', 'Rascani', '079395689'),
			 (23, 'Slovac', 'Paul', 'Cantemir', '079796390'),
			 (24, 'Vanatoru', 'Aid', 'Frunza', '079812431'),
			 (25, 'Melnic', 'Paula', 'Soroca', '079876119'),
			 (26, 'Munteanu', 'Calin', 'Bucovat', '079880975'),
			 (27, 'Radu', 'Sorin', 'Aneni', '079342235'),
			 (28, 'Radu', 'Cornelia', 'Bucuresti', '079112204'),
			 (29, 'Popescu', 'Elena', 'Cupcini', '079291233'),
			 (30, 'Ceai', 'Cornelia', 'Comrat', '079172897'),
			 (31, 'Radu', 'Maria', 'Falesti', '079501904'),
			 (32, 'Vasla', 'Cristi', 'Crivat', '079815303'),
			 (33, 'Melnic', 'Sanda', 'Ocnita', '079350243'),
			 (34, 'Borcan', 'Sanda', 'Costesti', '079235690'),
			 (35, 'Popescu', 'Mihai', 'Bucovat', '079242737'),
			 (36, 'Stici', 'Alexandra', 'Bucovat', '079454081'),
			 (37, 'Nastase', 'Carmen', 'Cahul', '079883555'),
			 (38, 'Chitic', 'Aida', 'Balti', '079121698'),
			 (39, 'Oaie', 'Calin', 'Bucovat', '079665760'),
			 (40, 'Sotir', 'Alina', 'Cahul', '079489533'),
			 (41, 'Bou', 'Bogdana', 'Comrat', '079180048'),
			 (42, 'Vulpe', 'Maria', 'Comrat', '079459381'),
			 (43, 'Coatu', 'Danuta', 'Aneni', '079212835'),
			 (44, 'Banana', 'Lena', 'Drochia', '079487676'),
			 (45, 'Florea', 'Cristina', 'Grigoriopol', '079219058'),
			 (46, 'Cioban', 'Valentina', 'Costesti', '079899382'),
			 (47, 'Moraru', 'Bogdan', 'Ocnita', '079703144'),
			 (48, 'Slovac', 'Grigorie', 'Comrat', '079271992'),
			 (49, 'Soimu', 'Alina', 'Ocnita', '079187534'),
			 (50, 'Ceai', 'Sorin', 'Costesti', '079373419'),
			 (51, 'Didian', 'Calin', 'Ungheni', '079844522'),
			 (52, 'Druta', 'Dumitru', 'Aneni', '079838369'),
			 (53, 'Cioban', 'Liviu', 'Falesti', '079480297'),
			 (54, 'Activ', 'Calin', 'Ialoveni', '079578669'),
			 (55, 'Bidon', 'Sanda', 'Costesti', '079595711'),
			 (56, 'Popa', 'Mihai', 'Comrat', '079578487'),
			 (57, 'Lungu', 'Aida', 'Soroca', '079175902'),
			 (58, 'Lungu', 'Sorin', 'Aneni', '079986364'),
			 (59, 'Radu', 'Vasile', 'Rascani', '079339300'),
			 (60, 'Bacioi', 'Maria', 'Briceni', '079395151'),
			 (61, 'Druta', 'Carmen', 'Falesti', '079878412'),
			 (62, 'Popescu', 'Danuta', 'Leuseni', '079287464'),
			 (63, 'Banana', 'Ion', 'Frunza', '079861949'),
			 (64, 'Zefir', 'Teofil', 'Bucovat', '079208829'),
			 (65, 'Simion', 'Cristi', 'Drochia', '079116246'),
			 (66, 'Sandu', 'Anton', 'Iasi', '079830553'),
			 (67, 'Druta', 'Cornelia', 'Rascani', '079928411'),
			 (68, 'Popescu', 'Alina', 'Ocnita', '079848496'),
			 (69, 'Schitco', 'Cristi', 'Cantemir', '079493259'),
			 (70, 'Zefir', 'Aid', 'Costesti', '079577539'),
			 (71, 'Dodon', 'Paul', 'Aneni', '079978951'),
			 (72, 'Schitco', 'Alina', 'Ungheni', '079591832'),
			 (73, 'Ananas', 'Ioan', 'Rascani', '079994364'),
			 (74, 'Vasla', 'Carmen', 'Frunza', '079901240'),
			 (75, 'Cernat', 'Cristina', 'Balti', '079175948'),
			 (76, 'Aripa', 'Aurel', 'Comrat', '079869949'),
			 (77, 'Zefir', 'Aida', 'Cahul', '079158240'),
			 (78, 'Ahot', 'Daniela', 'Leuseni', '079675632'),
			 (79, 'Epureanu', 'Maria', 'Ocnita', '079674768'),
			 (80, 'Florea', 'Lena', 'Crivat', '079180041'),
			 (81, 'Druta', 'Valeriu', 'Leuseni', '079443064'),
			 (82, 'Cernat', 'Valeriu', 'Balti', '079864293'),
			 (83, 'Sotir', 'Cornel', 'Leuseni', '079496471'),
			 (84, 'Druta', 'Cornel', 'Nisporeni', '079355673'),
			 (85, 'Calin', 'Tima', 'Cupcini', '079327694'),
			 (86, 'Stici', 'Maria', 'Comrat', '079395501'),
			 (87, 'Magaru', 'Daniel', 'Costesti', '079635445'),
			 (88, 'Baraboi', 'Dragos', 'Costesti', '079428931'),
			 (89, 'Aripa', 'Bogdan', 'Cupcini', '079910372'),
			 (90, 'Zefir', 'Mircea', 'Chisinau', '079823475'),
			 (91, 'Calin', 'Tima', 'Ungheni', '079243767'),
			 (92, 'Didian', 'Valeriu', 'Costesti', '079281238'),
			 (93, 'Zefir', 'Aurel', 'Nisporeni', '079189762'),
			 (94, 'Didian', 'Liviu', 'Ocnita', '079214423'),
			 (95, 'Aripa', 'Paula', 'Crivat', '079295921'),
			 (96, 'Borcan', 'Aida', 'Comrat', '079920349'),
			 (97, 'Oaie', 'Cristi', 'Soroca', '079639021'),
			 (98, 'Borcan', 'Aida', 'Cahul', '079663305'),
			 (99, 'Druta', 'Vasile', 'Grigoriopol', '079152408'),
			 (100, 'Moara', 'Liviu', 'Briceni', '079139918'),
			 (101, 'Banana', 'Cornelia', 'Grigoriopol', '079812602'),
			 (102, 'Simion', 'Valeriu', 'Cahul', '079642685'),
			 (103, 'Vanatoru', 'Mihai', 'Cricova', '079508899'),
			 (104, 'Schitco', 'Mihai', 'Aneni', '079114970'),
			 (105, 'Activ', 'Sanda', 'Crivat', '079957619'),
			 (106, 'Mouse', 'Maria', 'Grigoriopol', '079908535'),
			 (107, 'Munteanu', 'Vasile', 'Bucuresti', '079638725'),
			 (108, 'Simion', 'Cornelia', 'Costesti', '079561742'),
			 (109, 'Ceai', 'Cornelia', 'Ungheni', '079936855'),
			 (110, 'Calin', 'Daniel', 'Balti', '079439546'),
			 (111, 'Chitic', 'Lena', 'Ungheni', '079210847'),
			 (112, 'Borcan', 'Maria', 'Bucovat', '079443529'),
			 (113, 'Ceai', 'Mihai', 'Soroca', '079608881'),
			 (114, 'Didian', 'Liviu', 'Ialoveni', '079266251'),
			 (115, 'Radu', 'Maria', 'Cahul', '079792872'),
			 (116, 'Didian', 'Calin', 'Cricova', '079935593'),
			 (117, 'Vulpe', 'Calin', 'Grigoriopol', '079352245'),
			 (118, 'Magaru', 'Aida', 'Cricova', '079654225'),
			 (119, 'Simion', 'Paul', 'Bucuresti', '079729267'),
			 (120, 'Popa', 'Teofil', 'Leova', '079471586'),
			 (121, 'Zefir', 'Anton', 'Grigoriopol', '079265324'),
			 (122, 'Varga', 'Bogdan', 'Rascani', '079541606'),
			 (123, 'Vasla', 'Mircea', 'Comrat', '079218584'),
			 (124, 'Cernat', 'Alexandra', 'Chisinau', '079981597'),
			 (125, 'Melnic', 'Ioan', 'Crivat', '079821205'),
			 (126, 'Slovac', 'Maria', 'Bucovat', '079995393'),
			 (127, 'Enache', 'Anton', 'Aneni', '079100364'),
			 (128, 'Bacioi', 'Liviu', 'Cricova', '079297614'),
			 (129, 'Nastase', 'Danuta', 'Leuseni', '079107798'),
			 (130, 'Activ', 'Daniel', 'Iasi', '079143215'),
			 (131, 'Bacioi', 'Daniel', 'Cupcini', '079602292'),
			 (132, 'Munteanu', 'Andrei', 'Ialoveni', '079146080'),
			 (133, 'Lascu', 'Paul', 'Nisporeni', '079137429'),
			 (134, 'Stici', 'Daniela', 'Leuseni', '079457718'),
			 (135, 'Popa', 'Lena', 'Soroca', '079491268'),
			 (136, 'Varga', 'Mircea', 'Aneni', '079669142'),
			 (137, 'Schitco', 'Cristina', 'Ialoveni', '079567271'),
			 (138, 'Cernat', 'Cristina', 'Costesti', '079819217'),
			 (139, 'Nastase', 'Mihai', 'Bucuresti', '079518237'),
			 (140, 'Simion', 'Bogdan', 'Nisporeni', '079616352'),
			 (141, 'Didian', 'Aurel', 'Crivat', '079332222'),
			 (142, 'Nastase', 'Cristina', 'Drochia', '079858948'),
			 (143, 'Ceai', 'Ioan', 'Drochia', '079745943'),
			 (144, 'Activ', 'Aurel', 'Nisporeni', '079826745'),
			 (145, 'Epureanu', 'Grigorie', 'Comrat', '079355230'),
			 (146, 'Oaie', 'Paul', 'Iasi', '079290018'),
			 (147, 'Sandu', 'Ion', 'Cricova', '079601210'),
			 (148, 'Activ', 'Carmen', 'Soroca', '079177596'),
			 (149, 'Popescu', 'Alexandru', 'Cantemir', '079866557'),
			 (150, 'Vanatoru', 'Alexandra', 'Grigoriopol', '079466075'),
			 (151, 'Baraboi', 'Sanda', 'Cricova', '079298921'),
			 (152, 'Zefir', 'Mircea', 'Cantemir', '079310640'),
			 (153, 'Stici', 'Maria', 'Leuseni', '079533109'),
			 (154, 'Inger', 'Alexandra', 'Balti', '079368747'),
			 (155, 'Magaru', 'Mircea', 'Cahul', '079443562'),
			 (156, 'Enache', 'Valeriu', 'Iasi', '079959103'),
			 (157, 'Ananas', 'Alexandra', 'Bucuresti', '079971719'),
			 (158, 'Coi', 'Andrei', 'Soroca', '079214076'),
			 (159, 'Epureanu', 'Sanda', 'Chisinau', '079426005'),
			 (160, 'Mariut', 'Paula', 'Soroca', '079289645'),
			 (161, 'Aripa', 'Elena', 'Aneni', '079196126'),
			 (162, 'Mouse', 'Alina', 'Comrat', '079985419'),
			 (163, 'Baraboi', 'Grigorie', 'Aneni', '079298145'),
			 (164, 'Banana', 'Lena', 'Leova', '079942151'),
			 (165, 'Coi', 'Daniel', 'Bucuresti', '079426434'),
			 (166, 'Cimpoi', 'Cornelia', 'Bucovat', '079245759'),
			 (167, 'Banana', 'Bogdan', 'Comrat', '079726091'),
			 (168, 'Coi', 'Vasile', 'Cupcini', '079197278'),
			 (169, 'Coi', 'Alexandra', 'Rascani', '079171920'),
			 (170, 'Banana', 'Aid', 'Iasi', '079255833'),
			 (171, 'Ceai', 'Alina', 'Grigoriopol', '079193784'),
			 (172, 'Radu', 'Aida', 'Nisporeni', '079126767'),
			 (173, 'Borcan', 'Carmen', 'Soroca', '079883360'),
			 (174, 'Vulpe', 'Carmen', 'Bucovat', '079726216'),
			 (175, 'Popescu', 'Dragos', 'Cahul', '079653225'),
			 (176, 'Didian', 'Mihai', 'Frunza', '079984753'),
			 (177, 'Radu', 'Alex', 'Ocnita', '079759377'),
			 (178, 'Comoara', 'Elena', 'Leuseni', '079261218'),
			 (179, 'Coi', 'Alexandru', 'Soroca', '079994967'),
			 (180, 'Oaie', 'Sanda', 'Frunza', '079379647'),
			 (181, 'Vulpe', 'Daniel', 'Rascani', '079182852'),
			 (182, 'Simion', 'Tima', 'Soroca', '079410418'),
			 (183, 'Ananas', 'Dragos', 'Briceni', '079843062'),
			 (184, 'Coi', 'Cristina', 'Falesti', '079425645'),
			 (185, 'Bou', 'Ion', 'Ocnita', '079458049'),
			 (186, 'Popescu', 'Valentina', 'Crivat', '079429649'),
			 (187, 'Epureanu', 'Dragos', 'Falesti', '079462358'),
			 (188, 'Cazacu', 'Sorin', 'Comrat', '079710507'),
			 (189, 'Comoara', 'Vasile', 'Falesti', '079216871'),
			 (190, 'Borcan', 'Anton', 'Aneni', '079167449'),
			 (191, 'Magaru', 'Alex', 'Comrat', '079102855'),
			 (192, 'Stici', 'Maria', 'Nisporeni', '079331985'),
			 (193, 'Popa', 'Ioan', 'Leova', '079163531'),
			 (194, 'Bidon', 'Alina', 'Leuseni', '079235235'),
			 (195, 'Cimpoi', 'Vasile', 'Falesti', '079995787'),
			 (196, 'Corovai', 'Elena', 'Leuseni', '079749114'),
			 (197, 'Schitco', 'Alexandra', 'Drochia', '079530936'),
			 (198, 'Didian', 'Liviu', 'Costesti', '079889907'),
			 (199, 'Banana', 'Elena', 'Leova', '079359112'),
			 (200, 'Baraboi', 'Dumitru', 'Ialoveni', '079766555'),
			 (201, 'Enache', 'Aida', 'Balti', '079429210'),
			 (202, 'Popescu', 'Danuta', 'Bucovat', '079756101'),
			 (203, 'Borcan', 'Alexandra', 'Iasi', '079966366'),
			 (204, 'Magaru', 'Liviu', 'Cantemir', '079220284'),
			 (205, 'Popescu', 'Carmen', 'Leova', '079477019'),
			 (206, 'Melnic', 'Aida', 'Falesti', '079741974'),
			 (207, 'Cimpoi', 'Cristina', 'Nisporeni', '079582067'),
			 (208, 'Cimpoi', 'Mircea', 'Chisinau', '079661142'),
			 (209, 'Corovai', 'Teofil', 'Soroca', '079319772'),
			 (210, 'Cazacu', 'Andrei', 'Iasi', '079257191'),
			 (211, 'Coatu', 'Andrei', 'Bucovat', '079269357'),
			 (212, 'Bidon', 'Vasile', 'Bucovat', '079439090'),
			 (213, 'Nastase', 'Mircea', 'Nisporeni', '079555250'),
			 (214, 'Ahot', 'Aurel', 'Soroca', '079524697'),
			 (215, 'Simion', 'Anton', 'Iasi', '079531111'),
			 (216, 'Cernat', 'Bogdan', 'Frunza', '079175525'),
			 (217, 'Nastase', 'Sanda', 'Ialoveni', '079306844'),
			 (218, 'Moara', 'Cristina', 'Bucuresti', '079788888'),
			 (219, 'Dodon', 'Cristina', 'Cricova', '079554435'),
			 (220, 'Ahot', 'Cornelia', 'Cupcini', '079573563'),
			 (221, 'Baraboi', 'Aurel', 'Ungheni', '079107354'),
			 (222, 'Cimpoi', 'Aid', 'Rascani', '079961958'),
			 (223, 'Magaru', 'Sanda', 'Bucuresti', '079290304'),
			 (224, 'Enache', 'Sorin', 'Rascani', '079356956'),
			 (225, 'Bacioi', 'Bogdan', 'Bucuresti', '079182175'),
			 (226, 'Aripa', 'Maria', 'Ialoveni', '079717478'),
			 (227, 'Epureanu', 'Teofil', 'Iasi', '079615000'),
			 (228, 'Activ', 'Aida', 'Bucovat', '079547142'),
			 (229, 'Bat', 'Cristina', 'Nisporeni', '079449676'),
			 (230, 'Moraru', 'Alina', 'Crivat', '079235683'),
			 (231, 'Enache', 'Anton', 'Balti', '079688135'),
			 (232, 'Bacioi', 'Dumitru', 'Iasi', '079384895'),
			 (233, 'Mariut', 'Cornel', 'Falesti', '079288749'),
			 (234, 'Aripa', 'Paul', 'Bucovat', '079528473'),
			 (235, 'Baraboi', 'Mihai', 'Grigoriopol', '079243160'),
			 (236, 'Mouse', 'Mihai', 'Bucovat', '079178147'),
			 (237, 'Banana', 'Paul', 'Aneni', '079258718'),
			 (238, 'Moara', 'Aurel', 'Iasi', '079323787'),
			 (239, 'Cernat', 'Dragos', 'Leova', '079920649'),
			 (240, 'Borcan', 'Alexandru', 'Crivat', '079110780'),
			 (241, 'Florea', 'Alex', 'Drochia', '079195208'),
			 (242, 'Moraru', 'Grigorie', 'Leova', '079868810'),
			 (243, 'Lascu', 'Paula', 'Briceni', '079882039'),
			 (244, 'Oaie', 'Alexandru', 'Briceni', '079578525'),
			 (245, 'Aripa', 'Andrei', 'Rascani', '079847054'),
			 (246, 'Nastase', 'Valentina', 'Soroca', '079319372'),
			 (247, 'Radu', 'Bogdan', 'Chisinau', '079722093'),
			 (248, 'Soimu', 'Cristi', 'Ialoveni', '079527580'),
			 (249, 'Moara', 'Ion', 'Cricova', '079863981'),
			 (250, 'Soimu', 'Aurel', 'Aneni', '079818932'),
			 (251, 'Didian', 'Paul', 'Briceni', '079632048'),
			 (252, 'Popescu', 'Maria', 'Ialoveni', '079559160'),
			 (253, 'Vulpe', 'Valentina', 'Cantemir', '079492522'),
			 (254, 'Sandu', 'Sanda', 'Chisinau', '079134705'),
			 (255, 'Zefir', 'Aida', 'Bucovat', '079252217'),
			 (256, 'Bacioi', 'Cornelia', 'Comrat', '079428912'),
			 (257, 'Chitic', 'Calin', 'Briceni', '079388520'),
			 (258, 'Vanatoru', 'Calin', 'Cricova', '079110780'),
			 (259, 'Epureanu', 'Cristi', 'Ialoveni', '079292753'),
			 (260, 'Stici', 'Daniel', 'Ungheni', '079813982'),
			 (261, 'Ceai', 'Cornelia', 'Iasi', '079408591'),
			 (262, 'Vanatoru', 'Alex', 'Leova', '079418471'),
			 (263, 'Soimu', 'Daniela', 'Grigoriopol', '079994372'),
			 (264, 'Dodon', 'Alina', 'Briceni', '079342474'),
			 (265, 'Soimu', 'Sanda', 'Grigoriopol', '079600011'),
			 (266, 'Inger', 'Dumitru', 'Leuseni', '079232700'),
			 (267, 'Lungu', 'Carmen', 'Rascani', '079446985'),
			 (268, 'Activ', 'Sorin', 'Ialoveni', '079980169'),
			 (269, 'Vulpe', 'Dragos', 'Cupcini', '079168780'),
			 (270, 'Chitic', 'Lena', 'Crivat', '079939844'),
			 (271, 'Inger', 'Valentina', 'Crivat', '079383549'),
			 (272, 'Didian', 'Anton', 'Soroca', '079747569'),
			 (273, 'Ananas', 'Liviu', 'Leuseni', '079668979'),
			 (274, 'Magaru', 'Alexandru', 'Comrat', '079487293'),
			 (275, 'Munteanu', 'Alina', 'Cahul', '079418843'),
			 (276, 'Melnic', 'Ion', 'Nisporeni', '079996687'),
			 (277, 'Cioban', 'Cornelia', 'Chisinau', '079223033'),
			 (278, 'Simion', 'Paul', 'Ialoveni', '079817861'),
			 (279, 'Corovai', 'Danuta', 'Cupcini', '079108493'),
			 (280, 'Baraboi', 'Mircea', 'Comrat', '079711485'),
			 (281, 'Simion', 'Paula', 'Bucovat', '079852151'),
			 (282, 'Nastase', 'Danuta', 'Crivat', '079593207'),
			 (283, 'Oaie', 'Alina', 'Cahul', '079262206'),
			 (284, 'Aripa', 'Sanda', 'Ialoveni', '079408446'),
			 (285, 'Chitic', 'Ion', 'Chisinau', '079568924'),
			 (286, 'Popescu', 'Maria', 'Cricova', '079599643'),
			 (287, 'Bat', 'Valentina', 'Grigoriopol', '079557036'),
			 (288, 'Vanatoru', 'Alex', 'Rascani', '079604492'),
			 (289, 'Sotir', 'Carmen', 'Costesti', '079159985'),
			 (290, 'Ahot', 'Maria', 'Chisinau', '079946903'),
			 (291, 'Magaru', 'Maria', 'Aneni', '079861419'),
			 (292, 'Lascu', 'Aida', 'Rascani', '079288328'),
			 (293, 'Radu', 'Alex', 'Frunza', '079165605'),
			 (294, 'Oaie', 'Maria', 'Nisporeni', '079115959'),
			 (295, 'Nastase', 'Vasile', 'Leova', '079898791'),
			 (296, 'Druta', 'Mircea', 'Bucuresti', '079178220'),
			 (297, 'Melnic', 'Dumitru', 'Costesti', '079745249'),
			 (298, 'Florea', 'Lena', 'Briceni', '079885402'),
			 (299, 'Cimpoi', 'Sanda', 'Crivat', '079150785'),
			 (300, 'Druta', 'Cristi', 'Cantemir', '079974367')


GO

	INSERT INTO Contracte (ID_Contract, Data_Contract, IDNP_Pers, Suma_Total, ID_Asig, ID_Filiala, IDNP_Agent) VALUES
			   (2953, '2019.11.11', 1, 100000, 1, 5, 12345678901),
			   (2954, '2019.11.11', 3, 25000, 3, 1, 87656783845),
			   (2955, '2019.11.12', 17, 35000, 4, 2, 87654365748),
			   (2956, '2019.11.13', 12, 50000, 2, 5, 84637592649),
			   (2957, '2019.11.13', 1, 50000, 3, 5, 84637592649),
			   (2958, '2019.11.13', 8, 10000, 4, 6, 94828471839),
			   (2959, '2019.11.15', 7, 15000, 2, 2, 87654365748),
			   (2960, '2019.11.15', 4, 15000, 1, 1, 87656783845),
			   (2961, '2019.11.15', 3, 100000, 2, 6, 94828471839),
			   (2962, '2019.11.16', 9, 50000, 3, 1, 87656783845),
			   (2963, '2019.11.16', 16, 5000, 4, 5, 84637592649),
			   (2964, '2019.11.16', 8, 25000, 1, 2, 87654365748),
			   (2965, '2019.11.16', 6, 15000, 3, 5, 12345678901),
			   (2966, '2019.11.16', 3, 7500, 3, 6, 94828471839),
			   (2967, '2019.11.17', 15, 55000, 2, 2, 87654365748),
			   (2968, '2019.11.17', 8, 10000, 1, 1, 87656783845),
			   (2969, '2019.11.17', 4, 10000, 4, 1, 87656783845),
			   (2970, '2019.11.17', 2, 50000, 3, 5, 84637592649)
GO

	INSERT INTO Useri VALUES
		('Nume', 'Email@mail.ru', 'Parola'),
		('Alex', 'Alex@mail.ru', '123456'),
		('Admin', 'admin@gmail.com', 'admin')
GO



--SELECT CONCAT_WS('_', Nume, Prenume)           -- Concatineaza dupa principiul ca primul parametru separeaza ceilalti
--	FROM Persoane


--SELECT CONCAT(Nume, ' ', Prenume)              -- Cea mai comuna metoda de concatinat
--	FROM Persoane


--SELECT (Nume + ' ' + Prenume)				     -- Concatinarea fara ajutorul functiei CONCAT, mai usor de inteles pentru programatori
--	FROM Persoane






--SELECT SUM(Suma_Total) as Suma_Totala         -- SUM, aduna fiecare valoare din inregistrare
--	FROM Contracte

--SELECT COUNT(Suma_Total) as Nr_Contracte      -- COUNT, aduna fiecare valoare pe rand [arata numarul de randuri]
--	FROM Contracte





--SELECT ID_Contract, DATEADD(day, 16, Data_Contract) as Ziua16     -- Adauga plus 16 zile la ziua initiala
--	FROM Contracte

--SELECT DATEDIFF(day, Data_Contract, GetDate()) as Timp			-- Scade din prima data a doua 
--	FROM Contracte




--Returneaza fix aceeasi doar ca DATENAME, returneaza in STRING, DATEPART in INT : [DAY, MONTH, YEAR]

--Select DATENAME(day, Data_Contract)      
--	FROM Contracte

--Select DATEPART(day, Data_Contract)
--	FROM Contracte



CREATE PROCEDURE SelectAllPersoaneOrhei AS
	SELECT Nume, Prenume, Adresa
		FROM Persoane
			WHERE Adresa LIKE '%Orhei%'

		  -- ' % A % '		contine A oriunde in String
		  -- ' % A '		contine A la inceput String
		  -- ' A % '		contine A la sfarsit String
		  -- ' A%B '		Incepe cu A si se termina cu B		  
GO




CREATE PROCEDURE SelectAllPersoaneChisinau AS
	SELECT Nume, Prenume, Adresa
		FROM Persoane
			WHERE Adresa IN ('Chisinau')
GO



--CREATE OR REPLACE VIEW
CREATE VIEW [Suma contract mai mare ca AVG] AS
	SELECT Suma_Total
		FROM Contracte
			WHERE Suma_Total > (SELECT AVG(Suma_Total) FROM Contracte)
GO


GO


ALTER TABLE Agenti_Asigurari DROP CONSTRAINT ML    -- Stergem o constrangere
GO

ALTER TABLE Agenti_Asigurari 
	ADD AtributX int                               -- Adaugam un atribut cu denumirea AtributX de tip integer
GO

ALTER TABLE Agenti_Asigurari 
	ALTER COLUMN AtributX nvarchar(20)             -- Schimbam tipul de date in nvarchar(20) 
GO

ALTER TABLE Agenti_Asigurari                       -- Il stergem tot odata
	DROP COLUMN AtributX
GO



-- Se folosesc indexurile pentru a prelua date din baza de date foarte rapid.
CREATE INDEX idx_Email
	ON	Filiale (Email)
GO

--Sterge indexul dat
DROP INDEX Filiale.idx_Email
GO



-- Permite sa afiseze valorile din ambele tabeluri impreuna, UNION ALL - chiar si elementele comune

--SELECT Nume,Prenume FROM Agenti_Asigurari
--WHERE Nume LIKE 'C%'
--	UNION ALL
--SELECT Nume,Prenume FROM Persoane
--WHERE Nume LIKE 'C%'
--ORDER BY Nume




-- Virgula este OBLIGATORIE dupa ultimul Atribut selectat inainte de functia CASE

--SELECT IDNP_Pers, Suma_Total,
--	CASE
--    WHEN Suma_Total <= 10000 THEN 'Slabut'
--	  WHEN Suma_Total >= 25000 THEN 'Bogat'
--    ELSE 'Normal'
--END AS [Caracteristica]
--FROM Contracte




CREATE PROCEDURE Agent_Filiala AS
SELECT Agenti_Asigurari.Nume, Agenti_Asigurari.Prenume, Filiale.Nume as NumeFiliala
FROM Agenti_Asigurari
INNER JOIN Filiale ON Filiale.ID_Filiala = Agenti_Asigurari.ID_Filiala
GO



	--LEFT JOIN 
--SELECT Agenti_Asigurari.Nume, Agenti_Asigurari.Prenume, Filiale.Nume as NumeFiliala
--FROM Agenti_Asigurari
--LEFT JOIN Filiale ON Filiale.ID_Filiala = Agenti_Asigurari.ID_Filiala
--ORDER BY Agenti_Asigurari.Nume

	--RIGHT JOIN
--SELECT Agenti_Asigurari.Nume, Agenti_Asigurari.Prenume, Filiale.Nume as NumeFiliala
--FROM Agenti_Asigurari
--RIGHT JOIN Filiale ON Filiale.ID_Filiala = Agenti_Asigurari.ID_Filiala
--ORDER BY Agenti_Asigurari.Nume

	--INNER JOIN
--SELECT Agenti_Asigurari.Nume, Agenti_Asigurari.Prenume, Filiale.Nume  as NumeFiliala
--FROM Agenti_Asigurari
--INEER JOIN Filiale ON Filiale.ID_Filiala = Agenti_Asigurari.ID_Filiala
--ORDER BY Agenti_Asigurari.Nume

	--FULL OUTER JOIN
--SELECT Agenti_Asigurari.Nume, Agenti_Asigurari.Prenume, Filiale.Nume  as NumeFiliala
--FROM Agenti_Asigurari
--FULL OUTER JOIN Filiale ON Filiale.ID_Filiala = Agenti_Asigurari.ID_Filiala
--ORDER BY Agenti_Asigurari.Nume






-- Functia EXISTS returneaza valoarea TRUE, si afiseaza toate denumirile de Tipuri de Asigurari
--SELECT Nume
--FROM Tip_Asigurari
--WHERE EXISTS ( SELECT Suma_Total FROM Contracte WHERE Tip_Asigurari.ID_Assig=Contracte.ID_Asig AND Suma_Total<=15000)
--ORDER BY Nume





CREATE PROCEDURE IfStatement AS
IF EXISTS (SELECT * FROM TableTest WHERE FirstName = 'Sorin')
BEGIN
	UPDATE TableTest set TestColumn = 333       -- In caz ca este TRUE
END
ELSE
BEGIN
	UPDATE TableTest set TestColumn = 222       -- In caz de este FALSE
END
select* from TableTest
GO



-- Executa toate procedurile si view-urile de mai sus
--EXEC IfStatement
--EXEC SelectDinDouaTabele
--EXEC SelectAllPersoaneOrhei
--EXEC SelectAllPersoaneChisinau
--SELECT * FROM [Suma contract mai mare ca AVG]





IF EXISTS (SELECT *
      FROM sys.server_event_sessions    
      WHERE name = 'test_session')
BEGIN
    DROP EVENT SESSION test_session 
		ON SERVER;   
END
GO

CREATE EVENT SESSION test_session
ON SERVER
    ADD EVENT sqlos.async_io_requested,
    ADD EVENT sqlserver.lock_acquired
    ADD TARGET package0.etw_classic_sync_target
        (SET default_etw_session_logfile_path = 'D:\Alex\Proiecte\SQL\sqletw.etl' )
    WITH (MAX_MEMORY=4MB, MAX_EVENT_SIZE=4MB);
GO


-- Selecteaza toti userii from database
/*
SELECT  SP.name,
        SP.principal_id,
        SP.type_desc,
        SP.is_disabled,
        SP.create_date,
        SP.modify_date,
        SP.default_database_name,
        SP.default_language_name,
        SP.is_fixed_role
FROM    sys.server_principals AS SP;
*/



--CREATE USER Alex FOR LOGIN Alex
--EXEC sp_addrolemember N'db_owner', N'Alex'





BEGIN TRANSACTION PrimaTranzactie
	INSERT INTO TableTest VALUES ('Me', 'Myself', 3, 4)
	IF ((SELECT COUNT(Id_Person) From TableTest  ) > 3)
	BEGIN
		SAVE TRANSACTION Savepoint
		INSERT INTO TableTest VALUES ('Don''t', 'Judge', 10, 300)
	END
	IF ((Select FirstName From TableTest WHERE Id_Person = 4) = 'Myself')    
	BEGIN
		PRINT 'RollBack'
		ROLLBACK TRANSACTION Savepoint
	END
COMMIT TRANSACTION;
GO


CREATE PROCEDURE Delete_From_Table(@Id Tinyint)
AS
BEGIN TRY
	BEGIN TRANSACTION [Alah]
		DELETE FROM TableTest WHERE  @Id = Id_Person	
		PRINT CONCAT('Succesfully deleted by Id ', @Id)
		COMMIT 
END TRY
BEGIN CATCH
    ROLLBACK 
	RAISERROR('This ID doesn''t exists', 16, 1)
END CATCH;
GO
--WHILE / DO


/* Cross Join
SELECT A.Nume, A.Prenume, T.Procentaj_Agent, T.Procentaj_Client
FROM Agenti_Asigurari A
CROSS JOIN Tip_Asigurari T
GO
*/
GO


--BACKUP DATABASE Nume_Baza_de_Date
	--TO DISK = 'Locatia'


BACKUP DATABASE Companie_Asigurari 
	FILE = 'Companie_Asigurari' 
	TO DISK = 'D:\Alex\Proiecte\SQL\Companie_Asigurari.fil'   -- .bak .FIL
	WITH FORMAT, 
	STATS = 1,
	DESCRIPTION = 'Full backup for Companie_Asigurari'
	--DIFERENTIAL
GO






CREATE PROCEDURE InsertInto(@numar int) 
AS
	DECLARE @Tabel_Nume TABLE (id INT, nume VARCHAR(20))
	INSERT INTO @Tabel_Nume VALUES (1, 'Alex'), (2, 'Adina'), (3, 'Stas'), (4, 'Maria')
	
	DECLARE @count INT;
	SET @count = 4;
    
	DECLARE @name nvarchar(max)
	SET @name = (SELECT nume FROM @Tabel_Nume WHERE id = 3)

	/* Iteratia de corectat */
	WHILE @count <= @numar
	BEGIN
	  /* NU MERGE PARTEA CU RANDOM */
	  INSERT INTO @Tabel_Nume VALUES (@count, (SELECT nume FROM @Tabel_Nume WHERE id = (SELECT FLOOR(RAND()*(3)+1))  ))
	  SET @count = @count + 1;
	END;

	SELECT * FROM @Tabel_Nume
GO

EXEC InsertInto 8


/*
	Return a random number >= 5 and <=10:
	SELECT FLOOR(RAND()*(10-5+1)+5);
*/










