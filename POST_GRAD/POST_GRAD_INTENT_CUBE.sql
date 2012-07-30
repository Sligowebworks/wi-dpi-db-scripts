USE [Wisconsin]
GO
/****** Object:  View [dbo].[v_POST_GRAD_INTENT]  ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  View [dbo].[v_POST_GRAD_INTENT]  ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[POST_GRAD_INTENT_CUBE]') AND OBJECTPROPERTY(id, N'IsTable') = 1)
DROP TABLE [dbo].[POST_GRAD_INTENT_CUBE]

GO

SELECT 
  [Year]	   
, [fullkey]
, [Race]
, [Sex]
 
/*** Aggregates: ***/
, 'Number of Graduates'			= cast(MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.COUNT ELSE 0 END) AS char(18)) 

, 'Number 4-Year College'		= cast(MAX(CASE WHEN P.IntentCode = '4Y' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% 4-Year College'			= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = '4Y' THEN P.GRADS ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number Voc/Tech College'		= cast(MAX(CASE WHEN P.INTENTCODE = '2V' THEN P.GRADS ELSE 0 END) AS char(18)) 

, '% Voc/Tech College'			= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = '2V' THEN P.Grads ELSE 0 END) 
										/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
										* 100) AS numeric(5, 1)) 
								END 

, 'Number Job Training'			= cast(MAX(CASE WHEN P.INTENTCODE = '1T' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% Job Training'				= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = '1T' THEN P.Grads ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number Employment'			= cast(MAX(CASE WHEN P.INTENTCODE = 'EP' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% Employment'				= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = 'EP' THEN P.Grads ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number Military'				= cast(MAX(CASE WHEN P.INTENTCODE = 'MI' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% Military'					= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = 'MI' THEN P.Grads ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number Seeking Employment'	= cast(MAX(CASE WHEN P.INTENTCODE = 'SE' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% Seeking Employment'		= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = 'SE' THEN P.Grads ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number Other Plans'			= cast(MAX(CASE WHEN P.INTENTCODE = 'OT' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% Other Plans'				= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = 'OT' THEN P.Grads ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number Undecided'			= cast(MAX(CASE WHEN P.INTENTCODE = 'UD' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% Undecided'					= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = 'UD' THEN P.Grads ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number No Response'			= cast(MAX(CASE WHEN P.INTENTCODE = 'NR' THEN P.Grads ELSE 0 END) AS char(18)) 

, '% No Response'				= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast((MAX(CASE WHEN P.INTENTCODE = 'NR' THEN P.Grads ELSE 0 END) 
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END 

, 'Number Miscellaneous'		= cast((MAX(CASE WHEN P.INTENTCODE = 'SE' THEN P.Grads ELSE 0 END) 
									+ MAX(CASE WHEN P.INTENTCODE = 'OT' THEN P.Grads ELSE 0 END)
									+ MAX(CASE WHEN P.INTENTCODE = 'UD' THEN P.Grads ELSE 0 END)
									+ MAX(CASE WHEN P.INTENTCODE = 'NR' THEN P.Grads ELSE 0 END))
								AS char(18)) 

, '% Miscellaneous'				= CASE 
								WHEN MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) = 0 THEN 0 
								ELSE cast(((MAX(CASE WHEN P.INTENTCODE = 'SE' THEN P.Grads ELSE 0 END) 
										+ MAX(CASE WHEN P.INTENTCODE = 'OT' THEN P.Grads ELSE 0 END)
										+ MAX(CASE WHEN P.INTENTCODE = 'UD' THEN P.Grads ELSE 0 END)
										+ MAX(CASE WHEN P.INTENTCODE = 'NR' THEN P.Grads ELSE 0 END))
									/ MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0 END) 
									* 100) AS numeric(5, 1)) 
								END

INTO [POST_GRAD_INTENT_CUBE]
FROM
POST_GRAD_INTENT_Adj P

GROUP BY
  [Year]	   
, [fullkey]
, [Race]
, [Sex]

GO
