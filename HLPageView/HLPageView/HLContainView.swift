//
//  HLContainView.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit

class HLContainView: UIView {

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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
