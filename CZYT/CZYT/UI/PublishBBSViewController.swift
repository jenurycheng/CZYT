//
//  PublishBBSViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/21.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class PublishBBSViewController: BasePortraitViewController {

    @IBOutlet weak var titleTextField:UITextField!
    @IBOutlet weak var contentTextView:UITextView!
    @IBOutlet weak var publishBtn:UIButton!
    @IBOutlet weak var contentWidth:NSLayoutConstraint!
    @IBOutlet weak var contentHeight:NSLayoutConstraint!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentLabel:UILabel!
    
    var dataSource = BBSDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "建言献策"
        
        contentWidth.constant = GetSWidth()
        contentHeight.constant = GetSHeight() - 64
        
        titleTextField.layer.cornerRadius = 5
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.borderColor = ThemeManager.current().backgroundColor.cgColor
        titleTextField.addTarget(self, action: #selector(PublishBBSViewController.endEdit), for: .editingDidEndOnExit)
        
        contentTextView.layer.cornerRadius = 5
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = ThemeManager.current().backgroundColor.cgColor
        
        publishBtn.backgroundColor = ThemeManager.current().mainColor
        publishBtn.layer.cornerRadius = 5
        publishBtn.layer.masksToBounds = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(PublishBBSViewController.endEdit))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(PublishBBSViewController.endEdit))
        self.titleLabel.addGestureRecognizer(tap1)
        self.contentLabel.addGestureRecognizer(tap2)
        // Do any additional setup after loading the view.
    }
    
    override func backItemBarClicked(_ item: UIBarButtonItem) {
        if self.contentTextView.isFirstResponder || self.titleTextField.isFirstResponder
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
        if Helper.isStringEmpty(titleTextField.text)
        {
            MBProgressHUD.showMessag("输入任务标题", to: self.view, showTimeSec: 1)
            return
        }
        if Helper.isStringEmpty(contentTextView.text)
        {
            MBProgressHUD.showMessag("输入任务内容", to: self.view, showTimeSec: 1)
            return
        }
        
        self.view.showHud()
        dataSource.publishBBS(titleTextField.text!, content: contentTextView.text, success: { 
            self.view.dismiss()
            MBProgressHUD.showSuccess("发布成功，后台审核中", to: self.view.window)
            self.navigationController?.popViewController(animated: true)
            }) { (error) in
                self.view.dismiss()
                MBProgressHUD.showError("发布失败", to: self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
