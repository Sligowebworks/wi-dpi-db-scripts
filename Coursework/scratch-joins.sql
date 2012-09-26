
(Select SubjectID, Topic, Advanced, Description, TypeID,WMASID1,WMASID2  
	 FROM Courses WHERE year = (SELECT max(year) from coursework) --250
		UNION ALL
	SELECT DISTINCT  SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description, 5 as TypeID, 14 as WMASID1, 0 as WMASID2  
	FROM Courses where year = (SELECT max(year) from coursework) --17
		UNION ALL
	SELECT 'ALL' as SubjectID, 'ALL' as Topic,  'N' as Advanced, 'Total' as Description,5 as TypeID, 14 as WMASID1, 0 as WMASID2
) --268

SELECT DISTINCT Topic, WMASID1 from courses ORDER BY WMASID1 -- 261
SELECT DISTINCT SubjectID, TypeID FROM courses
--
--FROM v_Template_Keys_WWoDis_tblAgencyFull Keys
--	LEFT OUTER JOIN 
--Coursework ON 
--	Keys.Year = Coursework.Year 
--	AND Keys.Fullkey = Coursework.Fullkey
--	AND Keys.SubjectID = Coursework.SubjectID
--	AND Keys.Topic = Coursework.Topic
--	AND (
--		(keys.grade = '94' AND Coursework.Grade = '94') OR 
--		(keys.grade = '40' AND Coursework.Grade = '06') OR 
--		(keys.grade = '44' AND Coursework.Grade = '07') OR 
--		(keys.grade = '48' AND Coursework.Grade = '08') OR 
--		(keys.grade = '52' AND Coursework.Grade = '09') OR 
--		(keys.grade = '56' AND Coursework.Grade = '10') OR 
--		(keys.grade = '60' AND Coursework.Grade = '11') OR 
--		(keys.grade = '64' AND Coursework.Grade = '12') 
--	)
--	AND Keys.Sex = Coursework.Sex
--	LEFT OUTER JOIN 
--Courses C on
--Keys.Year = C.Year and
--Keys.SubjectID = C.SubjectID and
--Keys.Topic = C.Topic
--
--WHERE 
--Keys.Race = '9' 
--AND Keys.disabilityCode = 9
