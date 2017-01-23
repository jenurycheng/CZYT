//
//  ResourceDocumentFileView.swift
//  GiMiHelper_3_0
//
//  Created by 成超 on 11/1/16.
//  Copyright © 2016 shuaidan. All rights reserved.
//

import UIKit

class ResourceDocumentFileView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static var selectedPath:String? = nil
    
    var tableView:UITableView!
    var dataSource = [DocumentDir]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initView()
    }
    
    func viewWillAppear()
    {
        ResourceDocumentFileView.selectedPath = nil
        if self.dataSource.count == 0
        {
            self.reloadData()
        }
    }
    
    var noDataView:NoDataView?
    func reloadData()
    {
        self.dataSource = FileSharedManager.sharedManager().getAllFile()
        self.tableView.reloadData()
        
        if self.dataSource.count == 0
        {
            if noDataView == nil
            {
                noDataView = NoDataView(frame: CGRectMake(0, -64, self.frame.size.width, self.frame.size.height+64), imageName: "data_error", hintText: "没有发现文档")
                noDataView?.backgroundColor = UIColor.whiteColor()
            }
            self.addSubview(noDataView!)
            
            noDataView?.hintDetailLabel.text = "没有发现文档, 您可以\n从QQ,微信等其他应用分享文件至无屏助手\n(ppt,doc,xls,pdf,txt,apk等)"
            
        }else{
            noDataView?.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView()
    {
        tableView = UITableView(frame: self.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        self.addSubview(tableView)
    }
}

extension ResourceDocumentFileView : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].files!.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ResourceDocumentFileView.selectedPath = dataSource[indexPath.section].files![indexPath.row].path
        let nav = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController
        nav?.popViewControllerAnimated(true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].typeName
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont.systemFontOfSize(14)
        cell.textLabel?.textColor = ThemeManager.current().darkGrayFontColor
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        cell.detailTextLabel?.textColor = ThemeManager.current().grayFontColor
        let f = dataSource[indexPath.section].files![indexPath.row]
        cell.textLabel?.text = f.name
        cell.detailTextLabel?.text = String(format: "%.2fMB", Float(f.size!)/1024/1024)
        
        if indexPath.row == dataSource[indexPath.section].files!.count-1 && indexPath.section != dataSource.count-1
        {
            return cell
        }
        
        let line = GetLineView(CGRect(x: 10, y: 49.5, width: GetSWidth()-10, height: 0.5))
        cell.addSubview(line)
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let file = dataSource[indexPath.section].files![indexPath.row]
        let h = MBProgressHUD.showMessag("删除中", toView: self)
        dispatch_async(dispatch_get_global_queue(0, 0)) { 
            do{
                try NSFileManager.defaultManager().removeItemAtPath(file.path!)
                
            }catch{
                
            }
            dispatch_async(dispatch_get_main_queue(), { 
                h.hide(true)
                self.reloadData()
            })
            
        }
        
    }
}
