
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[POST_GRAD_INTENT_NRAdj]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[POST_GRAD_INTENT_NRAdj]
GO



SELECT 
'year' = k.[YEAR], 
'fullkey' = k.[fullkey], 
'RACE' = k.[RACE], 
'SEX' = k.[SEX], 
'INTENTCODE' = 'NR', 
'NRGRADS' = isnull([GRADS],0), 
'ALDiff' = isnull([ALDiff],0), 
'NRAdj' = isnull([GRADS],0) + isnull([ALDiff],0)

INTO POST_GRAD_INTENT_NRAdj

FROM 

(
SELECT * from 
(SELECT DISTINCT [YEAR] FROM [POST_GRAD_INTENT]) year, 
(SELECT DISTINCT [FULLKEY] FROM [POST_GRAD_INTENT]) fullkey, 
(SELECT DISTINCT [RACE] FROM [POST_GRAD_INTENT]) race,  
(SELECT DISTINCT [SEX] FROM [POST_GRAD_INTENT]) sex,
(SELECT 'NR' as 'INTENTCODE') intentcode
--where fullkey = '02041303XXXX' 
--order by YEAR, FULLKEY, RACE, SEX, INTENTCODE 
) k

left outer join 

(
-- Beloit doesn't have any NRs for 2007 - but I do a left outer join on this subquery which requires them 
-- must make true keyset, then left outer join to the two below with sum(isnull(grads,0))
SELECT [YEAR], [FULLKEY], [RACE], [SEX], 'INTENTCODE' = 'NR', 'GRADS' = sum(isnull([GRADS],0))
FROM [POST_GRAD_INTENT] where year <> 'ALL' and (race = '9' or sex = '9') and race <> '6' and [INTENTCODE] = 'NR'
group by [YEAR], [FULLKEY], [RACE], [SEX]
) NR

on ltrim(rtrim(k.year)) = ltrim(rtrim(NR.year)) and ltrim(rtrim(k.fullkey)) = ltrim(rtrim(NR.fullkey)) and ltrim(rtrim(k.race)) = ltrim(rtrim(NR.race)) and ltrim(rtrim(k.sex)) = ltrim(rtrim(NR.sex))

--full outer join 

left outer join 

(
SELECT [YEAR], [FULLKEY], [RACE], [SEX], [INTENTCODE], [ALDiff] 
FROM [POST_GRAD_INTENT_ALAdj] where year <> 'ALL' and (race = '9' or sex = '9') --and [INTENTCODE] = 'AL'
and [ALDiff] <> 0 
) al

on ltrim(rtrim(k.year)) = ltrim(rtrim(al.year)) and ltrim(rtrim(k.fullkey)) = ltrim(rtrim(al.fullkey)) and ltrim(rtrim(k.race)) = ltrim(rtrim(al.race)) and ltrim(rtrim(k.sex)) = ltrim(rtrim(al.sex))

where k.year > '2003'
--test
--and k.fullkey = '02041303XXXX' 

order by year, fullkey, RACE, SEX, INTENTCODE, NRGRADS, ALDiff, NRAdj

--SELECT [year], [fullkey], [RACE], [SEX], [INTENTCODE], [HSCGrads], [ALGrads], [ALAdj], [ALDiff] FROM [POST_GRAD_INTENT_ALAdj] where intentcode = 'NR'


