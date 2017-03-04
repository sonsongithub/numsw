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

    func updateViews(){
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        scrollView.contentSize.height = 0

        self.render()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViews()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.render()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func render(){

        var size = self.view.frame.size
        size.height *= 0.5
        // renderer 取り出してscrollviewに追加
        for renderer in renderers {
            let image = renderer.render(size: size)

            let imageView = UIImageView(image: image)
            imageView.frame.size = size
            imageView.contentMode = .scaleToFill
            imageView.frame.origin = CGPoint(x: 0, y: scrollView.contentSize.height)
            scrollView.addSubview(imageView)
            scrollView.contentSize.height += size.height
        }
    }


}
