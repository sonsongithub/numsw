//
//  RendererDebugViewController.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

class RendererDebugViewController : UIViewController {
    
    required init() {
        super.init(nibName: "RendererDebugViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
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
        
        renderer = makeRenderer()
        
    }
    
    var renderer: Renderer?
    
    @IBOutlet var imageView: UIImageView!

    @IBAction func onRenderButton(sender: UIButton) {        
        let image = renderer!.renderToImage(size: imageView.bounds.size)
        imageView.image = image
    }
    
    @IBAction func onClearButton() {
        imageView.image = nil
    }
    
}

