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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let nav = BaseOrientationNavViewController(rootViewController: MainViewController())
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        
        self.initThird()
        
        self.initNavigationBar()
        self.initRemoteNotify()

        if launchOptions != nil {
            self.dealPushMessage(launchOptions!)
        }

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
        UMessage.startWithAppkey(Consts.umengAppKey, launchOptions: nil)
        UMessage.setLogEnabled(true)
        UMessage.setAutoAlert(false)
        
        RCIM.sharedRCIM().initWithAppKey(Consts.RCIMAppKey)//server:4yqYEo2DDgWPx
        //        RCIM.sharedRCIM().initWithAppKey("25wehl3uwhwew")
        RCIM.sharedRCIM().userInfoDataSource = self
        RCIM.sharedRCIM().groupInfoDataSource = self
    }
    
    func initNavigationBar()
    {
//        let nav = self.window?.rootViewController as! UINavigationController
//        nav.navigationBar.barTintColor = ThemeManager.current().mainColor
//        nav.navigationBar.tintColor = ThemeManager.current().whiteFontColor
//        nav.navigationBar.translucent = false
//        var dic = Dictionary<String, AnyObject>()
//        dic.updateValue(ThemeManager.current().whiteFontColor, forKey: NSForegroundColorAttributeName)
//        nav.navigationBar.titleTextAttributes = dic
        
        let bar = UINavigationBar.appearance()
        bar.barTintColor = ThemeManager.current().mainColor
        bar.tintColor = ThemeManager.current().whiteFontColor
        bar.translucent = false
        var dic = Dictionary<String, AnyObject>()
        dic.updateValue(ThemeManager.current().whiteFontColor, forKey: NSForegroundColorAttributeName)
        bar.titleTextAttributes = dic
    }
    
    func initRemoteNotify(){
        
        if UIApplication.sharedApplication().respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))
        {
            let action1 = UIMutableUserNotificationAction()
            action1.identifier = "action1_identifier"
            action1.title = "Accept"
            action1.activationMode = UIUserNotificationActivationMode.Foreground
            
            let action2 = UIMutableUserNotificationAction()
            action2.identifier = "action2_identifier"
            action2.title = "Reject"
            action2.activationMode = UIUserNotificationActivationMode.Background
            action2.authenticationRequired = true
            action2.destructive = true
            
            let categorys = UIMutableUserNotificationCategory()
            categorys.identifier = "category1"
            categorys.setActions([action1, action2], forContext: UIUserNotificationActionContext.Default)
            
            let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: NSSet(object: categorys) as? Set<UIUserNotificationCategory>)
            UMessage.registerRemoteNotificationAndUserNotificationSettings(userSettings)
            
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        UMessage.registerDeviceToken(deviceToken)
        
        
        var tokenStr = deviceToken.description
        tokenStr = tokenStr.replacingOccurrencesOfString("<", withString: "").replacingOccurrencesOfString(">", withString: "").replacingOccurrencesOfString(" ", withString: "")
        
        CCPrint("deviceToken=======%@", tokenStr)
        Consts.DeviceToken = tokenStr
        RCIMClient.sharedRCIMClient().setDeviceToken(tokenStr)
        
        if UserInfo.sharedInstance.isLogin
        {
            UserDataSource().updateUserToken(tokenStr, success: { (result) in
                
                }, failure: { (error) in
                    
            })
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        CCPrint(error.description)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        UMessage.didReceiveRemoteNotification(userInfo)
        CCPrint(userInfo)
        
        self.dealPushMessage(userInfo, isLaunch: false)
    }
    
    func dealPushMessage(userInfo: [NSObject : AnyObject], isLaunch:Bool = true)
    {
        var pushServiceData:[NSObject : AnyObject]?
        if isLaunch
        {
            pushServiceData = RCIMClient.sharedRCIMClient().getPushExtraFromLaunchOptions(userInfo)
        }else{
            pushServiceData = RCIMClient.sharedRCIMClient().getPushExtraFromRemoteNotification(userInfo)
        }
        CCPrint(userInfo)
        if pushServiceData != nil{
            CCPrint("融云推送消息");
            
        }else{
            CCPrint("普通推送消息");
        }
        let alert = UIAlertView(title: "", message: userInfo.description, delegate: nil, cancelButtonTitle: "Cancel")
        alert.show()
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate : RCIMUserInfoDataSource, RCIMGroupInfoDataSource
{
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        UserDataSource().getUserDetail(userId, success: { (result) in
            let info = RCUserInfo(userId: result.id, name: result.nickname, portrait: result.logo_path)
            completion(info)
            }) { (error) in
        }
    }
    
    func getGroupInfoWithGroupId(groupId: String!, completion: ((RCGroup!) -> Void)!) {
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

