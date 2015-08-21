/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package th.ac.kmutnb.gl.myreport.service.impl;

import java.util.ArrayList;
import java.util.List;
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
       
         String sql = "SELECT * FROM MASTER3D.SYSUSER WHERE DBLOGIN=?1 AND PWD=?2";
        List<User> us = (List<User>) this.dbcon.nativeQuery(User.class, sql,Username,Password);
 
        if (us != null && !us.isEmpty()) {
            CAccount acc = new CAccount();
            acc.setCode(Username);
            acc.setName(us.get(0).getFullName());
            acc.setDataDomain(us.get(0).getDepartmentId() + "");
            acc.setRole(us.get(0).getGroupId() + "");
            acc.setResources(new ArrayList<String>());
            
            return acc;
        }
        return null;
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
