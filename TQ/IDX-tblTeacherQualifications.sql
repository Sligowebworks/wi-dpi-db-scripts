 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblTeacherQualifications](
  [Year]
, [FullKey]
, [SchoolType]
, [LinkSubject]
, [Race]
, [Gender]
, [LicenseTotal]
, [LicenseFull]
, [FTE_Total]
, [ESEA_Core_FTE_Total]
-- , [FTELicenseFull]
-- , [FTELicenseEmer]
-- , [FTELicenseNo]
-- , [FTE_ESEA_HQYes]
-- , [FTE_ESEA_HQNo]
-- , [FTE5YearsOrMoreLocal]
-- , [FTE5YearsOrMoreTotal]
) WITH  IGNORE_DUP_KEY
,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblTeacherQualifications]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblTeacherQualifications]  TO [netwisco]
GO