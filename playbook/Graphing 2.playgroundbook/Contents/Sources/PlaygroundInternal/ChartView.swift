//
//  GraphView.swift
//  Charts
//

import UIKit

let ChartDrawableWasAddedNotification = "ChartDrawableWasAddedNotification"
let ChartDrawableWasRemovedNotification = "ChartDrawableWasRemovedNotification"

private let TopToTitleOffset = 20.0
private let BottomOfXAxisToXAxisTitleOffset = 22.0

internal class ChartView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var safeAreaLayoutGuide: UILayoutGuide? {
        didSet {
            contentView.setNeedsDisplay()
        }
    }
    
    /// The visible bounds of this graph.
    var axisBounds: Bounds = Bounds(minX: 0.0, maxX: 10.0, minY: 0.0, maxY: 10.0) {
        willSet(newValue) {
            // add bounds validation.
        }
        
        didSet {
            contentView.setNeedsDisplay()
        }
    }
    
    /// The bounds that this graph are constrained to. By default, these bounds are infinity in all directions.
    var viewableGraphBounds = Bounds(minX: -Double.greatestFiniteMagnitude, maxX: Double.greatestFiniteMagnitude, minY: Double.leastNormalMagnitude, maxY: Double.greatestFiniteMagnitude)
    
    /// Various style attributes describing how this graph should be drawn.
    var style = ChartStyle()
    
    /// True if the user has panned or zoomed.
    internal var userHasPannedOrZoomed = false
    
    private var scrollView: UIScrollView!

    // MARK: - Initialization -
    internal override required init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.25)

        contentView = ChartContentView(chartView: self)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        valueView = ChartValueView(chartView: self)
        valueView.frame = bounds
        valueView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(valueView)
        
        scrollView = UIScrollView(frame: bounds)
        scrollView.decelerationRate = style.scrollingDecelerationRate
        scrollView.delegate = self
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        // add the pinch gesture recognizer.
        pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(ChartView.handlePinchGestureRecognizer(recognizer:)))
        pinchGestureRecognizer.delegate = self
        addGestureRecognizer(pinchGestureRecognizer)
        
        // add the tap gesture recognizer.
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChartView.handleTapGestureRecognizer(recognizer:)))
        addGestureRecognizer(tapGestureRecognizer)
        
        // add the long press gesture recognizer.
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ChartView.handleLongPressGestureRecognizer(recognizer:)))
        addGestureRecognizer(longPressRecognizer)
        
        axisBounds = Bounds(minX: -4, maxX: 4, minY: -2, maxY: 2)
        viewableGraphBounds = Bounds(minX: -5, maxX: 5, minY: -3, maxY: 3)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Interaction -
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.contentSize = bounds.insetBy(dx: -bounds.width, dy: -bounds.width).size
        resetScrollViewContentOffset()
        
        DispatchQueue.main.async {
            self.contentView.setNeedsDisplay()
        }
    }
    
    var interactionReferenceBounds: Bounds?
    
    var interactionInProgress: Bool {
        return scrollView.isTracking || pinchGestureRecognizer.state == .changed
    }
    
    func interactionWillBegin() {
        interactionReferenceBounds = axisBounds
        scrollViewCumulativeDelta = CGPoint.zero
        pinchGestureScale = nil
    }
    
    func interactionWillEnd() {
        interactionReferenceBounds = nil
        scrollViewCumulativeDelta = CGPoint.zero
        pinchGestureScale = nil
    }
    
    func adjustBoundsForInteraction() {
        if let interactionReferenceBounds = interactionReferenceBounds {
            var adjustedBounds = interactionReferenceBounds
            
            // Adjust the position
            scrollViewCumulativeDelta.x += scrollViewContentOffsetDelta.x
            scrollViewCumulativeDelta.y += scrollViewContentOffsetDelta.y
            
            let pointsPerBoundUnitX = CGFloat(interactionReferenceBounds.deltaX) / bounds.width
            let pointsPerBoundUnitY = CGFloat(interactionReferenceBounds.deltaY) / bounds.height
            
            let scrollMultiplier = CGPoint(x: pointsPerBoundUnitX, y: pointsPerBoundUnitY)
            adjustedBounds = adjustedBounds.adjustedByPositionPoint(point: scrollViewCumulativeDelta, multiplier: scrollMultiplier)
            
            // Adjust the scale
            if let pinchScale = pinchGestureScale {
                adjustedBounds = adjustedBounds.adjustedByScale(scale: pinchScale, from: pinchAnchorPoint)
            }
            
            axisBounds = adjustedBounds
        }
    }
    
    // MARK: - Scroll View -
    
    var scrollViewCumulativeDelta = CGPoint.zero
    var scrollViewIsInteracting: Bool {
        get {
            return scrollView.isDragging
        }
    }
    
    var defaultScrollViewContentOffset: CGPoint {
        return CGPoint(x: (scrollView.contentSize.width / 2) - (scrollView.frame.width / 2), y: (scrollView.contentSize.height / 2) - (scrollView.frame.height / 2))
    }
    
    var scrollViewContentOffsetDelta: CGPoint {
        get {
            return CGPoint(x: defaultScrollViewContentOffset.x - scrollView.contentOffset.x, y: defaultScrollViewContentOffset.y - scrollView.contentOffset.y)
        }
    }
    
    func resetScrollViewContentOffset() {
        scrollView.contentOffset = defaultScrollViewContentOffset
    }
    
    // MARK: - Scroll View Delegate -
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if (pinchGestureIsInteracting == false) {
            interactionWillBegin()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        valueView.dismissDisplayedValues()
        adjustBoundsForInteraction()
        resetScrollViewContentOffset()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView.isDecelerating == false) {
            if (pinchGestureIsInteracting == false) {
                interactionWillEnd()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (pinchGestureIsInteracting == false) {
            interactionWillEnd()
        }
    }
    
    // MARK: - Gesture Recognizers -

    private var pinchGestureScale: Double?
    private var pinchAnchorPoint = CGPoint.zero
    private var pinchGestureRecognizer: UIPinchGestureRecognizer!
    private var pinchGestureIsInteracting: Bool {
        get {
            return pinchGestureRecognizer.state != .possible
        }
    }
    
    func handlePinchGestureRecognizer(recognizer: UIPinchGestureRecognizer) {
        valueView.dismissDisplayedValues()
        
        if (recognizer.state == .began) {
            if (scrollViewIsInteracting == false) {
                interactionWillBegin()
            }
            pinchAnchorPoint = convertPointFromScreen(screenPoint: recognizer.location(in: self))
        }
        else if (recognizer.state == .changed) {
            pinchGestureScale = Double(recognizer.scale)
            adjustBoundsForInteraction()
        }
        else if (recognizer.state == .ended || recognizer.state == .cancelled) {
            if (scrollViewIsInteracting == false) {
                interactionWillEnd()
            }
        }
    }
    
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    func handleTapGestureRecognizer(recognizer: UITapGestureRecognizer) {
        valueView.dismissDisplayedValues()
        
        let location = recognizer.location(in: valueView)
        let sizeOfTapArea: CGFloat = 44.0
        let touchRect = CGRect(origin: CGPoint(x: location.x - sizeOfTapArea/2.0, y: location.y - sizeOfTapArea/2.0), size: CGSize(width: sizeOfTapArea, height: sizeOfTapArea))
        
        var valueDisplayed = false
        
        for chartDrawable in chartDrawables {
            let chartValues = chartDrawable.values(inScreenRect: touchRect, inChartView: self)
            if chartValues.count > 0 {
                valueView.display(values: chartValues)
                valueDisplayed = true
            }
        }
        
        if (valueDisplayed) {
            contentView.drawsGridLines = true
        }
        else {
            contentView.drawsGridLines = !contentView.drawsGridLines
        }
    }
    
    private var longPressRecognizer: UILongPressGestureRecognizer!
    
    func handleLongPressGestureRecognizer(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: valueView)

        switch recognizer.state {
        case .began:
            valueView.dismissDisplayedValues()
            fallthrough
        case .changed:
            valueView.displayHighlightAt(horizontalLocation: location.x)
        default:
            valueView.dismissHighlight()
        }
        
        let lineWidth = CGFloat(style.highlightLineWidth)
        let lineRect = CGRect(origin: CGPoint(x: location.x - lineWidth / 2, y: 0), size: CGSize.zero)
        
        // Extend the line rect vertically to pick up data outside the display bounds and horizontally to expand the search area.
        let sizeOfSearchArea: CGFloat = 10.0
        let searchRect = lineRect.insetBy(dx: -sizeOfSearchArea, dy: -bounds.height).offsetBy(dx: 0, dy: bounds.midY)
        
        var chartValues = [ChartValue]()
        for chartDrawable in chartDrawables {
            chartValues += chartDrawable.values(inScreenRect: searchRect, inChartView: self)
        }
        
        valueView.display(values: chartValues)
    }
    
    // MARK: - Gesture Recognizer Delegate - 
    
    @objc(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:) internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: - Content -
    private var contentView: ChartContentView!
    private var valueView: ChartValueView!
    
    var chartDrawables = [ChartDrawable]()
    
    internal func addChartDrawable(chartDrawable: ChartDrawable) {
        chartDrawables.append(chartDrawable)
        NotificationCenter.default.post(name: Notification.Name(ChartDrawableWasAddedNotification), object: chartDrawable)
    }
    
    internal func removeChartDrawable(chartDrawable: ChartDrawable) {
        let index = chartDrawables.index { otherChartDrawable -> Bool in
            return chartDrawable === otherChartDrawable
        }
        if let index = index {
            chartDrawables.remove(at: index)
        }
        
        NotificationCenter.default.post(name: Notification.Name(ChartDrawableWasRemovedNotification), object: chartDrawable)
        contentView.setNeedsDisplay()
    }
    
    internal func removeAllChartDrawables() {
        chartDrawables = [ChartDrawable]()
        valueView.dismissDisplayedValues()
        contentView.setNeedsDisplay()
    }
    
    internal func convertPointToScreen(modelPoint: CGPoint) -> CGPoint {
        
        let drawingFrame = bounds
        
        let numPixelsWide = drawingFrame.width
        let horizontalRatioOfPixelsToLogical = numPixelsWide / CGFloat(axisBounds.deltaX)
        
        let numPixelsTall = drawingFrame.height
        let verticalRatioOfPixelsToLogical = numPixelsTall / CGFloat(axisBounds.deltaY)
        
        let screenX = ((modelPoint.x - CGFloat(axisBounds.minX)) * horizontalRatioOfPixelsToLogical)
        let screenY = drawingFrame.maxY - ((modelPoint.y - CGFloat(axisBounds.minY)) * verticalRatioOfPixelsToLogical)
        
        return CGPoint(x: screenX, y: screenY)
    }

    internal func convertPointFromScreen(screenPoint: CGPoint) -> CGPoint {
        
        let drawingFrame = bounds
        
        // calculate the ratio of horizontal logical units to pixels.
        let numPixelsWide = drawingFrame.width
        let horizontalRatioOfLogicalToPixels = CGFloat(axisBounds.deltaX)/numPixelsWide

        // calculate the ratio of vertical logical units to pixels.
        let numPixelsTall = drawingFrame.height
        let verticalRatioOfLogicalToPixels = CGFloat(axisBounds.deltaY)/numPixelsTall
        
        // put the given x and y value in terms of logical units.
        let logicalX = (screenPoint.x * horizontalRatioOfLogicalToPixels) + CGFloat(axisBounds.minX)
        let logicalY = ((drawingFrame.maxY - screenPoint.y) * verticalRatioOfLogicalToPixels) + CGFloat(axisBounds.minY)
        
        return CGPoint(x: logicalX, y: logicalY);
    }
    
    internal func convertBoundsToScreen(bounds: Bounds) -> Bounds {
        let bottomLeftScreenPoint = convertPointToScreen(modelPoint: CGPoint(x: bounds.minX, y: bounds.minY))
        let topRightScreenPoint = convertPointToScreen(modelPoint: CGPoint(x: bounds.maxX, y: bounds.maxY))
        return Bounds(minX: Double(bottomLeftScreenPoint.x), maxX: Double(topRightScreenPoint.x), minY: Double(bottomLeftScreenPoint.y), maxY: Double(topRightScreenPoint.y))
    }
}

// MARK: - ChartDrawable -
internal protocol ChartDrawable: class {
    func boundsOfData(inChartView chartView: ChartView) -> Bounds
    func values(inScreenRect rect: CGRect, inChartView chartView: ChartView) -> [ChartValue]
    func draw(withChartView chartView: ChartView, context: CGContext)
    
    var color: Color { get set }
    var label: String? { get set }
}

