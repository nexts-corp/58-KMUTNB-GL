package th.ac.kmutnb.gl.myreport.entity;
import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table
public class FundGroup implements Serializable {
    
    private static final long serialVersionUID = -2897758006089600256L;
    @Id
    @Column
    private Integer fundGroupId;
    
    @Column
    private String fundGroupName;

    public Integer getFundGroupId() {
        return fundGroupId;
    }

    public void setFundGroupId(Integer fundGroupId) {
        this.fundGroupId = fundGroupId;
    }

    public String getFundGroupName() {
        return fundGroupName;
    }

    public void setFundGroupName(String fundGroupName) {
        this.fundGroupName = fundGroupName;
    }

    
    
    
    
}
