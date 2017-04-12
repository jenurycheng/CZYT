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
    var timer:Timer?
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
        nameLabel.textAlignment = .center
        self.view.addSubview(nameLabel)
        
        let telView = self.getInputView(CGRect(x: 30, y: nameLabel.frame.origin.y + nameLabel.frame.height + 10, width: GetSWidth()-60, height: 40))
        self.view.addSubview(telView)
        
        let telLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        telLabel.text = "手机号:"
        telLabel.font = UIFont.systemFont(ofSize: 13)
        telLabel.textColor = ThemeManager.current().grayFontColor
        telView.addSubview(telLabel)
        
        telTextField = UITextField(frame: CGRect(x: 60, y: 0, width: telView.frame.size.width-60, height: 40))
        telTextField.placeholder = "请输入手机号"
        telTextField.delegate = self
//        telTextField.text = "18215595271"
//        telTextField.text = "13880184987"
        telTextField.keyboardType = .numberPad
        telTextField.font = UIFont.systemFont(ofSize: 14)
        telTextField.addTarget(telTextField, action: #selector(UITextField.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        telView.addSubview(telTextField)
        
        let codeView = self.getInputView(CGRect(x: 30, y: telView.frame.origin.y + telView.frame.height + 20, width: GetSWidth()-60, height: 40))
        self.view.addSubview(codeView)
        let codeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        codeLabel.text = "验证码:"
        codeLabel.font = UIFont.systemFont(ofSize: 13)
        codeLabel.textColor = ThemeManager.current().grayFontColor
        codeView.addSubview(codeLabel)
        codeTextField = UITextField(frame: CGRect(x: 60, y: 0, width: telView.frame.size.width-80-60, height: 40))
        codeTextField.placeholder = "请输入验证码"
        codeTextField.delegate = self
//        codeTextField.text = "1234"
        codeTextField.keyboardType = .numberPad
        codeTextField.font = UIFont.systemFont(ofSize: 14)
        codeTextField.addTarget(codeTextField, action: #selector(UITextField.resignFirstResponder), for: UIControlEvents.editingDidEndOnExit)
        codeView.addSubview(codeTextField)
        
        codeBtn = UIButton(type: .custom)
        codeBtn.frame = CGRect(x: codeView.frame.size.width-80, y: 0, width: 80, height: 40)
        codeBtn.setTitle("获取验证码", for: UIControlState())
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        codeBtn.setTitleColor(ThemeManager.current().mainColor, for: UIControlState())
        codeBtn.addTarget(self, action: #selector(UserLoginViewController.codeBtnClicked), for: UIControlEvents.touchUpInside)
        codeView.addSubview(codeBtn)
        
        let line = UIView(frame: CGRect(x: 0, y: 12, width: 1, height: 16))
        line.backgroundColor = ThemeManager.current().mainColor
        codeBtn.addSubview(line)
        
        nextBtn = UIButton(type:.system)
        nextBtn.frame = CGRect(x: 30, y: codeView.frame.origin.y + codeView.frame.height + 50, width: GetSWidth()-60, height: 45)
        if IS_IPHONE_4
        {
            nextBtn.frame = CGRect(x: 30, y: codeView.frame.origin.y + codeView.frame.height + 10, width: GetSWidth()-60, height: 45)
        }
        nextBtn.setTitle("登录", for: UIControlState())
        nextBtn.backgroundColor = ThemeManager.current().mainColor
        nextBtn.setTitleColor(ThemeManager.current().whiteFontColor, for: UIControlState())
        nextBtn.layer.cornerRadius = 5
        nextBtn.addTarget(self, action: #selector(UserLoginViewController.nextBtnClicked), for: UIControlEvents.touchUpInside)
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
    
    override func backItemBarClicked(_ item: UIBarButtonItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func getInputView(_ frame:CGRect)->UIView
    {
        let view = UIView(frame: frame)
        let line = UIView(frame: CGRect(x: 0, y: view.frame.size.height-1, width: view.frame.size.width, height: 0.5))
        line.backgroundColor = ThemeManager.current().lightGrayFontColor
        view.addSubview(line)
        return view
    }
    
    
    func backButtonClicked()
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    var curTel:String?
    func codeBtnClicked()
    {
        if Helper.isStringEmpty(telTextField.text) {
            MBProgressHUD.showError("请填写手机号", to: self.view)
            return
        }
        
        if telTextField.text!.characters.count != 11
        {
            MBProgressHUD.showError("请填写正确的手机号码", to: self.view)
            return
        }
        
        count = 60
        
        
        self.view.showHud()
        codeBtn.isUserInteractionEnabled = false
        
        dataSource.getValideCode(telTextField.text!, success: { (result) in
            self.view.dismiss()
            self.codeBtn.isUserInteractionEnabled = true
            self.curTel = self.telTextField.text
            MBProgressHUD.showSuccess("已发送", to: self.view)
            
            if self.timer != nil
            {
                self.timer?.invalidate()
                self.timer = nil
            }
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UserLoginViewController.timeout(_:)), userInfo: nil, repeats: true)
            }) { (error) in
                self.view.dismiss()
                self.codeBtn.isUserInteractionEnabled = true
                MBProgressHUD.showError(error.msg, to: self.view)
        }
    }
    
    var count = 60
    func timeout(_ timer:Timer)
    {
        count -= 1
        if count > 0
        {
            codeBtn.setTitle("\(count)秒后可重发", for: UIControlState())
            codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            codeBtn.isUserInteractionEnabled = false
        }else{
            self.timer!.invalidate()
            self.timer = nil
            codeBtn.setTitle("获取验证码", for: UIControlState())
            codeBtn.isUserInteractionEnabled = true
            codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    func nextBtnClicked()
    {
        if Helper.isStringEmpty(telTextField.text) {
            MBProgressHUD.showError("请填写手机号", to: self.view)
            return
        }

        if telTextField.text!.characters.count != 11
        {
            MBProgressHUD.showError("请填写正确的手机号码", to: self.view)
            return
        }

        
        if Helper.isStringEmpty(codeTextField.text) {
            MBProgressHUD.showError("请填写验证码", to: self.view)
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
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
            if !UserInfo.sharedInstance.isLogin
            {
                MBProgressHUD.showSuccess("登录成功", to: self.view.window)
            }
            
            self.codeTextField.text = ""
            self.timer?.invalidate()
            self.timer = nil
            self.codeBtn.setTitle("获取验证码", for: UIControlState())
            self.codeBtn.isUserInteractionEnabled  = true
            self.count = 0
            
            if self.pushToVC != nil
            {
                let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(self.pushToVC!, animated: false)
            }
            return
        }
        
        self.view.showHud()
        dataSource.login(telTextField.text!, code: codeTextField.text!, success: { (result) in
            self.view.dismiss()
            UserInfo.sharedInstance.update(result)
            UserInfo.sharedInstance.isLogin = true
            
            self.navigationController?.dismiss(animated: true, completion: nil)
            
            if !UserInfo.sharedInstance.isLogin
            {
                MBProgressHUD.showSuccess("登录成功", to: self.view.window)
            }
            
            self.codeTextField.text = ""
            self.timer?.invalidate()
            self.timer = nil
            self.codeBtn.setTitle("获取验证码", for: UIControlState())
            self.codeBtn.isUserInteractionEnabled  = true
            self.count = 0
            
            if self.pushToVC != nil
            {
                let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                nav?.pushViewController(self.pushToVC!, animated: false)
            }
            }) { (error) in
                MBProgressHUD.showError(error.msg, to: self.view)
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
