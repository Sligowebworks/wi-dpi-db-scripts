if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_TeacherQualifications]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_TeacherQualifications]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE view dbo.v_TeacherQualifications as

-- this is v_TeacherQualificationsKeys21.sql - derived from v_Template_Keys_WithSchooltypes

-- this view uses schooltypes as a separate column - v_Template_Keys uses grade column to key on schooltypes -
-- may have to exclude grades 70,71,72,73, maybe others, to avoid redundancy

--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_TeacherQualifications]') and OBJECTPROPERTY(id, N'IsView') = 1)
--drop view [dbo].[v_TeacherQualifications]
--GO

Select k.Year, 'YearFormatted' = cast((rtrim(cast((cast(k.year as int) - 1) as char)) + '-' + right(k.year,2)) as char(7)),
k.fullkey,
k.agencykey,
'AgencyType' = left(right(k.fullkey,6),2),
k.CESA,
k.County,
k.schooltype,
k.conferencekey,
k.SchooltypeCode,
'SchooltypeLabel2' = (case left(k.SchooltypeLabel,1) when 'E' then '    ' + k.SchooltypeLabel when 'M' then '   ' + k.SchooltypeLabel when 'H' then '  ' + k.SchooltypeLabel when 'C' then ' ' + k.SchooltypeLabel else k.SchooltypeLabel end),
'SchooltypeLabel' = (case left(k.SchooltypeLabel2,3) when 'Ele' then '    ' + k.SchooltypeLabel2 when 'Mid' then '   ' + k.SchooltypeLabel2 when 'Hi' then '  ' + k.SchooltypeLabel2 when 'El/' then ' ' + k.SchooltypeLabel2 else k.SchooltypeLabel2 end),
'SchooltypeLabel3' = (case left(k.SchooltypeLabel3,3) when 'Ele' then '    ' + k.SchooltypeLabel3 when 'Mid' then '   ' + k.SchooltypeLabel3 when 'Hig' then '  ' + k.SchooltypeLabel3 when 'El/' then ' ' + k.SchooltypeLabel3 else k.SchooltypeLabel3 end),
'SchooltypeLabel4' = (case left(k.SchooltypeLabel3,3) when 'Ele' then '    ' + (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': ' + k.SchooltypeLabel3 when 'Mid' then '   ' + (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': ' + k.SchooltypeLabel3  when 'Hig' then '  ' + (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': ' + k.SchooltypeLabel3 when 'El/' then ' '  + (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': ' + k.SchooltypeLabel3 else (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': ' + k.SchooltypeLabel3 end),
--'SchooltypeLabel5' = (case left(k.SchooltypeLabel5,1) when 'E' then '    ' + k.SchooltypeLabel5 when 'M' then '   ' + k.SchooltypeLabel5 when 'H' then '  ' + k.SchooltypeLabel5 when 'C' then ' ' + k.SchooltypeLabel5 else k.SchooltypeLabel5 end),
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
GradeCode, GradeLabel, GradeShortLabel, RaceCode, RaceLabel, RaceShortLabel, SexCode, SexLabel,

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
--AthlConfName, ConferenceKey,
-- combines district and school
'LinkedName' =
	case
		WHEN k.fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools'
		WHEN RIGHT(k.Fullkey, 1) = 'X' THEN rtrim(
			CASE
				WHEN k.districtwebaddress IS NULL THEN rtrim(k.Districtname)
				WHEN ltrim(rtrim(k.districtwebaddress))  = '' THEN rtrim(k.Districtname)
				WHEN LEFT(k.districtwebaddress, 3)  = 'FTP' THEN '<a href=javascript:popup(''ftp://' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>' + rtrim(k.districtname)  + '</A>'
				ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>'
			END)
		ELSE rtrim(
			CASE
				WHEN k.districtwebaddress IS NULL THEN rtrim(k.Districtname)
				WHEN ltrim(rtrim(k.districtwebaddress))  = '' THEN rtrim(k.Districtname)
				WHEN LEFT(k.districtwebaddress, 3)  = 'FTP' THEN '<a href=javascript:popup(''ftp://' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>' + rtrim(k.districtname)  + '</A>'
				ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>'
			END)
			+ ' / ' + 	rtrim(
			CASE
				WHEN k.schoolwebaddress IS NULL THEN rtrim(k.Schoolname)
				WHEN ltrim(rtrim(k.schoolwebaddress))  = '' THEN rtrim(k.Schoolname)
				WHEN LEFT(k.schoolwebaddress, 3)  = 'FTP' THEN '<a href=javascript:popup(''ftp://' + rtrim(k.schoolwebaddress) + ''') onClick=''setCookie(question, url)''>' + rtrim(k.schoolname)  + '</A>'
				ELSE '<a href=javascript:popup(''' + rtrim(k.schoolwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.schoolname)  + '</A>'
			END)
END,

-- website URL from districts table
'LinkedDistrictName' =
 case
	when districtwebaddress is null then rtrim(k.Districtname)
	when ltrim(rtrim(districtwebaddress))  = '' then rtrim(k.Districtname)
	when left(districtwebaddress, 3)  = 'ftp' then "<a href=javascript:popup('ftp://" + rtrim(districtwebaddress) + "') onclick='setcookie(question, url)'>" + rtrim(districtname)  + "</a>"
	ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>'
end,

-- website URL from schools table
'LinkedSchoolName' =
 case
	when schoolwebaddress is null then rtrim(k.Schoolname)
	when ltrim(rtrim(schoolwebaddress))  = '' then rtrim(k.Schoolname)
	when left(schoolwebaddress, 3)  = 'ftp' then "<a href=javascript:popup('ftp://" + rtrim(schoolwebaddress) + "') onclick='setcookie(question, url)'>" + rtrim(schoolname)  + "</a>"
	ELSE '<a href=javascript:popup(''' + rtrim(k.schoolwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.schoolname)  + '</A>'
end,

-- additional columns for the data table can be added here - use isnull() to zero-out missing rows

k.LinkSubjectCode, k.LinkSubjectLabel,
'FTETotal' = isnull([FTE],0),
'FTELicenseFull' = isnull([FTELicenseFull],0),
'LicenseFullFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTELicenseFull],0) / isnull([FTE],0)) * 100) end) as char) end,
'LicenseEmerFTE' = isnull([FTELicenseEmer],0),
'LicenseEmerFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTELicenseEmer],0) / isnull([FTE],0)) * 100) end) as char) end,
'LicenseNoFTE' = isnull([FTELicenseNo],0),
'LicenseNoFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTELicenseNo],0) / isnull([FTE],0)) * 100) end) as char) end,
'EHQYesFTE' = isnull([FTEEHQYes],0),
'EHQYesFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTEEHQYes],0) / isnull([FTE],0)) * 100) end) as char) end,
'EHQNoFTE' = isnull([FTEEHQNo],0),
'EHQNoFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTEEHQNo],0) / isnull([FTE],0)) * 100) end) as char) end,
'LocalExperience5YearsOrLessFTE' = (case isnull([FTE],0) when 0 then 0 else ([FTE] - isnull([FTE5YearsOrMoreLocal],0)) end),
'LocalExperience5YearsOrMoreFTE' = isnull([FTE5YearsOrMoreLocal],0),
'LocalExperience5YearsOrMoreFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTE5YearsOrMoreLocal],0) / isnull([FTE],0)) * 100) end) as char) end,
'TotalExperience5YearsOrLessFTE' = (case isnull([FTE],0) when 0 then 0 else ([FTE] - isnull([FTE5YearsOrMoreTotal],0)) end),
'TotalExperience5YearsOrMoreFTE' = isnull([FTE5YearsOrMoreTotal],0),
'TotalExperience5YearsOrMoreFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTE5YearsOrMoreTotal],0) / isnull([FTE],0)) * 100) end) as char) end,
'DegreeMastersOrHigherFTE' = isnull([FTEDegreeMastersOrHigher],0),
'DegreeMastersOrHigherFTEPercentage' = case cast(isnull([FTE],0) as float) when 0 then '--' else cast((case isnull([FTE],0) when 0 then 0 else ((isnull([FTEDegreeMastersOrHigher],0) / isnull([FTE],0)) * 100) end) as char) end,
'LicenseCountTotal' = isnull([LicenseTotal],0),
'LicenseCountFull' = isnull([LicenseFull],0),
'LicenseCountEmer' = isnull([LicenseEmer],0),
'LicenseCountNo' = isnull([LicenseNo],0),
'EHQCountTotal' = isnull([EHQTotal],0),
'EHQCountYes' = isnull([EHQYes],0),
'EHQCountNo' = isnull([EHQNo],0),
'LocalExperience' = isnull([LocalExperience],0),
'TotalExperience' = isnull([TotalExperience],0),
'DegreeHighSchool' = isnull([DegreeHighSchool],0),
'DegreeAssoc' = isnull([DegreeAssoc],0),
'DegreeBach' = isnull([DegreeBach],0),
'DegreeMast' = isnull([DegreeMast],0),
'Degree6YrSpec' = isnull([Degree6YrSpec],0),
'DegreeDoc' = isnull([DegreeDoc],0),
'DegreeOther' = isnull([DegreeOther],0),
'DegreeN' = isnull([DegreeN],0)


-- the place where you should put your join is commented down below

from (

-- school level
select agency.year, agency.fullkey, agency.agencykey,
--agency.schooltype,
(case agency.schooltype when '4' then '5' else agency.schooltype end) as 'schooltype',
tblSchoolTypesReal.SchoolTypeCode as 'SchooltypeCode', tblSchoolTypesReal.SchoolTypeLabel as 'SchooltypeLabel', tblSchoolTypesReal.SchoolTypeLabel2 as 'SchooltypeLabel2', tblSchoolTypesReal.SchoolTypeLabel3 as 'SchooltypeLabel3',
agency.conferencekey,
agency.schoolcat,
agency.CESA, agency.County, agency.district as 'DistrictCode', agency.school as 'SchoolCode',
rtrim(schools.name) as 'name', rtrim(districts.name) as 'districtname', rtrim(schools.name) as 'schoolname',
grademap.grade as GradeCode, grademap.name as GradeLabel, grademap.ABBR as GradeShortLabel,
Race.Num as RaceCode, Race.name as RaceLabel, Race.shortname as RaceShortLabel,
Sex.Num as SexCode, Sex.name as SexLabel,
rtrim(districts.webaddress) as 'districtwebaddress', rtrim(schools.webaddress) as 'schoolwebaddress',
--athletic_conf.Name as 'AthlConfName', athletic_conf.ConferenceKey,
tblTQLinkSubjects.LinkSubjectCode, tblTQLinkSubjects.LinkSubjectLabel
from grademap,

-- adds unknown and all keys
(Select num, name, shortname from Race
	UNION ALL Select 8 as num, 'No Response' as name, 'No Resp' As shortname
	UNION ALL Select 9 as num, 'All Races' as name, 'All Races' As shortname) Race,

-- adds unknown key
(Select num, name from Sex UNION ALL Select 9 as num, 'Both Genders' As name) Sex,
tblTQLinkSubjects,
tblAgencyFull agency
inner join schools on agency.year = schools.year and agency.fullkey = schools.fullkey
inner join districts on schools.year = districts.year and schools.district = districts.district
--inner join athletic_conf on districts.year = athletic_conf.year and districts.fullkey = athletic_conf.fullkey
inner join tblSchoolTypesReal on (case agency.schooltype when '4' then '5' else agency.schooltype end) = tblSchoolTypesReal.SchoolTypeCode

union all

-- district level
select agency.year, agency.fullkey, agency.agencykey,
--agency.schooltype,
tblSchoolTypesReal.SchoolTypeCode as 'schooltype',
tblSchoolTypesReal.SchoolTypeCode as 'SchooltypeCode', tblSchoolTypesReal.SchoolTypeLabel as 'SchooltypeLabel', tblSchoolTypesReal.SchoolTypeLabel2 as 'SchooltypeLabel2', tblSchoolTypesReal.SchoolTypeLabel3 as 'SchooltypeLabel3',
agency.conferencekey,
agency.schoolcat,
agency.CESA,
agency.County,
agency.district as 'DistrictCode', agency.school as 'SchoolCode',
rtrim(districts.name) as 'name', rtrim(districts.name) as 'districtname', '' as 'schoolname',
grademap.grade as GradeCode, grademap.name as GradeLabel, grademap.ABBR as GradeShortLabel,
Race.Num as RaceCode, Race.name as RaceLabel, Race.shortname as RaceShortLabel,
Sex.Num as SexCode, Sex.name as SexLabel,
rtrim(districts.webaddress) as 'districtwebaddress', '' as 'schoolwebaddress',
--athletic_conf.Name as 'AthlConfName', athletic_conf.ConferenceKey,
tblTQLinkSubjects.LinkSubjectCode, tblTQLinkSubjects.LinkSubjectLabel
from grademap,
tblSchoolTypesReal,
-- adds unknown and all keys
(Select num, name, shortname from Race
	UNION ALL Select 8 as num, 'No Response' as name, 'No Resp' As shortname
	UNION ALL Select 9 as num, 'All Races' as name, 'All Races' As shortname) Race,

-- adds unknown key
(Select num, name from Sex UNION ALL Select 9 as num, 'Both Genders' As name) Sex,
tblTQLinkSubjects,
tblAgencyFull agency inner join districts on agency.year = districts.year and agency.fullkey = districts.fullkey

-- start athletic_conf code
--inner join athletic_conf on districts.year = athletic_conf.year and districts.fullkey = athletic_conf.fullkey


union all

-- state level - may have to modify which column in the years table it pulls
-- consider changing codes for state to those in agency table? except fullkey
select Years.DefaultYear, fullkey = 'XXXXXXXXXXXX', agencykey = 'XXXXX',
--'schooltype' = 'XX',
tblSchoolTypesReal.SchoolTypeCode as 'schooltype',
tblSchoolTypesReal.SchoolTypeCode as 'SchooltypeCode', tblSchoolTypesReal.SchoolTypeLabel as 'SchooltypeLabel', tblSchoolTypesReal.SchoolTypeLabel2 as 'SchooltypeLabel2', tblSchoolTypesReal.SchoolTypeLabel3 as 'SchooltypeLabel3',
'conferencekey' = 0,
'schoolcat' = '',
-- not sure about this......
'02' as 'CESA',
'99' as County,
'7300' as 'DistrictCode', '' as 'SchoolCode',
'WI Public Schools' as 'name', 'WI Public Schools' as 'districtname', '' as 'schoolname',
grademap.grade as GradeCode, grademap.name as GradeLabel, grademap.ABBR as GradeShortLabel,
Race.Num as RaceCode, Race.name as RaceLabel, Race.shortname as RaceShortLabel,
Sex.Num as SexCode, Sex.name as SexLabel,
'' as 'districtwebaddress', '' as 'schoolwebaddress',
--'Wisconsin DPI' as 'AthlConfName', '99' as ConferenceKey,
tblTQLinkSubjects.LinkSubjectCode, tblTQLinkSubjects.LinkSubjectLabel
from Years, grademap,
tblSchoolTypesReal,
-- adds unknown and all keys
(Select num, name, shortname from Race
	UNION ALL Select 8 as num, 'No Response' as name, 'No Resp' As shortname
	UNION ALL Select 9 as num, 'All Races' as name, 'All Races' As shortname) Race,

-- adds unknown key
(Select num, name from Sex UNION ALL Select 9 as num, 'Both Genders' As name) Sex,
tblTQLinkSubjects

) k

-- put a left outer join to the data table here if you can - or you can create another view that does a left outer join from this view

left outer join [tblTeacherQualifications] on

k.[Year] = [tblTeacherQualifications].[Year] and k.[FullKey] = [tblTeacherQualifications].[FullKey] and cast(k.[SchoolTypeCode] as char)= cast([tblTeacherQualifications].[SchoolType] as char)
and k.[LinkSubjectCode] = [tblTeacherQualifications].[LinkSubject] and k.[RaceCode] = [tblTeacherQualifications].[Race] and k.[SexCode] = [tblTeacherQualifications].[Gender]

where
-- not using combined groups - no grades
k.racecode <> '6' and k.GradeCode = '99'

--this part of the where statement is for test purposes only - un-commenting it gives you a recordset of reasonable size to test against - it should be commented out for production
--and k.year = '2003' and (k.fullkey = '013619040223' or k.fullkey = '01361903XXXX' or k.fullkey = 'XXXXXXXXXXXX') and k.GradeCode = '99' and k.RaceCode = '9' and k.SexCode = '9'
--and k.year = '2007' and k.fullkey = 'XXXXXXXXXXXX' and k.RaceCode = '9' and k.SexCode = '9' and LinkSubjectCode = 'sumall'
--and k.schooltypecode = '6'

--and k.fullkey = '090196040060'

-- test order by
--order by k.year, k.fullkey, k.schooltypelabel, k.racecode, k.sexcode, k.gradecode, k.linksubjectcode





GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

