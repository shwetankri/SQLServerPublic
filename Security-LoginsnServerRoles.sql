SELECT sp.name Login_Name
	,Account_Type = CASE sp.type_desc
		WHEN 'Windows_Group'
			THEN 'AD Group'
		WHEN 'WINDOWS_LOGIN'
			THEN 'AD User'
		ELSE 'SQL Login'
		END
	,CASE 
		WHEN sysadmin = 1
			THEN 'Yes'
		ELSE 'No'
		END AS Sysadmin
	,CASE 
		WHEN securityadmin = 1
			THEN 'Yes'
		ELSE 'No'
		END AS securityadmin
	,CASE 
		WHEN serveradmin = 1
			THEN 'Yes'
		ELSE 'No'
		END AS serveradmin
	,CASE 
		WHEN setupadmin = 1
			THEN 'Yes'
		ELSE 'No'
		END AS setupadmin
	,CASE 
		WHEN processadmin = 1
			THEN 'Yes'
		ELSE 'No'
		END AS processadmin
	,CASE 
		WHEN diskadmin = 1
			THEN 'Yes'
		ELSE 'No'
		END AS diskadmin
	,CASE 
		WHEN dbcreator = 1
			THEN 'Yes'
		ELSE 'No'
		END AS dbcreator
	,CASE 
		WHEN bulkadmin = 1
			THEN 'Yes'
		ELSE 'No'
		END AS bulkadmin
FROM sys.syslogins sl
JOIN sys.server_principals sp ON sl.sid = sp.sid
WHERE sp.name NOT LIKE '%##%'
	AND sp.name NOT LIKE '%NT%'
