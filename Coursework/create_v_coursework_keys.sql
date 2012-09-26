USE [Wisconsin]
GO
/*
***** Object:  View [dbo].[v_COURSEWORK_KEYS]    Script Date: 09/26/2012 15:25:10 *****
*/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[v_COURSEWORK_KEYS]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[v_COURSEWORK_KEYS]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[v_COURSEWORK_KEYS] as
Select k.year, 'YearFormatted' = cast((rtrim(cast((cast(k.year as int) - 1) as char)) + '-' + right(k.year,2)) as char(7)),
k.fullkey,
k.agencykey,
'AgencyType' = left(right(k.fullkey,6),2),
k.CESA,
k.County,
k.ConferenceKey,
k.schooltype,
k.DistrictCode as 'District Number',
k.SchoolCode as 'School Number',
'charter' = (case k.schoolcat when 'CHR' then 'Y' else 'N' end),
'OrgLevelLabel' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end),
'OrgSchoolTypeLabel' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary',
'OrgSchoolTypeLabelAbbr' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary',
-- combines district and school
'Name' = rtrim(
	case
		WHEN k.Fullkey = 'XXXXXXXXXXXX' THEN (' ' + 'WI Public Schools')
		WHEN right(k.Fullkey,1) = 'X' THEN ('  ' + rtrim(Districtname))
		else ('   ' + rtrim(Districtname) + ' / ' + rtrim(Schoolname))
	end),
'District Name' = ('  ' +  rtrim(Districtname)),
'School Name' = ('   ' + rtrim(Schoolname)),
-- pulling columns multiple times with different names for backward compatibility
GradeCode as 'Grade', GradeCode, GradeLabel, GradeLabel as 'GradeName', GradeShortLabel, RaceCode, RaceLabel, RaceShortLabel, SexCode, SexCode as 'Sex',
SexLabel, SexLabel as 'SexDesc',

-- if these codes ever change, be sure to change BOTH case statements - must customize for WKCE, LEP, EconStatus, Disabilities, maybe others
'Student Group' = (Case
when RaceCode = '9' and SexCode = '9' then
	(Case
		when fullkey = 'XXXXXXXXXXXX' then '2'
		when right(fullkey,1) = 'X' then '3'
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
		when fullkey = 'XXXXXXXXXXXX' then 'Students in Wisconsin Public Schools'
		when right(fullkey,1) = 'X' then 'Students in this District'
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
	else "<a href=javascript:popup('" + rtrim(districtwebaddress) + "') onclick='setcookie(question, url)'>"+ rtrim(districtname)  + "</a>"
end,

-- website URL from schools table
'LinkedSchoolName' =
 case
	when schoolwebaddress is null then rtrim(k.Schoolname)
	when ltrim(rtrim(schoolwebaddress))  = '' then rtrim(k.Schoolname)
	when left(schoolwebaddress, 3)  = 'ftp' then "<a href=javascript:popup('ftp://" + rtrim(schoolwebaddress) + "') onclick='setcookie(question, url)'>" + rtrim(schoolname)  + "</a>"
	else "<a href=javascript:popup('" + rtrim(schoolwebaddress) + "') onclick='setcookie(question, url)'>"+ rtrim(schoolname)  + "</a>"
end

-- additional columns for the data table can be added here - use isnull() to zero-out missing rows

-- coursework columns
,
k.SubjectId,
k.SubjectDescription,
k.Topic,
k.Advanced,
k.CourseDescription,
k.CourseTypeID,
k.CourseType,
k.WMASID1,
k.WMAS_Description1


-- the place where you should put your join is commented down below

from (

-- district level
select agency.year, agency.fullkey, agency.agencykey, agency.schooltype, agency.schoolcat,
agency.CESA,
agency.County,
agency.ConferenceKey,
agency.district as 'DistrictCode', agency.school as 'SchoolCode',
rtrim(districts.name) as 'name', rtrim(districts.name) as 'districtname', '' as 'schoolname',
grademap.grade as GradeCode, grademap.name as GradeLabel, grademap.ABBR as GradeShortLabel,
Race.Num as RaceCode, Race.name as RaceLabel, Race.shortname as RaceShortLabel,
Sex.Num as SexCode, Sex.name as SexLabel,
rtrim(districts.webaddress) as 'districtwebaddress', '' as 'schoolwebaddress'

-- coursework columns
,
Courses.SubjectID as SubjectId,
Coursubs.Description as SubjectDescription,
Courses.Topic as Topic,
Courses.Advanced as Advanced,
Courses.Description as CourseDescription,
Courses.TypeID as CourseTypeID,
CourseTypes.Description as CourseType,
Courses.WMASID1 as WMASID1,
COURSES_WMAS_SUBJ.Description as WMAS_Description1


from grademap,

-- adds unknown and all keys
(Select num, name, shortname from Race
	UNION ALL Select 8 as num, 'No Response' as name, 'No Resp' As shortname
	UNION ALL Select 9 as num, 'All Races' as name, 'All Races' As shortname) Race,

-- adds unknown key
(Select num, name from Sex UNION ALL Select 9 as num, 'Both Genders' As name) Sex,

tblAgencyFull agency inner join districts on agency.year = districts.year and agency.fullkey = districts.fullkey
-- coursework froms
,

(Select SubjectID, Topic, Advanced, Description, TypeID,WMASID1,WMASID2  from Courses where year = (Select Year from v_COURSE_YEAR)
/* v_Course_Year allows use to use only the current courses in our keyset */
UNION ALL
Select distinct  SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description, 5 as TypeID, 14 as WMASID1, 0 as WMASID2  from Courses where year = (Select Year from v_COURSE_YEAR)
UNION ALL
Select 'ALL' as SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description,5 as TypeID, 14 as WMASID1, 0 as WMASID2
) Courses,

(Select * from coursubs where year = (Select Year from v_COURSE_YEAR)) Coursubs,
CourseTypes, Courses_WMAS_SUBJ

WHERE agency.Year >= 1997 and (RIGHT(agency.fullkey, 1) = 'X') and
grademap.Grade in (40,44,48,52,56,60,64,94) and  Courses.SubjectID = Coursubs.Subjectid
and Courses.TypeID = CourseTypes.CourseTypeID
and Courses.WMASID1 = COURSES_WMAS_SUBJ.WMASID

-- test
--and agency.year = '2002'

union all

-- state level - may have to modify which column in the years table it pulls
-- consider changing codes for state to those in agency table? except fullkey
select Years.DefaultYear, fullkey = 'XXXXXXXXXXXX', agencykey = 'XXXXX', 'schooltype' = 'XX', 'schoolcat' = '',
-- not sure about this......
'02' as 'CESA',
'99' as County,
'00' as 'ConferenceKey',
'7300' as 'DistrictCode', '' as 'SchoolCode',
'WI Public Schools' as 'name', 'WI Public Schools' as 'districtname', '' as 'schoolname',
grademap.grade as GradeCode, grademap.name as GradeLabel, grademap.ABBR as GradeShortLabel,
Race.Num as RaceCode, Race.name as RaceLabel, Race.shortname as RaceShortLabel,
Sex.Num as SexCode, Sex.name as SexLabel,
'' as 'districtwebaddress', '' as 'schoolwebaddress'

-- coursework columns
,
Courses.SubjectID as SubjectId,
Coursubs.Description as SubjectDescription,
Courses.Topic as Topic,
Courses.Advanced as Advanced,
Courses.Description as CourseDescription,
Courses.TypeID as CourseTypeID,
CourseTypes.Description as CourseType,
Courses.WMASID1 as WMASID1,
COURSES_WMAS_SUBJ.Description as WMAS_Description1

from Years, grademap,

-- adds unknown and all keys
(Select num, name, shortname from Race
	UNION ALL Select 8 as num, 'No Response' as name, 'No Resp' As shortname
	UNION ALL Select 9 as num, 'All Races' as name, 'All Races' As shortname) Race,

-- adds unknown key
(Select num, name from Sex UNION ALL Select 9 as num, 'Both Genders' As name) Sex

-- coursework froms
,

(Select SubjectID, Topic, Advanced, Description, TypeID,WMASID1,WMASID2  from Courses where year = (Select Year from v_COURSE_YEAR)
/* v_Course_Year allows use to use only the current courses in our keyset */
UNION ALL
Select distinct  SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description, 5 as TypeID, 14 as WMASID1, 0 as WMASID2  from Courses where year = (Select Year from v_COURSE_YEAR)
UNION ALL
Select 'ALL' as SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description,5 as TypeID, 14 as WMASID1, 0 as WMASID2
) Courses,

(Select * from coursubs where year = (Select Year from v_COURSE_YEAR)) Coursubs,
CourseTypes, Courses_WMAS_SUBJ

WHERE --agency.Year >= 1997 and (RIGHT(agency.fullkey, 1) = 'X') and
grademap.Grade in (40,44,48,52,56,60,64,94) and  Courses.SubjectID = Coursubs.Subjectid
and Courses.TypeID = CourseTypes.CourseTypeID
and Courses.WMASID1 = COURSES_WMAS_SUBJ.WMASID

) k

-- put a left outer join to the data table here if you can - or you can create another view that does a left outer join from this view

where --(racecode = '9' or sexcode = '9') and
--gradecode = '94' and
racecode = '9' --and sexcode = '9'
--and CourseTypeID = '1' and WMASID1 = '4'

--test
--and year = '2002' and fullkey = 'XXXXXXXXXXXX'

--and year = '1997' and fullkey = '01361903XXXX'


--this where statement is for test purposes only - un-commenting it gives you a recordset of reasonable size to test against - it should be commented out for production
--where year = '2002' and (fullkey = '013619040223' or fullkey = '01361903XXXX' or fullkey = 'XXXXXXXXXXXX') and GradeCode = '99' and RaceCode <> '9' and SexCode = '9'

