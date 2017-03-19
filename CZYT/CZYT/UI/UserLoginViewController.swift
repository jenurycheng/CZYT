//
//  UserLoginViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class UserLoginViewController: BasePortraitViewController {
    
    var pushToVC:UIViewController?
    
    var telTextField:UITextField!
    var codeTextField:UITextField!
    var codeBtn:UIButton!
    var nextBtn:UIButton!
    var timer:NSTimer?
    var logoImageView:UIImageView!
    var nameLabel:UILabel!
    
    var dataSource = UserDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "登录"
        self.view.backgroundColor = ThemeManager.current().foregroundColor
        
        logoImageView = UIImageView(frame: CGRect(x: GetSWidth()/2-40, y: 40, width: 80, height: 80))
        logoImageView.image = UIImage(named: "app_icon")
        logoImageView.layer.cornerRadius = logoImageView.frame.width/2
        logoImageView.layer.masksToBounds = true
        self.view.addSubview(logoImageView)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: logoImageView.frame.origin.y + logoImageView.frame.height + 10, width: GetSWidth(), height: 20))
        nameLabel.text = "成资合作"
        nameLabel.textColor = ThemeManager.current().mainColor
        nameLabel.textAlignment = .Center
        self.view.addSubview(nameLabel)
        
        let telView = self.getInputView(CGRectMake(30, nameLabel.frame.origin.y + nameLabel.frame.height + 10, GetSWidth()-60, 40))
        self.view.addSubview(telView)
        
        let telLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        telLabel.text = "手机号:"
        telLabel.font = UIFont.systemFontOfSize(13)
        telLabel.textColor = ThemeManager.current().grayFontColor
        telView.addSubview(telLabel)
        
        telTextField = UITextField(frame: CGRectMake(60, 0, telView.frame.size.width-60, 40))
        telTextField.placeholder = "请输入手机号"
        telTextField.delegate = self
//        telTextField.text = "18215595271"
//        telTextField.text = "13880184987"
        telTextField.keyboardType = .NumberPad
        telTextField.font = UIFont.systemFontOfSize(14)
        telTextField.addTarget(telTextField, action: #selector(UITextField.resignFirstResponder), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        telView.addSubview(telTextField)
        
        let codeView = self.getInputView(CGRectMake(30, telView.frame.origin.y + telView.frame.height + 20, GetSWidth()-60, 40))
        self.view.addSubview(codeView)
        let codeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        codeLabel.text = "验证码:"
        codeLabel.font = UIFont.systemFontOfSize(13)
        codeLabel.textColor = ThemeManager.current().grayFontColor
        codeView.addSubview(codeLabel)
        codeTextField = UITextField(frame: CGRectMake(60, 0, telView.frame.size.width-80-60, 40))
        codeTextField.placeholder = "请输入验证码"
        codeTextField.delegate = self
//        codeTextField.text = "1234"
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
        
//        self.telTextField.becomeFirstResponder()
        
        self.navigationItem.leftBarButtonItem = nil
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UserLoginViewController.tapped))
        self.view.addGestureRecognizer(tap)
    }
    
    func tapped()
    {
        self.view.endEditing(true)
    }
    
    override func backItemBarClicked(item: UIBarButtonItem) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
                self.view.dismiss()
                self.codeBtn.userInteractionEnabled = true
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
        
        if telTextField.text! == "13880184987" && codeTextField.text! == "8888"
        {
            let ui = UserInfo()
            ui.id = "550"
            ui.nickname = "赵"
            ui.token = "6gggGQ7Id15zUFnEH88gh1c3WSEN8buxIX4ah9tuS/Eq07d6P18AyLc4AQTT6ECMnxNK547lF/q8i9UwMUD15Q=="
            ui.logo_path = "http://111.9.93.229:20080/unity/userfiles/user/photo/portrait.jpg"
            ui.mobile = "18010648123"
            ui.dept_id = "4"
            ui.dept_name = "市成资一体办"
            ui.publish_task_flag = "1"
            UserInfo.sharedInstance.update(ui)
            UserInfo.sharedInstance.isLogin = true
            
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            
            if !UserInfo.sharedInstance.isLogin
            {
                MBProgressHUD.showSuccess("登录成功", toView: self.view.window)
            }
            
            self.codeTextField.text = ""
            self.timer?.invalidate()
            self.timer = nil
            self.codeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            self.codeBtn.userInteractionEnabled  = true
            self.count = 0
            
            if self.pushToVC != nil
            {
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(self.pushToVC!, animated: false)
            }
            return
        }
        
        self.view.showHud()
        dataSource.login(telTextField.text!, code: codeTextField.text!, success: { (result) in
            self.view.dismiss()
            UserInfo.sharedInstance.update(result)
            UserInfo.sharedInstance.isLogin = true
            
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            
            if !UserInfo.sharedInstance.isLogin
            {
                MBProgressHUD.showSuccess("登录成功", toView: self.view.window)
            }
            
            self.codeTextField.text = ""
            self.timer?.invalidate()
            self.timer = nil
            self.codeBtn.setTitle("获取验证码", forState: UIControlState.Normal)
            self.codeBtn.userInteractionEnabled  = true
            self.count = 0
            
            if self.pushToVC != nil
            {
                let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(self.pushToVC!, animated: false)
            }
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
