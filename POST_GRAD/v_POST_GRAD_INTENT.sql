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

SELECT K.[year]
, K.[fullkey]
, AgencyType
, [County], [CESA], [District] = [District Number], [SchoolType] = COALESCE([SchoolType], '9')
--, [SchoolTypeLabel]
, [ConferenceKey]
, K.[Race]
, [RaceLabel]
, RaceShortLabel
, K.[Sex]
, [SexLabel]
, [PriorYear] = (cast((K.Year - 1) AS char(4)) + '-' + cast(right(K.Year,2) AS char(4)))
, [YearFormatted]
, [DistState] = CASE WHEN K.Fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools' WHEN RIGHT(K.Fullkey, 1) = 'X' THEN K.[District Name] ELSE K.[School Name] END
, [District Number], [District Name]
, [School Number], [School Name], [GradeLabel]
, [Student Group], [StudentGroupLabel], [OrgLevelLabel], [OrgSchoolTypeLabel], [agencykey], [charter], [LinkedDistrictName]
, [LinkedSchoolName], [LinkedName], [Name]
, [Grade 12 Enrollment]
, [Number of Graduates]

/*** Aggregates ***/
, [Number 4-Year College]
, '% 4-Year College' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% 4-Year College] as char) end)
, [Number Voc/Tech College]
, '% Voc/Tech College' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Voc/Tech College] as char) end)
, [Number Job Training]
, '% Job Training' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Job Training] as char) end)
, [Number Employment]
, '% Employment' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Employment] as char) end)
, [Number Military]
, '% Military' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Military] as char) end)
, [Number Seeking Employment]
, '% Seeking Employment' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Seeking Employment] as char) end)
, [Number Other Plans]
, '% Other Plans' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Other Plans] as char) end)
, [Number Undecided]
, '% Undecided' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Undecided] as char) end)
, [Number No Response]
, '% No Response' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% No Response] as char) end)
, [Number Miscellaneous]
, '% Miscellaneous' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Miscellaneous] as char) end)

FROM (

SELECT
	E.[Year]	   
, E.[fullkey]
, E.[Race]
, E.[Sex]
, E.[Grade]

, E.enrollment AS 'Grade 12 Enrollment'
 

/*** Aggregates: ***/
, 'Number of Graduates' = CASE 
	WHEN E.Suppressed = -10 THEN '*'
    ELSE cast(MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.COUNT ELSE 0 END) AS char(18)) 
	END 
, 'Number 4-Year College' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast(MAX(CASE WHEN P.IntentCode = '4Y' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% 4-Year College' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = '4Y' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Voc/Tech College' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast(MAX(CASE WHEN P.IntentCode = '2V' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% Voc/Tech College' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = '2V' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Job Training' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast(MAX(CASE WHEN P.IntentCode = '1T' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% Job Training' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = '1T' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Employment' = CASE 
	WHEN E.Suppressed = - 10 THEN '*'
    ELSE cast(MAX(CASE WHEN P.IntentCode = 'EP' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% Employment' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = 'EP' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Military' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast(MAX(CASE WHEN P.IntentCode = 'MI' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% Military' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = 'MI' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Seeking Employment' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast(MAX(CASE WHEN P.IntentCode = 'SE' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% Seeking Employment' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = 'SE' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Other Plans' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast(MAX(CASE WHEN P.IntentCode = 'OT' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% Other Plans' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = 'OT' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Undecided' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast(MAX(CASE WHEN P.IntentCode = 'UD' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% Undecided' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = 'UD' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number No Response' = CASE 
	WHEN E.Suppressed = - 10 THEN '*'
    ELSE cast(MAX(CASE WHEN P.IntentCode = 'NR' THEN P.Grads ELSE 0 END) AS char(18)) 
	END 
, '% No Response' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast((MAX(CASE WHEN P.IntentCode = 'NR' THEN P.Grads ELSE 0 END) 
			/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
			* 100) AS numeric(5, 1)) 
	END 
, 'Number Miscellaneous' = CASE 
	WHEN E.Suppressed = - 10 THEN '*' 
	ELSE cast((MAX(CASE WHEN P.IntentCode = 'SE' THEN P.Grads ELSE 0 END) 
			+ MAX(CASE WHEN P.IntentCode = 'OT' THEN P.Grads ELSE 0 END)
			+ MAX(CASE WHEN P.IntentCode = 'UD' THEN P.Grads ELSE 0 END)
			+ MAX(CASE WHEN P.IntentCode = 'NR' THEN P.Grads ELSE 0 END))
		AS char(18)) 
	END 
, '% Miscellaneous' = CASE 
	WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
	ELSE cast(((MAX(CASE WHEN P.IntentCode = 'SE' THEN P.Grads ELSE 0 END) 
			+ MAX(CASE WHEN P.IntentCode = 'OT' THEN P.Grads ELSE 0 END)
			+ MAX(CASE WHEN P.IntentCode = 'UD' THEN P.Grads ELSE 0 END)
			+ MAX(CASE WHEN P.IntentCode = 'NR' THEN P.Grads ELSE 0 END))
		/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
		* 100) AS numeric(5, 1)) 
	END

FROM 
POST_GRAD_INTENT_Adj P

INNER JOIN v_enrollment E ON E.Year = P.Year AND E.Fullkey = P.Fullkey AND E.Race = P.Race AND E.Sex = P.Sex
AND E.year  >= 1997 and E.grade = 64


/*** TESTING ***/
--AND (E.fullkey in ('07329003XXXX')) AND (E.SchoolType in ('9')) 
--AND E.AgencyType IN ('03', '04', '4C', '49', 'XX') 
--AND E.year IN ( 2011) AND (E.Race in ('0', '1', '2', '3', '4', '6', '5')) AND (E.Sex in ('9'))
/*** END TESTING ***/

GROUP BY
	E.[Year]	   
, E.[fullkey]
, E.[Race]
, E.[Sex]
, E.[enrollment]
, E.[Suppressed]
, E.Grade

) measures
RIGHT OUTER JOIN v_Template_Keys_WWoDis_tblAgencyFull K
on measures.fullkey = K.fullkey
AND measures.year = K.year
AND measures.Race = K.Race
AND measures.Sex = K.Sex

WHERE 
K.GradeCode = 64
AND K.disabilityCode = 9

--TESTING:
--WHERE (K.fullkey in ('07329003XXXX')) AND (SchoolType in ('9')) 
--AND AgencyType IN ('03', '04', '4C', '49', 'XX') 
--AND k.year IN ( 2011) AND (K.Race in ('0', '1', '2', '3', '4', '6', '5')) AND (K.Sex in ('9'))

GO
