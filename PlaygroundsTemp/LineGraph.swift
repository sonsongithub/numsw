//
//  LineData.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

public struct LineGraph {
    public init(points: [CGPoint]) {
        self.points = points
    }
    
    public var points: [CGPoint]
    
    public func computeViewport() -> CGRect {
        return RendererUtil.computeViewport(points: points)
    }
}
