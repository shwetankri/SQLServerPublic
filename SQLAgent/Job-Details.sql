-- Query to find the important about SQL Server Agent Jobs on your server

SELECT	sj.name Job_Name,
		sj.description Job_Description, 
		lo.name Job_Owner, 
		sj.enabled Is_Enabled, 
		so.email_address Notification_EmailId, 
		sj.date_created Job_CreateDate, 
		sj.date_modified Job_ModifiedDate
FROM msdb.dbo.sysjobs sj
LEFT JOIN msdb.dbo.sysoperators so
		ON sj.notify_email_operator_id = so.id
LEFT JOIN sys.syslogins lo
		ON sj.owner_sid = lo.sid
