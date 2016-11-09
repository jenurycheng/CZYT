//
//  ActivityModel.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class LeaderActivity: Reflect {
    var summary:String?
    var id:String?
    var classify:String?
    var title:String?
    var publish_date:String?
    var logo_path:String?
    var original:String?
}

class LeaderActivityDetail: Reflect {
    var summary:String?
    var id:String?
    var classify:String?
    var title:String?
    var publish_date:String?
    var logo_path:String?
    var original:String?
    var content:String = ""
}

class WebLink : Reflect
{
    var title:String?
    var href:String?
}

