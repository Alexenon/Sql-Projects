/* 
	DOCUMENTATION
 
	https://www.sqlshack.com/managing-data-with-sql-server-filestream-tables/   Manage Filestream

	https://www.sqlskills.com/blogs/paul/filestream-directory-structure/	Directory Structure  

	https://www.mssqltips.com/sql-server-tip-category/92/filestream/	FILESTREAM Tips

	https://www.red-gate.com/simple-talk/sql/learn-sql-server/an-introduction-to-sql-server-filestream/		Big Tutorial		

	https://database.guide/how-to-delete-files-in-sql-server-2019/    Delete files

*/



/*	Declare and set the full path to specific directory  */
DECLARE @fullpath nvarchar(max);
DECLARE @foldername nvarchar(max);
SET @fullpath = 'D:\
Alex\Proiecte\SQL'
SET @foldername = 'TestFolder'
GO

DROP DATABASE Archive 
GO

CREATE DATABASE Archive 
ON
PRIMARY ( NAME = Arch1,
    FILENAME = 'D:\Alex\Proiecte\SQL\Backups\Arhive\archdat1.mdf'),    -- Primary File
FILEGROUP FileStreamGroup1 CONTAINS FILESTREAM( NAME = Arch3,
    FILENAME = 'D:\Alex\Proiecte\SQL\Backups\Arhive\filestream1')		-- Folder Name
LOG ON ( NAME = Archlog1,
    FILENAME = 'D:\Alex\Proiecte\SQL\Backups\Arhive\archlog1.ldf')	   -- Transaction File
GO


DROP DATABASE TestBd
GO

CREATE DATABASE TestBd
GO

/* Add FILEGROUP to database that contains FILESTREAM */
ALTER DATABASE TestBd ADD FILEGROUP [TestFileGroup] CONTAINS FILESTREAM;
GO

/* Add FILE to FILEGROUP */
ALTER DATABASE TestBd ADD FILE (
NAME = [FirstFolder], FILENAME = 'D:\Alex\Proiecte\SQL\Hey')
TO FILEGROUP [TestFileGroup] 
GO




EXEC master.sys.xp_delete_files
'D:\Alex\Proiecte\SQL\Backups\Arhive';
GO

 

-- Variabile, AlterDatabase, CreateTable



