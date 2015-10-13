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
      /*maps.ACCOUNT_LEVEL,COALESCE(gl.DR_R, 0) AS DR_R,COALESCE(gl.CR_R, 0) AS CR_R,*/
  
      COALESCE(gl.DR_R, 0) AS DR_R,
      COALESCE(gl.CR_R, 0) AS CR_R,
      COALESCE(gl.DR_C, 0) AS DR,
      COALESCE(gl.CR_C, 0) AS CR
    FROM
  
  
    (
      SELECT
        CASE
          WHEN glr.ACCOUNTID IS NULL
          THEN glc.ACCOUNTID
          ELSE glr.ACCOUNTID
        END    AS ACCOUNTID,
        glr.DR AS DR_R,
        glr.CR AS CR_R,
        glc.DR AS DR_C,
        glc.CR AS CR_C
            
      FROM
      
        (
            SELECT gl.ACCOUNTID,
              SUM(DR) AS DR,
              SUM(CR) AS CR
            FROM MASTER3D.GL gl
            LEFT JOIN MASTER3D.GLHEAD glh
            ON gl.GLHEADID = glh.GLHEADID
            WHERE gl.accountid NOT IN (3200002000,3200003000)
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
          
            UNION
          
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


              )
        )glc
      
      
      
      FULL JOIN
      
      
        (
        
          SELECT ACCOUNTID,SUM(DR) AS DR,SUM(CR) AS CR
          FROM
            (
              /*--------------------พันยอดเฉพาะปี--------------------*/
            
                SELECT gl.ACCOUNTID,
                  SUM(DR) AS DR,
                  SUM(CR) AS CR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON gl.GLHEADID = glh.GLHEADID
                WHERE 
                gl.accountid NOT IN (3200002000,3200003000)
                AND
                gl.GLHEADSTATUS != 'V'
                AND
                  (
                        glh.GLHEADDATE >= TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY')
                        AND glh.GLHEADDATE < TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                  )
                
                AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                {{BUDGET_SQL}}


                GROUP BY gl.ACCOUNTID
              
              UNION
              
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
                      )
                    AND gl.GLHEADSTATUS != 'V'
                    AND 
                      (
                        glh.GLHEADDATE >= TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY')
                        AND glh.GLHEADDATE < TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                      )

                    AND (gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                    AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                    AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                    AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                    AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                    AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                    {{BUDGET_SQL}}


                )
            
            
            
            
            UNION
              
              
              /*--------------------พันยอดทั้งระบบ--------------------*/
              
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
                AND ( glh.GLHEADDATE < TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY') )

                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                {{BUDGET_SQL}}

              GROUP BY gl.ACCOUNTID
              
              UNION
              
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
                        OR gl.ACCOUNTID LIKE '4%'
                        OR gl.ACCOUNTID LIKE '5%'
                      )
                    AND gl.GLHEADSTATUS != 'V'
                    AND ( glh.GLHEADDATE < TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY') )

                    AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                    AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                    AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                    AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                    AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                    AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                    {{BUDGET_SQL}}
                )
                
                
                
            )
          GROUP BY ACCOUNTID
        
        )glr
        
      ON glr.ACCOUNTID = glc.ACCOUNTID
      ORDER BY ACCOUNTID
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
    ORDER BY maps.ACCOUNTID
  
  )
  
WHERE ( (DR_R-CR_R)!=0 OR CR!=0 OR DR!=0)
