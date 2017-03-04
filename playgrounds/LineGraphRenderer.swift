//
//  LineGraphRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreGraphics


class LineGraphRenderer : Renderer {
    
    
    init(points: [CGPoint]) {
        self.points = points
    }
    
    var points: [CGPoint]
    
    func computeViewport() -> CGRect {
        let xs = points.map { $0.x }
        var x0 = xs.min()!
        var x1 = xs.max()!
        let ys = points.map { $0.y }
        var y0 = ys.min()!
        var y1 = ys.max()!
        
        var cx = (x0 + x1) / 2.0
        var cy = (y0 + y1) / 2.0
        
        //  min size constraint
        var width = max(x1 - x0, 2)
        var height = max(y1 - y0, 2)
        
        x0 = cx - width / 2.0
        y0 = cy - height / 2.0
        
        x0 -= 1.0
        y0 -= 1.0
        x1 += 1.0
        y1 += 1.0
        
        width = x1 - x0
        height = y1 - y0
        
        return CGRect(origin: CGPoint(x: x0, y: y0),
                      size: CGSize(width: width, height: height))
    }
    
    
    func render(size: CGSize) -> UIImage {
        
        viewport = computeViewport()
//        print("viewport=\(viewport)")
        viewportTransform = computeViewportTransform(from: viewport,
                                                     to: CGRect(origin: CGPoint.zero,
                                                                size: size),
                                                     flipY: true)
//        print(CGPoint(x: 2, y: 3).applying(viewportTransform))
//        print(CGPoint(x: -1, y: -1).applying(viewportTransform))
//        print(CGPoint(x: 5, y: 7).applying(viewportTransform))
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        drawAxisX(context: ctx)
        drawAxisY(context: ctx)
        
        drawPoints(context: ctx)

//        drawDebugX(context: ctx,
//                   point0: CGPoint(x: -1, y: -1),
//                   point1: CGPoint(x: 5, y: 7))

        
        let cgImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }
    
    func drawAxisX(context ctx: CGContext) {
        let t = viewportTransform!
        let p0 = CGPoint(x: viewport.minX, y: 0).applying(t)
        let p1 = CGPoint(x: viewport.maxX, y: 0).applying(t)
        
        ctx.setLineWidth(2.0)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        ctx.move(to: p0)
        ctx.addLine(to: p1)
        ctx.closePath()
        ctx.strokePath()
    }
    
    func drawAxisY(context ctx: CGContext) {
        let t = viewportTransform!
        let p0 = CGPoint(x: 0, y: viewport.minY).applying(t)
        let p1 = CGPoint(x: 0, y: viewport.maxY).applying(t)
        
        ctx.setLineWidth(2.0)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        ctx.move(to: p0)
        ctx.addLine(to: p1)
        ctx.closePath()
        ctx.strokePath()
    }
    
    func drawPoints(context ctx: CGContext) {
        let t = viewportTransform!
        
        ctx.setLineWidth(2.0)
        
        ctx.setStrokeColor(UIColor.white.cgColor)
        
        if self.points.count < 2 {
            return
        }
        
        
        ctx.move(to: self.points[0].applying(t))
        
        for i in 1..<self.points.count {
            ctx.addLine(to: self.points[i].applying(t))
        }
        
//        ctx.closePath()
        
        ctx.strokePath()
        
    }
    
    
    func drawDebugX(context ctx: CGContext,
                    point0: CGPoint,
                    point1: CGPoint)
    {
        let t = viewportTransform!
        let point0 = point0.applying(t)
        let point1 = point1.applying(t)
        
        ctx.setLineWidth(2.0)
        
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.move(to: CGPoint(x: point0.x, y: point0.y))
        ctx.addLine(to: CGPoint(x: point1.x, y: point1.y))
        ctx.closePath()
        ctx.strokePath()
        
        ctx.setStrokeColor(UIColor.green.cgColor)
        ctx.move(to: CGPoint(x: point1.x, y: point0.y))
        ctx.addLine(to: CGPoint(x: point0.x, y: point1.y))
        ctx.closePath()
        ctx.strokePath()
    }
    
    private var viewport: CGRect!
    private var viewportTransform: CGAffineTransform!
}
