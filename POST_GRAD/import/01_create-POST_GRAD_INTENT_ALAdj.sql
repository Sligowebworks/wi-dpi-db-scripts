-- this is POST_GRAD_INTENT_TableMorphingALAdj13.sql

-- see many notes in previous versions 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[POST_GRAD_INTENT_ALAdj]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[POST_GRAD_INTENT_ALAdj]
	GO

	select 
	'year' = al.[YEAR], 
	'fullkey' = al.[fullkey], 
	'RACE' = al.[RACE], 
	'SEX' = al.[SEX], 
	'INTENTCODE' = al.[INTENTCODE], 

	'HSCGrads' = reg.regular, 
	'ALGrads' = al.[GRADS], 
	'ALAdj' = (case when isnull(al.[GRADS],0) < isnull(reg.regular,0) then reg.regular else al.[GRADS] end),
	'ALDiff' = (case when isnull(al.[GRADS],0) < isnull(reg.regular,0) then (reg.regular - al.[GRADS]) else 0 end)

	into POST_GRAD_INTENT_ALAdj

	from 


	(
		SELECT [YEAR], [FULLKEY], [RACE], [SEX], [INTENTCODE], [GRADS] 
		FROM [POST_GRAD_INTENT] where year <> 'ALL' and (race = '9' or sex = '9') and [INTENTCODE] = 'AL'
	) al

	left outer join 

	(select [Year], [FullKey], [Race], 'SEX' = [Gender], [Regular] from (
			--SELECT [Year], [FullKey], [Race], [Gender], [Regular] FROM [tblHSCSchoolsEconELP] where grade = '64' and disability = '9' 
--SELECT [Year], [FullKey], [Race], [Gender], [Regular] FROM [tblHSCSchoolsEconELP] where grade = '64' and disability = '9' and EconDisadv = '9' and ELPCode = '9'
SELECT [Year], [FullKey], [Race], [Gender], [Regular] FROM [tblHSCSchoolsEconELPXYearRateSuppressed] where grade = '64' and disability = '9' and EconDisadv = '9' and ELPCode = '9' and [XYears] = '0' 

union all 
--SELECT [Year], [FullKey], [Race], [Gender], [Regular] FROM [tblHSCDistrictStateEconELP] where schooltype = '9' and grade = '64' and disability = '9' 
--SELECT [Year], [FullKey], [Race], [Gender], [Regular] FROM [tblHSCDistrictStateEconELP] where schooltype = '9' and grade = '64' and disability = '9'  and EconDisadv = '9' and ELPCode = '9'
SELECT [Year], [FullKey], [Race], [Gender], [Regular] FROM [tblHSCDistStateEconELPXYearRateSuppressed] where schooltype = '9' and grade = '64' and disability = '9'  and EconDisadv = '9' and ELPCode = '9'  and [XYears] = '0' 
) x ) reg

on al.year = reg.year and al.fullkey = reg.fullkey and al.race = reg.race and ltrim(rtrim(al.sex)) = ltrim(rtrim(reg.sex))

where al.year > '2003'

order by al.[YEAR], al.[FULLKEY], al.[RACE], al.[SEX]



