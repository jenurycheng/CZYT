//
//  BBSModel.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBS: Reflect {
    var comment_count:String?
    var summary:String?
    var id:String?
    var classify:String?
    var browser_count:String?
    var title:String?
    var publish_date:String?
    var logo_path:String?
    var original:String?
}

class BBSDetail : Reflect
{
    var id:String?
    var title:String?
    var logo_path:String?
    var classify:String?
    var summary:String?
    var original:String?
    var publish_date:String?
    var browser_count:String?
    var comment_count:String?
    var content:String?
}

class BBSComment : Reflect
{
    func getContent()->String?
    {
        return content == nil ? message : content
    }
    var exchange_id:String?
    var comment_id:String?
    var content:String?
    var message:String?
    var publish_user_id:String?
    var publish_user_name:String?
    var publish_date:String?
    var receiver_user_id:String?
    var receiver_user_name:String?
}