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
public class RPT13_model extends BaseReport{
    @Column
    String RUNNINGNUMBER="";
    @Column
    String SEQUENCE="";
    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date GLHEADDATE;
    @Column
    String REFID1="";
    @Column
    String DESCRIPTION1="";
    @Column
    String RECEIVEFROM="";
    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date RECEIVEDATE;

    public String getRUNNINGNUMBER() {
        return RUNNINGNUMBER;
    }

    public void setRUNNINGNUMBER(String RUNNINGNUMBER) {
        this.RUNNINGNUMBER = RUNNINGNUMBER;
    }

    public String getSEQUENCE() {
        return SEQUENCE;
    }

    public void setSEQUENCE(String SEQUENCE) {
        this.SEQUENCE = SEQUENCE;
    }

    public Date getGLHEADDATE() {
        return GLHEADDATE;
    }

    public void setGLHEADDATE(Date GLHEADDATE) {
        this.GLHEADDATE = GLHEADDATE;
    }

    public String getREFID1() {
        return REFID1;
    }

    public void setREFID1(String REFID1) {
        this.REFID1 = REFID1;
    }

    public String getDESCRIPTION1() {
        return DESCRIPTION1;
    }

    public void setDESCRIPTION1(String DESCRIPTION1) {
        this.DESCRIPTION1 = DESCRIPTION1;
    }

    public String getRECEIVEFROM() {
        return RECEIVEFROM;
    }

    public void setRECEIVEFROM(String RECEIVEFROM) {
        this.RECEIVEFROM = RECEIVEFROM;
    }

    public Date getRECEIVEDATE() {
        return RECEIVEDATE;
    }

    public void setRECEIVEDATE(Date RECEIVEDATE) {
        this.RECEIVEDATE = RECEIVEDATE;
    }
    
    
}
