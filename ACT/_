USE [Wisconsin]
GO
/****** Object:  View [dbo].[v_ACT]    Script Date: 08/21/2012 21:41:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[v_ACT]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[v_ACT]
GO

CREATE VIEW [dbo].[v_ACT]
AS
-- 2010-10-31: kind of a radical change, the suppressions test in the scores aren't working right, unnecessary casts  to char seem to be interfering somehow - 
-- removing all casts on all suppression columns
-- see English  section for explanation of suppression rules

--Select * from (
select k.year, k.YearFormatted, k.fullkey, k.agencykey, 
'AgencyType' = left(right(k.fullkey,6),2),
k.CESA, 
'schooltype' = (case when right(k.fullkey,1) <> 'X' then k.schooltype else '9' end), 
'SchoolTypeRaw' = k.SchoolType, 
-- fix per act_qa_101711.docx 2.b.
--'SchoolTypeLabel' = 'Summary', 
'SchoolTypeLabel' = (case when right(k.fullkey,1) = 'X' then 'Summary' else (case k.schooltype when '3' then '  High' when '5' then '   Mid/Jr Hi' when '6' then '    Elem' when '7' then ' El/Sec' when '9' then 'Summary' end) end), 
'OrgSchoolTypeLabel' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary', 
'OrgSchoolTypeLabelAbbr' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary', 
k.ConferenceKey, k.[District Number], k.[School Number], k.charter, k.OrgLevelLabel, k.Name, k.[District Name], 
k.[School Name], k.[GradeCode], k.[GradeLabel], k.[GradeShortLabel], k.[RaceCode], k.[RaceLabel], k.RaceShortLabel, k.SexCode, k.SexLabel, k.[Student Group], k.StudentGroupLabel, 
k.LinkedName, k.LinkedDistrictName, k.LinkedSchoolName, 
-- brb backwards compatible columns
'PriorYears' = cast(cast(K.year as int)-1 as char(4)) + '-' + right(cast(cast(K.year as int) as char(4)),2),
'DistState' = (case when K.fullkey = 'XXXXXXXXXXXX' then 'Entire State' when right(K.fullkey,4) = 'XXXX' then 'District' else 'Current School' end),
k.[RaceCode] as 'Race', k.SexCode as 'Sex', k.[District Number] as 'district', k.[District Name] as Districtname, k.[School Name] as Schoolname, K.county,

'Enrollment PreK-12' = cast(isnull(k.enrollment,'0') as char), 

'suppressed' = cast(isnull(s.suppressed,isnull(k.enrollment,'0')) as char), 
--k.AgencyName as Name,

--isnull(Act.PupilCount,0) as 'PupilCount', 
-- act_qa_081511am.docx #3
-- fix per act_qa_101711.docx 2.b.
--'PupilCount' = case when rtrim(s.suppressed) = '-10' then '*' when k.enrollment is null or k.enrollment = 0 then '0' when act.Pupilcount = 0 or act.PupilCount is null then '0' when isnull(k.enrollment,'0') < 6 then '*' else isnull(Act.PupilCount,0)  end, 
--'PupilCount' = case when act.Pupilcount = 0 or act.PupilCount is null then '0' else isnull(Act.PupilCount,0)  end, 

-- per email exchange with MZD 2012-02-27
--'PupilCount' = case when rtrim(s.suppressed) = '-10' then '*' when act.Pupilcount = 0 or act.PupilCount is null then '0' when isnull(k.enrollment,'0') < 6 then '*' else isnull(Act.PupilCount,0)  end, 
'PupilCount' = case when rtrim(s.suppressed) = '-10' then '*' when act.Pupilcount = 0 or act.PupilCount is null then '0' when isnull(k.enrollment,'0') > 0 and isnull(k.enrollment,'0') < 6 then '*' else isnull(Act.PupilCount,0)  end, 

'PupilCountRaw' = isnull(Act.PupilCount,0), 

-- jdj: special suppression rule for ACT per Jean email 7/12/02
-- jdj 2004-09-21 - modifying suppression rules so that district-level ACT scores are not suppressed if the suppression is only due to small schools

-- jdj: 2010-11-01 - outdated code now but probably still maybe a good synopsis of suppression rules - maybe double-check with Jean?

--'English' = 
--Case  
---- if no kids took the ACT test, show --
--when act.Pupilcount = '0' or act.PupilCount is null then '--' 
---- if less than 6 kids took the ACT test, suppress....
--when cast(act.Pupilcount as int) < 6 then '*' 
---- if it's a school-level record and enrollment says suppress it, suppress....
--when cast(enr.suppressed as char) = '-10' and act.school <> 'XXXX' then '*'  
---- if it's a district-level record and enrollment says suppress it and it's not all students, suppress....
--when cast(enr.suppressed as char) = '-10' and act.school = 'XXXX' and (enr.race <> '9' or enr.sex <> '9') then '*'  
---- if it's a district-level record and enrollment says suppress it and it's all students, and there are schools in this district that took the ACT test, suppress....
--when cast(enr.suppressed as char) = '-10' and act.school = 'XXXX' and enr.race = '9' and enr.sex = '9' and 
--(select top 1 a.fullkey from enrollment e inner join act a on e.year = a.year and e.fullkey = a.fullkey and e.race = a.race and e.sex = a.sex 
--where a.year = act.year and a.district = act.district and a.school <> 'XXXX' and e.grade = '64' and e.race = '9' and e.sex = '9' and suppressed = -10
--) is not null 
--then '*'  
---- otherwise, there are no schools in this district that took the ACT test that have grade 12 suppressed, so it's OK to show the district numbers 
---- this will include districts that enrollment would otherwise suppress - 
---- but enrollment is suppressing them only to protect privacy in grade 12, that didn't take the ACT test anyway - so we show the district-level data
--else  isnull(act.English,'--') end,

'English' = 
Case when rtrim(s.suppressed) <> '-10' and (act.Pupilcount = '0' or act.PupilCount is null) then '--' when cast(act.Pupilcount as int) < 6 then '*' when rtrim(s.suppressed) = '-10' and isnumeric(k.[School Number]) = 1 then '*'  
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and (k.racecode <> '9' or k.sexcode <> '9') then '*' 
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and k.racecode = '9' and k.sexcode = '9' and 
(select top 1 a.fullkey from tblPubEnrWWoDisSuppressed e inner join act a on e.year = a.year and e.fullkey = a.fullkey and e.race = a.race and e.gender = a.sex 
where a.year = act.year and a.district = act.district and a.school <> 'XXXX' and e.grade = '64' and e.race = '9' and e.gender = '9' and rtrim(suppressed) = -10) is not null then '*'  
else  isnull(act.English,'--') end,

'Math' = 
Case when rtrim(s.suppressed) <> '-10' and (act.Pupilcount = '0' or act.PupilCount is null) then '--' when cast(act.Pupilcount as int) < 6 then '*' when rtrim(s.suppressed) = '-10' and isnumeric(k.[School Number]) = 1 then '*'  
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and (k.racecode <> '9' or k.sexcode <> '9') then '*' 
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and k.racecode = '9' and k.sexcode = '9' and 
(select top 1 a.fullkey from tblPubEnrWWoDisSuppressed e inner join act a on e.year = a.year and e.fullkey = a.fullkey and e.race = a.race and e.gender = a.sex 
where a.year = act.year and a.district = act.district and a.school <> 'XXXX' and e.grade = '64' and e.race = '9' and e.gender = '9' and rtrim(suppressed) = -10) is not null then '*'  
else  isnull(act.Math,'--') end,

'Reading' = 
Case when rtrim(s.suppressed) <> '-10' and (act.Pupilcount = '0' or act.PupilCount is null) then '--' when cast(act.Pupilcount as int) < 6 then '*' when rtrim(s.suppressed) = '-10' and isnumeric(k.[School Number]) = 1 then '*'  
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and (k.racecode <> '9' or k.sexcode <> '9') then '*' 
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and k.racecode = '9' and k.sexcode = '9' and 
(select top 1 a.fullkey from tblPubEnrWWoDisSuppressed e inner join act a on e.year = a.year and e.fullkey = a.fullkey and e.race = a.race and e.gender = a.sex 
where a.year = act.year and a.district = act.district and a.school <> 'XXXX' and e.grade = '64' and e.race = '9' and e.gender = '9' and rtrim(suppressed) = -10) is not null then '*'  
else  isnull(act.Reading,'--') end,

'Science' = 
Case when rtrim(s.suppressed) <> '-10' and (act.Pupilcount = '0' or act.PupilCount is null) then '--' when cast(act.Pupilcount as int) < 6 then '*' when rtrim(s.suppressed) = '-10' and isnumeric(k.[School Number]) = 1 then '*'  
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and (k.racecode <> '9' or k.sexcode <> '9') then '*' 
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and k.racecode = '9' and k.sexcode = '9' and 
(select top 1 a.fullkey from tblPubEnrWWoDisSuppressed e inner join act a on e.year = a.year and e.fullkey = a.fullkey and e.race = a.race and e.gender = a.sex 
where a.year = act.year and a.district = act.district and a.school <> 'XXXX' and e.grade = '64' and e.race = '9' and e.gender = '9' and rtrim(suppressed) = -10) is not null then '*'  
else  isnull(act.Science,'--') end,

'Composite' = 
Case when rtrim(s.suppressed) <> '-10' and (act.Pupilcount = '0' or act.PupilCount is null) then '--' when cast(act.Pupilcount as int) < 6 then '*' when rtrim(s.suppressed) = '-10' and isnumeric(k.[School Number]) = 1 then '*'  
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and (k.racecode <> '9' or k.sexcode <> '9') then '*' 
when rtrim(s.suppressed) = '-10' and act.school = 'XXXX' and k.racecode = '9' and k.sexcode = '9' and 
(select top 1 a.fullkey from tblPubEnrWWoDisSuppressed e inner join act a on e.year = a.year and e.fullkey = a.fullkey and e.race = a.race and e.gender = a.sex 
where a.year = act.year and a.district = act.district and a.school <> 'XXXX' and e.grade = '64' and e.race = '9' and e.gender = '9' and rtrim(suppressed) = -10) is not null then '*'  
else  isnull(act.Composite,'--') end,

/*
'Math' = 
Case  when act.Pupilcount ='0' or act.PupilCount is null  then '--' when cast(act.Pupilcount as int) < 6 then '*' when cast(enr.suppressed as char) = '-10' then '*'  else  isnull(act.Math,'--') end,
 'Reading' = 
Case  when act.Pupilcount ='0' or act.PupilCount is null  then '--' when cast(act.Pupilcount as int) < 6 then '*' when cast(enr.suppressed as char) = '-10' then '*'  else  isnull(act.Reading,'--') end,
 'Science' =
Case  when act.Pupilcount = '0' or act.PupilCount is null  then '--' when cast(act.Pupilcount as int) < 6 then '*' when cast(enr.suppressed as char) = '-10' then '*'  else  isnull(act.Science,'--') end,
'Composite' =
Case  when act.Pupilcount = '0' or act.PupilCount is null then '--' when cast(act.Pupilcount as int) < 6 then '*' when cast(enr.suppressed as char) = '-10' then '*'  else  isnull(act.Composite,'--') end,
*/
'Enrollment' = isnull(cast(k.enrollment as char(18)),'0') ,

--'Perc Tested' = Case  when act.Pupilcount = 0 or act.PupilCount is null then '0' when enr.enrollment is null or enr.enrollment = 0 then '0'  else cast((cast(act.PupilCount as int)/ (cast(enr.enrollment as float)) *100) as char) end
-- may need to add an excpetion to suppresion when district record and no grade 12 being supppressed in schools - per scores above
'Perc Tested' = Case when rtrim(s.suppressed) = '-10' then '*' when k.enrollment is null or k.enrollment = 0 then '--' when act.Pupilcount = 0 or act.PupilCount is null then '0' when isnull(k.enrollment,'0') < 6 then '*' 
else cast((cast(act.PupilCount as int)/ (cast(k.enrollment as float)) *100) as char) end

from 
v_Template_Keys_WWoDis_tblAgencyFull K

left outer join tblActSuppressed s
ON (k.year = s.Year and k.Fullkey = s.Fullkey and k.gradecode = s.gradecode and k.Race = s.Racecode and k.Sex = s.Sexcode)

Left outer join act
ON (Act.year = k.Year and Act.Fullkey = k.Fullkey and ACT.Race = k.Racecode and ACT.Sex = k.Sexcode)
--Left outer join enrollment Enr
--ON (k.year = Enr.Year and  k.Fullkey = Enr.Fullkey and k.Racecode = Enr.Race and k.Sexcode = Enr.Sex)
--Where  Enr.Grade = '64' and k.Racecode in (1,2,3,4,5,9) and k.Sexcode in (1,2,9) and k.gradecode = '64'
Where  k.Grade = '64' and k.Racecode in (0,1,2,3,4,5,6,7,9) and k.Sexcode in (1,2,8,9) and k.gradecode = '64'
and K.DisabilityCode = '9' 
and 
(
	(right(k.fullkey,1) = 'X' and K.schooltype = '9')
or
	(right(k.fullkey,1) <> 'X')
)

and k.Agencytype in ('03','04','4C','49','XX')

UNION ALL

select k.year, k.YearFormatted, k.fullkey, k.agencykey, 
'AgencyType' = left(right(k.fullkey,6),2),
k.CESA, 
'schooltype' = (case when right(k.fullkey,1) <> 'X' then k.schooltype else '9' end), 
'SchoolTypeRaw' = k.SchoolType, 
--'SchoolTypeLabel' = 'Summary', 
'SchoolTypeLabel' = (case when right(k.fullkey,1) = 'X' then 'Summary' else (case k.schooltype when '3' then '  High' when '5' then '   Mid/Jr Hi' when '6' then '    Elem' when '7' then ' El/Sec' when '9' then 'Summary' end) end), 
'OrgSchoolTypeLabel' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary', 
'OrgSchoolTypeLabelAbbr' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end) + ': Summary', 


k.ConferenceKey, k.[District Number], k.[School Number], k.charter, k.OrgLevelLabel, k.Name, k.[District Name], 
k.[School Name], k.[GradeCode], k.[GradeLabel], k.[GradeShortLabel], k.[RaceCode], k.[RaceLabel], k.RaceShortLabel, k.SexCode, k.SexLabel, k.[Student Group], k.StudentGroupLabel, 
k.LinkedName, k.LinkedDistrictName, k.LinkedSchoolName, 
-- brb backwards compatible columns
'PriorYears' = cast(cast(K.year as int)-1 as char(4)) + '-' + right(cast(cast(K.year as int) as char(4)),2),
'DistState' = (case when K.fullkey = 'XXXXXXXXXXXX' then 'Entire State' when right(K.fullkey,4) = 'XXXX' then 'District' else 'Current School' end),
k.[RaceCode] as 'Race', k.SexCode as 'Sex', k.[District Number] as 'district', k.[District Name] as Districtname, k.[School Name] as Schoolname, 
K.county,
'Enrollment PreK-12' = 'NA', 'suppressed' = 'NA', 
--k.AgencyName as Name,

isnull(Act.PupilCount,0) as 'PupilCount', 
'PupilCountRaw' = isnull(Act.PupilCount,0), 

-- jdj: special suppression rule for ACT per Jean email 7/12/02
'English' = 
Case when act.Pupilcount = '0' or act.PupilCount is null  then '--' when cast(act.Pupilcount as int) < 6 then '*' else  isnull(act.English,'--')  END,
'Math' = 
Case when act.Pupilcount = '0'  or act.PupilCount is null then '--' when cast(act.Pupilcount as int) < 6 then '*' else  isnull(act.Math,'--')  END,
 'Reading' = 
Case when act.Pupilcount = '0' or act.PupilCount is null then '--' when cast(act.Pupilcount as int) < 6 then '*' else  isnull(act.Reading,'--')  END,
 'Science' =
Case when act.Pupilcount = '0' or act.PupilCount is null then '--' when cast(act.Pupilcount as int) < 6 then '*' else  isnull(act.Science,'--')  END,
'Composite' =
Case when act.Pupilcount = '0' or act.PupilCount is null  then '--' when cast(act.Pupilcount as int) < 6 then '*' else  isnull(act.Composite,'--')  END,

'Enrollment' = 'NA',
'Perc Tested' = 'NA'
from 
v_Template_Keys_WWoDis_tblAgencyFull k

left outer join tblActSuppressed s
ON (k.year = s.Year and k.Fullkey = s.Fullkey and k.gradecode = s.gradecode and k.Race = s.Racecode and k.Sex = s.Sexcode)

Left outer join act ON (Act.year = k.Year and Act.Fullkey = k.Fullkey and ACT.Race = k.Racecode and ACT.Sex = k.Sexcode) 
--Left outer join enrollment Enr ON (k.year = Enr.Year and  k.Fullkey = Enr.Fullkey and k.Sexcode = Enr.Sex and k.gradecode = enr.grade)
--Left outer join enrollment Enr ON (k.year = Enr.Year and  k.Fullkey = Enr.Fullkey and k.gradecode = enr.grade)

--Where (k.racecode = 8 or k.Sexcode = 8) and k.gradecode = '64'
Where (k.racecode = 7 or k.Sexcode = 8) and k.gradecode = '64'
and k.racecode = '9' and k.sexcode = '9'
and k.DisabilityCode = '9' 

--and k.schooltype = '9' 

and 
(
	(right(k.fullkey,1) = 'X' and K.schooltype = '9')
or
	(right(k.fullkey,1) <> 'X')
)

and k.Agencytype in ('03','04','4C','49','XX')

--) a
--where year = '2002' and fullkey = 'XXXXXXXXXXXX' and race = '8' and sex = '9'



