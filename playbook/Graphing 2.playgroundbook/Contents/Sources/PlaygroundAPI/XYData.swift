//
//  DataPoints.swift
//  Charts
//

import Foundation

private let DefaultStartingX = 0.0

/// A set of (x,y) data that can be plotted.
public class XYData {
    
    internal var xyData = [(Double, Double)]()
    
    internal var dataDidChangeHandler: (() -> Void)?
    
    private var xStrideForAppend = 1.0
    
    public convenience init(xyData: (Double, Double)...) {
        self.init(xyData: xyData)
    }
    
    /// Creates an XYData with the given (x,y) data:
    ///   - `xyData` The (x,y) data.
    public init(xyData: [(Double, Double)]) {
        self.xyData = xyData
    }
 
    /// Creates an XYData with the given y data, starting at the given x value, with the given x stride.
    ///   - `yData`. The color to use for symbols and lines.
    ///   - `startingX`. The x value to start the data at. The default value is 0.0.
    ///   - `xStride`. The difference between one x value and the next. The default value is 1.0.
    public init(yData: [Double], startingX: Double = 0.0, xStride: Double = 1.0) {
        
        var currentX = startingX
        for y in yData {
            xyData.append((currentX, y))
            currentX += xStride
        }
        
        self.xStrideForAppend = xStride
    }
    
    /// Appends the given (x,y) point to the XYData.
    public func append(x: Double, y: Double) {
        xyData.append((x,y))
    }
    
    /// Appends the given y point to the XYData. The x value is inferred based on the existing data.
    public func append(y: Double) {
        let x = xyData.count == 0 ? DefaultStartingX : xyData.last!.0 + xStrideForAppend
        append(x: x, y: y)
        dataDidChangeHandler?()
    }
    
    internal var xData: [Double] {
        return xyData.map { $0.0 }
    }
    
    internal var yData: [Double] {
        return xyData.map { $0.1 }
    }
    
    internal func sort() {
        xyData = xyData.sorted{ $0.0 < $1.0 }
    }
    
    internal var count: Int {
        return xyData.count
    }
    
}
