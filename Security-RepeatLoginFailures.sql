SET NOCOUNT ON

	DECLARE @ErrorLogCount INT 
	DECLARE @LastLogDate DATETIME

	DECLARE @ErrorLogInfo TABLE (
	LogDate DATETIME
	,ProcessInfo NVARCHAR (50)
	,[Text] NVARCHAR (MAX)
	)
   
	DECLARE @EnumErrorLogs TABLE (
	[Archive#] INT
	,[Date] DATETIME
	,LogFileSizeMB INT
	)

	CREATE TABLE #FailedLogins 
	(
	Server_Name nVARCHAR(100),
	NumberofAttempts int,
	Details nVARCHAR(500),
	MinLogDate DateTime,
	MaxLogDate DateTime
	)

	INSERT INTO @EnumErrorLogs
	EXEC sp_enumerrorlogs

	SELECT @ErrorLogCount = MIN([Archive#]), @LastLogDate = MAX([Date])
	FROM @EnumErrorLogs

	WHILE @ErrorLogCount IS NOT NULL
	BEGIN

		INSERT INTO @ErrorLogInfo
		EXEC sp_readerrorlog @ErrorLogCount

		SELECT @ErrorLogCount = MIN([Archive#]), @LastLogDate = MAX([Date])
		FROM @EnumErrorLogs
		WHERE [Archive#] > @ErrorLogCount
		AND @LastLogDate > getdate() - 5
  
	END

	INSERT INTO #FailedLogins
	SELECT @@servername as Server_Name, COUNT (Text) AS NumberOfAttempts, Text AS Details, MIN(LogDate) as MinLogDate, 	MAX(LogDate) as MaxLogDate
	FROM @ErrorLogInfo
	WHERE ProcessInfo = 'Logon'
	AND Text LIKE '%fail%'
	AND LogDate > getdate() - 5
	GROUP BY Text, CAST(LogDate as Date)
	ORDER BY NumberOfAttempts DESC;

	WITH CTE AS
	(
		SELECT Server_Name, NumberofAttempts, Details, MinLogDate, MaxLogDate, RANK() OVER (Partition by Details Order BY  MinLogdate) RepeatOff
		FROM #failedlogins
	)
	SELECT *
	FROM CTE
	WHERE RepeatOff = 5

	DROP TABLE #failedlogins
SET NOCOUNT OFF
