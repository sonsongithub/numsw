//
//  LineChartLayer.swift
//  Charts
//
import UIKit

private let FunctionSampleInternalInPoints = 1.0

internal class LinePlotDrawable: ChartDrawable {
    
    var dataProvider: LineData?
    
    var symbol: Symbol? = Symbol()
    var lineStyle = LineStyle.none
    var lineWidth: CGFloat = 2.0
    
    private func drawSymbolsAtPoints(points: [(Double, Double)], inChartView chartView: ChartView, inContext context: CGContext) {
        guard let symbol = symbol else { return }
        for point in points {
            let screenPoint = chartView.convertPointToScreen(modelPoint: CGPoint(x: point.0, y: point.1))
            symbol.draw(atCenterPoint: CGPoint(x: screenPoint.x, y: screenPoint.y), fillColor: color.uiColor, usingContext: context)
        }
    }
    
    // MARK: - ChartDrawable conformance -
    
    var color = Color.blue
    var label: String?
    
    func draw(withChartView chartView: ChartView, context: CGContext) {

        guard let dataProvider = dataProvider else { return }
        
        let modelPoints = dataProvider.data(forBounds: chartView.axisBounds, chartView: chartView)
        let screenPoints = modelPoints.map { modelPoint -> CGPoint in
            return chartView.convertPointToScreen(modelPoint: CGPoint(x: modelPoint.0, y: modelPoint.1))
        }
        
        if lineStyle != .none {
            for (index, point) in screenPoints.enumerated() {
                if (index == 0) {
                    context.move(to: point)
                } else {
                    context.addLine(to: point)
                }
            }
            
            switch lineStyle {
            case .dashed:
                context.setLineDash(phase: 0, lengths: [6, 10])
            case .dotted:
                context.setLineDash(phase: 0, lengths: [1, 6])
            default:
                break
            }
            
            context.setStrokeColor(color.cgColor)
            context.setLineJoin(.round)
            context.setLineWidth(lineWidth)
            context.strokePath()
        }
        
        drawSymbolsAtPoints(points: modelPoints, inChartView: chartView, inContext: context)
    }
    
    func boundsOfData(inChartView chartView: ChartView) -> Bounds {
        guard let dataProvider = dataProvider else { return Bounds.infinite }
        return dataProvider.boundsOfData(chartView: chartView)
    }
    
    func values(inScreenRect rect: CGRect, inChartView chartView: ChartView) -> [ChartValue]  {
        guard let dataProvider = dataProvider else { return [] }
        
        let minPoint = chartView.convertPointFromScreen(screenPoint: CGPoint(x: rect.minX, y: rect.maxY))
        let maxPoint = chartView.convertPointFromScreen(screenPoint: CGPoint(x: rect.maxX, y: rect.minY))
        let bounds = Bounds(minX: Double(minPoint.x), maxX: Double(maxPoint.x), minY: Double(minPoint.y), maxY: Double(maxPoint.y))
        let includeInterpolatedValues = dataProvider.providesInterpolatedData && lineStyle.isConnected
        
        return dataProvider.data(withinBounds: bounds, chartView: chartView, includeInterpolatedValues: includeInterpolatedValues).map { data in
            let screenPoint = chartView.convertPointToScreen(modelPoint: CGPoint(x: data.1.0, y: data.1.1))
            let index = data.0
            let value = data.1
            let isInterpolated = includeInterpolatedValues && index == nil
            return ChartValue(chartDrawable: self, index: index, value: value, interpolated: isInterpolated, screenPoint: screenPoint)
        }
    }

}

internal protocol LineData: CustomPlaygroundQuickLookable {
    var providesInterpolatedData: Bool { get }
    func boundsOfData(chartView: ChartView) -> Bounds
    func data(forBounds bounds: Bounds, chartView: ChartView) -> [(Double, Double)]
    func data(withinBounds bounds: Bounds, chartView: ChartView, includeInterpolatedValues: Bool) -> [(Int?, (Double, Double))]
}

internal class DiscreteLineData: LineData {
    
    fileprivate let xyData: XYData
    
    init(xyData: XYData) {
        self.xyData = xyData
    }
    
    var providesInterpolatedData: Bool {
        return true
    }
    
    func boundsOfData(chartView: ChartView) -> Bounds {
        guard xyData.count > 0 else { return Bounds.infinite }
        
        let xData = xyData.xData
        let yData = xyData.yData
        
        return Bounds(minX: xData.min()!, maxX: xData.max()!, minY: yData.min()!, maxY: yData.max()!)
    }

    func data(forBounds bounds: Bounds, chartView: ChartView) -> [(Double, Double)] {
        return xyData.xyData
    }
    
    func data(withinBounds bounds: Bounds, chartView: ChartView, includeInterpolatedValues: Bool) -> [(Int?, (Double, Double))] {
        let xyData = self.xyData.xyData
        var dataWithinBounds = [(Int?, (Double, Double))]()
        
        if xyData.count == 0 {
            return dataWithinBounds
        }
        
        for (index, data) in xyData.enumerated() {
            if bounds.contains(data: data) {
                dataWithinBounds.append((index, data))
            }
        }
        
        if includeInterpolatedValues && dataWithinBounds.count == 0 {
            for (index, data) in xyData.enumerated() {
                if data.0 > bounds.midX {
                    if index == 0 {
                        break
                    }

                    guard let interpolatedValue = interpolatedValueBetween(a: xyData[index - 1], b: data, time: Double(bounds.midX)) else {
                        break
                    }
                    
                    if bounds.contains(data: interpolatedValue) {
                        // We can only have at most 1 interpolated value and it cannot have an index.
                        dataWithinBounds.append((nil, interpolatedValue))
                        break
                    }
                }
            }
        }
        
        return dataWithinBounds
    }
    
    private func interpolatedValueBetween(a: (Double, Double), b: (Double, Double), time: Double) -> (Double, Double)? {
        let interpolationWidth = (b.0 - a.0)
        let interpolationHeight = (b.1 - a.1)

        let interpolationTime = (time - a.0) / interpolationWidth
        if interpolationTime < 0 || interpolationTime > 1 {
            return nil
        }
        
        return (a.0 + (interpolationWidth * interpolationTime), a.1 + (interpolationHeight * interpolationTime))
    }
    
}

extension DiscreteLineData: CustomPlaygroundQuickLookable {
    internal var customPlaygroundQuickLook: PlaygroundQuickLook {
        get {
            let numPoints = xyData.count
            let suffix = numPoints == 1 ? "point" : "points"
            return .text("\(numPoints) \(suffix)")
        }
    }
}

internal class FunctionLineData: LineData {
    
    fileprivate let function: (Double) -> Double
    
    init(function: @escaping (Double) -> Double) {
        self.function = function
    }
    
    var providesInterpolatedData: Bool {
        return false
    }
    
    /// For function data, use the current chart's x bounds, and then sample the data to determine the y bounds.
    func boundsOfData(chartView: ChartView) -> Bounds {
        
        // grab the data for the current chart bounds.
        var bounds = chartView.axisBounds
        let boundedData = data(forBounds: bounds, chartView: chartView)
        
        guard boundedData.count > 0 else { return Bounds.infinite }
        
        // grab the y points for the data.
        let yData = boundedData.map { $0.1 }
        
        // update the x bounds to indicate that the data is unbounded.
        bounds.minX = .infinity
        bounds.maxX = .infinity
        
        // udpate the bounds match the y data min and max values.
        bounds.minY = yData.min()!
        bounds.maxY = yData.max()!
        
        return bounds
    }
    
    func data(forBounds bounds: Bounds, chartView: ChartView) -> [(Double, Double)] {
        
        let axisBounds = chartView.axisBounds
        
        let screenZeroAsModel = chartView.convertPointFromScreen(screenPoint: CGPoint.zero).x
        let screenStrideOffsetAsModel = chartView.convertPointFromScreen(screenPoint: CGPoint(x: FunctionSampleInternalInPoints, y: 0.0)).x
        let modelStride = Double(screenStrideOffsetAsModel - screenZeroAsModel)
        
        var data = [(Double, Double)]()
        for x in stride(from: axisBounds.minX, through: axisBounds.maxX, by: modelStride) {
            data.append((x, function(x)))
        }
        
        // make sure we always go to the end.
        data.append(axisBounds.maxX, function(axisBounds.maxX))
        
        return data
    }
    
    func data(withinBounds bounds: Bounds, chartView: ChartView, includeInterpolatedValues: Bool) -> [(Int?, (Double, Double))] {
        let data = (bounds.midX, function(bounds.midX))
        if bounds.contains(data: data) {
            return [(nil, data)] // Function data won't ever have an index.
        }
        return []
    }

}

extension FunctionLineData: CustomPlaygroundQuickLookable {
    internal var customPlaygroundQuickLook: PlaygroundQuickLook {
        get {
            return .text(String(describing: function))
        }
    }
}

