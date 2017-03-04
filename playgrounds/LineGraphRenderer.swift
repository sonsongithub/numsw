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
        viewportTransform = computeViewportTransform(from: viewport,
                                                     to: CGRect(origin: CGPoint.zero,
                                                                size: size),
                                                     flipY: true)
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        
        let ctx = UIGraphicsGetCurrentContext()!
        
        drawDebugX(context: ctx,
                   point0: CGPoint(x: viewport.minX, y: viewport.minY),
                   point1: CGPoint(x: viewport.maxX, y: viewport.maxY))
        
        drawAxisX(context: ctx)
        drawAxisY(context: ctx)
        drawPoints(context: ctx)
        
        let cgImage = ctx.makeImage()!
        return UIImage(cgImage: cgImage)
    }
    
    func drawAxisX(context ctx: CGContext) {
        let p0 = CGPoint(x: viewport.minX, y: 0)
        let p1 = CGPoint(x: viewport.maxX, y: 0)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        drawLine(context: ctx, points: [p0, p1])
    }
    
    func drawAxisY(context ctx: CGContext) {
        let p0 = CGPoint(x: 0, y: viewport.minY)
        let p1 = CGPoint(x: 0, y: viewport.maxY)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        drawLine(context: ctx, points: [p0, p1])
    }
    
    func drawPoints(context ctx: CGContext) {
        ctx.setStrokeColor(UIColor.white.cgColor)
        drawLine(context: ctx, points: self.points)
    }
    
    func drawDebugX(context ctx: CGContext,
                    point0: CGPoint,
                    point1: CGPoint)
    {
        ctx.setStrokeColor(UIColor.red.cgColor)
        drawLine(context: ctx, points: [
            CGPoint(x: point0.x, y: point0.y),
            CGPoint(x: point1.x, y: point1.y)
            ])
        
        ctx.setStrokeColor(UIColor.green.cgColor)
        drawLine(context: ctx, points: [
            CGPoint(x: point1.x, y: point0.y),
            CGPoint(x: point0.x, y: point1.y)
            ])
    }
    
    func drawLine(context ctx: CGContext,
                  points: [CGPoint])
    {
        let t = viewportTransform!
        
        let points = points.map { $0.applying(t) }
        
        ctx.setLineWidth(2.0)
        
        if self.points.count < 2 {
            return
        }
        
        ctx.move(to: points[0])
        for i in 1..<points.count {
            ctx.addLine(to: points[i])
        }
        
        ctx.strokePath()
    }
    
    private var viewport: CGRect!
    private var viewportTransform: CGAffineTransform!
}
