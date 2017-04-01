//
//  HLContainView.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit
protocol HLContainViewDelegate :class{
    func containViewDidEndScroll(_ containView:HLContainView,DidEndScroll index:Int)
    
    func containView(_ containView:HLContainView,sourceIndex:Int,targetIndex:Int,progress:CGFloat)
}
private let kCCellID = "kCCellID"
class HLContainView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    weak var delegate:HLContainViewDelegate?
    var childVcs :[UIViewController]
    var parentVc :UIViewController
    fileprivate var isForbidDelegate :Bool = false

    fileprivate var beginOffset :CGFloat = 0
    fileprivate lazy var collectionView :UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal

       let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kCCellID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    
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
 
        for child in childVcs {
          parentVc.addChildViewController(child)
        }
        
        
        addSubview(collectionView)
        
    }
}


extension HLContainView{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCCellID, for: indexPath)
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        let childVc = childVcs[indexPath.item]
        cell.contentView.addSubview(childVc.view)
//        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
}


extension HLContainView {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDidEndScroll()
    }
    
    private func scrollViewDidEndScroll(){
        let index = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        delegate?.containViewDidEndScroll(self, DidEndScroll: index)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidDelegate = false
        beginOffset = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let containOffset = scrollView.contentOffset.x

        guard containOffset != beginOffset  && !isForbidDelegate else {
            return
        }
        var sourceIndex = 0
        var targetIndex = 0
        var progress :CGFloat = 0
        let collectionWidth = collectionView.bounds.width
        if containOffset >  beginOffset{//左滑
            sourceIndex = Int(containOffset / collectionWidth)
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            progress = (containOffset - beginOffset ) / collectionWidth
            if containOffset - beginOffset == collectionWidth {
                targetIndex = sourceIndex
            }
        }else{//右滑
            targetIndex = Int(containOffset / collectionWidth)
            sourceIndex = targetIndex + 1
            progress = (beginOffset - containOffset) / collectionWidth
            
        }
        
        

        delegate?.containView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
}

extension HLContainView :HLTitleViewDelegate{
    func titleView(_ titleView: HLTitleView, targetIndex: Int) {
        isForbidDelegate = true
        let  indexPath  = IndexPath(item: targetIndex, section: 0)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
