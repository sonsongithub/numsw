//
//  RenderViewController.swift
//  sandbox
//
//  Created by color_box on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit
import CoreGraphics

public func addLine(x: [Double], y: [Double]) {
    let cgPoints = zip(x, y).map {
        CGPoint(x: $0.0, y:$0.1)
    }
    
    let renderer = LineGraphRenderer(lines: [
        LineData(points: cgPoints)
        ])
    
    add(renderer: renderer)
}

public func addLine2(x: [Double], y: [Double],
                     x2: [Double], y2: [Double]) {
    let cgPoints = zip(x, y).map {
        CGPoint(x: $0.0, y: $0.1)
    }
    
    let cgPoints2 = zip(x2, y2).map {
        CGPoint(x: $0.0, y: $0.1)
    }
    
    let renderer = LineGraphRenderer(lines: [
        LineData(points: cgPoints),
        LineData(points: cgPoints2)
        ])
    
    add(renderer: renderer)
}



//public func append(renderer:Renderer){
//    RenderViewController.shared.renderers.append(renderer)
//    RenderViewController.shared.render()
//}

public func appendHoge(){
    RenderViewController.shared.renderers.append(LineGraphRenderer(lines: [
        LineData(points: DummyData.points1()),
        LineData(points: DummyData.points2())
        ]
    ))
    RenderViewController.shared.render()
}


public func add(renderer: Renderer) {
    RenderViewController.shared.renderers.append(renderer)
}

public func testMakeRenderer() {
    add(renderer: makeRenderer())
}

public func makeRenderer() -> LineGraphRenderer {
    return LineGraphRenderer(lines: [
        LineData(points: DummyData.points1()),
        LineData(points: DummyData.points2())
        ])
}

class RenderViewController: UIViewController {

    func makeRenderer() -> LineGraphRenderer {
        return LineGraphRenderer(lines: [
            LineData(points: DummyData.points1()),
            LineData(points: DummyData.points2())
            ]
        )
    }


    static var shared:RenderViewController!

    var renderers:[Renderer] = []

    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        RenderViewController.shared = self

        scrollView = UIScrollView()
        scrollView.frame = self.view.frame

        self.view.addSubview(scrollView)


//        renderers.append(makeRenderer())
//        renderers.append(makeRenderer())
//        renderers.append(makeRenderer())
//        renderers.append(makeRenderer())

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
