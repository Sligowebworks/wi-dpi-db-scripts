-- this is ExpulsionsSchoolCubeAddCombinedGroups.sql
-- based on SuspensionsSchoolCubeAddCombinedGroups4.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblExpulsionsSchools]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblExpulsionsSchools]
GO

select * 
into tblExpulsionsSchools
from (

	SELECT [Year], [FullKey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], [PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [PupilNumExpTotal], [PupilNumExpDurationTotal], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], [IncidentsExpTotal], [IncidentsExpDurationTotal], [DaysExpWeaponDrugYes], [DaysExpWeaponDrugNo], [DaysExpTotal], [DaysExpDurationTotal] 
	FROM [tblExpulsionsSchoolCube] S 

	union 
	
	SELECT S.[Year], S.[FullKey], S.[Schooltype], S.[Grade], 'Race' = dbo.ConvertDPIRaceCodes('C', S.[Year]), S.[Gender], S.[Disability], 
	'undupepupilcount' = sum([undupepupilcount]), 
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

	FROM tblPubEnrWWoDisSuppressed E 
	full outer join [tblExpulsionsSchoolCube] S
	on E.[Year] = S.[Year] and E.[FullKey] = S.[FullKey] and E.[schooltype] = S.[schooltype] and rtrim(E.[Grade]) = rtrim(S.[Grade]) and rtrim(E.[Race]) = rtrim(S.[Race]) and E.[Gender] = S.[Gender] and E.[Disability] = S.[Disability] 
	
	where 
	-- test
	--E.year = '2004' and E.fullkey = '126615040100' and 
	E.grade in ('99') and E.race in ('0','1','2','3','4','5','6') and suppressed = -10 and S.fullkey is not null
	group by S.[Year], S.[FullKey], S.[schooltype], S.[Grade], S.[Gender], S.[Disability]
	
) x

order by [Year], [FullKey], [schooltype], [Grade], Race, [Gender], [Disability]
	
CREATE  UNIQUE  INDEX [AllClustered] ON [dbo].[tblExpulsionsSchools]([Year], [FullKey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], [PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], [DaysExpWeaponDrugYes], [DaysExpWeaponDrugNo], [DaysExpTotal], [DaysExpDurationTotal]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblExpulsionsSchools]  TO [netwisco]
GO
