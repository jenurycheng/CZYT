//
//  UserInfo.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class UserInfo: Reflect {
    
    class var sharedInstance : UserInfo
    {
        struct Instance{
            static let instance:UserInfo = UserInfo()
        }
        return Instance.instance
    }
    
    required init() {
        super.init()
        self.addObserver(self, forKeyPath: "isLogin", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit{
        self.removeObserver(self, forKeyPath: "isLogin")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        switch keyPath!
        {
            case "isLogin":
                if isLogin
                {
//                    ChatDataSource.sharedInstance.queryUserGroup(UserInfo.sharedInstance.id!, success: { (result) in
//                    }) { (error) in
//                    }
                }else{
                    RCIMClient.sharedRCIMClient().disconnect(false)
                }
            break
        default:
            break
        }
    }
    
    func update(user:UserInfo)
    {
        self.id = user.id
        self.birthday = user.birthday
        self.nickname = user.nickname
        self.address = user.address
        self.token = user.token
        self.logo_path = user.logo_path
        self.gender = user.gender
        self.mobile = user.mobile
        self.session = user.session
        self.dept_id = user.dept_id
        self.dept_name = user.dept_name
    }
    dynamic var isLogin:Bool = false
    
    var id:String?
    var birthday:String?
    var nickname:String?
    var address:String?
    var token:String?
    var logo_path:String?
    var gender:String?
    var mobile:String = ""
    var session:String = ""
    var dept_id:String?
    var dept_name:String?
    
    var USER_DEFAULT_USERNAME = "USER_DEFAULT_USERNAME"
    var USER_DEFAULT_PASSWORD = "USER_DEFAULT_PASSWORD"
    
    func setUserName(username:String, pwd:String)
    {
        let dic = NSUserDefaults.standardUserDefaults()
        dic.setObject(username, forKey: USER_DEFAULT_USERNAME)
        dic.setObject(pwd, forKey: USER_DEFAULT_PASSWORD)
        dic.synchronize()
    }
    
    func getUserNamePwd()->(username:String?, pwd:String?)
    {
        let dic = NSUserDefaults.standardUserDefaults()
        let username = dic.objectForKey(USER_DEFAULT_USERNAME) as? String
        let pwd = dic.objectForKey(USER_DEFAULT_PASSWORD) as? String
        
        return (username, pwd)
    }
}
