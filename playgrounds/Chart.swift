//
//  Chart.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

public struct Chart {
    public init() {
        computeViewport()
    }
    
    public var viewport: CGRect = .zero    
    public var elements: [ChartElement] = []
    
    public mutating func computeViewport() {
        guard elements.count != 0 else {
            viewport = RendererUtil.adjustViewport(viewport: CGRect.zero)
            return
        }
        
        var b = elements.first!.computeBounds()
        for e in elements.dropFirst() {
            b = b.union(e.computeBounds())
        }
        viewport = RendererUtil.adjustViewport(viewport: b)
    }
}
