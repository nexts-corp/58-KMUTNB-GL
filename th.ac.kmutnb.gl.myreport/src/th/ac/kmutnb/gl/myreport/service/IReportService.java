
package th.ac.kmutnb.gl.myreport.service;

import java.util.List;
import th.ac.kmutnb.gl.myreport.entity.Department;
import th.co.bpg.cde.annotation.CIOperation;
import th.co.bpg.cde.annotation.CIParam;
import th.co.bpg.cde.annotation.CIService;
import th.co.bpg.cde.collection.CJFile;


@CIService(Uri = "/report")
public interface IReportService {

    @CIOperation(Uri = "/export")
    public CJFile export(@CIParam(Name="reportcode") String reportCode
            ,@CIParam(Name="export") String exportType
            ,@CIParam(Name="param")String param);
    
    @CIOperation(Uri = "/checkSingIn",Authentication = true,ResourceCode ="*")
    public String checkSingIn();
    
}
