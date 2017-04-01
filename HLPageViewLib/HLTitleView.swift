//
//  HLTitleView.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit
protocol HLTitleViewDelegate :class{
    func titleView(_ titleView: HLTitleView,targetIndex :Int)
}
class HLTitleView: UIView {

    weak var delegate :HLTitleViewDelegate?
    
    var titles :[String]
    var style :HLPageStyle
    
    fileprivate var currentIndex = 0
    fileprivate var targetIndex = 0
    fileprivate lazy var titleLabels :[UILabel] = [UILabel]()
    fileprivate lazy var normalRGB :(CGFloat,CGFloat,CGFloat) = self.style.normalColor.getRGBValue()
    fileprivate lazy var selctedRGB :(CGFloat,CGFloat,CGFloat) = self.style.selectColor.getRGBValue()
    fileprivate lazy var deltaRGB :(CGFloat,CGFloat,CGFloat) = {
        let deltaR = self.selctedRGB.0 - self.normalRGB.0
        let deltaG = self.selctedRGB.1 - self.normalRGB.1
        let deltaB = self.selctedRGB.2 - self.normalRGB.2

        return (deltaR,deltaG,deltaB)
        
    }()
    fileprivate lazy var bottomLine :UIView = {
       let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        return bottomLine
    }()
    fileprivate lazy var coverView :UIView = {
        let coverView  = UIView()
        coverView.backgroundColor = self.style.coverViewColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
        
    }()
    fileprivate lazy var scrollView :UIScrollView = {
        let scrollView = UIScrollView(frame:self.bounds)
        scrollView.showsHorizontalScrollIndicator = false;
        
        return scrollView;
    }()
    init(frame: CGRect,titles:[String],style:HLPageStyle) {
        
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        self.setupUI();
        scrollView.scrollsToTop = false;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

   
}

extension HLTitleView
{
    fileprivate func setupUI(){
     addSubview(scrollView)
        setLabels()
        if style.isShowBottomLine {
            setupBottomLine()
        }
        
        if style.isShowCover {
            setupCoverView()
        }
        
    }
    
    private func setupBottomLine() {
       scrollView.addSubview(bottomLine)
        bottomLine.frame = titleLabels.first!.frame
        bottomLine.frame.size.height = style.bottomLineHeight
        bottomLine.frame.origin.y = style.titleHeight - style.bottomLineHeight
        
        
    }
    
    private func setupCoverView() {
        
       scrollView.insertSubview(coverView, at: 0)
        guard let firstLabel = titleLabels.first else{return}
        var coverW :CGFloat = firstLabel.frame.size.width
        let coverH :CGFloat = style.coverViewHeight
        var coverX :CGFloat = firstLabel.frame.origin.x
        let coverY :CGFloat = (scrollView.frame.height - style.coverViewHeight) * 0.5
        if style.isSrollEnable {
            coverX -= style.converViewMargin
            coverW += style.converViewMargin * 2
        }else{
            coverW -= style.coverViewLrEdge * 2
            coverX += style.coverViewLrEdge
            
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.layer.masksToBounds = true
        
    }
    
    
    private func setLabels(){
        
        
        for (i,title) in titles.enumerated() {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i == 0 ? style.selectColor : style.normalColor
            titleLabel.font = style.titleFont
            
            scrollView.addSubview(titleLabel)
            let tapGes = UITapGestureRecognizer(target: self, action:#selector(titleTap(_ :)))
            titleLabel.addGestureRecognizer(tapGes)
            titleLabels.append(titleLabel)
            titleLabel.isUserInteractionEnabled = true
        }
      
        var labelW :CGFloat = bounds.width / CGFloat(titleLabels.count)
        let labelH :CGFloat = style.titleHeight
        var labelX :CGFloat = 0
        let labelY :CGFloat = 0
        
        
        for (i,titleLabel) in titleLabels.enumerated() {
            if style.isSrollEnable {
                
               labelW =  (titleLabel.text! as NSString).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:style.titleFont], context: nil).width
                
                labelX = i == 0 ? style.titleMargin * 0.5: titleLabels[i - 1].frame.maxX + style.titleMargin
             
                
            }else{
              labelX = labelW * CGFloat(i)
     
            }
            
              titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            print(titleLabel.frame)
        }
        
        if style.isSrollEnable {
            scrollView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: style.titleHeight)
        }
        
        if style.isScale {
            titleLabels.first?.transform = CGAffineTransform(scaleX:style.maxScale, y: style.maxScale)
        }
        
        
    }
    
  
}

extension HLTitleView{
     func titleTap(_ tap :UITapGestureRecognizer){
       
        guard let targetLabel = tap.view as? UILabel else {
            return
        }
        
        guard targetLabel.tag != currentIndex else {
            return
        }
        
        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        
        currentIndex = targetLabel.tag
        
        adjustLabelPosition()
        
        
        delegate?.titleView(self, targetIndex: currentIndex)
        
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: { 
              
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.size.width

            })}
        
        if  style.isScale {
            UIView.animate(withDuration: 0.25, animations: { 
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        if style.isShowCover {
            UIView.animate(withDuration: 0.25, animations: { 
                self.coverView.frame.origin.x = self.style.isSrollEnable ? targetLabel.frame.origin.x - self.style.converViewMargin :targetLabel.frame.origin.x + self.style.coverViewLrEdge
                
                self.coverView.frame.size.width = self.style.isSrollEnable ? (targetLabel.frame.size.width + self.style.converViewMargin * 2) : targetLabel.frame.width - self.style.coverViewLrEdge * 2
            })
            
            
        }
        
        
    }
    
    fileprivate func adjustLabelPosition() {
        
        guard style.isSrollEnable  else {
            return
        }
        let targetLabel = titleLabels[currentIndex]
        var offset = targetLabel.center.x - scrollView.bounds.width * 0.5
        if offset < 0 {
            offset = 0
        }
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if offset > maxOffsetX {
            offset = maxOffsetX
        }
        
        scrollView.setContentOffset(CGPoint(x:offset,y:0), animated: true)

    }
}


extension HLTitleView :HLContainViewDelegate{
    func containViewDidEndScroll(_ containView: HLContainView, DidEndScroll index: Int) {
        currentIndex = index
//        titleLabels[currentIndex].textColor = style.normalColor
//        titleLabels[targetIndex].textColor = style.selectColor

        for (i,titleLabel) in titleLabels.enumerated() {
            if i == targetIndex {
                titleLabels[i].textColor = style.selectColor
            }else{
                titleLabel.textColor = style.normalColor
            }
        }
       adjustLabelPosition()
        

    }
    
    func containView(_ containView: HLContainView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        if progress == 1 {
            self.targetIndex = targetIndex

        }
        let soucreLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        soucreLabel.textColor = UIColor(r: selctedRGB.0 - deltaRGB.0 * progress, g: selctedRGB.1 - deltaRGB.1 * progress, b: selctedRGB.2 - deltaRGB.2 * progress)
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0 * progress, g: normalRGB.1 + deltaRGB.1 * progress, b: normalRGB.2 + deltaRGB.2 * progress)
        
        let deltaWidth = targetLabel.frame.width - soucreLabel.frame.width
        let deltaX = targetLabel.frame.origin.x - soucreLabel.frame.origin.x
        if style.isShowBottomLine {
            
            
            bottomLine.frame.size.width = deltaWidth * progress + soucreLabel.frame.width
            bottomLine.frame.origin.x = deltaX * progress + soucreLabel.frame.origin.x
        }
        
        if style.isScale {
            let deltaScale = style.maxScale - 1.0
            soucreLabel.transform = CGAffineTransform(scaleX: style.maxScale - deltaScale * progress, y: style.maxScale - deltaScale * progress)
            targetLabel.transform = CGAffineTransform(scaleX: 1 + deltaScale * progress, y: 1 + deltaScale * progress)
        }
        
        if style.isShowCover {
            coverView.frame.origin.x = style.isSrollEnable ? (soucreLabel.frame.origin.x - style.converViewMargin + deltaX * progress) : (soucreLabel.frame.origin.x + style.coverViewLrEdge + deltaX * progress)
            coverView.frame.size.width = style.isSrollEnable ? (soucreLabel.frame.width + style.converViewMargin * 2 + deltaWidth * progress) : (soucreLabel.frame.width - style.coverViewLrEdge * 2 + deltaWidth * progress)
            
        }
    }
    

}
