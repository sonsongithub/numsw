//
//  RenderTableViewController.swift
//  sandbox
//
//  Created by color_box on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

//  Second Implementation with UITableView

import UIKit

private class RenderTableViewCell: UITableViewCell {
    
    var renderer: Renderer? {
        willSet {
            self.renderImageView.image = nil
            self.renderedImageSize = .zero
        }
    }
    
    private let renderImageView = UIImageView(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        print("RenderTableViewCell init")
        self.separatorInset = .zero
        self.selectionStyle = .none
        renderImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        renderImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(renderImageView)
        renderImageView.frame = self.contentView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("RenderTableViewCell deinit")
    }
    
    private var renderedImageSize = CGSize.zero
    
    func updateImageViewIfNeeded() {
        print("rendering bounds: \(self.contentView.bounds)")
        if renderedImageSize == self.contentView.bounds.size &&
            self.renderImageView.image != nil {
            // already rendered
            return
        }
        updateImageView()
    }
    
    private func updateImageView() {
        guard let renderer = self.renderer else { return }
        let image = renderer.renderToImage(size: self.contentView.bounds.size)
        self.renderImageView.image = image
        renderedImageSize = self.contentView.bounds.size
    }
}

public class RenderTableViewController: UITableViewController {
    private let CellIdentifier = "Cell"
    
    var renderers: [Renderer] = [] {
        didSet {
            for i in 0..<renderers.count {
                renderers[i].parentViewSize = self.tableView.frame.size
            }
            tableView.reloadData()
        }
    }
    
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
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.visibleCells.flatMap({ $0 as? RenderTableViewCell}).forEach({ $0.updateImageViewIfNeeded() })
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return renderers.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        if let cell = cell as? RenderTableViewCell {
            cell.renderer = renderers[indexPath.row]
        }
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return renderers[indexPath.row].height
    }

    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? RenderTableViewCell {
            cell.updateImageViewIfNeeded()
        }
    }
}
