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
public class RPT01A_model extends BaseReport {

    @Column
    BigDecimal DR_R=BigDecimal.ZERO;;
    @Column
    BigDecimal CR_R=BigDecimal.ZERO;;

    public BigDecimal getDR_R() {
        return DR_R;
    }

    public void setDR_R(BigDecimal DR_R) {
        this.DR_R = DR_R;
    }

    public BigDecimal getCR_R() {
        return CR_R;
    }

    public void setCR_R(BigDecimal CR_R) {
        this.CR_R = CR_R;
    }

    
    
    
    

}
