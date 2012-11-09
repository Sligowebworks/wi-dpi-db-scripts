if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[v_TeacherQualificationsScatterplot]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[v_TeacherQualificationsScatterplot]
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO






CREATE view [dbo].[v_TeacherQualificationsScatterplot] as

-- this is v_TeacherQualificationsScatterplotKeys40.sql - derived from v_Template_Keys_WithSchooltypes

-- this view uses schooltypes as a separate column - v_Template_Keys uses grade column to key on schooltypes -
-- may have to exclude grades 70,71,72,73, maybe others, to avoid redundancy

SELECT [Year], [YearFormatted], [fullkey], [agencykey], [AgencyType], [CESA], [County], [schooltype], [conferencekey], [SchooltypeCode], [SchooltypeLabel], [SchooltypeLabel2], [SchooltypeLabel3], [SchooltypeLabel4],
[District Number], [School Number], [charter], [OrgLevelLabel], [Name], [District Name], [School Name], [GradeCode], [GradeLabel], [GradeShortLabel], [RaceCode], [RaceLabel], [RaceShortLabel], [SexCode], [SexLabel],
[Student Group], [StudentGroupLabel], [LinkedName], [LinkedDistrictName], [LinkedSchoolName], [LinkSubjectCode], [LinkSubjectLabel], [RelateToKey], [RelateToLabel], [RelateToNumerator], [RelateToDenominator],
'RelateToValue' = (case when RelateToKey = 'SPND' and RelateToDenominator = 0 then 'n/a' else [RelateToValue] end),
[LicenseFullFTEPercentage], [LicenseEmerFTEPercentage], [LicenseNoFTEPercentage], [LocalExperience5YearsOrMoreFTEPercentage], [TotalExperience5YearsOrMoreFTEPercentage],
[DegreeMastersOrHigherFTEPercentage], [FTETotal], [FTELicenseFull], [LicenseEmerFTE], [LicenseNoFTE], [EHQYesFTE], [EHQYesFTEPercentage], [EHQNoFTE], [EHQNoFTEPercentage],
[LocalExperience5YearsOrLessFTE], [LocalExperience5YearsOrMoreFTE], [TotalExperience5YearsOrLessFTE], [TotalExperience5YearsOrMoreFTE], [DegreeMastersOrHigherFTE], [LicenseCountTotal], [LicenseCountFull],
[LicenseCountEmer], [LicenseCountNo], [EHQCountTotal]
--, [EHQCountYes], [EHQCountNo],
[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast], [Degree6YrSpec],
[DegreeDoc], [DegreeOther], [DegreeN]

from (

	Select
	  k.Year
	, 'YearFormatted' = cast((rtrim(cast((cast(k.year as int) - 1) as char)) + '-' + right(k.year,2)) as char(7))
	, k.fullkey
	, k.agencykey
	, 'AgencyType' = left(right(k.fullkey,6),2)
	, k.CESA
	, k.County
	, k.schooltype
	, k.conferencekey
	, k.SchooltypeCode
	, 'SchooltypeLabel' = (case left(k.SchooltypeLabel,1) when 'E' then '    ' + k.SchooltypeLabel when 'M' then '   ' + k.SchooltypeLabel when 'H' then '  ' + k.SchooltypeLabel when 'C' then ' ' + k.SchooltypeLabel else k.SchooltypeLabel end)
	, 'SchooltypeLabel2' = (case left(k.SchooltypeLabel2,3) when 'Ele' then '    ' + k.SchooltypeLabel2 when 'Mid' then '   ' + k.SchooltypeLabel2 when 'Hi' then '  ' + k.SchooltypeLabel2 when 'El/' then ' ' + k.SchooltypeLabel2 else k.SchooltypeLabel2 end)
	, 'SchooltypeLabel3' = (case left(k.SchooltypeLabel3,3) when 'Ele' then '    ' + k.SchooltypeLabel3 when 'Mid' then '   ' + k.SchooltypeLabel3 when 'Hig' then '  ' + k.SchooltypeLabel3 when 'El/' then ' ' + k.SchooltypeLabel3 else k.SchooltypeLabel3 end)
	, 'SchooltypeLabel4' =
	(case left(k.SchooltypeLabel3,3)
		when 'Ele' then '    '
			+ (case when k.fullkey = 'XXXXXXXXXXXX' then ' State'
				when right(k.fullkey,1) = 'X' then '  District'
				else '   Current School' end)
			+ ': ' + k.SchooltypeLabel3 when 'Mid' then '   '
			+ (case when k.fullkey = 'XXXXXXXXXXXX' then ' State'
				when right(k.fullkey,1) = 'X' then '  District'
				else '   Current School' end)
			+ ': ' + k.SchooltypeLabel3  when 'Hig' then '  '
			+ (case when k.fullkey = 'XXXXXXXXXXXX' then ' State'
				when right(k.fullkey,1) = 'X' then '  District'
				else '   Current School' end)
			+ ': ' + k.SchooltypeLabel3 when 'El/' then ' '
			+ (case when k.fullkey = 'XXXXXXXXXXXX' then ' State'
				when right(k.fullkey,1) = 'X' then '  District'
				else '   Current School' end)
			+ ': ' + k.SchooltypeLabel3
		else (case when k.fullkey = 'XXXXXXXXXXXX' then ' State'
			when right(k.fullkey,1) = 'X' then '  District'
			else '   Current School' end)
			+ ': ' + k.SchooltypeLabel3 end)


	, k.DistrictCode as 'District Number'
	, k.SchoolCode as 'School Number'
	, 'charter' = (case k.schoolcat when 'CHR' then 'Y' else 'N' end)
	, 'OrgLevelLabel' = (case when k.fullkey = 'XXXXXXXXXXXX' then ' State' when right(k.fullkey,1) = 'X' then '  District' else '   Current School' end)

	-- combines district and school
	, 'Name' = rtrim(
		case
			WHEN k.Fullkey = 'XXXXXXXXXXXX' THEN (' ' + 'WI Public Schools')
			WHEN right(k.Fullkey,1) = 'X' THEN ('  ' + rtrim(Districtname))
			else ('   ' + rtrim(Districtname) + ' / ' + rtrim(Schoolname))
		end)
	, 'District Name' = ('  ' +  rtrim(Districtname))
	, 'School Name' = ('   ' + rtrim(Schoolname))
	, 'GradeCode' = '99', 'GradeLabel' = 'Grades PreK-12', 'GradeShortLabel' = 'Prek-12'
	, 'RaceCode' = 9, 'RaceLabel' = 'All Races', 'RaceShortLabel' = 'All Races', 'SexCode' = 9, 'SexLabel' = 'Both Genders'

	-- if these codes ever change, be sure to change BOTH case statements - must customize for WKCE, LEP, EconStatus, Disabilities, maybe others
	, 'Student Group' = (Case when k.fullkey = 'XXXXXXXXXXXX' then '2' when right(k.fullkey,1) = 'X' then '3' else '6' end)

	-- if these codes ever change, be sure to change BOTH case statements - must customize for WKCE, LEP, EconStatus, Disabilities, maybe others
	, 'StudentGroupLabel' = 	(Case when k.fullkey = 'XXXXXXXXXXXX' then 'Students in Wisconsin Public Schools'
		when right(k.fullkey,1) = 'X' then 'Students in this District'
		else 'Students in this School' end)

	-- combines district and school
	, 'LinkedName' =
		case
			WHEN k.fullkey = 'XXXXXXXXXXXX' THEN 'WI Public Schools'
			WHEN RIGHT(k.Fullkey, 1) = 'X' THEN rtrim(
				CASE
					WHEN k.districtwebaddress IS NULL THEN rtrim(k.Districtname)
					WHEN ltrim(rtrim(k.districtwebaddress))  = '' THEN rtrim(k.Districtname)
					WHEN LEFT(k.districtwebaddress, 3)  = 'FTP' THEN '<a href=javascript:popup(''ftp://' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>' + rtrim(k.districtname)  + '</A>'
					ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>'
				END)
			ELSE rtrim(
				CASE
					WHEN k.districtwebaddress IS NULL THEN rtrim(k.Districtname)
					WHEN ltrim(rtrim(k.districtwebaddress))  = '' THEN rtrim(k.Districtname)
					WHEN LEFT(k.districtwebaddress, 3)  = 'FTP' THEN '<a href=javascript:popup(''ftp://' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>' + rtrim(k.districtname)  + '</A>'
					ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>'
				END)
				+ ' / ' + 	rtrim(
				CASE
					WHEN k.schoolwebaddress IS NULL THEN rtrim(k.Schoolname)
					WHEN ltrim(rtrim(k.schoolwebaddress))  = '' THEN rtrim(k.Schoolname)
					WHEN LEFT(k.schoolwebaddress, 3)  = 'FTP' THEN '<a href=javascript:popup(''ftp://' + rtrim(k.schoolwebaddress) + ''') onClick=''setCookie(question, url)''>' + rtrim(k.schoolname)  + '</A>'
					ELSE '<a href=javascript:popup(''' + rtrim(k.schoolwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.schoolname)  + '</A>'
				END)
	END

	-- website URL from districts table
	, 'LinkedDistrictName' =
	 case
		when districtwebaddress is null then rtrim(k.Districtname)
		when ltrim(rtrim(districtwebaddress))  = '' then rtrim(k.Districtname)
		when left(districtwebaddress, 3)  = 'ftp' then "<a href=javascript:popup('ftp://" + rtrim(districtwebaddress) + "') onclick='setcookie(question, url)'>" + rtrim(districtname)  + "</a>"
		ELSE '<a href=javascript:popup(''' + rtrim(k.districtwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.districtname)  + '</A>'
	end

	-- website URL from schools table
	, 'LinkedSchoolName' =
	 case
		when schoolwebaddress is null then rtrim(k.Schoolname)
		when ltrim(rtrim(schoolwebaddress))  = '' then rtrim(k.Schoolname)
		when left(schoolwebaddress, 3)  = 'ftp' then "<a href=javascript:popup('ftp://" + rtrim(schoolwebaddress) + "') onclick='setcookie(question, url)'>" + rtrim(schoolname)  + "</a>"
		ELSE '<a href=javascript:popup(''' + rtrim(k.schoolwebaddress) + ''') onClick=''setCookie(question, url)''>'+ rtrim(k.schoolname)  + '</A>'
	end

	-- additional columns for the data table can be added here - use isnull() to zero-out missing rows

	, k.LinkSubjectCode, k.LinkSubjectLabel, k.RelateToKey, k.RelateToLabel
	-- 2006-01-03 - adding suppression for Disability - must convert to char to support *s
	, 'RelateToNumerator' = cast((case
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToNumerator = -10 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and (RelateToDenominator-RelateToNumerator) <= 0 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToDenominator < 0 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToDenominator > 0 and RelateToDenominator < 6 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is null then '*'
		else cast(isnull(RelateToNumerator,0) as char) end) as char)

	, 'RelateToDenominator' = cast((case
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToDenominator > 0 and RelateToDenominator < 6 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToDenominator = -10 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToDenominator < 0 then '*'
		else cast(cast(isnull([RelateToDenominator],0) as int) as char) end) as char)

	, 'RelateToValue' = cast((case
		-- per jean email of 2006-01-09 - accidentally deleted some previous rows
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToNumerator = -10 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToDenominator = -10 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and (RelateToDenominator-RelateToNumerator) <= 0 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToValue = -10 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is not null and RelateToDenominator > 0 and RelateToDenominator < 6 then '*'
		when k.RelateToKey = 'DISAB' and RelateToValue is null then '*'
		when k.RelateToKey = 'DISAB' and RelateToDenominator < 0 then '*'
		when k.RelateToKey = 'DISAB' and RelateToDenominator = 0 then '--'
		-- per Jean email of 2006-03-23 - errors in different data collections mean sometimes denominator is greater than numerator for percentages - capping at 100%
		when (k.RelateToKey = 'Asn' or k.RelateToKey = 'Blck' or k.RelateToKey = 'DISAB' or k.RelateToKey = 'Econ' or k.RelateToKey = 'LEP' or
			k.RelateToKey = 'Hsp' or k.RelateToKey = 'Ntv' or k.RelateToKey = 'Wht') and cast(RelateToValue as decimal(18,9)) > 100 then '100'
		else cast(cast(isnull(RelateToValue,0) as decimal(18,9)) as char) end) as char)

	, 'LicenseFullFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTELicenseFull],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'LicenseEmerFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTELicenseEmer],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'LicenseNoFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTELicenseNo],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'LocalExperience5YearsOrMoreFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTE5YearsOrMoreLocal],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'TotalExperience5YearsOrMoreFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTE5YearsOrMoreTotal],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'DegreeMastersOrHigherFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTEDegreeMastersOrHigher],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'FTETotal' = isnull([FTE_Total],0)
	, 'FTELicenseFull' = isnull([FTELicenseFull],0)
	, 'LicenseEmerFTE' = isnull([FTELicenseEmer],0)
	, 'LicenseNoFTE' = isnull([FTELicenseNo],0)
	, 'EHQYesFTE' = isnull([FTE_ESEA_HQYes],0)
	, 'EHQYesFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTE_ESEA_HQYes],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'EHQNoFTE' = isnull([FTE_ESEA_HQNo],0)
	, 'EHQNoFTEPercentage' = case cast(isnull([FTE_Total],0) as float) when 0 then '--' else cast((case isnull([FTE_Total],0) when 0 then 0 else ((isnull([FTE_ESEA_HQNo],0) / isnull([FTE_Total],0)) * 100) end) as char) end
	, 'LocalExperience5YearsOrLessFTE' = (case isnull([FTE_Total],0) when 0 then 0 else ([FTE_Total] - isnull([FTE5YearsOrMoreLocal],0)) end)
	, 'LocalExperience5YearsOrMoreFTE' = isnull([FTE5YearsOrMoreLocal],0)
	, 'TotalExperience5YearsOrLessFTE' = (case isnull([FTE_Total],0) when 0 then 0 else ([FTE_Total] - isnull([FTE5YearsOrMoreTotal],0)) end)
	, 'TotalExperience5YearsOrMoreFTE' = isnull([FTE5YearsOrMoreTotal],0)
	, 'DegreeMastersOrHigherFTE' = isnull([FTEDegreeMastersOrHigher],0)
	, 'LicenseCountTotal' = isnull([LicenseTotal],0)
	, 'LicenseCountFull' = isnull([LicenseFull],0)
	, 'LicenseCountEmer' = isnull([LicenseEmer],0)
	, 'LicenseCountNo' = isnull([LicenseNo],0)
	, 'EHQCountTotal' = isnull([EHQTotal],0)
	--, 'EHQCountYes' = isnull([EHQYes],0)
	--, 'EHQCountNo' = isnull([EHQNo],0)
	, 'LocalExperience' = isnull([LocalExperience],0)
	, 'TotalExperience' = isnull([TotalExperience],0)
	, 'DegreeHighSchool' = isnull([DegreeHighSchool],0)
	, 'DegreeAssoc' = isnull([DegreeAssoc],0)
	, 'DegreeBach' = isnull([DegreeBach],0)
	, 'DegreeMast' = isnull([DegreeMast],0)
	, 'Degree6YrSpec' = isnull([Degree6YrSpec],0)
	, 'DegreeDoc' = isnull([DegreeDoc],0)
	, 'DegreeOther' = isnull([DegreeOther],0)
	, 'DegreeN' = isnull([DegreeN],0)


	-- the place where you should put your join is commented down below

	from (
	--School Level:
	SELECT * FROM v_TeacherQualificationsScatterplot_subSchoolLevel

	UNION ALL

	--District Level:
	SELECT * FROM v_TeacherQualificationsScatterplot_subDistrictLevel

	UNION  ALL

	--State Level:
	SELECT * FROM v_TeacherQualificationsScatterplot_subStateLevel

	) k

	-- put a left outer join to the data table here if you can - or you can create another view that does a left outer join from this view

	LEFT OUTER JOIN [tblTeacherQualifications]
	ON k.[Year] = [tblTeacherQualifications].[Year]
		AND k.[FullKey] = [tblTeacherQualifications].[FullKey]
		-- must cast these as char when joining to avoid type conversion error - unable to find bad data in table
		AND cast(k.[SchoolTypeCode] as char)= cast([tblTeacherQualifications].[SchoolType] as char)
		AND k.[LinkSubjectCode] = [tblTeacherQualifications].[LinkSubject]
		AND k.[RaceCode] = [tblTeacherQualifications].[Race]
		AND k.[SexCode] = [tblTeacherQualifications].[Gender]

	LEFT OUTER JOIN tblTeacherQualificationsScatter
	ON k.[Year] = [tblTeacherQualificationsScatter].[Year]
		AND k.[FullKey] = [tblTeacherQualificationsScatter].[FullKey]
		AND cast(k.[SchoolTypeCode] as char) = cast((case [tblTeacherQualificationsScatter].[SchoolType] when '4' then '5' else [tblTeacherQualificationsScatter].[SchoolType] end) as char)
		AND cast(k.RelateToKey as char) = cast([tblTeacherQualificationsScatter].[RelateToKey] as char)

	WHERE
	-- not using combined groups - no grades
	--k.racecode <> '6' and
	-- might be able to improve performance by pinning k.gradecode to 99 and joining on that
	--k.GradeCode = '99'
	-- scatterplot doesn't show gender breakout
	--and k.SexCode = '9'
	-- scatterplot does show races one at a time, using a different key -
	--and k.RaceCode = '9'

	--and
	k.year >= '2003'
/***
this part of the where statement is for test purposes only - un-commenting it gives you a recordset of reasonable size to test against - it should be commented out for production
*/
	--and k.schooltype = '3'
	--and k.schooltype = '3'
	--and k.fullkey = '013619040223'

	-- all districts in state
	--and right(k.fullkey,1)  = 'X' and left(k.fullkey,1)  <> 'X'

	-- all districts in CESA 01
	--and right(k.fullkey,1)  = 'X' and left(k.fullkey,1)  <> 'X' and CESA = '01'

	-- all districts in county 67
	--and right(k.fullkey,1)  = 'X' and left(k.fullkey,1)  <> 'X' and county = '67'

	--and k.LinkSubjectCode = 'CORESUM' and k.RelateToKey = 'Asian'

	--and [DistrictCode] = '0714'

	--and k.year = '2003' and (k.fullkey = '013619040223' or k.fullkey = '01361903XXXX' or k.fullkey = 'XXXXXXXXXXXX') and k.GradeCode = '99' and k.RaceCode = '9' and k.SexCode = '9'
	--and k.year = '2003' and k.fullkey = 'XXXXXXXXXXXX' and k.RaceCode = '9' and k.SexCode = '9' and LinkSubjectCode = 'sumall'
	--and k.schooltypecode = '6'

	--and k.Year = '2005' and right(k.fullkey,1) <> 'X' and left(k.fullkey,1) <> 'X' and k.SchoolTypeCode = '7' and k.LinkSubjectCode = 'SUMALL' and k.RelateToKey = 'Disability' and k.County = '40'

	-- test order by
	--order by k.year, k.fullkey, k.schooltypelabel, k.racecode, k.sexcode, k.gradecode, k.linksubjectcode

) x








GO
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

