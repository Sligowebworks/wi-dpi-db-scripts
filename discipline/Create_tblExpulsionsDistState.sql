-- this is Create_tblExpulsionsDistState.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblExpulsionsDistState]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblExpulsionsDistState]
GO

select *
into tblExpulsionsDistState
from (

	SELECT [Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], [PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [PupilNumExpTotal], [PupilNumExpDurationTotal], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], [IncidentsExpTotal], [IncidentsExpDurationTotal], [DaysExpWeaponDrugYes], [DaysExpWeaponDrugNo], [DaysExpTotal], [DaysExpDurationTotal] FROM [tblExpulsionsDistricts]
	union all 
	SELECT [Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], [PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [PupilNumExpTotal], [PupilNumExpDurationTotal], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], [IncidentsExpTotal], [IncidentsExpDurationTotal], [DaysExpWeaponDrugYes], [DaysExpWeaponDrugNo], [DaysExpTotal], [DaysExpDurationTotal] FROM [tblExpulsionsState]

) x 

order by [Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability] 

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblExpulsionsDistState]([Year], [FullKey], [Schooltype], [Grade], [Race], [Gender], [Disability], [undupepupilcount], [PupilNumExpWeaponDrugYes], [PupilNumExpWeaponDrugNo], [PupilNumExpDurationTotal], [IncidentsExpWeaponDrugYes], [IncidentsExpWeaponDrugNo], [DaysExpWeaponDrugYes], [DaysExpWeaponDrugNo], [DaysExpDurationTotal]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblExpulsionsDistState]  TO [netwisco]
GO



	
