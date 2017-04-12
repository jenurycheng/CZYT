//
//  SelectContactViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class SelectContactViewController: BasePortraitViewController {
    
    var callback:((_ selectedIds:[String])->Void)?

    var okBtn:UIButton!
    
    var selectedIds = [String]()
    var selectContactView:SelectContactView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "被指派人"
        
        selectContactView = SelectContactView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64-50), selectMode:true, departmentID: DepartmentTree.rootDepartmentID)
//        selectContactView.contactView.maxSelectCount = 2
//        selectContactView.contactView.showMaxCountText = "最多可以选择一个主办人和协办人"
        selectContactView.contactView.selectedIds.append(contentsOf: self.selectedIds)
        self.view.addSubview(selectContactView)
        
        okBtn = UIButton(frame: CGRect(x: 10, y: GetSHeight()-64-45, width: GetSWidth()-20, height: 40))
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.setTitle("确定", for: UIControlState())
        okBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        okBtn.setTitleColor(UIColor.white, for: UIControlState())
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds = true
        okBtn.addTarget(self, action: #selector(SelectContactViewController.okBtnClicked), for: .touchUpInside)
        self.view.addSubview(okBtn)
        // Do any additional setup after loading the view.
    }
    
    func addCallback(_ callback:((_ selectedIds:[String])->Void)?)
    {
        self.callback = callback
    }
    
    func okBtnClicked()
    {
        if selectContactView.contactView.selectedIds.count == 0
        {
            MBProgressHUD.showMessag("至少选择一位主办人", to: self.view, showTimeSec: 1)
            return
        }
        if callback != nil
        {
            callback!(selectContactView.contactView.selectedIds)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
