CREATE USER [sql-insert-user] FROM EXTERNAL PROVIDER;
GRANT INSERT ON Logs TO [sql-insert-user];