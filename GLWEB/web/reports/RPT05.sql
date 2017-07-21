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
  
      COALESCE(gl.DR, 0) AS DR,
      COALESCE(gl.CR, 0) AS CR
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

        {{& QUERYALLSYSTEM_SQL}} 
        AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')

        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
        AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
        AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
        AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
        AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
        AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
        {{& BUDGET_SQL}}
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
            WHERE 
              (
                gl.ACCOUNTID IN (3200002000,3200003000)
                OR GL.ACCOUNTID LIKE '4%'
                OR GL.ACCOUNTID LIKE '5%'
              )
            AND gl.GLHEADSTATUS != 'V'

            {{& QUERYALLSYSTEM_SQL}} 
            AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY') 

            AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
            AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
            AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
            AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
            AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
            AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
            {{& BUDGET_SQL}}
          )
      ) gl
  
    LEFT OUTER JOIN
      (
        SELECT * FROM
          (
            SELECT * FROM
              (
                SELECT 
                  SYS_CONNECT_BY_PATH(ACCOUNTID,'|')   AS M_ACCOUNT_ID ,
                  SYS_CONNECT_BY_PATH(ACCOUNTNAME,'|') AS M_ACCOUNT_NAME,
                  ACCOUNTID,ACCOUNTNAME
                FROM MASTER3D.ACCOUNT
                START WITH MASTERID        = '0'
                CONNECT BY PRIOR ACCOUNTID = MASTERID
                ORDER SIBLINGS BY ACCOUNTID
              )
            WHERE ACCOUNTID NOT LIKE '124%'
            AND ACCOUNTID NOT LIKE '125%'
            AND ACCOUNTID NOT LIKE '127%'
            AND ACCOUNTID NOT LIKE '6%'
          )
        UNION ALL  
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1240000000|1240100000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|อาคาร|อาคารและสิ่งปลูกสร้าง|',ACCOUNTNAME) AS M_ACCOUNT_NAME,ACCOUNTID AS ACCOUNTID, 
              ACCOUNTNAME AS ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID >= 1240100000
            AND MASTERID < 1240500000
            AND NATURETYPE = 'D'
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1240000000|1240199999|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|อาคาร|ค่าเสื่อมราคาสะสม - อาคารและสิ่งปลูกสร้าง|',ACCOUNTNAME) AS M_ACCOUNT_NAME, 
              ACCOUNTID AS ACCOUNTID, ACCOUNTNAME AS ACCOUNTNAME 
            FROM MASTER3D.ACCOUNT
            WHERE MASTERID >= 1240100000
            AND MASTERID < 1240500000
            AND NATURETYPE = 'C'
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1240000000|1240500000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|อาคาร|งานระหว่างก่อสร้าง|',ACCOUNTNAME) AS M_ACCOUNT_NAME, 
              ACCOUNTID AS ACCOUNTID, ACCOUNTNAME AS ACCOUNTNAME 
            FROM MASTER3D.ACCOUNT
            WHERE MASTERID = 1240500000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1250100000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|ครุภัณฑ์|',ACCOUNTNAME) AS M_ACCOUNT_NAME, 
              ACCOUNTID AS ACCOUNTID, ACCOUNTNAME AS ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID >= 1250100000
            AND MASTERID < 1251800000
            AND NATURETYPE = 'D'
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1250199999|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|ค่าเสื่อมราคาสะสม - ครุภัณฑ์|',ACCOUNTNAME) AS M_ACCOUNT_NAME, 
              ACCOUNTID AS ACCOUNTID, ACCOUNTNAME AS ACCOUNTNAME 
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID >= 1250100000
            AND MASTERID < 1251800000
            AND NATURETYPE = 'C'
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1251800000|',ACCOUNTID) AS M_ACCOUNT_ID,
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|ครุภัณฑ์จากการบริจาค|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID AS ACCOUNTID,
              ACCOUNTNAME AS ACCOUNTNAME
            FROM MASTER3D.ACCOUNT
            WHERE MASTERID >= 1251800000
            AND MASTERID < 1253500000
            AND ACCOUNTNAME NOT LIKE '%ค่าเสื่อม%'
          )
        UNION ALL
          (
            SELECT
              CONCAT('|1000000000|1200000000|1251899999|',ACCOUNTID) AS M_ACCOUNT_ID,
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|ค่าเสื่อมราคาสะสม - ครุภัณฑ์จากการบริจาค|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID AS ACCOUNTID,
              ACCOUNTNAME AS ACCOUNTNAME
            FROM MASTER3D.ACCOUNT
            WHERE MASTERID >= 1251800000
            AND MASTERID < 1253500000
            AND ACCOUNTNAME LIKE '%ค่าเสื่อม%'
            
          )
        UNION ALL
          (
            SELECT
              CONCAT('|1000000000|1200000000|1253500000|',ACCOUNTID) AS M_ACCOUNT_ID,
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|ครุภัณฑ์จากการบริจาครอรับรู้|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID AS ACCOUNTID,
              ACCOUNTNAME AS ACCOUNTNAME
            FROM MASTER3D.ACCOUNT WHERE MASTERID >= 1253500000 
            AND MASTERID < 1255000000
            AND ACCOUNTNAME NOT LIKE '%ค่าเสื่อม%'
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1253599999|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|ค่าเสื่อมราคาสะสม - ครุภัณฑ์จากการบริจาครอรับรู้|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID AS ACCOUNTID, ACCOUNTNAME AS ACCOUNTNAME 
            FROM MASTER3D.ACCOUNT WHERE MASTERID >= 1253500000
            AND MASTERID < 1255000000
            AND ACCOUNTNAME LIKE '%ค่าเสื่อม%' 
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1270000000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|โปรแกรมคอมพิวเตอร์ (ครุภัณฑ์)|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID AS ACCOUNTID, ACCOUNTNAME AS ACCOUNTNAME 
            FROM MASTER3D.ACCOUNT WHERE ACCOUNTID = 1270201000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|1000000000|1200000000|1279999999|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|สินทรัพย์|สินทรัพย์ไม่หมุนเวียน|ค่าตัดจำหน่ายสะสม - โปรแกรมคอมพิวเตอร์|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID AS ACCOUNTID, ACCOUNTNAME AS ACCOUNTNAME 
            FROM MASTER3D.ACCOUNT WHERE ACCOUNTID = 1270202000
          )
      ) maps
    ON maps.ACCOUNTID = gl.ACCOUNTID
    where maps.ACCOUNTNAME is not null
    ORDER BY maps.ACCOUNTID
  
  ) 
WHERE ((DR-CR)!=0)
ORDER BY M_ACCOUNT_ID_1,M_ACCOUNT_ID_2,M_ACCOUNT_ID_3,M_ACCOUNT_ID_4,M_ACCOUNT_ID_5,M_ACCOUNT_ID_6