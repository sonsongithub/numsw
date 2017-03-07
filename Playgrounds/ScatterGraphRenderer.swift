//
//  ScatterGraphRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreGraphics

public class ScatterGraphRenderer : Renderer {
    public init(viewport: CGRect, scatter: ScatterGraph) {
        self.viewport = viewport
        self.scatter = scatter
    }
    
    public let viewport: CGRect
    public let scatter: ScatterGraph
    
    public func render(context: CGContext, windowSize: CGSize) {
        viewportTransform = RendererUtil.computeViewportTransform(viewport: viewport, windowSize: windowSize)
        drawScatter(context: context, scatter: scatter)
    }

    public func drawScatter(context ctx: CGContext, scatter: ScatterGraph) {
        ctx.setStrokeColor(UIColor.green.cgColor)
        
        let t = viewportTransform!
        
        for point in scatter.points {
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
    
    private var viewportTransform: CGAffineTransform?
}
