/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.service.impl;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import th.ac.kmutnb.gl.myreport.model.BaseReport;
import th.ac.kmutnb.gl.myreport.parameter.BaseParameter;
import th.ac.kmutnb.gl.myreport.service.IReportService;
import th.co.bpg.cde.collection.CJFile;
import th.co.bpg.cde.collection.CJMessage;
import th.co.bpg.cde.core.CServiceBase;
import th.co.bpg.cde.data.CDataContext;
import th.co.bpg.cde.report.CReportGenerater;

/**
 *
 * @author Panya
 */
public class ReportService extends CServiceBase implements IReportService {

    private final CDataContext dbcon;

    public ReportService() {
        
        this.dbcon = this.getDataContext();
    }

    private CReportGenerater newReportGenerater(String reportName, String export) {
        
        CReportGenerater gen = new CReportGenerater();
        if (export.equals("pdf")) {
            gen.setExportMode(CReportGenerater.ExportMode.PDF);
        } else if (export.equals("excel")) {
            gen.setExportMode(CReportGenerater.ExportMode.EXCEL);
        } else if (export.equals("word")) {
            gen.setExportMode(CReportGenerater.ExportMode.WORD);
        } else {
            gen.setExportMode(CReportGenerater.ExportMode.PDF);
        }

        gen.setReport(reportName + ".jasper");
        try {
            gen.setReport(new FileInputStream(this.currentPaht+"/reports/" + reportName + ".jasper"));
        } catch (FileNotFoundException ex) {
            Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return gen;
    }

    private CJFile outputFile(String reportName, String export, byte[] out) {
        if (export.equals("pdf")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.PDF, CJFile.CJFileSourceType.STREAM, reportName +"_"+this.account.getCode()+"_"+DateUtil.currentDate()+"_.pdf");
            return file;
        } else if (export.equals("excel")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.EXCEL, CJFile.CJFileSourceType.STREAM, reportName +"_"+this.account.getCode()+"_"+DateUtil.currentDate()+"_.xls");
            return file;
        } else if (export.equals("word")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.WORD, CJFile.CJFileSourceType.STREAM, reportName +"_"+this.account.getCode()+"_"+DateUtil.currentDate()+"_.doc");
            return file;
        } else if (export.equals("pdfview")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.PDF, CJFile.CJFileSourceType.STREAM);
            return file;
        } else {
            CJFile file = new CJFile(out, CJFile.CJFileType.PDF, CJFile.CJFileSourceType.STREAM, reportName +"_"+this.account.getCode()+"_"+DateUtil.currentDate()+"_.pdf");
            return file;
        }
    }

    private String readSQL(String reportName) {
        return this.readSQL(reportName, null,null);
    }

    private String readSQL(String reportName, Object params,Boolean checkQueryAll) {
        
        String qa = "";
        if(checkQueryAll && (reportName.equals("RPT01") || reportName.equals("RPT07"))){
            qa = "A";
        }
        
        StringBuilder sb = new StringBuilder();
        try (Scanner scanner = new Scanner(new FileInputStream(this.currentPaht+"/reports/" + reportName + qa + ".sql"), "UTF-8")) {
            while (scanner.hasNextLine()) {
                sb.append(scanner.nextLine());
                sb.append(" ");
            }
        } catch (FileNotFoundException ex) {
            Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (params != null) {
            try {
                return BaseParameter.PassArgument(sb.toString(), params);
            } catch (IOException ex) {
                Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return sb.toString();
    }

    @Override
    public CJFile export(String reportCode, String exportType
            ,String sparam) {
        try {
            
            CJMessage json=new CJMessage();
            json.parse(sparam);
            BaseParameter psql=(BaseParameter) json.getValue(BaseParameter.class, "");
            
            psql.setREPORT_LOCALE(this.locale);
            psql.setPUBLISHER(this.account.getName());
            
            Class reportClass = Class.forName("th.ac.kmutnb.gl.myreport.model."+ reportCode.toUpperCase() + "_model");
            String reportName = reportCode.toUpperCase();

            String reportSQL = this.readSQL(reportName,initialParam(psql),psql.getQUERYALLSYSTEM());

            List<BaseReport> datas = (List<BaseReport>) this.dbcon.nativeQuery(reportClass, reportSQL);
            CReportGenerater gen = this.newReportGenerater(reportName, exportType);
            
            if (datas != null && !datas.isEmpty()) {
                gen.setReportData(datas);
                psql.setREPORT_MAX_COUNT(datas.size());
                
            } else {
                List<BaseReport> datasx =new  ArrayList<>();
                try {
                    datasx.add((BaseReport) reportClass.newInstance());
                    psql.setREPORT_MAX_COUNT(0);
                } catch (InstantiationException | IllegalAccessException ex) {
                    Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
                }
                gen.setReportData(datasx);
            }
            psql.setREPORT_TYPE(exportType.toUpperCase());
            gen.setParameter(initialParam2(psql));
            byte[] out = gen.Export();
            return this.outputFile(reportName, exportType, out);

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return this.outputFile("RPTERROR", exportType, new byte[]{});
    }
    
   
    private BaseParameter initialParam(BaseParameter paramJson){
        paramJson.setDATE_START(DateUtil.Date2Eng(paramJson.getDATE_START()));
        paramJson.setDATE_END(DateUtil.Date2Eng(paramJson.getDATE_END()));
        paramJson.setDATE_FRIST(DateUtil.FirstPeriod(paramJson.getDATE_START()));
        String DATE_Previous = DateUtil.DATE_Previous(paramJson.getDATE_END());
        paramJson.setDATE_PREVIOUS(DATE_Previous);
        
        if(!paramJson.getQUERYALLSYSTEM()){
            paramJson.setQUERYALLSYSTEM_SQL("AND  glh.GLHEADDATE >= TO_DATE('"+paramJson.getDATE_START()+"', 'DD/MM/YYYY')");
        }
        
        if(paramJson.getBUDGET_TYPE().equals("3")){
            paramJson.setBUDGET_SQL("AND (gl.BUDGETGROUPID != 301010)");
        }
        
        return paramJson;
    }
    
    private BaseParameter initialParam2(BaseParameter paramJson){
        paramJson.setDATE_START(DateUtil.Date2Thai(paramJson.getDATE_START()));
        paramJson.setDATE_END(DateUtil.Date2Thai(paramJson.getDATE_END()));
        return paramJson;
    }

    @Override
    public String checkSingIn() {
        return "ok";
    }
    
}
