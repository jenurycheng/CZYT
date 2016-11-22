//
//  TaskDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/22.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {

    var id:String?
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var statusLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var btnView:UIView!
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    
    var okBtn:UIButton!
    var publishBtn:UIButton!
    
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
        
        publishBtn = UIButton(frame: CGRect(x: 10, y: 5, width: GetSWidth()-20, height: 40))
        publishBtn.backgroundColor = ThemeManager.current().mainColor
        publishBtn.layer.cornerRadius = 5
        publishBtn.layer.masksToBounds = true
        publishBtn.setTitle("指派", forState: .Normal)
        publishBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnView.addSubview(publishBtn)
        publishBtn.hidden = true
        publishBtn.addTarget(self, action: #selector(TaskDetailViewController.publishBtnClicked), forControlEvents: .TouchUpInside)
        
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
                self.navigationController?.popViewControllerAnimated(true)
                }, failure: { (error) in
                    MBProgressHUD.showSuccess(error.msg, toView: self.view.window)
            })
        }else if dataSource.taskDetail!.task_status! == "finished"//已完成
        {
            
        }else if dataSource.taskDetail!.task_status! == "accepted"//已接受
        {
            let sub = SubmitTaskViewController(nibName: "SubmitTaskViewController", bundle: nil)
            sub.id = self.id
            self.navigationController?.pushViewController(sub, animated: true)
        }
    }
    
    func publishBtnClicked()
    {
        
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
        if dataSource.taskDetail!.task_status! == "responsing"//待接受
        {
            okBtn.setTitle("接受", forState: .Normal)
            self.showBtn(true, showPublishBtn: false)
        }else if dataSource.taskDetail!.task_status! == "finished"//已完成
        {
            self.showBtn(false, showPublishBtn: false)
        }else if dataSource.taskDetail!.task_status! == "accepted"//已接受
        {
            okBtn.setTitle("提交", forState: .Normal)
            self.showBtn(true, showPublishBtn: true)
        }
    }
    
    func showBtn(showOkBtn:Bool, showPublishBtn:Bool)
    {
        okBtn.hidden = !showOkBtn
        publishBtn.hidden = !showPublishBtn
        
        if showOkBtn
        {
            okBtn.frame = CGRect(x: 10, y: 5, width: GetSWidth()-20, height: 40)
            if showPublishBtn
            {
                okBtn.frame = CGRect(x: 10, y: 5, width: (GetSWidth()-30)/2, height: 40)
                publishBtn.frame = CGRect(x: GetSWidth()/2 + 5, y: 5, width: (GetSWidth()-30)/2, height: 40)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
