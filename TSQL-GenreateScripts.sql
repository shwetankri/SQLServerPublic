#Use below to Grant execute permission to all the stored procedure to user test

#This is basically know-how to use SELECT with concatenation to generate scripts

SELECT ob.name, * , 'GRANT EXECUTE ON ' + sc.name + '.' + ob.name + ' TO test' 
FROM sys.objects ob
JOIN sys.schemas sc
ON ob.schema_id = sc.schema_id
WHERE type_desc = 'SQL_STORED_PROCEDURE'
