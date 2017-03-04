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
    
    
    init(lines: [LineData]) {
        self.lines = lines
    }
    
    var lines: [LineData]
    
    func computeViewport() -> CGRect {
        var bounds = CGRect(x: 0, y: 0, width: 0, height: 0)

        if lines.count > 0 {
            //  override
            bounds = lines[0].computeBounds()
            
            //  reduce
            for line in lines.dropFirst() {
                bounds = bounds.union(line.computeBounds())
            }
        }
        
        //  min size constraint
        
        var width = max(bounds.width, 2)
        var height = max(bounds.height, 2)
        
        //  10% margin
        
        width += width * 0.1
        height += height * 0.1
        
        return CGRect(x: bounds.midX - width / 2.0,
                      y: bounds.midY - height / 2.0,
                      width: width,
                      height: height)
    }
    
    func computeStepSize() -> CGSize {
        let size = viewport.size
        
        let xLog = log10(size.width)
        let xStep = pow(10.0, round(xLog) - 1)
        
        let yLog = log10(size.height)
        let yStep = pow(10.0, round(yLog) - 1)
                
        return CGSize(width: xStep, height: yStep)
    }
    
    func render(size: CGSize) -> UIImage {
        viewport = computeViewport()
        viewportTransform = computeViewportTransform(from: viewport,
                                                     to: CGRect(origin: CGPoint.zero,
                                                                size: size),
                                                     flipY: true)
        
        stepSize = computeStepSize()
        
        print("stpe=\(computeStepSize())")
        
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
        
        //  ticks
        
        let tickXs = computeTickValues(min: p0.x, max: p1.x,
                                       step: stepSize.width)
        let tickHeight = viewport.height * 0.1

        for x in tickXs {
            drawLine(context: ctx, points: [
                CGPoint(x: x, y: (tickHeight / 2.0)),
                CGPoint(x: x, y: -(tickHeight / 2.0)),
                ])
        }
    }
    
    func drawAxisY(context ctx: CGContext) {
        let p0 = CGPoint(x: 0, y: viewport.minY)
        let p1 = CGPoint(x: 0, y: viewport.maxY)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        drawLine(context: ctx, points: [p0, p1])
        
        //  ticks
        
        let tickYs = computeTickValues(min: p0.y, max: p1.y,
                                       step: stepSize.height)
        let tickWidth = viewport.width * 0.1
        
        for y in tickYs {
            drawLine(context: ctx, points: [
                CGPoint(x: -(tickWidth / 2.0), y: y),
                CGPoint(x: (tickWidth / 2.0), y: y),
                ])
        }
    }
    
    func drawPoints(context ctx: CGContext) {
        ctx.setStrokeColor(UIColor.white.cgColor)
        
        for line in lines {
            drawLine(context: ctx, points: line.points)
        }
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
        
        if points.count < 2 {
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
    private var stepSize: CGSize!
}
