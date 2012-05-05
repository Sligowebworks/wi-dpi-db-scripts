select 
DetailKey, Year, 

-- must test for expulsion or suspensions with "and rtrim(Duration) <> '' and Duration is not null "
-- PupilNum
'PupilNumSuspWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then PupilNum else 0 end),
'PupilNumSuspWeaponDrugNo' = sum(case when WeaponDrug = 'N' and rtrim(Duration) <> '' and Duration is not null then PupilNum else 0 end),
'PupilNumSuspTotal' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then PupilNum when WeaponDrug = 'N' 
	and rtrim(Duration) <> '' and Duration is not null then PupilNum else 0 end),

'PupilNumExpWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then PupilNum else 0 end),
'PupilNumExpWeaponDrugNo' = sum(case when WeaponDrug = 'N' and (rtrim(Duration) = '' or Duration is null) then PupilNum else 0 end),
'PupilNumExpTotal' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then PupilNum when WeaponDrug = 'N' 
	and rtrim(Duration) <> '' and Duration is not null then PupilNum else 0 end),

'PupilNumSuspDurationLong' = sum(case Duration when 'L' then PupilNum else 0 end),
'PupilNumSuspDurationShort' = sum(case Duration when 'S' then PupilNum else 0 end),
'PupilNumSuspDurationTotal' = sum(case Duration when 'L' then PupilNum when 'S' then PupilNum else 0 end),

'PupilNumExpDurationTotal' = sum(case when (rtrim(Duration) = '' or rtrim(Duration) is null) then PupilNum else 0 end),

'PupilNumAllTotal' = sum(PupilNum),

--'PupilNumAllDurationTotal' = sum(cast(Duration as int)),

--

'IncidentsSuspWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then Incidents else 0 end),
'IncidentsSuspWeaponDrugNo' = sum(case when WeaponDrug = 'N' and rtrim(Duration) <> '' and Duration is not null then Incidents else 0 end),
-- forgotten columns
'IncidentsSuspWeaponDrugYesDurationShort' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) = 'S' then Incidents else 0 end),
'IncidentsSuspWeaponDrugYesDurationLong' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) = 'L' then Incidents else 0 end),
'IncidentsSuspWeaponDrugNoDurationShort' = sum(case when WeaponDrug = 'N' and rtrim(Duration) = 'S' then Incidents else 0 end),
'IncidentsSuspWeaponDrugNoDurationLong' = sum(case when WeaponDrug = 'N' and rtrim(Duration) = 'L' then Incidents else 0 end),
--
'IncidentsSuspTotal' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then Incidents when WeaponDrug = 'N' 
	and rtrim(Duration) <> '' and Duration is not null then Incidents else 0 end),

'IncidentsExpWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then Incidents else 0 end),
'IncidentsExpWeaponDrugNo' = sum(case when WeaponDrug = 'N' and (rtrim(Duration) = '' or Duration is null) then Incidents else 0 end),
'IncidentsExpTotal' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then Incidents when WeaponDrug = 'N' 
	and rtrim(Duration) <> '' and Duration is not null then Incidents else 0 end),

'IncidentsSuspDurationLong' = sum(case Duration when 'L' then Incidents else 0 end),
'IncidentsSuspDurationShort' = sum(case Duration when 'S' then Incidents else 0 end),
'IncidentsSuspDurationTotal' = sum(case Duration when 'L' then Incidents when 'S' then Incidents else 0 end),

'IncidentsExpDurationTotal' = sum(case when (rtrim(Duration) = '' or Duration is null) then Incidents else 0 end),

'IncidentsAllTotal' = sum(Incidents),

--'IncidentsAllDurationTotal' = sum(cast(Duration as int)),

--
'DaysSuspWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then Days else 0 end),
'DaysSuspWeaponDrugNo' = sum(case when WeaponDrug = 'N' and rtrim(Duration) <> '' and Duration is not null then Days else 0 end),
'DaysSuspTotal' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then Days when WeaponDrug = 'N' 
	and rtrim(Duration) <> '' and Duration is not null then Days else 0 end),

'DaysExpWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then Days else 0 end),
'DaysExpWeaponDrugNo' = sum(case when WeaponDrug = 'N' and (rtrim(Duration) = '' or Duration is null) then Days else 0 end),
'DaysExpTotal' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then Days when WeaponDrug = 'N' 
	and rtrim(Duration) <> '' and Duration is not null then Days else 0 end),

'DaysSuspDurationLong' = sum(case Duration when 'L' then Days else 0 end),
'DaysSuspDurationShort' = sum(case Duration when 'S' then Days else 0 end),
'DaysSuspDurationTotal' = sum(case Duration when 'L' then Days when 'S' then Days else 0 end),

'DaysExpDurationTotal' = sum(case when (rtrim(Duration) = '' or Duration is null) then Days else 0 end),

'DaysAllTotal' = sum(Days)

--'DaysAllDurationTotal' = sum(cast(Duration as float))

--

/*
'IncidentsSuspWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then Incidents else 0 end),
'IncidentsSuspWeaponDrugNo' = sum(case when WeaponDrug = 'N' and rtrim(Duration) <> '' and Duration is not null then Incidents else 0 end),
'IncidentsSuspTotal' = sum(case when WeaponDrug = 'Y' and rtrim(Duration) <> '' and Duration is not null then Incidents when WeaponDrug = 'N' 
	and rtrim(Duration) <> '' and Duration is not null then Incidents else 0 end),

'IncidentsExpWeaponDrugYes' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then Incidents else 0 end),
'IncidentsExpWeaponDrugNo' = sum(case when WeaponDrug = 'N' and (rtrim(Duration) = '' or Duration is null) then Incidents else 0 end),
'IncidentsExpTotal' = sum(case when WeaponDrug = 'Y' and (rtrim(Duration) = '' or Duration is null) then Incidents when WeaponDrug = 'N' 
	and rtrim(Duration) <> = then Incidents else 0 end),

'IncidentsSuspDurationLong' = sum(case Duration when 'L' then Incidents else 0 end),
'IncidentsSuspDurationShort' = sum(case Duration when 'S' then Incidents else 0 end),
'IncidentsSuspDurationTotal' = sum(case Duration when 'L' then Incidents when 'S' then Incidents else 0 end),

'IncidentsExpDuration' = sum(case rtrim(Duration) when '' then Incidents else 0 end),


'DaysSuspWeaponDrugYes' = sum(case WeaponDrug when 'Y' then Days else 0 end),
'DaysSuspWeaponDrugNo' = sum(case WeaponDrug when 'N' then Days else 0 end),
'DaysSuspWeaponDrugTotal' = sum(Days),
'DaysSuspDurationLong' = sum(case Duration when 'L' then Days else 0 end),
'DaysSuspDurationShort' = sum(case Duration when 'S' then Days else 0 end),
'DaysSuspDurationTotal' = sum(case Duration when 'L' then Days when 'S' then Days else 0 end)

*/
-- excluding expulsions here by excluding ''

into IdeaFlat
from idea 
group by DetailKey, Year
go

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[IdeaFlat]([DetailKey], [Year], [PupilNumSuspWeaponDrugYes], [PupilNumSuspWeaponDrugNo], [PupilNumSuspTotal], [PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [PupilNumExpTotal], [PupilNumSuspDurationLong], [PupilNumSuspDurationShort], [PupilNumSuspDurationTotal], [PupilNumExpDurationTotal], [PupilNumAllTotal], [IncidentsSuspWeaponDrugYes], [IncidentsSuspWeaponDrugNo], [IncidentsSuspTotal]) WITH  FILLFACTOR = 100 ON [PRIMARY]
go

 CREATE  UNIQUE  INDEX [YearDetailKey] ON [dbo].[IdeaFlat]([Year], [DetailKey]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
go

GRANT  SELECT  ON [dbo].[IdeaFlat]  TO [public]
go

GRANT  SELECT  ON [dbo].[IdeaFlat]  TO [netwisco]
go
