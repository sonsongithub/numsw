//
//  ChartBuilder.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/06.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation

public class ChartBuilder {
    public init() {
        chart = Chart()
    }
    
    public func addLine(line: LineGraph) {
        chart.elements.append(.line(line))
        chart.computeViewport()
    }

    public func addScatter(scatter: ScatterGraph) {
        chart.elements.append(.scatter(scatter))
        chart.computeViewport()
    }
    
    public var chart: Chart
}
