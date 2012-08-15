

 CREATE  UNIQUE  CLUSTERED  INDEX [AllClustered] ON [dbo].[Act_DEPLOY]([Year], [district], [school], [race], [sex], [PupilCount], [English], [Math], [Reading], [Science], [Composite], [fullkey]) WITH  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  INDEX [YearFullkey] ON [dbo].[Act_DEPLOY]([Year], [fullkey]) ON [PRIMARY]
GO

 CREATE  INDEX [AllYearAtEnd] ON [dbo].[Act_DEPLOY]([fullkey], [race], [sex], [Year]) ON [PRIMARY]
GO

 CREATE  INDEX [yeardistschoolracesex] ON [dbo].[Act_DEPLOY]([Year], [district], [school], [race], [sex]) WITH  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [YearFullkeyRaceSex] ON [dbo].[Act_DEPLOY]([Year], [fullkey], [race], [sex]) WITH  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [AllIncludingDataYearAtEnd] ON [dbo].[Act_DEPLOY]([district], [school], [race], [sex], [PupilCount], [English], [Math], [Reading], [Science], [Composite], [fullkey], [Year]) WITH  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[Act_DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[Act_DEPLOY]  TO [netwisco]
GO


