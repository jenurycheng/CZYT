//
//  TabBar.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

protocol TabBarDelegate : NSObjectProtocol {
    func tabBarClickedIndex(_ tabBar:TabBar, index:Int)
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
        
        mainBtn = TabBarButton(frame: CGRect(x: 0, y: 0, width: width, height: height), text: "首页", icon: "home_main", selectedIcon: "home_main_h")
        doneBtn = TabBarButton(frame: CGRect(x: width * 1, y: 0, width: width, height: height), text: "督办", icon: "home_done", selectedIcon: "home_done_h")
        chatBtn = TabBarButton(frame: CGRect(x: width * 2, y: 0, width: width, height: height), text: "会话", icon: "home_chat", selectedIcon: "home_chat_h")
        userBtn = TabBarButton(frame: CGRect(x: width * 3, y: 0, width: width, height: height), text: "我的", icon: "home_user", selectedIcon: "home_user_h")
        
        mainBtn.tag = 0
        doneBtn.tag = 1
        chatBtn.tag = 2
        userBtn.tag = 3
        
        mainBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), for: .touchUpInside)
        doneBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), for: .touchUpInside)
        chatBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), for: .touchUpInside)
        userBtn.addTarget(self, action: #selector(TabBar.btnClicked(_:)), for: .touchUpInside)
     
        self.addSubview(mainBtn)
        self.addSubview(doneBtn)
        self.addSubview(chatBtn)
        self.addSubview(userBtn)
        
        let topline = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 1))
        topline.backgroundColor = ThemeManager.current().backgroundColor
        self.addSubview(topline)
        
        self.selectedBtn(mainBtn)
    }
    
    func btnClicked(_ btn:TabBarButton)
    {
        let tag = btn.tag
        if delegate != nil {
            delegate?.tabBarClickedIndex(self, index: tag)
        }
        self.selectedBtn(btn)
    }
    
    func selectedBtn(_ btn:TabBarButton)
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
        iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height-20))
        iconImageView.contentMode = .center
        iconImageView.image = UIImage(named: icon!)
        self.addSubview(iconImageView)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: self.frame.size.height - 20, width: self.frame.size.width, height: 20))
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.textColor = ThemeManager.current().darkGrayFontColor
        nameLabel.text = text
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(nameLabel)
    }
}
