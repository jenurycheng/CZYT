//
//  ActivityModel.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/9.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class LeaderActivity: EVObject {
    var summary:String?
    var id:String?
    var classify:String?
    var title:String?
    var publish_date:String?
    var logo_path:String?
    var original:String?
    var type:String?
    var amount:String?
    var progress:String?
}

class LeaderType : EVObject
{
    var key:String?
    var value:String?
}

class LeaderActivityDetail: EVObject {
    var summary:String?
    var id:String?
    var classify:String?
    var title:String?
    var publish_date:String?
    var logo_path:String?
    var original:String?
    var content:String = ""
    var type:String?
    var amount:String?
    var progress:String?
    var basic:String?
    var requirement:String?
    var promotion:String?
    var problem:String?
    var share_url:String?
}

class ProjectWorkDetail : EVObject
{
    var summary:String?
    var id:String?
    var classify:String?
    var title:String?
    var publish_date:String?
    var progress:String?
    var basic:String?
    var requirement:String?
    var promotion:String?
    var problem:String?
    var projectwork_basic_content:String?
    var projectwork_basic_year:String?
    var projectwork_basic_plan_age_limit:String?
    var projectwork_basic_image_progress:String?
    var projectwork_basic_ziyang_qiantou_unit:String?
    var projectwork_basic_ziyang_zeren_unit:String?
    var projectwork_basic_ziyang_zerenren:String?
    var projectwork_basic_chengdu_qiantou_unit:String?
    var projectwork_basic_chengdu_zeren_unit:String?
    var projectwork_basic_chengdu_zerenren:String?
    var projectwork_promotion_m1:String?
    var projectwork_promotion_m2:String?
    var projectwork_promotion_m3:String?
    var projectwork_promotion_m4:String?
    var projectwork_promotion_m5:String?
    var projectwork_promotion_m6:String?
    var projectwork_promotion_m7:String?
    var projectwork_promotion_m8:String?
    var projectwork_promotion_m9:String?
    var projectwork_promotion_m10:String?
    var projectwork_promotion_m11:String?
    var projectwork_promotion_m12:String?
    var projectwork_promotion_m1_isshow:String?
    var projectwork_promotion_m2_isshow:String?
    var projectwork_promotion_m3_isshow:String?
    var projectwork_promotion_m4_isshow:String?
    var projectwork_promotion_m5_isshow:String?
    var projectwork_promotion_m6_isshow:String?
    var projectwork_promotion_m7_isshow:String?
    var projectwork_promotion_m8_isshow:String?
    var projectwork_promotion_m9_isshow:String?
    var projectwork_promotion_m10_isshow:String?
    var projectwork_promotion_m11_isshow:String?
    var projectwork_promotion_m12_isshow:String?
}

class WebLink : EVObject
{
    var title:String?
    var href:String?
}

