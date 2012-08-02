USE [Wisconsin]
GO
/****** Object:  View [dbo].[v_POST_GRAD_INTENT]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View [dbo].[v_POST_GRAD_INTENT]  ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[v_POST_GRAD_INTENT]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[v_POST_GRAD_INTENT]

GO

CREATE VIEW [dbo].[v_POST_GRAD_INTENT]
AS

SELECT 
  K.[Year]
, K.[fullkey]
, K.AgencyType
, K.[County], K.[CESA], [District] = k.[District Number], K.[SchoolType] 
, K.[ConferenceKey]
, K.[Race]
, K.[RaceLabel]
, [RaceShortLabel] = -- Make historic labels consistent for Graph (sorting)
	CASE K.[RaceShortLabel]
		WHEN 'Black Not Hisp' THEN 'Black'
		WHEN 'Hisp' THEN 'Hispanic'
		ELSE K.[RaceShortLabel]
	END
, K.[Sex]
, K.[SexLabel]
, [PriorYear] = (cast((K.Year - 1) AS char(4)) + '-' + cast(right(K.Year,2) AS char(4)))
, K.[YearFormatted]
, [DistState] = CASE WHEN K.Fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools' WHEN RIGHT(K.Fullkey, 1) = 'X' THEN K.[District Name] ELSE K.[School Name] END
, K.[District Number], K.[District Name]
, K.[School Number], K.[School Name], K.[GradeLabel]
, [Student Group], [StudentGroupLabel], [OrgLevelLabel], [OrgSchoolTypeLabel], [agencykey], [charter], [LinkedDistrictName]
, [LinkedSchoolName], [LinkedName], [Name]
, [Grade 12 Enrollment] = K.enrollment
, K.[Suppressed]

, [Number of Graduates] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number of Graduates] END

, [Number 4-Year College] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number 4-Year College] END
, '% 4-Year College' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% 4-Year College] as char) end)

, [Number Voc/Tech College] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Voc/Tech College] END
, '% Voc/Tech College' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Voc/Tech College] as char) end)

, [Number Job Training] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Job Training] END
, '% Job Training' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Job Training] as char) end)

, [Number Employment] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Employment] END
, '% Employment' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Employment] as char) end)

, [Number Military] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Military] END
, '% Military' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Military] as char) end)

, [Number Seeking Employment] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Seeking Employment] END
, '% Seeking Employment' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Seeking Employment] as char) end)

, [Number Other Plans] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Other Plans] END
, '% Other Plans' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Other Plans] as char) end)

, [Number Undecided] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Undecided] END
, '% Undecided' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Undecided] as char) end)

, [Number No Response] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number No Response] END
, '% No Response' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% No Response] as char) end)

, [Number Miscellaneous] = CASE WHEN K.Suppressed = - 10 THEN '*' ELSE [Number Miscellaneous] END
, '% Miscellaneous' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Miscellaneous] as char) end)

 
FROM 
v_Template_Keys_WWoDis_tblAgencyFull K
LEFT OUTER JOIN
POST_GRAD_INTENT_CUBE P

on K.fullkey = P.fullkey
AND K.year = P.year
AND K.Race = P.Race
AND K.Sex = P.Sex

WHERE 
K.GradeCode = 64
AND K.disabilityCode = 9


GO