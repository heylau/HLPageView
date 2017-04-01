//
//  ViewController.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        let pageviewF = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        
        let titles = ["首页","库存","销售","基础","首页库存","库存库存","销售库存","基础库存"]
        
        var childVcs = [UIViewController]()
        for  _ in 0..<titles.count {
            let vc = UIViewController()
            
            vc.view.backgroundColor = UIColor.randomColor()
            
            childVcs.append(vc)
        }
        
        var style = HLPageStyle()
        style.isSrollEnable = true
//        style.titleHeight = 44
//        style.isScale = fal
        let pageView = HLPageView(frame: pageviewF, titles: titles, style: style, childVcs: childVcs, parentVc: self)
        
        view.addSubview(pageView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

