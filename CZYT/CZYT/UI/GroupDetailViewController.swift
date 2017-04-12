//
//  GroupDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/17.
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


class GroupDetailViewController: BasePortraitViewController {

    var groupId:String?
    var collectionView:UICollectionView!
    var dataSource = ChatDataSource()
    
    var deleteBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: GetSWidth(), height: GetSHeight()-64), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ThemeManager.current().backgroundColor
        self.view.addSubview(collectionView)
        collectionView.register(UINib(nibName: "GroupUserCell", bundle: nil), forCellWithReuseIdentifier: "GroupUserCell")
        collectionView.register(UINib(nibName: "GroupLineCell", bundle: nil), forCellWithReuseIdentifier: "GroupLineCell")
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        
        deleteBtn = UIButton(frame: CGRect(x: 10, y: 20, width: GetSWidth()-20, height: 40))
        deleteBtn.backgroundColor = UIColor.red
        deleteBtn.setTitle("退出讨论组", for: UIControlState())
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.layer.masksToBounds = true
        deleteBtn.addTarget(self, action: #selector(GroupDetailViewController.deleteBtnClicked), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func deleteBtnClicked()
    {
        if UserInfo.sharedInstance.id == self.dataSource.groupDetail?.create_user_id {
            dataSource.destoryGroup(UserInfo.sharedInstance.id!, groupId: self.groupId!, success: { (result) in
                MBProgressHUD.showMessag("解散成功", to: self.view.window, showTimeSec: 1)
                self.quitSuccess()
                }, failure: { (error) in
                    MBProgressHUD.showMessag(error.msg, to: self.view.window, showTimeSec: 1)
            })
        }else{
            dataSource.quitGroup([UserInfo.sharedInstance.id!], groupId: self.groupId!, success: { (result) in
                MBProgressHUD.showMessag("退出成功", to: self.view.window, showTimeSec: 1)
                self.quitSuccess()
                }, failure: { (error) in
                    MBProgressHUD.showMessag(error.msg, to: self.view.window, showTimeSec: 1)
            })
        }
    }
    
    func quitSuccess()
    {
        let notify = Notification(name: Notification.Name(rawValue: ChatDataSource.NOTIFICATION_QUIT_GROUP), object: nil, userInfo: ["id":self.groupId!])
        NotificationCenter.default.post(notify)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getGroupDetail()
    }
    
    func getGroupDetail()
    {
        if groupId != nil {
            dataSource.queryGroupDetail(groupId!, success: { (result) in
                self.collectionView.reloadData()
                self.title = self.dataSource.groupDetail?.groupName
                if self.dataSource.groupDetail?.create_user_id == UserInfo.sharedInstance.id
                {
                    self.deleteBtn.setTitle("解散讨论组", for: UIControlState())
                }
            }) { (error) in
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: UICollectionViewDelegate
extension GroupDetailViewController : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            if indexPath.row < dataSource.groupDetail!.users!.count {
                let user = dataSource.groupDetail!.users![indexPath.row]
                if user.userId != UserInfo.sharedInstance.id
                {
                    let chat = PrivateConversationViewController()
                    chat.conversationType = RCConversationType.ConversationType_PRIVATE
                    chat.targetId = user.userId
                    chat.title = user.user_name
                    self.navigationController?.pushViewController(chat, animated: true)
                }
            }
            else{
                if dataSource.groupDetail != nil {
                    let add = AddGroupUserViewController(nibName: "AddGroupUserViewController", bundle: nil)
                    add.detail = dataSource.groupDetail
                    self.navigationController?.pushViewController(add, animated: true)
                }
            }
        }else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                let alert = UIAlertView(title: "", message: "修改讨论组名称", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alert.alertViewStyle = UIAlertViewStyle.plainTextInput
                let nameTextField = alert.textField(at: 0)
                nameTextField?.delegate = self
                nameTextField?.tag = 100
                nameTextField?.placeholder = "请输入讨论组名称"
                nameTextField?.text = dataSource.groupDetail?.groupName
                
                alert.show()
            }
        }
    }
}

extension GroupDetailViewController : UIAlertViewDelegate
{
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1
        {
            let text = alertView.textField(at: 0)?.text
            if !Helper.isStringEmpty(text) {
                dataSource.updateGroup(self.dataSource.groupDetail!.groupId!, groupName: text!, success: { (result) in
                    MBProgressHUD.showSuccess("修改成功", to: self.view)
                    let group = RCGroup(groupId: self.groupId, groupName: text!, portraitUri: "")
                    RCIM.shared().refreshGroupInfoCache(group, withGroupId: self.groupId)
                    self.getGroupDetail()
                    }, failure: { (error) in
                        MBProgressHUD.showError(error.msg, to: self.view)
                })
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 0.5)) / Double(NSEC_PER_SEC), execute: {
                    MBProgressHUD.showError("名称不能为空", to: self.view)
                })
                
            }
        }
    }
}

extension GroupDetailViewController : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count > 20 && !Helper.isStringEmpty(string) {
            return false
        }
        return true
    }
}

//MARK: UICollectionViewDataSource
extension GroupDetailViewController : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        view.backgroundColor = ThemeManager.current().backgroundColor
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return dataSource.groupDetail?.users?.count == nil ? 0 : dataSource.groupDetail!.users!.count + 1
        }else if section == 1
        {
            return dataSource.groupDetail?.users?.count == nil ? 0 : 1
        }else if section == 2
        {
            return dataSource.groupDetail?.users?.count == nil ? 0 : 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupUserCell", for: indexPath) as! GroupUserCell
            if indexPath.row < dataSource.groupDetail!.users!.count {
                cell.update(dataSource.groupDetail!.users![indexPath.row])
            }else{
                cell.updateToAddBtn()
            }
            
            return cell
        }else if indexPath.section == 1
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupLineCell", for: indexPath) as! GroupLineCell
            
            if indexPath.row == 0
            {
                cell.nameLabel.text = "讨论组名称"
                cell.detailLabel.text = dataSource.groupDetail?.groupName
                cell.backgroundColor = ThemeManager.current().foregroundColor
            }
            return cell
            
        }else if indexPath.section == 2
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
            cell.addSubview(deleteBtn)
            cell.backgroundColor = ThemeManager.current().backgroundColor
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension GroupDetailViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return GroupUserCell.cellSize()
        }else if indexPath.section == 1
        {
            return CGSize(width: GetSWidth(), height: 45)
        }else if indexPath.section == 2
        {
            return CGSize(width: GetSWidth(), height: 100)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSize(width: GetSWidth(), height: 0)
    }
}
