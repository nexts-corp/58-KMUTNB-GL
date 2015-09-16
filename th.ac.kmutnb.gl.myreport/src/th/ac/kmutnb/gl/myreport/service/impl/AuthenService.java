/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.service.impl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import th.ac.kmutnb.gl.myreport.entity.User;
import th.co.bpg.cde.aaa.CAccount;
import th.co.bpg.cde.aaa.CIAuthentication;
import th.co.bpg.cde.core.CServiceBase;
import th.co.bpg.cde.data.CDataContext;

/**
 *
 * @author somchit
 */
public class AuthenService extends CServiceBase implements CIAuthentication {

    private CDataContext dbcon;

    public AuthenService() {
        this.dbcon = this.getDataContext("default");
    }

    @Override
    public CAccount signin(String Username, String Password) {
        if (this.Login2DB3D(Username, Password)) {
            String sql = "SELECT * FROM MASTER3D.SYSUSER WHERE DBLOGIN=?1 ";
            List<User> us = (List<User>) this.dbcon.nativeQuery(User.class, sql, Username);

            if (us != null && !us.isEmpty()) {
                CAccount acc = new CAccount();
                acc.setCode(Username);
                acc.setName(us.get(0).getFullName());
                acc.setDataDomain(us.get(0).getDepartmentId() + "");
                acc.setRole(us.get(0).getGroupId() + "");
                acc.setResources(new ArrayList<String>());

                return acc;
            }
        }
        return null;
    }

    public boolean Login2DB3D(String userName, String password) {
        try {
            Connection conn = null;
            Properties connectionProps = new Properties();
            connectionProps.put("user", userName);
            connectionProps.put("password", password);
            Class.forName("oracle.jdbc.OracleDriver");
            //DriverManager.registerDriver(new oracle.jdbc.OracleDriver());

            conn = DriverManager.getConnection("jdbc:oracle:thin:@25.32.200.27:1521:gl3d", connectionProps);

            conn.close();
            return true;
        } catch (ClassNotFoundException | SQLException ex) {
            return false;
        }
    }

    @Override
    public boolean signout() {
        return true;
    }

    @Override
    public CAccount info() {
        return this.account;
    }

}
