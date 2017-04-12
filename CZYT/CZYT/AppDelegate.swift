//
//  AppDelegate.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let nav = BaseOrientationNavViewController(rootViewController: MainViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        self.initThird()
        
        self.initNavigationBar()
        self.initRemoteNotify()

        if launchOptions != nil {
            //处理推送消息
            self.dealPushMessage(launchOptions!)
        }
        
        //是否保存了登录信息
        let ui = UserInfo.read()
        if ui != nil
        {
            UserInfo.sharedInstance.update(ui!)
            UserInfo.sharedInstance.isLogin = true
        }
        
        LaunchAdverScreen.show()
        
        return true
    }
    
    func initThird()
    {
        //消息推送
        UMessage.start(withAppkey: Consts.umengAppKey, launchOptions: nil)
        UMessage.setLogEnabled(true)
        UMessage.setAutoAlert(false)
        
        UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = Consts.umengAppKey
        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
        
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx8fa7f17064cd2dcf", appSecret: "e22baf2557c9a1d872eac16d877272fd", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.wechatFavorite)
        
        let type1 = UMSocialPlatformType(rawValue: 1500)
        UMSocialUIManager.addCustomPlatformWithoutFilted(type1!, withPlatformIcon: UIImage(named: "task_msg"), withPlatformName: "短信")
        let type2 = UMSocialPlatformType(rawValue: 1501)
        UMSocialUIManager.addCustomPlatformWithoutFilted(type2!, withPlatformIcon: UIImage(named: "link_small"), withPlatformName: "复制链接")
        
//        UMSocialManager.defaultManager().setPlaform(UMSocialPlatformType.QQ, appKey: "1104491791", appSecret: "DIeHXRrC1DCVn3ru", redirectURL: "http://mobile.umeng.com/social")
        
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "2762936634", appSecret: "49b8ef0beca28cace2e3372f8b936aa1", redirectURL: "https://sns.whalecloud.com/sina2/callback")
        
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "1106074872", appSecret: "wdmXjT8EZYZ1rV7W", redirectURL: "http://mobile.umeng.com/social")
        
//        UMSocialManager.defaultManager().setPlaform(UMSocialPlatformType.Sina, appKey: "2762936634", appSecret: "49b8ef0beca28cace2e3372f8b936aa1", redirectURL: "https://sns.whalecloud.com/sina2/callback")
        
        
        RCIM.shared().initWithAppKey(Consts.RCIMAppKey)//server:4yqYEo2DDgWPx
        //        RCIM.sharedRCIM().initWithAppKey("25wehl3uwhwew")
        RCIM.shared().userInfoDataSource = self
        RCIM.shared().groupInfoDataSource = self
        
        
    }
    
    func initNavigationBar()
    {
        let bar = UINavigationBar.appearance()
        bar.barTintColor = ThemeManager.current().mainColor
        bar.tintColor = ThemeManager.current().whiteFontColor
        bar.isTranslucent = false
        var dic = Dictionary<String, AnyObject>()
        dic.updateValue(ThemeManager.current().whiteFontColor, forKey: NSForegroundColorAttributeName)
        bar.titleTextAttributes = dic
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
    }
    
    func initRemoteNotify(){
        
        if UIApplication.shared.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:)))
        {
            let action1 = UIMutableUserNotificationAction()
            action1.identifier = "action1_identifier"
            action1.title = "Accept"
            action1.activationMode = UIUserNotificationActivationMode.foreground
            
            let action2 = UIMutableUserNotificationAction()
            action2.identifier = "action2_identifier"
            action2.title = "Reject"
            action2.activationMode = UIUserNotificationActivationMode.background
            action2.isAuthenticationRequired = true
            action2.isDestructive = true
            
            let categorys = UIMutableUserNotificationCategory()
            categorys.identifier = "category1"
            categorys.setActions([action1, action2], for: UIUserNotificationActionContext.default)
            
            let userSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: NSSet(object: categorys) as? Set<UIUserNotificationCategory>)
            UMessage.registerRemoteNotificationAndUserNotificationSettings(userSettings)
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        UMessage.registerDeviceToken(deviceToken)
        
        
        var tokenStr = deviceToken.description
        tokenStr = tokenStr.replacingOccurrences(of: "<", with: "").replacingOccurrences(of:">", with: "").replacingOccurrences(of:" ", with: "")
        
        CCPrint("deviceToken=======%@", tokenStr)
        Consts.DeviceToken = tokenStr
        RCIMClient.shared().setDeviceToken(tokenStr)
        
        if UserInfo.sharedInstance.isLogin
        {
            UserDataSource().updateUserToken(tokenStr, success: { (result) in
                
                }, failure: { (error) in
                    
            })
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        CCPrint(error.description)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        UMessage.didReceiveRemoteNotification(userInfo)
        CCPrint(userInfo)
        
        self.dealPushMessage(userInfo, isLaunch: false)
    }
    
    func dealPushMessage(_ userInfo: [AnyHashable: Any], isLaunch:Bool = true)
    {
        var pushServiceData:[AnyHashable: Any]?
        if isLaunch
        {
            pushServiceData = RCIMClient.shared().getPushExtra(fromLaunchOptions: userInfo)
        }else{
            pushServiceData = RCIMClient.shared().getPushExtra(fromRemoteNotification: userInfo)
        }
        CCPrint(userInfo)
        if pushServiceData != nil{
            CCPrint("融云推送消息");
            
        }else{
            CCPrint("普通推送消息");
        }
//        let alert = UIAlertView(title: "", message: userInfo.description, delegate: nil, cancelButtonTitle: "Cancel")
//        alert.show()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //        return XMShareApi.handleOpenUrl(url, delegate: nil)
        //调用其他SDK
        let path = url.absoluteString
        //其它应用传过来的文件
        if path.hasPrefix("file://") {
            let hub = MBProgressHUD.showMessag("正在储存", to: window)
            FileSharedManager.sharedManager().wirteToFile(url, callback: { (b, msg) in
                hub?.hide(false)
                MBProgressHUD.showMessag("已储存到成资合作", to: self.window, showTimeSec: 1)
            })
        }else{
            let b = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
            if !b {
                //other
            }
            return b
        }
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let b = UMSocialManager.default().handleOpen(url)
        if !b {
            //other
        }
        return b
    }
}

extension AppDelegate : RCIMUserInfoDataSource, RCIMGroupInfoDataSource
{
    /*!
     获取用户信息
     
     @param userId      用户ID
     @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
     
     @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
     在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
     */
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        UserDataSource().getUserDetail(userId, success: { (result) in
            let info = RCUserInfo(userId: result.id, name: result.nickname, portrait: result.logo_path)
            completion(info)
            }) { (error) in
        }
    }
    
    func getGroupInfo(withGroupId groupId: String!, completion: ((RCGroup?) -> Void)!) {
        let g = ChatDataSource.sharedInstance.getGroup(groupId)
        if g != nil {
            let rg = RCGroup(groupId: g?.groupId, groupName: g?.groupName, portraitUri: "")
            completion(rg)
        }
        
        ChatDataSource().queryGroupDetail(groupId, success: { (result) in
            let rg = RCGroup(groupId: result.groupId, groupName: result.groupName, portraitUri: "")
            completion(rg)
            }) { (error) in
                
        }
    }
}

