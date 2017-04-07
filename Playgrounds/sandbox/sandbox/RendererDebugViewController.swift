//
//  RendererDebugViewController.swift
//  sandbox
//
//  Created by omochimetaru on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

#if os(iOS)
import UIKit

import NumswRenderer

class RendererDebugViewController: UIViewController {
    
    required init() {
        super.init(nibName: "RendererDebugViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
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
#endif
