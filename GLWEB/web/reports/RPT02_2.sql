
SELECT ROW_NUMBER() OVER (ORDER BY ACCOUNTID,tx.DEPARTMENTID,GLHEADID) AS id,
  ACCOUNTID AS ACCOUNT_ID,
  ACCOUNTNAME AS ACCOUNT_NAME,
  GLHEADID,
  GLHEADDATE,
  DOCNUMBER,
  DESCRIPTION1,
  tx.DEPARTMENTID,
  dep.DEPARTMENTNAME,
  REFDOC,
  CHEQUEID,
  REFDATE2,
  CR,
  DR
FROM
  (
      SELECT
        acco.ACCOUNTID,
        acco.ACCOUNTNAME ,
        glall.GLHEADID,
        glall.GLHEADDATE,
        CONCAT(CONCAT(CONCAT(CONCAT(glall.PERIODID,'-'),glall.BOOKCODE),'/'),glall.SEQUENCE) AS DOCNUMBER,
        glall.DESCRIPTION1,
        glall.DEPARTMENTID,
        CONCAT(CONCAT(glall.LOTCODE,'-'),glall.REFID1) AS REFDOC,
        TO_CHAR(glall.CHEQUEID) AS CHEQUEID,
        glall.REFDATE2,
        glall.CR,
        glall.DR
      FROM MASTER3D.ACCOUNT acco
      INNER JOIN
        (


            SELECT 
              gl.ACCOUNTID,
              gl.GLHEADID,
              glh.GLHEADDATE,
              glh.PERIODID,
              glh.BOOKCODE,
              glh.SEQUENCE,
              glh.DESCRIPTION1,
              gl.DEPARTMENTID,
              gl.LOTCODE,
              glh.REFID1,
            CASE
              WHEN gl.LOTCODE='DN'
              THEN dnche.CHEQUEID
              WHEN gl.LOTCODE='PP'
              THEN ppche.CHEQUEID
              WHEN gl.LOTCODE='PM'
              THEN pmche.CHEQUEID
            END AS CHEQUEID,
            CASE
              WHEN gl.LOTCODE='DN'
              THEN pmdn.PAIDDATETIME
              WHEN gl.LOTCODE='PP'
              THEN pmpp.PAIDDATETIME
              WHEN gl.LOTCODE='PM'
              THEN pm.PAIDDATETIME
            END AS REFDATE2,
            gl.CR,
            gl.DR

            FROM MASTER3D.GL gl
            INNER JOIN MASTER3D.GLHEAD glh
            ON gl.GLHEADID = glh.GLHEADID


            LEFT JOIN MASTER3D.PAYMENT pm
            ON gl.GLHEADID = pm.GLHEADID
            LEFT JOIN (
              SELECT PAYMENTID,WM_CONCAT(DISTINCT CHEQUEID) AS CHEQUEID FROM MASTER3D.PAYMENTITEM
              WHERE CHEQUEID IS NOT NULL
              GROUP BY PAYMENTID
            )pmche
            ON pm.PAYMENTID = pmche.PAYMENTID


            LEFT JOIN MASTER3D.GL glpp
            ON gl.GLHEADID = glpp.REFGLHEADID
            AND glpp.LOTCODE = 'PM'
            LEFT JOIN MASTER3D.PAYMENT pmpp
            ON glpp.GLHEADID = pmpp.GLHEADID
            LEFT JOIN (
              SELECT PAYMENTID,WM_CONCAT(DISTINCT CHEQUEID) AS CHEQUEID FROM MASTER3D.PAYMENTITEM
              WHERE CHEQUEID IS NOT NULL
              GROUP BY PAYMENTID
            )ppche
            ON pmpp.PAYMENTID = ppche.PAYMENTID



            LEFT JOIN MASTER3D.GL glppdn
            ON gl.GLHEADID = glppdn.REFGLHEADID
            AND gl.LOTCODE = 'DN'
            LEFT JOIN MASTER3D.GL gldn
            ON glppdn.GLHEADID = gldn.REFGLHEADID
            AND gldn.LOTCODE = 'PM'
            LEFT JOIN MASTER3D.PAYMENT pmdn
            ON gldn.GLHEADID = pmdn.GLHEADID
            LEFT JOIN (
              SELECT PAYMENTID,WM_CONCAT(DISTINCT CHEQUEID) AS CHEQUEID FROM MASTER3D.PAYMENTITEM
              WHERE CHEQUEID IS NOT NULL
              GROUP BY PAYMENTID
            )dnche
            ON pmdn.PAYMENTID = dnche.PAYMENTID


            WHERE gl.GLHEADSTATUS != 'V'
            AND glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
            AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')
            
            AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
            AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
            AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
            AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
            AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
            AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
            AND ( gl.ACCOUNTID BETWEEN {{ACCOUNT_START}} AND {{ACCOUNT_END}} )
            {{BUDGET_SQL}}

        )glall ON acco.ACCOUNTID = glall.ACCOUNTID







      UNION ALL



      SELECT aid.ACCOUNTID,
        aid.ACCOUNTNAME AS ACCOUNTNAME,
        GLHEADID,
        GLHEADDATE,
        DOCNUMBER,
        DESCRIPTION1,
        DEPARTMENTID,
        REFDOC ,
        CHEQUEID,
        REFDATE2,
        CR,
        DR
      FROM
        (
          SELECT ACCOUNTID,
          ''                                    AS ACCOUNTNAME,
          000000                                AS GLHEADID,
          TO_DATE('{{DATE_START}}', 'DD/MM/YYYY') AS GLHEADDATE,
          ''                                    AS DOCNUMBER,
          'ยอดยกมา'                             AS DESCRIPTION1,
          DEPARTMENTID,
          ''                                    AS REFDOC,
          ''                                    AS CHEQUEID,
          TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')   AS REFDATE2,
          CR,
          DR
        FROM
          (

            SELECT ACCOUNTID,DEPARTMENTID,
              SUM(DR) AS DR,
              SUM(CR) AS CR
            FROM
              (
              /*--------------------พันยอดเฉพาะปี--------------------*/
                SELECT gl.ACCOUNTID,gl.DEPARTMENTID,
                  SUM(DR) AS DR,
                  SUM(CR) AS CR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON gl.GLHEADID = glh.GLHEADID
                WHERE

                gl.GLHEADSTATUS != 'V'
                AND ( glh.GLHEADDATE >= TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY')
                AND glh.GLHEADDATE    < TO_DATE('{{DATE_START}}', 'DD/MM/YYYY') )
                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                AND ( gl.ACCOUNTID BETWEEN {{ACCOUNT_START}} AND {{ACCOUNT_END}} )
                {{BUDGET_SQL}}

                GROUP BY gl.ACCOUNTID,gl.DEPARTMENTID


                UNION ALL

                /*--------------------พันยอดทั้งระบบ--------------------*/
                SELECT gl.ACCOUNTID,gl.DEPARTMENTID,
                  SUM(DR) AS DR,
                  SUM(CR) AS CR
                FROM MASTER3D.GL gl
                LEFT JOIN MASTER3D.GLHEAD glh
                ON gl.GLHEADID = glh.GLHEADID
                WHERE ( gl.ACCOUNTID LIKE '1%'
                OR gl.ACCOUNTID LIKE '2%'
                OR ( gl.ACCOUNTID LIKE '3%'
                AND gl.accountid NOT IN (3200002000,3200003000) ) )
                AND gl.GLHEADSTATUS != 'V'
                AND ( glh.GLHEADDATE  < TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY') )
                AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                AND ( gl.ACCOUNTID BETWEEN {{ACCOUNT_START}} AND {{ACCOUNT_END}} )
                {{BUDGET_SQL}}

                GROUP BY gl.ACCOUNTID,gl.DEPARTMENTID

                UNION ALL

                SELECT 3200003000 AS ACCOUNTID,
                  DEPARTMENTID,DR,CR
                FROM
                  (
                    SELECT
                      gl.DEPARTMENTID,
                      SUM(CR) AS CR,
                      SUM(DR)       AS DR
                    FROM MASTER3D.GL gl
                    LEFT JOIN MASTER3D.GLHEAD glh
                    ON glh.GLHEADID       = gl.GLHEADID
                    WHERE ( gl.ACCOUNTID IN (3200002000,3200003000)
                    OR gl.ACCOUNTID LIKE '4%'
                    OR gl.ACCOUNTID LIKE '5%' )
                    AND gl.GLHEADSTATUS != 'V'

                    AND ( glh.GLHEADDATE  < TO_DATE('{{DATE_FRIST}}', 'DD/MM/YYYY') )
                    AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
                    AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
                    AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
                    AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
                    AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
                    AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
                    {{BUDGET_SQL}}

                    GROUP BY gl.DEPARTMENTID
                  )

              )
              GROUP BY ACCOUNTID,DEPARTMENTID

          ) bid
        )tb
       INNER JOIN MASTER3D.ACCOUNT aid
       ON aid.ACCOUNTID = tb.ACCOUNTID

  )tx
  INNER JOIN MASTER3D.DEPARTMENT dep
  ON tx.DEPARTMENTID = dep.DEPARTMENTID
  WHERE ((DR-CR)!=0)
AND ( ACCOUNTID BETWEEN {{ACCOUNT_START}} AND {{ACCOUNT_END}} )
  ORDER BY ACCOUNTID,tx.DEPARTMENTID,GLHEADDATE,GLHEADID