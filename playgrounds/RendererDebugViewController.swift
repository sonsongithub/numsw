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
        
        renderer = LineGraphRenderer(lines: [
            LineData(points: DummyData.points1()),
            LineData(points: DummyData.points2())
            ])
        
    }
    
    var renderer: Renderer?
    
    @IBOutlet var imageView: UIImageView!

    @IBAction func onRenderButton(sender: UIButton) {
//        print("size = \(imageView.bounds)")
        
        let image = renderer!.render(size: imageView.bounds.size)
        imageView.image = image
    }
    
    @IBAction func onClearButton() {
        imageView.image = nil
    }
    
}

