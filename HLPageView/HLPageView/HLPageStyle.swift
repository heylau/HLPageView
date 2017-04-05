
//
//  HLPageStyle.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit

struct HLPageStyle {

    //标题高度
    var titleHeight :CGFloat = 44
    //标题默认颜色
    var normalColor :UIColor = UIColor(r: 255, g: 255, b: 255)
    //标题选中颜色
    var selectColor :UIColor = UIColor(r: 255, g: 160, b: 0)
    //标题文字大小
    var titleFont :UIFont = UIFont.systemFont(ofSize: 14)
    //标题滑动可用
    var isSrollEnable :Bool = false
    //标题文字间距
    var titleMargin :CGFloat = 20
    //标题底部线条
    var isShowBottomLine :Bool = true
    //标题底部线条颜色
    var bottomLineColor :UIColor = UIColor(r: 255, g: 160, b: 0)
    //标题底部线条高度
    var bottomLineHeight :CGFloat = 2
    //标题文字缩放
    var isScale :Bool = false
    //标题文字最大缩放
    var maxScale :CGFloat = 1.2
    //标题遮盖颜色
    var coverViewColor :UIColor = UIColor.black
    //标题遮盖透明度
    var coverViewAlpha :CGFloat = 0.3
    //标题遮盖
    var isShowCover :Bool = false
    //标题遮盖高度
    var coverViewHeight :CGFloat = 25
    //标题遮盖圆角
    var coverViewRadius :CGFloat = 12.5
    //标题遮盖间距(滑动模式下)
    var converViewMargin :CGFloat = 8
    //标题遮盖左右边距(不可滑动模式下)
    var coverViewLrEdge :CGFloat = 10
    //pageView高度
    var pageControlHeight :CGFloat = 20
    //title显示位置
    var isTitleInTop :Bool = true
    
}
