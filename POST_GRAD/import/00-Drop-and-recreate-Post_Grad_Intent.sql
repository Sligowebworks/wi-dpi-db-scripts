if exists (select * from sysobjects where id = object_id(N'[dbo].[POST_GRAD_INTENT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[POST_GRAD_INTENT]
GO

CREATE TABLE [dbo].[POST_GRAD_INTENT] (
	[YEAR] [char] (4) NULL ,
	[FULLKEY] [char] (12) NULL ,
	[RACE] [tinyint] NULL ,
	[SEX] [tinyint] NULL ,
	[INTENTCODE] [char] (2) NULL ,
	[GRADS] [numeric](18, 0) NULL 
) ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[POST_GRAD_INTENT]  TO [public]
GO

GRANT  SELECT  ON [dbo].[POST_GRAD_INTENT]  TO [netwisco]
GO

