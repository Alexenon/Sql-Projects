USE master
GO
IF EXISTS(
	SELECT *FROM sys.databases WHERE name='Test')
BEGIN
		ALTER DATABASE Test SET single_user
		WITH ROLLBACK IMMEDIATE
		DROP DATABASE Test
		END
GO
CREATE DATABASE Test
GO
USE Test
GO



--SET NOCOUNT ON; -- REMOVES THE NUMBER OF AFFECTED ROWS
GO


CREATE TABLE TriggerDemo_NewParent
(
   ID INT IDENTITY (1,1) PRIMARY KEY,
   Emp_First_name VARCHAR (50),
   Emp_Last_name VARCHAR (50),
   Emp_Salary INT 
  )
GO


CREATE TABLE TriggerDemo_InsteadParent
(
   ID INT IDENTITY (1,1) PRIMARY KEY,
   ParentID INT,
   PerformedAction VARCHAR (50),
  )
GO


CREATE TABLE TestTable(
	ID int IDENTITY(1,1) PRIMARY KEY,
	Column1 VARCHAR (50),
	Column2 VARCHAR (50),
	Column3 date
)
GO


CREATE TABLE ShowData(
	HisName VARCHAR (50),
	--myuser_name AS USER_NAME()      Cool feature
	Data datetime
)
GO


/* The Primary Key is based on 2 columns */
CREATE TABLE tmp (
    c1 INT,
    c2 INT,
    PRIMARY KEY CLUSTERED ([c1], [c2])
);
GO


INSERT INTO tmp VALUES(1, 1), (1, 2), (2, 1), (2, 2)
--SELECT * FROM tmp
GO


INSERT INTO TriggerDemo_NewParent VALUES ('AAA','BBB', 999)
GO


-- AFTER / INSTEAD OF

CREATE TRIGGER InsteadOfInsertTrigger 
ON TriggerDemo_NewParent
AFTER INSERT        
AS
INSERT INTO TriggerDemo_InsteadParent VALUES ((SELECT TOP 1  inserted.ID FROM inserted), 'Instead of INSERT')
GO


CREATE TRIGGER InsteadOfUpdateTrigger 
ON TriggerDemo_NewParent
INSTEAD OF UPDATE
AS
INSERT INTO TriggerDemo_InsteadParent VALUES ((SELECT TOP 1  inserted.ID FROM inserted), 'Instead of UPDATE')
GO


INSERT INTO TriggerDemo_NewParent VALUES ('AAA','BBB',500)
	GO 
UPDATE TriggerDemo_NewParent SET Emp_Salary = 300
	GO
INSERT INTO TriggerDemo_NewParent VALUES ('CCC','DDD',600)
	GO
UPDATE TriggerDemo_NewParent SET Emp_Salary = 300
	GO









CREATE TRIGGER FirstTrigger ON TriggerDemo_NewParent
INSTEAD OF INSERT
AS
DECLARE @Count int
DECLARE @Sum int 
SELECT @Count = COUNT(*) FROM TriggerDemo_NewParent
SELECT @Sum = SUM(Emp_Salary) FROM TriggerDemo_NewParent
IF (@Count < @Sum)
	INSERT INTO TriggerDemo_InsteadParent VALUES (@Count, @Sum)
ELSE
	RAISERROR('Error, IndexOutOfBoundsException', 16, 1);
GO


INSERT INTO TriggerDemo_NewParent VALUES ('AAA','BBB',500)
	GO 



CREATE TRIGGER ShowChangeData ON TestTable
AFTER INSERT
AS
DECLARE @Name nvarchar(20)
DECLARE @Date date
SELECT TOP 1 @Name = Column1 + Column2 FROM TestTable

--INSERT INTO ShowData VALUES ((SELECT Column1 FROM TestTable), GETDATE())
INSERT INTO ShowData VALUES (@Name, GETDATE())
GO


INSERT INTO TestTable VALUES 
	('Bat', 'Alex', GETDATE()),
	('Stanescu', 'Sergiu', GETDATE())

GO

--Select * from TriggerDemo_NewParent
--Select * from TriggerDemo_InsteadParent
--Select * from TestTable
--Select * from ShowData
--GO





CREATE FUNCTION Func()
RETURNS @Table TABLE(ColName int)
AS
BEGIN
  DECLARE @Var int
  SET @Var = 10
  INSERT INTO @Table(ColName) VALUES (@Var)
  RETURN
END
GO

--SELECT * FROM Func()
GO





CREATE PROCEDURE PrintSomething (@Number int = 1)
AS
BEGIN 
	SELECT * FROM TestTable WHERE ID = @Number
END;
GO


--EXEC PrintSomething;
--EXEC PrintSomething 2;



CREATE TABLE InputDataFromFile(
	Col1 VARCHAR (50),
	Col2 VARCHAR (50),
	Col3 VARCHAR (50)
)
GO


BULK INSERT InputDataFromFile
FROM 'D:\Alex\Proiecte\SQL\Input File Txt\InputData.csv'
WITH (
	FIRSTROW = 1,
	FIELDTERMINATOR = ',',
	FORMAT='CSV',
	FIELDQUOTE='"',
	ROWTERMINATOR='\n' 
	);




alter authorization on database :: Test to SA   



IF NOT EXISTS (SELECT [name]
                FROM [sys].[database_principals]
                WHERE [type] = N'S' AND [name] = N'Alex')
BEGIN
    CREATE USER Alex
    FOR LOGIN Alex WITH DEFAULT_SCHEMA = [TestSchema]
END
ALTER ROLE [db_ddladmin] ADD MEMBER Alex
GO


CREATE SCHEMA TestSchema AUTHORIZATION [BATAURS\Nautilus]
    GRANT SELECT, UPDATE, INSERT 
	ON SCHEMA::TestSchema TO Alex 
GO   




GRANT SELECT, UPDATE, INSERT 
ON dbo.ShowData
TO Alex
GO


CREATE PROCEDURE ShowTableOwners AS

DECLARE @ShowOwners TABLE (
	DBA_NAME varchar(max),
	TABLE_OWNER varchar(max),
	TABLE_NAME varchar(max),
	TABLE_TYPE varchar(max),
	REMARKS varchar(max)
)

INSERT INTO @ShowOwners(DBA_NAME, TABLE_OWNER, TABLE_NAME, TABLE_TYPE, REMARKS)
EXECUTE master.sys.sp_MSforeachdb 'USE [?]; EXEC sp_tables'

SELECT DBA_NAME, TABLE_OWNER, TABLE_NAME FROM @ShowOwners
WHERE DBA_NAME <> 'master' AND DBA_NAME <> 'tempdb' AND DBA_NAME <> 'model' AND DBA_NAME <> 'msdb' 
AND TABLE_TYPE = 'TABLE' AND TABLE_OWNER <> 'sys';
GO
--EXEC ShowTableOwners;

--SELECT SYSTEM_USER, USER;


CREATE SCHEMA Test;  
GO  
  
CREATE SEQUENCE Test.CountBy1
	AS int
	START WITH 1
	INCREMENT BY 1
	MAXVALUE 100
	--CYCLE {NO CYCLE}
	--CACHE {CONSTANT}
GO


--SELECT NEXT VALUE FOR Test.CountBy1 AS CountTimes;
--GO 5

--SELECT * FROM sys.sequences WHERE name = 'CountBy1';



DECLARE MyCursor CURSOR SCROLL
	FOR SELECT * FROM TriggerDemo_NewParent
OPEN MyCursor
	FETCH NEXT FROM MyCursor
	WHILE @@FETCH_STATUS = 0  
		BEGIN
			FETCH NEXT FROM MyCursor;  
		END;
CLOSE MyCursor
DEALLOCATE MyCursor
GO




