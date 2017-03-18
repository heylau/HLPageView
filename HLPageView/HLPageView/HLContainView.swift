//
//  HLContainView.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit

class HLContainView: UIView {

    var childVcs :[UIViewController]
    var parentVc :UIViewController
    
    
    init(frame: CGRect,childVcs:[UIViewController],parentVc:UIViewController) {
       
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}


extension HLContainView {
    fileprivate func setupUI(){
 
        
        
        
    }
}
