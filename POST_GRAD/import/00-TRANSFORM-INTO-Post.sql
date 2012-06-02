
INSERT INTO post
SELECT 
col1 as 'year'
, col2 as 'AgencyType'
, col3 as 'PupilID'
--, '99' as 'PupilID'
, col4 as 'IntentCode'
, col5 as 'Grads'
, [fullkey] = NULL
, [RACE] = dbo.convertDPIRaceCodes(left(col3,1), col1)
, [SEX] = CASE right(col3,1)
	WHEN 'F' THEN 1
	WHEN 'M' THEN 2 
	ELSE NULL END
FROM post_csv
