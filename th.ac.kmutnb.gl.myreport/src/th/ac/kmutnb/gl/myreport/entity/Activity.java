package th.ac.kmutnb.gl.myreport.entity;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table
public class Activity implements Serializable {
    
    private static final long serialVersionUID = -3585331205894341679L;
    @Id
    @Column
    private Integer activityId;
    
    @Column
    private String activityName;
    
   

    public Integer getActivityId() {
        return activityId;
    }

    public void setActivityId(Integer activityId) {
        this.activityId = activityId;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName;
    }

    
    
}
