use wisconsin;


SELECT RaceCode, Shortname, Year, * FROM RaceYear where year IN (2010, 2011) AND RaceCOde IN (0,1,2,3)
ORDER BY sHORTName, Year

-- from create-POST_GRAD_INTENT_NRAdj in import	
select * from 
(SELECT distinct [YEAR] FROM [POST_GRAD_INTENT]) year, 
(SELECT distinct [FULLKEY] FROM [POST_GRAD_INTENT]) fullkey, 
(SELECT distinct [RACE] FROM [POST_GRAD_INTENT]) race,  
(SELECT distinct [SEX] FROM [POST_GRAD_INTENT]) sex,
(SELECT 'NR' as 'INTENTCODE') intentcode



SELECT DISTINCT year, racelabel, racecode from v_TruancySchoolDistState
WHERE year IN (2011)
ORDER BY year DESC, racelabel DESC


SELECT DISTINCT year, racelabel, racecode from v_Template_Keys_WWoDis_tblAgencyFull
WHERE year IN (2011)
ORDER BY year DESC, racelabel DESC

SELECT DISTINCT year, race from enrollment
WHERE year IN (2011)
ORDER BY year DESC, race DESC


SELECT * FROM v_TruancySchoolDistState WHERE (SchoolType in ('9')) AND AgencyType IN ('03', '04', '4C', '49', 'XX') AND (SexCode in ('9')) AND (RaceCode in ('0', '1', '2', '3', '4', '6', '5', '8')) AND (GradeCode in ('98')) AND (year in ('2011')) AND (FullKey in ('07329003XXXX'))


SELECT DISTINCT year, Race FROM v_POST_GRAD_INTENT
WHERE year in (2011)


SELECT race, racelabel, year FROM v_POST_GRAD_INTENT WHERE (fullkey in ('12329703XXXX')) AND (SchoolType in ('9')) AND AgencyType IN ('03', '04', '4C', '49', 'XX') AND ((year >= 1997) AND (year <= 2011)) AND (Race in ('0', '1', '2', '3', '4', '6', '5')) AND (Sex in ('9'))

--ORDER BY racelabel DESC, year DESC

ORDER BY  RaceShortLabel,[year] DESC