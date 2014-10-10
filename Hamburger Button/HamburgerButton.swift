//
//  HamburgerButton.swift
//  Hamburger Button
//
//  Created by Robert Böhnke on 02/07/14.
//  Copyright (c) 2014 Robert Böhnke. All rights reserved.
//

import CoreGraphics
import QuartzCore
import UIKit

@IBDesignable class HamburgerButton : UIButton {
    
    @IBInspectable var color:UIColor = UIColor.whiteColor()
    @IBInspectable var size:CGFloat = 0
    @IBInspectable var menu:Bool = false
    
    var scaleFactor:CGFloat = 1.0
    var strokeSize:CGFloat
        {
        get
        {
            return 4 * scaleFactor
        }
    }
    
    let menuStrokeStart: CGFloat = 0.325
    let menuStrokeEnd: CGFloat = 0.95
    
    let hamburgerStrokeStart: CGFloat = 0.0263
    let hamburgerStrokeEnd: CGFloat = 0.1126
    
    var drawingRect:Bool = false
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    override func intrinsicContentSize() -> CGSize {
        if(size > 0)
        {
            return CGSize(width: size, height: size)
        }
        else
        {
            return CGSize(width: 44.0, height: 44.0)
        }
    }
    
    override func drawRect(rect: CGRect)
    {
        scaleFactor = (size > 0) ? size / 54.0 : (frame.height < frame.width) ? frame.height / 54.0 : frame.width / 54.0
        let outline:CGPath = {
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 10 * self.scaleFactor, 27 * self.scaleFactor)
            CGPathAddCurveToPoint(path, nil, 12.00 * self.scaleFactor, 27.00 * self.scaleFactor, 28.02 * self.scaleFactor, 27.00 * self.scaleFactor, 40 * self.scaleFactor, 27 * self.scaleFactor)
            CGPathAddCurveToPoint(path, nil, 55.92 * self.scaleFactor, 27.00 * self.scaleFactor, 50.47 * self.scaleFactor,  2.00 * self.scaleFactor, 27 * self.scaleFactor,  2 * self.scaleFactor)
            CGPathAddCurveToPoint(path, nil, 13.16 * self.scaleFactor,  2.00 * self.scaleFactor,  2.00 * self.scaleFactor, 13.16 * self.scaleFactor,  2 * self.scaleFactor, 27 * self.scaleFactor)
            CGPathAddCurveToPoint(path, nil,  2.00 * self.scaleFactor, 40.84 * self.scaleFactor, 13.16 * self.scaleFactor, 52.00 * self.scaleFactor, 27 * self.scaleFactor, 52 * self.scaleFactor)
            CGPathAddCurveToPoint(path, nil, 40.84 * self.scaleFactor, 52.00 * self.scaleFactor, 52.00 * self.scaleFactor, 40.84 * self.scaleFactor, 52 * self.scaleFactor, 27 * self.scaleFactor)
            CGPathAddCurveToPoint(path, nil, 52.00 * self.scaleFactor, 13.16 * self.scaleFactor, 42.39 * self.scaleFactor,  2.00 * self.scaleFactor, 27 * self.scaleFactor,  2 * self.scaleFactor)
            CGPathAddCurveToPoint(path, nil, 13.16 * self.scaleFactor,  2.00 * self.scaleFactor,  2.00 * self.scaleFactor, 13.16 * self.scaleFactor,  2 * self.scaleFactor, 27 * self.scaleFactor)
            
            return path
            }()
        
        let shortStroke:CGPath = {
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 1 * self.scaleFactor, 2)
            CGPathAddLineToPoint(path, nil, 28 * self.scaleFactor, 2)
            
            return path
            }()
        
        self.top.path = shortStroke
        self.middle.path = outline
        self.bottom.path = shortStroke
        
        for layer in [ self.top, self.middle, self.bottom ] {
            layer.fillColor = nil
            layer.strokeColor = color.CGColor
            layer.lineWidth = strokeSize
            layer.miterLimit = 100
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true
            
            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, strokeSize, kCGLineCapRound, kCGLineJoinMiter, 100)
            
            layer.bounds = CGPathGetPathBoundingBox(strokingPath)
            
            layer.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]
            
            self.layer.addSublayer(layer)
        }
        
        self.top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5)
        self.top.position = CGPointMake((frame.width / 2) + (13.45 * scaleFactor), (frame.height / 2) - (9.5 * scaleFactor))
        self.top.transform = (menu) ? CATransform3DRotate(CATransform3DMakeTranslation(-4 * scaleFactor, 0, 0), -0.7853975, 0, 0, 1) : CATransform3DIdentity
        
        self.middle.position = CGPointMake(frame.width / 2.0, frame.height / 2.0)
        self.middle.strokeStart = (menu) ? menuStrokeStart : hamburgerStrokeStart
        self.middle.strokeEnd = (menu) ? menuStrokeEnd : hamburgerStrokeEnd
        
        self.bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5 )
        self.bottom.position = CGPointMake((frame.width / 2) + (13.45 * scaleFactor), (frame.height / 2) + (9.5 * scaleFactor))
        self.bottom.transform = (menu) ? CATransform3DRotate(CATransform3DMakeTranslation(-4 * scaleFactor, 0, 0), 0.7853975, 0, 0, 1) : CATransform3DIdentity
        
        drawingRect = true
        showsMenu = menu
        drawingRect = false
    }
    
    var showsMenu: Bool = false {
        didSet {
            if(drawingRect)
            {
                return
            }
            let strokeStart = CABasicAnimation(keyPath: "strokeStart")
            let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            
            if self.showsMenu {
                strokeStart.toValue = menuStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
                
                strokeEnd.toValue = menuStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
            } else {
                strokeStart.toValue = hamburgerStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.5, 1.2)
                strokeStart.beginTime = CACurrentMediaTime() + 0.1
                strokeStart.fillMode = kCAFillModeBackwards
                
                strokeEnd.toValue = hamburgerStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.3, 0.5, 0.9)
            }
            
            self.middle.ocb_applyAnimation(strokeStart)
            self.middle.ocb_applyAnimation(strokeEnd)
            
            let topTransform = CABasicAnimation(keyPath: "transform")
            topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
            topTransform.duration = 0.4
            topTransform.fillMode = kCAFillModeBackwards
            
            let bottomTransform = topTransform.copy() as CABasicAnimation
            
            if self.showsMenu {
                let translation = CATransform3DMakeTranslation(-4 * scaleFactor, 0, 0)
                
                topTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, -0.7853975, 0, 0, 1))
                topTransform.beginTime = CACurrentMediaTime() + 0.25
                
                bottomTransform.toValue = NSValue(CATransform3D: CATransform3DRotate(translation, 0.7853975, 0, 0, 1))
                bottomTransform.beginTime = CACurrentMediaTime() + 0.25
            } else {
                topTransform.toValue = NSValue(CATransform3D: CATransform3DIdentity)
                topTransform.beginTime = CACurrentMediaTime() + 0.05
                
                bottomTransform.toValue = NSValue(CATransform3D: CATransform3DIdentity)
                bottomTransform.beginTime = CACurrentMediaTime() + 0.05
            }
            
            self.top.ocb_applyAnimation(topTransform)
            self.bottom.ocb_applyAnimation(bottomTransform)
        }
    }
    
    var top: CAShapeLayer! = CAShapeLayer()
    var bottom: CAShapeLayer! = CAShapeLayer()
    var middle: CAShapeLayer! = CAShapeLayer()
}

extension CALayer {
    func ocb_applyAnimation(animation: CABasicAnimation) {
        let copy = animation.copy() as CABasicAnimation
        
        if !(copy.fromValue != nil) {
            copy.fromValue = self.presentationLayer().valueForKeyPath(copy.keyPath)
        }
        
        self.addAnimation(copy, forKey: copy.keyPath)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath)
    }
}