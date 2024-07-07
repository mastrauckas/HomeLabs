DROP USER IF EXISTS [sql-select-identity] 
CREATE USER [sql-select-identity] FROM EXTERNAL PROVIDER;
GRANT SELECT ON Logs TO [sql-select-identity];