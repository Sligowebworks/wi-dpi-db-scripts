SELECT year, agencykey, subjectid, topic, cast(offerings as decimal(11,0)) as offerings  
FROM cwkoff
	UNION ALL
SELECT year, 'XXXXX' as agencykey, 'ALL' as subjectid, 'ALL' as topic, cast(sum(Offerings) as decimal(11,0)) as offerings
FROM cwkoff
GROUP BY year
	UNION ALL
SELECT year, agencykey, 'ALL' as subjectid, 'ALL' as topic, cast(sum(Offerings) as decimal(11,0)) as offerings
FROM cwkoff
GROUP BY year, agencykey
	UNION ALL
SELECT year, 'XXXXX' as agencykey, subjectid, 'ALL' as topic, cast(sum(Offerings) as decimal(11,0)) as offerings
FROM cwkoff
GROUP BY year, subjectid
	UNION ALL
SELECT year, agencykey, subjectid, 'ALL' as topic, Cast(sum(Offerings) as decimal(11,0)) as offerings
FROM cwkoff
GROUP BY year, agencykey, subjectid
	UNION ALL
SELECT year, 'XXXXX' as agencykey, subjectid, topic, cast(sum(Offerings) as decimal(11,0)) as offerings
FROM cwkoff
GROUP BY year, subjectid, topic
