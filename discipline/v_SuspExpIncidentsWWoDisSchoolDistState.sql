USE [Wisconsin]
GO
/****** Object:  View [dbo].[v_SuspExpIncidentsWWoDisSchoolDistState]    Script Date: 05/05/2012 15:19:37 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[v_SuspExpIncidentsWWoDisSchoolDistState]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[v_SuspExpIncidentsWWoDisSchoolDistState]

GO

/****** Object:  View [dbo].[v_SuspExpIncidentsWWoDisSchoolDistState]    Script Date: 05/05/2012 15:18:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO





CREATE view [dbo].[v_SuspExpIncidentsWWoDisSchoolDistState] as
Select 
k.year, 'YearFormatted' = cast((rtrim(cast((cast(k.year as int) - 1) as char)) + '-' + right(k.year,2)) as char(7)), 
k.fullkey, 
k.agencykey, 
'AgencyType' = left(right(k.fullkey,6),2),
k.CESA, 
k.County,
k.ConferenceKey, 
--k.schooltype, 
--'schooltype' = (case right(k.fullkey,1) when 'X' then k.schooltypek else k.schooltype end), 
'schooltype' = k.schooltype, 
'SchooltypeLabel' = (case k.schooltype when '3' then '  High School Type' when '5' then '   Middle/Junior High School Type' when '6' then '    Elementary School Type' when '7' then ' Combined Elementary/Secondary School Type' when '9' then 'Summary' end), 
'SchooltypeLabelShort' = (case k.schooltype when '3' then '  High' when '5' then '   Mid/Jr Hi' when '6' then '    Elem' when '7' then ' El/Sec' when '9' then 'Summary' end), 
k.RollupSchooltype, 
k.DistrictCode as 'District Number', 
k.SchoolCode as 'School Number', 
'charter' = (case k.schoolcat when 'CHR' then 'Y' else 'N' end),
'OrgLevelLabel' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end),

'OrgSchoolTypeLabel' = 
(case right(k.fullkey,1) when 'X' then 
	(case k.schooltype 
	when '6' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Elementary Schools'
	when '5' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Middle / Junior High Schools'
	when '3' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': High Schools'
	when '7' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Elementary / Secondary Combined Schools'
	when '9' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary'
	else '' end)
else (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) end), 
'OrgSchoolTypeLabelAbbr' = 
(case right(k.fullkey,1) when 'X' then 
	(case k.schooltype 
	when '6' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Elem'
	when '5' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Mid/Jr Hi'
	when '3' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': High'
	when '7' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': El/Sec'
	when '9' then (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary'
	else '' end)
else (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) end), 


-- combines district and school
'Name' = rtrim(
	case 
		WHEN k.Fullkey = 'XXXXXXXXXXXX' THEN (' ' + 'WI Public Schools')
		WHEN right(k.Fullkey,1) = 'X' THEN ('  ' + rtrim(Districtname))
		else ('   ' + rtrim(Districtname) + ' / ' + rtrim(Schoolname))
	end),
'District Name' = ('  ' +  rtrim(Districtname)), 
'School Name' = ('   ' + rtrim(Schoolname)), 
'Grade' = GradeCode, GradeCode, GradeLabel, GradeShortLabel, 'Race' = RaceCode, RaceCode, RaceLabel, RaceShortLabel, 
'Gender' = SexCode, SexCode, 'GenderLabel' = SexLabel, SexLabel, DisabilityCode, DisabilityLabel, ShortDisabilityLabel,

-- if these codes ever change, be sure to change BOTH case statements - must customize for WKCE, LEP, EconStatus, Disabilities, maybe others
'Student Group' = (Case
when RaceCode = '9' and SexCode = '9' then 
	(Case 
		when k.fullkey = 'XXXXXXXXXXXX' then '2'
		when right(k.fullkey,1) = 'X' then '3'
		else '6'
	end)
when RaceCode = '9' and SexCode = '1' then '11'
when RaceCode = '9' and SexCode = '2' then '12'
when RaceCode = '9' and SexCode = '8' then '13'
when RaceCode = '1' and SexCode = '9' then '14'
when RaceCode = '2' and SexCode = '9' then '15'
when RaceCode = '3' and SexCode = '9' then '16'
when RaceCode = '4' and SexCode = '9' then '17'
when RaceCode = '5' and SexCode = '9' then '18'
when RaceCode = '8' and SexCode = '9' then '19'
when RaceCode = '6' and SexCode = '9' then '20'
end),

-- if these codes ever change, be sure to change BOTH case statements - must customize for WKCE, LEP, EconStatus, Disabilities, maybe others
'StudentGroupLabel' = (Case
when RaceCode = '9' and SexCode = '9' then 
	(Case 
		when k.fullkey = 'XXXXXXXXXXXX' then 'Students in Wisconsin Public Schools'
		when right(k.fullkey,1) = 'X' then 'Students in this District'
		else 'Students in this School'
	end)
when RaceCode = '9' and SexCode = '1' then 'Female'
when RaceCode = '9' and SexCode = '2' then 'Male'
when RaceCode = '9' and SexCode = '8' then 'Gender Code Missing/Invalid'
when RaceCode = '1' and SexCode = '9' then 'American Indian/Alaskan Native'
when RaceCode = '2' and SexCode = '9' then 'Asian/Pacific Islander'
when RaceCode = '3' and SexCode = '9' then 'Black (Not of Hispanic Origin)'
when RaceCode = '4' and SexCode = '9' then 'Hispanic'
when RaceCode = '5' and SexCode = '9' then 'White (Not of Hispanic Origin)'
when RaceCode = '8' and SexCode = '9' then 'Race/Eth Code Missing/Invalid'
when RaceCode = '6' and SexCode = '9' then 'Combined Groups (Small Number)'
end),

-- combines district and school
'LinkedName' = 
	case 
		WHEN k.Fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools'
		WHEN RIGHT(k.Fullkey, 1) = 'X' THEN rtrim(
			CASE 
				WHEN k.districtwebaddress IS NULL THEN rtrim(k.Districtname) 
				WHEN ltrim(rtrim(k.districtwebaddress))  = '' THEN rtrim(k.Districtname) 
				ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>' 
			END)
		ELSE rtrim(
			CASE 
				WHEN k.districtwebaddress IS NULL THEN rtrim(k.Districtname) 
				WHEN ltrim(rtrim(k.districtwebaddress))  = '' THEN rtrim(k.Districtname) 
				ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>' 
			END)
			+ ' / ' + 	rtrim(
			CASE 
				WHEN k.schoolwebaddress IS NULL THEN rtrim(k.Schoolname) 
				WHEN ltrim(rtrim(k.schoolwebaddress))  = '' THEN rtrim(k.Schoolname) 
				ELSE '<a href=javascript:popup(''' + rtrim(k.schoolwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.schoolname)  + '</A>' 
			END)
END, 

-- website URL from districts table
'LinkedDistrictName' = 
 case 
	when districtwebaddress is null then rtrim(k.Districtname) 
	when ltrim(rtrim(districtwebaddress))  = '' then rtrim(k.Districtname) 
	else "<a href=javascript:popup('" + rtrim(districtwebaddress) + "') onclick='setcookie(question, url)'>"+ rtrim(districtname)  + "</a>" 
end,

-- website URL from schools table
'LinkedSchoolName' = 
 case 
	when schoolwebaddress is null then rtrim(k.Schoolname) 
	when ltrim(rtrim(schoolwebaddress))  = '' then rtrim(k.Schoolname) 
	else "<a href=javascript:popup('" + rtrim(schoolwebaddress) + "') onclick='setcookie(question, url)'>"+ rtrim(schoolname)  + "</a>" 
end, 

'Total Enrollment PreK-12' = isnull(e.enrollment,0), 'suppressed' = isnull(e.suppressed,0), 

IncidentsTotalWeaponDrugNo, 

isnull(IncidentsSuspDurationLong,0) as 'IncidentsSuspDurationLong', 
isnull(IncidentsSuspDurationShort,0) as 'IncidentsSuspDurationShort', 
isnull(IncidentsSuspWeaponDrugYesDurationShort,0) as 'IncidentsSuspWeaponDrugShort', 
isnull(IncidentsSuspWeaponDrugYesDurationLong,0) as 'IncidentsSuspWeaponDrugLong',
isnull(IncidentsSuspWeaponDrugNoDurationShort,0) as 'IncidentsSuspNonWeaponDrugShort',
isnull(IncidentsSuspWeaponDrugNoDurationLong,0) as 'IncidentsSuspNonWeaponDrugLong',
isnull(IncidentsExpDurationTotal,0) as 'IncidentsExpDurationTotal', 
isnull(E.enrollment,0) as 'enrollment', 

-- fix per Jean email 2012-02-21 
--isnull(IncidentsSuspWeaponDrugYes,0) as 'IncidentCountSuspWeaponDrug', 
--isnull(IncidentsSuspWeaponDrugNo,0) as 'IncidentCountSuspNonWeaponDrug', 
--isnull(IncidentsExpWeaponDrugYes,0) as 'IncidentCountExpWeaponDrug', 
--isnull(IncidentsExpWeaponDrugNo,0) as 'IncidentCountExpNonWeaponDrug', 

(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '0' when E.enrollment is null then '0' else 
	cast(isnull(IncidentsSuspWeaponDrugYes,0) as char) end) 
	as 'IncidentCountSuspWeaponDrug',

(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '0' when E.enrollment is null then '0' else 
	cast(isnull(IncidentsSuspWeaponDrugNo,0) as char) end) 
	as 'IncidentCountSuspNonWeaponDrug',

(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '0' when E.enrollment is null then '0' else 
	cast(isnull(IncidentsExpWeaponDrugYes,0) as char) end) 
	as 'IncidentCountExpWeaponDrug',

(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '0' when E.enrollment is null then '0' else 
	cast(isnull(IncidentsExpWeaponDrugNo,0) as char) end) 
	as 'IncidentCountExpNonWeaponDrug',

(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '0' when E.enrollment is null then '0' else 
	cast(isnull(IncidentsTotalWeaponDrugYes,0) as char) end) 
	as 'IncidentCountTotalWeaponDrug',
(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '0' when E.enrollment is null then '0' else 
	cast(isnull(IncidentsTotalWeaponDrugNo,0) as char) end) 
	as 'IncidentCountTotalNonWeaponDrug',
(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '--' when E.enrollment is null then '--' 
	else cast((isnull(IncidentsTotalWeaponDrugYes,0)  / (E.enrollment / 1000) ) as char(18) ) end) as 'WeaponDrugIncidentRate',

(case when E.suppressed = -10 then '*' when E.enrollment = 0 then '--' when E.enrollment is null then '--' 
	else cast((isnull(IncidentsTotalWeaponDrugNo,0) / (E.enrollment / 1000)) as char(18)) end) as 'NonWeaponDrugIncidentRate',

(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) is null then '--' 
	else cast((((isnull(IncidentsSuspWeaponDrugYesDurationShort,0) + isnull(IncidentsSuspWeaponDrugYesDurationLong,0)) / isnull(IncidentsTotalWeaponDrugYes,0) * 100)) as char(18)) end) as '%WeaponDrugAllSusp',
(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) is null then '--' 
	else cast(((isnull(IncidentsSuspWeaponDrugYesDurationShort,0) / isnull(IncidentsTotalWeaponDrugYes,0) * 100)) as char(18)) end) as '%WeaponDrugShortSusp',
(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) is null then '--' 
	else cast(((isnull(IncidentsSuspWeaponDrugYesDurationLong,0) / isnull(IncidentsTotalWeaponDrugYes,0) * 100)) as char(18)) end) as '%WeaponDrugLongSusp',
(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugYes,0) is null then '--' 
	else cast(((isnull(IncidentsExpWeaponDrugYes,0) / isnull(IncidentsTotalWeaponDrugYes,0) * 100)) as char(18)) end) as '%WeaponDrugExp',
(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) is null then '--' else 
	cast((((isnull(IncidentsSuspWeaponDrugNoDurationShort,0) + isnull(IncidentsSuspWeaponDrugNoDurationLong,0) ) / isnull(IncidentsTotalWeaponDrugNo,0) * 100)) as char(18)) end) as '%NonWeaponDrugAllSusp',
(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) is null then '--' else 
	cast(((isnull(IncidentsSuspWeaponDrugNoDurationShort,0) / isnull(IncidentsTotalWeaponDrugNo,0) * 100)) as char(18)) end) as '%NonWeaponDrugShortSusp',
(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) is null then '--' else 
	cast(((isnull(IncidentsSuspWeaponDrugNoDurationLong,0) / isnull(IncidentsTotalWeaponDrugNo,0) * 100)) as char(18)) end) as '%NonWeaponDrugLongSusp',
(case when E.suppressed = -10 then '*' when E.suppressed = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) = 0 then '--' when isnull(IncidentsTotalWeaponDrugNo,0) is null then '--' else 
	cast(((isnull(IncidentsExpWeaponDrugNo,0) / isnull(IncidentsTotalWeaponDrugNo,0) * 100)) as char(18)) end) as '%NonWeaponDrugExp'

-- additional columns for the data table can be added here - use isnull() to zero-out missing rows 

-- the place where you should put your join is commented down below

from (

-- school level
select agency.year, agency.fullkey, agency.agencykey, 
-- this will produce five records, one for each of the five schooltypes, for each single school-level record - can handle this by WHEREing on schooltype for school-level records
-- if this turns out to be a problem, consider unioning two queries together, one school-level query with one real schooltype per agency using agency.schooltype, 
-- and one dist & state level query with five schooltypes per agency, using SchooltypeCodes.schooltypecode
-- actually, see where below - (and k.fullkey <> 'X' and k.schooltype = e.schooltype) seems to fix it 
'schooltype' = agency.schooltype, 
--'schooltypek' = (case right(agency.fullkey,1) when 'X' then SchooltypeCodes.schooltypecode else agency.schooltype end), 
--'schooltype' = agency.schooltype, 
--RollupSchooltype, 
'RollupSchooltype' = (case rtrim(ltrim(agency.schooltype)) when '3' then '72' when '5' then '71' when '6' then '70' when '7' then '73' when '9' then '99' else null end),
agency.schoolcat, 
agency.CESA, agency.County, agency.ConferenceKey, agency.district as 'DistrictCode', agency.school as 'SchoolCode', 
rtrim(agency.name) as 'name', rtrim(agency.districtname) as 'districtname', rtrim(agency.schoolname) as 'schoolname', 
grademap.grade as GradeCode, grademap.name as GradeLabel, grademap.ABBR as GradeShortLabel, 
Race.Num as RaceCode, Race.name as RaceLabel, Race.shortname as RaceShortLabel,
Sex.Num as SexCode, Sex.name as SexLabel,
DisabilityCodes.CodeNum as DisabilityCode, DisabilityCodes.[Description] as DisabilityLabel, DisabilityCodes.[ShortDescription] as ShortDisabilityLabel, 
rtrim(agency.districtwebaddress) as 'districtwebaddress', rtrim(agency.schoolwebaddress) as 'schoolwebaddress'
from grademap, 

---- adds unknown and all keys
---- adds unknown and all keys
--(Select num, name, shortname from Race 
--	UNION ALL Select 8 as num, 'No Response' as name, 'No Resp' As shortname 
--	UNION ALL Select 9 as num, 'All Races' as name, 'All Races' As shortname) Race,

-- adds unknown key
(Select num, name from Sex UNION ALL Select 9 as num, 'Both Genders' As name) Sex,

(select CodeNum, [Description], ShortDescription from DisabilityCodes where CodeNum in ('1','2','9')) DisabilityCodes, 

--(select 3 as 'SchooltypeCode' union select 5 as 'SchooltypeCode' union select 6 as 'SchooltypeCode' union select 7 as 'SchooltypeCode' union select 9 as 'SchooltypeCode') SchooltypeCodes, 

-- using new table
tblAgencyFull agency 

inner join (SELECT [RaceCode] as 'num', [LongName] as 'name', [shortname], [year] FROM [RaceYear]) Race on agency.year = Race.year 

where right(agency.fullkey,1) <> 'X' 
-- 2010-04-07 - fixing agencytypes per suspensions expulsions incidents rewrite 032910.doc
and agencytype in ('04','4C','49')

union all 

-- district/state level
select agency.year, agency.fullkey, agency.agencykey, 
-- this will produce five records, one for each of the five schooltypes, for each single school-level record - can handle this by WHEREing on schooltype for school-level records
-- if this turns out to be a problem, consider unioning two queries together, one school-level query with one real schooltype per agency using agency.schooltype, 
-- and one dist & state level query with five schooltypes per agency, using SchooltypeCodes.schooltypecode
-- actually, see where below - (and k.fullkey <> 'X' and k.schooltype = e.schooltype) seems to fix it 
'schooltype' = SchooltypeCodes.schooltypecode, 
--'schooltypek' = (case right(agency.fullkey,1) when 'X' then SchooltypeCodes.schooltypecode else agency.schooltype end), 
--'schooltype' = agency.schooltype, 
--RollupSchooltype, 
'RollupSchooltype' = (case rtrim(ltrim(SchooltypeCodes.schooltypecode)) when '3' then '72' when '5' then '71' when '6' then '70' when '7' then '73' when '9' then '99' else null end),
agency.schoolcat, 
agency.CESA, agency.County, agency.ConferenceKey, agency.district as 'DistrictCode', agency.school as 'SchoolCode', 
rtrim(agency.name) as 'name', rtrim(agency.districtname) as 'districtname', rtrim(agency.schoolname) as 'schoolname', 
grademap.grade as GradeCode, grademap.name as GradeLabel, grademap.ABBR as GradeShortLabel, 
Race.Num as RaceCode, Race.name as RaceLabel, Race.shortname as RaceShortLabel,
Sex.Num as SexCode, Sex.name as SexLabel,
DisabilityCodes.CodeNum as DisabilityCode, DisabilityCodes.[Description] as DisabilityLabel, DisabilityCodes.[ShortDescription] as ShortDisabilityLabel, 
rtrim(agency.districtwebaddress) as 'districtwebaddress', rtrim(agency.schoolwebaddress) as 'schoolwebaddress'
from grademap, 

---- adds unknown and all keys
---- adds unknown and all keys
--(Select num, name, shortname from Race 
--	UNION ALL Select 8 as num, 'No Response' as name, 'No Resp' As shortname 
--	UNION ALL Select 9 as num, 'All Races' as name, 'All Races' As shortname) Race,

-- adds unknown key
(Select num, name from Sex UNION ALL Select 9 as num, 'Both Genders' As name) Sex,

(select CodeNum, [Description], ShortDescription from DisabilityCodes where CodeNum in ('1','2','9')) DisabilityCodes, 

(select 3 as 'SchooltypeCode' union select 5 as 'SchooltypeCode' union select 6 as 'SchooltypeCode' union select 7 as 'SchooltypeCode' union select 9 as 'SchooltypeCode') SchooltypeCodes, 

-- using new table
tblAgencyFull agency 

inner join (SELECT [RaceCode] as 'num', [LongName] as 'name', [shortname], [year] FROM [RaceYear]) Race on agency.year = Race.year 

where (right(agency.fullkey,1) = 'X' 
-- 2010-04-07 - fixing agencytypes per suspensions expulsions incidents rewrite 032910.doc
--and agency.agencytype not in ('00','01','02','05'))
and agencytype in ('03','XX'))
-- 2009-07-15 - pulling CESA and County rows for some reason - no name, no data - filtering out for now so client can QA
or (fullkey = 'XXXXXXXXXXXX')


) k

-- put a left outer join to the data table here if you can - or you can create another view that does a left outer join from this view 

left outer join 
(select * from tblPubEnrWWoDisSuppressed union all select * from tblPubEnrWWoDisSuppressedDistState) e 
--(select * from tblPubEnrWWoDisSuppressedDistState) e 
on k.year = e.year and k.fullkey = e.fullkey and k.schooltype = e.schooltype and k.GradeCode = e.Grade and k.racecode = e.race and k.sexcode = e.gender and k.disabilitycode = e.disability

--left outer join (select * from tblSuspensionsExpulsionsIncidentsDistState) s on k.year = s.year and k.fullkey = s.fullkey and k.schooltype = s.schooltype and k.gradecode = s.grade and k.racecode = s.race and k.sexcode = s.gender and k.disabilitycode = s.Disability
left outer join (select * from tblSuspensionsExpulsionsIncidentsSchools union all select * from tblSuspensionsExpulsionsIncidentsDistState) s on k.year = s.year and k.fullkey = s.fullkey and k.schooltype = s.schooltype and k.gradecode = s.grade and k.racecode = s.race and k.sexcode = s.gender and k.disabilitycode = s.Disability

--this where statement is for test purposes only - un-commenting it gives you a recordset of reasonable size to test against - it should be commented out for production

where k.year > '1998'

-- filter out bogus schooltypes at school level
--and
--	(
--		(right(k.fullkey,1) <> 'X' and k.schooltype is not null)
--		or 
--		right(k.fullkey,1) = 'X' 
--	)


--and right(k.fullkey,1) <> 'X' and k.schooltype = e.schooltype
-- filter in only valid grade/schooltype combinations - must revise when adding schooltype support to table


/*
and k.year = '2008' 
--and (fullkey = '013619040223' or fullkey = '01361903XXXX' or fullkey = 'XXXXXXXXXXXX') 
and (k.fullkey = '013619040012' or k.fullkey = '01361903XXXX' or k.fullkey = 'XXXXXXXXXXXX')
--and k.fullkey = '013619040022' 
and GradeCode = '99' 
--and gradecode in ('12','16','20','24','28','32','36','40','44','48','52','56','60','64','70','71','72','73','99')
and RaceCode = '9' and SexCode = '9' 
--and k.schooltype = '6'
--and k.Gradecode = '48'
and disabilitycode = '9'
--and k.schooltype = '3'
--and gradecode = '72'
--and rollupschooltype = '72'


order by k.year, k.fullkey, CESA, County, schooltype, [District Number], [School Number], [OrgLevelLabel], GradeCode, RaceCode, SexCode, DisabilityCode

*/











