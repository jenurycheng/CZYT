//
//  CreateGroupViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/15.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class CreateGroupViewController: BasePortraitViewController {

    var dataSource = ContactDataSource.sharedInstance
    var apiDataSource = ChatDataSource()
    
    var selectContactView:SelectContactView!
    
    @IBOutlet weak var createBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建讨论组"
        self.view.backgroundColor = ThemeManager.current().backgroundColor
        createBtn.backgroundColor = ThemeManager.current().mainColor
        createBtn.layer.cornerRadius = 5
        createBtn.layer.masksToBounds = true
        
        selectContactView = SelectContactView(frame: CGRectMake(0, 0, GetSWidth(), GetSHeight() - 64 - 50), selectMode: true)
        self.view.addSubview(selectContactView)
        
        selectContactView.contactView.selectedIds.append(UserInfo.sharedInstance.id!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func create()
    {
        if selectContactView.contactView.selectedIds.count == 0 {
            MBProgressHUD.showMessag("请选择要加入的群成员", toView: self.view, showTimeSec: 1)
            return
        }
        
        let alert = UIAlertView(title: "", message: "输入讨论组名称", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        let nameTextField = alert.textFieldAtIndex(0)
        nameTextField?.delegate = self
        nameTextField?.tag = 100
        nameTextField?.placeholder = "请输入讨论组名称"
        nameTextField?.text = ""
        
        alert.show()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CreateGroupViewController : UITextFieldDelegate
{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count > 20 && !Helper.isStringEmpty(string) {
            return false
        }
        return true
    }
}

extension CreateGroupViewController : UIAlertViewDelegate
{
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1
        {
            let text = alertView.textFieldAtIndex(0)?.text
            if !Helper.isStringEmpty(text) {
                self.view.showHud()
                apiDataSource.createGroup(selectContactView.contactView.selectedIds, groupName: text!, success: { (result) in
                    self.view.dismiss()
                    MBProgressHUD.showMessag("创建成功", toView: self.view.window, showTimeSec: 1)
                    self.navigationController?.popViewControllerAnimated(true)
                }) { (error) in
                    self.view.dismiss()
                    MBProgressHUD.showMessag(error.msg, toView: self.view, showTimeSec: 1)
                }
            }else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.5)), dispatch_get_main_queue(), {
                    MBProgressHUD.showError("名称不能为空", toView: self.view)
                })
                
            }
        }
    }
}
