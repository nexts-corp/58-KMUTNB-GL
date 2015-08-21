/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.model;

import javax.persistence.Column;
import javax.persistence.Entity;

/**
 *
 * @author Panya
 */
@Entity
public class RPT08_model extends BaseReport {
    
    @Column
    String PLANID="";
    @Column
    String PLANNAME="";
    @Column
    String DEPARTMENTID= "";
    @Column
    String DEPARTMENTNAME= "";
    @Column
    String ACCOUNTID= "";
    @Column
    String ACCOUNTNAME= "";
   
    

    public String getPLANID() {
        return PLANID;
    }

    public void setPLANID(String PLANID) {
        this.PLANID = PLANID;
    }

    public String getPLANNAME() {
        return PLANNAME;
    }

    public void setPLANNAME(String PLANNAME) {
        this.PLANNAME = PLANNAME;
    }
    	
    public String getDEPARTMENTID() {
        return DEPARTMENTID;
    }

    public void setDEPARTMENTID(String DEPARTMENTID) {
        this.DEPARTMENTID = DEPARTMENTID;
    }

    public String getDEPARTMENTNAME() {
        return DEPARTMENTNAME;
    }

    public void setDEPARTMENTNAME(String DEPARTMENTNAME) {
        this.DEPARTMENTNAME = DEPARTMENTNAME;
    }

    public String getACCOUNTID() {
        return ACCOUNTID;
    }

    public void setACCOUNTID(String ACCOUNTID) {
        this.ACCOUNTID = ACCOUNTID;
    }

    public String getACCOUNTNAME() {
        return ACCOUNTNAME;
    }

    public void setACCOUNTNAME(String ACCOUNTNAME) {
        this.ACCOUNTNAME = ACCOUNTNAME;
    }

    
    
    
}
