CREATE CREDENTIAL FirstCredential WITH IDENTITY = 'TestLogin',
    SECRET = 'TestPassword';
GO

CREATE LOGIN TestLogin WITH PASSWORD = 'TestPassword',
    CREDENTIAL = FirstCredential,
	DEFAULT_DATABASE = master,
	CHECK_POLICY = OFF,
	CHECK_EXPIRATION = OFF ;
	/*  
	CHECK_POLICY = { ON | OFF }
		Specifies that the Windows password policies of the computer on which SQL Server 
		is running should be enforced on this login. The default value is ON. 
		
	CHECK_EXPIRATION = { ON | OFF }
		Applies to SQL Server logins only. 
		Specifies whether password expiration policy should be enforced on this login. The default value is OFF.
	
	CREDENTIAL 
		A credential is a record that contains the authentication information 
		that is required to connect to a resource outside SQL Server. 
		Most credentials include a Windows user and password. 
	*/
GO



CREATE USER Vasile FOR LOGIN TestLogin


SELECT * FROM sys.sql_logins


DROP LOGIN TestLogin
DROP CREDENTIAL FirstCredential
DROP USER Vasile



