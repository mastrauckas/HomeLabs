CREATE USER [sql-select-user] FROM EXTERNAL PROVIDER;
GRANT SELECT ON Logs TO [sql-select-user];