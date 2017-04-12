//
//  BBSModel.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/12.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BBS: EVObject {
    var comment_count:String?
    var summary:String?
    var id:String?
    var classify:String?
    var browser_count:String?
    var title:String?
    var publish_date:String?
    var logo_path:String?
    var original:String?
    var exchange_istop:String?
    var publish_user_id:String?
    var publish_user_name:String?
    var publish_user_logo_path:String?
    
    func isTop()->Bool
    {
        return exchange_istop == "1" ? true : false
    }
}

class BBSDetail : EVObject
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
    var exchange_istop:String?
    var publish_user_id:String?
    var publish_user_name:String?
    var publish_user_logo_path:String?
    func isTop()->Bool
    {
        return exchange_istop == "1" ? true : false
    }
    
}

class BBSComment : EVObject
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
    var publish_user_logo_path:String?
    var receiver_user_id:String?
    var receiver_user_name:String?
    var parent_comment_id:String?
    var children:[BBSComment]?
}
