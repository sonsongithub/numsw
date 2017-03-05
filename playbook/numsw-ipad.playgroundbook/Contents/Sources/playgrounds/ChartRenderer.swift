//
//  ChartRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

public class ChartRenderer : Renderer {
    
    public init(chart: Chart) {
        self.chart = chart
        
        update()
    }
    
    public let chart: Chart
    
    public func render(context: CGContext, windowSize: CGSize) {
        compositer?.render(context: context, windowSize: windowSize)
    }
    
    private func update() {
        var renderers: [Renderer] = []
        
        renderers.append(AxisRenderer(chart: chart))
        
        for element in chart.elements {
            switch element {
            case .line(let line):
                renderers.append(LineGraphRenderer(viewport: chart.viewport, line: line))
            }
        }
        
        let r = CompositeRenderer()
        self.compositer = r
        r.renderers = renderers
    }
    
    private var compositer: CompositeRenderer?
}
