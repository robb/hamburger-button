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

class HamburgerButton : UIButton {
    let shortStroke: CGPath = {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 2, 2)
        CGPathAddLineToPoint(path, nil, 28, 2)

        return path
    }()

    let outline: CGPath = {
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 10, 27)
        CGPathAddCurveToPoint(path, nil, 12.00, 27.00, 28.02, 27.00, 40, 27)
        CGPathAddCurveToPoint(path, nil, 55.92, 27.00, 50.47,  2.00, 27,  2)
        CGPathAddCurveToPoint(path, nil, 13.16,  2.00,  2.00, 13.16,  2, 27)
        CGPathAddCurveToPoint(path, nil,  2.00, 40.84, 13.16, 52.00, 27, 52)
        CGPathAddCurveToPoint(path, nil, 40.84, 52.00, 52.00, 40.84, 52, 27)
        CGPathAddCurveToPoint(path, nil, 52.00, 13.16, 42.39,  2.00, 27,  2)
        CGPathAddCurveToPoint(path, nil, 13.16,  2.00,  2.00, 13.16,  2, 27)

        return path
    }()

    let menuStrokeStart: CGFloat = 0.325
    let menuStrokeEnd: CGFloat = 0.9

    let hamburgerStrokeStart: CGFloat = 0.028
    let hamburgerStrokeEnd: CGFloat = 0.111
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.top.path = shortStroke
        self.middle.path = outline
        self.bottom.path = shortStroke

        for layer in [ self.top, self.middle, self.bottom ] {
            layer.fillColor = nil
            layer.strokeColor = UIColor.whiteColor().CGColor
            layer.lineWidth = 4
            layer.miterLimit = 4
            layer.lineCap = kCALineCapRound
            layer.masksToBounds = true

            let strokingPath = CGPathCreateCopyByStrokingPath(layer.path, nil, 4, .Round, .Miter, 4)

            layer.bounds = CGPathGetPathBoundingBox(strokingPath)

            layer.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]

            self.layer.addSublayer(layer)
        }

        self.top.anchorPoint = CGPointMake(28.0 / 30.0, 0.5)
        self.top.position = CGPointMake(40, 18)

        self.middle.position = CGPointMake(27, 27)
       self.middle.strokeStart = hamburgerStrokeStart
        self.middle.strokeEnd = hamburgerStrokeEnd

        self.bottom.anchorPoint = CGPointMake(28.0 / 30.0, 0.5)
        self.bottom.position = CGPointMake(40, 36)
    }

    var showsMenu: Bool = false {
        didSet {
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

            let bottomTransform = topTransform.copy() as! CABasicAnimation

            if self.showsMenu {
                let translation = CATransform3DMakeTranslation(-4, 0, 0)

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
        let copy = animation.copy() as! CABasicAnimation

        if copy.fromValue == nil {
            copy.fromValue = self.presentationLayer()!.valueForKeyPath(copy.keyPath!)
        }

        self.addAnimation(copy, forKey: copy.keyPath)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
    }
}
