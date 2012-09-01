USE [Wisconsin]
GO

/****** Object:  View [dbo].[v_COURSEWORK]    Script Date: 08/31/2012 19:03:23 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[v_COURSEWORK]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[v_COURSEWORK]
GO

/****** Object:  View [dbo].[v_COURSEWORK]    Script Date: 08/31/2012 19:02:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[v_COURSEWORK]
AS
SELECT 
keys.year, Keys.fullkey, 
(cast((Keys.Year - 1) AS char(4)) + '-' + cast(right(Keys.Year,2) AS char(2))) AS 'PriorYear', 
'DistState' = CASE WHEN Keys.Fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools' Else ' ' +  districts.Name END, 
'SchooltypeLabel' = 'Summary', 
'OrgLevelLabel' = CASE WHEN Keys.Fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools' Else ' ' + districts.Name END, 
'OrgSchoolTypeLabel' = (case when keys.fullkey = 'XXXXXXXXXXXX' then ' State' when right(keys.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary', 
'OrgSchoolTypeLabelAbbr' = (case when keys.fullkey = 'XXXXXXXXXXXX' then ' State' when right(keys.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary', 
'Name' = CASE WHEN Keys.Fullkey = 'XXXXXXXXXXXX' THEN ' State' Else ' ' +  districts.Name END, 
keys.LinkedDistrictName, 
keys.LinkedName, 
Keys.YearFormatted,
'AgencyType' = left(right(Keys.fullkey,6),2),
Keys.CESA,
Keys.County, 
Keys.ConferenceKey, 
Keys.[District Number],
Keys.[School Number],
Keys.[District Name],
Keys.[School Name],
Keys.[GradeLabel], 
Keys.[RaceLabel],
Keys.[SexLabel],
Keys.[StudentGroupLabel],
Keys.[Student Group],
Keys.[schooltype],
Keys.[agencykey],
Keys.[charter],
Keys.[SexCode],

Keys.SubjectDescription as 'Subject',
Keys.SubjectID,
Keys.Topic,
Keys.CourseDescription as 'Course',
Keys.CourseTypeID,
Keys.CourseType,
Keys.WMASID1,
Keys.WMAS_Description1,
Keys.Grade, Keys.GradeName, keys.Sex, Keys.SexDesc, 
'Advanced' = Case Keys.Advanced when 'Y' then 'YES' ELSE 'NO' END,
isnull(cast(E.enrollment as char(18)),'0') as enrollment,
--"# Who Took Course" = isnull(cast(Coursework.Enrollment as char(18)),'0'),
"# Who Took Course" = (case when C.Description is null then 'NA' else isnull(cast(Coursework.Enrollment as char(18)),'0') end),

"% Who Took Course" = CASE WHEN E.Enrollment > 0 THEN
	CASE WHEN E.SUPPRESSED = -10 then '*' 
	else
		Isnull(cast(((isnull(cast(Coursework.Enrollment as numeric(18)),0)/E.Enrollment)*100) as char(18)),'0') 
	END

ELSE
	'0'
END
FROM v_Coursework_Keys Keys
LEFT OUTER JOIN 
ENROLLMENT E on 
(Keys.Year = E.Year AND 
Keys.Fullkey = E.Fullkey and 
Keys.grade = E.Grade and
Keys.Sex = E.Sex and 
E.Race = '9' )
LEFT OUTER JOIN
Coursework ON 
(Keys.Year = Coursework.Year AND 
Keys.Fullkey = Coursework.Fullkey AND
Keys.SubjectID = Coursework.SubjectID AND
Keys.Topic = Coursework.Topic AND
(
(keys.grade = '94' and Coursework.Grade = '94') or 
(keys.grade = '40' and Coursework.Grade = '06') or 
(keys.grade = '44' and Coursework.Grade = '07') or 
(keys.grade = '48' and Coursework.Grade = '08') or 
(keys.grade = '52' and Coursework.Grade = '09') or 
(keys.grade = '56' and Coursework.Grade = '10') or 
(keys.grade = '60' and Coursework.Grade = '11') or 
(keys.grade = '64' and Coursework.Grade = '12') 
)
and Keys.Sex = Coursework.Sex
)
LEFT OUTER JOIN
    DISTRICTS ON (Districts.Year = Keys.Year AND 
 LEFT(Districts.Fullkey, 6) = LEFT(Keys.FullKey, 6)) 
-- jdj
left outer join courses C on
Keys.Year = C.Year and
Keys.SubjectID = C.SubjectID and
Keys.Topic = C.Topic
