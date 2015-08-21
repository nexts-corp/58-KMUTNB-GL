/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "SYSUSER",schema = "MASTER3D")
public class User implements Serializable {

    private static final long serialVersionUID = 198564837346577031L;
    @Id
    @Column(name = "SYSUSERID")
    private Integer userId;
    @Column(name = "SYSUSERGROUPID")
    private Integer groupId;
    @Column(name = "FULLNAME")
    private String fullName;
    @Column(name = "DEPARTMENTID")
    private Integer departmentId;
    @Column(name = "STAFFID")
    private Integer staffId;
    @Column(name = "PWD")
    private String password;
    @Column(name = "EMAIL")
    private String email;
    @Column(name = "DBLOGIN")
    private String dblogin;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getDblogin() {
        return dblogin;
    }

    public void setDblogin(String dblogin) {
        this.dblogin = dblogin;
    }
    
    
    
}
