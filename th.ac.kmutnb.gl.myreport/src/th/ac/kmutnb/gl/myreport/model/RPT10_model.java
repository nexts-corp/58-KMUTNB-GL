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
public class RPT10_model extends BaseReport{
    
    @Column
    String IDG="";
    @Column
    String NAMEG="";
    @Column
    String NAME="";
    @Column
    BigDecimal RESULT=BigDecimal.ZERO;;

    public String getIDG() {
        return IDG;
    }

    public void setIDG(String IDG) {
        this.IDG = IDG;
    }

    public String getNAMEG() {
        return NAMEG;
    }

    public void setNAMEG(String NAMEG) {
        this.NAMEG = NAMEG;
    }

    public String getNAME() {
        return NAME;
    }

    public void setNAME(String NAME) {
        this.NAME = NAME;
    }

    public BigDecimal getRESULT() {
        return RESULT;
    }

    public void setRESULT(BigDecimal RESULT) {
        this.RESULT = RESULT;
    }
   
    
    
    
}
