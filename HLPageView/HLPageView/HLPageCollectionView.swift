//
//  HLPageCollectionView.swift
//  HLPageView
//
//  Created by heylau on 2017/4/4.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit
protocol HLPageCollecitonViewDataSource :class{
    func numberOfSectionInPageCollectionView(_ pageCollectionView :HLPageCollectionView) -> Int
    func pageCollectionView(_ pageCollectionView :HLPageCollectionView, numberOfSection section :Int) -> Int
    
    func pageCollectionView(_ pageCollectionView :HLPageCollectionView,_ collectionView :UICollectionView ,cellAtIndexPath indexPath :IndexPath) -> UICollectionViewCell
    
}
class HLPageCollectionView: UIView {
    
    fileprivate var titles :[String]
    fileprivate var style :HLPageStyle
    fileprivate var pageControl  :UIPageControl!
    weak var dataSource :HLPageCollecitonViewDataSource?
    fileprivate var collectionView :UICollectionView!
    fileprivate var layout :HLPageCollecitonLayout
    fileprivate var currentIndex : IndexPath = IndexPath(item: 0, section: 0)
    fileprivate var titleView :HLTitleView!
    init(frame: CGRect,titles:[String],style :HLPageStyle,layout :HLPageCollecitonLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        super.init(frame:frame)
        setupUI()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension HLPageCollectionView {
    fileprivate func setupUI()  {
        let titleY = style.isTitleInTop ? 0 : bounds.height - style.titleHeight
        let titleFrame = CGRect(x: 0, y: titleY, width: bounds.width, height: style.titleHeight)
        
        let titleView = HLTitleView(frame: titleFrame, titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        self.titleView = titleView
        addSubview(titleView)
        
        let collectionY = style.isTitleInTop ? style.titleHeight : 0
        
        let  collectionFrame = CGRect(x: 0, y: collectionY, width: bounds.width, height: bounds.height - style.titleHeight - style.pageControlHeight)
        
        let collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.randomColor()
        collectionView.dataSource = self
  
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        self.collectionView = collectionView
        addSubview(collectionView)
        
        let pageFrame = CGRect(x: 0, y: collectionFrame.maxY, width: bounds.width, height: style.titleHeight)
        let pageControl = UIPageControl(frame: pageFrame)
        pageControl.numberOfPages = 4
        pageControl.backgroundColor = UIColor.lightGray
        self.pageControl = pageControl
        addSubview(pageControl)
        
    }
}

extension HLPageCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return dataSource?.numberOfSectionInPageCollectionView(self) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemNum = dataSource?.pageCollectionView(self, numberOfSection: section) ?? 0
        if section == 0 {
            pageControl.numberOfPages = (itemNum - 1) / (layout.cols * layout.rows) + 1
        }
        return itemNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return (dataSource?.pageCollectionView(self, collectionView, cellAtIndexPath: indexPath))!
    }
}


extension HLPageCollectionView {
    func registerCell(_ cell :AnyClass?,reusableIdentifier :String){
        collectionView?.register(cell, forCellWithReuseIdentifier: reusableIdentifier)
    }
    
    func registerNib(_ nib :UINib?,reusableIdentifier :String){
        collectionView?.register(nib, forCellWithReuseIdentifier: reusableIdentifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
}


extension HLPageCollectionView :HLTitleViewDelegate {
    func titleView(_ titleView: HLTitleView, targetIndex: Int) {
        let indexPath  = IndexPath(item: 0, section: targetIndex)
        print(indexPath)
        let itemNum = dataSource?.pageCollectionView(self, numberOfSection: targetIndex) ?? 0
        
        pageControl.numberOfPages = (itemNum - 1) / (layout.rows * layout.cols) + 1
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        pageControl.currentPage = 0
//        
        currentIndex = indexPath
//        let left = layout.sectionInset.left
        collectionView.contentOffset.x -= layout.sectionInset.left

    }
}

extension HLPageCollectionView :UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewEndScroll()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    private func scrollViewEndScroll()  {
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        
        guard let indexPath = collectionView.indexPathForItem(at: point) else{return}
        
        if indexPath.section != currentIndex.section  {
            let itemCount = dataSource?.pageCollectionView(self, numberOfSection: indexPath.section) ?? 0
            pageControl.numberOfPages = (itemCount - 1) / (layout.cols * layout.rows) + 1
            
            currentIndex = indexPath
            
        }
        
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
        
        titleView.setCurrentIndex(indexPath.section)
        
        
        
    }
}
