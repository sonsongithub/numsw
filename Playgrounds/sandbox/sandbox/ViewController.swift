//
//  ViewController.swift
//  sandbox
//
//  Created by sonson on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import NumswRenderer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    @IBAction func onRightButton(sender: UIButton) {
        let vc = RendererDebugViewController()
        present(vc, animated: true)
    }
    @IBAction func onLeftButton(_ sender: Any) {
        func makeRenderer() -> ChartRenderer {
            let points1 = DummyData.points1()
            let points2 = DummyData.points2()
            
            var chart = Chart()
            chart.elements = [
                .line(LineGraph(points: points1)),
                .line(LineGraph(points: points2))
            ]
            chart.computeViewport()
            
            return ChartRenderer(chart: chart)
        }
        
        let vc = RenderScrollViewController()
        
        vc.append(renderer: makeRenderer())
        vc.append(renderer: makeRenderer())
        vc.append(renderer: makeRenderer())
        vc.append(renderer: TextRenderer("hoge"))
        
        present(vc, animated: true)
    }
    
    @IBAction func onTestButton(sender: UIButton) {
        DummyData.runHoldExample()
        present(NumswPlayground.shared.viewController, animated: true)
    }

}
