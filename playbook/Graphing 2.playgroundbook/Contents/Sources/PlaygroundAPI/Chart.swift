//
//  Chart.swift
//  Charts
//

import UIKit

private let PresentationPaddingPercent = 0.10

public struct Bounds {
    public var minX: Double
    public var maxX: Double
    public var minY: Double
    public var maxY: Double
    
    static let infinite = Bounds(minX: .infinity, maxX: .infinity, minY: .infinity, maxY: .infinity)
}

internal extension Bounds {
    func contains(data: (Double, Double)) -> Bool {
        if data.0 < minX { return false }
        if data.0 > maxX { return false }
        if data.1 < minY { return false }
        if data.1 > maxY { return false }
        return true
    }
}

internal struct Insets {
    internal var top = 0.0
    internal var left = 0.0
    internal var bottom = 0.0
    internal var right = 0.0
}

private let BottomPadForStopButton = 90.0
private let BottomInsetThreshold = 100.0

public class Chart {
    
    /// The single shared chart that all plots are automatically added to.
    public static let shared = Chart()
    
    internal let backingView: UIView = ChartView()
    
    internal var chartView: ChartView {
        return backingView as! ChartView
    }
    
    private var chartDrawableAddObserverToken: AnyObject?
    
    private var boundsHaveBeenProgrammaticallySet = false
    
    /// The bounds of this chart (minimum x, maximum x, minimum y, and maximum y).
    public var bounds: Bounds {
        get {
            return chartView.axisBounds
        }
        set {
            chartView.axisBounds = newValue
            boundsHaveBeenProgrammaticallySet = true
        }
    }
    
    private var bottomInsetBeforeShowingKeyboard = 0.0
    
    private var keyBoardWillShowNotificationObserver: AnyObject?
    private var keyBoardWillHideNotificationObserver: AnyObject?
    
    private init() {
        backingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        chartDrawableAddObserverToken = NotificationCenter.default.addObserver(forName: NSNotification.Name(ChartDrawableWasAddedNotification), object: nil, queue: nil) { [weak self] notification in
            let chartDrawable = notification.object as! ChartDrawable
            self?.snapToChartDrawableDataBounds(chartDrawable: chartDrawable)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(chartDrawableAddObserverToken!)
    }
    
    private func snapToChartDrawableDataBounds(chartDrawable: ChartDrawable) {
        
        guard !boundsHaveBeenProgrammaticallySet else { return }
        guard !chartView.userHasPannedOrZoomed else { return }
        
        let chartViewBounds = chartView.axisBounds
        
        // figure out the bounding box around all the drawables.
        var boundsOfAllChartDrawables = Bounds.infinite
        for chartDrawable in chartView.chartDrawables {
            let otherDrawablesDataBounds = chartDrawable.boundsOfData(inChartView: chartView)
            boundsOfAllChartDrawables = boundsOfAllChartDrawables.unionIgnorningInfinity(otherDrawablesDataBounds)
        }
        
        // If we've calculated a zero bounds for our data, default to a 2x2 bounds.
        if boundsOfAllChartDrawables.isEmpty {
            boundsOfAllChartDrawables = Bounds(minX: -1, maxX: 1, minY: -1, maxY: 1)
        }
        
        // if the x delta is 0 increase it to match the y delta
        if boundsOfAllChartDrawables.deltaX == 0 {
            boundsOfAllChartDrawables.minX -= boundsOfAllChartDrawables.deltaY / 2
            boundsOfAllChartDrawables.maxX += boundsOfAllChartDrawables.deltaY / 2
        }

        // if the y delta is 0 increase it to match the x delta
        if boundsOfAllChartDrawables.deltaY == 0 {
            boundsOfAllChartDrawables.minY -= boundsOfAllChartDrawables.deltaX / 2
            boundsOfAllChartDrawables.maxY += boundsOfAllChartDrawables.deltaX / 2
        }
        
        let xPad = boundsOfAllChartDrawables.deltaX * PresentationPaddingPercent
        let yPad = boundsOfAllChartDrawables.deltaY * PresentationPaddingPercent

        // if the x dimension is discrete, inset it a bit.
        if !xPad.isNaN {
            boundsOfAllChartDrawables.minX -= xPad
            boundsOfAllChartDrawables.maxX += xPad
        }

        // if the y dimension is discrete, inset it a bit.
        if !yPad.isNaN {
            boundsOfAllChartDrawables.minY -= yPad
            boundsOfAllChartDrawables.maxY += yPad
        }
        
        // clamp the data bounds to be finite (infinite bounds are clamped the the current chart bounds).
        boundsOfAllChartDrawables.minX = boundsOfAllChartDrawables.minX.isFinite ? boundsOfAllChartDrawables.minX : chartViewBounds.minX
        boundsOfAllChartDrawables.maxX = boundsOfAllChartDrawables.maxX.isFinite ? boundsOfAllChartDrawables.maxX : chartViewBounds.maxX
        boundsOfAllChartDrawables.minY = boundsOfAllChartDrawables.minY.isFinite ? boundsOfAllChartDrawables.minY : chartViewBounds.minY
        boundsOfAllChartDrawables.maxY = boundsOfAllChartDrawables.maxY.isFinite ? boundsOfAllChartDrawables.maxY : chartViewBounds.maxY
        
        chartView.axisBounds = boundsOfAllChartDrawables
    }
    
    internal func reset() {
        chartView.removeAllChartDrawables()
        chartView.userHasPannedOrZoomed = false
        boundsHaveBeenProgrammaticallySet = false
        Color.resetCurrentColor()
    }
}

extension Bounds: Equatable {}

public func ==(left: Bounds, right: Bounds) -> Bool {
    return left.minX == right.minX && left.maxX == right.maxX && left.minY == right.minY && left.maxY == right.maxY
}
