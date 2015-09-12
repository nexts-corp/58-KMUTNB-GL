SELECT
  ROW_NUMBER() OVER (ORDER BY mgr.MGRCODE)  AS id,
  mgr.MGRCODE AS mgrCode ,
  CONCAT(mgr.MGRNAMETHAI,dep.DEPARTMENTNAME) AS mgrNameThai ,
  refer.MGRDEPARTMENTID AS mgrDepartmentId ,
  CONCAT(pre.PRENAMETHAI,refer.REFERNAME) AS referName
FROM MASTER3D.MGR mgr 
INNER JOIN (
  SELECT
    refer.MGRCODE,
    refer.MGRDEPARTMENTID,
    refer.PRENAMECODE,
    refer.REFERNAME
  FROM MASTER3D.REFER refer
  UNION ALL
  SELECT 
    more.MGRCODE,
    more.MGRDEPARTMENTID,
    refer.PRENAMECODE,
    refer.REFERNAME
  FROM MASTER3D.REFER refer
  INNER JOIN MASTER3D.MORETITLE more
  ON refer.REFERID = more.REFERID
) refer 
ON mgr.MGRCODE = refer.MGRCODE
INNER JOIN MASTER3D.PRENAME pre
ON refer.PRENAMECODE = pre.PRENAMECODE
INNER JOIN MASTER3D.DEPARTMENT dep
ON refer.MGRDEPARTMENTID = dep.DEPARTMENTID
WHERE mgr.MGRCODE = 01 
OR mgr.MGRCODE = 06 
OR mgr.MGRCODE = 20 
OR mgr.MGRCODE = 30
ORDER BY MGRCODE
