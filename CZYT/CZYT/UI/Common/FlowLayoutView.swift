//
//  FlowLayoutView.swift
//  GiMiHelper_Kid
//
//  Created by shuaidan on 16/6/17.
//  Copyright © 2016年 成超. All rights reserved.
//

import UIKit


class FalowLayoutElementInfo {
   
    var text:String!
    var row:Int! = 0            //  行
    var column:Int! = 0         //  列
    var dataBtn:UIButton! = UIButton()
}


@objc protocol FlowLayoutViewDelegate : NSObjectProtocol {
    
    func flowLayoutViewClickedBtn(view:FlowLayoutView, btn:UIButton, text:String)
}

class FlowLayoutView : UIView {

    var dataInfo:Array<FalowLayoutElementInfo>?
    var textFontSize:CGFloat?
    weak var delegate:FlowLayoutViewDelegate?
    
    override init(frame: CGRect) {
 
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.8, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
           
    func setDatas(datas:Array<String>?,  textFontSize:CGFloat = 15 , viewWidth:CGFloat! = 0) {
   
//        if nil == datas || datas?.count < 1  {
//            return
//        }
//        self.textFontSize = textFontSize
//        dataInfo = [FalowLayoutElementInfo]()
//        var vWidth = viewWidth
//        if 0 == viewWidth {
//            vWidth = GetSWidth()
//        }
//        let btnHeight:CGFloat! = Helper.scale(106)
//        var curWidth:CGFloat! = 0
//        let space:CGFloat! = Helper.scale(30)
//        for i in 0 ..< (datas?.count)! {
//            var oneDataInfo = FalowLayoutElementInfo()
//            oneDataInfo.text = datas![i]
//            oneDataInfo.dataBtn.tag = i
//            var textWidth = Helper.getTextSize(oneDataInfo.text, font: UIFont.systemFontOfSize(textFontSize), size: CGSizeMake(CGFloat(MAXFLOAT), btnHeight)).width
//            textWidth = (textWidth + Helper.scale(90)) > vWidth ? vWidth : (textWidth + Helper.scale(90))
//            if 0 == i {
//                oneDataInfo.row = 0
//                oneDataInfo.column = 0
//                oneDataInfo.dataBtn.frame = CGRectMake(5, 5, textWidth, btnHeight)
//                curWidth = textWidth + 5
//            }
//            else {
//                let rSpace = space > 5 ? space : 5
//                if curWidth + space + textWidth + rSpace <= vWidth {
//                    oneDataInfo.column = dataInfo![i-1].column + 1
//                    oneDataInfo.row = dataInfo![i-1].row
//                    oneDataInfo.dataBtn.frame = CGRectMake(curWidth + space, dataInfo![i-1].dataBtn.frame.origin.y, textWidth, btnHeight)
//                    curWidth = curWidth + textWidth + space
//                }
//                else {
//                    oneDataInfo.column = 0
//                    oneDataInfo.row = dataInfo![i-1].row + 1
//                    oneDataInfo.dataBtn.frame = CGRectMake(5, dataInfo![i-1].dataBtn.frame.origin.y + btnHeight + Helper.scale(30) , textWidth, btnHeight)
//                    curWidth = textWidth + 5
//                }
//            }
//            setFalowLayoutData(&oneDataInfo)
//            if 0 == i {
//                oneDataInfo.dataBtn.setTitleColor(ThemeManager.current().whiteFontColor, forState: .Normal)
//                oneDataInfo.dataBtn.backgroundColor = ThemeManager.current().mainColor
//            }else{
//                oneDataInfo.dataBtn.setTitleColor(ThemeManager.current().grayFontColor, forState: .Normal)
//                oneDataInfo.dataBtn.backgroundColor = ThemeManager.current().foregroundColor
//            }
//            self.dataInfo?.append(oneDataInfo)
//        }
//        changeView()
        
        if nil == datas || datas?.count < 1  {
            return
        }
        self.textFontSize = textFontSize
        dataInfo = [FalowLayoutElementInfo]()
        var vWidth = viewWidth
        if 0 == viewWidth {
            vWidth = GetSWidth()
        }
        let btnHeight:CGFloat! = Helper.scale(106)
        var curWidth:CGFloat! = 0
        
        var btnWidth:CGFloat = 70;
        
        var space:CGFloat! = (GetSWidth()-btnWidth*4)/5
        
        if datas?.count < 4 {
            space = (GetSWidth() - btnWidth * CGFloat(datas!.count))/(CGFloat(datas!.count) + 1)
        }
        
        
        for i in 0 ..< (datas?.count)! {
            var oneDataInfo = FalowLayoutElementInfo()
            oneDataInfo.text = datas![i]
            oneDataInfo.dataBtn.tag = i
            var textWidth = Helper.getTextSize(oneDataInfo.text, font: UIFont.systemFontOfSize(textFontSize), size: CGSizeMake(CGFloat(MAXFLOAT), btnHeight)).width
            textWidth = btnWidth//(textWidth + Helper.scale(90)) > vWidth ? vWidth : (textWidth + Helper.scale(90))
            if 0 == i {
                oneDataInfo.row = 0
                oneDataInfo.column = 0
                oneDataInfo.dataBtn.frame = CGRectMake(space, 5, textWidth, btnHeight)
                curWidth = textWidth + space
            }
            else {
                let rSpace = space > 5 ? space : 5
                if curWidth + space + textWidth + rSpace <= vWidth {
                    oneDataInfo.column = dataInfo![i-1].column + 1
                    oneDataInfo.row = dataInfo![i-1].row
                    oneDataInfo.dataBtn.frame = CGRectMake(curWidth + space, dataInfo![i-1].dataBtn.frame.origin.y, textWidth, btnHeight)
                    curWidth = curWidth + textWidth + space
                }
                else {
                    oneDataInfo.column = 0
                    oneDataInfo.row = dataInfo![i-1].row + 1
                    oneDataInfo.dataBtn.frame = CGRectMake(space, dataInfo![i-1].dataBtn.frame.origin.y + btnHeight + Helper.scale(30) , textWidth, btnHeight)
                    curWidth = textWidth + space
                }
            }
            setFalowLayoutData(&oneDataInfo)
            if 0 == i {
                oneDataInfo.dataBtn.setTitleColor(ThemeManager.current().whiteFontColor, forState: .Normal)
                oneDataInfo.dataBtn.backgroundColor = ThemeManager.current().mainColor
            }else{
                oneDataInfo.dataBtn.setTitleColor(ThemeManager.current().grayFontColor, forState: .Normal)
                oneDataInfo.dataBtn.backgroundColor = ThemeManager.current().foregroundColor
            }
            self.dataInfo?.append(oneDataInfo)
        }
        changeView()
        
    }
    
    func changeView() {
       
        var frame = self.frame
        if 5 > frame.size.width {
            frame.size.width = GetSWidth()
        }
        frame.size.height = dataInfo![(dataInfo?.count)!-1].dataBtn.frame.origin.y + dataInfo![(dataInfo?.count)!-1].dataBtn.frame.size.height + 5
        self.frame = frame
        for i in 0 ..< (dataInfo?.count)! {
            self.addSubview(dataInfo![i].dataBtn)
          //  print(dataInfo![i].dataBtn.frame)
        }
    }
    
    
    func setFalowLayoutData(inout data:FalowLayoutElementInfo) {
        data.dataBtn.layer.cornerRadius = data.dataBtn.frame.height/2
        data.dataBtn.setTitle(data.text, forState: UIControlState.Normal)
        data.dataBtn.setTitleColor(ThemeManager.current().grayFontColor, forState: UIControlState.Normal)
        data.dataBtn.setTitleColor(ThemeManager.current().mainColor, forState: UIControlState.Highlighted)
       // data?.dataBtn.setBackgroundImage(Consts.btnLightedImage, forState: UIControlState.Highlighted)
        data.dataBtn.titleLabel?.font = UIFont.systemFontOfSize(textFontSize!)
        data.dataBtn.layer.masksToBounds = true
//        data.dataBtn.layer.borderWidth = 0.5
//        data.dataBtn.layer.borderColor = Helper.parseColor(0xccccccff).CGColor
        data.dataBtn.addTarget(self, action: #selector(FlowLayoutView.btnClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
        
    func btnClicked(btn:UIButton) {
      
        for var info:FalowLayoutElementInfo in self.dataInfo!
        {
            if info.dataBtn .isEqual(btn)
            {
                info.dataBtn.setTitleColor(ThemeManager.current().whiteFontColor, forState: .Normal)
                info.dataBtn.backgroundColor = ThemeManager.current().mainColor
            }else{
                info.dataBtn.setTitleColor(ThemeManager.current().grayFontColor, forState: .Normal)
                info.dataBtn.backgroundColor = ThemeManager.current().foregroundColor
            }
        }
        
        if nil != delegate && true == delegate?.respondsToSelector(#selector(FlowLayoutViewDelegate.flowLayoutViewClickedBtn(_:btn:text:))) {
            delegate?.flowLayoutViewClickedBtn(self, btn: btn, text: btn.currentTitle!)
        }
    }

}










