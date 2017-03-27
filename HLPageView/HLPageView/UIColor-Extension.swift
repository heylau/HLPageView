
//
//  UIColor-Extension.swift
//  HLPageView
//
//  Created by heylau on 2017/3/16.
//  Copyright © 2017年 hey lau. All rights reserved.
//

import UIKit

class UIColor_Extension: NSObject {

}

extension UIColor{
    
    class func randomColor() ->UIColor{
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1)
    }
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    convenience init?(hexString:String) {
        guard hexString.characters.count >= 6 else {
            return nil
        }
        
        var hexTempString = hexString.uppercased()
        
        if hexTempString.hasPrefix("0X") || hexTempString.hasPrefix("##") {
            hexTempString = (hexTempString as NSString).substring(from: 2)
            
        }
        
        
        if hexTempString.hasPrefix("#") {
            hexTempString = (hexTempString as NSString).substring(from: 1)
            
        }
        
        var range = NSRange(location: 0, length: 2)
        let rHex = (hexTempString as NSString).substring(with: range)
        range.location = 2
        let gHex = (hexTempString as NSString).substring(with: range)
        range.location = 4
        let bHex = (hexTempString as NSString).substring(with: range)
        
        var r :UInt32 = 0
        var g :UInt32 = 0
        var b :UInt32 = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)

        
        
      self.init(r: CGFloat(r),g:CGFloat(g) ,b: CGFloat(b))
    }
    
    func getRGBValue() -> (CGFloat,CGFloat,CGFloat) {
        guard let cmps = cgColor.components else {
             fatalError("请确认该颜色由RGB创建")
        }
        return (cmps[0] * 255.0,cmps[1] * 255.0,cmps[2] * 255.0)
    }
}
