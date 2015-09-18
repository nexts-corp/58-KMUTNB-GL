SELECT
	ROW_NUMBER () OVER (ORDER BY NULL) AS ID,
	HEADER1,
	HEADER2,
	HEADER3,
	ACC_NAME,
	BALANCE_CURRENT,
	BALANCE_PAST
FROM
	(
		SELECT
			'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
			'รายได้สูง(ต่ำ)กว่าค่าใช้จ่าย' AS HEADER2,
			'รายได้สูง(ต่ำ)กว่าค่าใช้จ่าย' AS HEADER3,
			'รายได้สูง(ต่ำ)กว่าค่าใช้จ่ายสุทธิ' AS ACC_NAME,
			BALANCE_CURRENT,
			BALANCE_PAST
		FROM
			(
				SELECT
					BALANCE_CURRENT,
					BALANCE_PAST
				FROM
					(
						SELECT
							'1' AS MASK,
							REVENUE_NET - EXPENSE_NET AS BALANCE_CURRENT
						FROM
							(
								SELECT
									SUM (CR - DR) AS REVENUE_NET
								FROM
									MASTER3D.GL
								LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
								LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
								WHERE
									GL.ACCOUNTID IN (
										SELECT
											ACCOUNTID
										FROM
											MASTER3D. ACCOUNT START WITH MASTERID = 4000000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
									)
								AND GL.GLHEADSTATUS != 'V'
								AND ACC.ACCOUNTSTATUS = 'Y'
								AND GL.ACCOUNTID NOT IN (
									4190700000,
									4190400000,
									4190103000,
									4190800000,
									4190900000,
									4191000000
								)
								AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
								AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
								AND (
									gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
									AND {{ BUDGET_SORCE_END }}
								)
								AND (
									gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
									AND {{ PLAN_SORCE_END }}
								)
								AND (
									gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
									AND {{ PROJECT_SORCE_END }}
								)
								AND (
									gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
									AND {{ ACTIVITY_SORCE_END }}
								)
								AND (
									gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
									AND {{ FUND_SORCE_END }}
								) {{ BUDGET_SQL }}
							) REVENUE
						CROSS JOIN (
							SELECT
								SUM (DR - CR) AS EXPENSE_NET
							FROM
								MASTER3D.GL
							LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
							LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
							WHERE
								GL.ACCOUNTID IN (
									SELECT
										ACCOUNTID
									FROM
										MASTER3D. ACCOUNT START WITH MASTERID = 5000000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
								)
							AND GL.GLHEADSTATUS != 'V'
							AND ACC.ACCOUNTSTATUS = 'Y'
							AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
							AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
							AND (
								gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
								AND {{ BUDGET_SORCE_END }}
							)
							AND (
								gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
								AND {{ PLAN_SORCE_END }}
							)
							AND (
								gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
								AND {{ PROJECT_SORCE_END }}
							)
							AND (
								gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
								AND {{ ACTIVITY_SORCE_END }}
							)
							AND (
								gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
								AND {{ FUND_SORCE_END }}
							) {{ BUDGET_SQL }}
						) EXPENSE
					) TMP_CURRENT
				FULL OUTER JOIN (
					SELECT
						'1' AS MASK,
						REVENUE_NET - EXPENSE_NET AS BALANCE_PAST
					FROM
						(
							SELECT
								SUM (CR - DR) AS REVENUE_NET
							FROM
								MASTER3D.GL
							LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
							LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
							WHERE
								GL.ACCOUNTID IN (
									SELECT
										ACCOUNTID
									FROM
										MASTER3D. ACCOUNT START WITH MASTERID = 4000000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
								)
							AND GL.GLHEADSTATUS != 'V'
							AND ACC.ACCOUNTSTATUS = 'Y'
							AND GL.ACCOUNTID NOT IN (
								4190700000,
								4190400000,
								4190103000,
								4190800000,
								4190900000,
								4191000000
							)
							AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
							AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
							AND (
								gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
								AND {{ BUDGET_SORCE_END }}
							)
							AND (
								gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
								AND {{ PLAN_SORCE_END }}
							)
							AND (
								gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
								AND {{ PROJECT_SORCE_END }}
							)
							AND (
								gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
								AND {{ ACTIVITY_SORCE_END }}
							)
							AND (
								gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
								AND {{ FUND_SORCE_END }}
							) {{ BUDGET_SQL }}
						) REVENUE
					CROSS JOIN (
						SELECT
							SUM (DR - CR) AS EXPENSE_NET
						FROM
							MASTER3D.GL
						LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
						LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
						WHERE
							GL.ACCOUNTID IN (
								SELECT
									ACCOUNTID
								FROM
									MASTER3D. ACCOUNT START WITH MASTERID = 5000000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
							)
						AND GL.GLHEADSTATUS != 'V'
						AND ACC.ACCOUNTSTATUS = 'Y'
						AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
						AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
						AND (
							gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
							AND {{ BUDGET_SORCE_END }}
						)
						AND (
							gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
							AND {{ PLAN_SORCE_END }}
						)
						AND (
							gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
							AND {{ PROJECT_SORCE_END }}
						)
						AND (
							gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
							AND {{ ACTIVITY_SORCE_END }}
						)
						AND (
							gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
							AND {{ FUND_SORCE_END }}
						) {{ BUDGET_SQL }}
					) EXPENSE
				) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
			)
		UNION ALL
			SELECT
				'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
				'ปรับกระทบกำไรสุทธิ' AS HEADER2,
				'จากการดำเนินงาน' AS HEADER3,
				'ค่าเสื่อมราคา-อาคารและสิ่งปลูกสร้าง' AS ACC_NAME,
				BALANCE_CURRENT,
				BALANCE_PAST
			FROM
				(
					SELECT
						BALANCE_CURRENT,
						BALANCE_PAST
					FROM
						(
							SELECT
								'1' AS MASK,
								SUM (DR - CR) AS BALANCE_CURRENT
							FROM
								MASTER3D.GL
							LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
							LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
							WHERE
								GL.ACCOUNTID IN (
									SELECT
										ACCOUNTID
									FROM
										MASTER3D. ACCOUNT START WITH (
											MASTERID = 5150101000
											OR MASTERID = 5150102000
											OR MASTERID = 5150103000
											OR MASTERID = 5150104000
										) CONNECT BY PRIOR ACCOUNTID = MASTERID
								)
							AND GL.GLHEADSTATUS != 'V'
							AND ACC.ACCOUNTSTATUS = 'Y'
							AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
							AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
							AND (
								gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
								AND {{ BUDGET_SORCE_END }}
							)
							AND (
								gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
								AND {{ PLAN_SORCE_END }}
							)
							AND (
								gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
								AND {{ PROJECT_SORCE_END }}
							)
							AND (
								gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
								AND {{ ACTIVITY_SORCE_END }}
							)
							AND (
								gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
								AND {{ FUND_SORCE_END }}
							) {{ BUDGET_SQL }}
						) TMP_CURRENT
					FULL OUTER JOIN (
						SELECT
							'1' AS MASK,
							SUM (DR - CR) AS BALANCE_PAST
						FROM
							MASTER3D.GL
						LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
						LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
						WHERE
							GL.ACCOUNTID IN (
								SELECT
									ACCOUNTID
								FROM
									MASTER3D. ACCOUNT START WITH (
										MASTERID = 5150101000
										OR MASTERID = 5150102000
										OR MASTERID = 5150103000
										OR MASTERID = 5150104000
									) CONNECT BY PRIOR ACCOUNTID = MASTERID
							)
						AND GL.GLHEADSTATUS != 'V'
						AND ACC.ACCOUNTSTATUS = 'Y'
						AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
						AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
						AND (
							gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
							AND {{ BUDGET_SORCE_END }}
						)
						AND (
							gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
							AND {{ PLAN_SORCE_END }}
						)
						AND (
							gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
							AND {{ PROJECT_SORCE_END }}
						)
						AND (
							gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
							AND {{ ACTIVITY_SORCE_END }}
						)
						AND (
							gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
							AND {{ FUND_SORCE_END }}
						) {{ BUDGET_SQL }}
					) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
				)
			UNION ALL
				SELECT
					'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
					'ปรับกระทบกำไรสุทธิ' AS HEADER2,
					'จากการดำเนินงาน' AS HEADER3,
					'ค่าเสื่อมราคา-ครุภัณฑ์' AS ACC_NAME,
					BALANCE_CURRENT,
					BALANCE_PAST
				FROM
					(
						SELECT
							BALANCE_CURRENT,
							BALANCE_PAST
						FROM
							(
								SELECT
									'1' AS MASK,
									SUM (DR - CR) AS BALANCE_CURRENT
								FROM
									MASTER3D.GL
								LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
								LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
								WHERE
									GL.ACCOUNTID IN (
										SELECT
											ACCOUNTID
										FROM
											MASTER3D. ACCOUNT START WITH MASTERID = 5150107000 CONNECT BY PRIOR ACCOUNTID = MASTERID
									)
								AND GL.GLHEADSTATUS != 'V'
								AND ACC.ACCOUNTSTATUS = 'Y'
								AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
								AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
								AND (
									gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
									AND {{ BUDGET_SORCE_END }}
								)
								AND (
									gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
									AND {{ PLAN_SORCE_END }}
								)
								AND (
									gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
									AND {{ PROJECT_SORCE_END }}
								)
								AND (
									gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
									AND {{ ACTIVITY_SORCE_END }}
								)
								AND (
									gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
									AND {{ FUND_SORCE_END }}
								) {{ BUDGET_SQL }}
							) TMP_CURRENT
						FULL OUTER JOIN (
							SELECT
								'1' AS MASK,
								SUM (DR - CR) AS BALANCE_PAST
							FROM
								MASTER3D.GL
							LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
							LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
							WHERE
								GL.ACCOUNTID IN (
									SELECT
										ACCOUNTID
									FROM
										MASTER3D. ACCOUNT START WITH MASTERID = 5150107000 CONNECT BY PRIOR ACCOUNTID = MASTERID
								)
							AND GL.GLHEADSTATUS != 'V'
							AND ACC.ACCOUNTSTATUS = 'Y'
							AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
							AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
							AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                                                        AND (
								gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
								AND {{ BUDGET_SORCE_END }}
							)
							AND (
								gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
								AND {{ PLAN_SORCE_END }}
							)
							AND (
								gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
								AND {{ PROJECT_SORCE_END }}
							)
							AND (
								gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
								AND {{ ACTIVITY_SORCE_END }}
							)
							AND (
								gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
								AND {{ FUND_SORCE_END }}
							) {{ BUDGET_SQL }}
						) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
					)
				UNION ALL
					SELECT
						'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
						'ปรับกระทบกำไรสุทธิ' AS HEADER2,
						'จากการดำเนินงาน' AS HEADER3,
						'ค่าตัดจำหน่าย' AS ACC_NAME,
						BALANCE_CURRENT,
						BALANCE_PAST
					FROM
						(
							SELECT
								BALANCE_CURRENT,
								BALANCE_PAST
							FROM
								(
									SELECT
										'1' AS MASK,
										SUM (DR - CR) AS BALANCE_CURRENT
									FROM
										MASTER3D.GL
									LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
									LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
									WHERE
										GL.ACCOUNTID IN (
											SELECT
												ACCOUNTID
											FROM
												MASTER3D. ACCOUNT START WITH MASTERID = 5150200000 CONNECT BY PRIOR ACCOUNTID = MASTERID
										)
									AND GL.GLHEADSTATUS != 'V'
									AND ACC.ACCOUNTSTATUS = 'Y'
									AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
									AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
									AND (
										gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
										AND {{ BUDGET_SORCE_END }}
									)
									AND (
										gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
										AND {{ PLAN_SORCE_END }}
									)
									AND (
										gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
										AND {{ PROJECT_SORCE_END }}
									)
									AND (
										gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
										AND {{ ACTIVITY_SORCE_END }}
									)
									AND (
										gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
										AND {{ FUND_SORCE_END }}
									) {{ BUDGET_SQL }}
								) TMP_CURRENT
							FULL OUTER JOIN (
								SELECT
									'1' AS MASK,
									SUM (DR - CR) AS BALANCE_PAST
								FROM
									MASTER3D.GL
								LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
								LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
								WHERE
									GL.ACCOUNTID IN (
										SELECT
											ACCOUNTID
										FROM
											MASTER3D. ACCOUNT START WITH MASTERID = 5150200000 CONNECT BY PRIOR ACCOUNTID = MASTERID
									)
								AND GL.GLHEADSTATUS != 'V'
								AND ACC.ACCOUNTSTATUS = 'Y'
								AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
								AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
								AND (
									gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
									AND {{ BUDGET_SORCE_END }}
								)
								AND (
									gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
									AND {{ PLAN_SORCE_END }}
								)
								AND (
									gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
									AND {{ PROJECT_SORCE_END }}
								)
								AND (
									gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
									AND {{ ACTIVITY_SORCE_END }}
								)
								AND (
									gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
									AND {{ FUND_SORCE_END }}
								) {{ BUDGET_SQL }}
							) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
						)
					UNION ALL
						SELECT
							'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
							'ปรับกระทบกำไรสุทธิ' AS HEADER2,
							'จากการดำเนินงาน' AS HEADER3,
							'เพิ่มขึ้น/ลดลงในลูกหนี้เงินยืมทดรองจ่าย' AS ACC_NAME,
							BALANCE_CURRENT,
							BALANCE_PAST
						FROM
							(
								SELECT
									BALANCE_CURRENT,
									BALANCE_PAST
								FROM
									(
										SELECT
											'1' AS MASK,
											SUM (CR - DR) AS BALANCE_CURRENT
										FROM
											MASTER3D.GL
										LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
										LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
										WHERE
											GL.ACCOUNTID IN (
												SELECT
													ACCOUNTID
												FROM
													MASTER3D. ACCOUNT START WITH MASTERID = 1120300000 CONNECT BY PRIOR ACCOUNTID = MASTERID
											)
										AND GL.GLHEADSTATUS != 'V'
										AND ACC.ACCOUNTSTATUS = 'Y'
										AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
										AND (
											gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
											AND {{ BUDGET_SORCE_END }}
										)
										AND (
											gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
											AND {{ PLAN_SORCE_END }}
										)
										AND (
											gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
											AND {{ PROJECT_SORCE_END }}
										)
										AND (
											gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
											AND {{ ACTIVITY_SORCE_END }}
										)
										AND (
											gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
											AND {{ FUND_SORCE_END }}
										) {{ BUDGET_SQL }}
									) TMP_CURRENT
								FULL OUTER JOIN (
									SELECT
										'1' AS MASK,
										SUM (CR - DR) AS BALANCE_PAST
									FROM
										MASTER3D.GL
									LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
									LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
									WHERE
										GL.ACCOUNTID IN (
											SELECT
												ACCOUNTID
											FROM
												MASTER3D. ACCOUNT START WITH MASTERID = 1120300000 CONNECT BY PRIOR ACCOUNTID = MASTERID
										)
									AND GL.GLHEADSTATUS != 'V'
									AND ACC.ACCOUNTSTATUS = 'Y'
									AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
									AND (
										gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
										AND {{ BUDGET_SORCE_END }}
									)
									AND (
										gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
										AND {{ PLAN_SORCE_END }}
									)
									AND (
										gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
										AND {{ PROJECT_SORCE_END }}
									)
									AND (
										gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
										AND {{ ACTIVITY_SORCE_END }}
									)
									AND (
										gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
										AND {{ FUND_SORCE_END }}
									) {{ BUDGET_SQL }}
								) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
							)
						UNION ALL
							SELECT
								'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
								'ปรับกระทบกำไรสุทธิ' AS HEADER2,
								'จากการดำเนินงาน' AS HEADER3,
								'เพิ่มขึ้น/ลดลงในลูกหนี้อื่นๆ' AS ACC_NAME,
								BALANCE_CURRENT,
								BALANCE_PAST
							FROM
								(
									SELECT
										BALANCE_CURRENT,
										BALANCE_PAST
									FROM
										(
											SELECT
												'1' AS MASK,
												SUM (DR - CR) AS BALANCE_CURRENT
											FROM
												MASTER3D.GL
											LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
											LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
											WHERE
												ACC.ACCOUNTID IN (
													SELECT
														ACCOUNTID
													FROM
														MASTER3D. ACCOUNT
													WHERE
														ACCOUNTSTATUS = 'Y'
													AND MASTERID = 1120400000
												)
											AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
											AND (
												gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
												AND {{ BUDGET_SORCE_END }}
											)
											AND (
												gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
												AND {{ PLAN_SORCE_END }}
											)
											AND (
												gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
												AND {{ PROJECT_SORCE_END }}
											)
											AND (
												gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
												AND {{ ACTIVITY_SORCE_END }}
											)
											AND (
												gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
												AND {{ FUND_SORCE_END }}
											) {{ BUDGET_SQL }}
											AND GL.GLHEADSTATUS != 'V'
										) TMP_CURRENT
									FULL OUTER JOIN (
										SELECT
											'1' AS MASK,
											SUM (DR - CR) AS BALANCE_PAST
										FROM
											MASTER3D.GL
										LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
										LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
										WHERE
											ACC.ACCOUNTID IN (
												SELECT
													ACCOUNTID
												FROM
													MASTER3D. ACCOUNT
												WHERE
													ACCOUNTSTATUS = 'Y'
												AND MASTERID = 1120400000
											)
										AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
										AND GL.GLHEADSTATUS != 'V'
										AND (
											gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
											AND {{ BUDGET_SORCE_END }}
										)
										AND (
											gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
											AND {{ PLAN_SORCE_END }}
										)
										AND (
											gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
											AND {{ PROJECT_SORCE_END }}
										)
										AND (
											gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
											AND {{ ACTIVITY_SORCE_END }}
										)
										AND (
											gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
											AND {{ FUND_SORCE_END }}
										) {{ BUDGET_SQL }}
									) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
								)
							UNION ALL
								SELECT
									'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
									'ปรับกระทบกำไรสุทธิ' AS HEADER2,
									'จากการดำเนินงาน' AS HEADER3,
									'เพิ่มขึ้น/ลดลงในเงินทดรองราชการรอเบิกจากคลัง' AS ACC_NAME,
									BALANCE_CURRENT,
									BALANCE_PAST
								FROM
									(
										SELECT
											BALANCE_CURRENT,
											BALANCE_PAST
										FROM
											(
												SELECT
													'1' AS MASK,
													SUM (CR - DR) AS BALANCE_CURRENT
												FROM
													MASTER3D.GL
												LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
												LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
												WHERE
													ACC.ACCOUNTID IN (
														SELECT
															ACCOUNTID
														FROM
															MASTER3D. ACCOUNT
														WHERE
															ACCOUNTSTATUS = 'Y'
														AND MASTERID = 1180006000
													)
												AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
												AND GL.GLHEADSTATUS != 'V'
                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
												AND (
													gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
													AND {{ BUDGET_SORCE_END }}
												)
												AND (
													gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
													AND {{ PLAN_SORCE_END }}
												)
												AND (
													gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
													AND {{ PROJECT_SORCE_END }}
												)
												AND (
													gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
													AND {{ ACTIVITY_SORCE_END }}
												)
												AND (
													gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
													AND {{ FUND_SORCE_END }}
												) {{ BUDGET_SQL }}
											) TMP_CURRENT
										FULL OUTER JOIN (
											SELECT
												'1' AS MASK,
												SUM (CR - DR) AS BALANCE_PAST
											FROM
												MASTER3D.GL
											LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
											LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
											WHERE
												ACC.ACCOUNTID IN (
													SELECT
														ACCOUNTID
													FROM
														MASTER3D. ACCOUNT
													WHERE
														ACCOUNTSTATUS = 'Y'
													AND MASTERID = 1180006000
												)
											AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
											AND GL.GLHEADSTATUS != 'V'
                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
											AND (
												gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
												AND {{ BUDGET_SORCE_END }}
											)
											AND (
												gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
												AND {{ PLAN_SORCE_END }}
											)
											AND (
												gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
												AND {{ PROJECT_SORCE_END }}
											)
											AND (
												gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
												AND {{ ACTIVITY_SORCE_END }}
											)
											AND (
												gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
												AND {{ FUND_SORCE_END }}
											) {{ BUDGET_SQL }}
										) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
									)
								UNION ALL
									SELECT
										'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
										'ปรับกระทบกำไรสุทธิ' AS HEADER2,
										'จากการดำเนินงาน' AS HEADER3,
										'เพิ่มขึ้น/ลดลงในรายได้ค้างรับ' AS ACC_NAME,
										BALANCE_CURRENT,
										BALANCE_PAST
									FROM
										(
											SELECT
												BALANCE_CURRENT,
												BALANCE_PAST
											FROM
												(
													SELECT
														'1' AS MASK,
														SUM (CR - DR) AS BALANCE_CURRENT
													FROM
														MASTER3D.GL
													LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
													LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
													WHERE
														GL.ACCOUNTID IN (
															SELECT
																ACCOUNTID
															FROM
																MASTER3D. ACCOUNT START WITH MASTERID = 1140000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
														)
													AND GL.GLHEADSTATUS != 'V'
													AND ACC.ACCOUNTSTATUS = 'Y'
													AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
													AND (
														gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
														AND {{ BUDGET_SORCE_END }}
													)
													AND (
														gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
														AND {{ PLAN_SORCE_END }}
													)
													AND (
														gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
														AND {{ PROJECT_SORCE_END }}
													)
													AND (
														gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
														AND {{ ACTIVITY_SORCE_END }}
													)
													AND (
														gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
														AND {{ FUND_SORCE_END }}
													) {{ BUDGET_SQL }}
												) TMP_CURRENT
											FULL OUTER JOIN (
												SELECT
													'1' AS MASK,
													SUM (CR - DR) AS BALANCE_PAST
												FROM
													MASTER3D.GL
												LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
												LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
												WHERE
													GL.ACCOUNTID IN (
														SELECT
															ACCOUNTID
														FROM
															MASTER3D. ACCOUNT START WITH MASTERID = 1140000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
													)
												AND GL.GLHEADSTATUS != 'V'
												AND ACC.ACCOUNTSTATUS = 'Y'
												AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
												AND (
													gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
													AND {{ BUDGET_SORCE_END }}
												)
												AND (
													gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
													AND {{ PLAN_SORCE_END }}
												)
												AND (
													gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
													AND {{ PROJECT_SORCE_END }}
												)
												AND (
													gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
													AND {{ ACTIVITY_SORCE_END }}
												)
												AND (
													gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
													AND {{ FUND_SORCE_END }}
												) {{ BUDGET_SQL }}
											) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
										)
									UNION ALL
										SELECT
											'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
											'ปรับกระทบกำไรสุทธิ' AS HEADER2,
											'จากการดำเนินงาน' AS HEADER3,
											'เพิ่มขึ้น/ลดลงในวัสดุคงเหลือ' AS ACC_NAME,
											BALANCE_CURRENT,
											BALANCE_PAST
										FROM
											(
												SELECT
													BALANCE_CURRENT,
													BALANCE_PAST
												FROM
													(
														SELECT
															'1' AS MASK,
															SUM (CR - DR) AS BALANCE_CURRENT
														FROM
															MASTER3D.GL
														LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
														LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
														WHERE
															ACC.ACCOUNTID IN (
																SELECT
																	ACCOUNTID
																FROM
																	MASTER3D. ACCOUNT START WITH MASTERID = 1160000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
															)
														AND GL.GLHEADSTATUS != 'V'
														AND ACC.ACCOUNTSTATUS = 'Y'
														AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
														AND (
															gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
															AND {{ BUDGET_SORCE_END }}
														)
														AND (
															gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
															AND {{ PLAN_SORCE_END }}
														)
														AND (
															gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
															AND {{ PROJECT_SORCE_END }}
														)
														AND (
															gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
															AND {{ ACTIVITY_SORCE_END }}
														)
														AND (
															gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
															AND {{ FUND_SORCE_END }}
														) {{ BUDGET_SQL }}
													) TMP_CURRENT
												FULL OUTER JOIN (
													SELECT
														'1' AS MASK,
														SUM (CR - DR) AS BALANCE_PAST
													FROM
														MASTER3D.GL
													LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
													LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
													WHERE
														ACC.ACCOUNTID IN (
															SELECT
																ACCOUNTID
															FROM
																MASTER3D. ACCOUNT START WITH MASTERID = 1160000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
														)
													AND GL.GLHEADSTATUS != 'V'
													AND ACC.ACCOUNTSTATUS = 'Y'
													AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
													AND (
														gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
														AND {{ BUDGET_SORCE_END }}
													)
													AND (
														gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
														AND {{ PLAN_SORCE_END }}
													)
													AND (
														gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
														AND {{ PROJECT_SORCE_END }}
													)
													AND (
														gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
														AND {{ ACTIVITY_SORCE_END }}
													)
													AND (
														gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
														AND {{ FUND_SORCE_END }}
													) {{ BUDGET_SQL }}
												) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
											)
										UNION ALL
											SELECT
												'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
												'ปรับกระทบกำไรสุทธิ' AS HEADER2,
												'จากการดำเนินงาน' AS HEADER3,
												'เพิ่มขึ้น/ลดลงในเงินประกันผลงาน' AS ACC_NAME,
												BALANCE_CURRENT,
												BALANCE_PAST
											FROM
												(
													SELECT
														BALANCE_CURRENT,
														BALANCE_PAST
													FROM
														(
															SELECT
																'1' AS MASK,
																SUM (CR - DR) AS BALANCE_CURRENT
															FROM
																MASTER3D.GL
															LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
															LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
															WHERE
																ACC.ACCOUNTID IN (
																	SELECT
																		ACCOUNTID
																	FROM
																		MASTER3D. ACCOUNT
																	WHERE
																		ACCOUNTSTATUS = 'Y'
																	AND MASTERID = 1180008000
																)
															AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
															AND (
																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																AND {{ BUDGET_SORCE_END }}
															)
															AND (
																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																AND {{ PLAN_SORCE_END }}
															)
															AND (
																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																AND {{ PROJECT_SORCE_END }}
															)
															AND (
																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																AND {{ ACTIVITY_SORCE_END }}
															)
															AND (
																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																AND {{ FUND_SORCE_END }}
															) {{ BUDGET_SQL }}
															AND GL.GLHEADSTATUS != 'V'
														) TMP_CURRENT
													FULL OUTER JOIN (
														SELECT
															'1' AS MASK,
															SUM (CR - DR) AS BALANCE_PAST
														FROM
															MASTER3D.GL
														LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
														LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
														WHERE
															ACC.ACCOUNTID IN (
																SELECT
																	ACCOUNTID
																FROM
																	MASTER3D. ACCOUNT
																WHERE
																	ACCOUNTSTATUS = 'Y'
																AND MASTERID = 1180008000
															)
														AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
														AND (
															gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
															AND {{ BUDGET_SORCE_END }}
														)
														AND (
															gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
															AND {{ PLAN_SORCE_END }}
														)
														AND (
															gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
															AND {{ PROJECT_SORCE_END }}
														)
														AND (
															gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
															AND {{ ACTIVITY_SORCE_END }}
														)
														AND (
															gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
															AND {{ FUND_SORCE_END }}
														) {{ BUDGET_SQL }}
														AND GL.GLHEADSTATUS != 'V'
													) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
												)
											UNION ALL
												SELECT
													'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
													'ปรับกระทบกำไรสุทธิ' AS HEADER2,
													'จากการดำเนินงาน' AS HEADER3,
													'เพิ่มขึ้น/ลดลงในเจ้าหนี้ระยะสั้น' AS ACC_NAME,
													BALANCE_CURRENT,
													BALANCE_PAST
												FROM
													(
														SELECT
															BALANCE_CURRENT,
															BALANCE_PAST
														FROM
															(
																SELECT
																	'1' AS MASK,
																	SUM (CR - DR) AS BALANCE_CURRENT
																FROM
																	MASTER3D.GL
																LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																WHERE
																	ACC.ACCOUNTID IN (
																		SELECT
																			ACCOUNTID
																		FROM
																			MASTER3D. ACCOUNT START WITH MASTERID = 2110000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																	)
																AND GL.GLHEADSTATUS != 'V'
																AND ACC.ACCOUNTSTATUS = 'Y'
																AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																AND (
																	gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																	AND {{ BUDGET_SORCE_END }}
																)
																AND (
																	gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																	AND {{ PLAN_SORCE_END }}
																)
																AND (
																	gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																	AND {{ PROJECT_SORCE_END }}
																)
																AND (
																	gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																	AND {{ ACTIVITY_SORCE_END }}
																)
																AND (
																	gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																	AND {{ FUND_SORCE_END }}
																) {{ BUDGET_SQL }}
															) TMP_CURRENT
														FULL OUTER JOIN (
															SELECT
																'1' AS MASK,
																SUM (CR - DR) AS BALANCE_PAST
															FROM
																MASTER3D.GL
															LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
															LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
															WHERE
																ACC.ACCOUNTID IN (
																	SELECT
																		ACCOUNTID
																	FROM
																		MASTER3D. ACCOUNT START WITH MASTERID = 2110000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																)
															AND GL.GLHEADSTATUS != 'V'
															AND ACC.ACCOUNTSTATUS = 'Y'
															AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
															AND (
																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																AND {{ BUDGET_SORCE_END }}
															)
															AND (
																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																AND {{ PLAN_SORCE_END }}
															)
															AND (
																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																AND {{ PROJECT_SORCE_END }}
															)
															AND (
																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																AND {{ ACTIVITY_SORCE_END }}
															)
															AND (
																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																AND {{ FUND_SORCE_END }}
															) {{ BUDGET_SQL }}
														) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
													)
												UNION ALL
													SELECT
														'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
														'ปรับกระทบกำไรสุทธิ' AS HEADER2,
														'จากการดำเนินงาน' AS HEADER3,
														'เพิ่มขึ้น/ลดลงในค่าใช้จ่ายค้างจ่าย' AS ACC_NAME,
														BALANCE_CURRENT,
														BALANCE_PAST
													FROM
														(
															SELECT
																BALANCE_CURRENT,
																BALANCE_PAST
															FROM
																(
																	SELECT
																		'1' AS MASK,
																		SUM (CR - DR) AS BALANCE_CURRENT
																	FROM
																		MASTER3D.GL
																	LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																	LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																	WHERE
																		ACC.ACCOUNTID IN (
																			SELECT
																				ACCOUNTID
																			FROM
																				MASTER3D. ACCOUNT START WITH MASTERID = 2120000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																		)
																	AND GL.GLHEADSTATUS != 'V'
																	AND ACC.ACCOUNTSTATUS = 'Y'
																	AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																	AND (
																		gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																		AND {{ BUDGET_SORCE_END }}
																	)
																	AND (
																		gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																		AND {{ PLAN_SORCE_END }}
																	)
																	AND (
																		gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																		AND {{ PROJECT_SORCE_END }}
																	)
																	AND (
																		gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																		AND {{ ACTIVITY_SORCE_END }}
																	)
																	AND (
																		gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																		AND {{ FUND_SORCE_END }}
																	) {{ BUDGET_SQL }}
																) TMP_CURRENT
															FULL OUTER JOIN (
																SELECT
																	'1' AS MASK,
																	SUM (CR - DR) AS BALANCE_PAST
																FROM
																	MASTER3D.GL
																LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																WHERE
																	ACC.ACCOUNTID IN (
																		SELECT
																			ACCOUNTID
																		FROM
																			MASTER3D. ACCOUNT START WITH MASTERID = 2120000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																	)
																AND GL.GLHEADSTATUS != 'V'
																AND ACC.ACCOUNTSTATUS = 'Y'
																AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																AND (
																	gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																	AND {{ BUDGET_SORCE_END }}
																)
																AND (
																	gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																	AND {{ PLAN_SORCE_END }}
																)
																AND (
																	gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																	AND {{ PROJECT_SORCE_END }}
																)
																AND (
																	gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																	AND {{ ACTIVITY_SORCE_END }}
																)
																AND (
																	gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																	AND {{ FUND_SORCE_END }}
																) {{ BUDGET_SQL }}
															) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
														)
													UNION ALL
														SELECT
															'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
															'ปรับกระทบกำไรสุทธิ' AS HEADER2,
															'จากการดำเนินงาน' AS HEADER3,
															'เพิ่มขึ้น/ลดลงในภาษีค้างจ่าย' AS ACC_NAME,
															BALANCE_CURRENT,
															BALANCE_PAST
														FROM
															(
																SELECT
																	BALANCE_CURRENT,
																	BALANCE_PAST
																FROM
																	(
																		SELECT
																			'1' AS MASK,
																			SUM (CR - DR) AS BALANCE_CURRENT
																		FROM
																			MASTER3D.GL
																		LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																		LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																		WHERE
																			ACC.ACCOUNTID IN (
																				SELECT
																					ACCOUNTID
																				FROM
																					MASTER3D. ACCOUNT START WITH (
																						MASTERID = 2180001000
																						OR MASTERID = 2180002000
																						OR MASTERID = 2180003000
																						OR MASTERID = 2180006000
																					) CONNECT BY PRIOR ACCOUNTID = MASTERID
																			)
																		AND GL.GLHEADSTATUS != 'V'
																		AND ACC.ACCOUNTSTATUS = 'Y'
																		AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																		AND (
																			gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																			AND {{ BUDGET_SORCE_END }}
																		)
																		AND (
																			gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																			AND {{ PLAN_SORCE_END }}
																		)
																		AND (
																			gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																			AND {{ PROJECT_SORCE_END }}
																		)
																		AND (
																			gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																			AND {{ ACTIVITY_SORCE_END }}
																		)
																		AND (
																			gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																			AND {{ FUND_SORCE_END }}
																		) {{ BUDGET_SQL }}
																	) TMP_CURRENT
																FULL OUTER JOIN (
																	SELECT
																		'1' AS MASK,
																		SUM (CR - DR) AS BALANCE_PAST
																	FROM
																		MASTER3D.GL
																	LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																	LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																	WHERE
																		ACC.ACCOUNTID IN (
																			SELECT
																				ACCOUNTID
																			FROM
																				MASTER3D. ACCOUNT START WITH (
																					MASTERID = 2180001000
																					OR MASTERID = 2180002000
																					OR MASTERID = 2180003000
																					OR MASTERID = 2180006000
																				) CONNECT BY PRIOR ACCOUNTID = MASTERID
																		)
																	AND GL.GLHEADSTATUS != 'V'
																	AND ACC.ACCOUNTSTATUS = 'Y'
																	AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																	AND (
																		gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																		AND {{ BUDGET_SORCE_END }}
																	)
																	AND (
																		gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																		AND {{ PLAN_SORCE_END }}
																	)
																	AND (
																		gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																		AND {{ PROJECT_SORCE_END }}
																	)
																	AND (
																		gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																		AND {{ ACTIVITY_SORCE_END }}
																	)
																	AND (
																		gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																		AND {{ FUND_SORCE_END }}
																	) {{ BUDGET_SQL }}
																) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
															)
														UNION ALL
															SELECT
																'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																'จากการดำเนินงาน' AS HEADER3,
																'เพิ่มขึ้น/ลดลงในรายได้รับล่วงหน้า' AS ACC_NAME,
																BALANCE_CURRENT,
																BALANCE_PAST
															FROM
																(
																	SELECT
																		BALANCE_CURRENT,
																		BALANCE_PAST
																	FROM
																		(
																			SELECT
																				'1' AS MASK,
																				SUM (CR - DR) AS BALANCE_CURRENT
																			FROM
																				MASTER3D.GL
																			LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																			LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																			WHERE
																				ACC.ACCOUNTID IN (
																					SELECT
																						ACCOUNTID
																					FROM
																						MASTER3D. ACCOUNT START WITH MASTERID = 2130000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																				)
																			AND GL.GLHEADSTATUS != 'V'
																			AND ACC.ACCOUNTSTATUS = 'Y'
																			AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																			AND (
																				gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																				AND {{ BUDGET_SORCE_END }}
																			)
																			AND (
																				gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																				AND {{ PLAN_SORCE_END }}
																			)
																			AND (
																				gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																				AND {{ PROJECT_SORCE_END }}
																			)
																			AND (
																				gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																				AND {{ ACTIVITY_SORCE_END }}
																			)
																			AND (
																				gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																				AND {{ FUND_SORCE_END }}
																			) {{ BUDGET_SQL }}
																		) TMP_CURRENT
																	FULL OUTER JOIN (
																		SELECT
																			'1' AS MASK,
																			SUM (CR - DR) AS BALANCE_PAST
																		FROM
																			MASTER3D.GL
																		LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																		LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																		WHERE
																			ACC.ACCOUNTID IN (
																				SELECT
																					ACCOUNTID
																				FROM
																					MASTER3D. ACCOUNT START WITH MASTERID = 2130000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																			)
																		AND GL.GLHEADSTATUS != 'V'
																		AND ACC.ACCOUNTSTATUS = 'Y'
																		AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																		AND (
																			gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																			AND {{ BUDGET_SORCE_END }}
																		)
																		AND (
																			gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																			AND {{ PLAN_SORCE_END }}
																		)
																		AND (
																			gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																			AND {{ PROJECT_SORCE_END }}
																		)
																		AND (
																			gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																			AND {{ ACTIVITY_SORCE_END }}
																		)
																		AND (
																			gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																			AND {{ FUND_SORCE_END }}
																		) {{ BUDGET_SQL }}
																	) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																)
															UNION ALL
																SELECT
																	'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																	'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																	'จากการดำเนินงาน' AS HEADER3,
																	'เพิ่มขึ้น/ลดลงในรายได้รอการรับรู้ระยะยาว' AS ACC_NAME,
																	BALANCE_CURRENT,
																	BALANCE_PAST
																FROM
																	(
																		SELECT
																			BALANCE_CURRENT,
																			BALANCE_PAST
																		FROM
																			(
																				SELECT
																					'1' AS MASK,
																					SUM (CR - DR) AS BALANCE_CURRENT
																				FROM
																					MASTER3D.GL
																				LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																				LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																				WHERE
																					ACC.ACCOUNTID IN (
																						SELECT
																							ACCOUNTID
																						FROM
																							MASTER3D. ACCOUNT
																						WHERE
																							ACCOUNTSTATUS = 'Y'
																						AND MASTERID = 2200001000
																					)
																				AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																				AND (
																					gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																					AND {{ BUDGET_SORCE_END }}
																				)
																				AND (
																					gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																					AND {{ PLAN_SORCE_END }}
																				)
																				AND (
																					gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																					AND {{ PROJECT_SORCE_END }}
																				)
																				AND (
																					gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																					AND {{ ACTIVITY_SORCE_END }}
																				)
																				AND (
																					gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																					AND {{ FUND_SORCE_END }}
																				) {{ BUDGET_SQL }}
																				AND GL.GLHEADSTATUS != 'V'
																			) TMP_CURRENT
																		FULL OUTER JOIN (
																			SELECT
																				'1' AS MASK,
																				SUM (CR - DR) AS BALANCE_PAST
																			FROM
																				MASTER3D.GL
																			LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																			LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																			WHERE
																				ACC.ACCOUNTID IN (
																					SELECT
																						ACCOUNTID
																					FROM
																						MASTER3D. ACCOUNT
																					WHERE
																						ACCOUNTSTATUS = 'Y'
																					AND MASTERID = 2200001000
																				)
																			AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																			AND (
																				gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																				AND {{ BUDGET_SORCE_END }}
																			)
																			AND (
																				gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																				AND {{ PLAN_SORCE_END }}
																			)
																			AND (
																				gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																				AND {{ PROJECT_SORCE_END }}
																			)
																			AND (
																				gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																				AND {{ ACTIVITY_SORCE_END }}
																			)
																			AND (
																				gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																				AND {{ FUND_SORCE_END }}
																			) {{ BUDGET_SQL }}
																			AND GL.GLHEADSTATUS != 'V'
																		) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																	)
																UNION ALL
																	SELECT
																		'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																		'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																		'จากการดำเนินงาน' AS HEADER3,
																		'เพิ่มขึ้น/ลดลงในเงินรับฝาก' AS ACC_NAME,
																		BALANCE_CURRENT,
																		BALANCE_PAST
																	FROM
																		(
																			SELECT
																				BALANCE_CURRENT,
																				BALANCE_PAST
																			FROM
																				(
																					SELECT
																						'1' AS MASK,
																						SUM (CR - DR) AS BALANCE_CURRENT
																					FROM
																						MASTER3D.GL
																					LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																					LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																					WHERE
																						ACC.ACCOUNTID IN (
																							SELECT
																								ACCOUNTID
																							FROM
																								MASTER3D. ACCOUNT START WITH MASTERID = 2200003000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																						)
																					AND GL.GLHEADSTATUS != 'V'
																					AND ACC.ACCOUNTSTATUS = 'Y'
																					AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																					AND (
																						gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																						AND {{ BUDGET_SORCE_END }}
																					)
																					AND (
																						gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																						AND {{ PLAN_SORCE_END }}
																					)
																					AND (
																						gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																						AND {{ PROJECT_SORCE_END }}
																					)
																					AND (
																						gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																						AND {{ ACTIVITY_SORCE_END }}
																					)
																					AND (
																						gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																						AND {{ FUND_SORCE_END }}
																					) {{ BUDGET_SQL }}
																				) TMP_CURRENT
																			FULL OUTER JOIN (
																				SELECT
																					'1' AS MASK,
																					SUM (CR - DR) AS BALANCE_PAST
																				FROM
																					MASTER3D.GL
																				LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																				LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																				WHERE
																					ACC.ACCOUNTID IN (
																						SELECT
																							ACCOUNTID
																						FROM
																							MASTER3D. ACCOUNT START WITH MASTERID = 2200003000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																					)
																				AND GL.GLHEADSTATUS != 'V'
																				AND ACC.ACCOUNTSTATUS = 'Y'
																				AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																				AND (
																					gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																					AND {{ BUDGET_SORCE_END }}
																				)
																				AND (
																					gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																					AND {{ PLAN_SORCE_END }}
																				)
																				AND (
																					gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																					AND {{ PROJECT_SORCE_END }}
																				)
																				AND (
																					gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																					AND {{ ACTIVITY_SORCE_END }}
																				)
																				AND (
																					gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																					AND {{ FUND_SORCE_END }}
																				) {{ BUDGET_SQL }}
																			) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																		)
																	UNION ALL
																		SELECT
																			'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																			'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																			'จากการดำเนินงาน' AS HEADER3,
																			'เพิ่มขึ้น/ลดลงในเงินมัดจำและประกันสัญญา' AS ACC_NAME,
																			BALANCE_CURRENT,
																			BALANCE_PAST
																		FROM
																			(
																				SELECT
																					BALANCE_CURRENT,
																					BALANCE_PAST
																				FROM
																					(
																						SELECT
																							'1' AS MASK,
																							SUM (CR - DR) AS BALANCE_CURRENT
																						FROM
																							MASTER3D.GL
																						LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																						LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																						WHERE
																							ACC.ACCOUNTID IN (
																								SELECT
																									ACCOUNTID
																								FROM
																									MASTER3D. ACCOUNT START WITH MASTERID = 2160000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																							)
																						AND GL.GLHEADSTATUS != 'V'
																						AND ACC.ACCOUNTSTATUS = 'Y'
																						AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																						AND (
																							gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																							AND {{ BUDGET_SORCE_END }}
																						)
																						AND (
																							gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																							AND {{ PLAN_SORCE_END }}
																						)
																						AND (
																							gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																							AND {{ PROJECT_SORCE_END }}
																						)
																						AND (
																							gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																							AND {{ ACTIVITY_SORCE_END }}
																						)
																						AND (
																							gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																							AND {{ FUND_SORCE_END }}
																						) {{ BUDGET_SQL }}
																					) TMP_CURRENT
																				FULL OUTER JOIN (
																					SELECT
																						'1' AS MASK,
																						SUM (CR - DR) AS BALANCE_PAST
																					FROM
																						MASTER3D.GL
																					LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																					LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																					WHERE
																						ACC.ACCOUNTID IN (
																							SELECT
																								ACCOUNTID
																							FROM
																								MASTER3D. ACCOUNT START WITH MASTERID = 2160000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																						)
																					AND GL.GLHEADSTATUS != 'V'
																					AND ACC.ACCOUNTSTATUS = 'Y'
																					AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																					AND (
																						gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																						AND {{ BUDGET_SORCE_END }}
																					)
																					AND (
																						gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																						AND {{ PLAN_SORCE_END }}
																					)
																					AND (
																						gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																						AND {{ PROJECT_SORCE_END }}
																					)
																					AND (
																						gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																						AND {{ ACTIVITY_SORCE_END }}
																					)
																					AND (
																						gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																						AND {{ FUND_SORCE_END }}
																					) {{ BUDGET_SQL }}
																				) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																			)
																		UNION ALL
																			SELECT
																				'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																				'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																				'จากการดำเนินงาน' AS HEADER3,
																				'เพิ่มขึ้น/ลดลงในทุนการศึกษาคงยอดเงินต้น' AS ACC_NAME,
																				BALANCE_CURRENT,
																				BALANCE_PAST
																			FROM
																				(
																					SELECT
																						BALANCE_CURRENT,
																						BALANCE_PAST
																					FROM
																						(
																							SELECT
																								'1' AS MASK,
																								SUM (CR - DR) AS BALANCE_CURRENT
																							FROM
																								MASTER3D.GL
																							LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																							LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																							WHERE
																								ACC.ACCOUNTID IN (
																									SELECT
																										ACCOUNTID
																									FROM
																										MASTER3D. ACCOUNT
																									WHERE
																										ACCOUNTSTATUS = 'Y'
																									AND MASTERID = 2200005000
																								)
																							AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																							AND (
																								gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																								AND {{ BUDGET_SORCE_END }}
																							)
																							AND (
																								gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																								AND {{ PLAN_SORCE_END }}
																							)
																							AND (
																								gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																								AND {{ PROJECT_SORCE_END }}
																							)
																							AND (
																								gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																								AND {{ ACTIVITY_SORCE_END }}
																							)
																							AND (
																								gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																								AND {{ FUND_SORCE_END }}
																							) {{ BUDGET_SQL }}
																						) TMP_CURRENT
																					FULL OUTER JOIN (
																						SELECT
																							'1' AS MASK,
																							SUM (CR - DR) AS BALANCE_PAST
																						FROM
																							MASTER3D.GL
																						LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																						LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																						WHERE
																							ACC.ACCOUNTID IN (
																								SELECT
																									ACCOUNTID
																								FROM
																									MASTER3D. ACCOUNT
																								WHERE
																									ACCOUNTSTATUS = 'Y'
																								AND MASTERID = 2200005000
																							)
																						AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																						AND (
																							gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																							AND {{ BUDGET_SORCE_END }}
																						)
																						AND (
																							gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																							AND {{ PLAN_SORCE_END }}
																						)
																						AND (
																							gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																							AND {{ PROJECT_SORCE_END }}
																						)
																						AND (
																							gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																							AND {{ ACTIVITY_SORCE_END }}
																						)
																						AND (
																							gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																							AND {{ FUND_SORCE_END }}
																						) {{ BUDGET_SQL }}
																						AND GL.GLHEADSTATUS != 'V'
																					) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																				)
																			UNION ALL
																				SELECT
																					'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																					'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																					'จากการดำเนินงาน' AS HEADER3,
																					'เพิ่มขึ้น/ลดลงในดอกผลทุนการศึกษาคงยอดเงินต้น' AS ACC_NAME,
																					BALANCE_CURRENT,
																					BALANCE_PAST
																				FROM
																					(
																						SELECT
																							BALANCE_CURRENT,
																							BALANCE_PAST
																						FROM
																							(
																								SELECT
																									'1' AS MASK,
																									SUM (CR - DR) AS BALANCE_CURRENT
																								FROM
																									MASTER3D.GL
																								LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																								LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																								WHERE
																									ACC.ACCOUNTID IN (
																										SELECT
																											ACCOUNTID
																										FROM
																											MASTER3D. ACCOUNT
																										WHERE
																											ACCOUNTSTATUS = 'Y'
																										AND MASTERID = 2200006000
																									)
																								AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																								AND (
																									gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																									AND {{ BUDGET_SORCE_END }}
																								)
																								AND (
																									gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																									AND {{ PLAN_SORCE_END }}
																								)
																								AND (
																									gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																									AND {{ PROJECT_SORCE_END }}
																								)
																								AND (
																									gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																									AND {{ ACTIVITY_SORCE_END }}
																								)
																								AND (
																									gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																									AND {{ FUND_SORCE_END }}
																								) {{ BUDGET_SQL }}
																								AND GL.GLHEADSTATUS != 'V'
																							) TMP_CURRENT
																						FULL OUTER JOIN (
																							SELECT
																								'1' AS MASK,
																								SUM (CR - DR) AS BALANCE_PAST
																							FROM
																								MASTER3D.GL
																							LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																							LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																							WHERE
																								ACC.ACCOUNTID IN (
																									SELECT
																										ACCOUNTID
																									FROM
																										MASTER3D. ACCOUNT
																									WHERE
																										ACCOUNTSTATUS = 'Y'
																									AND MASTERID = 2200006000
																								)
																							AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																							AND (
																								gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																								AND {{ BUDGET_SORCE_END }}
																							)
																							AND (
																								gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																								AND {{ PLAN_SORCE_END }}
																							)
																							AND (
																								gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																								AND {{ PROJECT_SORCE_END }}
																							)
																							AND (
																								gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																								AND {{ ACTIVITY_SORCE_END }}
																							)
																							AND (
																								gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																								AND {{ FUND_SORCE_END }}
																							) {{ BUDGET_SQL }}
																						) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																					)
																				UNION ALL
																					SELECT
																						'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																						'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																						'จากการดำเนินงาน' AS HEADER3,
																						'เพิ่มขึ้น/ลดลงในทุนการศึกษาจ่ายผ่าน' AS ACC_NAME,
																						BALANCE_CURRENT,
																						BALANCE_PAST
																					FROM
																						(
																							SELECT
																								BALANCE_CURRENT,
																								BALANCE_PAST
																							FROM
																								(
																									SELECT
																										'1' AS MASK,
																										SUM (CR - DR) AS BALANCE_CURRENT
																									FROM
																										MASTER3D.GL
																									LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																									LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																									WHERE
																										ACC.ACCOUNTID IN (
																											SELECT
																												ACCOUNTID
																											FROM
																												MASTER3D. ACCOUNT
																											WHERE
																												ACCOUNTSTATUS = 'Y'
																											AND MASTERID = 2200004000
																										)
																									AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																									AND (
																										gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																										AND {{ BUDGET_SORCE_END }}
																									)
																									AND (
																										gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																										AND {{ PLAN_SORCE_END }}
																									)
																									AND (
																										gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																										AND {{ PROJECT_SORCE_END }}
																									)
																									AND (
																										gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																										AND {{ ACTIVITY_SORCE_END }}
																									)
																									AND (
																										gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																										AND {{ FUND_SORCE_END }}
																									) {{ BUDGET_SQL }}
																									AND GL.GLHEADSTATUS != 'V'
																								) TMP_CURRENT
																							FULL OUTER JOIN (
																								SELECT
																									'1' AS MASK,
																									SUM (CR - DR) AS BALANCE_PAST
																								FROM
																									MASTER3D.GL
																								LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																								LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																								WHERE
																									ACC.ACCOUNTID IN (
																										SELECT
																											ACCOUNTID
																										FROM
																											MASTER3D. ACCOUNT
																										WHERE
																											ACCOUNTSTATUS = 'Y'
																										AND MASTERID = 2200004000
																									)
																								AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																								AND (
																									gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																									AND {{ BUDGET_SORCE_END }}
																								)
																								AND (
																									gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																									AND {{ PLAN_SORCE_END }}
																								)
																								AND (
																									gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																									AND {{ PROJECT_SORCE_END }}
																								)
																								AND (
																									gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																									AND {{ ACTIVITY_SORCE_END }}
																								)
																								AND (
																									gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																									AND {{ FUND_SORCE_END }}
																								) {{ BUDGET_SQL }}
																								AND GL.GLHEADSTATUS != 'V'
																							) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																						)
																					UNION ALL
																						SELECT
																							'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																							'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																							'จากการดำเนินงาน' AS HEADER3,
																							'เพิ่มขึ้น/ลดลงในเงินกองทุนอุดหนุนการวิจัย' AS ACC_NAME,
																							BALANCE_CURRENT,
																							BALANCE_PAST
																						FROM
																							(
																								SELECT
																									BALANCE_CURRENT,
																									BALANCE_PAST
																								FROM
																									(
																										SELECT
																											'1' AS MASK,
																											SUM (CR - DR) AS BALANCE_CURRENT
																										FROM
																											MASTER3D.GL
																										LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																										LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																										WHERE
																											ACC.ACCOUNTID IN (
																												SELECT
																													ACCOUNTID
																												FROM
																													MASTER3D. ACCOUNT
																												WHERE
																													ACCOUNTSTATUS = 'Y'
																												AND MASTERID = 2200008000
																											)
																										AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																										AND (
																											gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																											AND {{ BUDGET_SORCE_END }}
																										)
																										AND (
																											gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																											AND {{ PLAN_SORCE_END }}
																										)
																										AND (
																											gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																											AND {{ PROJECT_SORCE_END }}
																										)
																										AND (
																											gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																											AND {{ ACTIVITY_SORCE_END }}
																										)
																										AND (
																											gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																											AND {{ FUND_SORCE_END }}
																										) {{ BUDGET_SQL }}
																										AND GL.GLHEADSTATUS != 'V'
																									) TMP_CURRENT
																								FULL OUTER JOIN (
																									SELECT
																										'1' AS MASK,
																										SUM (CR - DR) AS BALANCE_PAST
																									FROM
																										MASTER3D.GL
																									LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																									LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																									WHERE
																										ACC.ACCOUNTID IN (
																											SELECT
																												ACCOUNTID
																											FROM
																												MASTER3D. ACCOUNT
																											WHERE
																												ACCOUNTSTATUS = 'Y'
																											AND MASTERID = 2200008000
																										)
																									AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																									AND (
																										gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																										AND {{ BUDGET_SORCE_END }}
																									)
																									AND (
																										gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																										AND {{ PLAN_SORCE_END }}
																									)
																									AND (
																										gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																										AND {{ PROJECT_SORCE_END }}
																									)
																									AND (
																										gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																										AND {{ ACTIVITY_SORCE_END }}
																									)
																									AND (
																										gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																										AND {{ FUND_SORCE_END }}
																									) {{ BUDGET_SQL }}
																									AND GL.GLHEADSTATUS != 'V'
																								) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																							)
																						UNION ALL
																							SELECT
																								'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																								'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																								'จากการดำเนินงาน' AS HEADER3,
																								'เพิ่มขึ้น/ลดลงในเงินพัฒนาวิชาการ' AS ACC_NAME,
																								BALANCE_CURRENT,
																								BALANCE_PAST
																							FROM
																								(
																									SELECT
																										BALANCE_CURRENT,
																										BALANCE_PAST
																									FROM
																										(
																											SELECT
																												'1' AS MASK,
																												SUM (CR - DR) AS BALANCE_CURRENT
																											FROM
																												MASTER3D.GL
																											LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																											LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																											WHERE
																												ACC.ACCOUNTID IN (
																													SELECT
																														ACCOUNTID
																													FROM
																														MASTER3D. ACCOUNT
																													WHERE
																														ACCOUNTSTATUS = 'Y'
																													AND MASTERID = 2200009000
																												)
																											AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																											AND (
																												gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																												AND {{ BUDGET_SORCE_END }}
																											)
																											AND (
																												gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																												AND {{ PLAN_SORCE_END }}
																											)
																											AND (
																												gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																												AND {{ PROJECT_SORCE_END }}
																											)
																											AND (
																												gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																												AND {{ ACTIVITY_SORCE_END }}
																											)
																											AND (
																												gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																												AND {{ FUND_SORCE_END }}
																											) {{ BUDGET_SQL }}
																											AND GL.GLHEADSTATUS != 'V'
																										) TMP_CURRENT
																									FULL OUTER JOIN (
																										SELECT
																											'1' AS MASK,
																											SUM (CR - DR) AS BALANCE_PAST
																										FROM
																											MASTER3D.GL
																										LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																										LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																										WHERE
																											ACC.ACCOUNTID IN (
																												SELECT
																													ACCOUNTID
																												FROM
																													MASTER3D. ACCOUNT
																												WHERE
																													ACCOUNTSTATUS = 'Y'
																												AND MASTERID = 2200009000
																											)
																										AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																										AND (
																											gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																											AND {{ BUDGET_SORCE_END }}
																										)
																										AND (
																											gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																											AND {{ PLAN_SORCE_END }}
																										)
																										AND (
																											gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																											AND {{ PROJECT_SORCE_END }}
																										)
																										AND (
																											gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																											AND {{ ACTIVITY_SORCE_END }}
																										)
																										AND (
																											gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																											AND {{ FUND_SORCE_END }}
																										) {{ BUDGET_SQL }}
																										AND GL.GLHEADSTATUS != 'V'
																									) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																								)
																							UNION ALL
																								SELECT
																									'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																									'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																									'จากการดำเนินงาน' AS HEADER3,
																									'เพิ่มขึ้น/ลดลงในเงินบริจาคโดยมีวัตถุประสงค์' AS ACC_NAME,
																									BALANCE_CURRENT,
																									BALANCE_PAST
																								FROM
																									(
																										SELECT
																											BALANCE_CURRENT,
																											BALANCE_PAST
																										FROM
																											(
																												SELECT
																													'1' AS MASK,
																													SUM (CR - DR) AS BALANCE_CURRENT
																												FROM
																													MASTER3D.GL
																												LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																												LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																												WHERE
																													ACC.ACCOUNTID IN (
																														SELECT
																															ACCOUNTID
																														FROM
																															MASTER3D. ACCOUNT
																														WHERE
																															ACCOUNTSTATUS = 'Y'
																														AND MASTERID = 2200010000
																													)
																												AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																												AND (
																													gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																													AND {{ BUDGET_SORCE_END }}
																												)
																												AND (
																													gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																													AND {{ PLAN_SORCE_END }}
																												)
																												AND (
																													gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																													AND {{ PROJECT_SORCE_END }}
																												)
																												AND (
																													gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																													AND {{ ACTIVITY_SORCE_END }}
																												)
																												AND (
																													gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																													AND {{ FUND_SORCE_END }}
																												) {{ BUDGET_SQL }}
																												AND GL.GLHEADSTATUS != 'V'
																											) TMP_CURRENT
																										FULL OUTER JOIN (
																											SELECT
																												'1' AS MASK,
																												SUM (CR - DR) AS BALANCE_PAST
																											FROM
																												MASTER3D.GL
																											LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																											LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																											WHERE
																												ACC.ACCOUNTID IN (
																													SELECT
																														ACCOUNTID
																													FROM
																														MASTER3D. ACCOUNT
																													WHERE
																														ACCOUNTSTATUS = 'Y'
																													AND MASTERID = 2200010000
																												)
																											AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																											AND (
																												gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																												AND {{ BUDGET_SORCE_END }}
																											)
																											AND (
																												gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																												AND {{ PLAN_SORCE_END }}
																											)
																											AND (
																												gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																												AND {{ PROJECT_SORCE_END }}
																											)
																											AND (
																												gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																												AND {{ ACTIVITY_SORCE_END }}
																											)
																											AND (
																												gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																												AND {{ FUND_SORCE_END }}
																											) {{ BUDGET_SQL }}
																											AND GL.GLHEADSTATUS != 'V'
																										) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																									)
																								UNION ALL
																									SELECT
																										'กระแสเงินสดจากกิจกรรมดำเนินงาน' AS HEADER1,
																										'ปรับกระทบกำไรสุทธิ' AS HEADER2,
																										'จากการดำเนินงาน' AS HEADER3,
																										'เพิ่มขึ้น/ลดลงในเงินสวัสดิการมหาวิทยาลัย' AS ACC_NAME,
																										BALANCE_CURRENT,
																										BALANCE_PAST
																									FROM
																										(
																											SELECT
																												BALANCE_CURRENT,
																												BALANCE_PAST
																											FROM
																												(
																													SELECT
																														'1' AS MASK,
																														SUM (CR - DR) AS BALANCE_CURRENT
																													FROM
																														MASTER3D.GL
																													LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																													LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																													WHERE
																														ACC.ACCOUNTID IN (
																															SELECT
																																ACCOUNTID
																															FROM
																																MASTER3D. ACCOUNT
																															WHERE
																																ACCOUNTSTATUS = 'Y'
																															AND MASTERID = 2200011000
																														)
																													AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																													AND (
																														gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																														AND {{ BUDGET_SORCE_END }}
																													)
																													AND (
																														gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																														AND {{ PLAN_SORCE_END }}
																													)
																													AND (
																														gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																														AND {{ PROJECT_SORCE_END }}
																													)
																													AND (
																														gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																														AND {{ ACTIVITY_SORCE_END }}
																													)
																													AND (
																														gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																														AND {{ FUND_SORCE_END }}
																													) {{ BUDGET_SQL }}
																													AND GL.GLHEADSTATUS != 'V'
																												) TMP_CURRENT
																											FULL OUTER JOIN (
																												SELECT
																													'1' AS MASK,
																													SUM (CR - DR) AS BALANCE_PAST
																												FROM
																													MASTER3D.GL
																												LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																												LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																												WHERE
																													ACC.ACCOUNTID IN (
																														SELECT
																															ACCOUNTID
																														FROM
																															MASTER3D. ACCOUNT
																														WHERE
																															ACCOUNTSTATUS = 'Y'
																														AND MASTERID = 2200011000
																													)
																												AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																												AND (
																													gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																													AND {{ BUDGET_SORCE_END }}
																												)
																												AND (
																													gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																													AND {{ PLAN_SORCE_END }}
																												)
																												AND (
																													gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																													AND {{ PROJECT_SORCE_END }}
																												)
																												AND (
																													gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																													AND {{ ACTIVITY_SORCE_END }}
																												)
																												AND (
																													gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																													AND {{ FUND_SORCE_END }}
																												) {{ BUDGET_SQL }}
																												AND GL.GLHEADSTATUS != 'V'
																											) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																										)
																									UNION ALL
																										SELECT
																											'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER1,
																											'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER2,
																											'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER3,
																											'เพิ่มขึ้น/ลดลงในเงินลงทุน' AS ACC_NAME,
																											BALANCE_CURRENT,
																											BALANCE_PAST
																										FROM
																											(
																												SELECT
																													BALANCE_CURRENT,
																													BALANCE_PAST
																												FROM
																													(
																														SELECT
																															'1' AS MASK,
																															SUM (CR - DR) AS BALANCE_CURRENT
																														FROM
																															MASTER3D.GL
																														LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																														LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																														WHERE
																															GL.ACCOUNTID IN (
																																SELECT
																																	ACCOUNTID
																																FROM
																																	MASTER3D. ACCOUNT START WITH (
																																		MASTERID = 1170000000
																																		OR MASTERID = 1220000000
																																	) CONNECT BY PRIOR ACCOUNTID = MASTERID
																															)
																														AND GL.GLHEADSTATUS != 'V'
																														AND ACC.ACCOUNTSTATUS = 'Y'
																														AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																														AND (
																															gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																															AND {{ BUDGET_SORCE_END }}
																														)
																														AND (
																															gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																															AND {{ PLAN_SORCE_END }}
																														)
																														AND (
																															gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																															AND {{ PROJECT_SORCE_END }}
																														)
																														AND (
																															gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																															AND {{ ACTIVITY_SORCE_END }}
																														)
																														AND (
																															gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																															AND {{ FUND_SORCE_END }}
																														) {{ BUDGET_SQL }}
																													) TMP_CURRENT
																												FULL OUTER JOIN (
																													SELECT
																														'1' AS MASK,
																														SUM (CR - DR) AS BALANCE_PAST
																													FROM
																														MASTER3D.GL
																													LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																													LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																													WHERE
																														GL.ACCOUNTID IN (
																															SELECT
																																ACCOUNTID
																															FROM
																																MASTER3D. ACCOUNT START WITH (
																																	MASTERID = 1170000000
																																	OR MASTERID = 1220000000
																																) CONNECT BY PRIOR ACCOUNTID = MASTERID
																														)
																													AND GL.GLHEADSTATUS != 'V'
																													AND ACC.ACCOUNTSTATUS = 'Y'
																													AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																													AND (
																														gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																														AND {{ BUDGET_SORCE_END }}
																													)
																													AND (
																														gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																														AND {{ PLAN_SORCE_END }}
																													)
																													AND (
																														gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																														AND {{ PROJECT_SORCE_END }}
																													)
																													AND (
																														gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																														AND {{ ACTIVITY_SORCE_END }}
																													)
																													AND (
																														gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																														AND {{ FUND_SORCE_END }}
																													) {{ BUDGET_SQL }}
																												) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																											)
																										UNION ALL
																											SELECT
																												'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER1,
																												'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER2,
																												'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER3,
																												'เพิ่มขึ้น/ลดลงในที่ดิน' AS ACC_NAME,
																												BALANCE_CURRENT,
																												BALANCE_PAST
																											FROM
																												(
																													SELECT
																														BALANCE_CURRENT,
																														BALANCE_PAST
																													FROM
																														(
																															SELECT
																																'1' AS MASK,
																																SUM (CR - DR) AS BALANCE_CURRENT
																															FROM
																																MASTER3D.GL
																															LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																															LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																															WHERE
																																GL.ACCOUNTID IN (
																																	SELECT
																																		ACCOUNTID
																																	FROM
																																		MASTER3D. ACCOUNT START WITH MASTERID = 1230000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																)
																															AND GL.GLHEADSTATUS != 'V'
																															AND ACC.ACCOUNTSTATUS = 'Y'
																															AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																															AND (
																																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																AND {{ BUDGET_SORCE_END }}
																															)
																															AND (
																																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																AND {{ PLAN_SORCE_END }}
																															)
																															AND (
																																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																AND {{ PROJECT_SORCE_END }}
																															)
																															AND (
																																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																AND {{ ACTIVITY_SORCE_END }}
																															)
																															AND (
																																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																AND {{ FUND_SORCE_END }}
																															) {{ BUDGET_SQL }}
																														) TMP_CURRENT
																													FULL OUTER JOIN (
																														SELECT
																															'1' AS MASK,
																															SUM (CR - DR) AS BALANCE_PAST
																														FROM
																															MASTER3D.GL
																														LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																														LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																														WHERE
																															GL.ACCOUNTID IN (
																																SELECT
																																	ACCOUNTID
																																FROM
																																	MASTER3D. ACCOUNT START WITH MASTERID = 1230000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																															)
																														AND GL.GLHEADSTATUS != 'V'
																														AND ACC.ACCOUNTSTATUS = 'Y'
																														AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																														AND (
																															gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																															AND {{ BUDGET_SORCE_END }}
																														)
																														AND (
																															gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																															AND {{ PLAN_SORCE_END }}
																														)
																														AND (
																															gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																															AND {{ PROJECT_SORCE_END }}
																														)
																														AND (
																															gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																															AND {{ ACTIVITY_SORCE_END }}
																														)
																														AND (
																															gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																															AND {{ FUND_SORCE_END }}
																														) {{ BUDGET_SQL }}
																													) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																												)
																											UNION ALL
																												SELECT
																													'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER1,
																													'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER2,
																													'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER3,
																													'เพิ่มขึ้น/ลดลงในอาคารและสิ่งปลูกสร้าง' AS ACC_NAME,
																													BALANCE_CURRENT,
																													BALANCE_PAST
																												FROM
																													(
																														SELECT
																															BALANCE_CURRENT,
																															BALANCE_PAST
																														FROM
																															(
																																SELECT
																																	'1' AS MASK,
																																	(
																																		BALANCE_CURRENT - TOTAL_DEPRECIATE
																																	) AS BALANCE_CURRENT
																																FROM
																																	(
																																		SELECT
																																			SUM (CR - DR) AS BALANCE_CURRENT
																																		FROM
																																			MASTER3D.GL
																																		LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																		LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																		WHERE
																																			GL.ACCOUNTID IN (
																																				SELECT
																																					ACCOUNTID
																																				FROM
																																					MASTER3D. ACCOUNT START WITH MASTERID = 1240000000
																																				AND ACCOUNTID != 1240500000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																			)
																																		AND GL.GLHEADSTATUS != 'V'
																																		AND ACC.ACCOUNTSTATUS = 'Y'
																																		AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                
																																		AND (
																																			gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																			AND {{ BUDGET_SORCE_END }}
																																		)
																																		AND (
																																			gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																			AND {{ PLAN_SORCE_END }}
																																		)
																																		AND (
																																			gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																			AND {{ PROJECT_SORCE_END }}
																																		)
																																		AND (
																																			gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																			AND {{ ACTIVITY_SORCE_END }}
																																		)
																																		AND (
																																			gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																			AND {{ FUND_SORCE_END }}
																																		) {{ BUDGET_SQL }}
																																	)
																																CROSS JOIN (
																																	SELECT
																																		(
																																			BALANCE_CURRENT - BALANCE_PAST
																																		) AS TOTAL_DEPRECIATE
																																	FROM
																																		(
																																			SELECT
																																				BALANCE_CURRENT,
																																				BALANCE_PAST
																																			FROM
																																				(
																																					SELECT
																																						'1' AS MASK,
																																						SUM (DR - CR) AS BALANCE_CURRENT
																																					FROM
																																						MASTER3D.GL
																																					LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																					LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																					WHERE
																																						GL.ACCOUNTID IN (
																																							SELECT
																																								ACCOUNTID
																																							FROM
																																								MASTER3D. ACCOUNT START WITH (
																																									MASTERID = 5150101000
																																									OR MASTERID = 5150102000
																																									OR MASTERID = 5150103000
																																									OR MASTERID = 5150104000
																																								) CONNECT BY PRIOR ACCOUNTID = MASTERID
																																						)
																																					AND GL.GLHEADSTATUS != 'V'
																																					AND ACC.ACCOUNTSTATUS = 'Y'
																																					AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
																																					AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																					AND (
																																						gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																						AND {{ BUDGET_SORCE_END }}
																																					)
																																					AND (
																																						gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																						AND {{ PLAN_SORCE_END }}
																																					)
																																					AND (
																																						gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																						AND {{ PROJECT_SORCE_END }}
																																					)
																																					AND (
																																						gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																						AND {{ ACTIVITY_SORCE_END }}
																																					)
																																					AND (
																																						gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																						AND {{ FUND_SORCE_END }}
																																					) {{ BUDGET_SQL }}
																																				) TMP_CURRENT
																																			FULL OUTER JOIN (
																																				SELECT
																																					'1' AS MASK,
																																					SUM (DR - CR) AS BALANCE_PAST
																																				FROM
																																					MASTER3D.GL
																																				LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																				LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																				WHERE
																																					GL.ACCOUNTID IN (
																																						SELECT
																																							ACCOUNTID
																																						FROM
																																							MASTER3D. ACCOUNT START WITH (
																																								MASTERID = 5150101000
																																								OR MASTERID = 5150102000
																																								OR MASTERID = 5150103000
																																								OR MASTERID = 5150104000
																																							) CONNECT BY PRIOR ACCOUNTID = MASTERID
																																					)
																																				AND GL.GLHEADSTATUS != 'V'
																																				AND ACC.ACCOUNTSTATUS = 'Y'
																																				AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
																																				AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																				AND (
																																					gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																					AND {{ BUDGET_SORCE_END }}
																																				)
																																				AND (
																																					gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																					AND {{ PLAN_SORCE_END }}
																																				)
																																				AND (
																																					gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																					AND {{ PROJECT_SORCE_END }}
																																				)
																																				AND (
																																					gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																					AND {{ ACTIVITY_SORCE_END }}
																																				)
																																				AND (
																																					gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																					AND {{ FUND_SORCE_END }}
																																				) {{ BUDGET_SQL }}
																																			) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																																		)
																																)
																															) TMP_CURRENT
																														FULL OUTER JOIN (
																															SELECT
																																'1' AS MASK,
																																SUM (CR - DR) AS BALANCE_PAST
																															FROM
																																MASTER3D.GL
																															LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																															LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																															WHERE
																																GL.ACCOUNTID IN (
																																	SELECT
																																		ACCOUNTID
																																	FROM
																																		MASTER3D. ACCOUNT START WITH MASTERID = 1240000000
																																	AND ACCOUNTID != 1240500000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																)
																															AND GL.GLHEADSTATUS != 'V'
																															AND ACC.ACCOUNTSTATUS = 'Y'
																															AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																															AND (
																																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																AND {{ BUDGET_SORCE_END }}
																															)
																															AND (
																																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																AND {{ PLAN_SORCE_END }}
																															)
																															AND (
																																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																AND {{ PROJECT_SORCE_END }}
																															)
																															AND (
																																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																AND {{ ACTIVITY_SORCE_END }}
																															)
																															AND (
																																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																AND {{ FUND_SORCE_END }}
																															) {{ BUDGET_SQL }}
																														) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																													)
																												UNION ALL
																													SELECT
																														'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER1,
																														'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER2,
																														'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER3,
																														'เพิ่มขึ้น/ลดลงในครุภัณฑ์' AS ACC_NAME,
																														BALANCE_CURRENT,
																														BALANCE_PAST
																													FROM
																														(SELECT
                                                                                                                                                                                                                                                    'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER1,
                                                                                                                                                                                                                                                    'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER2,
                                                                                                                                                                                                                                                    'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER3,
                                                                                                                                                                                                                                                    'เพิ่มขึ้น/ลดลงในครุภัณฑ์' AS ACC_NAME,
                                                                                                                                                                                                                                                    BALANCE_CURRENT,
                                                                                                                                                                                                                                                    BALANCE_PAST
                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                    (
                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                                    BALANCE_CURRENT,
                                                                                                                                                                                                                                                                    BALANCE_PAST
                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                                    (
                                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                                                    '1' AS MASK,
                                                                                                                                                                                                                                                                                    (
                                                                                                                                                                                                                                                                                            BALANCE_CURRENT - TOTAL_DEPRECIATE
                                                                                                                                                                                                                                                                                    ) AS BALANCE_CURRENT
                                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                                                    (
                                                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                                                                    SUM (CR - DR) AS BALANCE_CURRENT
                                                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                                                                    MASTER3D.GL
                                                                                                                                                                                                                                                                                            LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
                                                                                                                                                                                                                                                                                            LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
                                                                                                                                                                                                                                                                                            WHERE
                                                                                                                                                                                                                                                                                                    GL.ACCOUNTID IN (
                                                                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                                                                                    ACCOUNTID
                                                                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                                                                                    MASTER3D. ACCOUNT START WITH (
                                                                                                                                                                                                                                                                                                                            MASTERID = 1250000000
                                                                                                                                                                                                                                                                                                                            OR MASTERID = 5210002000
                                                                                                                                                                                                                                                                                                                    ) CONNECT BY PRIOR ACCOUNTID = MASTERID
                                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                                            AND GL.GLHEADSTATUS != 'V'
                                                                                                                                                                                                                                                                                            AND ACC.ACCOUNTSTATUS = 'Y'
                                                                                                                                                                                                                                                                                            AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                            AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                                                                                                                                                                                                                                                                                             AND (
																																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																AND {{ BUDGET_SORCE_END }}
																															)
																															AND (
																																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																AND {{ PLAN_SORCE_END }}
																															)
																															AND (
																																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																AND {{ PROJECT_SORCE_END }}
																															)
																															AND (
																																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																AND {{ ACTIVITY_SORCE_END }}
																															)
																															AND (
																																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																AND {{ FUND_SORCE_END }}
																															) {{ BUDGET_SQL }}
                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                            CROSS JOIN (
                                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                                            (
                                                                                                                                                                                                                                                                                                    BALANCE_CURRENT - BALANCE_PAST
                                                                                                                                                                                                                                                                                            ) AS TOTAL_DEPRECIATE
                                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                                            (
                                                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                                                            BALANCE_CURRENT,
                                                                                                                                                                                                                                                                                                            BALANCE_PAST
                                                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                                                            (
                                                                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                                                                            '1' AS MASK,
                                                                                                                                                                                                                                                                                                                            SUM (DR - CR) AS BALANCE_CURRENT
                                                                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                                                                            MASTER3D.GL
                                                                                                                                                                                                                                                                                                                    LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
                                                                                                                                                                                                                                                                                                                    LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
                                                                                                                                                                                                                                                                                                                    WHERE
                                                                                                                                                                                                                                                                                                                            GL.ACCOUNTID IN (
                                                                                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                                                                                            ACCOUNTID
                                                                                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                                                                                            MASTER3D. ACCOUNT START WITH (MASTERID = 5150107000) CONNECT BY PRIOR ACCOUNTID = MASTERID
                                                                                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                                                                                    AND GL.GLHEADSTATUS != 'V'
                                                                                                                                                                                                                                                                                                                    AND ACC.ACCOUNTSTATUS = 'Y'
                                                                                                                                                                                                                                                                                                                    AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                                    AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                                    AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                                                                                                                                                                                                                                                                                                                    AND (
																																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																AND {{ BUDGET_SORCE_END }}
																															)
																															AND (
																																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																AND {{ PLAN_SORCE_END }}
																															)
																															AND (
																																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																AND {{ PROJECT_SORCE_END }}
																															)
																															AND (
																																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																AND {{ ACTIVITY_SORCE_END }}
																															)
																															AND (
																																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																AND {{ FUND_SORCE_END }}
																															) {{ BUDGET_SQL }}
                                                                                                                                                                                                                                                                                                            ) TMP_CURRENT
                                                                                                                                                                                                                                                                                                    FULL OUTER JOIN (
                                                                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                                                                                    '1' AS MASK,
                                                                                                                                                                                                                                                                                                                    SUM (DR - CR) AS BALANCE_PAST
                                                                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                                                                                    MASTER3D.GL
                                                                                                                                                                                                                                                                                                            LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
                                                                                                                                                                                                                                                                                                            LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
                                                                                                                                                                                                                                                                                                            WHERE
                                                                                                                                                                                                                                                                                                                    GL.ACCOUNTID IN (
                                                                                                                                                                                                                                                                                                                            SELECT
                                                                                                                                                                                                                                                                                                                                    ACCOUNTID
                                                                                                                                                                                                                                                                                                                            FROM
                                                                                                                                                                                                                                                                                                                                    MASTER3D. ACCOUNT START WITH (MASTERID = 5150107000) CONNECT BY PRIOR ACCOUNTID = MASTERID
                                                                                                                                                                                                                                                                                                                    )
                                                                                                                                                                                                                                                                                                            AND GL.GLHEADSTATUS != 'V'
                                                                                                                                                                                                                                                                                                            AND ACC.ACCOUNTSTATUS = 'Y'
                                                                                                                                                                                                                                                                                                            AND GLHEAD.GLHEADDATE >= TO_DATE ('{{DATE_FRIST}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                            AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                            AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                                                                                                                                                                                                                                                                                                            AND (
																																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																AND {{ BUDGET_SORCE_END }}
																															)
																															AND (
																																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																AND {{ PLAN_SORCE_END }}
																															)
																															AND (
																																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																AND {{ PROJECT_SORCE_END }}
																															)
																															AND (
																																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																AND {{ ACTIVITY_SORCE_END }}
																															)
																															AND (
																																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																AND {{ FUND_SORCE_END }}
																															) {{ BUDGET_SQL }}
                                                                                                                                                                                                                                                                                                    ) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
                                                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                                    ) TMP_CURRENT
                                                                                                                                                                                                                                                            FULL OUTER JOIN (
                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                            '1' AS MASK,
                                                                                                                                                                                                                                                                            SUM (CR) - SUM (DR) AS BALANCE_PAST
                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                            MASTER3D.GL
                                                                                                                                                                                                                                                                    LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
                                                                                                                                                                                                                                                                    LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
                                                                                                                                                                                                                                                                    WHERE
                                                                                                                                                                                                                                                                            GL.ACCOUNTID IN (
                                                                                                                                                                                                                                                                                    SELECT
                                                                                                                                                                                                                                                                                            ACCOUNTID
                                                                                                                                                                                                                                                                                    FROM
                                                                                                                                                                                                                                                                                            MASTER3D. ACCOUNT START WITH MASTERID = 1250000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
                                                                                                                                                                                                                                                                            )
                                                                                                                                                                                                                                                                    AND GL.GLHEADSTATUS != 'V'
                                                                                                                                                                                                                                                                    AND ACC.ACCOUNTSTATUS = 'Y'
                                                                                                                                                                                                                                                                    AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                    AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                                                                                                                                                                                                                                                                        AND (
																																gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																AND {{ BUDGET_SORCE_END }}
																															)
																															AND (
																																gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																AND {{ PLAN_SORCE_END }}
																															)
																															AND (
																																gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																AND {{ PROJECT_SORCE_END }}
																															)
																															AND (
																																gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																AND {{ ACTIVITY_SORCE_END }}
																															)
																															AND (
																																gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																AND {{ FUND_SORCE_END }}
																															) {{ BUDGET_SQL }}
                                                                                                                                                                                                                                                            ) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
                                                                                                                                                                                                                                                    ))
                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                        
																								/*------------------------------------------------------------------------------------------------------------*/						  
																													UNION ALL
																														SELECT
																															'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER1,
																															'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER2,
																															'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER3,
																															'เพิ่มขึ้น/ลดลงในโปรแกรมคอมพิวเตอร์' AS ACC_NAME,
																															BALANCE_CURRENT,
																															BALANCE_PAST
																														FROM
																															(
																																SELECT
																																	BALANCE_CURRENT,
																																	BALANCE_PAST
																																FROM
																																	(
																																		SELECT
																																			'1' AS MASK,
																																			SUM (CR - DR) AS BALANCE_CURRENT
																																		FROM
																																			MASTER3D.GL
																																		LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																		LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																		WHERE
																																			GL.ACCOUNTID IN (
																																				SELECT
																																					ACCOUNTID
																																				FROM
																																					MASTER3D. ACCOUNT START WITH MASTERID = 1270200000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																			)
																																		AND GL.GLHEADSTATUS != 'V'
																																		AND ACC.ACCOUNTSTATUS = 'Y'
																																		AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																		AND (
																																			gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																			AND {{ BUDGET_SORCE_END }}
																																		)
																																		AND (
																																			gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																			AND {{ PLAN_SORCE_END }}
																																		)
																																		AND (
																																			gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																			AND {{ PROJECT_SORCE_END }}
																																		)
																																		AND (
																																			gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																			AND {{ ACTIVITY_SORCE_END }}
																																		)
																																		AND (
																																			gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																			AND {{ FUND_SORCE_END }}
																																		) {{ BUDGET_SQL }}
																																	) TMP_CURRENT
																																FULL OUTER JOIN (
																																	SELECT
																																		'1' AS MASK,
																																		SUM (CR - DR) AS BALANCE_PAST
																																	FROM
																																		MASTER3D.GL
																																	LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																	LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																	WHERE
																																		GL.ACCOUNTID IN (
																																			SELECT
																																				ACCOUNTID
																																			FROM
																																				MASTER3D. ACCOUNT START WITH MASTERID = 1270200000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																		)
																																	AND GL.GLHEADSTATUS != 'V'
																																	AND ACC.ACCOUNTSTATUS = 'Y'
																																	AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																	AND (
																																		gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																		AND {{ BUDGET_SORCE_END }}
																																	)
																																	AND (
																																		gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																		AND {{ PLAN_SORCE_END }}
																																	)
																																	AND (
																																		gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																		AND {{ PROJECT_SORCE_END }}
																																	)
																																	AND (
																																		gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																		AND {{ ACTIVITY_SORCE_END }}
																																	)
																																	AND (
																																		gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																		AND {{ FUND_SORCE_END }}
																																	) {{ BUDGET_SQL }}
																																) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																															)
																														UNION ALL
																															SELECT
																																'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER1,
																																'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER2,
																																'กระแสเงินสดจากกิจกรรมลงทุน' AS HEADER3,
																																'เพิ่มขึ้น/ลดลงในงานระหว่างทำ' AS ACC_NAME,
																																BALANCE_CURRENT,
																																BALANCE_PAST
																															FROM
																																(
																																	SELECT
																																		BALANCE_CURRENT,
																																		BALANCE_PAST
																																	FROM
																																		(
																																			SELECT
																																				'1' AS MASK,
																																				SUM (CR - DR) AS BALANCE_CURRENT
																																			FROM
																																				MASTER3D.GL
																																			LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																			LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																			WHERE
																																				GL.ACCOUNTID IN (
																																					SELECT
																																						ACCOUNTID
																																					FROM
																																						MASTER3D. ACCOUNT START WITH (
																																							MASTERID = 1240500000
																																							OR MASTERID = 1270400000
																																						) CONNECT BY PRIOR ACCOUNTID = MASTERID
																																				)
																																			AND GL.GLHEADSTATUS != 'V'
																																			AND ACC.ACCOUNTSTATUS = 'Y'
																																			AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																			AND (
																																				gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																				AND {{ BUDGET_SORCE_END }}
																																			)
																																			AND (
																																				gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																				AND {{ PLAN_SORCE_END }}
																																			)
																																			AND (
																																				gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																				AND {{ PROJECT_SORCE_END }}
																																			)
																																			AND (
																																				gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																				AND {{ ACTIVITY_SORCE_END }}
																																			)
																																			AND (
																																				gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																				AND {{ FUND_SORCE_END }}
																																			) {{ BUDGET_SQL }}
																																		) TMP_CURRENT
																																	FULL OUTER JOIN (
																																		SELECT
																																			'1' AS MASK,
																																			SUM (CR - DR) AS BALANCE_PAST
																																		FROM
																																			MASTER3D.GL
																																		LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																		LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																		WHERE
																																			GL.ACCOUNTID IN (
																																				SELECT
																																					ACCOUNTID
																																				FROM
																																					MASTER3D. ACCOUNT START WITH (
																																						MASTERID = 1240500000
																																						OR MASTERID = 1270400000
																																					) CONNECT BY PRIOR ACCOUNTID = MASTERID
																																			)
																																		AND GL.GLHEADSTATUS != 'V'
																																		AND ACC.ACCOUNTSTATUS = 'Y'
																																		AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																		AND (
																																			gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																			AND {{ BUDGET_SORCE_END }}
																																		)
																																		AND (
																																			gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																			AND {{ PLAN_SORCE_END }}
																																		)
																																		AND (
																																			gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																			AND {{ PROJECT_SORCE_END }}
																																		)
																																		AND (
																																			gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																			AND {{ ACTIVITY_SORCE_END }}
																																		)
																																		AND (
																																			gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																			AND {{ FUND_SORCE_END }}
																																		) {{ BUDGET_SQL }}
																																	) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																																)
																															UNION ALL
																																SELECT
																																	'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER1,
																																	'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER2,
																																	'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER3,
																																	'เพิ่มขึ้น/ลดลงในเงินสำรองเงินคงคลัง' AS ACC_NAME,
																																	BALANCE_CURRENT,
																																	BALANCE_PAST
																																FROM
																																	(
																																		SELECT
																																			BALANCE_CURRENT,
																																			BALANCE_PAST
																																		FROM
																																			(
																																				SELECT
																																					'1' AS MASK,
																																					SUM (CR - DR) AS BALANCE_CURRENT
																																				FROM
																																					MASTER3D.GL
																																				LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																				LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																				WHERE
																																					GL.ACCOUNTID IN (
																																						SELECT
																																							ACCOUNTID
																																						FROM
																																							MASTER3D. ACCOUNT START WITH MASTERID = 3100009000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																					)
																																				AND GL.GLHEADSTATUS != 'V'
																																				AND ACC.ACCOUNTSTATUS = 'Y'
																																				AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																				AND (
																																					gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																					AND {{ BUDGET_SORCE_END }}
																																				)
																																				AND (
																																					gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																					AND {{ PLAN_SORCE_END }}
																																				)
																																				AND (
																																					gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																					AND {{ PROJECT_SORCE_END }}
																																				)
																																				AND (
																																					gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																					AND {{ ACTIVITY_SORCE_END }}
																																				)
																																				AND (
																																					gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																					AND {{ FUND_SORCE_END }}
																																				) {{ BUDGET_SQL }}
																																			) TMP_CURRENT
																																		FULL OUTER JOIN (
																																			SELECT
																																				'1' AS MASK,
																																				SUM (CR - DR) AS BALANCE_PAST
																																			FROM
																																				MASTER3D.GL
																																			LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																			LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																			WHERE
																																				GL.ACCOUNTID IN (
																																					SELECT
																																						ACCOUNTID
																																					FROM
																																						MASTER3D. ACCOUNT START WITH MASTERID = 3100009000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																				)
																																			AND GL.GLHEADSTATUS != 'V'
																																			AND ACC.ACCOUNTSTATUS = 'Y'
																																			AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																			AND (
																																				gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																				AND {{ BUDGET_SORCE_END }}
																																			)
																																			AND (
																																				gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																				AND {{ PLAN_SORCE_END }}
																																			)
																																			AND (
																																				gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																				AND {{ PROJECT_SORCE_END }}
																																			)
																																			AND (
																																				gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																				AND {{ ACTIVITY_SORCE_END }}
																																			)
																																			AND (
																																				gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																				AND {{ FUND_SORCE_END }}
																																			) {{ BUDGET_SQL }}
																																		) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																																	)
																																UNION ALL
																																	SELECT
																																		'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER1,
																																		'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER2,
																																		'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER3,
																																		'เพิ่มขึ้น/ลดลงในทุน' AS ACC_NAME,
																																		BALANCE_CURRENT,
																																		BALANCE_PAST
																																	FROM
																																		(
																																			SELECT
																																				BALANCE_CURRENT,
																																				BALANCE_PAST
																																			FROM
																																				(
																																					SELECT
																																						'1' AS MASK,
																																						SUM (CR - DR) AS BALANCE_CURRENT
																																					FROM
																																						MASTER3D.GL
																																					LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																					LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																					WHERE
																																						GL.ACCOUNTID IN (
																																							SELECT
																																								ACCOUNTID
																																							FROM
																																								MASTER3D. ACCOUNT START WITH MASTERID = 3100011000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																						)
																																					AND GL.GLHEADSTATUS != 'V'
																																					AND ACC.ACCOUNTSTATUS = 'Y'
																																					AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																					AND (
																																						gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																						AND {{ BUDGET_SORCE_END }}
																																					)
																																					AND (
																																						gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																						AND {{ PLAN_SORCE_END }}
																																					)
																																					AND (
																																						gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																						AND {{ PROJECT_SORCE_END }}
																																					)
																																					AND (
																																						gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																						AND {{ ACTIVITY_SORCE_END }}
																																					)
																																					AND (
																																						gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																						AND {{ FUND_SORCE_END }}
																																					) {{ BUDGET_SQL }}
																																				) TMP_CURRENT
																																			FULL OUTER JOIN (
																																				SELECT
																																					'1' AS MASK,
																																					SUM (CR - DR) AS BALANCE_PAST
																																				FROM
																																					MASTER3D.GL
																																				LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																				LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																				WHERE
																																					GL.ACCOUNTID IN (
																																						SELECT
																																							ACCOUNTID
																																						FROM
																																							MASTER3D. ACCOUNT START WITH MASTERID = 3100011000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																					)
																																				AND GL.GLHEADSTATUS != 'V'
																																				AND ACC.ACCOUNTSTATUS = 'Y'
																																				AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																				AND (
																																					gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																					AND {{ BUDGET_SORCE_END }}
																																				)
																																				AND (
																																					gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																					AND {{ PLAN_SORCE_END }}
																																				)
																																				AND (
																																					gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																					AND {{ PROJECT_SORCE_END }}
																																				)
																																				AND (
																																					gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																					AND {{ ACTIVITY_SORCE_END }}
																																				)
																																				AND (
																																					gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																					AND {{ FUND_SORCE_END }}
																																				) {{ BUDGET_SQL }}
																																			) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																																		)
																																	UNION ALL
																																		SELECT
																																			'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER1,
																																			'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER2,
																																			'กระแสเงินสดจากกิจกรรมจัดหาเงิน' AS HEADER3,
																																			'เพิ่มขึ้น/ลดลงในรายได้สูง(ต่ำ)กว่าค่าใช้จ่ายสะสม' AS ACC_NAME,
																																			BALANCE_CURRENT,
																																			BALANCE_PAST
																																		FROM
																																			(
																																				SELECT
																																					BALANCE_CURRENT,
																																					BALANCE_PAST
																																				FROM
																																					(
																																						SELECT
																																							'1' AS MASK,
																																							SUM (CR - DR) AS BALANCE_CURRENT
																																						FROM
																																							MASTER3D.GL
																																						LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																						LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																						WHERE
																																							GL.ACCOUNTID IN (
																																								SELECT
																																									ACCOUNTID
																																								FROM
																																									MASTER3D. ACCOUNT START WITH MASTERID = 3200000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																							)
																																						AND GL.GLHEADSTATUS != 'V'
																																						AND ACC.ACCOUNTSTATUS = 'Y'
																																						AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																						AND (
																																							gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																							AND {{ BUDGET_SORCE_END }}
																																						)
																																						AND (
																																							gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																							AND {{ PLAN_SORCE_END }}
																																						)
																																						AND (
																																							gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																							AND {{ PROJECT_SORCE_END }}
																																						)
																																						AND (
																																							gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																							AND {{ ACTIVITY_SORCE_END }}
																																						)
																																						AND (
																																							gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																							AND {{ FUND_SORCE_END }}
																																						) {{ BUDGET_SQL }}
																																					) TMP_CURRENT
																																				FULL OUTER JOIN (
																																					SELECT
																																						'1' AS MASK,
																																						SUM (CR - DR) AS BALANCE_PAST
																																					FROM
																																						MASTER3D.GL
																																					LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																					LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																					WHERE
																																						GL.ACCOUNTID IN (
																																							SELECT
																																								ACCOUNTID
																																							FROM
																																								MASTER3D. ACCOUNT START WITH MASTERID = 3200000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																						)
																																					AND GL.GLHEADSTATUS != 'V'
																																					AND ACC.ACCOUNTSTATUS = 'Y'
																																					AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																					AND (
																																						gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																						AND {{ BUDGET_SORCE_END }}
																																					)
																																					AND (
																																						gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																						AND {{ PLAN_SORCE_END }}
																																					)
																																					AND (
																																						gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																						AND {{ PROJECT_SORCE_END }}
																																					)
																																					AND (
																																						gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																						AND {{ ACTIVITY_SORCE_END }}
																																					)
																																					AND (
																																						gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																						AND {{ FUND_SORCE_END }}
																																					) {{ BUDGET_SQL }}
																																				) TMP_PAST ON TMP_PAST.MASK = TMP_CURRENT.MASK
																																			)
																																		UNION ALL
																																			SELECT
																																				'รวม' AS HEADER1,
																																				'รวม' AS HEADER2,
																																				'รวม' AS HEADER3,
																																				'เงินสดและรายการเทียบเท่าเงินสดคงเหลือ ณ วันต้นงวด' AS ACC_NAME,
																																				(DR - CR) AS BALANCE_CURRENT,
																																				0 AS BALANCE_PAST
																																			FROM
																																				(
																																					SELECT
																																						'1' AS MASK,
																																						SUM (DR) AS DR,
																																						SUM (CR) AS CR
																																					FROM
																																						MASTER3D.GL
																																					LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																					LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																					WHERE
																																						GL.ACCOUNTID IN (
																																							SELECT
																																								ACCOUNTID
																																							FROM
																																								MASTER3D. ACCOUNT START WITH MASTERID = 1110000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																						)
																																					AND GL.GLHEADSTATUS != 'V'
																																					AND ACC.ACCOUNTSTATUS = 'Y'
																																					AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_PREVIOUS}}', 'DD/MM/YYYY')
																																				)
																																			UNION ALL
																																				SELECT
																																					'รวม' AS HEADER1,
																																					'รวม' AS HEADER2,
																																					'รวม' AS HEADER3,
																																					'เงินสดและรายการเทียบเท่าเงินสดคงเหลือ ณ วันปลายงวด' AS ACC_NAME,
																																					(DR - CR) AS BALANCE_CURRENT,
																																					0 AS BALANCE_PAST
																																				FROM
																																					(
																																						SELECT
																																							'1' AS MASK,
																																							SUM (DR) AS DR,
																																							SUM (CR) AS CR
																																						FROM
																																							MASTER3D.GL
																																						LEFT OUTER JOIN MASTER3D.GLHEAD ON GLHEAD.GLHEADID = GL.GLHEADID
																																						LEFT OUTER JOIN MASTER3D. ACCOUNT ACC ON ACC.ACCOUNTID = GL.ACCOUNTID
																																						WHERE
																																							GL.ACCOUNTID IN (
																																								SELECT
																																									ACCOUNTID
																																								FROM
																																									MASTER3D. ACCOUNT START WITH MASTERID = 1110000000 CONNECT BY PRIOR ACCOUNTID = MASTERID
																																							)
																																						AND GL.GLHEADSTATUS != 'V'
																																						AND ACC.ACCOUNTSTATUS = 'Y'
																																						AND GLHEAD.GLHEADDATE <= TO_DATE ('{{DATE_END}}', 'DD/MM/YYYY')
                                                                                                                                                                                                                                                                                                                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
																																						AND (
																																							gl.BUDGETGROUPID BETWEEN {{ BUDGET_SORCE_START }}
																																							AND {{ BUDGET_SORCE_END }}
																																						)
																																						AND (
																																							gl.PLANID BETWEEN {{ PLAN_SORCE_START }}
																																							AND {{ PLAN_SORCE_END }}
																																						)
																																						AND (
																																							gl.PROJECTID BETWEEN {{ PROJECT_SORCE_START }}
																																							AND {{ PROJECT_SORCE_END }}
																																						)
																																						AND (
																																							gl.ACTIVITYID BETWEEN {{ ACTIVITY_SORCE_START }}
																																							AND {{ ACTIVITY_SORCE_END }}
																																						)
																																						AND (
																																							gl.FUNDGROUPID BETWEEN {{ FUND_SORCE_START }}
																																							AND {{ FUND_SORCE_END }}
																																						) {{ BUDGET_SQL }}
																																					)
	)