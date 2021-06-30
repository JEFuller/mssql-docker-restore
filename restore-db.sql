RESTORE DATABASE JEFDAQ FROM DISK = '/var/opt/mssql/backup/db.bak' WITH
    MOVE '$(DataFile)' TO '/var/opt/mssql/data/main.mdf',
    MOVE '$(LogFile)' TO '/var/opt/mssql/data/main_log.ldf',
    REPLACE
GO