-- this is ExpulsionsSchoolCubing-2010-11-19.sql
-- derived from SuspensionsSchoolCubing-2009-09-01-E.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblExpulsionsSchoolCube]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblExpulsionsSchoolCube]
GO

select * 
into tblExpulsionsSchoolCube
from (

	SELECT 
	E.Year, 
	E.FullKey, 
	A.Schooltype, 
	'Grade' = (case grouping(E.Grade) when 1 then '99' else Grade end),
	'Race' = (case grouping(E.Race) when 1 then '9' else Race end),
	'Gender' = (case grouping(E.sex) when 1 then '9' else Sex end),
	'Disability' = (case grouping(E.ldisabled) when 1 then '9' else E.ldisabled end),
	--[Suspensionkey], 
	--IdeaFlat.detailkey, 
	
	--'Economic_disadvantaged' = (case grouping(E.[Economic_disadvantaged]) when 1 then '9' else E.[Economic_disadvantaged] end),
	--'English_language_level' = (case grouping(E.[English_language_level]) when 1 then '9' else E.[English_language_level] end),
	--'ELP_more_than_2_years' = (case grouping(E.[ELP_more_than_2_years]) when 1 then '9' else E.[ELP_more_than_2_years] end),
	--'Fay_school' = (case grouping(E.[Fay_school]) when 1 then '9' else E.[Fay_school] end),
	--'Fay_district' = (case grouping(E.[Fay_district]) when 1 then '9' else E.[Fay_district] end),
	--'Fay_state' = (case grouping(E.[Fay_state]) when 1 then '9' else E.[Fay_state] end), 
	
	-- leftover from Dropouts
	--'Completed_School_Term' = sum([Completed_School_Term]), 
	--'Dropouts' = sum(E.Dropouts), 
	--'Cohort_dropouts' = sum([Cohort_dropouts])

	'undupepupilcount' = sum(E.unduppupilcount), 
	'PupilNumExpWeaponDrugYes' = sum([PupilNumExpWeaponDrugYes]), 
	'PupilNumExpWeaponDrugNo' = sum([PupilNumExpWeaponDrugNo]), 
	'PupilNumExpTotal' = sum([PupilNumExpTotal]), 
	'PupilNumExpDurationTotal' = sum([PupilNumExpDurationTotal]), 
	'IncidentsExpWeaponDrugYes' = sum([IncidentsExpWeaponDrugYes]), 
	'IncidentsExpWeaponDrugNo' = sum([IncidentsExpWeaponDrugNo]), 
	'IncidentsExpTotal' = sum([IncidentsExpTotal]), 
	'IncidentsExpDurationTotal' = sum([IncidentsExpDurationTotal]), 
	'DaysExpWeaponDrugYes' = sum([DaysExpWeaponDrugYes]), 
	'DaysExpWeaponDrugNo' = sum([DaysExpWeaponDrugNo]), 
	'DaysExpTotal' = sum([DaysExpTotal]), 
	'DaysExpDurationTotal' = sum([DaysExpDurationTotal]) 
	
	FROM tblExpulsionsPKRolled E
	inner join tblAgencyFull A on E.year = A.year and E.fullkey = A.fullkey
	inner join IdeaFlat on E.year = IdeaFlat.year and E.expulsionkey = IdeaFlat.detailkey 
	--where E.year = '2003' and left(E.fullkey,8) = '01361904'
	--where E.year = '2003' and E.fullkey = '013619040022'
	
	-- stripping out districts in source - only for school rollups
	--where isnull(A.Schooltype,'0') <> '0'
	where right(E.fullkey,1) <> 'X'
	
	-- test 
	--and E.year = '2008' and E.fullkey = '010714040020'
	--and E.fullkey = '010714040020'
	
	group by E.Year, E.FullKey, A.Schooltype, E.Grade, E.Race, E.Sex, E.ldisabled 
	--, [Suspensionkey], IdeaFlat.detailkey 
	
	-- these are null for now, leaving out...
	--, E.[Economic_disadvantaged], E.[English_language_level], [ELP_more_than_2_years], [Fay_school], [Fay_district], [Fay_state]
	
	with cube
	having E.year is not null and E.fullkey is not null and A.Schooltype is not null
	
	-- now filter out fact rows from cube output
	-- wherever "X is not null" - must AND to "(X is not null or (X is null and grouping(X) = 0))" - to include nulls indicating unreported data - better to replace these N/A nulls with 0s?
	and (
	(grade is null and grouping(E.Grade) = 1 and race is null and grouping(E.Race) = 1 and sex is null and grouping(E.Sex) = 1 and ldisabled is null and grouping(E.ldisabled) = 1 
	--and Economic_disadvantaged is null and grouping(E.Economic_disadvantaged) = 1 and English_language_level is null and grouping(E.English_language_level) = 1
	) or 
	((grade is not null or (grade is null and grouping(E.Grade) = 0)) and race is null and grouping(E.Race) = 1 and sex is null and grouping(E.Sex) = 1 and ldisabled is null and grouping(E.ldisabled) = 1
	--and Economic_disadvantaged is null and grouping(E.Economic_disadvantaged) = 1 and English_language_level is null and grouping(E.English_language_level) = 1
	) or 
	(grade is null and grouping(E.Grade) = 1 and (race is not null or (race is null and grouping(race) = 0)) and sex is null and grouping(E.Sex) = 1 and ldisabled is null and grouping(E.ldisabled) = 1
	--and Economic_disadvantaged is null and grouping(E.Economic_disadvantaged) = 1 and English_language_level is null and grouping(E.English_language_level) = 1
	) or 
	(grade is null and grouping(E.Grade) = 1 and race is null and grouping(E.Race) = 1 and (sex is not null or (sex is null and grouping(sex) = 0)) and ldisabled is null and grouping(E.ldisabled) = 1
	--and Economic_disadvantaged is null and grouping(E.Economic_disadvantaged) = 1 and English_language_level is null and grouping(E.English_language_level) = 1
	) or 
	-- adding constraint for year - no disability breakouts before year 2003
	(grade is null and grouping(E.Grade) = 1 and race is null and grouping(E.Race) = 1 and sex is null and grouping(E.Sex) = 1 and (ldisabled is not null or (ldisabled is null and grouping(ldisabled) = 0)) 
	--and Economic_disadvantaged is null and grouping(E.Economic_disadvantaged) = 1 and English_language_level is null and grouping(E.English_language_level) = 1 and E.year > 2002
	) 
	--or 
	
	-- adding constraint for year - no disability breakouts before year 2004
	--(grade is null and grouping(E.Grade) = 1 and race is null and grouping(E.Race) = 1 and gender is null and grouping(E.Sex) = 1 and disability is null and grouping(E.Disability) = 1 
	--and (Economic_disadvantaged is not null or (Economic_disadvantaged is null and grouping(Economic_disadvantaged) = 0)) and English_language_level is null and grouping(E.English_language_level) = 1 and E.year > 2003) or 
	-- adding constraint for year - no disability breakouts before year 2004
	--(grade is null and grouping(E.Grade) = 1 and race is null and grouping(E.Race) = 1 and gender is null and grouping(E.Sex) = 1 and disability is null and grouping(E.Disability) = 1 
	--and Economic_disadvantaged is null and grouping(E.Economic_disadvantaged) = 1 and (English_language_level is not null or (English_language_level is null and grouping(E.English_language_level) = 0)) and E.year > 2003)
	)


) x

order by Year, FullKey, Schooltype, Grade, Race, Gender, Disability
--, Suspensionkey --, E.Economic_disadvantaged, E.English_language_level

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblExpulsionsSchoolCube]([Year], [FullKey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], [PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [PupilNumExpDurationTotal], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], [DaysExpWeaponDrugYes], [DaysExpWeaponDrugNo], [DaysExpDurationTotal]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblExpulsionsSchoolCube]  TO [netwisco]
GO



