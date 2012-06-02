-- this is POST_GRAD_INTENT_TableMorphingAdj12Denom.sql

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[POST_GRAD_INTENT_AdjDenom]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[POST_GRAD_INTENT_AdjDenom]
GO

select [YEAR], [FULLKEY], [RACE], [SEX], [INTENTCODE], [GRADS] 

into POST_GRAD_INTENT_AdjDenom

from (
SELECT [YEAR], [FULLKEY], [RACE], [SEX], [INTENTCODE], [GRADS] FROM [POST_GRAD_INTENT] where year <> 'ALL' and (race = '9' or sex = '9') and year < '2004'
union all 
SELECT [YEAR], [FULLKEY], [RACE], [SEX], [INTENTCODE], [GRADS] FROM [POST_GRAD_INTENT] where year <> 'ALL' and (race = '9' or sex = '9') and [INTENTCODE] <> 'AL' and [INTENTCODE] <> 'NR' and year > '2003'
union all 
SELECT [year], [fullkey], [RACE], [SEX], [INTENTCODE], 'GRADS' = [ALAdj] FROM [POST_GRAD_INTENT_ALAdj]
union all 
SELECT [year], [fullkey], [RACE], [SEX], [INTENTCODE], 'GRADS' = [NRAdj] FROM [POST_GRAD_INTENT_NRAdj]
) x

order by [YEAR], [FULLKEY], [RACE], [SEX], [INTENTCODE]

CREATE  CLUSTERED  INDEX [AllClustered] ON [dbo].[POST_GRAD_INTENT_AdjDenom]([YEAR], [FULLKEY], [RACE], [SEX], [INTENTCODE], [GRADS]) WITH  FILLFACTOR = 100 ON [PRIMARY]
GO

GRANT  SELECT  ON [dbo].[POST_GRAD_INTENT_AdjDenom]  TO [public]
GO

GRANT  SELECT  ON [dbo].[POST_GRAD_INTENT_AdjDenom]  TO [netwisco]
GO


