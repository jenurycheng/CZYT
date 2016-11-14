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
    
    var inputTextView:UITextField!
    var submitBtn:UIButton!
    var centerView:UIView!
    
    var block:((text:String)->Void)?
    
    class func shareInstance()->KeyboardInputView{
        struct Singleton{
            static var predicate:dispatch_once_t = 0
            static var instance:KeyboardInputView? = nil
        }
        dispatch_once(&Singleton.predicate) { () -> Void in
            Singleton.instance = KeyboardInputView()
        }
        return Singleton.instance!
    }
    
    init(){
        super.init(frame: UIScreen.mainScreen().bounds)
        self.initView();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidChangeFrameNotification, object: nil)
    }
    
    func initView(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardInputView.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardInputView.keyboardShow(_:)), name:UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardInputView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardInputView.keyboardHide(_:)), name: UIKeyboardDidHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KeyboardInputView.keyboardChangeFrame(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        
        self.backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        centerView = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, 40))
        centerView.backgroundColor = UIColor.whiteColor()
        self.addSubview(centerView)
        
        inputTextView = UITextField(frame: CGRectMake(5, 5, centerView.frame.size.width-70, 30))
        inputTextView.placeholder = "输入评论内容"
        inputTextView.layer.cornerRadius = 5
        inputTextView.clearButtonMode = UITextFieldViewMode.WhileEditing
        inputTextView.layer.masksToBounds = true
        inputTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        inputTextView.layer.borderWidth = 0.5
        inputTextView.font = UIFont.systemFontOfSize(15)
        centerView.addSubview(inputTextView)
        
        inputTextView.leftView = UIView(frame: CGRectMake(0, 0, 10, inputTextView.frame.size.height))
        inputTextView.leftViewMode = UITextFieldViewMode.Always
        
        submitBtn = UIButton(frame: CGRectMake(centerView.frame.size.width-60, 5, 55, 30))
        submitBtn.backgroundColor = Helper.parseColor(0x2B97EDFF)
        submitBtn.setTitle("确定", forState: UIControlState.Normal)
        submitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        submitBtn.titleLabel?.font = UIFont.systemFontOfSize(Helper.scale(58))
        submitBtn.layer.cornerRadius = 3
        submitBtn.layer.masksToBounds = true
        centerView.addSubview(submitBtn)
        submitBtn.addTarget(self, action: #selector(KeyboardInputView.okBtnClicked), forControlEvents: UIControlEvents.TouchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(KeyboardInputView.tapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func okBtnClicked(){
        if inputTextView.text != nil || inputTextView.text != ""
        {
            block!(text: inputTextView.text!)
        }
    }
    
    func closeBtnClicked(){
        self.hide()
    }
    
    func tapped(tap:UITapGestureRecognizer)
    {
        self.hide()
    }
    
    func hide(){
        inputTextView.resignFirstResponder()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0
            }) { (finish) -> Void in
                self.removeFromSuperview()
                self.alpha = 1
        }
    }
    
    func keyboardWillShow(notify:NSNotification)
    {
        
    }
    
    func keyboardShow(notify:NSNotification)
    {
        
    }
    
    func keyboardWillHide(notify:NSNotification)
    {
        centerView.frame = CGRectMake(0, UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width, centerView.frame.size.height)
    }
    
    func keyboardHide(notify:NSNotification)
    {
        
    }
    
    func keyboardChangeFrame(notify:NSNotification)
    {
        let userInfo = notify.userInfo as! NSDictionary
        let keyboardF = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue;
        print(keyboardF.origin.y)
        UIView.animateWithDuration(0.1) { () -> Void in
            self.centerView.frame = CGRectMake(0, keyboardF.origin.y - self.centerView.frame.size.height, keyboardF.size.width, self.centerView.frame.size.height)
        }
    }
    
    func show(block:((text:String)->Void)){
//        inputTextView.text = ""
        self.block = block
        UIApplication.sharedApplication().delegate!.window!?.addSubview(self)
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