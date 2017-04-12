//
//  TaskDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/22.
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
    var projectItem:UIBarButtonItem!
    
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
        okBtn.setTitle("提交", for: UIControlState())
        okBtn.setTitleColor(UIColor.white, for: UIControlState())
        btnView.addSubview(okBtn)
        okBtn.isHidden = true
        okBtn.addTarget(self, action: #selector(TaskDetailViewController.okBtnClicked), for: .touchUpInside)
        
        assignBtn = UIButton(frame: CGRect(x: 10, y: 5, width: GetSWidth()-20, height: 40))
        assignBtn.backgroundColor = ThemeManager.current().mainColor
        assignBtn.layer.cornerRadius = 5
        assignBtn.layer.masksToBounds = true
        assignBtn.setTitle("指派", for: UIControlState())
        assignBtn.setTitleColor(UIColor.white, for: UIControlState())
        btnView.addSubview(assignBtn)
        assignBtn.isHidden = true
        assignBtn.addTarget(self, action: #selector(TaskDetailViewController.assignBtnClicked), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(UINib(nibName: "TaskResultTopCell", bundle: nil), forCellWithReuseIdentifier: "TaskResultTopCell")
        collectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        collectionView.register(UINib(nibName: "FileCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FileCollectionCell")
        collectionView.backgroundColor = ThemeManager.current().foregroundColor
        collectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        
        projectItem = UIBarButtonItem(title: "项目背景", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TaskDetailViewController.projectClicked))
        // Do any additional setup after loading the view.
    }
    
    func projectClicked()
    {
        if dataSource.taskDetail?.task_projectwork_id == nil {
            return
        }
        let detail = ProjectWorkDetailViewController()
        detail.hiddenItem = true
        detail.id = dataSource.taskDetail!.task_projectwork_id!
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSource.taskDetail != nil && dataSource.taskDetail!.task_status! == "finished"
        {
            return
        }
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
                MBProgressHUD.showSuccess("接受成功", to: self.view.window)
                MyTaskViewController.shouldReload = true
                self.navigationController?.popViewController(animated: true)
                }, failure: { (error) in
                    MBProgressHUD.showSuccess(error.msg, to: self.view.window)
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
            weakSelf.selectedIds.append(contentsOf: selectedIds)
            
            weakSelf.assign()
        })
        self.navigationController?.pushViewController(s, animated: true)
    }
    
    func assign()
    {
        let task = PublishTask()
        task.taskId = self.id!
//        task.director = selectedIds[0]
//        if selectedIds.count > 1
//        {
//            task.supporter = selectedIds[1]
//        }else{
//            task.supporter = ""
//        }
        var assigns = ""
        for id in selectedIds
        {
            if id != selectedIds[selectedIds.count-1]
            {
                assigns = assigns + id + ","
            }else{
                assigns = assigns + id
            }
        }
        task.assigns = assigns
        
        self.view.showHud()
        dataSource.assignTask(task, success: { (result) in
            MBProgressHUD.showSuccess("指派成功", to: self.view)
            self.view.dismiss()
            }, failure: { (error) in
                MBProgressHUD.showError(error.msg, to: self.view)
                self.view.dismiss()
        })
    }
    
    func updateView()
    {
        if Helper.isStringEmpty(dataSource.taskDetail?.task_projectwork_id) || dataSource.taskDetail!.task_projectwork_id == "0"{
            self.navigationItem.rightBarButtonItem = nil
        }else{
            self.navigationItem.rightBarButtonItem = projectItem
        }
        if !Helper.isStringEmpty(dataSource.taskDetail?.task_status_name) && self.statusLabel.text == dataSource.taskDetail?.task_status_name
        {
            return
        }
        self.titleLabel.text = dataSource.taskDetail?.task_title
        self.statusLabel.text = dataSource.taskDetail?.task_status_name
        self.timeLabel.text = dataSource.taskDetail?.task_end_date
//        self.contentLabel.text = dataSource.taskDetail?.task_content == nil ? "" : "任务内容:\n\n" + dataSource.taskDetail!.task_content!
        
        let attr = NSMutableAttributedString(string: "")
        attr.appendAttributeString("任务内容:\n\n", color: UIColor.black, font: self.contentLabel.font)
        if dataSource.taskDetail?.task_content != nil {
            attr.appendAttributeString(dataSource.taskDetail!.task_content!, color: ThemeManager.current().darkGrayFontColor, font: self.contentLabel.font)
        }
        self.contentLabel.attributedText = attr
        
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
//                    let n = dataSource.taskDetail!.assign![1].assignee_user_name == nil ? "" : dataSource.taskDetail!.assign![1].assignee_user_name!
//                    name = name + ", " + n
                    name = name + " 等\(dataSource.taskDetail!.assign!.count)人"
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
                okBtn.setTitle("接受", for: UIControlState())
                if UserInfo.sharedInstance.publishEnabled()
                {
                    self.showBtn(true, showPublishBtn: true)
                }else{
                    self.showBtn(true, showPublishBtn: false)
                }
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
                okBtn.setTitle("查看", for: UIControlState())
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
                okBtn.setTitle("提交", for: UIControlState())
                self.showBtn(true, showPublishBtn: false)
                self.showResult()
            }
        }
        
        if dataSource.taskDetail?.assign?.count != nil && !isMyTask
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
        DispatchAfter(0.2, queue: DispatchQueue.main) {
            let text = self.contentLabel.text == nil ? "" : self.contentLabel.text!
            let textHeight = Helper.getTextSize(text, font: self.contentLabel.font, size: CGSize(width: self.contentLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
            self.collectionView.alpha = 1
            self.contentHeight.constant = self.topHeight.constant + textHeight + self.collectionView.contentSize.height + 20 + 50
            self.view.layoutIfNeeded()
            print(self.collectionView.contentSize)
        }
    }
    
    func getView(_ i:Int, assign:TaskAssign)->UIView
    {
        let view = UIView(frame: CGRect(x: 0, y: 100 + CGFloat(i) * 30, width: GetSWidth(), height: 30))
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: view.frame.width-20, height: 30))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = ThemeManager.current().darkGrayFontColor
        
        let text = NSMutableAttributedString()
        if assign.assign_date != nil
        {
            let t = assign.assign_date! + ": "
            text.appendAttributeString(t, color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFont(ofSize: 12))
        }
        
        if assign.assigner_user_name != nil
        {
            text.appendAttributeString(assign.assigner_user_name!, color: ThemeManager.current().mainColor, font: UIFont.systemFont(ofSize: 12))
            text.appendAttributeString("指派给了", color: ThemeManager.current().darkGrayFontColor, font: UIFont.systemFont(ofSize: 12))
        }
        
        if assign.assignee_user_name != nil
        {
            text.appendAttributeString(assign.assignee_user_name!, color: ThemeManager.current().mainColor, font: UIFont.systemFont(ofSize: 12))
        }
        label.attributedText = text
        view.addSubview(label)
        return view
    }
    
    func showBtn(_ showOkBtn:Bool, showPublishBtn:Bool)
    {
        okBtn.isHidden = !showOkBtn
        assignBtn.isHidden = !showPublishBtn
        
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
            btnView.isHidden = true
        }else{
            btnView.isHidden = false
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 1
        {
            let photoArray = NSMutableArray()
            
            for i in 0 ..< self.dataSource.taskDetail!.task_comment!.photos!.count
            {
                let photo = MJPhoto()
                let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 1)) as! ImageCollectionCell
                photo.url = URL(string: self.dataSource.taskDetail!.task_comment!.photos![i].photo_path!)
                photo.srcImageView = cell.imageView
                photo.image = cell.imageView.image
                photoArray.add(photo)
            }
            let browser = MJPhotoBrowser()
            browser.showPushBtn = false
            browser.currentPhotoIndex = UInt(indexPath.row)
            browser.photos = photoArray as [AnyObject]
            browser.show()
        }else if indexPath.section == 2
        {
            let web = WebShowViewController()
            var path = self.dataSource.taskDetail!.task_comment!.files![indexPath.row].file_path!
//            path = path.stringByRemovingPercentEncoding!
            path = path.addingPercentEscapes(using: String.Encoding.utf8)!
            web.url = URL(string: path)
            self.navigationController?.pushViewController(web, animated: true)
        }
    }
}

//MARK: UICollectionViewDataSource
extension TaskDetailViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if dataSource.taskDetail?.task_status == "accepted"
        {
            return 1
        }else{
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        if kind == UICollectionElementKindSectionHeader {
            if indexPath.section == 1 && indexPath.row == 0
            {
                cell.backgroundColor = ThemeManager.current().backgroundColor
            }
        }else{
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if section == 0
        {
            return dataSource.taskDetail == nil ? 0 : 1
        }else if section == 1{
            return dataSource.taskDetail?.task_comment?.photos?.count == nil ? 0 : dataSource.taskDetail!.task_comment!.photos!.count
        }else{
            return dataSource.taskDetail?.task_comment?.files?.count == nil ? 0 : dataSource.taskDetail!.task_comment!.files!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskResultTopCell", for: indexPath) as! TaskResultTopCell
            cell.update(self.dataSource.taskDetail!)
            return cell
        }else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
            cell.deleteBtn.isHidden = true
            cell.updatePhoto(dataSource.taskDetail!.task_comment!.photos![indexPath.row])
            return cell
        }else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FileCollectionCell", for: indexPath) as! FileCollectionCell
            cell.deleteBtn.isHidden = true
            cell.updateFile(dataSource.taskDetail!.task_comment!.files![indexPath.row])
            return cell
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TaskDetailViewController : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if indexPath.section == 0
        {
            return TaskResultTopCell.cellSize(self.dataSource.taskDetail?.task_comment?.taskcomment_content)
        }else if indexPath.section == 1{
            return ImageCollectionCell.cellSize()
        }else
        {
            return FileCollectionCell.cellSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        if section == 0
        {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 1 || section == 2
        {
            return CGSize(width: GetSWidth(), height: 1)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSize(width: GetSWidth(), height: 0)
    }
}
