//
//  RenderViewController.swift
//  sandbox
//
//  Created by color_box on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

/*
public class RenderViewController: UIViewController {

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

    public override func viewDidLoad() {
        super.viewDidLoad()

        RenderViewController.shared = self

        scrollView = UIScrollView()
        scrollView.frame = self.view.frame

        self.view.addSubview(scrollView)
    }


    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.render()

    }


    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViews()
    }

    public override func didReceiveMemoryWarning() {
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

 */

private class RenderTableViewCell: UITableViewCell {
    
    var renderer: Renderer? {
        willSet {
            self.renderImageView.image = nil
        }
    }
    
    private let renderImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("RenderTableViewCell init")
        self.separatorInset = .zero
        renderImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        renderImageView.contentMode = .scaleAspectFit
        self.addSubview(renderImageView)
        renderImageView.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        print("RenderTableViewCell deinit")
    }
    
    func updateImageView() {
        guard let renderer = self.renderer else {
            self.renderImageView.image = nil
            return
        }
        
        let image = renderer.render(size: self.bounds.size)
        self.renderImageView.image = image
    }
}

public class RenderViewController: UITableViewController {
    private let CellIdentifier = "Cell"
    private var renderers: [Renderer] = []
    
    public init() {
        super.init(style: .plain)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        
        tableView.register(RenderTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }
    
    public func append(renderer: Renderer) {
        self.renderers.append(renderer)
        self.tableView.reloadData()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // will ??
        //self.tableView.reloadData()
    }


    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return renderers.count
    }
    
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! RenderTableViewCell
        //cell.textLabel!.text = "Hello \(indexPath)"
        cell.renderer = renderers[indexPath.row]
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.5
    }

    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! RenderTableViewCell
        cell.updateImageView()
    }
}



