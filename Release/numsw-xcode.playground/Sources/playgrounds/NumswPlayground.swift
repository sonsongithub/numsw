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
        viewController = RenderTableViewController()
    }
    
    public let viewController: RenderTableViewController
    
    public func append(renderer: ChartRenderer) {
        renderers.append(renderer)
    }
    
    public func plot(_ x: [Double], _ y: [Double]) {
        guard let b = chartBuilder else {
            hold {
                plot(x, y)
            }
            return
        }
        
        let points = zip(x, y).map {
            CGPoint(x: $0.0, y: $0.1)
        }
        b.addLine(line: LineGraph(points: points))
    }
    
    public func scatter(_ x: [Double], _ y: [Double]) {
        guard let b = chartBuilder else {
            hold {
                scatter(x, y)
            }
            return
        }
        let points = zip(x, y).map {
            CGPoint(x: $0.0, y: $0.1)
        }
        b.addScatter(scatter: ScatterGraph(points: points))
    }
    
    public func hold(_ f: () throws -> Void) rethrows {
        let b = ChartBuilder()
        chartBuilder = b

        try f()
        
        chartBuilder = nil
        
        let renderer = ChartRenderer(chart: b.chart)
        append(renderer: renderer)
    }
    
    public static var shared: NumswPlayground {
        get {
            if _shared == nil {
                _shared = NumswPlayground()
            }
            return _shared!
        }
    }
    
    private var renderers: [ChartRenderer] = [] {
        didSet {
            viewController.renderers = renderers.map { $0 as Renderer }
        }
    }
    
    private var chartBuilder: ChartBuilder?
    
    private static var _shared: NumswPlayground?
    
}

public func addLine(
    x: [Double], y: [Double]) {
    hold {
        plot(x, y)
    }
}

public func addLine2(
    x: [Double], y: [Double],
    x2: [Double], y2: [Double]) {
    hold {
        plot(x, y)
        scatter(x2, y2)
    }
}

public func plot(
    _ x: [Double], _ y: [Double]) {
    NumswPlayground.shared.plot(x, y)
}

public func scatter(
    _ x: [Double], _ y: [Double]) {
    NumswPlayground.shared.scatter(x, y)
}

public func hold(f: () throws -> Void) rethrows {
    try NumswPlayground.shared.hold(f)
}
