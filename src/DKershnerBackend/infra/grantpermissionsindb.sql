CREATE USER [dk-webapp] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [dk-webapp];
ALTER ROLE db_datawriter ADD MEMBER [dk-webapp];
ALTER ROLE db_ddladmin ADD MEMBER [dk-webapp];
GO