//
//  PrivateConversationViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/17.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class PrivateConversationViewController: RCConversationViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backItemBar =  UIBarButtonItem(image: UIImage(named: "backbar"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseNavViewController.backItemBarClicked(_:)))
        self.navigationItem.leftBarButtonItem = backItemBar
    }
    
    func backItemBarClicked(item:UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
}
