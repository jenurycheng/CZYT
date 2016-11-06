//
//  TabBar.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

protocol TabBarDelegate : NSObjectProtocol {
    func tabBarClickedIndex(tabBar:TabBar, index:Int)
}

class TabBar: UIView {

    var doneBtn:TabBarButton!
    var mainBtn:TabBarButton!
    var userCenterBtn:UIButton!
    var chatBtn:TabBarButton!
    var userBtn:TabBarButton!
    var selectedBtn:TabBarButton?
    weak var delegate:TabBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView()
    {
        self.backgroundColor = ThemeManager.current().foregroundColor
        
        let width = self.frame.size.width / 4
        let height = self.frame.size.height
        
        mainBtn = TabBarButton(frame: CGRectMake(0, 0, width, height), text: "首页", icon: "home_main", selectedIcon: "home_main_h")
        doneBtn = TabBarButton(frame: CGRectMake(width * 1, 0, width, height), text: "督办", icon: "home_done", selectedIcon: "home_done_h")
        chatBtn = TabBarButton(frame: CGRectMake(width * 2, 0, width, height), text: "会话", icon: "home_chat", selectedIcon: "home_chat_h")
        userBtn = TabBarButton(frame: CGRectMake(width * 3, 0, width, height), text: "我的", icon: "home_user", selectedIcon: "home_user_h")
        
        mainBtn.tag = 0
        doneBtn.tag = 1
        chatBtn.tag = 2
        userBtn.tag = 3
        
        mainBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), forControlEvents: .TouchUpInside)
        doneBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), forControlEvents: .TouchUpInside)
        chatBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), forControlEvents: .TouchUpInside)
        userBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), forControlEvents: .TouchUpInside)
     
        self.addSubview(mainBtn)
        self.addSubview(doneBtn)
        self.addSubview(chatBtn)
        self.addSubview(userBtn)
        
        let topline = UIView(frame: CGRectMake(0, 0, self.frame.size.width, 1))
        topline.backgroundColor = ThemeManager.current().backgroundColor
        self.addSubview(topline)
        
        self.selectedBtn(mainBtn)
    }
    
    func btnClicked(btn:TabBarButton)
    {
        let tag = btn.tag
        if delegate != nil {
            delegate?.tabBarClickedIndex(self, index: tag)
        }
        self.selectedBtn(btn)
    }
    
    func selectedBtn(btn:TabBarButton)
    {
        if selectedBtn != nil{
            selectedBtn?.nameLabel.textColor = ThemeManager.current().grayFontColor
            selectedBtn?.iconImageView.image = UIImage(named: selectedBtn!.icon!)
        }
        btn.nameLabel.textColor = ThemeManager.current().mainColor
        btn.iconImageView.image = UIImage(named: btn.selectedIcon!)
        
        selectedBtn = btn
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

class TabBarButton : UIButton
{
    var text:String?
    var icon:String?
    var selectedIcon:String?
    
    var iconImageView:UIImageView!
    var nameLabel:UILabel!
    
    init(frame: CGRect, text:String, icon:String, selectedIcon:String) {
        super.init(frame: frame)
        self.text = text
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initButton()
    {
        iconImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20))
        iconImageView.contentMode = .Center
        iconImageView.image = UIImage(named: icon!)
        self.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20))
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.textColor = ThemeManager.current().darkGrayFontColor
        nameLabel.text = text
        nameLabel.font = UIFont.systemFontOfSize(14)
        self.addSubview(nameLabel)
    }
}
