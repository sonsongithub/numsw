//
//  Symbol.swift
//  Charts
//

import UIKit

/// Types of shapes that can be used to create symbols.
public enum SymbolShape: Int {
    case circle = 0
    case square = 1
    case triangle = 2
}

/// A symbol that represents a point on the screen.
public class Symbol {
    
    private let symbolDrawable: SymbolDrawable
    
    internal let size: Double
    
    /// Creates a shape-based symbol:
    ///   - `shape`. The type of shape. The default value is .circle.
    ///   - `size`. The size of the shape. The default value is 8.0.
    public init(shape: SymbolShape = .circle, size: Double = 8.0) {
        symbolDrawable = ShapeSymbolDrawable(shape: shape, size: size)
        self.size = size
    }
 
    /// Creates an image-based symbol:
    ///   - `imageName`. The name of the image in this playground’s resources.
    ///   - `size`. The size of the image. The default value is 32.0.
    public init(imageNamed imageName: String, size: Double = 32.0) {
        symbolDrawable = ImageSymbolDrawable(imageNamed: imageName, size: size)
        self.size = size
    }
    
    internal func draw(atCenterPoint point: CGPoint, fillColor: UIColor, usingContext context: CGContext) {
        symbolDrawable.draw(atCenterPoint: point, fillColor: fillColor, usingContext: context)
    }
}

private protocol SymbolDrawable {
    func draw(atCenterPoint point: CGPoint, fillColor: UIColor, usingContext context: CGContext)
}

fileprivate class ShapeSymbolDrawable: SymbolDrawable {
    
    private var fillColor = Color.blue.uiColor
    
    private let size: Double
    
    private let shape: SymbolShape
    
    private var pathImage: UIImage?
    
    fileprivate init(shape: SymbolShape, size: Double) {
        
        self.shape = shape
        self.size = size
        
        updatePathImage()
    }
    
    private func updatePathImage() {
        
        let rect = CGRect(x: 0, y: 0, width: CGFloat(size), height: CGFloat(size))
        
        let path: UIBezierPath
        switch shape {
        case .circle:
            path = UIBezierPath(ovalIn: rect)
        case .square:
            path = UIBezierPath(rect: rect)
        case .triangle:
            path = UIBezierPath()
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.close()
            path.lineJoinStyle = .miter
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(fillColor.cgColor)
        path.fill()
        
        pathImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func draw(atCenterPoint point: CGPoint, fillColor: UIColor, usingContext context: CGContext) {
        
        if (self.fillColor != fillColor) {
            self.fillColor = fillColor
            updatePathImage()
        }
        
        let sizeAsFloat = CGFloat(size)
        let x = point.x - sizeAsFloat/2.0
        let y = point.y - sizeAsFloat/2.0
        
        let rect = CGRect(x: x, y: y, width: sizeAsFloat, height: sizeAsFloat)
        pathImage?.draw(in: rect)
    }
}

private class ImageSymbolDrawable: SymbolDrawable {
    
    private let uiImage: UIImage
    
    private let size: Double
    
    init(imageNamed imageName: String, size: Double) {
        
        if let uiImage = UIImage(named: imageName) {
            self.uiImage = uiImage
            self.size = size
        } else {
            self.uiImage = #imageLiteral(resourceName: "QuestionMark")
            self.size = 24.0
        }
        
    }
    
    func draw(atCenterPoint point: CGPoint, fillColor: UIColor, usingContext context: CGContext) {
        
        let imageWidth = uiImage.size.width
        let imageHeight = uiImage.size.height
        let sizeAsFloat = CGFloat(size)
        let widthGreaterThanHeight = uiImage.size.width > uiImage.size.height
        
        let width = widthGreaterThanHeight ? sizeAsFloat : sizeAsFloat * (imageWidth/imageHeight)
        let height = widthGreaterThanHeight ? sizeAsFloat * (imageHeight/imageWidth) : sizeAsFloat
        let x = point.x - width/2.0
        let y = point.y - height/2.0
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        uiImage.draw(in: rect)
    }
}
