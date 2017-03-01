//
//  SelectContactViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class SelectContactViewController: BasePortraitViewController {
    
    var callback:((selectedIds:[String])->Void)?

    var okBtn:UIButton!
    
    var selectedIds = [String]()
    var selectContactView:SelectContactView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "被指派人"
        
        selectContactView = SelectContactView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64-50), selectMode:true, departmentID: DepartmentTree.rootDepartmentID)
//        selectContactView.contactView.maxSelectCount = 2
//        selectContactView.contactView.showMaxCountText = "最多可以选择一个主办人和协办人"
        selectContactView.contactView.selectedIds.appendContentsOf(self.selectedIds)
        self.view.addSubview(selectContactView)
        
        okBtn = UIButton(frame: CGRect(x: 10, y: GetSHeight()-64-45, width: GetSWidth()-20, height: 40))
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.setTitle("确定", forState: .Normal)
        okBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        okBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds = true
        okBtn.addTarget(self, action: #selector(SelectContactViewController.okBtnClicked), forControlEvents: .TouchUpInside)
        self.view.addSubview(okBtn)
        // Do any additional setup after loading the view.
    }
    
    func addCallback(callback:((selectedIds:[String])->Void)?)
    {
        self.callback = callback
    }
    
    func okBtnClicked()
    {
        if selectContactView.contactView.selectedIds.count == 0
        {
            MBProgressHUD.showMessag("至少选择一位主办人", toView: self.view, showTimeSec: 1)
            return
        }
        if callback != nil
        {
            callback!(selectedIds:selectContactView.contactView.selectedIds)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
