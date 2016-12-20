//
//  ThemeManager.swift
//  GiMiHelper_3.0
//
//  Created by shuaidan on 16/8/8.
//  Copyright © 2016年 shuaidan. All rights reserved.
//

import UIKit

class ThemeManager: NSObject {

    class var sharedInstance : ThemeManager
    {
        struct Instance{
            static let instance:ThemeManager = ThemeManager()
        }
        return Instance.instance
    }
    
    class func current()->Theme
    {
        return ThemeManager.sharedInstance.currentTheme
    }
    
    var currentTheme:Theme!
    
    var defaultTheme:Theme!
    
    override init() {
        super.init()
        self.initTheme()
    }
    
    func initTheme()
    {
        defaultTheme = Theme()
        defaultTheme.mainColor = Helper.parseColor(0xDD3237FF)
        defaultTheme.secMainColor = Helper.parseColor(0x4392F3FF)
        defaultTheme.navTitleColor = UIColor.whiteColor()
        defaultTheme.backgroundColor = Helper.parseColor(0xF0F0F0FF)
        defaultTheme.foregroundColor = UIColor.whiteColor()
        defaultTheme.darkGrayFontColor = Helper.parseColor(0x333333FF)
        defaultTheme.grayFontColor = Helper.parseColor(0x848484FF)
        defaultTheme.lightGrayFontColor = Helper.parseColor(0xB0B0B0FF)
        defaultTheme.whiteFontColor = UIColor.whiteColor()
        
        currentTheme = defaultTheme
    }
}
