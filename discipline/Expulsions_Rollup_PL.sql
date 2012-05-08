-- this is ExpulsionsRollupPK.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblExpulsionsPKRolled]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblExpulsionsPKRolled]
GO

select *
into tblExpulsionsPKRolled
from (

SELECT [ExpulsionKey], [AgencyKey], [Year], 'Grade' = '12', [Race], [Sex], [Disability], [UndupPupilCount], [FullKey], [ldisabled] 
FROM [Expulsions]
where cast(grade as int) < 16
group by [ExpulsionKey], [AgencyKey], [Year], [Race], [Sex], [Disability], [UndupPupilCount], [FullKey], [ldisabled] 
union
SELECT [ExpulsionKey], [AgencyKey], [Year], [Grade], [Race], [Sex], [Disability], [UndupPupilCount], [FullKey], [ldisabled] 
FROM [Expulsions]
where cast(grade as int) >= 16

) x 

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblExpulsionsPKRolled]([ExpulsionKey], [AgencyKey], [Year], [Grade], [Race], [Sex], [Disability], [UndupPupilCount], [FullKey], [ldisabled]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

