//
//  RenderViewController.swift
//  sandbox
//
//  Created by color_box on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

import UIKit

func add(renderer: Renderer) {
    
}

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
        renderImageView.contentMode = .scaleToFill
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

class RenderViewController: UITableViewController {


    private let CellIdentifier = "Cell"
    private var renderers: [Renderer] = []
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        func makeRenderer() -> LineGraphRenderer {
            return LineGraphRenderer(points: DummyData.points1())
        }
        
        for _ in 0...20 {
            renderers.append(makeRenderer())
        }
        
        
        tableView.contentInset = .zero
        tableView.separatorStyle = .none
        
        tableView.register(RenderTableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // will ??
        //self.tableView.reloadData()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return renderers.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as! RenderTableViewCell
        //cell.textLabel!.text = "Hello \(indexPath)"
        cell.renderer = renderers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! RenderTableViewCell
        cell.updateImageView()
    }
}
