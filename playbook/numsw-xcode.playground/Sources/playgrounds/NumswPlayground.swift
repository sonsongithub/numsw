//
//  NumswPlayground.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/05.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

public class NumswPlayground {
    internal init() {
        viewController = RenderViewController2()
    }
    
    public let viewController: RenderViewController2
    
    public func add(renderer: Renderer) {
        viewController.renderers.append(renderer)
    }
    
    public func addLine(
        x: [Double], y: [Double])
    {
        let cgPoints = zip(x, y).map {
            CGPoint(x: $0.0, y:$0.1)
        }
        
        let renderer = LineGraphRenderer(lines: [
            LineData(points: cgPoints)
            ])
        
        add(renderer: renderer)
    }
    
    public func addLine2(
            x: [Double], y: [Double],
            x2: [Double], y2: [Double])
    {
        let cgPoints = zip(x, y).map {
            CGPoint(x: $0.0, y: $0.1)
        }
        
        let cgPoints2 = zip(x2, y2).map {
            CGPoint(x: $0.0, y: $0.1)
        }
        
        let renderer = LineGraphRenderer(lines: [
            LineData(points: cgPoints),
            LineData(points: cgPoints2)
            ])
        
        add(renderer: renderer)
    }
    
    public static var shared: NumswPlayground {
        get {
            if _shared == nil {
                _shared = NumswPlayground()
            }
            return _shared!
        }
    }
    
    private static var _shared: NumswPlayground?
}

public func addLine(
    x: [Double], y: [Double])
{
    NumswPlayground.shared.addLine(x: x, y: y)
}

public func addLine2(
    x: [Double], y: [Double],
    x2: [Double], y2: [Double])
{
    NumswPlayground.shared.addLine2(x: x, y: y,
                                    x2: x2, y2: y2)
}

