-- this is TeacherQualificationsAlpha43.sql - revision of 20031208m.sql
-- should be all subject-level, teacher-level rollups - next step should do school-level rollups by leaving out agencykey and staffkey
-- and summing on columns in TQAss and grouping on columns in TQStaff

-- this seems to be what I want - took out staff key from where
-- seems to do subject-level totals and staff data collapses properly - seems to be same as 20031208i.sql, but has staffkey in the resultset

-- in 20031208i.sql, took staff key out of the where and the select, continuing to group on it - does this do it the way I want?
-- total experience number per below match up - looks good
-- select sum(totalexperience) from tbltqstaff where staffkey in (select distinct staffkey from tbltqass where workagencykey = '52888' and ESAECoreCategory = 'LA')

-- in 20031208j.sql, took staff key out of the group by - does this do it the way I want? - no - pulling some bad numbers per below
-- select sum(totalexperience) from tbltqstaff where staffkey in (select distinct staffkey from tbltqass where workagencykey = '52888' and ESAECoreCategory = 'LA')

---- check with Jean:
-- per assignment counts - same teacher, two different assignments, the two are added together
-- LicenseTotal, LicenseFull, LicenseEmer, LicenseNo, EHQTotal, EHQYes, EHQNo

-- per teacher counts - same teacher, two different assignments, the two are not added together, the value for the teacher comes through un-aggregated
--FTE, FTE5YearsOrMoreLocal, FTE5YearsOrMoreTotal, LocalExperience, TotalExperience, DegreeHighSchool, DegreeAssoc, DegreeBach,  DegreeMast,  Degree6YrSpec, DegreeDoc,
--DegreeOther, DegreeN

SELECT
[wisconsin].[dbo].[tblTQAssBeta].[Year], agency.agencykey, agency.FullKey,
[tblTQAssBeta].[StaffKey],
agency.District,
-- files have all school-level/teacher-level data - except for some teachers that are assigned to districts, not to schools - padding these rows with X for no school - is this right?
-- also must group by this case statement
'School' = (case rtrim(agency.School) when '' then 'XXXX' else agency.School end),
-- files have all school-level/teacher-level data - except for some teachers that are assigned to districts, not to schools
-- these numbers must be aggregated into district-level rollups, to show when schooltype = district summary - using 0 as a placeholder for this
-- also morphing schooltypes 4 to 5
-- also must group by this case statement
'SchoolType' = (case rtrim(agency.SchoolType) when '' then '0' when '4' then '5' else agency.SchoolType end),
--[AssignmentType], [AssignmentCode], [WMASCode], [ESAECoreCategory],
[LinkSubject],

'Race' = (case [Race] when 'I' then '1' when 'A' then '2' when 'B' then '3' when 'H' then '4' when 'W' then '5' when 'n' then '8' else '8' end),
'Gender' = (case [Gender] when 'F' then '1' when 'M' then '2' when 'n' then '8' else '8' end),
-- count? sum? max?
count([WiscLicenseStatus]) as [LicenseTotal],
sum(case [WiscLicenseStatus] when 'F' then 1 else 0 end) as [LicenseFull],
sum(case [WiscLicenseStatus] when 'E' then 1 else 0 end) as [LicenseEmer],
sum(case [WiscLicenseStatus] when 'U' then 1 else 0 end) as [LicenseNo],
count([ESEAHighlyQualified]) as EHQTotal,
sum(case [ESEAHighlyQualified] when 'Y' then 1 else 0 end) as [ESEAHQYes],
sum(case [ESEAHighlyQualified] when 'N' then 1 else 0 end) as [ESEAHQNo],
sum(CASE WHEN [ESEACoreCategory]  = 'N' OR [ESEACoreCategory] = '' OR [ESEACoreCategory] IS NULL THEN 0 ELSE [FTE] END) as [ESEACoreFTE],
sum([FTE]) as 'FTE',
sum(case [WiscLicenseStatus] when 'F' then cast([FTE] as decimal(5,2)) else 0 end) as 'FTELicenseFull',
sum(case [WiscLicenseStatus] when 'E' then cast([FTE] as decimal(5,2)) else 0 end) as 'FTELicenseEmer',
sum(case [WiscLicenseStatus] when 'U' then cast([FTE] as decimal(5,2)) else 0 end) as 'FTELicenseNo',
sum(case [ESEAHighlyQualified] when 'Y' then cast([FTE] as decimal(5,2)) else 0 end) as 'FTE_ESEA_HQYes',
sum(case [ESEAHighlyQualified] when 'N' then cast([FTE] as decimal(5,2)) else 0 end) as 'FTE_ESEA_HQNo',
sum(CASE WHEN [ESEACoreCategory]  <> 'N' AND [ESEACoreCategory] <> '' AND [ESEACoreCategory] IS NOT NULL AND [ESEAHighlyQualified] = 'Y' THEN cast([FTE] as decimal(5,2)) ELSE 0 END) as [FTE_ESEACoreHQYes],
sum(CASE WHEN [ESEACoreCategory]  <> 'N' AND [ESEACoreCategory] <> '' AND [ESEACoreCategory] IS NOT NULL AND [ESEAHighlyQualified] = 'N' THEN cast([FTE] as decimal(5,2)) ELSE 0 END) as [FTE_ESEACoreHQNo],
sum(case when cast([LocalExperience] as int) >= 5 then cast([FTE] as decimal(5,2)) else 0 end) as 'FTE5YearsOrMoreLocal',
sum(case when cast([TotalExperience] as int) >= 5 then cast([FTE] as decimal(5,2)) else 0 end) as 'FTE5YearsOrMoreTotal',
sum(case when [HighestDegreeEarned] in ('5','6','7')  then cast([FTE] as decimal(5,2)) else 0 end) as 'FTEDegreeMastersOrHigher',
[LocalExperience],
[TotalExperience],
DegreeHighSchool = max(case [HighestDegreeEarned] when '2' then 1 else 0 end),
DegreeAssoc = max(case [HighestDegreeEarned] when '3' then 1 else 0 end),
DegreeBach = max(case [HighestDegreeEarned] when '4' then 1 else 0 end),
DegreeMast = max(case [HighestDegreeEarned] when '5' then 1 else 0 end),
Degree6YrSpec = max(case [HighestDegreeEarned] when '6' then 1 else 0 end),
DegreeDoc = max(case [HighestDegreeEarned] when '7' then 1 else 0 end),
DegreeOther = max(case [HighestDegreeEarned] when '8' then 1 else 0 end),
DegreeN = max(case [HighestDegreeEarned] when 'n' then 1 else 0 end)

into tblTeacherQualificationsAlpha

FROM [wisconsin].[dbo].[tblTQAssBeta]
inner join [wisconsin].[dbo].[tblTQStaff] on [wisconsin].[dbo].[tblTQAssBeta].[StaffKey] = [wisconsin].[dbo].[tblTQStaff].[StaffKey] and [wisconsin].[dbo].[tblTQAssBeta].[Year] = [wisconsin].[dbo].[tblTQStaff].[Year]
-- Jean confirms that WorkAgencyKey is the right one - takes rows from 77,036 down to 75,797
inner join agency on [wisconsin].[dbo].[tblTQAssBeta].Year = agency.year and [wisconsin].[dbo].[tblTQAssBeta].WorkAgencyKey = agency.agencykey

--where
-- test where
--[wisconsin].[dbo].[tblTQAssBeta].[Year] = '2003' and district = '3619' --and schooltype = '3' --and WMASCODE = 'LA' and race = 'W' and gender = 'M'
--and
-- where for this grouping
--rtrim([ESAECoreCategory]) in ('LA','MA','SC','SS','FL','AR') and

--Agencykey = '52888' and rtrim(race) = 'W' and gender = 'M' and [tblTQAssBeta].staffkey = '955149'
--Agencykey = '52888' and LinkSubject = 'ELA'

--group by [wisconsin].[dbo].[tblTQAssBeta].[Year], agency.agencykey, agency.FullKey, [tblTQAssBeta].[StaffKey], agency.District, agency.School, agency.SchoolType,
--[LinkSubject], [Race], [Gender], [LocalExperience], [TotalExperience]

group by [wisconsin].[dbo].[tblTQAssBeta].[Year], agency.agencykey, agency.FullKey, [tblTQAssBeta].[StaffKey], agency.District, ESEACoreCategory,
--agency.School,
(case rtrim(agency.School) when '' then 'XXXX' else agency.School end),
--agency.SchoolType,
(case rtrim(agency.SchoolType) when '' then '0' when '4' then '5' else agency.SchoolType end),
[LinkSubject], [Race], [Gender], [LocalExperience], [TotalExperience]


