package th.ac.kmutnb.gl.myreport.entity;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table
public class BudgetGroup implements Serializable {
    
    private static final long serialVersionUID = 1017284593558680698L;
    @Id
    @Column
    private Integer budgetGroupId;
    
    @Column
    private String budgetGroupName;
    
    @Column
    private String budgetSource;

    public Integer getBudgetGroupId() {
        return budgetGroupId;
    }

    public void setBudgetGroupId(Integer budgetGroupId) {
        this.budgetGroupId = budgetGroupId;
    }

    public String getBudgetGroupName() {
        return budgetGroupName;
    }

    public void setBudgetGroupName(String budgetGroupName) {
        this.budgetGroupName = budgetGroupName;
    }

    public String getBudgetSource() {
        return budgetSource;
    }

    public void setBudgetSource(String budgetSource) {
        this.budgetSource = budgetSource;
    }
    
    
    
    
}
