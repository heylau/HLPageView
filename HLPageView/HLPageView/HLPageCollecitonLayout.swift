//
//  HLPageCollecitonLayout.swift
//  HLPageView
//
//  Created by heylau on 2017/4/4.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit

class HLPageCollecitonLayout: UICollectionViewLayout {
    var sectionInset :UIEdgeInsets = UIEdgeInsets.zero
    var itemMargin :CGFloat = 0
    var lineMargin :CGFloat = 0
    var cols :Int = 4
    var rows :Int = 2
    
    
    fileprivate lazy var attributes :[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    fileprivate var totalWidth :CGFloat = 0
    
}


extension HLPageCollecitonLayout {
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {
            return
        }
        let sections = collectionView.numberOfSections
        
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - ((CGFloat(cols - 1)) * itemMargin)) / CGFloat(cols)
        
        let itemH = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom - lineMargin * CGFloat(rows - 1)) / CGFloat(rows)
        
        var preViousNumOfPage = 0

        for section in 0..<sections {
            
            let items = collectionView.numberOfItems(inSection: section)
            
            
            for item in 0..<items {
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let currentPage = item / (cols * rows)
                let currentIndex = item % (cols * rows)
                
                let x :CGFloat = CGFloat(preViousNumOfPage + currentPage) * collectionView.bounds.width + sectionInset.left + (itemW + itemMargin) * CGFloat((currentIndex % cols))
                
                let y = sectionInset.top + (itemH + lineMargin) * CGFloat((currentIndex / cols))
             
                

                attribute.frame = CGRect(x: x, y: y, width: itemW, height: itemH)
                
                attributes.append(attribute)
            }
            
            preViousNumOfPage += (items - 1) / (cols * rows) + 1
        }
        
        totalWidth = CGFloat(preViousNumOfPage) * collectionView.bounds.width
        
        
    }
}

extension HLPageCollecitonLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

extension HLPageCollecitonLayout {
    override var collectionViewContentSize: CGSize
        {
            return CGSize(width: totalWidth, height:0)
    }
}
