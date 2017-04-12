//
//  BaseViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/6.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    static var NavHidden:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ThemeManager.current().foregroundColor
        // Do any additional setup after loading the view.
    }
    
    deinit {
        CCPrint("deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navHidden = self.isKind(of: BaseNavHiddenViewController.classForCoder())
        if navHidden == true && BaseViewController.NavHidden == true {
            self.navigationController?.navigationBar.alpha = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let hidden = self.isKind(of: BaseNavHiddenViewController.classForCoder())
        BaseViewController.NavHidden = hidden
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
