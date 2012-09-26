use wisconsin
GO

SELECT top 1 * FROM CourseTypeTemp

--Update courses set typeid = [CourseTypeID]
SELECT typeid, * 
from 
courses, CourseTypes, CourseTypeTemp 
where
courses.subjectid = CourseTypeTemp.subject and courses.topic = CourseTypeTemp.topic and 
CourseTypeTemp.[Course Type] = CourseTypes.Description
GO


SELECT * FROM
CourseTypeTemp ctt LEFT OUTER JOIN CourseTypes ct
 on ctt.[Course Type] = ct.Description
WHERE ct.Description IS NULL

SELECT Distinct Description FROM CourseTypes

SELECT Distinct [Course Type] FROM CourseTypeTemp