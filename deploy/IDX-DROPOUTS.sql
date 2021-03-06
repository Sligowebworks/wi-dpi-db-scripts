USE wisconsin
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblDropoutsDistState-DEPLOY]([Year], [FullKey], [schooltype], [Grade], [Race], [Gender], [Disability], [Economic_disadvantaged], [English_language_level], [Completed_School_Term], [Dropouts], [Cohort_dropouts]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblDropoutsDistStateEconELP-DEPLOY]([Year], [FullKey], [schooltype], [Grade], [Race], [Gender], [Disability], [Economic_disadvantaged], [English_language_level], [Completed_School_Term], [Dropouts], [Cohort_dropouts]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblDropoutsSchools-DEPLOY]([Year], [FullKey], [schooltype], [Grade], [Race], [Gender], [Disability], [Economic_disadvantaged], [English_language_level], [Completed_School_Term], [Dropouts], [Cohort_dropouts]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblDropoutsSchoolsEconELP-DEPLOY]([Year], [FullKey], [schooltype], [Grade], [Race], [Gender], [Disability], [Economic_disadvantaged], [English_language_level], [Completed_School_Term], [Dropouts], [Cohort_dropouts]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

