USE WithoutQuery
GO



DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS Restaurant;
DROP TABLE IF EXISTS City;
DROP TABLE IF EXISTS friendOf;
DROP TABLE IF EXISTS livesIn;
DROP TABLE IF EXISTS locatedIn;
GO



CREATE TABLE Person (
  Person_Id INT PRIMARY KEY,
  Person_Name VARCHAR(MAX)
) AS NODE;

CREATE TABLE Restaurant (
  Restaurant_Id INT PRIMARY KEY,
  Restaurant_Name VARCHAR(MAX),
  City VARCHAR(100) -- Foreign key to table City
) AS NODE;

CREATE TABLE City (
  City_Id INT PRIMARY KEY,
  City_Name VARCHAR(MAX),
  State_Name VARCHAR(MAX)
) AS NODE;
GO

-- Create EDGE tables. 
CREATE TABLE likes (rating INTEGER) AS EDGE;
CREATE TABLE friendOf AS EDGE;
CREATE TABLE livesIn AS EDGE;
CREATE TABLE locatedIn AS EDGE;


INSERT INTO Person VALUES 
	(1,'John'), 
	(2,'Mary'), 
	(3,'Alice'), 
	(4,'Jacob'), 
	(5,'Julie');

INSERT INTO Restaurant VALUES 
	(1,'Taco Dell','Bellevue'), 
	(2,'Ginger and Spice','Seattle'), 
	(3,'Noodle Land', 'Redmond');

INSERT INTO City VALUES 
	(1,'Bellevue','wa'),
	(2,'Seattle','wa'),
	(3,'Redmond','wa');


INSERT INTO likes VALUES (
	(SELECT $node_id FROM Person WHERE Person_Id = 1), (SELECT $node_id FROM Restaurant WHERE Restaurant_Id = 1), 9);
INSERT INTO likes VALUES (
	(SELECT $node_id FROM Person WHERE Person_Id = 2), (SELECT $node_id FROM Restaurant WHERE Restaurant_Id = 2), 7);
INSERT INTO likes VALUES (
	(SELECT $node_id FROM Person WHERE Person_Id = 3), (SELECT $node_id FROM Restaurant WHERE Restaurant_Id = 3), 10);

	

/*
SELECT * FROM Person
SELECT * FROM Restaurant
SELECT * FROM likes
*/

/* Checks all tables that begins with "L" is an edge or a node */
SELECT  name, t.is_edge,t.is_node, schema_id, create_date, modify_date, max_column_id_used
FROM sys.tables t
WHERE name like 'L%'


/* 
	https://docs.microsoft.com/en-us/sql/t-sql/statements/create-table-sql-graph?view=sql-server-ver15#examples  Microsoft Tutorial

	https://www.red-gate.com/simple-talk/sql/sql-development/sql-server-graph-databases-part-1-introduction/  Simple Tutorial

	https://www.sqlshack.com/introduction-sql-server-2017-graph-database/  Complex Tutorial
*/