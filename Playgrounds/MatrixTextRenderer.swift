//
//  MatrixTextRenderer.swift
//  sandbox
//
//  Created by sonson on 2017/03/14.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation
import CoreGraphics

#if SANDBOX_APP
    import numsw
#endif

public class MatrixTextRenderer: Renderer {
    
    public init() {
        
        update()
    }
    
    public var parentViewSize = CGSize.zero
    public var height: CGFloat {
        return parentViewSize.height * 2.5
    }
    
    public func render(context: CGContext, windowSize: CGSize) {
        compositer?.render(context: context, windowSize: windowSize)
    }
    
    private func update() {
//        var renderers: [Renderer] = []
//        
//        renderers.append(AxisRenderer(chart: chart))
//        
//        for element in chart.elements {
//            switch element {
//            case .line(let line):
//                renderers.append(LineGraphRenderer(viewport: chart.viewport, line: line))
//            case .scatter(let scatter):
//                renderers.append(ScatterGraphRenderer(viewport: chart.viewport, scatter: scatter))
//            }
//        }
//        
//        let r = CompositeRenderer()
//        self.compositer = r
//        r.renderers = renderers
    }
    
    private var compositer: CompositeRenderer?
}
