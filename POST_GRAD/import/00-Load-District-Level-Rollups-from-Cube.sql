Select vcube.year, districts.fullkey, race, sex, intentcode, Grads
 from (
	select isnull(p.Year, 'ALL') as Year, left(p.Fullkey, 6) as FKey, IsNull(p.Race, 9) as Race, Isnull(p.Sex,9) as Sex, Isnull(p.IntentCode,'AL') as IntentCode, Sum(p.Grads) as Grads
	from post p
	-- 285299 without join 
	inner join tblAgencyFull a on p.year = a.year and p.fullkey = a.fullkey
	where a.sms = '0'
	Group BY p.Year, left(p.FullKey,6), p.RACE, p.SEX, p.IntentCode 
	WITH CUBE 
) vcube, districts
where (vcube.year = districts.year and vcube.fkey = left(districts.fullkey,6))

