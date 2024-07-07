DROP USER IF EXISTS [sql-insert-identity] 
CREATE USER [sql-insert-identity] FROM EXTERNAL PROVIDER;
GRANT INSERT ON Logs TO [sql-insert-identity];