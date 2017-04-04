//
//  PublishApproveViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class PublishApproveViewController: BasePortraitViewController {

    var id:String?
    var type:String?
    @IBOutlet weak var contentTextView:UITextView!
    @IBOutlet weak var publishBtn:UIButton!
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    @IBOutlet weak var noLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    
    var dataSource = TaskDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "添加批示"
        
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight() - 64
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = ThemeManager.current().backgroundColor.CGColor
        
        publishBtn.backgroundColor = ThemeManager.current().mainColor
        publishBtn.layer.cornerRadius = 5
        publishBtn.layer.masksToBounds = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishApproveViewController.endEdit))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(PublishApproveViewController.endEdit))
        self.contentLabel.addGestureRecognizer(tap2)
        self.noLabel.addGestureRecognizer(tap1)
        // Do any additional setup after loading the view.
    }
    
    override func backItemBarClicked(item: UIBarButtonItem) {
        if self.contentTextView.isFirstResponder()
        {
            self.endEdit()
        }else{
            super.backItemBarClicked(item)
        }
    }
    
    func endEdit()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func publishBtnClicked()
    {
        if Helper.isStringEmpty(contentTextView.text)
        {
            MBProgressHUD.showMessag("请输入内容", toView: self.view, showTimeSec: 1)
            return
        }
        
        dataSource.publishApprove(self.contentTextView.text, advice_type: self.type!, advice_ref_id: self.id!, success: {
            MBProgressHUD.showSuccess("批示成功", toView: self.view.window)
            ApproveListViewController.needUpdate = true
            self.navigationController?.popViewControllerAnimated(true)
            }) { (error) in
                MBProgressHUD.showError("批示出错", toView: self.view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
