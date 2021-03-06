USE wisconsin
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblTruancyDistState-DEPLOY]([Year], [FullKey], [schooltype], [Grade], [Race], [Gender], [PupilsTruant]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblTruancySchools-DEPLOY]([Year], [FullKey], [schooltype], [Grade], [Race], [Gender], [PupilsTruant]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblTruancyDistState-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblTruancyDistState-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblTruancySchools-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblTruancySchools-DEPLOY]  TO [netwisco]
GO

