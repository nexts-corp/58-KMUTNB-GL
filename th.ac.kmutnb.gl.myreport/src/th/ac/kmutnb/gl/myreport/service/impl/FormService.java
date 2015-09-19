package th.ac.kmutnb.gl.myreport.service.impl;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import th.ac.kmutnb.gl.myreport.entity.Account;
import th.ac.kmutnb.gl.myreport.entity.Activity;
import th.ac.kmutnb.gl.myreport.entity.BudgetGroup;
import th.ac.kmutnb.gl.myreport.entity.Department;
import th.ac.kmutnb.gl.myreport.entity.FundGroup;
import th.ac.kmutnb.gl.myreport.entity.Plan;
import th.ac.kmutnb.gl.myreport.entity.Project;
import th.ac.kmutnb.gl.myreport.entity.Mgr;
import th.ac.kmutnb.gl.myreport.service.IFormService;
import th.co.bpg.cde.core.CServiceBase;
import th.co.bpg.cde.data.CDataContext;

public class FormService extends CServiceBase implements IFormService {

    private CDataContext dbcon;
    private String currentDepartment;

    public FormService() {
        this.dbcon = this.getDataContext();
        
        
    }

    private String readSQL(String sqlName) {
     
        StringBuilder sb = new StringBuilder();
        try (Scanner scanner = new Scanner(new FileInputStream(this.currentPaht+"/sql/" + sqlName + ".sql"), "UTF-8")) {
            while (scanner.hasNextLine()) {
                sb.append(scanner.nextLine());
                sb.append(" ");
            }
        } catch (FileNotFoundException ex) {
            Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return sb.toString();
    }

    /*@Override
     public List<Department> department() {
 
     Department dep = new Department();
     dep.setMasterId(0);
     String sql="select p from Department p  order by p.departmentId";
     List<Department> datas = (List<Department>) this.dbcon.getObjectBySQL(Department.class, sql,0,0);
        
     return datas;
        
     }*/
    /*@Override
     public String plan() {
 
     Plan query = new Plan();
     List<Plan> datas = (List<Plan>) this.dbcon.getObject(query);
        
     if(datas!=null){
     return "NotNull";
     }else{
     return "Null";
     }
        
     }*/
    @Override
    public List<Department> department() {

        String sql = "SELECT DEPARTMENTID AS departmentId,DEPARTMENTNAME AS departmentName "
                + " FROM MASTER3D.DEPARTMENT WHERE (MASTERID=0 OR MASTERID IS NULL ) ";
             
        if(!this.account.getDataDomain().equals("0")){
            sql+=" and (DEPARTMENTID="+this.account.getDataDomain().substring(0,3)+"00)";
        }
        sql+=" ORDER BY DEPARTMENTID";
        List<Department> datas = (List<Department>) this.dbcon.nativeQuery(Department.class, sql);

        return datas;

    }

    
    @Override
    public List<Department> departmentDetail() {
        String sql = "SELECT DEPARTMENTID AS departmentId,DEPARTMENTNAME AS departmentName,MASTERID AS masterId "
                + " FROM MASTER3D.DEPARTMENT   ";
        
        
        if(!this.account.getDataDomain().equals("0")){
            if(this.account.getDataDomain().substring(3).equals("00")){
                
               //sql+=" select  DEPARTMENTID AS departmentId,DEPARTMENTNAME AS departmentName,MASTERID AS masterId "
                //        + " FROM MASTER3D.DEPARTMENT ";
                sql+=" WHERE (MASTERID="+this.account.getDataDomain()+") "
                        + " or (DEPARTMENTID="+this.account.getDataDomain()+") ";
            }else{
                 sql+=" WHERE (DEPARTMENTID="+this.account.getDataDomain()+")  ";
            }
        }else{
            //sql+=" WHERE (MASTERID!=0 AND MASTERID IS NOT NULL) ";
        }
        sql+=" ORDER BY DEPARTMENTID";
        
        List<Department> datas = (List<Department>) this.dbcon.nativeQuery(Department.class, sql);
        return datas;
    }
    
    @Override
    public List<Plan> plan() {

        /*String sql = "SELECT PLANID AS planId,PLANNAME AS planName "
                + " FROM MASTER3D.PLAN "
               // + ""+this.getPlanCondition()+""
                + " ORDER BY planId";
        List<Plan> datas = (List<Plan>) this.dbcon.nativeQuery(Plan.class, sql);*/
        String sql = "SELECT PLANID AS planId,PLANNAME AS planName FROM MASTER3D.PLAN ORDER BY planId";
        List<Plan> datas = (List<Plan>) this.dbcon.nativeQuery(Plan.class, sql);

        return datas;
    }
    

    @Override
    public List<Project> project() {
        /*String depId=(String) this.request.getValue(String.class, "depId");
        if(!"".equals(depId)){
            this.currentDepartment=depId;
        }else{
          this.currentDepartment=this.account.getDataDomain();
        }
        String sql = "SELECT PROJECTID AS projectId,PROJECTNAME AS projectName "
                + " FROM MASTER3D.PROJECT "
                + ""+this.getProjectCondition()+""
                + " ORDER BY projectId";
        List<Project> datas = (List<Project>) this.dbcon.nativeQuery(Project.class, sql);*/
        
        String sql = "SELECT PROJECTID AS projectId,PROJECTNAME AS projectName FROM MASTER3D.PROJECT ORDER BY projectId";
        List<Project> datas = (List<Project>) this.dbcon.nativeQuery(Project.class, sql);


        return datas;
    }

    @Override
    public List<FundGroup> fundGroup() {
        
        String sql = "SELECT FUNDGROUPID AS fundGroupId,FUNDGROUPNAME AS fundGroupName "
                + " FROM MASTER3D.FUNDGROUP ORDER BY FUNDGROUPID";
        List<FundGroup> datas = (List<FundGroup>) this.dbcon.nativeQuery(FundGroup.class, sql);

        return datas;
    }

    @Override
    public List<Activity> activity() {
        /*String depId=(String) this.request.getValue(String.class, "depId");
        if(!"".equals(depId)){
            this.currentDepartment=depId;
           
        }else{
             this.currentDepartment=this.account.getDataDomain();
        }
        String sql = "SELECT ACTIVITYID AS activityId,ACTIVITYNAME AS activityName "
                + " FROM MASTER3D.ACTIVITY "
                +this.getActivityCondition()
                +" GROUP BY ACTIVITYNAME,ACTIVITYID ORDER BY ACTIVITYID";
        List<Activity> datas = (List<Activity>) this.dbcon.nativeQuery(Activity.class, sql);*/
        
        
        
        String sql = "SELECT ACTIVITYID AS activityId,ACTIVITYNAME AS activityName FROM MASTER3D.ACTIVITY GROUP BY ACTIVITYNAME,ACTIVITYID ORDER BY ACTIVITYID";
        List<Activity> datas = (List<Activity>) this.dbcon.nativeQuery(Activity.class, sql);

        return datas;
    }
    
    public String getActivityCondition(){
        String sql=" where ACTIVITYID in (SELECT ACTIVITYID FROM MASTER3D.GL gl ";
        if(!this.currentDepartment.equals("0")){
            if(this.currentDepartment.substring(3).equals("00")){
                sql+=" where DEPARTMENTID like '"+this.currentDepartment.substring(0,3)+"__'";
            }else{
                sql+=" where DEPARTMENTID="+this.currentDepartment+"";
            }
            sql+= " GROUP BY gl.ACTIVITYID )";
        }
        else{
            sql="";
        }
        
        return sql;
    }
    public String getProjectCondition(){
      // String sql = this.currentDepartment.equals("0") ? "" :" where ProjectId in(SELECT ProjectId  "
        //        + " FROM MASTER3D.ACTIVITY "+this.getActivityCondition() +")";
        
         String sql=" where ProjectId in (SELECT ProjectId FROM MASTER3D.GL gl ";
        if(!this.currentDepartment.equals("0")){
            if(this.currentDepartment.substring(3).equals("00")){
                sql+=" where DEPARTMENTID like '"+this.currentDepartment.substring(0,3)+"__'";
            }else{
                sql+=" where DEPARTMENTID="+this.currentDepartment+"";
            }
            sql+= " GROUP BY gl.ProjectId )";
        }
        else{
            sql="";
        }
        
        return sql;
    }
    
    public String getPlanCondition(){
       // String sql = this.currentDepartment.equals("0") ? "" : 
       //         " where planId in ( select planId  from  MASTER3D.PROJECT "+this.getProjectCondition()+")";
        
          String sql=" where planId in (SELECT planId FROM MASTER3D.GL gl ";
        if(!this.currentDepartment.equals("0")){
            if(this.currentDepartment.substring(3).equals("00")){
                sql+=" where DEPARTMENTID like '"+this.currentDepartment.substring(0,3)+"__'";
            }else{
                sql+=" where DEPARTMENTID="+this.currentDepartment+"";
            }
            sql+= " GROUP BY gl.planId )";
        }
        else{
            sql="";
        }
        
        return sql;
    }

    @Override
    public List<BudgetGroup> budgetGroup() {

        
        String sql = "SELECT BUDGETGROUPID AS budgetGroupId,BUDGETGROUPNAME AS budgetGroupName,BUDGETSOURCE  "
                + " FROM MASTER3D.BUDGETGROUP WHERE BUDGETGROUPSTATUS='Y' ORDER BY BUDGETGROUPID";
        List<BudgetGroup> datas = (List<BudgetGroup>) this.dbcon.nativeQuery(BudgetGroup.class, sql);

        return datas;
        
    }
    
    
    @Override
    public String user() {
        return this.account.getName();
    }
    
    
    @Override
    public List<Department> departmentCurrent() {
        String sql = "SELECT DEPARTMENTID AS departmentId , DEPARTMENTNAME AS departmentName FROM MASTER3D.DEPARTMENT WHERE DEPARTMENTID = "+this.account.getDataDomain();
        List<Department> datas = (List<Department>) this.dbcon.nativeQuery(Department.class, sql);

        return datas;
    }
    

    @Override
    public List<Account> account() {
        String sql = this.readSQL("account");
        List<Account> datas = (List<Account>) this.dbcon.nativeQuery(Account.class, sql);
        return datas;
    }
    
    @Override
    public List<Mgr> mgr() {
        
        String sql = this.readSQL("mgr");
        List<Mgr> datas = (List<Mgr>) this.dbcon.nativeQuery(Mgr.class, sql);

        return datas;
    }
    

}
