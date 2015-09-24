package th.ac.kmutnb.gl.myreport.service;

import java.util.List;
import th.ac.kmutnb.gl.myreport.entity.Department;
import th.co.bpg.cde.annotation.CIOperation;
import th.co.bpg.cde.annotation.CIParam;
import th.co.bpg.cde.annotation.CIService;
import th.co.bpg.cde.collection.CJFile;

@CIService(Uri = "/report")
public interface IReportService {

    @CIOperation(Uri = "/export", Authentication = true, ResourceCode = "*")
    public CJFile export(@CIParam(Name = "param") String param);

    @CIOperation(Uri = "/download", Authentication = true, ResourceCode = "*")
    public CJFile downlaod(@CIParam(Name = "param") String param);

    @CIOperation(Uri = "/checkSingIn", Authentication = true, ResourceCode = "*")
    public String checkSingIn();

    @CIOperation(Uri = "/index")
    public CJFile index();

    @CIOperation(Uri = "/main")
    public CJFile main();

    @CIOperation(Uri = "/login")
    public CJFile login();

    @CIOperation(Uri = "/js")
    public CJFile js();

}
