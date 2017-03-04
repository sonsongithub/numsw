//
//  LineData.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

public struct LineData {
    public init(points: [CGPoint]) {
        self.points = points
    }
    
    public var points: [CGPoint]
    
    public func computeBounds() -> CGRect {
        let xs = points.map { $0.x }
        let ys = points.map { $0.y }
        
        let x0 = xs.min()!
        let x1 = xs.max()!
        let y0 = ys.min()!
        let y1 = ys.max()!
        
        return CGRect(x: x0, y: y0, width: x1 - x0, height: y1 - y0)
    }
}
