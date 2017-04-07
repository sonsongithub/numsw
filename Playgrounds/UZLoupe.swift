//
//  UZLoupe.swift
//  UZTextView
//
//  Created by sonson on 2017/03/28.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

/**
 Search root view of the hierarchy in which the specified view is included recursively, if can not find it, return itself.
 - parameters view: A view over a UIWindow object.
 */
fileprivate func rootViewOfHierarchy(including view: UIView) -> UIView {
    guard let parent = view.superview else { return view }
    if parent.isKind(of: UIWindow.self) {
        return view
    }
    return rootViewOfHierarchy(including: parent)
}

/**
 Loupe to magnify the text while user is tapping/selecting any words in the UZTextView.
 */
internal class UZLoupe: UIView, CAAnimationDelegate {
    /// Radius of the loupe.
    private static let radius = CGFloat(60)
    /// The image contains the screen shot of the UZTextView object.
    private var image = UIImage()
    /// UZTextView to which the loupe is attached.
    internal var textView: UZTextView?
    
    internal init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UZLoupe.radius * 2, height: UZLoupe.radius * 2))
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isHidden = true
    }
    
    override var center: CGPoint {
        didSet { setNeedsDisplay() }
    }
    
    public override var tintColor: UIColor! {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        guard let textView = textView else { return }
        let textViewBackgroundColor = textView.backgroundColor ?? UIColor.white
        
        /// Loupe the circle background
        textViewBackgroundColor.setFill()
        context.addArc(center: CGPoint(x: UZLoupe.radius, y: UZLoupe.radius), radius: UZLoupe.radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        context.closePath()
        context.drawPath(using: .fill)
        
        /// Draw magnified content
        context.saveGState()
        context.addArc(center: CGPoint(x: UZLoupe.radius, y: UZLoupe.radius), radius: UZLoupe.radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        context.closePath()
        context.clip()
        image.draw(at: .zero)
        context.restoreGState()
        
        /// Draw the circle frame
        tintColor.withAlphaComponent(1).setStroke()
        context.saveGState()
        context.setLineWidth(2)
        context.addArc(center: CGPoint(x: UZLoupe.radius, y: UZLoupe.radius), radius: UZLoupe.radius - 1, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        context.closePath()
        context.drawPath(using: .stroke)
        context.restoreGState()
    }
    
    /// Show loupe itself with animation
    private func show() {
        guard super.isHidden == true else { return }
        super.isHidden = false
        
        let animationProperties: [(String, [Any], [NSNumber])] = [
            ("opacity", [0, 0.97, 1], [0, 0.7, 1]),
            ("transform.scale", [0, 1], [0, 1]),
            ("transform.translation.y", [(self.frame.size.height * CGFloat(0.5)) as NSNumber, 0], [0, 1]),
        ]
        
        let animations: [CAAnimation] = animationProperties.map({
            let animation = CAKeyframeAnimation(keyPath: $0.0)
            animation.values = $0.1
            animation.keyTimes = $0.2
            return animation
        })
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = 0.2
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.delegate = self
        
        group.setValue("show", forKey: "name")
        self.layer.add(group, forKey: "show")
    }
    
    /// Hide loupe itself with animation
    private func hide() {
        let animationProperties: [(String, [Any], [NSNumber])] = [
            ("opacity", [1, 0.97, 0], [0, 0.7, 1]),
            ("transform.scale", [1, 0], [0, 1]),
            ("transform.translation.y", [0, (self.frame.size.height * CGFloat(0.5)) as NSNumber], [0, 1]),
        ]
        
        let animations: [CAAnimation] = animationProperties.map({
            let animation = CAKeyframeAnimation(keyPath: $0.0)
            animation.values = $0.1
            animation.keyTimes = $0.2
            return animation
        })
        
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = 0.2
        group.isRemovedOnCompletion = false
        group.fillMode = kCAFillModeForwards
        group.delegate = self
        
        group.setValue("hide", forKey: "name")
        self.layer.add(group, forKey: "hide")
    }
    
    /// CAAnimationDelegate callback method
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String else { return }
        if name == "show" {
        } else if name == "hide" {
            super.isHidden = true
        }
    }
    
    /// Does not use `isHidden` property inside UZLoupe in order to switch hide/shown.
    /// Insted of it, use `super.isHidden`.
    override var isHidden: Bool {
        set {
            if !newValue {
                show()
            } else {
                hide()
            }
        }
        get {
            return super.isHidden
        }
    }
    
    /**
     Capture the image from the specified UZTextView around specified point.
     - parameter point: Center of the capturing area.
     - parameter textView: UZTextView you want to capture.
     - returns: UIImage object which contains UZTextView. The size of the image is twice of UZLoupe.radius x UZLoupe.radius.
     */
    private func capture(at point: CGPoint, from textView: UZTextView) -> UIImage {
        /// prepare capturing
        UIGraphicsBeginImageContextWithOptions(CGSize(width: UZLoupe.radius * 2, height: UZLoupe.radius * 2), false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        /// offset
        context.translateBy(x: -point.x + UZLoupe.radius, y: -point.y + UZLoupe.radius)
        
        /// rendering
        let prev = super.isHidden
        super.isHidden = true
        textView.layer.render(in: context)
        super.isHidden = prev
        
        /// capture to mamoery as UIImage
        image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /**
     Move the loupe to the specified point. 
     Intrinsicly, this method captures a screen shot from UZTextView and save it to `image` property.
     - paremeter point: CGPoint structure which contains location where you want to move the loupe.
     */
    internal func move(to point: CGPoint) {
        guard let textView = textView else { return }
        
        let targetView = rootViewOfHierarchy(including: textView)

        image = capture(at: point, from: textView)
        setNeedsDisplay()
        
        targetView.addSubview(self)
        let nextCenter = textView.convert(point, to: targetView)
        self.center = nextCenter.offsetBy(x: 0, y: -UZLoupe.radius - UZLoupe.radius * 0.2)
    }
    
}
