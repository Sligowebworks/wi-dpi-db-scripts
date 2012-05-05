USE Wisconsin
GO

SELECT DISTINCT year FROM tblExpulsionsPKRolled ORDER BY year DESC

SELECT max(year) FROM IdeaFlat

SELECT year, [IncidentsExpDurationTotal] FROM ideaFLAT WHERE year = 2011 and [IncidentsExpDurationTotal] <> 0




SELECT 
DISTINCT year
, DaysExpDurationTotal

FROM tblExpulsionsDistState

ORDER BY year DESC