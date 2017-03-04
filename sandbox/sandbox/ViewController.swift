//
//  ViewController.swift
//  sandbox
//
//  Created by sonson on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

                
    }
    
    @IBAction func onRightButton(sender: UIButton) {
        let vc = RendererDebugViewController()
        present(vc, animated: true)
    }
    @IBAction func onLeftButton(_ sender: Any) {
        
        let vc = RenderViewController()
        present(vc, animated: true)
        
    }

}

