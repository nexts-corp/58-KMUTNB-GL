
SELECT * FROM
  (
    SELECT ROW_NUMBER() OVER (ORDER BY maps.M_ACCOUNT_ID) AS id,
      regexp_substr(maps.M_ACCOUNT_ID,'[^|]+', 1, 1) M_ACCOUNT_ID_1,
      regexp_substr(maps.M_ACCOUNT_NAME,'[^|]+', 1, 1) M_ACCOUNT_NAME_1,
      regexp_substr(maps.M_ACCOUNT_ID,'[^|]+', 1, 2) M_ACCOUNT_ID_2,
      regexp_substr(maps.M_ACCOUNT_NAME,'[^|]+', 1, 2) M_ACCOUNT_NAME_2,
      regexp_substr(maps.M_ACCOUNT_ID,'[^|]+', 1, 3) M_ACCOUNT_ID_3,
      regexp_substr(maps.M_ACCOUNT_NAME,'[^|]+', 1, 3) M_ACCOUNT_NAME_3,
      regexp_substr(maps.M_ACCOUNT_ID,'[^|]+', 1, 4) M_ACCOUNT_ID_4,
      regexp_substr(maps.M_ACCOUNT_NAME,'[^|]+', 1, 4) M_ACCOUNT_NAME_4,
      regexp_substr(maps.M_ACCOUNT_ID,'[^|]+', 1, 5) M_ACCOUNT_ID_5,
      regexp_substr(maps.M_ACCOUNT_NAME,'[^|]+', 1, 5) M_ACCOUNT_NAME_5,
      regexp_substr(maps.M_ACCOUNT_ID,'[^|]+', 1, 6) M_ACCOUNT_ID_6,
      regexp_substr(maps.M_ACCOUNT_NAME,'[^|]+', 1, 6) M_ACCOUNT_NAME_6,
      maps.ACCOUNTID   AS ACCOUNT_ID,
      maps.ACCOUNTNAME AS ACCOUNT_NAME,
  
      COALESCE(gl.DR_T, 0) AS DR_T,
      COALESCE(gl.CR_T, 0) AS CR_T,
      COALESCE(gl.DR_U, 0) AS DR_U,
      COALESCE(gl.CR_U, 0) AS CR_U,
      COALESCE(gl.DR_B, 0) AS DR_B,
      COALESCE(gl.CR_B, 0) AS CR_B
    FROM
  
  
    (
      SELECT
        glt.ACCOUNTID,
        glt.DR AS DR_T,
        glt.CR AS CR_T,
        glu.DR AS DR_U,
        glu.CR AS CR_U,
        glb.DR AS DR_B,
        glb.CR AS CR_B
      FROM
        (
        
        
          SELECT
            ACCOUNTID, 
            SUM(DR) AS DR,
            SUM(CR) AS CR
          FROM
            (
                SELECT gl.ACCOUNTID,
                  SUM(DR) AS DR,
                  SUM(CR) AS CR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON gl.GLHEADID = glh.GLHEADID
                WHERE 
                  (
                    gl.ACCOUNTID LIKE '1%'
                    OR gl.ACCOUNTID LIKE '2%'
                    OR
                      (
                        gl.ACCOUNTID LIKE '3%' 
                        AND gl.accountid NOT IN (3200002000,3200003000)
                      )
                  )

                AND gl.GLHEADSTATUS != 'V'

                AND glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')

                AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                {{BUDGET_SQL}}

                GROUP BY gl.ACCOUNTID
            
                UNION ALL
             
                SELECT 
                    3200003000 AS ACCOUNTID,DR,CR
                FROM
                    (
                        SELECT 
                          SUM(CR) AS CR,
                          SUM(DR) AS DR
                        FROM MASTER3D.GL gl
                        LEFT JOIN MASTER3D.GLHEAD glh
                        ON glh.GLHEADID = gl.GLHEADID
                        WHERE gl.ACCOUNTID IN (3200002000,3200003000)
                        
                        AND gl.GLHEADSTATUS != 'V'

                        AND glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                        AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')

                        AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                        AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                        AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                        AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                        AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                        AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                        {{BUDGET_SQL}}
                    )

                
              
                
                UNION ALL
              
                SELECT gl.ACCOUNTID,
                  SUM(DR) AS DR,
                  SUM(CR) AS CR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON gl.GLHEADID = glh.GLHEADID
                WHERE 
                  (
                    gl.ACCOUNTID LIKE '4%'
                    OR gl.ACCOUNTID LIKE '5%'
                  )
             
                AND gl.GLHEADSTATUS != 'V'
                AND 
                  (
                    glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                    AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')
                  )
                AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                {{BUDGET_SQL}}
                GROUP BY gl.ACCOUNTID
            )
          GROUP BY ACCOUNTID

        )glt
        
      LEFT JOIN 
      
        (

          SELECT
            ACCOUNTID, 
            SUM(DR) AS DR,
            SUM(CR) AS CR
          FROM
            (
             
                SELECT gl.ACCOUNTID,
                  SUM(DR) AS DR,
                  SUM(CR) AS CR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON gl.GLHEADID = glh.GLHEADID
                WHERE 
                  (
                    gl.ACCOUNTID LIKE '1%'
                    OR gl.ACCOUNTID LIKE '2%'
                    OR
                      (
                        gl.ACCOUNTID LIKE '3%' 
                        AND gl.accountid NOT IN (3200002000,3200003000)
                      )
                  )

                AND gl.GLHEADSTATUS != 'V'
                AND glh.DESCRIPTION2 LIKE '#99%'

                AND glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')

                AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                {{BUDGET_SQL}}
                    GROUP BY gl.ACCOUNTID
            
                UNION ALL
             
                SELECT 
                    3200003000 AS ACCOUNTID,DR,CR
                FROM
                    (
                        SELECT
                          SUM(CR) AS CR,
                          SUM(DR) AS DR
                        FROM MASTER3D.GL gl
                        LEFT JOIN MASTER3D.GLHEAD glh
                        ON glh.GLHEADID = gl.GLHEADID
                        WHERE gl.ACCOUNTID IN (3200002000,3200003000)

                        AND gl.GLHEADSTATUS != 'V'
                        AND glh.DESCRIPTION2 LIKE '#99%'
                        
                        AND glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                        AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')
                        
                        AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                        AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                        AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                        AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                        AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                        AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                        {{BUDGET_SQL}}
                    )

                
                UNION ALL
              
                SELECT gl.ACCOUNTID,
                  SUM(DR) AS DR,
                  SUM(CR) AS CR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON gl.GLHEADID = glh.GLHEADID
                WHERE 
                  (
                    gl.ACCOUNTID LIKE '4%'
                    OR gl.ACCOUNTID LIKE '5%'
                  )
             
                AND gl.GLHEADSTATUS != 'V'
                AND glh.DESCRIPTION2 LIKE '#99%'

                AND glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')
                 
                AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                {{BUDGET_SQL}}
                GROUP BY gl.ACCOUNTID
             
              
            )
          GROUP BY ACCOUNTID

        )glu
      ON glt.ACCOUNTID = glu.ACCOUNTID
        
      LEFT JOIN 
      
        (
          SELECT 
            3200003000 AS ACCOUNTID,DR,CR
          FROM
            (
                SELECT 
                  SUM(CR) AS CR,
                  SUM(DR) AS DR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON glh.GLHEADID = gl.GLHEADID
                WHERE 
                  (
                    gl.ACCOUNTID IN (3200002000,3200003000)
                    OR GL.ACCOUNTID LIKE '4%'
                    OR GL.ACCOUNTID LIKE '5%'
                  )
                AND gl.GLHEADSTATUS != 'V'
                AND glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')
                AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                {{BUDGET_SQL}}
              
            )
        )glb
      ON glt.ACCOUNTID = glb.ACCOUNTID



    )gl
    
    
    
    LEFT OUTER JOIN
      (
        SELECT ACCOUNTID,
          ACCOUNTNAME,
          LEVEL                                AS ACCOUNT_LEVEL ,
          SYS_CONNECT_BY_PATH(ACCOUNTID,'|')   AS M_ACCOUNT_ID ,
          SYS_CONNECT_BY_PATH(ACCOUNTNAME,'|') AS M_ACCOUNT_NAME
        FROM MASTER3D.ACCOUNT
        START WITH MASTERID        = '0'
        AND ACCOUNTSTATUS            = 'Y'
        CONNECT BY PRIOR ACCOUNTID = MASTERID
        ORDER SIBLINGS BY ACCOUNTID
      ) maps
    ON maps.ACCOUNTID = gl.ACCOUNTID
    WHERE ((gl.DR_T-gl.CR_T)!=0 OR (gl.DR_U-gl.CR_U)!=0 OR (gl.DR_B-gl.CR_B)!=0)
    ORDER BY maps.ACCOUNTID
  
  )