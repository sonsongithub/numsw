//
//  ChartStyle.swift
//  Charts
//

import UIKit

internal class ChartStyle {
    
    /// The color of the axis.
    var axisColor = Color(white: 0.8, alpha: 1.0)
    
    /// The padding of the axis labels.
    var axisLabelPadding = 5.0
    
    /// The color of the axis labels.
    var axisLabelColor: Color = Color.gray
    
    /// The font to use for the axis labels.
    var axisLabelFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    /// The string attributes to apply to the axis label text.
    var axisLabelAttributes: [String: AnyObject] {
        if let attributes = _axisLabelAttributes {
            return attributes
        }
        
        _axisLabelAttributes = [
            NSFontAttributeName: axisLabelFont,
            NSForegroundColorAttributeName: axisLabelColor.uiColor
            ]
        
        return _axisLabelAttributes!
    }
    var _axisLabelAttributes: [String: AnyObject]?
    
    /// The number formatter used to generate axis labels.
    lazy var axisNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    /// The color of the graph highlight line.
    var highlightLineColor: Color = Color(red: 1, green: 0, blue: 0)
    
    /// The width of the highlight line.
    var highlightLineWidth = 1.0
    
    /// The color of the value callout background.
    var calloutBackgroundColor: Color = Color(white: 1.0, alpha: 0.9)
    
    /// Returns the string attributes to apply to the callout title label with a given Color.
    func calloutTitleLabelAttributesWith(color: Color) -> [String: AnyObject] {
        return [
            NSFontAttributeName: calloutLabelFont,
            NSForegroundColorAttributeName: color.uiColor
        ]
    }
    
    /// The padding for the callout title label.
    var calloutTitlePadding = 5.0
    
    /// The maximum width for a callout.
    var calloutMaxWidth = 150.0
    
    /// The color of the label text for the callout field title.
    var calloutFieldTitleLabelColor: Color = Color(white: 0.0, alpha: 0.5)
    
    /// The string attributes to apply to the label for the callout field title.
    var calloutFieldTitleLabelAttributes: [String: AnyObject] {
        if let attributes = _calloutFieldTitleLabelAttributes {
            return attributes
        }
        
        _calloutFieldTitleLabelAttributes = [
            NSFontAttributeName: calloutLabelFont,
            NSForegroundColorAttributeName: calloutFieldTitleLabelColor.uiColor
        ]
        
        return _calloutFieldTitleLabelAttributes!
    }
    var _calloutFieldTitleLabelAttributes: [String: AnyObject]?
    
    /// The color of the label text for the callout field value.
    var calloutFieldValueLabelColor: Color = Color(white: 0.0, alpha: 0.9)
    
    /// The string attributes to apply to the label for the callout field title.
    var calloutFieldValueLabelAttributes: [String: AnyObject] {
        if let attributes = _calloutFieldValueLabelAttributes {
            return attributes
        }
        
        _calloutFieldValueLabelAttributes = [
            NSFontAttributeName: calloutLabelFont,
            NSForegroundColorAttributeName: calloutFieldValueLabelColor.uiColor
        ]
        
        return _calloutFieldValueLabelAttributes!
    }
    var _calloutFieldValueLabelAttributes: [String: AnyObject]?
    
    /// The font to use for the callout label.
    var calloutLabelFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    /// The inset from the edge of the value callout where the text will be drawn.
    var calloutLabelInset = 10.0
    
    /// The corner radius of the value callout.
    var calloutCornerRadius = 10.0
    
    /// The length of the callout array.
    var calloutArrowLength = 10.0
    
    /// The offset of the callout from its anchor.
    var calloutOffset = 10.0
    
    /// The minimum intersection allowed between callouts.
    var calloutIntersectionLimit = 5.0
    
    /// The minimum number of decimal points to display in the callouts for functions.
    var calloutFunctionMiniumPrecision = 4
    
    /// The maximum number of decimal points to display in the callouts for functions.
    var calloutFunctionMaximumPrecision = 10
    
    /// The color of the reference grid lines.
    var referenceGridlinesColor = Color.gray
    
    /// The color of the major grid lines.
    var majorGridlinesColor = Color.white
    
    /// The deceleration rate of the graph panning interaction.
    var scrollingDecelerationRate = UIScrollViewDecelerationRateNormal * 0.75
}

enum ChartBorderStyle {
    case none, bottomEdge, leftAndBottomEdges, topAndBottomEdges, allEdges
}
