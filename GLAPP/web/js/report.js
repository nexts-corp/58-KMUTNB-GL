$(document).ready(function () {



    $(".cDate").datepicker({language: 'th-th', format: 'dd/mm/yyyy', autoclose: true});

    var chAjaxLoad = [];
    chAjaxLoad["user"] = false;
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

            //console.log(chAjaxLoad.department);
            if (
                    chAjaxLoad["user"] == true && chAjaxLoad["department"] == true &&
                    chAjaxLoad["departmentDetail"] == true && chAjaxLoad["account"] == true &&
                    chAjaxLoad["project"] == true && chAjaxLoad["plan"] == true &&
                    chAjaxLoad["activity"] == true && chAjaxLoad["fundGroup"] == true &&
                    chAjaxLoad["budgetGroup"] == true
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

    function ksCallBack(run, callback) {
        var data = run();
        callback(data);
    }
    
    function ksCallBack2(vari,run, callback) {
        var data = run(vari);
        callback(data);
    }
    

    function selectFristLast(name) {

        $(name).eq(0).find('option[style*="display: block"]').first().attr("selected", true);
        $(name).eq(1).find('option[style*="display: block"]').last().attr("selected", true);
        $(name).trigger("chosen:updated");

    }



    $(document).on("change", "#report_type", function () {
        if($("#report_type").val()==="RPT02" || $("#report_type").val()==="RPT02_2"){
            $(".cAccount").prop("disabled", false).trigger("chosen:updated");
        }else{
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
    ;



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
        } else {
        }

        selectFristLast(optionName);

    });



    $(document).on("click", ".bExport", function () {

        

        

        var sendData = {
            BUDGET_SORCE_START: '',
            BUDGET_SORCE_END: '',
            DATE_START: '',
            DATE_END: '',
            DEPARTMENT: '',
            DEPARTMENT_SORCE_START: '',
            DEPARTMENT_SORCE_END: '',
            PLAN_SORCE_START: '',
            PLAN_SORCE_END: '',
            PROJECT_SORCE_START: '',
            PROJECT_SORCE_END: '',
            ACTIVITY_SORCE_START: '',
            ACTIVITY_SORCE_END: '',
            FUND_SORCE_START: '',
            FUND_SORCE_END: '',
            PUBLISHER: '',
            BUDGET_TYPE: '',
            ACCOUNT_START: '',
            ACCOUNT_END: ''
        };



        sendData.BUDGET_SORCE_START = $('#source_start').val();
        sendData.BUDGET_SORCE_END = $('#source_end').val();
        sendData.DATE_START = $('#date_start').val();
        sendData.DATE_END = $('#date_end').val();
        sendData.DEPARTMENT = "";
        sendData.DEPARTMENT_SORCE_START = $('#department_start').val();
        sendData.DEPARTMENT_SORCE_END = $('#department_end').val();
        sendData.PLAN_SORCE_START = $('#plan_start').val();
        sendData.PLAN_SORCE_END = $('#plan_end').val();
        sendData.PROJECT_SORCE_START = $('#project_start').val();
        sendData.PROJECT_SORCE_END = $('#project_end').val();
        sendData.ACTIVITY_SORCE_START = $('#activity_start').val();
        sendData.ACTIVITY_SORCE_END = $('#activity_end').val();
        sendData.FUND_SORCE_START = $('#fund_start').val();
        sendData.FUND_SORCE_END = $('#fund_end').val();
        sendData.PUBLISHER = "พงศ์ปณต ทัศนียาชุมพาลี";
        sendData.BUDGET_TYPE = $('#budgetType').val();
        sendData.ACCOUNT_START = $('#account_start').val();
        sendData.ACCOUNT_END = $('#account_end').val();





        var nameDepartmentAll = "";

        var valMasterStart = $("#department_start option:selected").attr("master-id");
        var valMasterEnd = $("#department_end option:selected").attr("master-id");
        if(valMasterStart === "0"){ valMasterStart = $("#department_start option:selected").val(); }
        if(valMasterEnd === "0"){ valMasterEnd = $("#department_end option:selected").val(); }

        if (valMasterStart === valMasterEnd) {
            var strDepartment =$("#department").find('option[value="'+valMasterStart+'"]').text();
            var resDepartment = strDepartment.split("  :  ");
            nameDepartmentAll += resDepartment[1]+"\n";
        }

        var valMasterStart2 = $("#department_start option:selected").attr("master-id");
        var valMasterEnd2 = $("#department_end option:selected").attr("master-id");
        if ((sendData.DEPARTMENT_SORCE_START === sendData.DEPARTMENT_SORCE_END)&&(valMasterStart2!=="0" && valMasterEnd2!=="0")) {
            var strDepartmentDetail = $("#department_start option:selected").text();
            var resDepartmentDetail = strDepartmentDetail.split("  :  ");

            nameDepartmentAll += resDepartmentDetail[1];
        }


        var start_fsourceid = $("#source_start").val().substring(0,1);
        var end_fsourceid = $("#source_end").val().substring(0,1);
        var bType = $("#budgetType").val();
        if(start_fsourceid === '1' && end_fsourceid === '1'){
            nameDepartmentAll += "  (เงินงบประมาณแผ่นดิน)";
        }else if(((start_fsourceid === '2' && end_fsourceid === '9')||(start_fsourceid === '2' && end_fsourceid === '3')||(start_fsourceid === '3' && end_fsourceid === '9'))&& bType!=='3'){
            nameDepartmentAll += "  (เงินรายได้รวม)";
        }else if(start_fsourceid === '2' && end_fsourceid === '9' && bType==='3'){
            nameDepartmentAll += "  (เงินรายได้ศูนย์รวม)";
        }else if(start_fsourceid === '3' && end_fsourceid === '3'){
            nameDepartmentAll += "  (เงินทุนคณะ)";
        }else{

        }
        sendData.DEPARTMENT = nameDepartmentAll;


        var data = {
            "reportcode": $('#report_type').val(),
            "export": $(this).attr('exporttype'),
            "param": encodeURIComponent(JSON.stringify(sendData))
        };


        var url = "/api/gl/report/export?reportcode=" + data.reportcode + "&export=" + data.export + "&param=" + data.param;
        if (data.export == "pdfview") {
            var win = window.open();
            win.document.write('<title>เรียกดูรายงาน : ระบบบัญชีแยกประเภทสามมิติ</title><link href="css/font-awesome.min.css" rel="stylesheet" type="text/css"><style type="text/css"> .loading {text-align: center; position: fixed; width: 100%; height: 100%; left: 0; top: 0; background: #f1f1f1; z-index: 1000; } </style><script>function fn(){document.getElementById("loading").remove();}</script><div id="loading" class="loading"><br><br><br><br><i class="fa fa-cog fa-spin fa-2x"></i><br>กรุณารอสักครู่</div><iframe src="'+url+'" onload="fn()" name="theFrame" frameborder="0" style="position:absolute;top:0px;left:0px;right:0px;bottom:0px" height="100%" width="100%"></iframe><script>location.hash = "viewReport"</script>');
        } else {
            var win = window.open();
            win.document.write('<title>ดาวน์โหลดไฟล์ : ระบบบัญชีแยกประเภทสามมิติ</title><link href="css/font-awesome.min.css" rel="stylesheet" type="text/css"><style type="text/css"> .loading {text-align: center; position: fixed; width: 100%; height: 100%; left: 0; top: 0; background: #f1f1f1; z-index: 1000; } </style><script> function fn(){document.getElementById("loading").remove();}</script><div id="loading" class="loading"><br><br><br><br><i class="fa fa-download fa-2x"></i><br>ทำการดาวน์โหลดไฟล์</div><iframe src="'+url+'" onload="fn()" name="theFrame" frameborder="0" style="position:absolute;top:0px;left:0px;right:0px;bottom:0px" height="100%" width="100%"></iframe><script>location.hash = "viewReport"</script>');
        }



    });



});
