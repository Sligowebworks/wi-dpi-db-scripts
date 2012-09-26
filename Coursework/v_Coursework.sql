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
	keys.[year]
  ,keys.[YearFormatted]
  ,keys.[fullkey]
  ,keys.[agencykey]
  ,keys.[AgencyType]
  ,keys.[CESA]
  ,keys.[County]
  ,keys.[ConferenceKey]
  ,keys.[schooltype]
  ,keys.[RollupSchooltype]
  ,keys.[District Number]
  ,keys.[School Number]
  ,keys.[charter]
  ,keys.[OrgLevelLabel]
  ,keys.[OrgSchoolTypeLabel]
  ,keys.[OrgSchoolTypeLabelAbbr]
  ,keys.[Name]
  ,keys.[District Name]
  ,keys.[School Name]
  ,keys.[Grade]
  ,keys.[GradeCode]
  ,keys.[GradeLabel]
  ,keys.[GradeShortLabel]
  ,keys.[Race]
  ,keys.[RaceCode]
  ,keys.[RaceLabel]
  ,keys.[RaceShortLabel]
  ,keys.[Sex]
  ,keys.[SexCode]
  ,keys.[SexLabel]
  ,keys.[DisabilityCode]
  ,keys.[DisabilityLabel]
  ,keys.[ShortDisabilityLabel]
  ,keys.[Student Group]
  ,keys.[StudentGroupLabel]
  ,keys.[LinkedName]
  ,keys.[LinkedDistrictName]
  ,keys.[LinkedSchoolName]
  ,keys.[Total Enrollment PreK-12]
  ,keys.[enrollment]
  ,keys.[suppressed]

  ,course_keys.CourseTypeID
  ,course_keys.WMASID1

  , "Course" = C.Description
  
, "# Who Took Course" = (case when C.Description is null then 'NA' else isnull(cast(Coursework.Enrollment as char(18)),'0') end)

, "% Who Took Course" = 
	CASE WHEN Keys.Enrollment > 0 THEN
		CASE WHEN keys.suppressed = -10 then '*' 
		ELSE Isnull(cast(((isnull(cast(Coursework.Enrollment as numeric(18)),0)/Keys.Enrollment)*100) as char(18)),'0') 
		END
	ELSE '0'
	END
FROM 
v_Template_Keys_WWoDis_tblAgencyFull keys
	CROSS JOIN
 (
	(Select SubjectID, Topic, Advanced, Description as 'CourseType', TypeID as 'CourseTypeID' ,WMASID1,WMASID2  
	 FROM Courses WHERE year = (SELECT max(year) from courses)
		UNION ALL
	SELECT DISTINCT  SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description, 5 as TypeID, 14 as WMASID1, 0 as WMASID2  
	FROM Courses where year = (SELECT max(year) from courses)
		UNION ALL
	SELECT 'ALL' as SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description,5 as TypeID, 14 as WMASID1, 0 as WMASID2
)
) course_keys
	LEFT OUTER JOIN 
Coursework ON 
	Keys.Year = Coursework.Year 
	AND Keys.Fullkey = Coursework.Fullkey
	AND course_keys.SubjectID = Coursework.SubjectID
	AND course_keys.Topic = Coursework.Topic
	AND (
		(keys.grade = '94' AND Coursework.Grade = '94') OR 
		(keys.grade = '40' AND Coursework.Grade = '06') OR 
		(keys.grade = '44' AND Coursework.Grade = '07') OR 
		(keys.grade = '48' AND Coursework.Grade = '08') OR 
		(keys.grade = '52' AND Coursework.Grade = '09') OR 
		(keys.grade = '56' AND Coursework.Grade = '10') OR 
		(keys.grade = '60' AND Coursework.Grade = '11') OR 
		(keys.grade = '64' AND Coursework.Grade = '12') 
	)
	AND Keys.Sex = Coursework.Sex
	LEFT OUTER JOIN 
Courses C on
Keys.Year = C.Year and
course_keys.SubjectID = C.SubjectID and
course_keys.Topic = C.Topic

WHERE 
Keys.Race = '9' 
AND Keys.disabilityCode = 9
--Keys.Grade in (40,44,48,52,56,60,64,94)
