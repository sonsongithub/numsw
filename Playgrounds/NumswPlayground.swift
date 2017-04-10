//
//  NumswPlayground.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/05.
//  Copyright © 2017年 sonson. All rights reserved.
//

import CoreGraphics

#if SANDBOX_APP
    import numsw
#endif

public class NumswPlayground {
    internal init() {
        #if os(iOS)
            viewController = RenderTableViewController()
        #endif
    }
    
    #if os(iOS)
        public let viewController: RenderTableViewController
    #endif
    
    public func append(renderer: ChartRenderer) {
        renderers.append(renderer)
    }
    
#if os(iOS)
    public func print(_ matrix: Matrix<Double>) {
        let matrixTextRenderer = MatrixTextRenderer(matrix)
        renderers.append(matrixTextRenderer)
    }
    
    public func print(_ string: String) {
        let textRenderer = TextRenderer(string)
        renderers.append(textRenderer)
    }
#endif
    
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
        if _shared == nil {
            _shared = NumswPlayground()
        }
        return _shared!
    }
    
    private var renderers: [Renderer] = [] {
        didSet {
            #if os(iOS)
            viewController.renderers = renderers.map { $0 as Renderer }
            #endif
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

public func nwprint(_ matrix: Matrix<Double>) {
#if os(iOS)
    NumswPlayground.shared.print(matrix)
#endif
}

public func nwprint(_ string: String) {
#if os(iOS)
    NumswPlayground.shared.print(string)
#endif
}
