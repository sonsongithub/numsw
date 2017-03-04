//
//  ChartContentView.swift
//  Charts
//

import UIKit

internal class ChartContentView: UIView {
    
    internal weak var chartView: ChartView?
    
    internal var backgroundView: ChartBackgroundView?
    
    internal var plottingView: ChartPlottingView?
    
    // - Initialization -
    init(chartView: ChartView) {
        super.init(frame: CGRect.zero)
        
        self.chartView = chartView
        
        let blurEffect = UIBlurEffect(style: .light)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        
        let visualEffectView = UIVisualEffectView(effect: vibrancyEffect)
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(visualEffectView)
        
        backgroundView = ChartBackgroundView(contentView: self)
        backgroundView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.contentView.addSubview(backgroundView!)
        
        plottingView = ChartPlottingView(contentView: self)
        plottingView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(plottingView!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not a valid initializer for this class")
    }
    
    var drawsGridLines: Bool = false {
        didSet {
            if oldValue != drawsGridLines {
                backgroundView?.setNeedsDisplay()
            }
        }
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        backgroundView?.setNeedsDisplay()
        plottingView?.setNeedsDisplay()
    }
    
}

internal class ChartPlottingView: UIView {
    
    internal weak var contentView: ChartContentView!
    
    init(contentView: ChartContentView) {
        super.init(frame: CGRect.zero)
        self.contentView = contentView
        self.isOpaque = false
        self.layer.drawsAsynchronously = true
        self.layer.needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let chartView = contentView.chartView else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        for chartDrawable in chartView.chartDrawables {
            chartDrawable.draw(withChartView: chartView, context: context)
        }
    }
    
}

internal class ChartBackgroundView: UIView {
    
    internal weak var contentView: ChartContentView!
    
    init(contentView: ChartContentView) {
        super.init(frame: CGRect.zero)
        self.contentView = contentView
        self.isOpaque = false
        self.layer.drawsAsynchronously = true
        self.layer.needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let chartView = contentView.chartView else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        drawAxisLabelsAndGridlinesInContext(context, chartView: chartView)
    }
    
    private let xAxisLabelPreferredStrideInPoints = 75.0
    private let yAxisLabelPreferredStrideInPoints = 35.0
    
    private let axisLabelBitmapCache = NSCache<AnyObject, UIImage>()
    
    func drawAxisLabelsAndGridlinesInContext(_ context: CGContext, chartView: ChartView) {
        
        let style = chartView.style
        let contentFrame = chartView.bounds
        let widthInPoints = contentFrame.width
        let heightInPoints = contentFrame.height
        let idealNumXLabels = widthInPoints / CGFloat(xAxisLabelPreferredStrideInPoints)
        let idealNumYLabels = heightInPoints / CGFloat(yAxisLabelPreferredStrideInPoints)
        
        let axisBounds = chartView.axisBounds
        let deltaX = axisBounds.deltaX
        let deltaY = axisBounds.deltaY
        let rawXStride = deltaX / Double(idealNumXLabels)
        let rawYStride = deltaY / Double(idealNumYLabels)
        
        let actualXStride = adjustedStrideForRawStride(stride: rawXStride)
        let actualYStride = adjustedStrideForRawStride(stride: rawYStride)
        
        var startingX = axisBounds.minX
        if fmod(axisBounds.minX, actualXStride) != 0 {
            startingX = (floor(axisBounds.minX / actualXStride) * actualXStride) + actualXStride
        }
        
        var startingY = axisBounds.minY
        if fmod(axisBounds.minY, actualYStride) != 0 {
            startingY = (floor(axisBounds.minY / actualYStride) * actualYStride) + actualYStride
        }
        
        // Draw x axis labels and grid/reference lines
        var yLabelXPos: CGFloat = 0
        var xLabelYPos: CGFloat = bounds.maxY
        
        // Returns a rendered representation of the provided string as a UIImage
        func renderLabelImageFrom(string: String) -> UIImage? {
            let attributes = style.axisLabelAttributes
            let size = string.size(attributes: attributes)
            
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            string.draw(at: CGPoint.zero, withAttributes: style.axisLabelAttributes)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return image
        }
        
        // Returns or creates a cached axis-label image
        func labelImageFrom(string: String) -> UIImage {
            if let xLabelImage = axisLabelBitmapCache.object(forKey: string as AnyObject) {
                return xLabelImage
            }
            else if let xLabelImage = renderLabelImageFrom(string: string) {
                axisLabelBitmapCache.setObject(xLabelImage, forKey: string as AnyObject)
                return xLabelImage
            }
            else {
                fatalError("Unable to create axis label image.")
            }
        }
        
        // Used to round strided values to the same maximum fractional digits as our number formatter
        let strideValueDivisor = pow(10.0, Double(style.axisNumberFormatter.maximumFractionDigits))
        
        // Calculate the X label/gridlines and Y label horizontal positions
        var xValues = [(Double, CGFloat)]()
        var xLabelImages = [UIImage]()
        var xLabelsMaxHeight: CGFloat = 0.0
        for var x in stride(from: startingX, through: axisBounds.maxX, by: actualXStride) {
            x = round(x * strideValueDivisor) / strideValueDivisor
            
            if (startingX.isLess(than: 0)) {
                yLabelXPos = bounds.maxX
            }
            
            let xLabelScreenPoint = chartView.convertPointToScreen(modelPoint: CGPoint(x: x, y: 0.0))
            xValues.append((x, xLabelScreenPoint.x))
            
            let xLabelString = style.axisNumberFormatter.string(from: NSNumber(value: x)) ?? ""
            let xLabelImage = labelImageFrom(string: xLabelString)
            
            xLabelImages.append(xLabelImage)
            xLabelsMaxHeight = max(xLabelsMaxHeight, xLabelImage.size.height)
        }
        
        // Calculate the Y label/gridlines and X label vertical positions
        var yValues = [(Double, CGFloat)]()
        var yLabelImages = [UIImage]()
        var yLabelsMaxWidth: CGFloat = 0.0
        for var y in stride(from: startingY, through: axisBounds.maxY, by: actualYStride) {
            y = round(y * strideValueDivisor) / strideValueDivisor
            
            if (startingY.isLess(than: 0)) {
                xLabelYPos = bounds.minY
            }
            
            let yLabelScreenPoint = chartView.convertPointToScreen(modelPoint: CGPoint(x: 0.0, y: y))
            yValues.append((y, yLabelScreenPoint.y))
            
            let yLabelString = style.axisNumberFormatter.string(from: NSNumber(value: y)) ?? ""
            let yLabelImage = labelImageFrom(string: yLabelString)
            
            yLabelImages.append(yLabelImage)
            yLabelsMaxWidth = max(yLabelsMaxWidth, yLabelImage.size.width)
        }
        
        var xReferenceLine: CGFloat?
        for (x, xScreenPoint) in xValues {
            // Draw the grid/reference lines if they fall within the visible bounds.
            if (xScreenPoint >= contentFrame.minX && xScreenPoint <= contentFrame.maxX) {
                if (abs(x) <= DBL_EPSILON) {
                    // keep track of the X reference line position for our Y labels.
                    yLabelXPos = xScreenPoint
                    // Keep track of a vertical reference line if we're at the 0 point to draw later.
                    xReferenceLine = xScreenPoint
                }
                else if (contentView.drawsGridLines) {
                    // draw a vertical grid line.
                    context.move(to: CGPoint(x: xScreenPoint, y: contentFrame.minY))
                    context.addLine(to: CGPoint(x: xScreenPoint, y: contentFrame.maxY))
                }
            }
        }
        
        var yReferenceLine: CGFloat?
        for (y, yScreenPoint) in yValues {
            // Draw the grid/reference lines if they fall within the visible bounds.
            if (yScreenPoint >= contentFrame.minY && yScreenPoint <= contentFrame.maxY) {
                if (abs(y) <= DBL_EPSILON) {
                    // keep track of the Y reference line position for our X labels.
                    xLabelYPos = yScreenPoint
                    // Keep track of a horizontal reference line if we're at the 0 point to draw later.
                    yReferenceLine = yScreenPoint
                }
                else if (contentView.drawsGridLines) {
                    // draw a horizontal grid line.
                    context.move(to: CGPoint(x: contentFrame.minX, y: yScreenPoint))
                    context.addLine(to: CGPoint(x: contentFrame.maxX, y: yScreenPoint))
                }
            }
        }
        
        context.setLineWidth(1.0)
        context.setStrokeColor(style.majorGridlinesColor.cgColor)
        context.strokePath()
        
        if let xReferenceLine = xReferenceLine {
            // draw a vertical reference line
            context.move(to: CGPoint(x: xReferenceLine, y: contentFrame.minY))
            context.addLine(to: CGPoint(x: xReferenceLine, y: contentFrame.maxY))
        }
        
        if let yReferenceLine = yReferenceLine {
            // draw a horizontal reference line
            context.move(to: CGPoint(x: contentFrame.minX, y: yReferenceLine))
            context.addLine(to: CGPoint(x: contentFrame.maxX, y: yReferenceLine))
        }
        
        context.setStrokeColor(style.referenceGridlinesColor.cgColor)
        context.strokePath()
        
        let axisLabelPadding = CGFloat(style.axisLabelPadding)
        
        // determine the minY for the X axis labels
        let xAxisLabelMinY: CGFloat
        if let safeAreaLayoutGuide = chartView.safeAreaLayoutGuide {
            xAxisLabelMinY = safeAreaLayoutGuide.layoutFrame.origin.y
        }
        else {
            xAxisLabelMinY = bounds.minY
        }
        
        // clamp the X label Y position to the calculated layout min Y
        xLabelYPos = max(xLabelYPos, xAxisLabelMinY)
        
        // draw the X axis value labels
        for ((x, xScreenPos), xLabelImage) in zip(xValues, xLabelImages) where abs(x) > DBL_EPSILON {
            let invertPosition = (xLabelYPos - xLabelsMaxHeight - axisLabelPadding < xAxisLabelMinY)
            let xLabelLocation = CGPoint(
                x: xScreenPos - xLabelImage.size.width / 2.0,
                y: invertPosition ? xLabelYPos + axisLabelPadding : xLabelYPos - xLabelImage.size.height - axisLabelPadding)
            xLabelImage.draw(at: xLabelLocation)
        }
        
        // draw the Y axis value labels.
        for ((y, yScreenPos), yLabelImage) in zip(yValues, yLabelImages) where abs(y) > DBL_EPSILON {
            let invertPosition = (yLabelXPos + yLabelsMaxWidth + axisLabelPadding > bounds.maxX)
            let yLabelLocation = CGPoint(
                x: invertPosition ? yLabelXPos - yLabelImage.size.width - axisLabelPadding : yLabelXPos + axisLabelPadding,
                y: yScreenPos - yLabelImage.size.height/2.0)
            yLabelImage.draw(at: yLabelLocation)
        }
    }
    
    private func adjustedStrideForRawStride(stride: Double) -> Double {
        let digits = floor(log10(stride))
        let multiplier = pow(10, digits)
        let normalizedStride = stride / multiplier
        let magicNumber = magicNumberForInteger(number: normalizedStride)
        
        return magicNumber * multiplier
    }
    
    private func magicNumberForInteger(number: Double) -> Double {
        switch number {
        case let x where x <= 1:
            return 1
            
        case let x where x <= 2:
            return 2
            
        case let x where x <= 5:
            return 5
            
        default:
            return 10
        }
    }
    
}
