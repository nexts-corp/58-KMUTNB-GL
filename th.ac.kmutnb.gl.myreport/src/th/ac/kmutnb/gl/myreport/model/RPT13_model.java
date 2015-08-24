/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.model;

import java.math.BigDecimal;
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
    @Temporal(javax.persistence.TemporalType.DATE)
    Date GLHEADDATE;
    @Column
    String RECEIVEFROM=" ";
    @Column
    String DESCRIPTION=" ";
    @Column
    String CHEQUEID=" ";
    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date CHEQUEDATE;
    @Column
    String CHEQBRANCHBANK=" ";
    @Column
    String REFID1=" ";
    @Column
    String RECEIVEITEM=" ";
    @Column
    BigDecimal AMOUNT = BigDecimal.ZERO;

    public Date getGLHEADDATE() {
        return GLHEADDATE;
    }

    public void setGLHEADDATE(Date GLHEADDATE) {
        this.GLHEADDATE = GLHEADDATE;
    }

    public String getRECEIVEFROM() {
        return RECEIVEFROM;
    }

    public void setRECEIVEFROM(String RECEIVEFROM) {
        this.RECEIVEFROM = RECEIVEFROM;
    }

    public String getDESCRIPTION() {
        return DESCRIPTION;
    }

    public void setDESCRIPTION(String DESCRIPTION) {
        this.DESCRIPTION = DESCRIPTION;
    }

    public String getCHEQUEI() {
        return CHEQUEID;
    }

    public void setCHEQUEI(String CHEQUEID) {
        this.CHEQUEID = CHEQUEID;
    }

    public Date getCHEQUEDATE() {
        return CHEQUEDATE;
    }

    public void setCHEQUEDATE(Date CHEQUEDATE) {
        this.CHEQUEDATE = CHEQUEDATE;
    }

    public String getCHEQBRANCHBANK() {
        return CHEQBRANCHBANK;
    }

    public void setCHEQBRANCHBANK(String CHEQBRANCHBANK) {
        this.CHEQBRANCHBANK = CHEQBRANCHBANK;
    }

    public String getREFID1() {
        return REFID1;
    }

    public void setREFID1(String REFID1) {
        this.REFID1 = REFID1;
    }

    public String getRECEIVEITEM() {
        return RECEIVEITEM;
    }

    public void setRECEIVEITEM(String RECEIVEITEM) {
        this.RECEIVEITEM = RECEIVEITEM;
    }

    public BigDecimal getAMOUNT() {
        return AMOUNT;
    }

    public void setAMOUNT(BigDecimal AMOUNT) {
        this.AMOUNT = AMOUNT;
    }

    
    
}
