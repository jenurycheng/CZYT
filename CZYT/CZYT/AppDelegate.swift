//
//  AppDelegate.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initNavigationBar()
        
        
        RCIM.sharedRCIM().initWithAppKey("m7ua80gbmyydm")//server:4yqYEo2DDgWPx
//        RCIM.sharedRCIM().initWithAppKey("25wehl3uwhwew")
        RCIM.sharedRCIM().userInfoDataSource = self
        RCIM.sharedRCIM().groupInfoDataSource = self
        
        return true
    }
    
    func initNavigationBar()
    {
        let nav = self.window?.rootViewController as! UINavigationController
        nav.navigationBar.barTintColor = ThemeManager.current().mainColor
        nav.navigationBar.tintColor = ThemeManager.current().whiteFontColor
        nav.navigationBar.translucent = false
        var dic = Dictionary<String, AnyObject>()
        dic.updateValue(ThemeManager.current().whiteFontColor, forKey: NSForegroundColorAttributeName)
        nav.navigationBar.titleTextAttributes = dic
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
        if userId == "3" {
            let info = RCUserInfo(userId: userId, name: "霍长江", portrait: "")
            completion(info)
        }
        else{
            let info = RCUserInfo(userId: userId, name: "待实现", portrait: "")
            completion(info)
        }
    }
    
    func getGroupInfoWithGroupId(groupId: String!, completion: ((RCGroup!) -> Void)!) {
        let g = ChatDataSource.sharedInstance.getGroup(groupId)
        if g != nil {
            let rg = RCGroup(groupId: g?.groupId, groupName: g?.groupName, portraitUri: "")
            completion(rg)
        }
    }
}

