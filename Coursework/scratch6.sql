
USE wisconsin;

SELECT distinct year from courses;

SELECT * FROM v_Coursework WHERE ((year >= 1997) AND (year <= 2010)) AND (FullKey in ('02326903XXXX')) AND (Sex in ('1', '2')) AND (Grade in ('94')) AND (CourseTypeID in ('1')) AND (WMASID1 in ('4'))

SELECT OrgSchoolTypeLabel
FROM dbo.v_Template_Keys_WWoDis_tblAgencyFull
WHERE ((year >= 1997) AND (year <= 2010)) AND (FullKey in ('02326903XXXX')) AND (Sex in ('1', '2')) AND (Grade in ('94')) 
--AND (CourseTypeID in ('1')) 
--AND (WMASID1 in ('4'))

SELECT [year]
      ,[YearFormatted]
      ,[fullkey]
      ,[agencykey]
      ,[AgencyType]
      ,[CESA]
      ,[County]
      ,[ConferenceKey]
      ,[schooltype]
      ,[RollupSchooltype]
      ,[District Number]
      ,[School Number]
      ,[charter]
      ,[OrgLevelLabel]
      ,[OrgSchoolTypeLabel]
      ,[OrgSchoolTypeLabelAbbr]
      ,[Name]
      ,[District Name]
      ,[School Name]
      ,[Grade]
      ,[GradeCode]
      ,[GradeLabel]
      ,[GradeShortLabel]
      ,[Race]
      ,[RaceCode]
      ,[RaceLabel]
      ,[RaceShortLabel]
      ,[Sex]
      ,[SexCode]
      ,[SexLabel]
      ,[DisabilityCode]
      ,[DisabilityLabel]
      ,[ShortDisabilityLabel]
      ,[Student Group]
      ,[StudentGroupLabel]
      ,[LinkedName]
      ,[LinkedDistrictName]
      ,[LinkedSchoolName]
      ,[Total Enrollment PreK-12]
      ,[enrollment]
      ,[suppressed]
  FROM [Wisconsin].[dbo].[v_Template_Keys_WWoDis_tblAgencyFull]