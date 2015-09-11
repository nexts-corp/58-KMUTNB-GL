package th.ac.kmutnb.gl.myreport.entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
public class Mgr implements Serializable {

    @Id
    private Integer id;
    
    @Column
    private Integer mgrCode;
    
    @Column
    private String mgrNameThai;
    
    @Column
    private String referName;
    
    @Column
    private Integer mgrDepartmentId;

    
    
    
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
    public Integer getMgrCode() {
        return mgrCode;
    }

    public void setMgrCode(Integer mgrCode) {
        this.mgrCode = mgrCode;
    }

    public String getMgrNameThai() {
        return mgrNameThai;
    }

    public void setMgrNameThai(String mgrNameThai) {
        this.mgrNameThai = mgrNameThai;
    }

    public String getReferName() {
        return referName;
    }

    public void setReferName(String referName) {
        this.referName = referName;
    }

    public Integer getMgrDepartmentId() {
        return mgrDepartmentId;
    }

    public void setMgrDepartmentId(Integer mgrDepartmentId) {
        this.mgrDepartmentId = mgrDepartmentId;
    }

    
    
    
    
    
}
