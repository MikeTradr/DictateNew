//
//  PZDisclosureIndicator.swift
//  Dictate
//
//  Created by Mike Derr on 2/2/16.
//  Copyright © 2016 ThatSoft.com. All rights reserved.
//
// from here:  http://pastebin.com/xgReAeWc]
// and... http://stackoverflow.com/questions/19492683/how-to-change-color-of-disclosure-indicator-of-uitableveiw-programatically

import UIKit

class PZDisclosureIndicator: UIView {
    
    var color: UIColor {
        didSet {
            color.getRed(&rgba.red, green: &rgba.green, blue: &rgba.blue, alpha: &rgba.alpha)
        }
    }
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    init(color: UIColor) {
        self.color = color
        rgba = (0, 0, 0, 0)
        super.init(frame: CGRect(x: 0, y: 0, width: 16, height: 24))
        
        backgroundColor = .clearColor()
        setNeedsDisplay()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(context, rgba.red, rgba.green, rgba.blue, rgba.alpha)
        
        CGContextMoveToPoint(context, 4, 0)
        CGContextAddLineToPoint(context, 4, 0)
        CGContextAddLineToPoint(context, 16, 12)
        CGContextAddLineToPoint(context, 4, 24)
        CGContextAddLineToPoint(context, 0, 24 - 4)
        CGContextAddLineToPoint(context, 9, 12)
        CGContextAddLineToPoint(context, 0, 4)
        CGContextAddLineToPoint(context, 4, 0)
        CGContextFillPath(context)
    }
}