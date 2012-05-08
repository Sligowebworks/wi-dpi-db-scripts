if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblSuspensionsExpulsionsIncidentsSchools]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblSuspensionsExpulsionsIncidentsSchools]
GO

select [Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], 
'undupepupilcount' = sum([undupepupilcount]), 
'IncidentsSuspWeaponDrugYes' = sum([IncidentsSuspWeaponDrugYes]), 
'IncidentsSuspWeaponDrugNo' = sum([IncidentsSuspWeaponDrugNo]), 
'IncidentsSuspWeaponDrugYesDurationShort' = sum([IncidentsSuspWeaponDrugYesDurationShort]), 
'IncidentsSuspWeaponDrugYesDurationLong' = sum([IncidentsSuspWeaponDrugYesDurationLong]), 
'IncidentsSuspWeaponDrugNoDurationShort' = sum([IncidentsSuspWeaponDrugNoDurationShort]), 
'IncidentsSuspWeaponDrugNoDurationLong' = sum([IncidentsSuspWeaponDrugNoDurationLong]), 
'IncidentsExpWeaponDrugYes' = sum([IncidentsExpWeaponDrugYes]), 
'IncidentsExpWeaponDrugNo' = sum([IncidentsExpWeaponDrugNo]), 
'IncidentsSuspDurationLong' = sum([IncidentsSuspDurationLong]), 
'IncidentsSuspDurationShort' = sum([IncidentsSuspDurationShort]), 
'IncidentsExpDurationTotal' = sum([IncidentsExpDurationTotal]), 
'IncidentsTotalWeaponDrugYes' = sum([IncidentsTotalWeaponDrugYes]), 
'IncidentsTotalWeaponDrugNo' = sum([IncidentsTotalWeaponDrugNo]) 

into tblSuspensionsExpulsionsIncidentsSchools

from (

	SELECT [Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], 
	
	--[PupilNumSuspWeaponDrugYes], [PupilNumSuspWeaponDrugNo], [PupilNumSuspTotal], [PupilNumSuspDurationLong], [PupilNumSuspDurationShort], 
	--[PupilNumSuspDurationTotal], [IncidentsSuspWeaponDrugYes], [IncidentsSuspWeaponDrugNo], [IncidentsSuspWeaponDrugYesDurationShort], 
	--[IncidentsSuspWeaponDrugYesDurationLong], [IncidentsSuspWeaponDrugNoDurationShort], [IncidentsSuspWeaponDrugNoDurationLong], [IncidentsSuspTotal], 
	--[IncidentsSuspDurationLong], [IncidentsSuspDurationShort], [IncidentsSuspDurationTotal], [DaysSuspWeaponDrugYes], [DaysSuspWeaponDrugNo], [DaysSuspTotal], 
	--[DaysSuspDurationLong], [DaysSuspDurationShort], [DaysSuspDurationTotal] 
	
	isnull(IncidentsSuspWeaponDrugYes,0) as 'IncidentsSuspWeaponDrugYes', 
	isnull(IncidentsSuspWeaponDrugNo,0) as 'IncidentsSuspWeaponDrugNo', 
	isnull(IncidentsSuspWeaponDrugYesDurationShort,0) as 'IncidentsSuspWeaponDrugYesDurationShort', 
	isnull(IncidentsSuspWeaponDrugYesDurationLong,0) as 'IncidentsSuspWeaponDrugYesDurationLong',
	isnull(IncidentsSuspWeaponDrugNoDurationShort,0) as 'IncidentsSuspWeaponDrugNoDurationShort',
	isnull(IncidentsSuspWeaponDrugNoDurationLong,0) as 'IncidentsSuspWeaponDrugNoDurationLong',
	0 as 'IncidentsExpWeaponDrugYes', 
	0 as 'IncidentsExpWeaponDrugNo',
	isnull(IncidentsSuspDurationLong,0) as 'IncidentsSuspDurationLong', 
	isnull(IncidentsSuspDurationShort,0) as 'IncidentsSuspDurationShort',
	0 as 'IncidentsExpDurationTotal', 
	isnull(IncidentsSuspWeaponDrugYes,0) as 'IncidentsTotalWeaponDrugYes', 
	isnull(IncidentsSuspWeaponDrugNo,0) as 'IncidentsTotalWeaponDrugNo' 
	
	FROM [tblSuspensionsSchools]
	
	union all
	
	SELECT [Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], 
	
	--[PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [PupilNumExpTotal], [PupilNumExpDurationTotal], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], 
	--[IncidentsExpTotal], [IncidentsExpDurationTotal], [DaysExpWeaponDrugYes], [DaysExpWeaponDrugNo], [DaysExpTotal], [DaysExpDurationTotal] 
	
	0 as 'IncidentsSuspWeaponDrugYes', 
	0 as 'IncidentsSuspWeaponDrugNo', 
	0 as 'IncidentsSuspWeaponDrugYesDurationShort', 
	0 as 'IncidentsSuspWeaponDrugYesDurationLong',
	0 as 'IncidentsSuspWeaponDrugNoDurationShort',
	0 as 'IncidentsSuspWeaponDrugNoDurationLong',
	isnull(IncidentsExpWeaponDrugYes,0) as 'IncidentsExpWeaponDrugYes', 
	isnull(IncidentsExpWeaponDrugNo,0) as 'IncidentsExpWeaponDrugNo',
	0 as 'IncidentsSuspDurationLong', 
	0 as 'IncidentsSuspDurationShort',
	isnull(IncidentsExpDurationTotal,0) as 'IncidentsExpDurationTotal', 
	isnull(IncidentsExpWeaponDrugYes,0) as 'IncidentsTotalWeaponDrugYes', 
	isnull(IncidentsExpWeaponDrugNo,0) as 'IncidentsTotalWeaponDrugNo'
	
	FROM [tblExpulsionsSchools]

) x

group by [Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability]

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblSuspensionsExpulsionsIncidentsSchools]([Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [IncidentsSuspWeaponDrugYes], [IncidentsSuspWeaponDrugNo], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], [IncidentsSuspDurationLong], [IncidentsSuspDurationShort], [IncidentsExpDurationTotal], [IncidentsTotalWeaponDrugYes], [IncidentsTotalWeaponDrugNo]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblSuspensionsExpulsionsIncidentsSchools]  TO [netwisco]
GO



