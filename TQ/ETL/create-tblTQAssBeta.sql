-- this is TQAssCodeMorph.sql

select *

into tblTQAssBeta

from (

SELECT
[Year], [StaffKey], [WorkAgencyKey],
'LinkSubject' = (case [WMASCode] when 'LA' then 'ELA' when 'MA' then 'MATH' when 'SC' then 'SCI' when 'SS' then 'SOC' when 'FL' then 'FLANG' when 'AR' then 'ARTS' else 'XX' end),
[WiscLicenseStatus], [ESEAHighlyQualified], [ESAECoreCategory] as 'ESEACoreCategory', [FTE]
FROM [wisconsin].[dbo].[tblTQAss]
where rtrim([WMASCode]) in ('LA','MA','SC','SS','FL','AR')

union all

SELECT
[Year], [StaffKey], [WorkAgencyKey],
'LinkSubject' = 'ELSUBJ',
[WiscLicenseStatus], [ESEAHighlyQualified], [ESAECoreCategory], [FTE]
FROM [wisconsin].[dbo].[tblTQAss]
where rtrim([AssignmentCode]) = '0050'

union all

SELECT
[Year], [StaffKey], [WorkAgencyKey],
'LinkSubject' = 'SPCORE',
[WiscLicenseStatus], [ESEAHighlyQualified], [ESAECoreCategory], [FTE]
FROM [wisconsin].[dbo].[tblTQAss]
where rtrim([ESAECoreCategory]) <> 'n' and rtrim([ESAECoreCategory]) <> '' and rtrim([AssignmentType]) = 'SE'

union all

SELECT
[Year], [StaffKey], [WorkAgencyKey],
'LinkSubject' = 'CORESUM',
[WiscLicenseStatus], [ESEAHighlyQualified], [ESAECoreCategory], [FTE]
FROM [wisconsin].[dbo].[tblTQAss]
where rtrim([ESAECoreCategory]) <> 'n' and rtrim([ESAECoreCategory]) <> ''

union all

SELECT
[Year], [StaffKey], [WorkAgencyKey],
'LinkSubject' = 'SPSUM',
[WiscLicenseStatus], [ESEAHighlyQualified], [ESAECoreCategory], [FTE]
FROM [wisconsin].[dbo].[tblTQAss]
where [AssignmentType] = 'SE'

union all

SELECT
[Year], [StaffKey], [WorkAgencyKey],
'LinkSubject' = 'SUMALL',
[WiscLicenseStatus], [ESEAHighlyQualified], [ESAECoreCategory], [FTE]
FROM [wisconsin].[dbo].[tblTQAss]
--where rtrim([AssignmentCode]) <> '0001' -- used prior to 2012 (2011-12 import)
where rtrim([AssignmentCode]) <> '0970' -- as of 2011-12 import, and applied to previous years the same

) x
