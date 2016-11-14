//
//  UserLoginViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class UserLoginViewController: BasePortraitViewController {
    
    var telTextField:UITextField!
    var codeTextField:UITextField!
    var codeBtn:UIButton!
    var nextBtn:UIButton!
    var timer:NSTimer?
    
    var dataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登录"
        self.view.backgroundColor = ThemeManager.current().foregroundColor
        
        let telView = self.getInputView(CGRectMake(30, 50, GetSWidth()-60, 40))
        self.view.addSubview(telView)
        telTextField = UITextField(frame: CGRectMake(0, 0, telView.frame.size.width, 40))
        telTextField.placeholder = "手机号"
        telTextField.delegate = self
        telTextField.text = "13880184987"
        telTextField.keyboardType = .NumberPad
        telTextField.font = UIFont.systemFontOfSize(14)
        telTextField.addTarget(telTextField, action: #selector(UITextField.resignFirstResponder), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        telView.addSubview(telTextField)
        
        let codeView = self.getInputView(CGRectMake(30, telView.frame.origin.y + telView.frame.height + 20, GetSWidth()-60, 40))
        self.view.addSubview(codeView)
        codeTextField = UITextField(frame: CGRectMake(0, 0, telView.frame.size.width-80, 40))
        codeTextField.placeholder = "验证码"
        codeTextField.delegate = self
        codeTextField.keyboardType = .NumberPad
        codeTextField.font = UIFont.systemFontOfSize(14)
        codeTextField.addTarget(codeTextField, action: #selector(UITextField.resignFirstResponder), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        codeView.addSubview(codeTextField)
        
        codeBtn = UIButton(type: .Custom)
        codeBtn.frame = CGRectMake(codeView.frame.size.width-80, 0, 80, 40)
        codeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
        codeBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        codeBtn.setTitleColor(ThemeManager.current().mainColor, forState: UIControlState.Normal)
        codeBtn.addTarget(self, action: #selector(UserLoginViewController.codeBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        codeView.addSubview(codeBtn)
        
        let line = UIView(frame: CGRectMake(0, 12, 1, 16))
        line.backgroundColor = ThemeManager.current().mainColor
        codeBtn.addSubview(line)
        
        nextBtn = UIButton(type:.System)
        nextBtn.frame = CGRectMake(30, codeView.frame.origin.y + codeView.frame.height + 50, GetSWidth()-60, 45)
        if IS_IPHONE_4
        {
            nextBtn.frame = CGRectMake(30, codeView.frame.origin.y + codeView.frame.height + 10, GetSWidth()-60, 45)
        }
        nextBtn.setTitle("登录", forState: UIControlState.Normal)
        nextBtn.backgroundColor = ThemeManager.current().mainColor
        nextBtn.setTitleColor(ThemeManager.current().whiteFontColor, forState: UIControlState.Normal)
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action: #selector(UserLoginViewController.nextBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(nextBtn)
        
        self.telTextField.becomeFirstResponder()
    }
    
    func getInputView(frame:CGRect)->UIView
    {
        let view = UIView(frame: frame)
        let line = UIView(frame: CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 0.5))
        line.backgroundColor = ThemeManager.current().lightGrayFontColor
        view.addSubview(line)
        return view
    }
    
    
    func backButtonClicked()
    {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var curTel:String?
    func codeBtnClicked()
    {
        if Helper.isStringEmpty(telTextField.text) {
            MBProgressHUD.showError("请填写手机号", toView: self.view)
            return
        }
        
        if telTextField.text!.characters.count != 11
        {
            MBProgressHUD.showError("请填写正确的手机号码", toView: self.view)
            return
        }
        
        count = 60
        
        
        self.view.showHud()
        codeBtn.userInteractionEnabled = false
        
        dataSource.getValideCode(telTextField.text!, success: { (result) in
            self.view.dismiss()
            self.codeBtn.userInteractionEnabled = true
            self.curTel = self.telTextField.text
            MBProgressHUD.showSuccess("已发送", toView: self.view)
            
            if self.timer != nil
            {
                self.timer?.invalidate()
                self.timer = nil
            }
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(UserLoginViewController.timeout(_:)), userInfo: nil, repeats: true)
            }) { (error) in
                MBProgressHUD.showError(error.msg, toView: self.view)
        }
    }
    
    var count = 60
    func timeout(timer:NSTimer)
    {
        count -= 1
        if count > 0
        {
            codeBtn.setTitle("\(count)秒后可重发", forState: UIControlState.Normal)
            codeBtn.titleLabel?.font = UIFont.systemFontOfSize(12)
            codeBtn.userInteractionEnabled = false
        }else{
            self.timer!.invalidate()
            self.timer = nil
            codeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            codeBtn.userInteractionEnabled = true
            codeBtn.titleLabel?.font = UIFont.systemFontOfSize(13)
        }
    }
    
    func nextBtnClicked()
    {
        if Helper.isStringEmpty(telTextField.text) {
            MBProgressHUD.showError("请填写手机号", toView: self.view)
            return
        }

        if telTextField.text!.characters.count != 11
        {
            MBProgressHUD.showError("请填写正确的手机号码", toView: self.view)
            return
        }

        
        if Helper.isStringEmpty(codeTextField.text) {
            MBProgressHUD.showError("请填写验证码", toView: self.view)
            return
        }
        
        self.view.showHud()
        dataSource.login(telTextField.text!, code: codeTextField.text!, success: { (result) in
            self.view.dismiss()
            UserInfo.sharedInstance.update(result)
            UserInfo.sharedInstance.isLogin = true
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            MBProgressHUD.showSuccess("登录成功", toView: self.view)
            
            self.codeTextField.text = ""
            self.timer!.invalidate()
            self.timer = nil
            self.codeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            self.codeBtn.userInteractionEnabled  = true
            self.count = 0
            }) { (error) in
                MBProgressHUD.showError(error.msg, toView: self.view)
                self.view.dismiss()
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

extension UserLoginViewController : UITextFieldDelegate
{
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.isEqual(telTextField)
        {
            if textField.text?.characters.count == 11 && !Helper.isStringEmpty(string) {
                return false
            }
        }else if textField.isEqual(codeTextField)
        {
            if textField.text?.characters.count == 6 && !Helper.isStringEmpty(string) {
                return false
            }
        }
        return true
    }
}
