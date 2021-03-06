USE wisconsin
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblRetentionDistState-DEPLOY]([Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [PupilsRet], [PupilsRetWoGrade12Disabled]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblRetentionSchools-DEPLOY]([Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [PupilsRet], [PupilsRetWoGrade12Disabled]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblCSTForRetentionDistState-DEPLOY]([Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [Completed_School_Term]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblCSTForRetentionSchools-DEPLOY]([Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [Completed_School_Term]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblRetentionDistState-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblRetentionDistState-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblRetentionSchools-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblRetentionSchools-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblCSTForRetentionDistState-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblCSTForRetentionDistState-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblCSTForRetentionSchools-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblCSTForRetentionSchools-DEPLOY]  TO [netwisco]
GO