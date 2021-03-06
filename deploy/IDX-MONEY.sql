 CREATE  UNIQUE  CLUSTERED  INDEX [yearfullkeydistrict] ON [dbo].[Expend-DEPLOY]([Year], [FullKey], [District], [Support], [Admin], [Transp], [Facilities], [Food], [Total], [Instruction]) WITH  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [allcolumnsyearlast] ON [dbo].[Expend-DEPLOY]([FullKey], [District], [Instruction], [Support], [Admin], [Transp], [Facilities], [Food], [Total], [Year]) WITH  FILLFACTOR = 100 ON [PRIMARY]
GO

 CREATE  INDEX [Revenues_DEPLOY] ON [dbo].[Revenues-DEPLOY]([Year], [District], [FullKey]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

 CREATE  INDEX [yearfullkey] ON [dbo].[Revenues-DEPLOY]([Year], [FullKey]) WITH  FILLFACTOR = 90 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[Expend-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[Expend-DEPLOY]  TO [netwisco]
GO

GRANT  SELECT  ON [dbo].[Revenues-DEPLOY]  TO [public]
GO

GRANT  SELECT  ON [dbo].[Revenues-DEPLOY]  TO [netwisco]
GO

