//
//  ChartValueView.swift
//  Charts
//

import UIKit

internal struct ChartValue {
    weak var chartDrawable: ChartDrawable?
    
    var label: String? {
        return chartDrawable?.label
    }
    
    var color: Color? {
        return chartDrawable?.color
    }
    
    let index: Int?
    let value: (Double, Double)
    let interpolated: Bool
    let screenPoint: CGPoint
}

private enum CalloutDirection {
    case up
    case down
    case left
    case right
    
    var isVertical: Bool {
        get {
            return self == .up || self == .down
        }
    }
    
    var opposite: CalloutDirection {
        switch self {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}


internal class ChartValueView: UIView {
    
    private let horizontalHighlightView: UIView
    
    private var horizontalHighlightLocation: CGFloat? {
        didSet {
            updateHorizontalHighlight()
        }
    }
    
    private var displayedValues = [ChartValue]()
    
    private var calloutViews = [CalloutView]()
    
    internal weak var chartView: ChartView?
    
    internal var displayLink: CADisplayLink!
    
    // MARK: Initialization
    
    init(chartView: ChartView) {
        horizontalHighlightView = UIView(frame: CGRect.zero)
        horizontalHighlightView.backgroundColor = chartView.style.highlightLineColor.uiColor
        
        super.init(frame: CGRect.zero)
        
        self.chartView = chartView
        self.isOpaque = false
        
        addSubview(horizontalHighlightView)
        
        displayLink = CADisplayLink(target: self, selector: #selector(displayLinkCallback(displayLink:)))
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        displayLink.invalidate()
    }
    
    // MARK: Interface
    
    internal func display(values: [ChartValue]) {
        if (values.count > 0) {
            displayedValues.removeAll()
        }
        
        displayedValues += values
        updateCalloutViewTargetLayout()
    }
    
    internal func dismissDisplayedValues() {
        displayedValues.removeAll()
        resetCalloutViewTargetLayout()
    }
    
    internal func displayHighlightAt(horizontalLocation: CGFloat?) {
        horizontalHighlightLocation = horizontalLocation
    }
    
    internal func dismissHighlight() {
        horizontalHighlightLocation = nil
    }
    
    // MARK: CADisplayLink
    
    var previousTimestamp: CFTimeInterval?
    
    func displayLinkCallback(displayLink: CADisplayLink) {
        let timestamp = displayLink.timestamp
        
        if previousTimestamp == nil {
            previousTimestamp = timestamp
        }
        
        guard let previousTimestamp = previousTimestamp else {
            fatalError()
        }
        
        self.previousTimestamp = timestamp
        
        let timestampDelta = timestamp - previousTimestamp
        let multiplier = timestampDelta / 0.1
        
        // Position the callout views relative to their target frames
        for calloutView in calloutViews {
            if let targetFrame = calloutView.targetLayout?.frame {
                if calloutView.frame.equalTo(targetFrame) == false {
                    let interpolatedOrigin = interpolatedValueBetween(a: calloutView.frame.origin, b: targetFrame.origin, multiplier: CGFloat(multiplier))
                    calloutView.frame = CGRect(origin: interpolatedOrigin, size: targetFrame.size)
                }
                calloutView.isHidden = false
            }
            else {
                calloutView.isHidden = true
            }
        }
    }

    // MARK: Display
    
    func updateHorizontalHighlight() {
        guard let chartView = chartView else {
            horizontalHighlightView.removeFromSuperview()
            return
        }
        
        let style = chartView.style
        let highlightWidth = CGFloat(style.highlightLineWidth)
        
        if let horizontalHighlightLocation = horizontalHighlightLocation {
            horizontalHighlightView.isHidden = false
            horizontalHighlightView.frame = CGRect(x: horizontalHighlightLocation - (highlightWidth / 2), y: 0, width: highlightWidth, height: bounds.height)
        }
        else {
            horizontalHighlightView.isHidden = true
        }
    }
    
    private func interpolatedValueBetween(a: CGPoint, b: CGPoint, multiplier: CGFloat, roundToNearestHalf: Bool = true) -> CGPoint {
        let interpolationWidth = (b.x - a.x)
        let interpolationHeight = (b.y - a.y)
        
        if multiplier <= 0 { return a }
        if multiplier >= 1 { return b }
        
        var interpolatedX = a.x + (interpolationWidth * multiplier)
        var interpolatedY = a.y + (interpolationHeight * multiplier)
        
        if roundToNearestHalf {
            interpolatedX = round(interpolatedX * 2.0) / 2.0
            interpolatedY = round(interpolatedY * 2.0) / 2.0
        }
        
        return CGPoint(x: interpolatedX, y: interpolatedY)
    }
    
    func resetCalloutViewTargetLayout() {
        for calloutView in calloutViews {
            calloutView.targetLayout = nil
        }
    }
    
    var previousSortedValuePoints = [ChartValue]()
    
    func updateCalloutViewTargetLayout() {
        guard let chartView = chartView else { return }
        let style = chartView.style
        
        // Sort the value points by their Y values
        let sortedValuePoints = displayedValues.sorted { (a, b) -> Bool in
            return a.value.1 > b.value.1
        }
        
        // Work out whether the order has changed since last time
        var orderHasChanged: Bool = {
            if (sortedValuePoints.count != previousSortedValuePoints.count) {
                return true
            }
            
            for (a, b) in zip(sortedValuePoints, previousSortedValuePoints) {
                if a.chartDrawable !== b.chartDrawable {
                    return true
                }
            }
        
            return false
        }()
        
        if orderHasChanged {
            resetCalloutViewTargetLayout()
        }
        
        previousSortedValuePoints = sortedValuePoints
        
        var updatedCalloutViews = [CalloutView]()
        func updateCalloutViewFor(valuePoint: ChartValue, preferredDirections: [CalloutDirection]) {
            let foundCalloutView = calloutViews.first { calloutView in
                if let calloutViewChartValue = calloutView.chartValue {
                    return calloutViewChartValue.chartDrawable === valuePoint.chartDrawable
                }
                return false
            }
            
            let calloutView: CalloutView
            if let foundCalloutView = foundCalloutView {
                calloutView = foundCalloutView
            }
            else {
                calloutView = CalloutView(style: style)
                calloutView.isHidden = true
                calloutViews.append(calloutView)
                addSubview(calloutView)
            }
            
            let screenPoint = valuePoint.screenPoint
            let integralScreenPoint = CGPoint(x: round(screenPoint.x), y: round(screenPoint.y))
            
            calloutView.precision = requiredPrecisionFor(delta: chartView.axisBounds.deltaX)
            calloutView.chartValue = valuePoint
            calloutView.targetLayout = targetLayoutFor(calloutView: calloutView, relativeTo: updatedCalloutViews, anchorPoint: integralScreenPoint, preferredDirections: preferredDirections)
            updatedCalloutViews.append(calloutView)
        }
        
        // Update the middle value points first
        if sortedValuePoints.count > 2 {
            for valuePoint in Array(sortedValuePoints[1...sortedValuePoints.count - 2]) {
                updateCalloutViewFor(valuePoint: valuePoint, preferredDirections: [.right, .left, .up, .down])
            }
        }
        
        // Then the top and bottom
        if sortedValuePoints.count >= 2 {
            updateCalloutViewFor(valuePoint: sortedValuePoints.first!, preferredDirections: [.up, .down, .right, .left])
            updateCalloutViewFor(valuePoint: sortedValuePoints.last!, preferredDirections: [.down, .up, .right, .left])
        }
        else if let valuePoint = sortedValuePoints.first {
            updateCalloutViewFor(valuePoint: valuePoint, preferredDirections: [.up, .down, .right, .left])
        }
        
        // Reset the target layout of any callouts that weren't updated.
        for calloutView in calloutViews {
            if updatedCalloutViews.contains(calloutView) == false {
                calloutView.targetLayout = nil
            }
        }
        
    }
    
    private func targetLayoutFor(calloutView: CalloutView, relativeTo otherCalloutViews: [CalloutView], anchorPoint: CGPoint, preferredDirections: [CalloutDirection]) -> CalloutLayout? {
        guard let chartView = chartView else { return nil }
        let style = chartView.style
        
        let calloutSize = calloutView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        let cornerRadius = CGFloat(style.calloutCornerRadius)
        let arrowLength = CGFloat(style.calloutArrowLength)
        let calloutOffset = CGFloat(style.calloutOffset)
        
        func calloutRectFor(direction: CalloutDirection) -> CGRect {
            let midWidth = (calloutSize.width / 2)
            let midHeight = (calloutSize.height / 2)
            let arrowExtension = ((calloutOffset + arrowLength) * 2)
            
            let origin: CGPoint
            switch direction {
            case .up:
                origin = CGPoint(
                    x: anchorPoint.x - midWidth,
                    y: anchorPoint.y - calloutSize.height - arrowLength - calloutOffset
                )
            case .down:
                origin = CGPoint(
                    x: anchorPoint.x - midWidth,
                    y: (anchorPoint.y - calloutSize.height - arrowLength - calloutOffset) + calloutSize.height + arrowExtension
                )
            case .left:
                origin = CGPoint(
                    x: (anchorPoint.x + arrowLength + calloutOffset) - (calloutSize.width + arrowExtension),
                    y: anchorPoint.y - midHeight
                )
            case .right:
                origin = CGPoint(
                    x: anchorPoint.x + arrowLength + calloutOffset,
                    y: anchorPoint.y - midHeight
                )
            }
            return CGRect(origin: origin, size: calloutSize)
        }
        
        func calloutLayoutFor(calloutRect: CGRect, direction: CalloutDirection, adjustedWithin bounds: CGRect) -> CalloutLayout? {
            let intersection = calloutRect.intersection(bounds)
            if intersection.isInfinite || intersection.isEmpty {
                return nil
            }
            
            var updatedFrame = calloutRect
            var updatedDirection = direction
            
            if intersection.width < calloutRect.width {
                if direction.isVertical {
                    // Adjust position slightly
                    let dx = calloutRect.minX < 0 ? calloutRect.width - intersection.width : -(calloutRect.width - intersection.width)
                    updatedFrame = calloutRect.offsetBy(dx: dx, dy: 0)
                }
                else {
                    // Flip over to the opposite direction = 
                    updatedDirection = updatedDirection.opposite
                    updatedFrame = calloutRectFor(direction: updatedDirection)
                }
            }
            else if intersection.height < calloutRect.height {
                if direction.isVertical {
                    let intersectingTop = (calloutRect.minY < intersection.minY)
                    if (intersectingTop && direction == .up) || (!intersectingTop && direction == .down) {
                        // Flip over to the opposite direction
                        updatedDirection = updatedDirection.opposite
                        updatedFrame = calloutRectFor(direction: updatedDirection)
                    }
                }
                else {
                    // Adjust position slightly
                    let dy = calloutRect.minY < 0 ? calloutRect.height - intersection.height : -(calloutRect.height - intersection.height)
                    updatedFrame = calloutRect.offsetBy(dx: 0, dy: dy)
                }
            }

            return CalloutLayout(direction: updatedDirection, frame: updatedFrame)
        }

        func greatestVerticalIntersectionWithOtherCalloutFor(calloutRect: CGRect) -> CGRect? {
            var tallestIntersection: CGRect?
            let calloutIntersectionLimit = CGFloat(style.calloutIntersectionLimit)
            for otherCalloutView in otherCalloutViews where otherCalloutView != calloutView {
                if let otherCalloutViewTargetLayout = otherCalloutView.targetLayout {
                    let expandedCalloutFrame = otherCalloutViewTargetLayout.frame.insetBy(dx: calloutIntersectionLimit.negated(), dy: calloutIntersectionLimit.negated())
                    if calloutRect.intersects(expandedCalloutFrame) {
                        let intersection = calloutRect.intersection(expandedCalloutFrame)
                        if tallestIntersection == nil {
                            tallestIntersection = intersection
                        }
                        else if calloutRect.intersection(expandedCalloutFrame).maxY > tallestIntersection!.maxY {
                            tallestIntersection = intersection
                        }
                    }
                }
            }
            return tallestIntersection
        }
        
        // Try the previous target direction first
        var directionsToAttempt = preferredDirections
        if let previousTargetLayout = calloutView.targetLayout {
            if let index = directionsToAttempt.index(of: previousTargetLayout.direction) {
                directionsToAttempt.insert(directionsToAttempt.remove(at: index), at: 0)
            }
        }
        
        // See if we can find a callout rect that fits without being adjusted
        for direction in directionsToAttempt {
            let potentialCalloutRect = calloutRectFor(direction: direction)
            if let verticalIntsersection = greatestVerticalIntersectionWithOtherCalloutFor(calloutRect: potentialCalloutRect) {
                if verticalIntsersection.height < potentialCalloutRect.height {
                    let verticallyAdjustedCalloutRect = potentialCalloutRect.offsetBy(dx: 0, dy: verticalIntsersection.minY > potentialCalloutRect.minY ? verticalIntsersection.height.negated() : verticalIntsersection.height)
                    return calloutLayoutFor(calloutRect: verticallyAdjustedCalloutRect, direction: direction, adjustedWithin: bounds)
                }
            }
            else {
                return calloutLayoutFor(calloutRect: potentialCalloutRect, direction: direction, adjustedWithin: bounds)
            }
        }
        
        return nil
    }
    
    func requiredPrecisionFor(delta: Double) -> Int {
        var precision = 1
        var multiplier = 1
        while (delta / 10.0) * Double(multiplier) < 1.0 {
            precision += 1
            multiplier *= 10
        }
        return precision
    }

}

private struct CalloutLayout {
    
    let direction: CalloutDirection
    
    let frame: CGRect
    
}

private class CalloutView: UIView {
    
    private class CalloutContentView: UIView {
        
        let titleLabel = UILabel()
        
        let valueLabelContainer = UIView()
        
        let xTitleLabel = UILabel()
        let xValueLabel = UILabel()
        
        let yTitleLabel = UILabel()
        let yValueLabel = UILabel()
        
        let indexTitleLabel = UILabel()
        let indexValueLabel = UILabel()

        let style: ChartStyle
        
        private var yTitleLabelRightConstraint: NSLayoutConstraint!
        private var xValueLabelWidthConstraint: NSLayoutConstraint!
        
        init(style: ChartStyle) {
            self.style = style
            
            super.init(frame: CGRect.zero)
            
            addSubview(titleLabel)
            addSubview(valueLabelContainer)
            
            titleLabel.textAlignment = .center
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            
            valueLabelContainer.translatesAutoresizingMaskIntoConstraints = false
            valueLabelContainer.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            valueLabelContainer.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor).isActive = true
            valueLabelContainer.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor).isActive = true
            valueLabelContainer.rightAnchor.constraint(equalTo: xValueLabel.rightAnchor)
            valueLabelContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            valueLabelContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            
            let spaceWidth = ceil((" " as NSString).size(attributes: style.calloutFieldTitleLabelAttributes).width)
            let maxWidth = CGFloat(style.calloutMaxWidth)
            let contentInset = CGFloat(style.calloutTitlePadding)
            
            func attachBasicConstraintsFor(titleLabel: UILabel, valueLabel: UILabel, topAnchor: NSLayoutYAxisAnchor, bottomAnchor: NSLayoutYAxisAnchor?) {
                valueLabelContainer.addSubview(titleLabel)
                valueLabelContainer.addSubview(valueLabel)
                
                titleLabel.textAlignment = .right
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.leftAnchor.constraint(equalTo: valueLabelContainer.leftAnchor).isActive = true
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentInset).isActive = true
                if let bottomAnchor = bottomAnchor {
                    titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                }
                
                valueLabel.textAlignment = .left
                valueLabel.translatesAutoresizingMaskIntoConstraints = false
                valueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: spaceWidth).isActive = true
                valueLabel.rightAnchor.constraint(lessThanOrEqualTo: valueLabelContainer.rightAnchor).isActive = true
                valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: contentInset).isActive = true
                
                if let bottomAnchor = bottomAnchor {
                    valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                }
            }
            
            attachBasicConstraintsFor(titleLabel: xTitleLabel, valueLabel: xValueLabel, topAnchor: valueLabelContainer.topAnchor, bottomAnchor: nil)
            attachBasicConstraintsFor(titleLabel: yTitleLabel, valueLabel: yValueLabel, topAnchor: xTitleLabel.bottomAnchor, bottomAnchor: nil)
            attachBasicConstraintsFor(titleLabel: indexTitleLabel, valueLabel: indexValueLabel, topAnchor: yTitleLabel.bottomAnchor, bottomAnchor: self.bottomAnchor)
            
            yTitleLabelRightConstraint = yTitleLabel.rightAnchor.constraint(equalTo: valueLabelContainer.centerXAnchor, constant: spaceWidth.negated())
            yTitleLabelRightConstraint.isActive = true
            
            xTitleLabel.rightAnchor.constraint(equalTo: yTitleLabel.rightAnchor).isActive = true
            indexTitleLabel.rightAnchor.constraint(equalTo: yTitleLabel.rightAnchor).isActive = true
            
            xValueLabelWidthConstraint = xValueLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
            xValueLabelWidthConstraint.isActive = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var precision: Int = 0
        
        var chartValue: ChartValue? {
            didSet {
                updateContent()
            }
        }
        
        func updateContent() {
            guard let chartValue = chartValue else {
                for label in [titleLabel, xValueLabel, xTitleLabel, yTitleLabel, yValueLabel, indexTitleLabel, indexValueLabel] {
                    label.attributedText = nil
                }
                return
            }
            
            let fieldTitleAttributes = style.calloutFieldTitleLabelAttributes
            let fieldValueAttributes = style.calloutFieldValueLabelAttributes
            
            let displayIndex = (chartValue.index != nil)
            let isInterpolatedValue = chartValue.interpolated
            
            let decimalPoints = max(min(precision, style.calloutFunctionMaximumPrecision), style.calloutFunctionMiniumPrecision)
            
            let xValue = displayIndex ? "\(chartValue.value.0)" : String(format: "%.\(decimalPoints)f", chartValue.value.0)
            let yValue = displayIndex ? "\(chartValue.value.1)" : String(format: "%.\(decimalPoints)f", chartValue.value.1)
            
            let color: Color
            if let chartValueColor = chartValue.color {
                color = chartValueColor
            }
            else {
                color = Color.black
            }
            
            if let title = chartValue.label {
                let attributes = style.calloutTitleLabelAttributesWith(color: color)
                titleLabel.attributedText = NSAttributedString(string: title, attributes: attributes)
            }
            else {
                titleLabel.attributedText = nil
            }
            
            let valueLabelAttributes = isInterpolatedValue ? fieldTitleAttributes : fieldValueAttributes
            
            xTitleLabel.attributedText = NSAttributedString(string: "x:", attributes: fieldTitleAttributes)
            xValueLabel.attributedText = NSAttributedString(string: xValue, attributes: valueLabelAttributes)
            
            yTitleLabel.attributedText = NSAttributedString(string: "y:", attributes: fieldTitleAttributes)
            yValueLabel.attributedText = NSAttributedString(string: yValue, attributes: valueLabelAttributes)
            
            indexTitleLabel.attributedText = displayIndex ? NSAttributedString(string: "index:", attributes: fieldTitleAttributes) : nil
            indexValueLabel.attributedText = displayIndex ? NSAttributedString(string: "\(chartValue.index!)", attributes: fieldValueAttributes) : nil
            
            setNeedsUpdateConstraints()
        }
        
        fileprivate override func updateConstraints() {
            super.updateConstraints()
            
            guard let chartValue = chartValue else {
                return
            }
            
            guard let xValue = xValueLabel.text, let yValue = yValueLabel.text else {
                return
            }
            
            let fieldTitleAttributes = style.calloutFieldTitleLabelAttributes
            let fieldValueAttributes = style.calloutFieldValueLabelAttributes
            
            let displayIndex = (chartValue.index != nil)
            let isInterpolatedValue = chartValue.interpolated
            
            let valueLabelAttributes = isInterpolatedValue ? fieldTitleAttributes : fieldValueAttributes
            let valueCharacterCount = max(xValue.characters.count, yValue.characters.count)
            let valueLabelWidth = valueLabelWidthFor(characterCount: valueCharacterCount, attributes: valueLabelAttributes)
            
            yTitleLabelRightConstraint.isActive = displayIndex
            xValueLabelWidthConstraint.constant = valueLabelWidth
        }
        
        // Used to cache value label width calculation
        private var digitToWidthMap = [(Int) : CGFloat]()
        
        private func valueLabelWidthFor(characterCount: Int, attributes: [String: AnyObject]) -> CGFloat {
            if characterCount <= 0 { return 0.0 }
            if let cachedWidth = digitToWidthMap[characterCount] {
                return cachedWidth
            }
            var widthCalculationString = "."
            for _ in 1..<characterCount {
                widthCalculationString += "0"
            }
            
            let valueLabelWidth = ceil((widthCalculationString as NSString).size(attributes: attributes).width)
            digitToWidthMap[characterCount] = valueLabelWidth
            return valueLabelWidth
        }
        
    }
    
    let style: ChartStyle
    
    let backgroundLayer: CAShapeLayer
    
    let contentView: CalloutContentView
    
    var chartValue: ChartValue? {
        didSet {
            contentView.chartValue = chartValue
        }
    }
    
    var precision: Int = 0 {
        didSet {
            contentView.precision = precision
        }
    }
    
    fileprivate override var isHidden: Bool {
        didSet {
            if isHidden == false && oldValue == true {
                if let targetLayout = targetLayout {
                    frame = targetLayout.frame
                }
            }
        }
    }
    
    fileprivate var targetLayout: CalloutLayout? {
        didSet {
            if let targetLayout = targetLayout {
                bounds.size = targetLayout.frame.size
            }
        }
    }
    
    init(style: ChartStyle) {
        self.style = style
        
        backgroundLayer = CAShapeLayer()
        contentView = CalloutContentView(style: style)
        
        super.init(frame: CGRect.zero)
        
        backgroundLayer.fillColor = style.calloutBackgroundColor.cgColor
        backgroundLayer.frame = bounds
        layer.addSublayer(backgroundLayer)
        
        let contentInset = CGFloat(style.calloutLabelInset)
        let maxWidth = CGFloat(style.calloutMaxWidth)
        
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentInset).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -contentInset).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: contentInset).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant:-contentInset).isActive = true
    
        let maxWidthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1.0, constant: maxWidth)
        contentView.addConstraint(maxWidthConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override var frame: CGRect {
        didSet {
            updateBackgroundLayer()
        }
    }
    
    func updateBackgroundLayer() {
        guard let chartValue = chartValue else { return }
    
        let cornerRadius = CGFloat(style.calloutCornerRadius)
        let arrowPoint = convert(chartValue.screenPoint, from: superview)
        
        let contentPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        if let arrowPath = arrowPathFor(arrowPoint: arrowPoint) {
            contentPath.append(arrowPath)
        }
        backgroundLayer.path = contentPath.cgPath
    }
    
    func arrowPathFor(arrowPoint: CGPoint) -> UIBezierPath? {
        guard let targetLayout = targetLayout else { return nil }
        
        let arrowLength = CGFloat(style.calloutArrowLength)
        let arrowWidth = arrowLength * 2
        
        let cornerRadius = CGFloat(style.calloutCornerRadius)
        let insetBounds = bounds.insetBy(dx: cornerRadius, dy: cornerRadius)
        
        let trianglePath = UIBezierPath()
        if targetLayout.direction.isVertical {
            let yPos = targetLayout.direction == .up ? bounds.maxY : bounds.minY
            let arrowExtension = targetLayout.direction == .up ? arrowLength : arrowLength.negated()
            let triangleLeftCorner = max(insetBounds.minX, min(arrowPoint.x - arrowLength, insetBounds.maxX - arrowWidth))
            trianglePath.move(to: CGPoint(
                x: triangleLeftCorner,
                y: yPos))
            trianglePath.addLine(to: CGPoint(
                x: triangleLeftCorner + arrowWidth,
                y: yPos))
            trianglePath.addLine(to: CGPoint(
                x: triangleLeftCorner + arrowLength,
                y: yPos + arrowExtension))
        }
        else {
            let xPos = targetLayout.direction == .left ? bounds.maxX : bounds.minX
            let arrowExtension = targetLayout.direction == .left ? arrowLength : arrowLength.negated()
            let triangleTopCorner = max(insetBounds.minY, min(arrowPoint.y - arrowLength, insetBounds.maxY - arrowWidth))
            trianglePath.move(to: CGPoint(
                x: xPos,
                y: triangleTopCorner))
            trianglePath.addLine(to: CGPoint(
                x: xPos,
                y: triangleTopCorner + arrowWidth))
            trianglePath.addLine(to: CGPoint(
                x: xPos + arrowExtension,
                y: triangleTopCorner + arrowLength))
        }
        
        return trianglePath
    }
    
}

