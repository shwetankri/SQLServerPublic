#Script to change the job owner from the one in line 13 to sa

IF OBJECT_ID('tempdb.dbo.#SQLAgentOwner', 'U') IS NOT NULL
	DROP TABLE tempdb.dbo.#SQLAgentOwner

CREATE TABLE #SQLAgentOwner (Servername VARCHAR(100), Job_Name VARCHAR(200), Job_Owner VARCHAR(100))

INSERT INTO #SQLAgentOwner
SELECT @@ServerName, sj.name , sp.name 
	FROM msdb.dbo.sysjobs sj
	INNER JOIN sys.server_principals sp
ON sj.owner_sid = sp.sid
where sp.name = 'AccountToChange' -- Change the Account to the one you want to replace with sa

DECLARE @Job_namevar VARCHAR (100)

DECLARE Cursor_ChangeOwner CURSOR
	FOR SELECT Job_Name FROM #SQLAgentOwner

OPEN Cursor_ChangeOwner

FETCH NEXT FROM Cursor_ChangeOwner INTO @job_namevar		

WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC msdb..sp_update_job
        @job_name = @Job_namevar,
        @owner_login_name = 'sa'

		FETCH NEXT FROM Cursor_ChangeOwner INTO @Job_namevar
	END;

CLOSE Cursor_ChangeOwner

DEALLOCATE Cursor_ChangeOwner
DROP TABLE #SQLAgentOwner
