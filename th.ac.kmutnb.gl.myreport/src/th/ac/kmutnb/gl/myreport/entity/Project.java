package th.ac.kmutnb.gl.myreport.entity;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table
public class Project implements Serializable {
    
    private static final long serialVersionUID = 5276577188613767389L;
    @Id
    @Column
    private Integer projectId;
    
    @Column
    private String projectName;

    public Integer getProjectId() {
        return projectId;
    }

    public void setProjectId(Integer projectId) {
        this.projectId = projectId;
    }

    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }
    
    
}
