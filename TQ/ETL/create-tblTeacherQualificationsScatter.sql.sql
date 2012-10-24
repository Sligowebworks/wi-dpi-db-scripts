-- this is tblTeacherQualificationScatterMake46_RC10-C.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tblTeacherQualificationsScatter]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tblTeacherQualificationsScatter]
go

select *

into tblTeacherQualificationsScatter

from

(

-- this is tblTeacherQualificationScatterMake45.sql
-- should this really pass nulls? is null a flag for the graph to ignore the number?
-- yes = null flags for n/a and "--" - see view
-- if there are 0 students with a particular group for the nominator

-- jdj 20040414 - per jean email of 4/8/04, changing "where year =" to show most recent year, regardless of year of TQ data
-- jdj 20040506 - per Jean email of 5/4/2004, changing "where year =" again - see also TQScatterYearFix.sql

-- district spending - district rows
-- note - pulls data for Memship most-recent year - may not be same as most-recent year for expend or schools
-- should work as long as Memship year is not greater than Expend most-recent Year or schools most-recent year
-- jdj 20040506 - per above - not true anymore?
SELECT
[Memship].[Year], [Memship].[FullKey], schooltypes.schooltype,
'RelateToKey' = 'SPND',
([Expend].[Instruction] + [Expend].[Support] + [Expend].[Admin]) as 'RelateToNumerator', [Memship].[Memship] as 'RelateToDenominator',
'RelateToValue' = cast((([Expend].[Instruction] + [Expend].[Support] + [Expend].[Admin]) / [Memship].[Memship]) as decimal(12,2))
FROM (select '3' as 'SchoolType' union select '5' as 'SchoolType' union select '6' as 'SchoolType' union select '7' as 'SchoolType' union select '9' as 'SchoolType') schooltypes,
[Memship] inner join [Expend] on [Memship].[Year] = [Expend].[Year]
and [Memship].[District] = [Expend].[District]
--where [Memship].year >= (select min(year) from tblteacherqualifications) and [Memship].year <= (select max(year) from tblteacherqualifications)
where [Memship].year =
--(select max(year) from [Memship])
(select case when ((select max(year) from [Memship]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [Memship]) end)
and left([Memship].fullkey,1) <> 'X'

union all

-- district spending - faux school rows showing district-level data - so district-level will show on school-level view
-- note - pulls data for Memship most-recent year - may not be same as most-recent year for expend or schools
-- should work as long as Memship year is not greater than Expend most-recent Year or schools most-recent year
SELECT
[Memship].[Year], [Schools].[FullKey],
-- [Schools].[SchoolType]
(case [Schools].[SchoolType] when '4' then '5' else [Schools].[SchoolType] end) as 'SchoolType',
'RelateToKey' = 'SPND', -- 'RelateToLabel' = 'District Spending',
([Expend].[Instruction] + [Expend].[Support] + [Expend].[Admin]) as 'RelateToNumerator', [Memship].[Memship] as 'RelateToDenominator',
'RelateToValue' = cast((([Expend].[Instruction] + [Expend].[Support] + [Expend].[Admin]) / [Memship].[Memship]) as decimal(12,2))
FROM [Memship]
inner join [Expend] on [Memship].[Year] = [Expend].[Year]
and [Memship].[District] = [Expend].[District]
inner join schools on [Memship].[Year] = [Schools].[Year] and [Memship].[District] = [Schools].[District]
--where [Memship].year >= (select min(year) from tblteacherqualifications) and [Memship].year <= (select max(year) from tblteacherqualifications)
where [Memship].year =
--(select max(year) from [Memship])
(select case when ((select max(year) from [Memship]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [Memship]) end)
and rtrim(schooltype) <> ''

union all

-- district size - district-level rows
SELECT [YEAR], [FULLKEY], schooltypes.schooltype, 'RelateToKey' = 'DSZE', -- 'RelateToLabel' = 'District Size',
[ENROLLMENT] as 'RelateToNumerator', enrollment as 'RelateToDenominator', 'RelateToValue' = [ENROLLMENT]
FROM [enrollment], (select '3' as 'SchoolType' union select '5' as 'SchoolType' union select '6' as 'SchoolType' union select '7' as 'SchoolType' union select '9' as 'SchoolType') schooltypes
--where [enrollment].year >= (select min(year) from tblteacherqualifications) and [enrollment].year <= (select max(year) from tblteacherqualifications)
where [enrollment].year =
--(select max(year) from [enrollment])
(select case when ((select max(year) from [enrollment]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [enrollment]) end)
and left(fullkey,1) <> 'X' and right(fullkey,1) = 'X' and grade = '99' and sex = '9' and race = '9'

union all

-- district size - district-level rows
SELECT schools.[YEAR], schools.[FULLKEY],
--schools.schooltype,
'Schooltype' = (case schools.Schooltype when '4' then '5' else schools.Schooltype end),
'RelateToKey' = 'DSZE',
DistCounts.[ENROLLMENT] as 'RelateToNumerator', DistCounts.enrollment as 'RelateToDenominator', 'RelateToValue' = DistCounts.[ENROLLMENT]
FROM schools
inner join
	(
	SELECT [YEAR], [FULLKEY], schooltypes.schooltype, 'RelateToKey' = 'DSZE', -- 'RelateToLabel' = 'District Size',
	[ENROLLMENT] --as 'RelateToNumerator', enrollment as 'RelateToDenominator', 'RelateToValue' = [ENROLLMENT]
	FROM [enrollment], (select '3' as 'SchoolType' union select '5' as 'SchoolType' union select '6' as 'SchoolType' union select '7' as 'SchoolType' union select '9' as 'SchoolType') schooltypes
	--where [enrollment].year >= (select min(year) from tblteacherqualifications) and [enrollment].year <= (select max(year) from tblteacherqualifications)
	where [enrollment].year =
	--(select max(year) from [enrollment])
	(select case when ((select max(year) from [enrollment]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [enrollment]) end)
	and left(fullkey,1) <> 'X' and right(fullkey,1) = 'X' and grade = '99' and sex = '9' and race = '9'
	) DistCounts
on schools.year = DistCounts.year and left(schools.fullkey,6) = left(DistCounts.fullkey,6)
--and schools.schooltype = DistCounts.schooltype
and (case schools.Schooltype when '4' then '5' else schools.Schooltype end) = DistCounts.schooltype
--where schools.year >= (select min(year) from tblteacherqualifications) and schools.year <= (select max(year) from tblteacherqualifications)
where schools.year =
--(select max(year) from schools)
(select case when ((select max(year) from schools) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from schools) end)
and left(schools.fullkey,1) <> 'X' and right(schools.fullkey,1) <> 'X' --and grade = '99' and sex = '9' and race = '9'

union all

-- school size
SELECT [enrollment].[YEAR], [enrollment].[FULLKEY],
'Schooltype' = (case schools.Schooltype when '4' then '5' else schools.Schooltype end),
'RelateToKey' = 'SSZE', --'RelateToLabel' = 'School Size',
[ENROLLMENT] as 'RelateToNumerator', enrollment as 'RelateToDenominator',
'RelateToValue' = [ENROLLMENT]
FROM [enrollment]
inner join schools on [enrollment].year = schools.year and [enrollment].fullkey = schools.fullkey
--where (grade = '70' or grade = '71' or grade = '72' or grade = '73' or grade = '99') and sex = '9' and (race = '1' or race = '2' or race = '3' or race = '4' or race = '5' or race = '9')
--where [enrollment].year >= (select min(year) from tblteacherqualifications) and [enrollment].year <= (select max(year) from tblteacherqualifications)
where [enrollment].year =
--(select max(year) from [enrollment])
(select case when ((select max(year) from [enrollment]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [enrollment]) end)
and left([enrollment].fullkey,1) <> 'X' and right([enrollment].fullkey,1) <> 'X' and (grade = '70' or grade = '71' or grade = '72' or grade = '73' or grade = '99') and sex = '9' and race = '9'

union all

-- EconStatus
SELECT enrollment.[year], enrollment.[fullkey],
--'Schooltype' = (case enrollment.grade when '70' then '6' when '71' then '5' when '72' then '3' when '73' then '7' when '99' then (case right(enrollment.fullkey,1) when 'X' then '9' else schools.schooltype end) end),
'Schooltype' = 	(case enrollment.grade 	when '70' then '6' when '71' then '5' when '72' then '3' when '73' then '7' when '99' then (case right(enrollment.fullkey,1) when 'X' then '9'
else (case schools.schooltype when '4' then '5' else schools.schooltype end) end) end),
'RelateToKey' = 'Econ', sum(FreeReducedCount) as 'RelateToNumerator', enrollment as 'RelateToDenominator',
cast((case when sum(enrollment) = 0 then null when sum(FreeReducedCount) = 0 then null else (	(sum(FreeReducedCount) / sum(enrollment)) * 100) end) as decimal(12,2)) as 'RelateToValue'
FROM enrollment
left outer join [ErateRollups] on enrollment.year = [ErateRollups].year and enrollment.fullkey = [ErateRollups].fullkey
and enrollment.Grade = [ErateRollups].RollupGrade
left outer join schools on enrollment.year = schools.year and enrollment.fullkey = schools.fullkey
--where enrollment.year >= (select min(year) from tblteacherqualifications) and enrollment.year <= (select max(year) from tblteacherqualifications)
where enrollment.year =
--(select max(year) from [ErateRollups])
(select case when ((select max(year) from [ErateRollups]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [ErateRollups]) end)
and (grade = '70' or grade = '71' or grade = '72' or grade = '73' or grade = '99') and race = '9' and sex = '9'
--group by enrollment.[year], enrollment.[fullkey], (case enrollment.grade when '70' then '6' when '71' then '5' when '72' then '3' when '73' then '7' when '99' then (case right(enrollment.fullkey,1) when 'X' then '9' else schools.schooltype end) end), enrollment
group by enrollment.[year], enrollment.[fullkey], (case enrollment.grade when '70' then '6' when '71' then '5' when '72' then '3' when '73' then '7' when '99' then (case right(enrollment.fullkey,1) when 'X' then '9' else (case schools.schooltype when '4' then '5' else schools.schooltype end) end) end), enrollment

union all

-- LEP - schools
SELECT enrollment.[Year], enrollment.[Fullkey], 'schooltype' = (case schools.[schooltype] when '4' then '5' else schools.[schooltype] end),
'RelateToKey' = 'LEP', --'RelateToLabel' = 'Limited English Proficient',
sum((isnull(ProfLev1,0)+isnull(ProfLev2,0)+isnull(ProfLev3,0)+isnull(ProfLev4,0)+isnull(ProfLev5,0))) as 'RelateToNumerator',
enrollment.enrollment as 'RelateToDenominator',
cast((case when enrollment.enrollment = 0 then null when sum((isnull(ProfLev1,0)+isnull(ProfLev2,0)+isnull(ProfLev3,0)+isnull(ProfLev4,0)+isnull(ProfLev5,0))) = 0 then null
		else ((sum(isnull(ProfLev1,0)+isnull(ProfLev2,0)+isnull(ProfLev3,0)+isnull(ProfLev4,0)+isnull(ProfLev5,0)) / enrollment.enrollment) * 100) end) as decimal(12,2)) as 'RelateToValue'
FROM enrollment left outer join [leplang] on [leplang].year = enrollment.year and [leplang].fullkey = enrollment.fullkey
and [leplang].race = enrollment.race and [leplang].sex = enrollment.sex
inner join schools on enrollment.year = schools.year and enrollment.fullkey = schools.fullkey
--where enrollment.year >= (select min(year) from tblteacherqualifications) and enrollment.year <= (select max(year) from tblteacherqualifications)
where [leplang].year =
--(select max(year) from [leplang])
(select case when ((select max(year) from [leplang]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [leplang]) end)
and left(enrollment.fullkey,1) <> 'X' and enrollment.race = '9' and enrollment.sex = '9' and enrollment.grade = '99'
group by enrollment.[Year], enrollment.[Fullkey], (case schools.[schooltype] when '4' then '5' else schools.[schooltype] end), enrollment.enrollment, enrollment.grade

-- LEP - districts - each schooltype

union all

select enrollment.Year, enrollment.Fullkey,
'Schooltype' = (case enrollment.grade when '70' then '6' when '71' then '5' when '72' then '3' when '73' then '7' end),
'RelateToKey' = 'LEP',
'RelateToNumerator' = LEPCount, enrollment.enrollment as 'RelateToDenominator',
cast(case when enrollment.enrollment = 0 then null when isnull(LEPCount,0) = 0 then null else ((LEPCount / enrollment.enrollment) * 100) end as decimal(12,2)) as 'RelateToValue'

from (

	SELECT [LEPLang].[Year], 'Fullkey' = left([LEPLang].[Fullkey],6) + '03XXXX',
	'schooltype' = (case [LEPLang].[schooltype] when '4' then '5' else [LEPLang].[schooltype] end),
	'RollupGrade' = (case [LEPLang].schooltype when '3' then '72' when '4' then '71' when '5' then '71' when '6' then '70' when '7' then '73' end),
	sum((isnull(ProfLev1,0)+isnull(ProfLev2,0)+isnull(ProfLev3,0)+isnull(ProfLev4,0)+isnull(ProfLev5,0))) as 'LEPCount'
	FROM [LEPLang]
	where

	--[LEPLang].year >= (select min(year) from tblteacherqualifications) and [LEPLang].year <= (select max(year) from tblteacherqualifications)
	[LEPLang].year =
	--(select max(year) from [LEPLang])
	(select case when ((select max(year) from [leplang]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [leplang]) end)
	and [LEPLang].race = '9' and [LEPLang].sex = '9'

	group by [LEPLang].[Year], left([LEPLang].[Fullkey],6) + '03XXXX',
	(case [LEPLang].[schooltype] when '4' then '5' else [LEPLang].[schooltype] end),
	(case [LEPLang].schooltype when '3' then '72' when '4' then '71' when '5' then '71' when '6' then '70' when '7' then '73' end)
) LEP

right outer join enrollment on LEP.year = enrollment.year and LEP.fullkey = enrollment.fullkey and LEP.RollupGrade = enrollment.grade
--where enrollment.year >= (select min(year) from tblteacherqualifications) and enrollment.year <= (select max(year) from tblteacherqualifications)
where enrollment.year =
--(select max(year) from enrollment)
(select case when ((select max(year) from [enrollment]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [enrollment]) end)
and right(enrollment.fullkey,1) = 'X' and left(enrollment.fullkey,1) <> 'X' and enrollment.race = '9' and enrollment.sex = '9'
and (enrollment.grade = '70' or enrollment.grade = '71' or enrollment.grade = '72' or enrollment.grade = '73')

union all

-- LEP - districts - schooltype summaries

select enrollment.Year, enrollment.Fullkey, 'Schooltype' = '9',
'RelateToKey' = 'LEP',
'RelateToNumerator' = LEPCount, enrollment.enrollment as 'RelateToDenominator',
cast(case when enrollment.enrollment = 0 then null when isnull(LEPCount,0) = 0 then null else ((LEPCount / enrollment.enrollment) * 100) end as decimal(12,2)) as 'RelateToValue'

from (
	SELECT [LEPLang].[Year], 'Fullkey' = left([LEPLang].[Fullkey],6) + '03XXXX',
	'schooltype' = '9',
	'RollupGrade' = '99',
	sum((isnull(ProfLev1,0)+isnull(ProfLev2,0)+isnull(ProfLev3,0)+isnull(ProfLev4,0)+isnull(ProfLev5,0))) as 'LEPCount'
	FROM [LEPLang]
	where

	--[LEPLang].year >= (select min(year) from tblteacherqualifications) and [LEPLang].year <= (select max(year) from tblteacherqualifications)
	[LEPLang].year =
	--(select max(year) from [LEPLang])
	(select case when ((select max(year) from [leplang]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [leplang]) end)
	and [LEPLang].race = '9' and [LEPLang].sex = '9'

	group by [LEPLang].[Year], left([LEPLang].[Fullkey],6) + '03XXXX'
) LEP

right outer join enrollment on LEP.year = enrollment.year and LEP.fullkey = enrollment.fullkey and LEP.RollupGrade = enrollment.grade
--where enrollment.year >= (select min(year) from tblteacherqualifications) and enrollment.year <= (select max(year) from tblteacherqualifications)
where enrollment.year =
--(select max(year) from enrollment)
(select case when ((select max(year) from [enrollment]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [enrollment]) end)
and right(enrollment.fullkey,1) = 'X' and left(enrollment.fullkey,1) <> 'X' and enrollment.race = '9' and enrollment.sex = '9' and enrollment.grade = '99'

union all

-- native - district level
SELECT  e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Ntv', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressedDistState] e1 inner join [tblPubEnrWWoDisSuppressedDistState] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressedDistState]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressedDistState]) end)
and left(e1.fullkey,1) <> 'X'
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'I' and e2.race = '9' and e2.disability = '9'

union all

-- native - school level
SELECT e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Ntv', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressed] e1 inner join [tblPubEnrWWoDisSuppressed] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressed]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressed]) end)
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'I' and e2.race = '9' and e2.disability = '9'

union all

-- asian - district level
SELECT  e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Asn', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressedDistState] e1 inner join [tblPubEnrWWoDisSuppressedDistState] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressedDistState]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressedDistState]) end)
and left(e1.fullkey,1) <> 'X'
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'A' and e2.race = '9' and e2.disability = '9'

union all

-- asian - school level
SELECT e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Asn', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressed] e1 inner join [tblPubEnrWWoDisSuppressed] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressed]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressed]) end)
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'A' and e2.race = '9' and e2.disability = '9'

union all

-- black - district level
SELECT  e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Blck', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressedDistState] e1 inner join [tblPubEnrWWoDisSuppressedDistState] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressedDistState]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressedDistState]) end)
and left(e1.fullkey,1) <> 'X'
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'B' and e2.race = '9' and e2.disability = '9'

union all

-- black - school level
SELECT e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Blck', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressed] e1 inner join [tblPubEnrWWoDisSuppressed] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressed]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressed]) end)
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'B' and e2.race = '9' and e2.disability = '9'

union all

-- hispanic - district level
SELECT  e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Hsp', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressedDistState] e1 inner join [tblPubEnrWWoDisSuppressedDistState] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressedDistState]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressedDistState]) end)
and left(e1.fullkey,1) <> 'X'
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'H' and e2.race = '9' and e2.disability = '9'

union all

-- hispanic - school level
SELECT e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Hsp', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressed] e1 inner join [tblPubEnrWWoDisSuppressed] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressed]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressed]) end)
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'H' and e2.race = '9' and e2.disability = '9'

union all

-- pacific - district level
SELECT  e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Pac', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressedDistState] e1 inner join [tblPubEnrWWoDisSuppressedDistState] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressedDistState]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressedDistState]) end)
and left(e1.fullkey,1) <> 'X'
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'P' and e2.race = '9' and e2.disability = '9'

union all

-- pacific - school level
SELECT e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Pac', --'RelateToLabel' = '% Am Indian',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressed] e1 inner join [tblPubEnrWWoDisSuppressed] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressed]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressed]) end)
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'P' and e2.race = '9' and e2.disability = '9'

union all

-- white - district level
SELECT  e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Wht', --'RelateToLabel' = '% White',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressedDistState] e1 inner join [tblPubEnrWWoDisSuppressedDistState] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressedDistState]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressedDistState]) end)
and left(e1.fullkey,1) <> 'X'
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'W' and e2.race = '9' and e2.disability = '9'

union all

-- white - school level
SELECT e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = 'Wht', --'RelateToLabel' = '% White',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressed] e1 inner join [tblPubEnrWWoDisSuppressed] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressed]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressed]) end)
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'W' and e2.race = '9' and e2.disability = '9'

union all

-- TwoOrMore - district level
SELECT  e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = '2OrMore', --'RelateToLabel' = '% Two or More',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressedDistState] e1 inner join [tblPubEnrWWoDisSuppressedDistState] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressedDistState]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressedDistState]) end)
and left(e1.fullkey,1) <> 'X'
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'T' and e2.race = '9' and e2.disability = '9'

union all

-- TwoOrMore - school level
SELECT e1.[YEAR], e1.[FULLKEY],
'Schooltype' = e1.Schooltype,
'RelateToKey' = '2OrMore', --'RelateToLabel' = '% Two or More',
'RelateToNumerator' = e1.[ENROLLMENT], 'RelateToDenominator' = e2.[ENROLLMENT],
'RelateToValue' = case isnull(e2.[ENROLLMENT],0) when 0 then null else ((e1.[ENROLLMENT] / e2.[ENROLLMENT]) * 100) end
FROM [tblPubEnrWWoDisSuppressed] e1 inner join [tblPubEnrWWoDisSuppressed] e2 on e1.year = e2.year and e1.fullkey = e2.fullkey and e1.schooltype = e2.schooltype and e1.grade = e2.grade and e1.gender = e2.gender
inner join RaceYear on e1.year = RaceYear.year and e1.race = RaceYear.RaceCode
where e1.year =
(select case when ((select max(year) from [tblPubEnrWWoDisSuppressed]) > (select max(year) from tblTeacherQualifications)) then (select max(year) from tblTeacherQualifications) else (select max(year) from [tblPubEnrWWoDisSuppressed]) end)
and e1.schooltype in ('3','5','6','7','9') and e1.grade = '99' and e1.gender = '9' and RaceYear.DPICODE = 'T' and e2.race = '9' and e2.disability = '9'

union all
-- Disability - new approach - 2005-12-27

--select year, fullkey, schooltype,
--'RelateToKey' = 'Disability',
--'RelateToNumerator' = cast(isnull(e.[Disabled],0) as int),
--'RelateToDenominator' = cast(isnull(e.[Enrollment],0) as int),
--'RelateToValue' = (case isnull(e.[Enrollment],0) when 0 then null else cast(((e.[Disabled] / e.[Enrollment]) * 100) as decimal(8,4)) end)
--from v_Template_Keys_WWoDis_EnrollFlat e
--where year = (select max(year) from tblPubEnrWWoDisSuppressedSchoolDistStateFlat where fullkey = 'XXXXXXXXXXXX')

select d.year, d.fullkey, d.schooltype, 'RelateToKey' = 'DISAB',
-- '**' (flag for  disability collections producing enrollment < 0) and '--' (enrollment is 0 so percent not calculable) are done in the view
-- per jean email of 2006-01-09
--'RelateToNumerator' = (case when e.[Suppressed] = -10 then -10 else d.[Suppressed] end),
'RelateToNumerator' = cast(isnull(d.[Enrollment],0) as int),
-- tips for suppression in view:
-- when RelateToValue is not null and RelateToNumerator = -10, suppression is in effect - throw *
-- when RelateToValue is not null and RelateToDenominator = -10, enrollment itself is suppressed - throw * (not sure if enrollment itself is ever suppressed)
-- when RelateToValue is null, bogus SWD calculations are at work - throw **
-- when RelateToDenominator < 0, bogus SWD calculations are at work - throw **
-- when RelateToDenominator = 0, hide any bogus SWD calculations - throw 0
'RelateToDenominator' = cast(isnull(e.[Enrollment],0) as int),
-- tips for suppression in view:
-- when RelateToValue is not null and RelateToDenominator = -10, enrollment itself is suppressed - throw * (not sure if enrollment itself is ever suppressed)
-- when RelateToValue is null, bogus SWD calculations are at work - throw **
-- when RelateToDenominator < 0, bogus SWD calculations are at work - throw **
-- per jean email of 2006-01-09
--'RelateToValue' = (case when d.[Suppressed] = -10 then -10 when e.[Suppressed] = -10 then -10 when e.[Enrollment] <= 0 then null else cast(((d.[Enrollment] / e.[Enrollment]) * 100) as decimal(8,4)) end)
'RelateToValue' = (case when e.[Enrollment] <= 0 then null else cast(((d.[Enrollment] / e.[Enrollment]) * 100) as decimal(8,4)) end)
-- tips for suppression in view:
-- when RelateToValue is not null and RelateToNumerator = -10, suppression is in effect - throw *
-- when RelateToValue is not null and RelateToDenominator = -10, enrollment itself is suppressed - throw * (not sure if enrollment itself is ever suppressed)
-- when RelateToValue is null, bogus SWD calculations are at work - throw **
-- when RelateToDenominator < 0, bogus SWD calculations are at work - throw **
-- when RelateToDenominator = 0, avoid divide by zero error by throwing '--'
from v_Enrollment_WWoDis d
inner join v_Enrollment_WWoDis e
on d.[year] = e.[year] and d.[fullkey] = e.[fullkey] and d.[agencykey] = e.[agencykey] and d.schooltype = e.schooltype and d.[GradeCode] = e.[GradeCode] and d.[RaceCode] = e.[RaceCode] and d.[SexCode] = e.[SexCode]
where d.year = (select max(year) from tblPubEnrWWoDisSuppressedSchoolDistStateFlat)
and d.gradecode = '99' and d.racecode = '9' and d.sexcode = '9' and d.[DisabilityCode] = '1' and e.[DisabilityCode] = '9'
-- test
--and d.year = '2005' and d.fullkey = 'XXXXXXXXXXXX'


-- wkce demograph approach - Jean may want for disabilities
/*
select Year, Fullkey, 'schooltype' = '9',
--wkcedemographics.GroupNum,
'RelateToKey' = (case wkcedemographics.groupnum when '27' then 'EconomicStatus' when '21' then 'EnglishProficiency' when '25' then 'Disability'
when '14' then 'Native' when '15' then 'Asian' when '16' then 'Black' when '17' then 'Hispanic' when '18' then 'White' else 'Error' end),
groups.GroupName as 'RelateToLabel',
cast((case sum(denominator) when 0 then null else ((sum(numgroup) / sum(denominator)) * 100) end) as decimal(12,2)) as 'RelateToValue'
from wkcedemographics
inner join groups on wkcedemographics.groupnum = groups.groupnum
where year >= '2003'
group by year, fullkey, wkcedemographics.groupnum, groups.groupname

union all
*/


--order by [enrollment].fullkey, schooltype



/*
'Spending'
'DistSize'
'SchoolSize'
*/

/*
select
distinct groups.groupnum, groupname
from wkcedemographics
inner join groups on wkcedemographics.groupnum = groups.groupnum
order by groups.groupnum
*/
--where
--fullkey = '01397603XXXX'
--fullkey = '????????????'
--pctgroup is null

) x

-- weeding out inappropriate agencies
where left(right(x.fullkey,6),2) in ('03', '04', '4C', '49') or (right(left(x.fullkey,6),4) = '7300' and (left(right(x.fullkey,6),2) = '05' or left(right(x.fullkey,6),2) = '10'))
go

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblTeacherQualificationsScatter]([Year], [FullKey], [schooltype], [RelateToKey], [RelateToValue]) WITH  FILLFACTOR = 100 ON [PRIMARY]
go

GRANT  SELECT  ON [dbo].[tblTeacherQualificationsScatter]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblTeacherQualificationsScatter]  TO [netwisco]
GO

-- pinning year to make join work - see TQScatterYearFix.sql
update tblTeacherQualificationsScatter
set year = (select max(year) from tblTeacherQualifications)
GO

