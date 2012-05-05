-- this is SuspensionsRollupPK.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblSuspensionsPKRolled]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblSuspensionsPKRolled]
GO

select *
into tblSuspensionsPKRolled
from (

SELECT [Suspensionkey], [agencykey], [year], 'grade' = '12', [race], [sex], [disability], [undupepupilcount], [fullkey], [ldisabled], [debug] 
FROM [Suspensions]
where cast(grade as int) < 16
group by [Suspensionkey], [agencykey], [year], [race], [sex], [disability], [undupepupilcount], [fullkey], [ldisabled], [debug] 
union 
SELECT [Suspensionkey], [agencykey], [year], [grade], [race], [sex], [disability], [undupepupilcount], [fullkey], [ldisabled], [debug] 
FROM [Suspensions]
where cast(grade as int) >= 16

) x

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblSuspensionsPKRolled]([Suspensionkey], [agencykey], [year], [grade], [race], [sex], [disability], [undupepupilcount], [fullkey], [ldisabled], [debug]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO


