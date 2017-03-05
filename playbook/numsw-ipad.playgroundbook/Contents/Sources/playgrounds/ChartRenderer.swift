//
//  ChartRenderer.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

public class ChartRenderer : Renderer {
    
    public init() {
        compositer = CompositeRenderer()
    }
    
    public var chart: Chart? {
        didSet {
            update()
        }
    }
    
    public func render(context: CGContext, windowSize: CGSize) {
        compositer.render(context: context, windowSize: windowSize)
    }
    
    private func update() {
        compositer.renderers = []
        
        guard let chart = chart else {
            return
        }
        
        let axis = AxisRenderer(chart: chart)
        self.axis = axis
        
        compositer.renderers = [axis]
    }
    
    private var compositer: CompositeRenderer
    
    private var axis: AxisRenderer?
}
