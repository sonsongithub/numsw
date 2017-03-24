//
//  LineGraphRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreGraphics

public class LineGraphRenderer: Renderer {
    public init(viewport: CGRect, line: LineGraph) {
        self.viewport = viewport
        self.line = line
    }
    
    public let viewport: CGRect
    public let line: LineGraph
    
    public func render(context: CGContext, windowSize: CGSize) {
        viewportTransform = RendererUtil.computeViewportTransform(viewport: viewport, windowSize: windowSize)
        drawLine(context: context, points: line.points)
    }
    
//    public func drawPoints(context ctx: CGContext) {
//        ctx.setStrokeColor(UIColor.white.cgColor)
//        
//        if lines.count >= 1 {
//            drawLine(context: ctx, points: lines[0].points)
//        }
//        if lines.count >= 2 {
//            drawSanpuzu(context: ctx, line: lines[1])
//        }
//    }
    
    public func drawSanpuzu(context ctx: CGContext, line: LineGraph) {
        ctx.setStrokeColor(UIColor.green.cgColor)
        
        let t = viewportTransform!
        
        for point in line.points {
            let p = point.applying(t)
            
            RendererUtil.drawLine(context: ctx, points: [
                CGPoint(x: p.x - 10, y: p.y - 10),
                CGPoint(x: p.x + 10, y: p.y + 10)
                ])
            RendererUtil.drawLine(context: ctx, points: [
                CGPoint(x: p.x - 10, y: p.y + 10),
                CGPoint(x: p.x + 10, y: p.y - 10)
                ])
        }
    }
    
    public func drawDebugX(context ctx: CGContext, point0: CGPoint, point1: CGPoint) {
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
    
    public func drawLine(context: CGContext,
                         points: [CGPoint]) {
        context.setStrokeColor(UIColor.white.cgColor)
        
        let t = viewportTransform!
        
        let points = points.map { $0.applying(t) }
        
        RendererUtil.drawLine(context: context, points: points)
    }
    
    private var viewportTransform: CGAffineTransform?
}
