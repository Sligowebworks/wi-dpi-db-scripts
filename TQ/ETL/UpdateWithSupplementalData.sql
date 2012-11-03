
INSERT tblTQass
SELECT *
FROM tblTQAss_suppl

INSERT tblTQStaff
SELECT *
FROM tblTQStaff_suppl

UPDATE tblTQAss
SET WiscLicenseStatus = 'F' WHERE AssignmentCode = '0001'


SELECT tqa.* FROM
tblTQAss tqa
  INNER JOIN
 tblTQAss_suppl sup
on tqa.year = sup.year AND tqa.staffkey = sup.staffkey AND tqa.WorkAgencyKey = sup.WorkAgencyKey AND tqa.AssignmentCode = sup.AssignmentCode

--SELECT count(*) FROM tblTQAss_suppl --3309

SELECT tqa.* FROM tblTQAss tqa
INNER JOIN (
SELECT year, staffkey, WorkAgencyKey, AssignmentCode--, PositionCode, HireAgencyKey
, count(*) as 'total'
FROM tblTQAss
GROUP BY year, staffkey, WorkAgencyKey, AssignmentCode--, PositionCode, HireAgencyKey
HAVING count(*) > 1
) ids on tqa.year = ids.year and tqa.staffkey = ids.staffkey
WHERE tqa.year > 2003
ORDER BY tqa.year, tqa.staffkey

SELECT tqs.* FROM
tblTQStaff tqs
  INNER JOIN
tblTQStaff_suppl sup
on tqs.year = sup.year AND tqs.staffkey = sup.staffkey



SELECT year, staffkey
, count(*)
FROM tblTQstaff_suppl
GROUP BY year, staffkey
HAVING count(*) > 1


