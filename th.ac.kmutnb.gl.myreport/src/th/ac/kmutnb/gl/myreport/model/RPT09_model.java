/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.model;

import java.math.BigDecimal;
import javax.persistence.Column;
import javax.persistence.Entity;

/**
 *
 * @author Panya
 */
@Entity
public class RPT09_model extends BaseReport {

    @Column
    String HEADER1 = "";
    @Column
    String HEADER2 = "";
    @Column
    String HEADER3 = "";
    @Column
    String ACC_NAME = "";
    @Column
    BigDecimal BALANCE_CURRENT = BigDecimal.ZERO;
    @Column
    BigDecimal BALANCE_PAST = BigDecimal.ZERO;

    public String getHEADER1() {
        return HEADER1;
    }

    public void setHEADER1(String HEADER1) {
        this.HEADER1 = HEADER1;
    }

    public String getHEADER2() {
        return HEADER2;
    }

    public void setHEADER2(String HEADER2) {
        this.HEADER2 = HEADER2;
    }

    public String getHEADER3() {
        return HEADER3;
    }

    public void setHEADER3(String HEADER3) {
        this.HEADER3 = HEADER3;
    }

    public String getACC_NAME() {
        return ACC_NAME;
    }

    public void setACC_NAME(String ACC_NAME) {
        this.ACC_NAME = ACC_NAME;
    }

    public BigDecimal getBALANCE_CURRENT() {
        return BALANCE_CURRENT;
    }

    public void setBALANCE_CURRENT(BigDecimal BALANCE_CURRENT) {
        this.BALANCE_CURRENT = BALANCE_CURRENT;
    }

    public BigDecimal getBALANCE_PAST() {
        return BALANCE_PAST;
    }

    public void setBALANCE_PAST(BigDecimal BALANCE_PAST) {
        this.BALANCE_PAST = BALANCE_PAST;
    }

    
    
    
}
