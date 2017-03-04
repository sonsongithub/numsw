//
//  PointPlot.swift
//  Charts
//

import UIKit

public enum LineStyle {
    case none
    case solid
    case dashed
    case dotted
    
    var isConnected: Bool {
        get {
            return self != .none
        }
    }
}

/// An abstract, point-based plot that supports drawing points on the screen as symbols and connecting them with lines.
public class AbstractPointPlot {

    internal var linePlotDrawable: LinePlotDrawable
    
    /// The color of the line and symbols.
    public var color: Color {
        get {
            return linePlotDrawable.color
        }
        set {
            linePlotDrawable.color = newValue
        }
    }
    
    /// The stroke width of the line, in points.
    public var lineWidth: Double {
        get {
            return Double(linePlotDrawable.lineWidth)
        }
        set {
            linePlotDrawable.lineWidth = CGFloat(newValue)
        }
    }
    
    /// The symbols to draw at each point in the data set.
    public var symbol: Symbol? {
        get {
            return linePlotDrawable.symbol
        }
        set {
            linePlotDrawable.symbol = newValue
        }
    }

    /// The style to use to draw the line. The default value is .solid.
    public var style: LineStyle {
        get {
            return linePlotDrawable.lineStyle
        }
        set {
            linePlotDrawable.lineStyle = newValue
        }
    }
    
    public var label: String? {
        get {
            return linePlotDrawable.label
        }
        set {
            linePlotDrawable.label = newValue
        }
    }
    
    //MARK: initializers
    
    internal init(dataProvider: LineData, symbol: Symbol? = Symbol(), style: LineStyle = .none) {

        let chartView = Chart.shared.chartView
        linePlotDrawable = LinePlotDrawable()
        linePlotDrawable.dataProvider = dataProvider
        linePlotDrawable.color = Color.next()
        
        self.style = style
        self.symbol = symbol
        
        chartView.addChartDrawable(chartDrawable: linePlotDrawable)
    }
}

extension AbstractPointPlot: CustomPlaygroundQuickLookable {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        get {
            guard let dataProvider = linePlotDrawable.dataProvider else { return .text("") }
            return dataProvider.customPlaygroundQuickLook
        }
    }
}
