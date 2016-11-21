//
//  GroupDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/17.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class GroupDetailViewController: BasePortraitViewController {

    var groupId:String?
    var collectionView:UICollectionView!
    var dataSource = ChatDataSource()
    
    var deleteBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView = UICollectionView(frame: CGRectMake(0, 0, GetSWidth(), GetSHeight()-64), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = ThemeManager.current().backgroundColor
        self.view.addSubview(collectionView)
        collectionView.registerNib(UINib(nibName: "GroupUserCell", bundle: nil), forCellWithReuseIdentifier: "GroupUserCell")
        collectionView.registerNib(UINib(nibName: "GroupLineCell", bundle: nil), forCellWithReuseIdentifier: "GroupLineCell")
        collectionView.registerClass(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.registerClass(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "UICollectionReusableView")
        
        self.getGroupUser()
        
        deleteBtn = UIButton(frame: CGRect(x: 10, y: 20, width: GetSWidth()-20, height: 40))
        deleteBtn.backgroundColor = UIColor.redColor()
        deleteBtn.setTitle("退出群组", forState: .Normal)
        deleteBtn.layer.cornerRadius = 5
        deleteBtn.layer.masksToBounds = true
        deleteBtn.addTarget(self, action: #selector(GroupDetailViewController.deleteBtnClicked), forControlEvents: .TouchUpInside)
        // Do any additional setup after loading the view.
    }
    
    func deleteBtnClicked()
    {
        if UserInfo.sharedInstance.id == self.dataSource.groupDetail?.create_user_id {
            dataSource.destoryGroup(UserInfo.sharedInstance.id!, groupId: self.groupId!, success: { (result) in
                MBProgressHUD.showMessag("解散成功", toView: self.view.window, showTimeSec: 1)
                }, failure: { (error) in
                    MBProgressHUD.showMessag(error.msg, toView: self.view.window, showTimeSec: 1)
            })
        }else{
            dataSource.quitGroup([UserInfo.sharedInstance.id!], groupId: self.groupId!, success: { (result) in
                MBProgressHUD.showMessag("退出成功", toView: self.view.window, showTimeSec: 1)
                }, failure: { (error) in
                    MBProgressHUD.showMessag(error.msg, toView: self.view.window, showTimeSec: 1)
            })
        }
    }
    
    func getGroupUser()
    {
        if groupId != nil {
            dataSource.queryGroupDetail(groupId!, success: { (result) in
                self.collectionView.reloadData()
                self.title = self.dataSource.groupDetail?.groupName
                if self.dataSource.groupDetail?.create_user_id == UserInfo.sharedInstance.id
                {
                    self.deleteBtn.setTitle("解散群组", forState: .Normal)
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
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
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
            
        }
    }
}

//MARK: UICollectionViewDataSource
extension GroupDetailViewController : UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "UICollectionReusableView", forIndexPath: indexPath)
        view.backgroundColor = ThemeManager.current().backgroundColor
        return view
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GroupUserCell", forIndexPath: indexPath) as! GroupUserCell
            if indexPath.row < dataSource.groupDetail!.users!.count {
                cell.update(dataSource.groupDetail!.users![indexPath.row])
            }else{
                cell.updateToAddBtn()
            }
            
            return cell
        }else if indexPath.section == 1
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GroupLineCell", forIndexPath: indexPath) as! GroupLineCell
            
            if indexPath.row == 0
            {
                cell.nameLabel.text = "群名称"
                cell.detailLabel.text = dataSource.groupDetail?.groupName
                cell.backgroundColor = ThemeManager.current().foregroundColor
            }
            return cell
            
        }else if indexPath.section == 2
        {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UICollectionViewCell", forIndexPath: indexPath)
            cell.addSubview(deleteBtn)
            cell.backgroundColor = ThemeManager.current().backgroundColor
            return cell
        }
        return collectionView.dequeueReusableCellWithReuseIdentifier("", forIndexPath: indexPath)
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension GroupDetailViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return GroupUserCell.cellSize()
        }else if indexPath.section == 1
        {
            return CGSizeMake(GetSWidth(), 45)
        }else if indexPath.section == 2
        {
            return CGSizeMake(GetSWidth(), 100)
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSizeMake(GetSWidth(), 0)
    }
}
