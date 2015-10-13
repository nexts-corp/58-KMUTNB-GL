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
        SELECT ACCOUNTID,SUM(DR) AS DR,SUM(CR) AS CR
        FROM MASTER3D.GL gl
        LEFT JOIN MASTER3D.GLHEAD glh
        ON glh.GLHEADID = gl.GLHEADID
        WHERE 
          (
            GL.ACCOUNTID LIKE '4%'
            OR GL.ACCOUNTID LIKE '5%'
          )
        AND gl.GLHEADSTATUS != 'V'
        AND 
            ( 
                glh.GLHEADDATE >= TO_DATE('{{DATE_START}}', 'DD/MM/YYYY')
                AND glh.GLHEADDATE <= TO_DATE('{{DATE_END}}', 'DD/MM/YYYY')
            )

        AND ( gl.DEPARTMENTID BETWEEN {{DEPARTMENT_SORCE_START}} AND {{DEPARTMENT_SORCE_END}} )
        AND (gl.BUDGETGROUPID BETWEEN {{BUDGET_SORCE_START}} AND {{BUDGET_SORCE_END}} )
        AND (gl.PLANID BETWEEN {{PLAN_SORCE_START}} AND {{PLAN_SORCE_END}} )
        AND (gl.PROJECTID BETWEEN {{PROJECT_SORCE_START}} AND {{PROJECT_SORCE_END}} )
        AND (gl.ACTIVITYID BETWEEN {{ACTIVITY_SORCE_START}} AND {{ACTIVITY_SORCE_END}} )
        AND (gl.FUNDGROUPID BETWEEN {{FUND_SORCE_START}} AND {{FUND_SORCE_END}} )
        {{& BUDGET_SQL}}


        GROUP BY ACCOUNTID
      ) gl
  
    LEFT OUTER JOIN
      (
        SELECT M_ACCOUNT_ID,M_ACCOUNT_NAME,ACCOUNTID,ACCOUNTNAME FROM
          (
            SELECT * FROM
              (
                SELECT 
                  SYS_CONNECT_BY_PATH(ACCOUNTID,'|')   AS M_ACCOUNT_ID ,
                  SYS_CONNECT_BY_PATH(ACCOUNTNAME,'|') AS M_ACCOUNT_NAME,
                  ACCOUNTID,ACCOUNTNAME,MASTERID
                FROM MASTER3D.ACCOUNT
                START WITH MASTERID        = '0'
                CONNECT BY PRIOR ACCOUNTID = MASTERID
                ORDER SIBLINGS BY ACCOUNTID
              )
            WHERE (ACCOUNTID LIKE '4%'
            OR ACCOUNTID LIKE '5%')
            AND MASTERID != 4190700000
            AND MASTERID != 4190400000
            AND MASTERID != 4190103000
            AND MASTERID != 4190800000
            AND MASTERID != 4190900000
            AND MASTERID != 4191000000 
            AND (ACCOUNTID NOT BETWEEN 5150101000 AND 5150105000)
            
          )
        UNION ALL 
          (  
            SELECT 
              CONCAT('|4000000000|4100000000|4190000000|4195100000|4190700000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|รายได้|รายได้จากการดำเนินงาน|รายได้จากการดำเนินงานของสถาบัน|รายได้จากการบริหารโครงการเฉพาะกิจ|รายได้จากการบริหารงานโครงการเฉพาะกิจ|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID, 
              ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID = 4190700000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|4000000000|4100000000|4190000000|4195200000|4190400000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|รายได้|รายได้จากการดำเนินงาน|รายได้จากการดำเนินงานของสถาบัน|รายได้จากการอุดหนุนและเงินบริจาค|รายได้จากการรับบริจาค|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID, 
              ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID = 4190400000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|4000000000|4100000000|4190000000|4195300000|4190103000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|รายได้|รายได้จากการดำเนินงาน|รายได้จากการดำเนินงานของสถาบัน|รายได้อื่น|รายได้ค่าธรรมเนียมเมื่อจบการศึกษา|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID, 
              ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID = 4190103000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|4000000000|4100000000|4190000000|4195300000|4190800000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|รายได้|รายได้จากการดำเนินงาน|รายได้จากการดำเนินงานของสถาบัน|รายได้อื่น|รายได้ดอกเบี้ยรับและรายได้จากการลงทุน|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID, 
              ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID = 4190800000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|4000000000|4100000000|4190000000|4195300000|4190900000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|รายได้|รายได้จากการดำเนินงาน|รายได้จากการดำเนินงานของสถาบัน|รายได้อื่น|รายได้เบ็ดเตล็ด|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID, 
              ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID = 4190900000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|4000000000|4100000000|4190000000|4195300000|4191000000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|รายได้|รายได้จากการดำเนินงาน|รายได้จากการดำเนินงานของสถาบัน|รายได้อื่น|เงินค่าปรับจากการผิดสัญญา|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID, 
              ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID = 4191000000
          )
        UNION ALL
          (
            SELECT 
              CONCAT('|5000000000|5100000000|5150000000|5150100000|5150101000|',ACCOUNTID) AS M_ACCOUNT_ID, 
              CONCAT('|ค่าใช้จ่าย|ค่าใช้จ่ายจากการดำเนินงาน|ค่าเสื่อมราคาและค่าตัดจำหน่าย|ค่าเสื่อมราคา|ค่าเสื่อมราคา - อาคารและสิ่งปลูกสร้าง|',ACCOUNTNAME) AS M_ACCOUNT_NAME,
              ACCOUNTID, 
              ACCOUNTNAME
            FROM MASTER3D.ACCOUNT 
            WHERE MASTERID BETWEEN 5150101000 AND 5150104000
          )
      ) maps
    ON maps.ACCOUNTID = gl.ACCOUNTID
    ORDER BY maps.ACCOUNTID
  
  ) 
WHERE ( (DR-CR)!=0)
ORDER BY M_ACCOUNT_ID_1,M_ACCOUNT_ID_2,M_ACCOUNT_ID_3,M_ACCOUNT_ID_4,M_ACCOUNT_ID_5,M_ACCOUNT_ID_6