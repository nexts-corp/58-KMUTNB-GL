/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.service.impl;

import com.sun.org.apache.xerces.internal.impl.dv.util.Base64;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import java.util.TimeZone;
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
        System.setProperty("DEBUG", "false");
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
            gen.setReport(new FileInputStream(this.currentPaht + "/reports/" + reportName + ".jasper"));
        } catch (FileNotFoundException ex) {
            Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
        }
        return gen;
    }

    private CJFile outputFile(String reportName, String export, byte[] out) {
        if (export.equals("pdf")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.PDF, CJFile.CJFileSourceType.STREAM, reportName + "_" + this.account.getCode() + "_" + DateUtil.currentTimestamp() + ".pdf");
            return file;
        } else if (export.equals("excel")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.EXCEL, CJFile.CJFileSourceType.STREAM, reportName + "_" + this.account.getCode() + "_" + DateUtil.currentTimestamp() + ".xls");
            return file;
        } else if (export.equals("word")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.WORD, CJFile.CJFileSourceType.STREAM, reportName + "_" + this.account.getCode() + "_" + DateUtil.currentTimestamp() + ".doc");
            return file;
        } else if (export.equals("pdfview")) {
            CJFile file = new CJFile(out, CJFile.CJFileType.PDF, CJFile.CJFileSourceType.STREAM);

            return file;
        } else {
            CJFile file = new CJFile(out, CJFile.CJFileType.PDF, CJFile.CJFileSourceType.STREAM, reportName + "_" + this.account.getCode() + "_" + DateUtil.currentTimestamp() + ".pdf");
            return file;
        }
    }

    private String readSQL(String reportName) {
        return this.readSQL(reportName, null, null);
    }

    private String readSQL(String reportName, Object params, Boolean checkQueryAll) {

        String qa = "";
        if (checkQueryAll && reportName.equals("RPT07")) {
            qa = "A";
        }

        StringBuilder sb = new StringBuilder();
        try (Scanner scanner = new Scanner(new FileInputStream(this.currentPaht + "/reports/" + reportName + qa + ".sql"), "UTF-8")) {
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
    public CJFile downlaod(String sparam) {
        try {
            //  = new String(Base64.decode(sparam));
            sparam = sparam.replaceAll(" ", "+");
            //sparam = URLDecoder.decode(sparam, "UTF-8");
            sparam = new String(Base64.decode(sparam), "UTF-8");
            CJMessage json = new CJMessage();
            json.parse(sparam);
            BaseParameter psql = (BaseParameter) json.getValue(BaseParameter.class, "");

            if (psql.getSSID().equals(this.request.getValue(String.class, "JSESSIONID"))) {

                psql.setREPORT_LOCALE(this.locale);
                psql.setPUBLISHER(this.account.getName());

                String reportCode = psql.getREPORT_CODE();
                String exportType = psql.getEXPORT_TYPE();

                String reportName = reportCode.toUpperCase();

                if (psql.getQUERYALLSYSTEM() && reportName.equals("RPT07")) {
                    reportName = reportName + "A";
                    reportCode = reportCode + "A";
                }

                Class reportClass = Class.forName("th.ac.kmutnb.gl.myreport.model." + reportCode.toUpperCase() + "_model");

                String reportSQL = this.readSQL(reportName, initialParam(psql), psql.getQUERYALLSYSTEM());

                List<BaseReport> datas = (List<BaseReport>) this.dbcon.nativeQuery(reportClass, reportSQL);
                CReportGenerater gen = this.newReportGenerater(reportName, exportType);

                if (datas != null && !datas.isEmpty()) {
                    gen.setReportData(datas);
                    psql.setREPORT_MAX_COUNT(datas.size());

                } else {
                    List<BaseReport> datasx = new ArrayList<>();
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
            } else {
                CJFile file = new CJFile("<b>User Don't math Current Session</b>", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.STRING);
                return file;
            }

        } catch (ClassNotFoundException | UnsupportedEncodingException ex) {
            CJFile file = new CJFile("<b>Report Error</b>", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.STRING);
            return file;
        }

    }

    @Override
    public CJFile export(String sparam) {

        try {
            // sparam = URLDecoder.decode(sparam, "UTF-8");
            sparam = sparam.replaceAll(" ", "+");
            String xsparam = new String(Base64.decode(sparam), "UTF-8");
            CJMessage json = new CJMessage();
            json.parse(xsparam);
            BaseParameter pm = (BaseParameter) json.getValue(BaseParameter.class, "");
            //String xx= (String) this.request.getValue(String.class, "JSESSIONID");

            if (pm.getSSID().equals(this.request.getValue(String.class, "JSESSIONID"))) {

                String url = "/GLWEB/api/gl/report/download?param=" + sparam;
                String msg = "ทำการดาวน์โหลดไฟล์";
                String icon = "fa-download";
                if (pm.getEXPORT_TYPE().toLowerCase().equals("pdfview")) {
                    msg = "กรุณารอสักครู่";
                    icon = "  fa-cog fa-spin ";
                }
                HashMap reports = new HashMap();
                reports.put("RPT01", "รายงานงบทดลอง");
                reports.put("RPT02", "รายงานบัญชีแยกประเภท");
                reports.put("RPT02_2", "รายงานบัญชีแยกประเภท (หน่วยงาน)");
                reports.put("RPT05", "รายงานงบฐานะการเงิน");
                reports.put("RPT03", "รายงานรายละเอียดประกอบงบแสดงฐานะการเงิน");
                reports.put("RPT06", "รายงานงบรายได้และค่าใช้จ่าย");
                reports.put("RPT04", "รายงานรายละเอียดประกอบงบรายได้และค่าใช้จ่าย");
                reports.put("RPT07", "รายงานกระดาษทำการ");
                reports.put("RPT08", "รายงานเงินรายจ่ายของมหาวิทยาลัย");
                reports.put("RPT09", "รายงานงบกระแสเงินสดรวม");
                reports.put("RPT10", "รายงานวิเคราะห์งบการเงิน");
                reports.put("RPT11", "รายงานค้ำประกันสัญญา (รายงานสัญญา)");
                reports.put("RPT12", "รายงานค้ำประกันซอง (รายบริษัท)");
                reports.put("RPT13", "รายงานทะเบียนคุมเงินประกันเช่าทรัพย์สิน");

                String out = "<html>"
                        + "<head>"
                        + "<title>"
                        + "" + reports.get(pm.getREPORT_CODE().toUpperCase()).toString()
                        + "</title>"
                        + "<link href=\"/GLWEB/css/font-awesome.min.css\" rel=\"stylesheet\" type=\"text/css\">"
                        + "<style type=\"text/css\"> .loading {text-align: center; position: fixed;"
                        + " width: 100%; height: 100%; left: 0; top: 0; background: #f1f1f1; z-index: 1000; }"
                        + " </style>"
                        + "<script>function fn(){document.getElementById(\"loading\").remove();}</script>"
                        + "</head>"
                        + "<body>"
                        + "<div id=\"loading\" class=\"loading\"><br><br><br>"
                        + "<br><i class=\"fa " + icon + " fa-2x\"></i><br>" + msg + "</div>"
                        + "<iframe src=\"" + url + "\" onload=\"fn()\" name=\"theFrame\" frameborder=\"0\" "
                        + " style=\"position:absolute;top:0px;left:0px;right:0px;bottom:0px\" height=\"100%\" "
                        + " width=\"100%\"></iframe><script></script>"
                        + "</body>"
                        + "</html>";

                CJFile file = new CJFile(out, CJFile.CJFileType.HTML, CJFile.CJFileSourceType.STRING);

                return file;
            } else {
                CJFile file = new CJFile("<b>User Don't math Current Session</b>", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.STRING);
                return file;
            }
        } catch (UnsupportedEncodingException ex) {
            CJFile file = new CJFile("<b>Invalid Parameter</b>", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.STRING);
            return file;
        }
        // CJFile filex = new CJFile("<b>Invalid Parameter</b>", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.STRING);
        //return filex;
    }

    private BaseParameter initialParam(BaseParameter paramJson) {
        paramJson.setDATE_START(DateUtil.Date2Eng(paramJson.getDATE_START()));
        paramJson.setDATE_END(DateUtil.Date2Eng(paramJson.getDATE_END()));
        paramJson.setDATE_FRIST(DateUtil.FirstPeriod(paramJson.getDATE_START()));
        String DATE_Previous = DateUtil.DATE_Previous(paramJson.getDATE_END());
        paramJson.setDATE_PREVIOUS(DATE_Previous);

        if (!paramJson.getQUERYALLSYSTEM()) {
            paramJson.setQUERYALLSYSTEM_SQL("AND  glh.GLHEADDATE >= TO_DATE('" + paramJson.getDATE_START() + "', 'DD/MM/YYYY')");
        }

        if (paramJson.getBUDGET_TYPE().equals("3")) {
            paramJson.setBUDGET_SQL("AND (gl.BUDGETGROUPID != 301010)");
        }

        return paramJson;
    }

    private BaseParameter initialParam2(BaseParameter paramJson) {
        paramJson.setDATE_START(DateUtil.Date2Thai(paramJson.getDATE_START()));
        paramJson.setDATE_END(DateUtil.Date2Thai(paramJson.getDATE_END()));
        return paramJson;
    }

    @Override
    public String checkSingIn() {
        return "ok";
    }

    @Override
    public CJFile js() {
//        String input ="/th/ac/kmutnb/gl/web/res/report.js";
//        Class _ass=this.getClass();
//        try (InputStream in =_ass.getResourceAsStream(input)) {
//            ByteArrayOutputStream out = new ByteArrayOutputStream();
//            byte[] b = new byte[4096];
//            for (int n; (n = in.read(b)) != -1;) {
//                out.write(b, 0, n);
//            }
//            out.close();
//            String js = out.toString("UTF-8");
//            js = js.replaceAll("(\r\n|\n)", "");
//            
//            CJFile filex = new CJFile(js, CJFile.CJFileType.JS, CJFile.CJFileSourceType.STRING);
//            return filex;
//        } catch (FileNotFoundException ex) {
//            Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
//        } catch (IOException ex) {
//            Logger.getLogger(ReportService.class.getName()).log(Level.SEVERE, null, ex);
//        }
//        return null;
        
        CJFile filex = new CJFile("/th/ac/kmutnb/gl/web/res/report.js", CJFile.CJFileType.JS, CJFile.CJFileSourceType.RESOURCES);
        return filex;

    }

    @Override
    public CJFile index() {
        CJFile filex = new CJFile("/th/ac/kmutnb/gl/web/res/index.html", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.RESOURCES);
        return filex;
    }

    @Override
    public CJFile main() {
        CJFile filex = new CJFile("/th/ac/kmutnb/gl/web/res/main.html", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.RESOURCES);
        return filex;
    }

    @Override
    public CJFile login() {
        CJFile filex = new CJFile("/th/ac/kmutnb/gl/web/res/login.html", CJFile.CJFileType.HTML, CJFile.CJFileSourceType.RESOURCES);
        return filex;
    }

}
