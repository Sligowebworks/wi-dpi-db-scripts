USE wisconsin
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblHSCDistStateEconELPXYearRateSuppressed-DEPLOY]([Year], [Fullkey], [Schooltype], [Grade], [Xyears], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [Enrollment], [Suppressed], [TotalExp], [CERTIFICATE], [HSED], [REGULAR]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblHSCDistrictState-DEPLOY]([Year], [FullKey], [Schooltype], [Grade], [Race], [Gender], [Disability], [Cohort_Dropouts], [Maximum_Aged], [Certificate], [HSED], [Regular]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblHSCSchools-DEPLOY]([Year], [FullKey], [Schooltype], [Grade], [Race], [Gender], [Disability], [Cohort_Dropouts], [Maximum_Aged], [Certificate], [HSED], [Regular]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblHSCSchoolsEconELPXYearRateSuppressed-DEPLOY]([Year], [FullKey], [Schooltype], [Grade], [Xyears], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [Enrollment], [Suppressed], [TotalExp], [CERTIFICATE], [HSED], [REGULAR]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblHSCSchoolDistStateXYearRateSuppressionMaster]([Year], [FullKey], [Schooltype], [Grade], [XYears], [Race], [Gender], [Disability], [EconDisadv], [ELPCode]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblHSCDistStateEconELPXYearRateSuppressed-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblHSCDistrictState-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblHSCDistrictState-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblHSCSchools-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblHSCSchools-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblHSCSchoolsEconELPXYearRateSuppressed-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblHSCSchoolDistStateXYearRateSuppressionMaster]  TO [netwisco]
GO
