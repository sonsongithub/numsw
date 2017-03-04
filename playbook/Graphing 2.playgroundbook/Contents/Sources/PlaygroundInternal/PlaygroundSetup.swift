//
//  PlaygroundSetup.swift
//  Charts
//

import UIKit
import PlaygroundSupport

class ChartViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {
    
    override func loadView() {
        self.view = Chart.shared.chartView
    }
    
    override func viewDidLoad() {
        if let chartView = view as? ChartView {
            chartView.safeAreaLayoutGuide = liveViewSafeAreaGuide
        }
    }

}


public func _setup() {
    PlaygroundPage.current.liveView = ChartViewController()
}

public func _setupRender(){

    let viewController:RenderViewController = RenderViewController()

    PlaygroundPage.current.liveView = viewController as! UIViewController

}
