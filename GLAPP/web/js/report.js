$(document).ready(function () {


    $(".bExport").attr("disabled",true)
    $(".cDate").datepicker({language: 'th-th', format: 'dd/mm/yyyy', autoclose: true});

    var chAjaxLoad = [];
    chAjaxLoad["user"] = false;
    chAjaxLoad["departmentCurrent"] = false;
    chAjaxLoad["department"] = false;
    chAjaxLoad["departmentDetail"] = false;
    chAjaxLoad["account"] = false;
    chAjaxLoad["project"] = false;
    chAjaxLoad["plan"] = false;
    chAjaxLoad["activity"] = false;
    chAjaxLoad["fundGroup"] = false;
    chAjaxLoad["budgetGroup"] = false;


    function UCheckAjaxLoad(update) {
        chAjaxLoad[update] = true;
    }


    checkLoading(chAjaxLoad);
    function checkLoading(check) {
        setTimeout(function () {
            if (
                    chAjaxLoad["user"] == true && chAjaxLoad["department"] == true &&
                    chAjaxLoad["departmentDetail"] == true && chAjaxLoad["account"] == true &&
                    chAjaxLoad["project"] == true && chAjaxLoad["plan"] == true &&
                    chAjaxLoad["activity"] == true && chAjaxLoad["fundGroup"] == true &&
                    chAjaxLoad["budgetGroup"] == true && chAjaxLoad["departmentCurrent"]
                    ) {
                $(".loading").hide();
            } else {
                checkLoading(chAjaxLoad);
            }
        }, 1000);
    }


    $("select").chosen({width: "100%"});




    function eror_401(xrs) {
        if (xrs.status == 401) {
            var data = $.parseJSON(xrs.responseText);
            window.location.href = data.redirectPage;
        }
    }


    $.post("/api/gl/form/user", {}, function (data) {
        $(".user_adminname").text(data.user);
        UCheckAjaxLoad("user");
    }).fail(eror_401);
    
    
    
    $.post("/api/gl/form/departmentCurrent", {}, function (data) {
        $("#departmentName").text(data[0].departmentName);
        if(data[0].departmentId===0){
            $(".openRpt").show();
            $('#report_type').trigger("chosen:updated");
        }
        UCheckAjaxLoad("departmentCurrent");
    }).fail(eror_401);


    function ksCallBack(run, callback) {
        var data = run();
        callback(data);
    }


    var inc = 0;
    function selectFristLast(name) {
        $(name).eq(0).find('option[style*="display: block"]').first().prop("selected", true);
        $(name).eq(1).find('option[style*="display: block"]').last().prop("selected", true);
        $(name).trigger("chosen:updated");

    }



    $(document).on("change", "#report_type", function () {
        if ($("#report_type").val() === "RPT02" || $("#report_type").val() === "RPT02_2") {
            $(".cAccount").prop("disabled", false).trigger("chosen:updated");
        } else {
            selectFristLast(".cAccount");
            $(".cAccount").prop("disabled", true).trigger("chosen:updated");
        }
    });



    $.post("./api/gl/form/department", {}, function (data) {
        ksCallBack(function () {

            var i;
            var html;
            for (i in data) {
                html += '<option style="display: block" value="' + data[i].departmentId + '">' + data[i].departmentId + '  :  ' + data[i].departmentName + '</option>';
            }
            return html;

        }, function (req) {

            $('#department').html(req);
            UCheckAjaxLoad("department");
            $('#department').trigger("chosen:updated");

        });
    }).fail(eror_401);


    $.post("./api/gl/form/departmentDetail", {}, function (data) {
        ksCallBack(function () {

            var i;
            var html;
            for (i in data) {
                html += '<option style="display: block" master-id="' + data[i].masterId + '" value="' + data[i].departmentId + '" >' + data[i].departmentId + '  :  ' + data[i].departmentName + '</option>';
            }
            var nameUse = $(".cDepartment");
            nameUse.html(html);
            return nameUse;

        }, function (name) {
            selectFristLast(name);
            UCheckAjaxLoad("departmentDetail");

        });
    }).fail(eror_401);


    $(document).on("change", "#department", function () {

        var optionName = ".cDepartment";
        if ($("#department").val() === "0") {
            $(optionName).find("option").show();
            selectFristLast(optionName);
        } else {
            $(optionName).find("option").hide();
            $(optionName).find('option[value="' + $("#department").val() + '"]').show();
            $(optionName).find('option[master-id="' + $("#department").val() + '"]').show();
            //$(optionName).find('option[master-id="' + $("#department").val() + '"]').first().attr("selected", true);

            $(optionName).find('option[value="' + $("#department").val() + '"]').first().attr("selected", true);
            $(optionName).find('option[master-id="' + $("#department").val() + '"]').last().attr("selected", true);
        }

        selectFristLast(optionName);


    });


    $.post("./api/gl/form/account", {}, function (data) {

        ksCallBack(function () {

            var i;
            var html;
            for (i in data) {
                html += '<option style="display: block" value="' + data[i].accountId + '">' + data[i].accountId + '  :  ' + data[i].accountName + '</option>';
            }
            var nameUse = $(".cAccount");
            nameUse.html(html);
            return nameUse;

        }, function (name) {
            selectFristLast(name);
            UCheckAjaxLoad("account");
        });

    }).fail(eror_401);


    $.post("./api/gl/form/plan", {depId: 0}, function (data) {

        ksCallBack(function () {

            var i;
            var html;
            for (i in data) {
                html += '<option style="display: block" value="' + data[i].planId + '">' + data[i].planId + '  :  ' + data[i].planName + '</option>';
            }
            var nameUse = $(".cPlan");
            nameUse.html(html);
            return nameUse;

        }, function (name) {
            selectFristLast(name);
            UCheckAjaxLoad("plan");
        });

    }).fail(eror_401);

    getOptionPlanProjectActivity(null);





    function getOptionPlanProjectActivity(depIdVal) {

        $.post("./api/gl/form/project", {depId: depIdVal}, function (data) {

            ksCallBack(function () {

                var i;
                var html;
                for (i in data) {
                    html += '<option style="display: block" value="' + data[i].projectId + '">' + data[i].projectId + '  :  ' + data[i].projectName + '</option>';
                }
                var nameUse = $(".cProject");
                nameUse.html(html);
                return nameUse;

            }, function (name) {
                selectFristLast(name);
                UCheckAjaxLoad("project");
            });

        }).fail(eror_401);


        $.post("./api/gl/form/activity", {depId: depIdVal}, function (data) {

            ksCallBack(function () {

                var i;
                var html;
                for (i in data) {
                    html += '<option style="display: block" master-id="' + data[i].projectId + '" value="' + data[i].activityId + '">' + data[i].activityId + '  :  ' + data[i].activityName + '</option>';
                }
                var nameUse = $(".cActivity");
                nameUse.html(html);
                return nameUse;

            }, function (name) {
                selectFristLast(name);
                UCheckAjaxLoad("activity");
            });

        }).fail(eror_401);

    }






    $.post("./api/gl/form/fundGroup", {}, function (data) {

        ksCallBack(function () {

            var i;
            var html;
            for (i in data) {
                html += '<option style="display: block" value="' + data[i].fundGroupId + '">' + data[i].fundGroupId + '  :  ' + data[i].fundGroupName + '</option>';
            }
            var nameUse = $(".cFund");
            nameUse.html(html);
            return nameUse;

        }, function (name) {
            selectFristLast(name);
            UCheckAjaxLoad("fundGroup");
        });

    }).fail(eror_401);
    



    $.post("./api/gl/form/budgetGroup", {}, function (data) {

        ksCallBack(function () {

            var i;
            var html;
            for (i in data) {
                html += '<option style="display: block" budget-source="' + data[i].budgetSource + '"  value="' + data[i].budgetGroupId + '">' + data[i].budgetGroupId + '  :  ' + data[i].budgetGroupName + '</option>';
            }
            var nameUse = $(".cSource");
            nameUse.html(html);
            return nameUse;

        }, function (name) {
            selectFristLast(name);
            UCheckAjaxLoad("budgetGroup");
        });

    }).fail(eror_401);


    function selectBudgetGroup(optionName, budgetSource, useSelectAuto, fristSelect, lastSelect) {
        $(optionName).find('option[budget-source="' + budgetSource + '"]').show();
        if (useSelectAuto) {
            $(optionName).find('option[budget-source="' + fristSelect + '"]').first().attr("selected", true);
            $(optionName).find('option[budget-source="' + lastSelect + '"]').last().attr("selected", true);
        } else {
        }
    }


    $(document).on("change", "#budgetType", function () {

        var optionName = ".cSource";
        var getBudgetType = $("#budgetType").val();

        $(optionName).find("option").hide();
        if (getBudgetType === "1") {
            $(optionName).find("option").show();
        } else if (getBudgetType === "2") {
            selectBudgetGroup(optionName, 1, true, 1, 1);
        } else if (getBudgetType === "3") {
            selectBudgetGroup(optionName, 2, false, 0, 0);
            selectBudgetGroup(optionName, 9, true, 2, 9);
        } else if (getBudgetType === "4") {
            selectBudgetGroup(optionName, 3, true, 3, 3);
        } else if (getBudgetType === "5") {
            selectBudgetGroup(optionName, 2, false, 0, 0);
            selectBudgetGroup(optionName, 3, false, 0, 0);
            selectBudgetGroup(optionName, 9, true, 2, 9);
        } else {}

        selectFristLast(optionName);

    });



    $(document).on("change",".cDate",function(){
        var chtfdate = checkdate($("#date_start").val())*checkdate($("#date_end").val());
        if(chtfdate){
            $(this).parent("div").removeClass("has-error"); 
        }else{
            $(this).parent("div").addClass("has-error"); 
        }
        
        enableBtnExport();
    });
    
    function checkdate(valdate) {
        var validformat = /^\d{2}\/\d{2}\/\d{4}$/;
        var returnval = false;
        if (validformat.test(valdate)){
            var dayfield = valdate.split("/")[0];
            var monthfield = valdate.split("/")[1];
            var yearfield = valdate.split("/")[2];
            var dayobj = new Date(yearfield, monthfield - 1, dayfield);
            if ((dayobj.getMonth() + 1 !== parseInt(monthfield)) || (dayobj.getDate() !== parseInt(dayfield)) || (dayobj.getFullYear() !== parseInt(yearfield))){}else{
                returnval = true;
            }
        }
        return returnval;
    }
    
    

    $(document).on("change", "[check-hl]", function () {
        var cHL = $("."+$(this).attr("check-hl"));
        if(parseInt(cHL.eq(0).val())>parseInt(cHL.eq(1).val())){
            cHL.parents(".panel").removeClass("panel-info"); 
            cHL.parents(".panel").addClass("panel-danger"); 
        }else{
            cHL.parents(".panel").removeClass("panel-danger"); 
            cHL.parents(".panel").addClass("panel-info"); 
        }
        enableBtnExport();
        
        
    });
    
    function enableBtnExport(){
        var checkError = false;
        if($(".panel-danger").length!==0){ checkError = true; }
        if($(".has-error").length!==0){ checkError = true; }
        if(checkError){
            $(".bExport").attr("disabled",true);
        }else{
            $(".bExport").attr("disabled",false);
        }

    }
    
    
    
    
    
    
    function findIndexObject(obj, attr, value){
        for(var i = 0; i < obj.length; i += 1) {
            if(obj[i][attr] === value) {
                return i;
            }
        }
    };
    
    
    var dataMgr = [];
    $.post("./api/gl/form/mgr", {}, function (data) {
        dataMgr = data;
    }).fail(eror_401);
    
    
    function masterDepartment(dep){
        
        var masterId = parseInt(dep.attr("master-id"));
        if (masterId === 0) {
            return parseInt(dep.val());
        }else{
            return masterId;
        }
        
    }
    
    function budgetType(select){
        var budgetId = 1;
        var budgetText = "";
        
        var start_fsourceid = $("#source_start").val().substring(0, 1);
        var end_fsourceid = $("#source_end").val().substring(0, 1);
        var bType = $("#budgetType").val();
        if (start_fsourceid === '1' && end_fsourceid === '1') {
            budgetText = "เงินงบประมาณแผ่นดิน";
            budgetId = 2;
        } else if (((start_fsourceid === '2' && end_fsourceid === '9') || (start_fsourceid === '2' && end_fsourceid === '3') || (start_fsourceid === '3' && end_fsourceid === '9')) && bType !== '3') {
            budgetText = "เงินรายได้รวม";
            budgetId = 5;
        } else if (start_fsourceid === '2' && end_fsourceid === '9' && bType === '3') {
            budgetText = "เงินรายได้ศูนย์รวม";
            budgetId = 3;
        } else if (start_fsourceid === '3' && end_fsourceid === '3') {
            budgetText = "เงินทุนคณะ";
            budgetId = 4;
        }
        
        if(select==="id"){
            return budgetId;
        }else if(select==="text"){
            return budgetText;
        }
    }
    
    
    
    
    function getSignature(){
        
        var referName1 = "";
        var mgrNameThai1 = "";
        var referName2 = "";
        var mgrNameThai2 = "";
        
        var valMasterStart = masterDepartment($("#department_start option:selected"));
        var valMasterEnd = masterDepartment($("#department_end option:selected"));
        
        
        if(valMasterStart >= 20000 && valMasterStart===valMasterEnd){
            var fio = findIndexObject(dataMgr,"mgrDepartmentId",parseInt(valMasterStart));
            if(typeof fio !== 'undefined'){
                referName2 = dataMgr[fio].referName;
                mgrNameThai2 = dataMgr[fio].mgrNameThai;
            }
        }else if((valMasterStart < 20000 && valMasterStart===valMasterEnd)){
            var fio = findIndexObject(dataMgr,"mgrCode",6);
            if(typeof fio !== 'undefined'){
                referName2 = dataMgr[fio].referName;
                mgrNameThai2 = dataMgr[fio].mgrNameThai;
            }
        }else{
            var fio = findIndexObject(dataMgr,"mgrCode",6);
            if(typeof fio !== 'undefined'){
                referName2 = dataMgr[fio].referName;
                mgrNameThai2 = dataMgr[fio].mgrNameThai;
            }
            
            if(budgetType("id")===1 ||budgetType("id")===2 || budgetType("id")===5){
                var fio = findIndexObject(dataMgr,"mgrCode",1);
                if(typeof fio !== 'undefined'){
                    referName1 = dataMgr[fio].referName;
                    mgrNameThai1 = dataMgr[fio].mgrNameThai;
                }
            }
        }
        
        return [{referName:referName1,mgrNameThai:mgrNameThai1},{referName:referName2,mgrNameThai:mgrNameThai2}];
        
    }
    
   

    $(document).on("click", ".bExport", function () {
        
        var sendData = {
            BUDGET_SORCE_START: $('#source_start').val(),
            BUDGET_SORCE_END: $('#source_end').val(),
            DATE_START: $('#date_start').val(),
            DATE_END: $('#date_end').val(),
            DEPARTMENT_SORCE_START: $('#department_start').val(),
            DEPARTMENT_SORCE_END: $('#department_end').val(),
            PLAN_SORCE_START: $('#plan_start').val(),
            PLAN_SORCE_END: $('#plan_end').val(),
            PROJECT_SORCE_START: $('#project_start').val(),
            PROJECT_SORCE_END: $('#project_end').val(),
            ACTIVITY_SORCE_START: $('#activity_start').val(),
            ACTIVITY_SORCE_END: $('#activity_end').val(),
            FUND_SORCE_START: $('#fund_start').val(),
            FUND_SORCE_END: $('#fund_end').val(),
            BUDGET_TYPE: $('#budgetType').val(),
            ACCOUNT_START: $('#account_start').val(),
            ACCOUNT_END: $('#account_end').val(),
            DEPARTMENT: '',
            PUBLISHER: '',
            REFERNAME1: '',
            MGRNAMETHAI1: '',
            REFERNAME2: '',
            MGRNAMETHAI2: ''
        };


        var nameDepartmentAll = "";

        var valMasterStart = $("#department_start option:selected").attr("master-id");
        var valMasterEnd = $("#department_end option:selected").attr("master-id");
        if (valMasterStart === "0") {
            valMasterStart = $("#department_start option:selected").val();
        }
        if (valMasterEnd === "0") {
            valMasterEnd = $("#department_end option:selected").val();
        }

        if (valMasterStart === valMasterEnd) {
            var strDepartment = $("#department").find('option[value="' + valMasterStart + '"]').text();
            var resDepartment = strDepartment.split("  :  ");
            nameDepartmentAll += resDepartment[1] + "\n";
        }

        var valMasterStart2 = $("#department_start option:selected").attr("master-id");
        var valMasterEnd2 = $("#department_end option:selected").attr("master-id");
        if ((sendData.DEPARTMENT_SORCE_START === sendData.DEPARTMENT_SORCE_END) && (valMasterStart2 !== "0" && valMasterEnd2 !== "0")) {
            var strDepartmentDetail = $("#department_start option:selected").text();
            var resDepartmentDetail = strDepartmentDetail.split("  :  ");

            nameDepartmentAll += resDepartmentDetail[1];
        }

        if(budgetType('id')!==1){
            nameDepartmentAll += "  ("+budgetType('text')+")";
        }
        
        sendData.DEPARTMENT = nameDepartmentAll;
        
        
        var signature = getSignature();
        sendData.REFERNAME1 = signature[0].referName;
        sendData.MGRNAMETHAI1 = signature[0].mgrNameThai;
        sendData.REFERNAME2 = signature[1].referName;
        sendData.MGRNAMETHAI2 = signature[1].mgrNameThai;


        var data = {
            reportcode: $('#report_type').val(),
            export: $(this).attr('exporttype'),
            param: encodeURIComponent(JSON.stringify(sendData))
        };
        console.log(JSON.stringify(sendData, null, 4));

        var url = "/api/gl/report/export?reportcode=" + data.reportcode + "&export=" + data.export + "&param=" + data.param;
        
        if (data.export == "pdfview") {
            var win = window.open();
            win.document.write('<title>เรียกดูรายงาน : ระบบบัญชีแยกประเภทสามมิติ</title><link href="css/font-awesome.min.css" rel="stylesheet" type="text/css"><style type="text/css"> .loading {text-align: center; position: fixed; width: 100%; height: 100%; left: 0; top: 0; background: #f1f1f1; z-index: 1000; } </style><script>function fn(){document.getElementById("loading").remove();}</script><div id="loading" class="loading"><br><br><br><br><i class="fa fa-cog fa-spin fa-2x"></i><br>กรุณารอสักครู่</div><iframe src="' + url + '" onload="fn()" name="theFrame" frameborder="0" style="position:absolute;top:0px;left:0px;right:0px;bottom:0px" height="100%" width="100%"></iframe><script>location.hash = "viewReport"</script>');
        } else {
            var win = window.open();
            win.document.write('<title>ดาวน์โหลดไฟล์ : ระบบบัญชีแยกประเภทสามมิติ</title><link href="css/font-awesome.min.css" rel="stylesheet" type="text/css"><style type="text/css"> .loading {text-align: center; position: fixed; width: 100%; height: 100%; left: 0; top: 0; background: #f1f1f1; z-index: 1000; } </style><script> function fn(){document.getElementById("loading").remove();}</script><div id="loading" class="loading"><br><br><br><br><i class="fa fa-download fa-2x"></i><br>ทำการดาวน์โหลดไฟล์</div><iframe src="' + url + '" onload="fn()" name="theFrame" frameborder="0" style="position:absolute;top:0px;left:0px;right:0px;bottom:0px" height="100%" width="100%"></iframe><script>location.hash = "viewReport"</script>');
        }



    });



});
