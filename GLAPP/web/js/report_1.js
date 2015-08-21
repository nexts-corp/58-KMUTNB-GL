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
    ;

    $.post("/api/gl/form/user", {}, function (data) {
        $(".user_adminname").text(data.user);
        UCheckAjaxLoad("user");
    }).fail(eror_401);

    function ksCallBack(run, callback) {
        var data = run();
        callback(data);
    }
    ;

    function selectFristLast(name) {

        $(name).eq(0).find('option[style*="display: block"]').first().attr("selected", true);
        $(name).eq(1).find('option[style*="display: block"]').last().attr("selected", true);
        //alert($(name).find("option").first().val());
        //alert($(name).find('option[style*="display: block"]').last().val());
        $(name).trigger("chosen:updated");
        
    }
    

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
    ;

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
            alert(7);
            $(optionName).find("option").hide();
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




        var strDepartment = $("#department option:selected").text();
        var resDepartment = strDepartment.split(":");
        var nameDepartmentAll = "";
        if ($("#department").val() != "0") {
            nameDepartmentAll = resDepartment[1] + "\n";
        }


        if (($("#department").val() != sendData.DEPARTMENT_SORCE_START) && sendData.DEPARTMENT_SORCE_START == sendData.DEPARTMENT_SORCE_END) {
            var strDepartmentDetail = $("#department_start option:selected").text();
            var resDepartmentDetail = strDepartmentDetail.split(":");

            nameDepartmentAll += resDepartmentDetail[1];
        }

        if ($("#budgetType").val() != "1") {
            nameDepartmentAll += "  (" + $("#budgetType option:selected").text() + ")";
        }

        sendData.DEPARTMENT = nameDepartmentAll;


        var data = {
            "reportcode": $('#report_type').val(),
            "export": $(this).attr('exporttype'),
            "param": encodeURIComponent(JSON.stringify(sendData))
        };

        var url = "/api/gl/report/export?reportcode=" + data.reportcode + "&export=" + data.export + "&param=" + data.param;
        if (data.export == "pdfview") {
            //window.open("viewreport.html",'theFrame');
            var win = window.open();
            win.document.write('<title>เรียกดูรายงาน : ระบบบัญชีแยกประเภทสามมิติ</title><iframe src="'+url+'" name="theFrame" frameborder="0" style="position:absolute;top:0px;left:0px;right:0px;bottom:0px" height="100%" width="100%"></iframe><script>location.hash = "viewReport"</script>')
        } else {
            window.location.href = url;
        }


    });

});
