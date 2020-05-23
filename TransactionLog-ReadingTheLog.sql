SELECT	[Current LSN],
		Operation,
		Context,
		AllocUnitName,
		[Page ID], 
		[Slot ID], 
		[Transaction Name], 
		[Lock Information],
		Description 
FROM fn_dblog (NULL, NULL);
GO
