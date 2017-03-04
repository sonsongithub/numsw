//
//  Color.swift
//  Charts
//

import UIKit

public class Color: _ExpressibleByColorLiteral, Equatable {
    
    internal let uiColor: UIColor
    
    internal var cgColor: CGColor {
        return uiColor.cgColor
    }
    
    public static let clear: Color = #colorLiteral(red: 1, green: 0.9999743700027466, blue: 0.9999912977218628, alpha: 0)
    
    public static let white: Color  = #colorLiteral(red: 1, green: 0.9999743700027466, blue: 0.9999912977218628, alpha: 1)
    public static let gray: Color = #colorLiteral(red: 0.3367644548, green: 0.3980174661, blue: 0.4406478703, alpha: 1)
    public static let black: Color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    public static let purple: Color = #colorLiteral(red: 0.2666243911, green: 0.1584459841, blue: 0.7177972794, alpha: 1)
    public static let pink: Color   = #colorLiteral(red: 0.7086744905, green: 0.05744680017, blue: 0.5434997678, alpha: 1)
    public static let green: Color  = #colorLiteral(red: 0.07005243003, green: 0.5545874834, blue: 0.1694306433, alpha: 1)
    public static let blue: Color   = #colorLiteral(red: 0, green: 0.1771291047, blue: 0.97898072, alpha: 1)
    
    public init(white: CGFloat, alpha: CGFloat = 1.0) {
        uiColor = UIColor(white: white, alpha: alpha)
    }
    
    public init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1.0) {
        uiColor = UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: CGFloat(alpha))
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        uiColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

    internal init(_ uiColor: UIColor) {
        self.uiColor = uiColor
    }
    
    public convenience required init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }
    
    public func lighter(percent: Double = 0.2) -> Color {
        return colorByAdjustingBrightness(percent: 1 + percent)
    }
    
    public func withAlpha(alpha: Double) -> Color {
        return Color( uiColor.withAlphaComponent(CGFloat(alpha)))
    }
    
    public func darker(percent: Double = 0.2) -> Color {
        return colorByAdjustingBrightness(percent: 1 - percent)
    }
    
    private func colorByAdjustingBrightness(percent: Double) -> Color {
        var cappedPercent = min(percent, 1.0)
        cappedPercent = max(0.0, percent)
        
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness) * cappedPercent, alpha: Double(alpha))
    }
    
    public static func random() -> Color {
        let uint32MaxAsFloat = Float(UInt32.max)
        let red = Float(arc4random()) / uint32MaxAsFloat
        let blue = Float(arc4random()) / uint32MaxAsFloat
        let green = Float(arc4random()) / uint32MaxAsFloat
        
        return Color(red: Double(red), green: Double(green), blue: Double(blue), alpha: 1.0)
    }
    
    private static let standard = [purple, pink, green, blue, gray]
    
    private static var currentColorIndex = 0
    
    internal static func next() -> Color {
        let colorToReturn = standard[currentColorIndex]
        if (currentColorIndex == standard.count - 1) {
            currentColorIndex = 0
        } else {
            currentColorIndex += 1
        }
        
        return colorToReturn
    }
    
    internal static func resetCurrentColor() {
        currentColorIndex = 0
    }
}

public func ==(left: Color, right: Color) -> Bool {
    return left.uiColor == right.uiColor
}
