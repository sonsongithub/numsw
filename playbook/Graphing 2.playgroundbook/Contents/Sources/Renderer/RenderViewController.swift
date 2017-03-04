//
//  RenderViewController.swift
//  sandbox
//
//  Created by color_box on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

class RenderViewController: UIViewController {

    var renderers:[Renderer] = []

    var scrollView: UIScrollView!

//    func scrollView() -> UIScrollView{
//        return self.scrollView
//        return self.view.viewWithTag(999) as! UIScrollView
//    }


    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView()
        scrollView.frame = self.view.frame

        self.view.addSubview(scrollView)

        func makeRenderer() -> LineGraphRenderer {
            return LineGraphRenderer(points: DummyData.points1())
        }

        renderers.append(makeRenderer())
        renderers.append(makeRenderer())
        renderers.append(makeRenderer())
        renderers.append(makeRenderer())

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.render()

    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateViews(){
        for view in scrollView.subviews{
            view.removeFromSuperview()
        }
        scrollView.contentSize.height = 0
        self.render()
    }


    func render(){

        let size = self.view.frame.size
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
