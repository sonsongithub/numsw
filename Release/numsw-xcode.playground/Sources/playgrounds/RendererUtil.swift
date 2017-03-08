//
//  RendererUtil.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

//  Ideally, I can just define top level function.
//  But in playgroundbook, we can not use packagename so need `struct` namespacing.

public struct RendererUtil {

    public static func toRadian(_ x: CGFloat) -> CGFloat {
        return x * CGFloat.pi / CGFloat(180.0)
    }

    public static func toDegree(_ x: CGFloat) -> CGFloat {
        return x * CGFloat(180.0) / CGFloat.pi
    }
    
    public static func computeBounds(points: [CGPoint]) -> CGRect {
        let xs = points.map { $0.x }
        let ys = points.map { $0.y }
        
        let x0 = xs.min()!
        let x1 = xs.max()!
        let y0 = ys.min()!
        let y1 = ys.max()!
        
        return CGRect(x: x0, y: y0, width: x1 - x0, height: y1 - y0)
    }
    
    public static func adjustViewport(viewport: CGRect) -> CGRect {
        //  min size constraint
        
        var width = max(viewport.width, 2)
        var height = max(viewport.height, 2)
        
        //  10% margin
        
        width += width * 0.1
        height += height * 0.1
        
        return CGRect(x: viewport.midX - width / 2.0,
                      y: viewport.midY - height / 2.0,
                      width: width,
                      height: height)
    }
    
    public static func computeViewportTransform(
        from: CGRect,
        to: CGRect,
        flipY: Bool) -> CGAffineTransform {
        let fw = from.width
        let fh = from.height
        let tw = to.width
        let th = to.height
        
        var trans = CGAffineTransform.identity

        trans = trans.translatedBy(x: to.origin.x, y: to.origin.y)
        trans = trans.translatedBy(x: (tw / 2.0), y: (th / 2.0))
        
        let sx = tw / fw
        var sy = th / fh
        if flipY {
            sy *= -1
        }
        
        trans = trans.scaledBy(x: sx, y: sy)
        trans = trans.translatedBy(x: -(fw / 2.0), y: -(fh / 2.0))
        trans = trans.translatedBy(x: -from.origin.x, y: -from.origin.y)
        return trans
    }
    
    public static func computeViewportTransform(
        viewport: CGRect, windowSize: CGSize) -> CGAffineTransform {
        return computeViewportTransform(from: viewport,
                                        to: CGRect(origin: CGPoint.zero,
                                                   size: windowSize),
                                        flipY: true)
    }

    public static func computeTickValues(
        min: CGFloat,
        max: CGFloat,
        step: CGFloat) -> [CGFloat] {
        let x0 = Int(floor(min / step))
        let x1 = Int(ceil(max / step))
        
        var ret: [CGFloat] = []
        for xi in x0...x1 {
            let x = CGFloat(xi) * step
            ret.append(x)
        }
        
        return ret
    }

    public static func drawLine(context: CGContext,
                         points: [CGPoint]) {
        context.setLineWidth(2.0)
        
        if points.count < 2 {
            return
        }
        
        context.move(to: points[0])
        for i in 1..<points.count {
            context.addLine(to: points[i])
        }
        
        context.strokePath()
    }

}
