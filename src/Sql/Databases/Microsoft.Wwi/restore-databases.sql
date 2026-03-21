-- ================================================================================
-- Restore Databases
--
-- Docker Commands
--
-- Copy backups into the container:
-- > docker cp C:\Temp\Backups\WideWorldImporters-Full.bak sql-server-mssql-1:/var/opt/demo/mssql/backup
-- > docker cp C:\Temp\Backups\WideWorldImportersDW-Full.bak sql-server-mssql-1:/var/opt/demo/mssql/backup
--
-- Connect to the container command session:
-- > docker exec -it -u 0 sql-server-mssql-1 /bin/bash
-- ================================================================================

--
-- OLTP
--
ALTER DATABASE [WideWorldImporters]
	SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;
GO

RESTORE DATABASE [WideWorldImporters]
	FROM DISK = N'/var/opt/demo/mssql/backup/WideWorldImporters-Full.bak'
	WITH
		MOVE N'WWI_Primary'         TO N'/var/opt/demo/mssql/data/WideWorldImporters.mdf',
		MOVE N'WWI_UserData'        TO N'/var/opt/demo/mssql/data/WideWorldImporters_UserData.ndf',
		MOVE N'WWI_InMemory_Data_1' TO N'/var/opt/demo/mssql/data/WideWorldImporters_InMemory_Data_1.imf',
		MOVE N'WWI_Log'             TO N'/var/opt/demo/mssql/log/WideWorldImporters.ldf',
		REPLACE;
GO

ALTER DATABASE [WideWorldImporters]
	SET MULTI_USER;
GO

--
-- Data Warehouse
--
ALTER DATABASE [WideWorldImportersDW]
	SET SINGLE_USER
	WITH ROLLBACK IMMEDIATE;
GO

RESTORE DATABASE [WideWorldImportersDW]
	FROM DISK = N'/var/opt/demo/mssql/backup/WideWorldImportersDW-Full.bak'
	WITH
		MOVE N'WWI_Primary'           TO N'/var/opt/demo/mssql/data/WideWorldImportersDW.mdf',
		MOVE N'WWI_UserData'          TO N'/var/opt/demo/mssql/data/WideWorldImportersDW_UserData.ndf',
		MOVE N'WWIDW_InMemory_Data_1' TO N'/var/opt/demo/mssql/data/WideWorldImportersDW_InMemory_Data_1.imf',
		MOVE N'WWI_Log'               TO N'/var/opt/demo/mssql/log/WideWorldImportersDW.ldf',
		REPLACE;
GO

ALTER DATABASE [WideWorldImportersDW]
	SET MULTI_USER;
GO
