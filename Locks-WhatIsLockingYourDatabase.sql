--Change the Database_in_Q to your database name

SELECT request_session_id 
FROM sys.dm_tran_locks 
WHERE resource_database_id=DB_ID('Database_in_Q');
