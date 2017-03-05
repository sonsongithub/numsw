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
        viewport = CGRect.zero
    }
    
    public var viewport: CGRect
    
    public var elements: [ChartElement] = []
    
    public mutating func computeViewport() {
        guard elements.count != 0 else {
            viewport = RendererUtil.computeViewport(points: [])
            return
        }
        
        viewport = elements.first!.computeViewport()
        for e in elements.dropFirst() {
            viewport = viewport.union(e.computeViewport())
        }
    }
}
