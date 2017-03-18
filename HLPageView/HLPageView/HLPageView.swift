//
//  HLPageView.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit

class HLPageView: UIView {
    var titles :[String]
    var childVcs :[UIViewController]
    var style :HLPageStyle
    var parentVc :UIViewController
    
    
    init(frame: CGRect,titles :[String],style: HLPageStyle,childVcs:[UIViewController],parentVc:UIViewController) {
        self.titles = titles
        self.style = style
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


extension HLPageView {
    fileprivate func setupUI(){
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.size.width, height:style.titleHeight )
        
        let titleView = HLTitleView(frame: titleFrame, titles: titles, style: style)
        
        titleView.backgroundColor = UIColor(hexString: "#000080")
        addSubview(titleView)
        
        let containFrame = CGRect(x: 0, y: titleFrame.maxY, width: bounds.size.width, height: bounds.size.height - style.titleHeight)
        let containView = HLContainView(frame:containFrame, childVcs: childVcs, parentVc: parentVc)
        
        containView.backgroundColor = UIColor.brown
        
        addSubview(containView)
        
        

   
    }
}
