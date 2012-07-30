USE [Wisconsin]
GO
/****** Object:  View [dbo].[v_POST_GRAD_INTENT]    Script Date: 07/29/2012 21:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[v_POST_GRAD_INTENT]
AS

SELECT [year], [fullkey], 
'AgencyType' = left(right(fullkey,6),2),
[County], [CESA], [District], [SchoolType] = COALESCE([SchoolType], '9'), 
[SchoolTypeLabel] = (case COALESCE([SchoolType], '9') 
when '6' then '    Elementary School Type / K-12'
when '5' then '   Middle/Junior High School Type / K-12'
when '3' then '  High School Type / K-12'
when '7' then ' Comb. Elem/Second School Type / K-12'
when '9' then 'Summary'
else '' end),
'SchooltypeLabel2' = (case COALESCE([SchoolType], '9') 
when '6' then '    Elementary School Type / K-12'
when '5' then '   Middle/Junior High School Type / K-12'
when '3' then '  High School Type / K-12'
when '7' then ' Comb. Elem/Second School Type / K-12'
when '9' then 'Summary'
else '' end),
[ConferenceKey], 
[Race], 
[RaceLabel],
RaceShortLabel, 
[Sex], 
[SexLabel], 
[SexDesc], 
[PriorYear], [DistState], [YearFormatted], [District Number], 
[School Number], [District Name], [School Name], [GradeLabel], 
[Student Group], [StudentGroupLabel], [OrgLevelLabel], 'OrgSchoolTypeLabel' = [OrgLevelLabel] + ': Summary', [agencykey], [charter], [LinkedDistrictName], 
[LinkedSchoolName], [LinkedName], [Name], 
[Grade 12 Enrollment], 
[Number of Graduates], 
[Number 4-Year College], 
'% 4-Year College' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% 4-Year College] as char) end), 
[Number Voc/Tech College], 
'% Voc/Tech College' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Voc/Tech College] as char) end), 
[Number Job Training], 
'% Job Training' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Job Training] as char) end), 
[Number Employment], 
'% Employment' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Employment] as char) end), 
[Number Military], 
'% Military' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Military] as char) end), 
[Number Seeking Employment], 
'% Seeking Employment' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Seeking Employment] as char) end), 
[Number Other Plans], 
'% Other Plans' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Other Plans] as char) end), 
[Number Undecided], 
'% Undecided' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Undecided] as char) end), 
[Number No Response], 
'% No Response' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% No Response] as char) end), 
[Number Miscellaneous], 
'% Miscellaneous' = (case when cast([Number of Graduates] as char) = '0' then '--' else cast([% Miscellaneous] as char) end)

FROM (

SELECT E.year, E.fullkey, Agency.County, Agency.CESA, Agency.District, Agency.SchoolType, E.Race,  
E.Sex, Sex.Name AS SexDesc, (cast((E.Year - 1) AS char(4)) 
    + '-' + cast(right(E.Year,2) AS char(4))) AS 'PriorYear', 
    'DistState' = CASE WHEN e.Fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools'
     WHEN RIGHT(e.Fullkey, 1) 
    = 'X' THEN districts.Name ELSE schools.Name END, 

E.YearFormatted, 
E.[District Number],
E.[School Number],
E.[District Name],
E.[School Name],
E.GradeLabel,
Race.Name AS RaceLabel,
[RaceShortLabel] = Race.Shortname,
E.SexLabel,            
E.[Student Group],
E.StudentGroupLabel,   
E.OrgLevelLabel, 
E.agencykey,           
E.charter,    
E.ConferenceKey,          
E.[LinkedName], 
E.[Name], 

'LinkedDistrictName' = 
	 CASE WHEN districts.webaddress IS NULL THEN districts.Name 
	 WHEN ltrim(rtrim(districts.webaddress))  = '' THEN districts.Name 
	 WHEN LEFT(districts.webaddress, 3)  = 'FTP' THEN "<a href=javascript:popup('ftp://" + rtrim(districts.webaddress) + "') onClick='setCookie(question, url)'>" + rtrim(districts.Name)  + "</A>"
	 ELSE "<a href=javascript:popup('" + rtrim(districts.webaddress) + "') onClick='setCookie(question, url)'>"+ rtrim(districts.Name)  + "</A>" END,
'LinkedSchoolName' = 
	 CASE WHEN schools.webaddress IS NULL THEN schools.Name 
	 WHEN ltrim(rtrim(schools.webaddress))  = '' THEN schools.Name 
	 WHEN LEFT(schools.webaddress, 3)  = 'FTP' THEN "<a href=javascript:popup('ftp://" + rtrim(schools.webaddress) + "') onClick='setCookie(question, url)'>" + rtrim(schools.Name)  + "</A>"
	 ELSE "<a href=javascript:popup('" + rtrim(schools.webaddress) + "') onClick='setCookie(question, url)'>"+ rtrim(schools.Name)  + "</A>" END,
E.enrollment AS 'Grade 12 Enrollment', 
'Number of Graduates' = CASE WHEN Suppressed = - 10 THEN '*'
     ELSE cast(MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.COUNT
     ELSE 0 END) AS char(18)) END, 
'Number 4-Year College' = CASE WHEN Suppressed = - 10 THEN
     '*' ELSE cast(MAX(CASE WHEN P.IntentCode = '4Y' THEN P.Grads
     ELSE 0 END) AS char(18)) END, 
'% 4-Year College' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = '4Y' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Voc/Tech College' = CASE WHEN Suppressed = - 10 THEN
     '*' ELSE cast(MAX(CASE WHEN P.IntentCode = '2V' THEN P.Grads
     ELSE 0 END) AS char(18)) END, 
'% Voc/Tech College' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = '2V' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Job Training' = CASE WHEN Suppressed = - 10 THEN '*'
     ELSE cast(MAX(CASE WHEN P.IntentCode = '1T' THEN P.Grads ELSE
     0 END) AS char(18)) END, 
'% Job Training' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = '1T' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Employment' = CASE WHEN Suppressed = - 10 THEN '*'
     ELSE cast(MAX(CASE WHEN P.IntentCode = 'EP' THEN P.Grads ELSE
     0 END) AS char(18)) END, 
'% Employment' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = 'EP' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Military' = CASE WHEN Suppressed = - 10 THEN '*' ELSE
     cast(MAX(CASE WHEN P.IntentCode = 'MI' THEN P.Grads ELSE 0
     END) AS char(18)) END, 
'% Military' = CASE WHEN MAX(CASE WHEN P.INTENTCODE = 'AL'
     THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = 'MI' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Seeking Employment' = CASE WHEN Suppressed = - 10
     THEN '*' ELSE cast(MAX(CASE WHEN P.IntentCode = 'SE' THEN
     P.Grads ELSE 0 END) AS char(18)) END, 
'% Seeking Employment' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = 'SE' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Other Plans' = CASE WHEN Suppressed = - 10 THEN '*'
     ELSE cast(MAX(CASE WHEN P.IntentCode = 'OT' THEN P.Grads ELSE
     0 END) AS char(18)) END, 
'% Other Plans' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = 'OT' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Undecided' = CASE WHEN Suppressed = - 10 THEN '*' ELSE
     cast(MAX(CASE WHEN P.IntentCode = 'UD' THEN P.Grads ELSE
     0 END) AS char(18)) END, 
'% Undecided' = CASE WHEN MAX(CASE WHEN P.INTENTCODE =
     'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = 'UD' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number No Response' = CASE WHEN Suppressed = - 10 THEN '*'
     ELSE cast(MAX(CASE WHEN P.IntentCode = 'NR' THEN P.Grads
     ELSE 0 END) AS char(18)) END, 
'% No Response' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast((MAX(CASE WHEN P.IntentCode = 'NR' THEN
     P.Grads ELSE 0 END) 
    / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE 0
     END) * 100) AS numeric(5, 1)) END, 
'Number Miscellaneous' = CASE WHEN Suppressed = - 10 THEN
     '*' ELSE cast((MAX(CASE WHEN P.IntentCode = 'SE' THEN P.Grads
     ELSE 0 END) 
    + MAX(CASE WHEN P.IntentCode = 'OT' THEN P.Grads ELSE 0 END)
     + MAX(CASE WHEN P.IntentCode = 'UD' THEN P.Grads ELSE 0 END)
     + MAX(CASE WHEN P.IntentCode = 'NR' THEN P.Grads ELSE 0 END))
     AS char(18)) END, 
'% Miscellaneous' = CASE WHEN MAX(CASE WHEN P.INTENTCODE
     = 'AL' THEN P.GRADS ELSE 0 END) 
    = 0 THEN 0 ELSE cast(((MAX(CASE WHEN P.IntentCode = 'SE' THEN
     P.Grads ELSE 0 END) 
    + MAX(CASE WHEN P.IntentCode = 'OT' THEN P.Grads ELSE 0 END)
     + MAX(CASE WHEN P.IntentCode = 'UD' THEN P.Grads ELSE 0 END)
     + MAX(CASE WHEN P.IntentCode = 'NR' THEN P.Grads ELSE 0 END))
     / MAX(CASE WHEN P.INTENTCODE = 'AL' THEN P.GRADS ELSE
     0 END) * 100) AS numeric(5, 1)) END

FROM v_enrollment E 

LEFT OUTER JOIN POST_GRAD_INTENT_Adj P ON (E.Year = P.Year AND E.Fullkey = P.Fullkey AND E.Race = P.Race AND E.Sex = P.Sex) 
left outer JOIN tblAgencyFull agency ON (E.Year=agency.year and E.fullkey=agency.fullkey)

LEFT OUTER JOIN SCHOOLS ON (Schools.Year = E.Year AND Schools.Fullkey = E.Fullkey) 

LEFT OUTER JOIN DISTRICTS ON (Districts.Year = E.Year AND LEFT(Districts.Fullkey, 6) = LEFT(E.FullKey, 6)) 

--INNER JOIN (Select num, shortname as name from Race Union All Select 9 as Num,  'All' as Name) Race ON (E.RACE = RACE.NUM) 
inner join (SELECT [RaceCode] as 'num', [LongName] as 'name', [shortname], [year] FROM [RaceYear]) Race on (E.RACE = RACE.NUM and race.year = agency.year) 

INNER JOIN (select Num, Name from SEX UNION ALL Select 9 as Num,  'All' as Name) Sex ON (E.SEX = Sex.NUM)

WHERE e.year  >= 1997 and e.grade = 64
GROUP BY e.year, e.fullkey, Agency.County, Agency.CESA, Agency.District, Agency.SchoolType, e.Race, e.sex, e.enrollment, e.suppressed, RACE.NAME, SEX.NAME, DISTRICTS.NAME, SCHOOLS.NAME, DISTRICTS.WEBADDRESS, SCHOOLS.WEBADDRESS, E.YearFormatted, E.[District Number], E.[School Number], E.[District Name], E.[School Name], E.GradeLabel, E.RaceLabel, Race.Shortname,E.SexLabel, E.[Student Group], E.StudentGroupLabel, E.OrgLevelLabel, E.agencykey, E.charter, E.ConferenceKey, E.[LinkedName], E.[Name]

) OuterSelect








