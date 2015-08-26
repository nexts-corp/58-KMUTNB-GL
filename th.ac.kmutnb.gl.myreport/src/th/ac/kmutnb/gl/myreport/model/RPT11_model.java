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
public class RPT11_model extends BaseReport {

    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date GLHEADDATE;
    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date RECEIVEDATE;
    @Column
    String DESCRIPTION = "";
    @Column
    String CHEQUEID = "";
    @Column
    @Temporal(javax.persistence.TemporalType.DATE)
    Date CHEQUEDATE;
    @Column
    String CHEQBRANCHBANK = "";
    @Column
    String REFID1 = "";
    @Column
    String RECEIVEFEENAME = "";
    @Column
    String RECEIPT_NO = "";
    @Column
    String RECEIPT_BOOKNO = "";
    @Column
    BigDecimal AMOUNT = BigDecimal.ZERO;

    public Date getGLHEADDATE() {
        return GLHEADDATE;
    }

    public void setGLHEADDATE(Date GLHEADDATE) {
        this.GLHEADDATE = GLHEADDATE;
    }

    public Date getRECEIVEDATE() {
        return RECEIVEDATE;
    }

    public void setRECEIVEDATE(Date RECEIVEDATE) {
        this.RECEIVEDATE = RECEIVEDATE;
    }

    public String getDESCRIPTION() {
        return DESCRIPTION;
    }

    public void setDESCRIPTION(String DESCRIPTION) {
        this.DESCRIPTION = DESCRIPTION;
    }

    public String getCHEQUEID() {
        return CHEQUEID;
    }

    public void setCHEQUEID(String CHEQUEID) {
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

    public String getRECEIVEFEENAME() {
        return RECEIVEFEENAME;
    }

    public void setRECEIVEFEENAME(String RECEIVEFEENAME) {
        this.RECEIVEFEENAME = RECEIVEFEENAME;
    }

    public String getRECEIPT_NO() {
        return RECEIPT_NO;
    }

    public void setRECEIPT_NO(String RECEIPT_NO) {
        this.RECEIPT_NO = RECEIPT_NO;
    }

    public String getRECEIPT_BOOKNO() {
        return RECEIPT_BOOKNO;
    }

    public void setRECEIPT_BOOKNO(String RECEIPT_BOOKNO) {
        this.RECEIPT_BOOKNO = RECEIPT_BOOKNO;
    }

    public BigDecimal getAMOUNT() {
        return AMOUNT;
    }

    public void setAMOUNT(BigDecimal AMOUNT) {
        this.AMOUNT = AMOUNT;
    }
}
