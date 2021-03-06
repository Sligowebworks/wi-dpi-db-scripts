USE wisconsin
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblAttendanceDistState-DEPLOY]([Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [PossDays], [ActualDays]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblAttendanceSchools-DEPLOY]([Year], [Fullkey], [Schooltype], [Grade], [Race], [Gender], [Disability], [EconDisadv], [ELPCode], [PossDays], [ActualDays]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[tblAttendanceDistState-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblAttendanceDistState-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[tblAttendanceSchools-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[tblAttendanceSchools-DEPLOY]  TO [netwisco]
GO

