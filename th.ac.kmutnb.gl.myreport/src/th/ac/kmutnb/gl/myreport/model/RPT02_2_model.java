/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.model;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Temporal;

/**
 *
 * @author Panya
 */
@Entity
public class RPT02_2_model extends  BaseReport{
    
 
    @Column
    String GLHEADID=" ";
    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date GLHEADDATE;
    @Column
    String DOCNUMBER="";
    @Column
    String DESCRIPTION1="";
    @Column
    String DEPARTMENTID="";
    @Column
    String DEPARTMENTNAME="";
    @Column
    String REFDOC="";
    @Column
    String CHEQUEID="";
    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date REFDATE2;

    public String getDEPARTMENTNAME() {
        return DEPARTMENTNAME;
    }

    public void setDEPARTMENTNAME(String DEPARTMENTNAME) {
        this.DEPARTMENTNAME = DEPARTMENTNAME;
    }

    public String getGLHEADID() {
        return GLHEADID;
    }

    public void setGLHEADID(String GLHEADID) {
        this.GLHEADID = GLHEADID;
    }

    public Date getGLHEADDATE() {
        return GLHEADDATE;
    }

    public void setGLHEADDATE(Date GLHEADDATE) {
        this.GLHEADDATE = GLHEADDATE;
    }

    
   


    public String getDOCNUMBER() {
        return DOCNUMBER;
    }

    public void setDOCNUMBER(String DOCNUMBER) {
        this.DOCNUMBER = DOCNUMBER;
    }

    public String getDESCRIPTION1() {
        return DESCRIPTION1;
    }

    public void setDESCRIPTION1(String DESCRIPTION1) {
        this.DESCRIPTION1 = DESCRIPTION1;
    }

    public String getDEPARTMENTID() {
        return DEPARTMENTID;
    }

    public void setDEPARTMENTID(String DEPARTMENTID) {
        this.DEPARTMENTID = DEPARTMENTID;
    }

    public String getREFDOC() {
        return REFDOC;
    }

    public void setREFDOC(String REFDOC) {
        this.REFDOC = REFDOC;
    }

    public String getCHEQUEID() {
        return CHEQUEID;
    }

    public void setCHEQUEID(String CHEQUEID) {
        this.CHEQUEID = CHEQUEID;
    }

    public Date getREFDATE2() {
        return REFDATE2;
    }

    public void setREFDATE2(Date REFDATE2) {
        this.REFDATE2 = REFDATE2;
    }

    

    
}
