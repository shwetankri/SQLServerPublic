-- SQL Agent Job Template for Always-On environment
-- Created By Shwetank Singh
-- Remove Line 9 and Replace 10-16  with your code
-- I prefer adding this information into the log that this job is skipped as the server is not PRIMARY

DECLARE @AORole VARCHAR(20) = 'PRIMARY';
DECLARE @Message NVARCHAR(100) = 'Executing is running on Primary'
IF @AORole = (SELECT role_desc FROM sys.dm_hadr_availability_replica_states WHERE is_local=1 AND role=1)
	PRINT 'Primary Server'
	/*
	Your Job code here
	.
	.
	.
	.
	*/
ELSE 
	EXEC xp_logevent 60000, @Message, informational
