//
//  ScatterPlot.swift
//  Charts
//

import UIKit

/// Creates a scatter plot on the chart.
///
/// Properties that can affect the scatter plot:
///
///   - `color`. The color to use for symbols.
///   - `symbol`. The symbol to use for points. The default value is .circle.
public class ScatterPlot: AbstractPointPlot {
    
    /// Creates a scatter plot with the given (x,y) data.
    public convenience init(xyData: (Double, Double)...) {
        let xyData = XYData(xyData: xyData)
        self.init(xyData: xyData)
    }
    
    /// Creates a scatter plot with the given (x,y) data.
    public init(xyData: XYData) {
        let dataProvider = DiscreteLineData(xyData: xyData)
        super.init(dataProvider: dataProvider, style: .none)
        
        // when the point data changes, redraw the graph layer.
        xyData.dataDidChangeHandler = {
            Chart.shared.backingView.setNeedsDisplay()
        }
    }
    
}
