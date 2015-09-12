/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.parameter;

import com.github.mustachejava.DefaultMustacheFactory;
import com.github.mustachejava.Mustache;
import com.github.mustachejava.MustacheFactory;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.Locale;

/**
 *
 * @author Panya
 */
public class BaseParameter {

    Locale REPORT_LOCALE;
    int REPORT_MAX_COUNT;
    String REPORT_TYPE;
    String DATE_PREVIOUS;
    String DATE_FRIST;
    String DATE_START;
    String DATE_END;
    String PUBLISHER;
    String BUDGET_TYPE;
    String BUDGET_SQL;
    String BUDGET_SORCE_START;
    String BUDGET_SORCE_END;
    String FUND_SORCE_START;
    String FUND_SORCE_END;
    String DEPARTMENT;
    String DEPARTMENT_SORCE_START;
    String DEPARTMENT_SORCE_END;
    String PLAN_SORCE_START;
    String PLAN_SORCE_END;
    String PROJECT_SORCE_START;
    String PROJECT_SORCE_END;
    String ACTIVITY_SORCE_START;
    String ACTIVITY_SORCE_END;
    String ACCOUNT_START;
    String ACCOUNT_END;
    String REFERNAME1;
    String MGRNAMETHAI1;
    String REFERNAME2;
    String MGRNAMETHAI2;

    public String getREFERNAME1() {
        return REFERNAME1;
    }

    public void setREFERNAME1(String REFERNAME1) {
        this.REFERNAME1 = REFERNAME1;
    }

    public String getMGRNAMETHAI1() {
        return MGRNAMETHAI1;
    }

    public void setMGRNAMETHAI1(String MGRNAMETHAI1) {
        this.MGRNAMETHAI1 = MGRNAMETHAI1;
    }

    public String getREFERNAME2() {
        return REFERNAME2;
    }

    public void setREFERNAME2(String REFERNAME2) {
        this.REFERNAME2 = REFERNAME2;
    }

    public String getMGRNAMETHAI2() {
        return MGRNAMETHAI2;
    }

    public void setMGRNAMETHAI2(String MGRNAMETHAI2) {
        this.MGRNAMETHAI2 = MGRNAMETHAI2;
    }

    public String getDATE_PREVIOUS() {
        return DATE_PREVIOUS;
    }

    public void setDATE_PREVIOUS(String DATE_PREVIOUS) {
        this.DATE_PREVIOUS = DATE_PREVIOUS;
    }

    public String getACCOUNT_START() {
        return ACCOUNT_START;
    }

    public void setACCOUNT_START(String ACCOUNT_START) {
        this.ACCOUNT_START = ACCOUNT_START;
    }

    public String getACCOUNT_END() {
        return ACCOUNT_END;
    }

    public void setACCOUNT_END(String ACCOUNT_END) {
        this.ACCOUNT_END = ACCOUNT_END;
    }

    public BaseParameter() {
        this.REPORT_LOCALE = new Locale("th", "TH");
    }

    public String getBUDGET_SQL() {
        return BUDGET_SQL;
    }

    public void setBUDGET_SQL(String BUDGET_SQL) {
        this.BUDGET_SQL = BUDGET_SQL;
    }

    public String getDATE_FRIST() {
        return DATE_FRIST;
    }

    public void setDATE_FRIST(String DATE_FRIST) {
        this.DATE_FRIST = DATE_FRIST;
    }

    public String getBUDGET_TYPE() {
        return BUDGET_TYPE;
    }

    public void setBUDGET_TYPE(String BUDGET_TYPE) {
        this.BUDGET_TYPE = BUDGET_TYPE;
    }

    public String getDATE_START() {
        return DATE_START;
    }

    public void setDATE_START(String DATE_START) {
        this.DATE_START = DATE_START;
    }

    public String getDATE_END() {
        return DATE_END;
    }

    public void setDATE_END(String DATE_END) {
        this.DATE_END = DATE_END;
    }

    public String getPUBLISHER() {
        return PUBLISHER;
    }

    public void setPUBLISHER(String PUBLISHER) {
        this.PUBLISHER = PUBLISHER;
    }

    public String getBUDGET_SORCE_START() {
        return BUDGET_SORCE_START;
    }

    public void setBUDGET_SORCE_START(String BUDGET_SORCE_START) {
        this.BUDGET_SORCE_START = BUDGET_SORCE_START;
    }

    public String getBUDGET_SORCE_END() {
        return BUDGET_SORCE_END;
    }

    public void setBUDGET_SORCE_END(String BUDGET_SORCE_END) {
        this.BUDGET_SORCE_END = BUDGET_SORCE_END;
    }

    public String getFUND_SORCE_START() {
        return FUND_SORCE_START;
    }

    public void setFUND_SORCE_START(String FUND_SORCE_START) {
        this.FUND_SORCE_START = FUND_SORCE_START;
    }

    public String getFUND_SORCE_END() {
        return FUND_SORCE_END;
    }

    public void setFUND_SORCE_END(String FUND_SORCE_END) {
        this.FUND_SORCE_END = FUND_SORCE_END;
    }

    public String getDEPARTMENT_SORCE_START() {
        return DEPARTMENT_SORCE_START;
    }

    public void setDEPARTMENT_SORCE_START(String DEPARTMENT_SORCE_START) {
        this.DEPARTMENT_SORCE_START = DEPARTMENT_SORCE_START;
    }

    public String getDEPARTMENT_SORCE_END() {
        return DEPARTMENT_SORCE_END;
    }

    public void setDEPARTMENT_SORCE_END(String DEPARTMENT_SORCE_END) {
        this.DEPARTMENT_SORCE_END = DEPARTMENT_SORCE_END;
    }

    public String getPLAN_SORCE_START() {
        return PLAN_SORCE_START;
    }

    public String getDEPARTMENT() {
        return DEPARTMENT;
    }

    public void setDEPARTMENT(String DEPARTMENT) {
        this.DEPARTMENT = DEPARTMENT;
    }

    public void setPLAN_SORCE_START(String PLAN_SORCE_START) {
        this.PLAN_SORCE_START = PLAN_SORCE_START;
    }

    public String getPLAN_SORCE_END() {
        return PLAN_SORCE_END;
    }

    public void setPLAN_SORCE_END(String PLAN_SORCE_END) {
        this.PLAN_SORCE_END = PLAN_SORCE_END;
    }

    public String getPROJECT_SORCE_START() {
        return PROJECT_SORCE_START;
    }

    public void setPROJECT_SORCE_START(String PROJECT_SORCE_START) {
        this.PROJECT_SORCE_START = PROJECT_SORCE_START;
    }

    public String getPROJECT_SORCE_END() {
        return PROJECT_SORCE_END;
    }

    public void setPROJECT_SORCE_END(String PROJECT_SORCE_END) {
        this.PROJECT_SORCE_END = PROJECT_SORCE_END;
    }

    public String getACTIVITY_SORCE_START() {
        return ACTIVITY_SORCE_START;
    }

    public void setACTIVITY_SORCE_START(String ACTIVITY_SORCE_START) {
        this.ACTIVITY_SORCE_START = ACTIVITY_SORCE_START;
    }

    public String getACTIVITY_SORCE_END() {
        return ACTIVITY_SORCE_END;
    }

    public void setACTIVITY_SORCE_END(String ACTIVITY_SORCE_END) {
        this.ACTIVITY_SORCE_END = ACTIVITY_SORCE_END;
    }

    public static String PassArgument(String sql, Object params) throws IOException {
        MustacheFactory mf = new DefaultMustacheFactory();
        Mustache mustache = mf.compile(new StringReader(sql), "sql_reader");
        StringWriter writer = new StringWriter();
        mustache.execute(writer, params).flush();
        return writer.toString();

    }

    public Locale getREPORT_LOCALE() {
        return REPORT_LOCALE;
    }

    public void setREPORT_LOCALE(Locale REPORT_LOCALE) {
        this.REPORT_LOCALE = REPORT_LOCALE;
    }

    public int getREPORT_MAX_COUNT() {
        return REPORT_MAX_COUNT;
    }

    public void setREPORT_MAX_COUNT(int REPORT_MAX_COUNT) {
        this.REPORT_MAX_COUNT = REPORT_MAX_COUNT;
    }

    public String getREPORT_TYPE() {
        return REPORT_TYPE;
    }

    public void setREPORT_TYPE(String REPORT_TYPE) {
        this.REPORT_TYPE = REPORT_TYPE;
    }

}
