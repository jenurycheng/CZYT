//
//  TimeNewsDetailViewController.swift
//  CZYT
//
//  Created by jerry cheng on 2016/12/10.
//  Copyright © 2016年 chester. All rights reserved.
//

import UIKit
import MessageUI

class TimeNewsDetailViewController: BaseDetailViewController {

    var id:String? = ""
    var dataSourceApi = LeaderActivityDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "时政新闻"
        self.loadData()
        
        let share = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(TimeNewsDetailViewController.share))
        self.navigationItem.rightBarButtonItem = share
        // Do any additional setup after loading the view.
    }
    
    func share()
    {
        if self.dataSource == nil
        {
            return
        }
        
        UMSocialManager.default().removePlatformProvider(with: UMSocialPlatformType.sina)
        UMSocialUIManager.showShareMenuViewInWindow { (type, info) in
            
            if type.rawValue == 1500
            {
                self.msg()
                return
            }else if type.rawValue == 1501
            {
                let paste = UIPasteboard.general
                paste.string = self.dataSource?.share_url
                MBProgressHUD.showSuccess("已复制", to: self.view.window)
                return
            }
            
            let msg = UMSocialMessageObject()
            let thumb = UIImage(named: "app_icon")
            let shareObject = UMShareWebpageObject.shareObject(withTitle: self.dataSource!.title, descr: self.dataSource!.content, thumImage: thumb)
            shareObject?.webpageUrl = self.dataSource?.share_url
            msg.shareObject = shareObject
            
            UMSocialManager.default().share(to: type, messageObject: msg, currentViewController: self, completion: { (data, error) in
                if error != nil
                {
                    print(error)
                }else{
                    print("success")
                }
            })
        }
    }
    
    func msg()
    {
//        let str = "10086"

        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.title = "短信分享"
            //短信的内容,可以不设置
            let title = dataSource?.title ?? ""
            let url = dataSource?.share_url ?? ""
            controller.body = "分享自成资合作App：" + title + url
            //联系人列表
//            controller.recipients = []
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            print("本设备不能发短信")
            MBProgressHUD.showError("本设备不能发短信", to: self.view)
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

}

extension TimeNewsDetailViewController : MFMessageComposeViewControllerDelegate
{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        //判断短信的状态
        switch result{
            
        case .sent:
            print("短信已发送")
        case .cancelled:
            print("短信取消发送")
        case .failed:
            print("短信发送失败")
        default:
            print("短信已发送")
            break
        }
    }
}
