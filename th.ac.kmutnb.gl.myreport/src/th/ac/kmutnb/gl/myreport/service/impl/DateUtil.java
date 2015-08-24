/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.service.impl;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author somchit
 */
public class DateUtil {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        // TODO code application logic here
        //System.out.println("01/11/2014=>" + FirstPeriod("01/11/2014"));
        //System.out.println("01/07/2015=>" + FirstPeriod("01/07/2015"));
        // System.out.println("01/11/2014=>" + LastPeriod("01/11/2014"));
        //System.out.println("01/07/2015=>" + LastPeriod("01/07/2015"));

//        System.err.println(DATE_Previous("31/07/2015"));

//        for (int i = 1; i < 13; i++) {
//            if (i < 10) {
//                String[] out = Period2Date("25580" + i);
//                System.out.println("Period2Date 25580" + i + "=>" + out[0] + " to " + out[1]);
//                System.out.println("FirstPeriod 25580" + i + "=>" + FirstPeriod("25580" + i));
//                System.out.println("LastPeriod 25580" + i + "=>" + LastPeriod("25580" + i));
//                System.out.println("Date2Period " + out[1] + "=>" + Date2Period(out[1]));
//                System.out.println("FirstPeriod " + out[1] + "=>" + FirstPeriod(out[1]));
//                System.out.println("LastPeriod " + out[1] + "=>" + LastPeriod(out[1]));
//                 System.out.println("Date2Thai " + out[1] + "=>" + Date2Thai(out[1]));
//            } else {
//                String[] out = Period2Date("2558" + i);
//                System.out.println("Period2Date 2558" + i + "=>" + out[0] + " to " + out[1]);
//                System.out.println("FirstPeriod 2558" + i + "=>" + FirstPeriod("2558" + i));
//                System.out.println("LastPeriod 2558" + i + "=>" + LastPeriod("2558" + i));
//                System.out.println("Date2Period " + out[1] + "=>" + Date2Period(out[1]));
//                System.out.println("FirstPeriod " + out[1] + "=>" + FirstPeriod(out[1]));
//                System.out.println("LastPeriod " + out[1] + "=>" + LastPeriod(out[1]));
//                System.out.println("Date2Thai " + out[1] + "=>" + Date2Thai(out[1]));
//            }
//        }
        //System.out.println("255802=>" + Period2Date("255802"));
    }

    public static String FirstPeriod(String startDate) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Bangkok"));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Calendar scalendar = Calendar.getInstance();
        if (startDate.length() == 10) {
            String[] aStartDate = startDate.split("/");

            int sy = Integer.parseInt(aStartDate[2]);
            int sm = Integer.parseInt(aStartDate[1]);
            int sd = Integer.parseInt(aStartDate[0]);
            scalendar.set(sy, sm - 1, sd);

            if (scalendar.get(Calendar.MONTH) >= 0 && scalendar.get(Calendar.MONTH) <= 8) {
                scalendar.set(scalendar.get(Calendar.YEAR) - 1, 10 - 1, 1);
            } else {
                scalendar.set(scalendar.get(Calendar.YEAR), 10 - 1, 1);
            }
            return sdf.format(scalendar.getTime());
        } else {
            String syear = startDate.substring(0, 4);
            return syear + "01";
        }
    }

    public static String LastPeriod(String startDate) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Bangkok"));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Calendar scalendar = Calendar.getInstance();
        if (startDate.length() == 10) {
            String[] aStartDate = startDate.split("/");
            int sy = Integer.parseInt(aStartDate[2]);
            int sm = Integer.parseInt(aStartDate[1]);
            int sd = Integer.parseInt(aStartDate[0]);
            scalendar.set(sy, sm - 1, sd);

            if (scalendar.get(Calendar.MONTH) >= 0 && scalendar.get(Calendar.MONTH) <= 8) {
                scalendar.set(scalendar.get(Calendar.YEAR), 9 - 1, 30);
            } else {
                scalendar.set(scalendar.get(Calendar.YEAR) + 1, 9 - 1, 30);
            }
            return sdf.format(scalendar.getTime());
        } else {
            String syear = startDate.substring(0, 4);
            return syear + "12";
        }
    }

    public static String[] Period2Date(String period) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Bangkok"));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Calendar scalendar = Calendar.getInstance();
        Calendar ecalendar = Calendar.getInstance();
        String syear = period.substring(0, 4);
        String smonth = period.substring(4);
        int sy = Integer.parseInt(syear) - 543;
        int sm = Integer.parseInt(smonth);
        scalendar.set(sy, sm - 1, 1);
        scalendar.add(Calendar.MONTH, -3);

        int edm = scalendar.getActualMaximum(Calendar.DAY_OF_MONTH);

        ecalendar.set(scalendar.get(Calendar.YEAR), scalendar.get(Calendar.MONTH), edm);
        String[] out = new String[]{sdf.format(scalendar.getTime()), sdf.format(ecalendar.getTime())};
        return out;
        // return sdf.format(scalendar.getTime()) + "|" + sdf.format(ecalendar.getTime());
    }

    public static String Date2Period(String date) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Bangkok"));
        SimpleDateFormat sdf = new SimpleDateFormat("MM");
        // SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
        Calendar scalendar = Calendar.getInstance();

        String[] aStartDate = date.split("/");

        int sy = Integer.parseInt(aStartDate[2]);
        int sm = Integer.parseInt(aStartDate[1]);
        int sd = Integer.parseInt(aStartDate[0]);
        scalendar.set(sy, sm - 1, sd);
        scalendar.add(Calendar.MONTH, 3);

        return (scalendar.get(Calendar.YEAR) + 543) + ""
                + sdf.format(scalendar.getTime());
    }

    public static String Date2Thai(String date) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Bangkok"));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/");
        Calendar scalendar = Calendar.getInstance();

        String[] aStartDate = date.split("/");

        int sy = Integer.parseInt(aStartDate[2]);
        int sm = Integer.parseInt(aStartDate[1]);
        int sd = Integer.parseInt(aStartDate[0]);
        scalendar.set(sy, sm - 1, sd);

        return sdf.format(scalendar.getTime()) + (scalendar.get(Calendar.YEAR) + 543);

    }

    public static String Date2Eng(String date) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Bangkok"));
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/");
        Calendar scalendar = Calendar.getInstance();

        String[] aStartDate = date.split("/");

        int sy = Integer.parseInt(aStartDate[2]);
        int sm = Integer.parseInt(aStartDate[1]);
        int sd = Integer.parseInt(aStartDate[0]);
        scalendar.set(sy, sm - 1, sd);

        return sdf.format(scalendar.getTime()) + (scalendar.get(Calendar.YEAR) - 543);

    }

    public static String currentDate() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        Date now = new Date();

        return sdf.format(now);
    }

    public static String DATE_Previous(String date) {

        DateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Date today = null;
        try {
            today = sdf.parse(date);
        } catch (ParseException ex) {
            Logger.getLogger(DateUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(today);
        calendar.add(Calendar.MONTH, -1);
        calendar.set(Calendar.DATE, calendar.getActualMaximum(Calendar.DATE));
        Date lastDayOfMonth = calendar.getTime();
         
//        System.out.println("Last Day of Month: " + sdf.format(lastDayOfMonth));
        return sdf.format(lastDayOfMonth);
    }

   

}
