//
//  KeyboardInputView.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/13.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

import UIKit

class KeyboardInputView: UIView {
    
    static var singleTon:KeyboardInputView?
    class func shareInstance()->KeyboardInputView
    {
        if singleTon == nil {
            singleTon = KeyboardInputView()
        }
        return singleTon!
    }
    
    var inputTextView:UITextField!
    var submitBtn:UIButton!
    var centerView:UIView!
    
    var block:((_ text:String)->Void)?
    
    init(){
        super.init(frame: UIScreen.main.bounds)
        self.initView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
    }
    
    func initView(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardInputView.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardInputView.keyboardShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardInputView.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardInputView.keyboardHide(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardInputView.keyboardChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        centerView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 40))
        centerView.backgroundColor = UIColor.white
        self.addSubview(centerView)
        
        inputTextView = UITextField(frame: CGRect(x: 5, y: 5, width: centerView.frame.size.width-70, height: 30))
        inputTextView.placeholder = "输入评论内容"
        inputTextView.layer.cornerRadius = 5
        inputTextView.clearButtonMode = UITextFieldViewMode.whileEditing
        inputTextView.layer.masksToBounds = true
        inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        inputTextView.layer.borderWidth = 0.5
        inputTextView.font = UIFont.systemFont(ofSize: 15)
        centerView.addSubview(inputTextView)
        
        inputTextView.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: inputTextView.frame.size.height))
        inputTextView.leftViewMode = UITextFieldViewMode.always
        
        submitBtn = UIButton(frame: CGRect(x: centerView.frame.size.width-60, y: 5, width: 55, height: 30))
        submitBtn.backgroundColor = Helper.parseColor(0x2B97EDFF)
        submitBtn.setTitle("确定", for: UIControlState())
        submitBtn.setTitleColor(UIColor.white, for: UIControlState())
        submitBtn.titleLabel?.font = UIFont.systemFont(ofSize: Helper.scale(58))
        submitBtn.layer.cornerRadius = 3
        submitBtn.layer.masksToBounds = true
        centerView.addSubview(submitBtn)
        submitBtn.addTarget(self, action: #selector(KeyboardInputView.okBtnClicked), for: UIControlEvents.touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(KeyboardInputView.tapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func okBtnClicked(){
        if inputTextView.text != nil || inputTextView.text != ""
        {
            block!(inputTextView.text!)
        }
    }
    
    func closeBtnClicked(){
        self.hide()
    }
    
    func tapped(_ tap:UITapGestureRecognizer)
    {
        self.hide()
    }
    
    func hide(){
        inputTextView.resignFirstResponder()
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.alpha = 0
            }, completion: { (finish) -> Void in
                self.removeFromSuperview()
                self.alpha = 1
        }) 
    }
    
    func keyboardWillShow(_ notify:Notification)
    {
        
    }
    
    func keyboardShow(_ notify:Notification)
    {
        
    }
    
    func keyboardWillHide(_ notify:Notification)
    {
        centerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: centerView.frame.size.height)
    }
    
    func keyboardHide(_ notify:Notification)
    {
        
    }
    
    func keyboardChangeFrame(_ notify:Notification)
    {
        let userInfo = notify.userInfo as! NSDictionary
        let keyboardF = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue;
        print(keyboardF?.origin.y)
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.centerView.frame = CGRect(x: 0, y: (keyboardF?.origin.y)! - self.centerView.frame.size.height, width: (keyboardF?.size.width)!, height: self.centerView.frame.size.height)
        })
    }
    
    func show(_ block:@escaping ((_ text:String)->Void)){
//        inputTextView.text = ""
        self.block = block
        UIApplication.shared.delegate!.window!?.addSubview(self)
        inputTextView.becomeFirstResponder()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
