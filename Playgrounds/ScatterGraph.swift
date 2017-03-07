//
//  ScatterGraph.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

public struct ScatterGraph {
    public init(points: [CGPoint]) {
        self.points = points
    }
    
    public var points: [CGPoint]
    
    public func computeBounds() -> CGRect {
        return RendererUtil.computeBounds(points: points)
    }
}
