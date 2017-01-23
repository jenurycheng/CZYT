//
//  SelectFileViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2017/1/18.
//  Copyright © 2017年 chester. All rights reserved.
//

import UIKit

class SelectFileViewController: BasePortraitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选择文件"
        let resource = ResourceDocumentFileView(frame: self.view.bounds)        
        self.view.addSubview(resource)
        resource.viewWillAppear()
        // Do any additional setup after loading the view.
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
