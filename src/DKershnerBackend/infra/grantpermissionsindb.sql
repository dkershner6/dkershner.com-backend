CREATE USER [dk-db-access] FROM EXTERNAL PROVIDER;
ALTER ROLE db_datareader ADD MEMBER [dk-db-access];
ALTER ROLE db_datawriter ADD MEMBER [dk-db-access];
ALTER ROLE db_ddladmin ADD MEMBER [dk-db-access];
GO