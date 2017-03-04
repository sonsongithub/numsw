//
//  LinePlot.swift
//  Charts
//

import UIKit

/// Draws a line plot on the chart.
///
/// Properties that can affect the line plot:
///
///   - `color`. The color to use for symbols and lines.
///   - `lineWidth`. The width of the line. The default value is 4.0.
///   - `symbol`. The symbol to use for points along the line. The default value is .circle.
///   - `style`. The style to use to draw the line (for example, solid, dashed, and so on). The default value is .solid.
public class LinePlot: AbstractPointPlot {
    
    /// Creates a line plot with the given (x,y) data. The data is sorted in ascending x order.
    public convenience init(xyData: (Double, Double)...) {
        let xyData = XYData(xyData: xyData)
        self.init(xyData: xyData)
    }
    
    /// Creates a line plot with the given y data, starting at x=0 with an x-stride of 1.0. The data is sorted in ascending x order.
    ///   - `yData`. The y data.
    public convenience init(yData: Double...) {
        let xyData = XYData(yData: yData)
        self.init(xyData: xyData)
    }
    
    /// Creates a line plot with the given (x,y) data. The data is sorted in ascending x order.
    ///   - `xyData`. The (x,y) data.
    public init(xyData: XYData) {
        
        xyData.sort()
        
        let dataProvider = DiscreteLineData(xyData: xyData)
        super.init(dataProvider: dataProvider, style: .solid)
        
        // when the point data changes, redraw the graph layer.
        xyData.dataDidChangeHandler = { 
            Chart.shared.backingView.setNeedsDisplay()
        }
    }
    
    /// Creates a line plot with the given function. The function is called with an x value and must return the corresponding y value.
    ///   - `function`. The function used to calculate y values.
    public init(function: @escaping (Double) -> Double) {
        let dataProvider = FunctionLineData(function: function)
        super.init(dataProvider: dataProvider, symbol: nil, style: .solid)
    }
    
}
