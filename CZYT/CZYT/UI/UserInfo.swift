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
                    UserDataSource().updateUserToken(Consts.DeviceToken, success: { (result) in
                        
                        }, failure: { (error) in
                            
                    })
                    UserInfo.write(UserInfo.sharedInstance)
                }else{
                    RCIMClient.sharedRCIMClient().disconnect(false)
                    UserInfo.write(nil)
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
    
    static var USER_DEFAULT_ID = "USER_DEFAULT_ID"
    static var USER_DEFAULT_NICKNAME = "USER_DEFAULT_NICKNAME"
    static var USER_DEFAULT_TOKEN = "USER_DEFAULT_TOKEN"
    static var USER_DEFAULT_LOGO = "USER_DEFAULT_LOGO"
    static var USER_DEFAULT_MOBILE = "USER_DEFAULT_MOBILE"
    static var USER_DEFAULT_SESSION = "USER_DEFAULT_SESSION"
    static var USER_DEFAULT_DEPT_ID = "USER_DEFAULT_DEPT_ID"
    static var USER_DEFAULT_DEPT_NAME = "USER_DEFAULT_DEPT_NAME"
    
    class func write(ui:UserInfo?)
    {
        let dic = NSUserDefaults.standardUserDefaults()
        dic.setObject(ui?.id, forKey: USER_DEFAULT_ID)
        dic.setObject(ui?.nickname, forKey: USER_DEFAULT_NICKNAME)
        dic.setObject(ui?.token, forKey: USER_DEFAULT_TOKEN)
        dic.setObject(ui?.logo_path, forKey: USER_DEFAULT_LOGO)
        dic.setObject(ui?.mobile, forKey: USER_DEFAULT_MOBILE)
        dic.setObject(ui?.session, forKey: USER_DEFAULT_SESSION)
        dic.setObject(ui?.dept_id, forKey: USER_DEFAULT_DEPT_ID)
        dic.setObject(ui?.dept_name, forKey: USER_DEFAULT_DEPT_NAME)
        dic.synchronize()
    }
    
    class func read()->UserInfo?
    {
        let dic = NSUserDefaults.standardUserDefaults()
        
        let ui = UserInfo()
        ui.id = dic.objectForKey(USER_DEFAULT_ID) as? String
        ui.nickname = dic.objectForKey(USER_DEFAULT_NICKNAME) as? String
        ui.token = dic.objectForKey(USER_DEFAULT_TOKEN) as? String
        ui.logo_path = dic.objectForKey(USER_DEFAULT_LOGO) as? String
        ui.mobile = dic.objectForKey(USER_DEFAULT_MOBILE) as? String ?? ""
        ui.session = dic.objectForKey(USER_DEFAULT_SESSION) as? String ?? ""
        ui.dept_id = dic.objectForKey(USER_DEFAULT_DEPT_ID) as? String
        ui.dept_name = dic.objectForKey(USER_DEFAULT_DEPT_NAME) as? String
        
        if ui.id == nil
        {
            return nil
        }else{
            return ui
        }
    }
}
