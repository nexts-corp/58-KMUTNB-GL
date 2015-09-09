package th.ac.kmutnb.gl.myreport.service;
import java.util.List;
import th.ac.kmutnb.gl.myreport.entity.Account;
import th.ac.kmutnb.gl.myreport.entity.Activity;
import th.ac.kmutnb.gl.myreport.entity.BudgetGroup;
import th.ac.kmutnb.gl.myreport.entity.Department;
import th.ac.kmutnb.gl.myreport.entity.FundGroup;
import th.ac.kmutnb.gl.myreport.entity.Plan;
import th.ac.kmutnb.gl.myreport.entity.Project;
import th.co.bpg.cde.annotation.CIOperation;
import th.co.bpg.cde.annotation.CIService;

@CIService(Uri = "/form")
public interface IFormService {
    
 
    @CIOperation(Uri = "/department",Authentication = true,ResourceCode ="*")
    public List<Department> department();
    
    @CIOperation(Uri = "/departmentDetail",Authentication = true,ResourceCode ="*")
    public List<Department> departmentDetail();
    
    @CIOperation(Uri = "/plan",Authentication = true,ResourceCode ="*")
    public List<Plan> plan();
    
    @CIOperation(Uri = "/project",Authentication = true,ResourceCode ="*")
    public List<Project> project();
    
    @CIOperation(Uri = "/fundGroup",Authentication = true,ResourceCode ="*")
    public List<FundGroup> fundGroup();
    
    @CIOperation(Uri = "/budgetGroup",Authentication = true,ResourceCode ="*")
    public List<BudgetGroup> budgetGroup();
    
    @CIOperation(Uri = "/activity",Authentication = true,ResourceCode ="*")
    public List<Activity> activity();
    
    @CIOperation(Uri = "/account",Authentication = true,ResourceCode ="*")
    public List<Account> account();
    
    @CIOperation(Uri = "/user",Authentication = true,ResourceCode ="*")
    public String user();
    
    @CIOperation(Uri = "/departmentCurrent",Authentication = true,ResourceCode ="*")
    public List<Department> departmentCurrent();
    
    
    
} 
