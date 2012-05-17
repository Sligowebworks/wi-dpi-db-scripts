USE wisconsin
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[tblActivitiesSchooltypes-DEPLOY]([Year], [AgencyKey], [FullKey], [SchoolType], [OldGrade], [Grade], [Activity], [NumOffer], [PupilParticip]) WITH  IGNORE_DUP_KEY ,  FILLFACTOR = 100 ON [PRIMARY]
GO

