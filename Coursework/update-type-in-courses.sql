USE Wisconsin
GO

update coursetypetemp 
Set topic = '0' + rtrim(ltrim(topic))
where len(topic) = 2
GO

update coursetypetemp 
Set topic = '00' + rtrim(ltrim(topic))
where len(topic) = 1
GO

update coursetypetemp 
Set topic = '000' + rtrim(ltrim(topic))
where len(topic) = 0
GO

Update courses set typeid = [CourseTypeID]
from 
courses, CourseTypes, CourseTypeTemp 
where
courses.subjectid = CourseTypeTemp.subject and courses.topic = CourseTypeTemp.topic and 
CourseTypeTemp.[Course Type] = CourseTypes.Description
GO

Update courses set WMASID1 = [WMASID]
from 
courses, COURSES_WMAS_SUBJ, CourseTypeTemp 
where
courses.subjectid = CourseTypeTemp.subject and courses.topic = CourseTypeTemp.topic and 
CourseTypeTemp.[WMASsubject1] = COURSES_WMAS_SUBJ.Description
GO

Update courses set WMASID2 = [WMASID]
from 
courses, COURSES_WMAS_SUBJ, CourseTypeTemp 
where
courses.subjectid = CourseTypeTemp.subject and courses.topic = CourseTypeTemp.topic and 
CourseTypeTemp.[WMASsubject2] = COURSES_WMAS_SUBJ.Description
GO