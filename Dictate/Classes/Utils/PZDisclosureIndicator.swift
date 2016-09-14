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
        
        backgroundColor = .clear()
        setNeedsDisplay()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
        
        context?.move(to: CGPoint(x: 4, y: 0))
        context?.addLine(to: CGPoint(x: 4, y: 0))
        context?.addLine(to: CGPoint(x: 16, y: 12))
        context?.addLine(to: CGPoint(x: 4, y: 24))
        context?.addLine(to: CGPoint(x: 0, y: 24 - 4))
        context?.addLine(to: CGPoint(x: 9, y: 12))
        context?.addLine(to: CGPoint(x: 0, y: 4))
        context?.addLine(to: CGPoint(x: 4, y: 0))
        context?.fillPath()
    }
}
