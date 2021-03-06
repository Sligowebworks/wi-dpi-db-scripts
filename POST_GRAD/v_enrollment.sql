USE [Wisconsin]
GO
/****** Object:  View [dbo].[v_Enrollment]    Script Date: 05/02/2012 12:19:57 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[v_Enrollment]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[v_Enrollment]

GO
/****** Object:  View [dbo].[v_Enrollment]    Script Date: 05/02/2012 12:19:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE view [dbo].[v_Enrollment] as

Select 
	k.[year]
      ,k.[YearFormatted]
      ,k.[fullkey]
      ,k.[agencykey]
      ,k.[CESA]
      ,k.[County]
      ,k.[ConferenceKey]
      ,k.[AgencyType]
      ,k.[schooltype]
      ,k.[SchoolTypeLabel]
      ,k.[SchoolTypeLabelShort]
      ,k.[SchoolTypeLabelLong]
      ,k.[RollupSchooltype]
      ,k.[District Number]
      ,k.[School Number]
      ,k.[charter]
      ,k.[OrgLevelLabel]
      ,k.[OrgSchoolTypeLabel]
      ,k.[OrgSchoolTypeLabelAbbr]
      ,k.[Name]
      ,k.[District Name]
      ,k.[School Name]
      ,k.[Grade]
      ,k.[GradeCode]
      ,k.[GradeLabel]
      ,k.[GradeShortLabel]
      ,k.[Race]
      ,k.[RaceCode]
      ,k.[RaceLabel]
      ,k.[RaceShortLabel]
      ,k.[Sex]
      ,k.[SexCode]
      ,k.[SexLabel]
      ,k.[DisabilityCode]
      ,k.[DisabilityLabel]
      ,k.[ShortDisabilityLabel]
      ,k.[EconDisadv]
      ,k.[EconDisadvLabel]
      ,k.[ShortEconDisadvLabel]
      ,k.[ELPCode]
      ,k.[ELPLabel]
      ,k.[ShortELPLabel]
      ,k.[Student Group]
      ,k.[StudentGroupLabel]
      ,k.[LinkedName]
      ,k.[LinkedDistrictName]
      ,k.[LinkedSchoolName]
      ,k.[Total Enrollment PreK-12]
      ,k.[suppressed]
	, k.[GradeCode] as 'Grade'  -- backwards compatible column name
	, k.[RaceCode] as 'Race' -- backwards compatible column name
	, k.SexCode as 'Sex' -- backwards compatible column name

FROM 
v_Template_Keys_WWoDis_tblAgencyFull k LEFT OUTER JOIN enrollment e
on k.year = e.year and k.fullkey = e.fullkey and k.gradecode = e.grade and k.racecode = e.race and k.sexcode = e.sex


---- TEST:
-- --where k.year = '2002' and k.fullkey = 'XXXXXXXXXXXX' and k.gradecode = '99' and k.racecode = '9' and k.sexcode = '9'
--WHERE k.fullkey in ('07329003XXXX') AND k.SchoolType in ('9')
--AND AgencyType IN ('03', '04', '4C', '49', 'XX') 
--AND k.year IN (2011) 
----AND k.Race in ('0', '1', '2', '3', '4', '6', '5') 
--AND K.Race IN (0)
--AND k.Sex in ('9')


GO

GRANT SELECT on v_enrollment to Public
GO

GRANT SELECT on v_enrollment to netwisco
GO