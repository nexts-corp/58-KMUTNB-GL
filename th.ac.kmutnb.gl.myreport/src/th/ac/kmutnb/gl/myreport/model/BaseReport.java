/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.model;

import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;

/**
 *
 * @author Panya
 */

@MappedSuperclass
public class BaseReport implements Serializable {
    
    @Id
    @Column      
    String id="";
    @Column
    String M_ACCOUNT_ID_1=" ";
    @Column
    String M_ACCOUNT_NAME_1="";
    @Column
    String M_ACCOUNT_ID_2=" ";
    @Column
    String M_ACCOUNT_NAME_2="";
    @Column
    String M_ACCOUNT_ID_3=" ";
    @Column
    String M_ACCOUNT_NAME_3="";
    @Column
    String M_ACCOUNT_ID_4=" ";
    @Column
    String M_ACCOUNT_NAME_4="";
    @Column
    String M_ACCOUNT_ID_5=" ";
    @Column
    String M_ACCOUNT_NAME_5="";
    @Column
    String M_ACCOUNT_ID_6=" ";
    @Column
    String M_ACCOUNT_NAME_6="";
    @Column
    String ACCOUNT_ID=" ";
    @Column
    String ACCOUNT_NAME="";
    @Column
    BigDecimal DR=BigDecimal.ZERO;
    @Column
    BigDecimal CR=BigDecimal.ZERO;

    public BaseReport() {
        
    }

    public BigDecimal getDR() {
        return DR;
    }

    public void setDR(BigDecimal DR) {
        this.DR = DR;
    }

    public BigDecimal getCR() {
        return CR;
    }

    public void setCR(BigDecimal CR) {
        this.CR = CR;
    }
   

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getM_ACCOUNT_ID_1() {
        return M_ACCOUNT_ID_1;
    }

    public void setM_ACCOUNT_ID_1(String M_ACCOUNT_ID_1) {
        this.M_ACCOUNT_ID_1 = M_ACCOUNT_ID_1;
    }

    public String getM_ACCOUNT_NAME_1() {
        return M_ACCOUNT_NAME_1;
    }

    public void setM_ACCOUNT_NAME_1(String M_ACCOUNT_NAME_1) {
        this.M_ACCOUNT_NAME_1 = M_ACCOUNT_NAME_1;
    }

    public String getM_ACCOUNT_ID_2() {
        return M_ACCOUNT_ID_2;
    }

    public void setM_ACCOUNT_ID_2(String M_ACCOUNT_ID_2) {
        this.M_ACCOUNT_ID_2 = M_ACCOUNT_ID_2;
    }

    public String getM_ACCOUNT_NAME_2() {
        return M_ACCOUNT_NAME_2;
    }

    public void setM_ACCOUNT_NAME_2(String M_ACCOUNT_NAME_2) {
        this.M_ACCOUNT_NAME_2 = M_ACCOUNT_NAME_2;
    }

    public String getM_ACCOUNT_ID_3() {
        return M_ACCOUNT_ID_3;
    }

    public void setM_ACCOUNT_ID_3(String M_ACCOUNT_ID_3) {
        this.M_ACCOUNT_ID_3 = M_ACCOUNT_ID_3;
    }

    public String getM_ACCOUNT_NAME_3() {
        return M_ACCOUNT_NAME_3;
    }

    public void setM_ACCOUNT_NAME_3(String M_ACCOUNT_NAME_3) {
        this.M_ACCOUNT_NAME_3 = M_ACCOUNT_NAME_3;
    }

    public String getM_ACCOUNT_ID_4() {
        return M_ACCOUNT_ID_4;
    }

    public void setM_ACCOUNT_ID_4(String M_ACCOUNT_ID_4) {
        this.M_ACCOUNT_ID_4 = M_ACCOUNT_ID_4;
    }

    public String getM_ACCOUNT_NAME_4() {
        return M_ACCOUNT_NAME_4;
    }

    public void setM_ACCOUNT_NAME_4(String M_ACCOUNT_NAME_4) {
        this.M_ACCOUNT_NAME_4 = M_ACCOUNT_NAME_4;
    }

    public String getM_ACCOUNT_ID_5() {
        return M_ACCOUNT_ID_5;
    }

    public void setM_ACCOUNT_ID_5(String M_ACCOUNT_ID_5) {
        this.M_ACCOUNT_ID_5 = M_ACCOUNT_ID_5;
    }

    public String getM_ACCOUNT_NAME_5() {
        return M_ACCOUNT_NAME_5;
    }

    public void setM_ACCOUNT_NAME_5(String M_ACCOUNT_NAME_5) {
        this.M_ACCOUNT_NAME_5 = M_ACCOUNT_NAME_5;
    }

    public String getM_ACCOUNT_ID_6() {
        return M_ACCOUNT_ID_6;
    }

    public void setM_ACCOUNT_ID_6(String M_ACCOUNT_ID_6) {
        this.M_ACCOUNT_ID_6 = M_ACCOUNT_ID_6;
    }

    public String getM_ACCOUNT_NAME_6() {
        return M_ACCOUNT_NAME_6;
    }

    public void setM_ACCOUNT_NAME_6(String M_ACCOUNT_NAME_6) {
        this.M_ACCOUNT_NAME_6 = M_ACCOUNT_NAME_6;
    }

    public String getACCOUNT_ID() {
        return ACCOUNT_ID;
    }

    public void setACCOUNT_ID(String ACCOUNT_ID) {
        this.ACCOUNT_ID = ACCOUNT_ID;
    }

    public String getACCOUNT_NAME() {
        return ACCOUNT_NAME;
    }

    public void setACCOUNT_NAME(String ACCOUNT_NAME) {
        this.ACCOUNT_NAME = ACCOUNT_NAME;
    }

}
