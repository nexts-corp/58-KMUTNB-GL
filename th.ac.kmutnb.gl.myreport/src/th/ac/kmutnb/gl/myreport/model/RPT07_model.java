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
public class RPT07_model extends BaseReport{
    
    @Column
    BigDecimal DR_T=BigDecimal.ZERO;
    @Column
    BigDecimal CR_T=BigDecimal.ZERO;
    @Column
    BigDecimal DR_U=BigDecimal.ZERO;
    @Column
    BigDecimal CR_U=BigDecimal.ZERO;
    @Column
    BigDecimal DR_B=BigDecimal.ZERO;
    @Column
    BigDecimal CR_B=BigDecimal.ZERO;

    public BigDecimal getDR_T() {
        return DR_T;
    }

    public void setDR_T(BigDecimal DR_T) {
        this.DR_T = DR_T;
    }

    public BigDecimal getCR_T() {
        return CR_T;
    }

    public void setCR_T(BigDecimal CR_T) {
        this.CR_T = CR_T;
    }

    public BigDecimal getDR_U() {
        return DR_U;
    }

    public void setDR_U(BigDecimal DR_U) {
        this.DR_U = DR_U;
    }

    public BigDecimal getCR_U() {
        return CR_U;
    }

    public void setCR_U(BigDecimal CR_U) {
        this.CR_U = CR_U;
    }

    public BigDecimal getDR_B() {
        return DR_B;
    }

    public void setDR_B(BigDecimal DR_B) {
        this.DR_B = DR_B;
    }

    public BigDecimal getCR_B() {
        return CR_B;
    }

    public void setCR_B(BigDecimal CR_B) {
        this.CR_B = CR_B;
    }
    
   
    
    
    
}
