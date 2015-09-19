/* ประกันสัญญา */
SELECT
	ROW_NUMBER()OVER(ORDER BY RC.RECEIVEID)AS ID,
	GLH.GLHEADDATE,
	RC.RECEIVEDATE,
	CASE
WHEN RC.DESCRIPTION IS NULL THEN
	GLH.DESCRIPTION1
ELSE
	RC.DESCRIPTION
END AS DESCRIPTION,
 GL.CHEQUEID,
 GL.CHEQUEDATE,
 RI.CHEQBRANCHBANK,
 GLH.REFID1,
 RF.RECEIVEFEENAME,
 CONCAT(
	RC.DEPARTMENTBOOK,
	CONCAT(
		'-',
		CONCAT(
			RC.RECEIVEBOOKCODE,
			CONCAT(
				'-',
				CONCAT(
					RC.BUDGETPERIODID,
					CONCAT(
						'/',
						CONCAT(
							RC.BOOKNUMBER,
							CONCAT('/', RC.RUNNINGNUMBER)
						)
					)
				)
			)
		)
	)
)AS RECEIPT_NO,
 RC.BOOKNUMBER AS RECEIPT_BOOKNO,
(GL.CR - GL.DR)AS AMOUNT
FROM
	MASTER3D.GL
INNER JOIN MASTER3D.GLHEAD GLH ON GLH.GLHEADID = GL.GLHEADID
INNER JOIN MASTER3D.RECEIVE RC ON RC.RECEIVEID = GL.LOTID
INNER JOIN MASTER3D.RECEIVEITEM RI ON RI.RECEIVEID = RC.RECEIVEID
INNER JOIN MASTER3D.RECEIVEFEE RF ON RF.RECEIVEFEEID = RI.RECEIVEFEEID
WHERE
	GL.LOTCODE = 'RC'
AND RI.ACTIVITYID = RF.DEFAULTACTIVITY
AND GL.ACCOUNTID = 2160001001
AND GLH.GLHEADDATE >= TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY')
AND GLH.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')
AND RC.RECEIVESTATUS != 'V'
AND GLH.GLHEADSTATUS != 'V'
AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
{{BUDGET_SQL}}