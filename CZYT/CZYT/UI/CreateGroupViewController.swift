//
//  CreateGroupViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/11/15.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    var dataSource = ChatDataSource()
    
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "创建群组"
        let right = UIBarButtonItem(title: "创建", style: .Plain, target: self, action: #selector(CreateGroupViewController.create))
        self.navigationItem.rightBarButtonItem = right
        // Do any additional setup after loading the view.
    }
    
    func create()
    {
        if Helper.isStringEmpty(nameTextField.text)  {
            MBProgressHUD.showMessag("输入名称", toView: self.view, showTimeSec: 1)
            return
        }
        dataSource.createGroup(["1", "2", "3", "4"], groupName: nameTextField.text!, success: { (result) in
            
            }) { (error) in
                
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
