//
//  RenderViewController.swift
//  sandbox
//
//  Created by color_box on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

class RenderViewController: UIViewController {


    var renderers: [Renderer] = []

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        func makeRenderer() -> LineGraphRenderer {
            return LineGraphRenderer(points: DummyData.points1())
        }
        
        renderers.append(makeRenderer())
        renderers.append(makeRenderer())
        renderers.append(makeRenderer())
        renderers.append(makeRenderer())

    }


    override func viewWillAppear(_ animated: Bool) {
        self.render()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func render(){

        let size = self.view.frame.size
        // renderer 取り出してscrollviewに追加
        for renderer in renderers {
            let imageView = UIImageView(image: renderer.render(size: size))
            imageView.frame.origin = CGPoint(x: 0, y: scrollView.contentSize.height)
            scrollView.addSubview(imageView)
            scrollView.contentSize.height += size.height
        }
    }


}