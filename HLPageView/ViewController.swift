//
//  ViewController.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit
private let cellID = "pageCell"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        let pageFrame = CGRect(x: 0, y: 100, width:view.bounds.width, height: 300)
        
        let titles = ["热门","高级","专属","豪华"]
        
        var style = HLPageStyle()
        
        style.isShowBottomLine = true
        
        let layout = HLPageCollecitonLayout()
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.itemMargin = 10
        layout.lineMargin = 30
        layout.cols = 6
        layout.rows = 3

        
        let pageCollectionView = HLPageCollectionView(frame: pageFrame, titles: titles, style: style, layout: layout)
        
        pageCollectionView.dataSource = self
        pageCollectionView.registerCell(UICollectionViewCell.self, reusableIdentifier: cellID)
        view.addSubview(pageCollectionView)
        
        

    }

    

    func HLPageViewInit()  {
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


}

extension ViewController :HLPageCollecitonViewDataSource{
    func numberOfSectionInPageCollectionView(_ pageCollectionView: HLPageCollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: HLPageCollectionView, numberOfSection section: Int) -> Int {
        return 30
    }
    
    func pageCollectionView(_ pageCollectionView: HLPageCollectionView, _ collectionView: UICollectionView, cellAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
}
