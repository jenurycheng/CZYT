//
//  CreateGroupViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/15.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
        
        selectContactView = SelectContactView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight() - 64 - 50), selectMode: true)
        self.view.addSubview(selectContactView)
        
        selectContactView.contactView.selectedIds.append(UserInfo.sharedInstance.id!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func create()
    {
        if selectContactView.contactView.selectedIds.count == 0 {
            MBProgressHUD.showMessag("请选择要加入的群成员", to: self.view, showTimeSec: 1)
            return
        }
        
        let alert = UIAlertView(title: "", message: "输入讨论组名称", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        let nameTextField = alert.textField(at: 0)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count > 20 && !Helper.isStringEmpty(string) {
            return false
        }
        return true
    }
}

extension CreateGroupViewController : UIAlertViewDelegate
{
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1
        {
            let text = alertView.textField(at: 0)?.text
            if !Helper.isStringEmpty(text) {
                self.view.showHud()
                apiDataSource.createGroup(selectContactView.contactView.selectedIds, groupName: text!, success: { (result) in
                    self.view.dismiss()
                    MBProgressHUD.showMessag("创建成功", to: self.view.window, showTimeSec: 1)
                    self.navigationController?.popViewController(animated: true)
                    
                    let msg = RCTextMessage()
                    msg.content = "我创建了讨论组"
                    let name = UserInfo.sharedInstance.nickname == nil ? "" : UserInfo.sharedInstance.nickname!
                    RCIM.shared().sendMessage(RCConversationType.ConversationType_GROUP, targetId: result.groupId, content: msg, pushContent: "\(name)邀请你加入了讨论组", pushData: "\(UserInfo.sharedInstance.nickname!)邀请你加入了讨论组", success: { (code) in
                        
                        }, error: { (errorCode, code) in
                            
                    })
                }) { (error) in
                    self.view.dismiss()
                    MBProgressHUD.showMessag(error.msg, to: self.view, showTimeSec: 1)
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.5)) / Double(NSEC_PER_SEC), execute: {
                    MBProgressHUD.showError("名称不能为空", to: self.view)
                })
                
            }
        }
    }
}
