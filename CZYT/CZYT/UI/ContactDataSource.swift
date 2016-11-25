//
//  ContactDataSource.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/18.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class ContactDataSource: NSObject {
    
    class var sharedInstance : ContactDataSource
    {
        struct Instance{
            static let instance:ContactDataSource = ContactDataSource()
        }
        return Instance.instance
    }
    
    func getDepartment(id:String)->Department?
    {
        for d in department
        {
            if d.dept_id == id
            {
                return d
            }
        }
        return nil
    }
    
    var department = [Department]()
    func getDepartmentList(success:((result:[Department]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestGetDepartmentList()
        NetWorkHandle.NetWorkHandleUser.getDepartmentList(request) { (data) in
            if data.isSuccess()
            {
                let r = data.data as? Array<NSDictionary>
                var array = [Department]()
                if r != nil
                {
                    for dic in r!
                    {
                        let d = Department.parse(dict: dic)
                        array.append(d)
                    }
                }
                self.department = array
                success(result: array)
            }else{
                failure(error: data)
            }
        }
    }
    
    func getUser(departId:String)->[UserInfo]
    {
        var users = [UserInfo]()
        for u in contact
        {
            if u.dept_id == departId
            {
                users.append(u)
            }
        }
        return users
    }
    
    func getUserInfo(id:String)->UserInfo?
    {
        for u in contact
        {
            if u.id == id
            {
                return u
            }
        }
        return nil
    }
    
    var contact = [UserInfo]()
    func getContactList(groupId:String, success:((result:[UserInfo]) -> Void), failure:((error:HttpResponseData)->Void))
    {
        let request = NetWorkHandle.NetWorkHandleUser.RequestGetContactList()
        request.dept_id = groupId
        NetWorkHandle.NetWorkHandleUser.getContactList(request) { (data) in
            if data.isSuccess()
            {
                var array = [UserInfo]()
                let r = data.data as? Array<NSDictionary>
                if r != nil
                {
                    for dic in r!
                    {
                        let u = UserInfo.parse(dict: dic)
                        array.append(u)
                    }
                }
                self.contact = array
                success(result: array)
            }else{
                failure(error: data)
            }
        }
    }
}

class DepartmentTree : NSObject
{
    private static var single:DepartmentTree?
    class func sharedInstance()->DepartmentTree
    {
        if single == nil
        {
            single = DepartmentTree()
        }
        return single!
    }
    
    func update(id:String)
    {
        DepartmentTree.allSubTree.removeAll()
        DepartmentTree.single = DepartmentTree(id: id)
    }
    
    static let rootDepartmentID = "1"
    static var allSubTree = [DepartmentTree]()
    
    var id:String = DepartmentTree.rootDepartmentID
    var level = 0
    var department:Department?
    var users = [UserInfo]()
    var subDepartment = [Department]()
    
    override init() {
        super.init()
    }
    
    init(id:String, level:Int = 0) {
        super.init()
        self.id = id
        self.level = level
        
        self.initDepartment()
    }
    
    func initDepartment()
    {
        department = ContactDataSource.sharedInstance.getDepartment(id)
        if department == nil
        {
            return
        }
        DepartmentTree.allSubTree.append(self)
        
        for user in ContactDataSource.sharedInstance.contact
        {
            if user.dept_id == id
            {
                self.users.append(user)
            }
        }
        
        for depart in ContactDataSource.sharedInstance.department
        {
            if depart.dept_parent_id == id && !Helper.isStringEmpty(depart.dept_id)
            {
                
                let tree = DepartmentTree(id: depart.dept_id!, level: self.level + 1)
                self.users.appendContentsOf(tree.users)
                self.subDepartment.append(depart)
            }
        }
    }
    
}
