//
//  ChartGeometry.swift
//  Charts
//

import UIKit

extension Bounds {
    
    internal var deltaX: Double {
        get {
            return maxX - minX
        }
    }
    
    internal var deltaY: Double {
        get {
            return maxY - minY
        }
    }
    
    internal var midX: Double {
        get {
            return minX + ((maxX - minX) / 2)
        }
    }
    internal var midY: Double {
        get {
            return minY + ((maxY - minY) / 2)
        }
    }
    
    public var isEmpty: Bool {
        get {
            return deltaX == 0 && deltaY == 0
        }
    }
    
    internal func containsPoint(point: CGPoint) -> Bool {
        return (Double(point.x) >= minX) && (Double(point.x) <= maxX) && (Double(point.y) <= minY) && (Double(point.y) <= minY)
    }
    
    internal func adjustedByScale(scale: Double, from anchor: CGPoint) -> Bounds {
        var newBounds = self
        
        let xMultiplier = (Double(anchor.x) - minX) / deltaX
        let yMultiplier = (Double(anchor.y) - minY) / deltaY
        
        let xDeltaChange = deltaX - (deltaX / scale)
        let yDeltaChange = deltaY - (deltaY / scale)
        
        newBounds.minX += xDeltaChange * xMultiplier
        newBounds.maxX -= xDeltaChange * (1.0 - xMultiplier)
        newBounds.minY += yDeltaChange * yMultiplier
        newBounds.maxY -= yDeltaChange * (1.0 - yMultiplier)
        
        return newBounds
    }
    
    internal func adjustedByPositionPoint(point: CGPoint, multiplier: CGPoint = CGPoint(x: 1.0, y: 1.0)) -> Bounds {
        var newBounds = self
        newBounds.maxX -= Double(multiplier.x * point.x)
        newBounds.minX -= Double(multiplier.x * point.x)
        newBounds.maxY += Double(multiplier.y * point.y)
        newBounds.minY += Double(multiplier.y * point.y)
        
        return newBounds
    }
    
    /// Unions this Bounds with the other Bounds, favoring values that are not infinity.
    internal func unionIgnorningInfinity(_ otherBounds: Bounds) -> Bounds {
        let newMinX = minIgnoringInfinity(minX, otherBounds.minX)
        let newMaxX = maxIgnoringInfinity(maxX, otherBounds.maxX)
        let newMinY = minIgnoringInfinity(minY, otherBounds.minY)
        let newMaxY = maxIgnoringInfinity(maxY, otherBounds.maxY)
        
        return Bounds(minX: newMinX, maxX: newMaxX, minY: newMinY, maxY: newMaxY)
    }
    
    private func minIgnoringInfinity(_ a: Double, _ b: Double) -> Double {
        let minValue: Double
        if (a == .infinity) {
            minValue = b
        } else if (b == .infinity) {
            minValue = a
        } else {
            minValue = min(a, b)
        }
        
        return minValue
    }
    
    private func maxIgnoringInfinity(_ a: Double, _ b: Double) -> Double {
        let maxValue: Double
        if (a == .infinity) {
            maxValue = b
        } else if (b == .infinity) {
            maxValue = a
        } else {
            maxValue = max(a, b)
        }
        
        return maxValue
    }
}

extension CGRect {
    mutating func insetWithEdgeInsets(insets: UIEdgeInsets) {
        origin.x += insets.left
        origin.y += insets.bottom
        size.width -= insets.left + insets.right
        size.height -= insets.top + insets.bottom
    }
    
    func rectByInsettingRectWithEdgeInsets(insets: Insets) -> CGRect {
        var rect = self
        
        rect.origin.x += CGFloat(insets.left)
        rect.origin.y += CGFloat(insets.bottom)
        rect.size.width -= CGFloat(insets.left + insets.right)
        rect.size.height -= CGFloat(insets.top + insets.bottom)
        
        return rect
    }
}
