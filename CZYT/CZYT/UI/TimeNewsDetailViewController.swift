//
//  TimeNewsDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/12/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit

class TimeNewsDetailViewController: BaseDetailViewController {

    var id:String? = ""
    var dataSourceApi = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "时政新闻"
        self.loadData()
        
        let share = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(TimeNewsDetailViewController.share))
        self.navigationItem.rightBarButtonItem = share
        // Do any additional setup after loading the view.
    }
    
    func share()
    {
        UMSocialUIManager.showShareMenuViewInWindowWithPlatformSelectionBlock { (type, info) in
            let msg = UMSocialMessageObject()
            let thumb = "http://111.9.93.229:20080/unity/userfiles/user/photo/portrait.jpg"
            let shareObject = UMShareWebpageObject.shareObjectWithTitle("Test", descr: "Describe", thumImage: thumb)
            shareObject.webpageUrl = "http://www.baidu.com"
            msg.shareObject = shareObject
            
            UMSocialManager.defaultManager().shareToPlatform(type, messageObject: msg, currentViewController: self, completion: { (data, error) in
                if error != nil
                {
                    print(error)
                }else{
                    print("success")
                }
            })
        }
    }
    
    func loadData()
    {
        self.view.showHud()
        dataSourceApi.getLeaderActivityDetail(id!, success: { (result) in
            self.update(result)
            self.view.dismiss()
        }) { (error) in
            self.view.dismiss()
            NetworkErrorView.show(self.view, data: error, callback: {
                self.loadData()
            })
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
