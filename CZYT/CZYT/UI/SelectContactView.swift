//
//  SelectContactView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/26.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class SelectContactView: UIView {
    
    var departmentID:String?
    var selectMode = false
    
    var dataSource = ContactDataSource.sharedInstance
    var contactDataSource = ContactDataSource.sharedInstance
    
    var sideView:CCSideView!
    var departmentView:DepartmentListView!
    var contactView:ContactListView!
    
    init(frame: CGRect, selectMode:Bool = false, departmentID:String = DepartmentTree.rootDepartmentID) {
        super.init(frame: frame)
        self.selectMode = selectMode
        self.departmentID = departmentID
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()
    {
        departmentView = DepartmentListView(frame: self.bounds)
        departmentView.delegate = self
        contactView = ContactListView(frame: self.bounds, selectMode: selectMode)
        sideView = CCSideView(frame: self.bounds, leftView: departmentView, contentView: contactView)
        
        self.addSubview(sideView)
        
        self.getData()
        // Do any additional setup after loading the view.
    }
    
    func getData()
    {
        if dataSource.department.count == 0 || dataSource.contact.count == 0 {
            self.showHud()
        }
        dataSource.getDepartmentList({ (result) in
            self.dataSource.getContactList(self.departmentID!, success: { (result) in
                DepartmentTree.sharedInstance().update(DepartmentTree.rootDepartmentID)
                self.departmentView.update()
                self.contactView.update(DepartmentTree.sharedInstance())
                self.dismiss()
            }) { (error) in
                self.dismiss()
            }
        }) { (error) in
            self.dismiss()
        }
    }
}

extension SelectContactView : DepartmentListViewDelegate
{
    func departmentTreeSelected(depart: DepartmentTree) {
        sideView.hide()
        contactView.update(depart)
    }
}
