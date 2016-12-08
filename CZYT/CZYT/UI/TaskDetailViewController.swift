//
//  TaskDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/22.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TaskDetailViewController: BasePortraitViewController {

    var id:String?
    var isMyTask = true
    
    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var btnView:UIView!
    @IBOutlet weak var publishManLabel:UILabel!
    @IBOutlet weak var publishTimeLabel:UILabel!
    @IBOutlet weak var topView:UIView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    @IBOutlet weak var topHeight:NSLayoutConstraint!
    
    var okBtn:UIButton!
    var assignBtn:UIButton!
    
    var dataSource = TaskDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "任务详情"
        
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight() - 64 - 50
        
        okBtn = UIButton(frame: CGRect(x: 10, y: 5, width: GetSWidth()-20, height: 40))
        okBtn.backgroundColor = ThemeManager.current().mainColor
        okBtn.layer.cornerRadius = 5
        okBtn.layer.masksToBounds = true
        okBtn.setTitle("提交", forState: .Normal)
        okBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnView.addSubview(okBtn)
        okBtn.hidden = true
        okBtn.addTarget(self, action: #selector(TaskDetailViewController.okBtnClicked), forControlEvents: .TouchUpInside)
        
        assignBtn = UIButton(frame: CGRect(x: 10, y: 5, width: GetSWidth()-20, height: 40))
        assignBtn.backgroundColor = ThemeManager.current().mainColor
        assignBtn.layer.cornerRadius = 5
        assignBtn.layer.masksToBounds = true
        assignBtn.setTitle("指派", forState: .Normal)
        assignBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnView.addSubview(assignBtn)
        assignBtn.hidden = true
        assignBtn.addTarget(self, action: #selector(TaskDetailViewController.assignBtnClicked), forControlEvents: .TouchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollEnabled = false
        collectionView.registerNib(UINib(nibName: "TaskResultTopCell", bundle: nil), forCellWithReuseIdentifier: "TaskResultTopCell")
        collectionView.registerNib(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.backgroundColor = ThemeManager.current().foregroundColor
        collectionView.registerClass(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData()
    {
        if dataSource.taskDetail == nil
        {
            self.view.showHud()
        }
        dataSource.getTaskDetail(self.id!, success: { (result) in
            self.updateView()
            self.view.dismiss()
            }) { (error) in
                self.view.dismiss()
        }
    }
    
    func okBtnClicked()
    {
        if dataSource.taskDetail?.task_status == nil
        {
            return
        }
        if dataSource.taskDetail!.task_status! == "responsing"//待接受
        {
            self.view.showHud()
            dataSource.acceptTask(self.id!, success: { (result) in
                MBProgressHUD.showSuccess("接受成功", toView: self.view.window)
                MyTaskViewController.shouldReload = true
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (error) in
                    MBProgressHUD.showSuccess(error.msg, toView: self.view.window)
            })
        }else if dataSource.taskDetail!.task_status! == "finished"//已完成
        {
            let res = TaskResultViewController(nibName: "TaskResultViewController", bundle: nil)
            res.taskDetail = dataSource.taskDetail
            self.navigationController?.pushViewController(res, animated: true)
        }else if dataSource.taskDetail!.task_status! == "accepted"//已接受
        {
            let sub = SubmitTaskViewController(nibName: "SubmitTaskViewController", bundle: nil)
            sub.id = self.id
            self.navigationController?.pushViewController(sub, animated: true)
        }
    }
    var selectedIds = [String]()
    func assignBtnClicked()
    {
        if dataSource.taskDetail == nil
        {
            return
        }
        
        let s = SelectContactViewController()
        unowned let weakSelf = self
        s.addCallback({ (selectedIds) in
            
            weakSelf.selectedIds.removeAll()
            weakSelf.selectedIds.appendContentsOf(selectedIds)
            
            weakSelf.assign()
        })
        self.navigationController?.pushViewController(s, animated: true)
    }
    
    func assign()
    {
        let task = PublishTask()
        task.taskId = self.id!
        task.director = selectedIds[0]
        if selectedIds.count > 1
        {
            task.supporter = selectedIds[1]
        }else{
            task.supporter = ""
        }
        
        self.view.showHud()
        dataSource.assignTask(task, success: { (result) in
            MBProgressHUD.showSuccess("指派成功", toView: self.view)
            self.view.dismiss()
            }, failure: { (error) in
                MBProgressHUD.showError(error.msg, toView: self.view)
                self.view.dismiss()
        })
    }
    
    func updateView()
    {
        self.titleLabel.text = dataSource.taskDetail?.task_title
        self.statusLabel.text = dataSource.taskDetail?.task_status_name
        self.timeLabel.text = dataSource.taskDetail?.task_end_date
        self.contentLabel.text = dataSource.taskDetail?.task_content
        
        if dataSource.taskDetail?.task_status == nil
        {
            return
        }
        
        if isMyTask
        {
            let name = dataSource.taskDetail?.task_publish_user_name == nil ? "" : dataSource.taskDetail!.task_publish_user_name!
            publishManLabel.text = "指派人: " + name
        }else{
            var name = "指派给: "
            if dataSource.taskDetail?.assign != nil
            {
                if dataSource.taskDetail!.assign!.count > 0
                {
                    let n = dataSource.taskDetail!.assign![0].assignee_user_name == nil ? "" : dataSource.taskDetail!.assign![0].assignee_user_name!
                    name = name  + n
                }
                if dataSource.taskDetail!.assign?.count > 1
                {
                    let n = dataSource.taskDetail!.assign![1].assignee_user_name == nil ? "" : dataSource.taskDetail!.assign![1].assignee_user_name!
                    name = name + ", " + n
                }
            }
            publishManLabel.text = name
        }
        
        if dataSource.taskDetail?.task_publish_date != nil
        {
            publishTimeLabel.text = "指派时间:" + dataSource.taskDetail!.task_publish_date!
            //publishTimeLabel.text = "指派时间:" + Helper.formatDateString(dataSource.taskDetail!.task_publish_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
        }
        if dataSource.taskDetail?.task_status != nil
        {
            if dataSource.taskDetail!.task_status! == "responsing"//待接受
            {
                if dataSource.taskDetail?.task_end_date != nil
                {
                    timeLabel.text = "截止时间:" + Helper.formatDateString(dataSource.taskDetail!.task_end_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
                }
                okBtn.setTitle("接受", forState: .Normal)
                self.showBtn(true, showPublishBtn: true)
            }else if dataSource.taskDetail!.task_status! == "finished"//已完成
            {
//                if dataSource.taskDetail?.task_finish_date != nil
//                {
//                    timeLabel.text = "完成时间:" + Helper.formatDateString(dataSource.taskDetail!.task_finish_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
//                }
                if dataSource.taskDetail?.task_end_date != nil
                {
                    timeLabel.text = "截止时间:" + Helper.formatDateString(dataSource.taskDetail!.task_end_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
                }
                okBtn.setTitle("查看", forState: .Normal)
                self.showBtn(false, showPublishBtn: false)
                self.showResult()
            }else if dataSource.taskDetail!.task_status! == "accepted"//已接受
            {
//                if dataSource.taskDetail?.task_accept_date != nil
//                {
//                    timeLabel.text = "接受时间:" + Helper.formatDateString(dataSource.taskDetail!.task_accept_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
//                }
                if dataSource.taskDetail?.task_end_date != nil
                {
                    timeLabel.text = "截止时间:" + Helper.formatDateString(dataSource.taskDetail!.task_end_date!, fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"yyyy-MM-dd")
                }
                okBtn.setTitle("提交", forState: .Normal)
                self.showBtn(true, showPublishBtn: false)
                self.showResult()
            }
        }
        
        if dataSource.taskDetail?.assign?.count != nil
        {
            self.topHeight.constant = 30 * CGFloat(dataSource.taskDetail!.assign!.count) + 100
            for i in 0 ..< dataSource.taskDetail!.assign!.count
            {
                let view = self.getView(i, assign: dataSource.taskDetail!.assign![i])
                self.topView.addSubview(view)
            }
        }
        
        if !isMyTask
        {
            self.showBtn(false, showPublishBtn: false)
        }
    }
    
    func showResult()
    {
        collectionView.reloadData()
        collectionView.alpha = 0
        DispatchAfter(0.2, queue: dispatch_get_main_queue()) {
            let text = self.contentLabel.text == nil ? "" : self.contentLabel.text!
            let textHeight = Helper.getTextSize(text, font: self.contentLabel.font, size: CGSize(width: self.contentLabel.frame.width, height: CGFloat.max)).height
            self.collectionView.alpha = 1
            self.contentHeight.constant = self.topHeight.constant + textHeight + self.collectionView.contentSize.height + 20 + 50
            self.view.layoutIfNeeded()
            print(self.collectionView.contentSize)
        }
    }
    
    func getView(i:Int, assign:TaskAssign)->UIView
    {
        let view = UIView(frame: CGRect(x: 0, y: 100 + CGFloat(i) * 30, width: GetSWidth(), height: 30))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width-20, height: 30))
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = ThemeManager.current().darkGrayFontColor
        
        let text = NSMutableAttributedString()
        if assign.assign_date != nil
        {
            let t = assign.assign_date! + ": "
            text.appendAttributeString(t, color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFontOfSize(12))
        }
        
        if assign.assigner_user_name != nil
        {
            text.appendAttributeString(assign.assigner_user_name!, color: ThemeManager.current().mainColor, font: UIFont.systemFontOfSize(12))
            text.appendAttributeString("指派给了", color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFontOfSize(12))
        }
        
        if assign.assignee_user_name != nil
        {
            text.appendAttributeString(assign.assignee_user_name!, color: ThemeManager.current().mainColor, font: UIFont.systemFontOfSize(12))
        }
        label.attributedText = text
        view.addSubview(label)
        return view
    }
    
    func showBtn(showOkBtn:Bool, showPublishBtn:Bool)
    {
        okBtn.hidden = !showOkBtn
        assignBtn.hidden = !showPublishBtn
        
        if showOkBtn
        {
            okBtn.frame = CGRect(x: 10, y: 5, width: GetSWidth()-20, height: 40)
            if showPublishBtn
            {
                okBtn.frame = CGRect(x: 10, y: 5, width: (GetSWidth()-30)/2, height: 40)
                assignBtn.frame = CGRect(x: GetSWidth()/2 + 5, y: 5, width: (GetSWidth()-30)/2, height: 40)
            }
        }
        
        if !showOkBtn && !showPublishBtn
        {
            btnView.hidden = true
        }else{
            btnView.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: UICollectionViewDelegate
extension TaskDetailViewController : UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.section == 1
        {
            let photoArray = NSMutableArray()
            
            for i in 0 ..< self.dataSource.taskDetail!.task_comment!.photos!.count
            {
                let photo = MJPhoto()
                let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: i, inSection: 1)) as! ImageCollectionCell
                photo.url = NSURL(string: self.dataSource.taskDetail!.task_comment!.photos![i].photo_path!)
                photo.srcImageView = cell.imageView
                photo.image = cell.imageView.image
                photoArray.addObject(photo)
            }
            let browser = MJPhotoBrowser()
            browser.showPushBtn = false
            browser.currentPhotoIndex = UInt(indexPath.row)
            browser.photos = photoArray as [AnyObject]
            browser.show()
        }
    }
}

//MARK: UICollectionViewDataSource
extension TaskDetailViewController : UICollectionViewDataSource
{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        if dataSource.taskDetail?.task_status == "accepted"
        {
            return 1
        }else{
            if dataSource.taskDetail?.task_comment?.photos == nil || dataSource.taskDetail!.task_comment!.photos!.count == 0
            {
                return 1
            }
            return 2
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "UICollectionReusableView", forIndexPath: indexPath)
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 1 && indexPath.row == 0
            {
                cell.backgroundColor = ThemeManager.current().backgroundColor
            }
        }else{
            
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return dataSource.taskDetail == nil ? 0 : 1
        }else{
            return dataSource.taskDetail?.task_comment?.photos?.count == nil ? 0 : dataSource.taskDetail!.task_comment!.photos!.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TaskResultTopCell", forIndexPath: indexPath) as! TaskResultTopCell
            cell.update(self.dataSource.taskDetail!)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionCell", forIndexPath: indexPath) as! ImageCollectionCell
            cell.deleteBtn.hidden = true
            cell.updatePhoto(dataSource.taskDetail!.task_comment!.photos![indexPath.row])
            return cell
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TaskDetailViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return TaskResultTopCell.cellSize(self.dataSource.taskDetail?.task_comment?.taskcomment_content)
        }else{
            return ImageCollectionCell.cellSize()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if section == 0
        {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 1
        {
            return CGSize(width: GetSWidth(), height: 1)
        }
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSizeMake(GetSWidth(), 0)
    }
}
