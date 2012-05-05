USE Wisconsin
GO
--v_ExpulsionsDaysLostSchoolDistState	Cubing				-> idea_flat
--"Number of Days Expelled"			-> DaysExpDurationTotal	-> DaysExpDurationTotal ->

SELECT [Number of Days Expelled], * FROM v_ExpulsionsDaysLostSchoolDistState WHERE (SchoolType in ('9')) AND AgencyType IN ('03', '04', '4C', '49', 'XX') AND (SexCode in ('9')) AND (RaceCode in ('9')) AND (GradeCode in ('99')) AND (DisabilityCode in ('9')) AND (year in ('2011')) AND (FullKey in ('XXXXXXXXXXXX'))

--	IncidentCountTotalNonWeaponDrug				-> IncidentsTotalWeaponDrugNo

SELECT * FROM v_SuspExpIncidentsWWoDisSchoolDistState WHERE (SchoolType in ('9')) AND AgencyType IN ('03', '04', '4C', '49', 'XX') AND (SexCode in ('9')) AND (RaceCode in ('9')) AND (GradeCode in ('99')) AND (DisabilityCode in ('9')) AND (year in ('2011')) AND (FullKey in ('XXXXXXXXXXXX'))


SELECT DISTINCT year FROM tblExpulsionsPKRolled ORDER BY year DESC

SELECT max(year) FROM IdeaFlat

SELECT DISTINCT year, IncidentsExpDurationTotal FROM ideaFLAT WHERE IncidentsExpDurationTotal <> 0

SELECT Duration FROM idea WHERE duration <> 'L' and Duration IS NOT NULL
SELECT DISTINCT Duration FROM idea






SELECT 
DISTINCT year
, DaysExpDurationTotal

FROM tblExpulsionsDistState

ORDER BY year DESC