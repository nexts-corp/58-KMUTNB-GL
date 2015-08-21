<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="left_nav_slidebar">
    <ul>
        <li class="left_nav_active theme_border"> <a href="javascript:void(0);"><i class="fa fa-list-alt"></i> รายงาน  <span class="plus"><i class="fa fa-plus"></i></span> </a>
            <ul class="opened" style="display:block;padding-left: 15px;">
                <li> <a href="api/myreport/report/form/RPT05" alink><b>รายงานฐานะการเงิน</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT06" alink><b>รายงานงบรายได้และค่าใช้จ่าย</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT03" alink><b>รายงานรายละเอียดประกอบงบแสดงฐานะการเงิน</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT04" alink><b>รายงานรายละเอียดประกอบงบรายได้และค่าใช้จ่าย</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT07" alink><b>รายงานกระดาษทำการ</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT10" alink><b>รายงานวิเคราะห์งบการเงิน</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT09" alink><b>รายงานงบกระแสเงินสด</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT01" alink><b>รายงานงบทดลอง</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT02" alink><b>รายงานบัญชีแยกประเภท</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT11" alink><b>รายงานค้ำประกันสัญญา (รายสัญญา)</b> </a> </li>
                <li> <a href="api/myreport/report/form/RPT12" alink><b>รายงานค้ำประกันซอง (รายบริษัท)</b> </a> </li>
            </ul>
        </li>
        <li> <a href="javascript:void(0);"> <i class="fa fa-files-o"></i> เพิ่มเติม <span class="plus"><i class="fa fa-plus"></i></span></a>
            <ul style="padding-left: 15px;">
                <li> <a href="api/myreport/report/form/RPT08" alink> <b>รายงานเงินรายจ่ายของมหาวิทยาลัย</b></a> </li>
            </ul>
        </li>
        <li> <a href="javascript:void(0);"> <i class="fa fa-gear"></i> ตั้งค่า <span class="plus"><i class="fa fa-plus"></i></span></a>
            <ul style="padding-left: 15px;">
                <li> <a href="manage_user.html"><b>จัดการผู้ใช้งาน</b> </a> </li>
                <li> <a href="animations.html"><b>ช่วยเหลือ</b> </a> </li>
                <li> <a href="animations.html"><b>ออกจากระบบ</b> </a> </li>
            </ul>
        </li>

    </ul>
</div>

<script language="javascript">
    $(document).ready(function () {

        $("[alink]").on("click", function (e) {
            e.preventDefault();
            getContent($(this).attr("href"),$(this),function(ithis){
                $("[alink]").find('b').removeClass('theme_color');
                ithis.find('b').addClass('theme_color');
            });
        });
        
        function getContent(link,ithis,callback) {
            $.get(link,function (data, status) {
                $('.contentpanel').html(data);
                resetFormSpecial();
                callback(ithis);
            });
        }

    });
</script>