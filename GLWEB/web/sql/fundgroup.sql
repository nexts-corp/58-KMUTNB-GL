SELECT fundgroup.FUNDGROUPID AS fundGroupId,fundgroup.FUNDGROUPNAME AS fundGroupName FROM MASTER3D.FUNDGROUP fundgroup
INNER JOIN (
  SELECT gl.FUNDGROUPID
  FROM MASTER3D.GL gl
  LEFT JOIN MASTER3D.GLHEAD glh
  ON gl.GLHEADID = glh.GLHEADID
  WHERE %s
  AND glh.GLHEADSTATUS != 'v'
  GROUP BY gl.FUNDGROUPID
) tfundgroup
on fundgroup.FUNDGROUPID = tfundgroup.FUNDGROUPID
ORDER BY fundgroup.FUNDGROUPID
