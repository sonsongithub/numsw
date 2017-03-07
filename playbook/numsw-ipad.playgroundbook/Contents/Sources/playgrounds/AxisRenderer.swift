//
//  ChartRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

//  xAxis, yAxis, ticks

import UIKit

public class AxisRenderer : Renderer {
    public init(chart: Chart) {
        self.chart = chart
    }

    public let chart: Chart

    public func render(context: CGContext, windowSize: CGSize) {
        viewportTransform = RendererUtil.computeViewportTransform(viewport: chart.viewport, windowSize: windowSize)
        stepSize = computeStepSize()
        
        drawAxisX(context: context)
        drawAxisY(context: context)
    }
    
    private func computeStepSize() -> CGSize {
        let size = chart.viewport.size
        
        let xLog = log10(size.width)
        let xStep = pow(10.0, round(xLog) - 1)
        
        let yLog = log10(size.height)
        let yStep = pow(10.0, round(yLog) - 1)
        
        return CGSize(width: xStep, height: yStep)
    }
    
    private func drawAxisX(context ctx: CGContext) {
        let p0 = CGPoint(x: chart.viewport.minX, y: 0)
        let p1 = CGPoint(x: chart.viewport.maxX, y: 0)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        drawLine(context: ctx, points: [p0, p1])
        
        //  ticks
        
        let tickXs = RendererUtil.computeTickValues(min: p0.x, max: p1.x,
                                                    step: stepSize!.width)
        let tickHeight = chart.viewport.height * 0.04
        
        for x in tickXs {
            drawLine(context: ctx, points: [
                CGPoint(x: x, y: (tickHeight / 2.0)),
                CGPoint(x: x, y: -(tickHeight / 2.0)),
                ])
        }
    }
    
    private func drawAxisY(context ctx: CGContext) {
        let p0 = CGPoint(x: 0, y: chart.viewport.minY)
        let p1 = CGPoint(x: 0, y: chart.viewport.maxY)
        
        ctx.setStrokeColor(UIColor.gray.cgColor)
        drawLine(context: ctx, points: [p0, p1])
        
        //  ticks
        
        let tickYs = RendererUtil.computeTickValues(min: p0.y, max: p1.y,
                                                    step: stepSize!.height)
        let tickWidth = chart.viewport.width * 0.04
        
        for y in tickYs {
            drawLine(context: ctx, points: [
                CGPoint(x: -(tickWidth / 2.0), y: y),
                CGPoint(x: (tickWidth / 2.0), y: y),
                ])
        }
    }

    
    private func drawLine(context: CGContext,
                         points: [CGPoint])
    {
        let t = viewportTransform!
        
        let points = points.map { $0.applying(t) }
        
        RendererUtil.drawLine(context: context, points: points)
    }
    
    private var viewportTransform: CGAffineTransform?
    private var stepSize: CGSize?
}
