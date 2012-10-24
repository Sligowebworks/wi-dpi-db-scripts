

-- test all on district = '4634' first...

-- district rollups must exclude school, do a left 6 on fullkey, maybe else....
-- see TestDistricts01.sql

select [Year], [FullKey], [SchoolType], [LinkSubject], [Race], [Gender],
'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]),
'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
'FTEEHQNo' = sum(FTEEHQNo),
'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'LocalExperience' = sum([LocalExperience]), 'TotalExperience' = sum([TotalExperience]),
'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), 'DegreeHighSchool' = sum([DegreeHighSchool]), 'DegreeAssoc' = sum([DegreeAssoc]),
'DegreeBach' = sum([DegreeBach]), 'DegreeMast' = sum([DegreeMast]), 'Degree6YrSpec' = sum([Degree6YrSpec]), 'DegreeDoc' = sum([DegreeDoc]),
'DegreeOther' = sum([DegreeOther]), 'DegreeN' = sum([DegreeN])

into tblTeacherQualifications

from (
	-- school-level rollups - All teachers, schooltype n/a - no schooltype rollups at school level
	select
	-- must set schooltype to '9' to pull school rows on dist/state view
	[Year], [FullKey], [StaffKey], [SchoolType], [LinkSubject], '9' as [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [FullKey], [StaffKey],
		[SchoolType],
		[LinkSubject],
		--[Race], [Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- should be able to create unions of all rollups here....
	union all

	-- school-level rollups - teachers by race, schooltype n/a - no schooltype rollups at school level
	select
	-- must set schooltype to '9' to pull school rows on dist/state view
	[Year], [FullKey], [StaffKey], [SchoolType], [LinkSubject], [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [FullKey], [StaffKey],
		[SchoolType],
		[LinkSubject],
		[Race],
		--[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	union all

	-- school-level rollups - teachers by gender, schooltype n/a - no schooltype rollups at school level
	select
	[Year], [FullKey], [StaffKey], [SchoolType], [LinkSubject], '9' as [Race], [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [FullKey], [StaffKey],
		[SchoolType],
		[LinkSubject],
		--[Race],
		[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- start district-level rollups - schooltype = district summary
	union all

	-- district-level rollups - All teachers - schooltype = district summary
	select
	[Year], 'Fullkey' = left([FullKey],6) + '03XXXX', [StaffKey], '9' as [SchoolType], [LinkSubject], '9' as [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	--where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	--schooltype <> '0' and

	-- test
	--and linksubject = 'SUMALL'
	--district = '4634'

	-- select only those to sum on
	group by [Year], left([FullKey],6) + '03XXXX', [StaffKey],
		--[SchoolType],
		[LinkSubject],
		--[Race], [Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- should be able to create unions of all rollups here....
	union all

	-- district-level rollups - teachers by race - schooltype = district summary
	select
	[Year], 'Fullkey' = left([FullKey],6) + '03XXXX', [StaffKey], '9' as [SchoolType], [LinkSubject], [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	--where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	--schooltype <> '0' and

	-- test
	--and linksubject = 'SUMALL'
	--district = '4634'

	-- select only those to sum on
	group by [Year], left([FullKey],6) + '03XXXX', [StaffKey],
		-- [SchoolType],
		[LinkSubject],
		[Race],
		--[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	union all

	-- district-level rollups - teachers by gender - schooltype = district summary
	select
	[Year], 'Fullkey' = left([FullKey],6) + '03XXXX', [StaffKey], '9' as [SchoolType], [LinkSubject], '9' as [Race], [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	--where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	-- schooltype <> '0' and

	-- test
	--and linksubject = 'SUMALL'
	--district = '4634'

	-- select only those to sum on
	group by [Year], left([FullKey],6) + '03XXXX', [StaffKey],
		-- [SchoolType],
		[LinkSubject],
		--[Race],
		[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- start district-level rollups - schooltype breakouts
	union all

	-- district-level rollups - All teachers - schooltype breakouts
	select
	[Year], 'Fullkey' = left([FullKey],6) + '03XXXX', [StaffKey], [SchoolType], [LinkSubject], '9' as [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], left([FullKey],6) + '03XXXX', [StaffKey],
		[SchoolType],
		[LinkSubject],
		--[Race], [Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- should be able to create unions of all rollups here....
	union all

	-- district-level rollups - teachers by race - schooltype breakouts
	select
	[Year], 'Fullkey' = left([FullKey],6) + '03XXXX', [StaffKey], [SchoolType], [LinkSubject], [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], left([FullKey],6) + '03XXXX', [StaffKey],
		[SchoolType],
		[LinkSubject],
		[Race],
		--[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	union all

	-- district-level rollups - teachers by gender - schooltype breakouts
	select
	[Year], 'Fullkey' = left([FullKey],6) + '03XXXX', [StaffKey], [SchoolType], [LinkSubject], '9' as [Race], [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- leave out district-level assignments for schools totals
	where
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], left([FullKey],6) + '03XXXX', [StaffKey],
		[SchoolType],
		[LinkSubject],
		--[Race],
		[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- start state-level rollups

	-- start state-level rollups - schooltype = state summary
	union all

	-- state-level rollups - All teachers - schooltype = state summary
	select
	[Year], 'Fullkey' = 'XXXXXXXXXXXX', [StaffKey], '9' as [SchoolType], [LinkSubject], '9' as [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- restrict agencytypes for state rollups
	where left(right(fullkey,6),2) in ('03','04','4C','49') or (district = '7300' and (left(right(fullkey,6),2) = '05' or left(right(fullkey,6),2) = '10'))
	-- district-level records use schooltype 0 - grouped in only for district summaries
	-- include district-level assignments for schools totals
	--schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [StaffKey],
		--[SchoolType],
		[LinkSubject],
		--[Race], [Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- should be able to create unions of all rollups here....
	union all

	-- state-level rollups - teachers by race - schooltype = state summary
	select
	[Year], 'Fullkey' = 'XXXXXXXXXXXX', [StaffKey], '9' as [SchoolType], [LinkSubject], [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- restrict agencytypes for state rollups
	where left(right(fullkey,6),2) in ('03','04','4C','49') or (district = '7300' and (left(right(fullkey,6),2) = '05' or left(right(fullkey,6),2) = '10'))
	-- district-level records use schooltype 0 - grouped in only for district summaries
	-- include district-level assignments for schools totals
	--schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [StaffKey],
		-- [SchoolType],
		[LinkSubject],
		[Race],
		--[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	union all

	-- state-level rollups - teachers by gender - schooltype = state summary
	select
	[Year], 'Fullkey' = 'XXXXXXXXXXXX', [StaffKey], '9' as [SchoolType], [LinkSubject], '9' as [Race], [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- restrict agencytypes for state rollups
	where left(right(fullkey,6),2) in ('03','04','4C','49') or (district = '7300' and (left(right(fullkey,6),2) = '05' or left(right(fullkey,6),2) = '10'))
	-- district-level records use schooltype 0 - grouped in only for district summaries
	-- include district-level assignments for schools totals
	-- schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [StaffKey],
		-- [SchoolType],
		[LinkSubject],
		--[Race],
		[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- start state-level rollups - schooltype breakouts
	union all

	-- state-level rollups - All teachers - schooltype breakouts
	select
	[Year], 'Fullkey' = 'XXXXXXXXXXXX', [StaffKey], [SchoolType], [LinkSubject], '9' as [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- restrict agencytypes for state rollups
	where left(right(fullkey,6),2) in ('03','04','4C','49') or (district = '7300' and (left(right(fullkey,6),2) = '05' or left(right(fullkey,6),2) = '10')) and
	-- district-level records use schooltype 0 - grouped in only for district summaries
	-- leave out district-level assignments for schools totals
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [StaffKey],
		[SchoolType],
		[LinkSubject],
		--[Race], [Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	-- should be able to create unions of all rollups here....
	union all

	-- state-level rollups - teachers by race - schooltype breakouts
	select
	[Year], 'Fullkey' = 'XXXXXXXXXXXX', [StaffKey], [SchoolType], [LinkSubject], [Race], '9' as [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- restrict agencytypes for state rollups
	where left(right(fullkey,6),2) in ('03','04','4C','49') or (district = '7300' and (left(right(fullkey,6),2) = '05' or left(right(fullkey,6),2) = '10')) and
	-- leave out district-level assignments for schools totals
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [StaffKey],
		[SchoolType],
		[LinkSubject],
		[Race],
		--[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

	union all

	-- state-level rollups - teachers by gender - schooltype breakouts
	select
	[Year], 'Fullkey' = 'XXXXXXXXXXXX', [StaffKey], [SchoolType], [LinkSubject], '9' as [Race], [Gender],
	'LicenseTotal' = sum([LicenseTotal]), 'LicenseFull' = sum([LicenseFull]), 'LicenseEmer' = sum([LicenseEmer]), 'LicenseNo' = sum([LicenseNo]), 'EHQTotal' = sum([EHQTotal]),
	'EHQYes' = sum([EHQYes]), 'EHQNo' = sum([EHQNo]), 'FTE' = sum([FTE]), 'FTELicenseFull' = sum(FTELicenseFull), 'FTELicenseEmer' = sum(FTELicenseEmer), 'FTELicenseNo' = sum(FTELicenseNo), 'FTEEHQYes' = sum(FTEEHQYes),
	'FTEEHQNo' = sum(FTEEHQNo), 'FTE5YearsOrMoreLocal' = sum([FTE5YearsOrMoreLocal]),
	'FTE5YearsOrMoreTotal' = sum([FTE5YearsOrMoreTotal]), 'FTEDegreeMastersOrHigher' = sum([FTEDegreeMastersOrHigher]), [LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc], [DegreeBach], [DegreeMast],
	[Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]
	from tblTeacherQualificationsAlpha
	-- restrict agencytypes for state rollups
	--where left(right(fullkey,6),2) in ('03','04','4C','49') or (district = '7300' and (left(right(fullkey,6),2) = '05' or left(right(fullkey,6),2) = '10')) and
	-- jdj: added parentheses below to make it more restrictive - WI has already approved the numbers but I think this is more correct - may only weed out some unused rows
	where (left(right(fullkey,6),2) in ('03','04','4C','49') or (district = '7300' and (left(right(fullkey,6),2) = '05' or left(right(fullkey,6),2) = '10'))) and
	-- leave out district-level assignments for schools totals
	-- district-level records use schooltype 0 - grouped in only for district summaries
	schooltype <> '0'

	-- test
	--and linksubject = 'SUMALL'
	-- and district = '4634'

	-- select only those to sum on
	group by [Year], [StaffKey],
		[SchoolType],
		[LinkSubject],
		--[Race],
		[Gender],
		[LocalExperience], [TotalExperience], [DegreeHighSchool], [DegreeAssoc],
		[DegreeBach], [DegreeMast], [Degree6YrSpec], [DegreeDoc], [DegreeOther], [DegreeN]

) x

group by [Year], [FullKey], [SchoolType], [LinkSubject], [Race], [Gender]

-- test order by
order by fullkey, linksubject, schooltype, race
