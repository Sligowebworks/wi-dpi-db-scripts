SELECT * FROM 
(SELECT 
	 isnull(Year, 'ALL') as Year
	,isnull(AgencyKey,'XXXXX') as AgencyKey
	,Isnull(SubjectID,'ALL') as SubjectID
	,Isnull(Topic,'ALL') as Topic
	,Isnull(Grade,'94') as Grade
	,Isnull(Sex,'9') as Sex
	,Sum(Enrollment) as Enrollment
FROM cwk
GROUP BY Year, agencyKey, Subjectid, Topic, Grade, Sex
WITH Cube
) X
WHERE year <> 'ALL'
AND subjectid <> 'ALL'