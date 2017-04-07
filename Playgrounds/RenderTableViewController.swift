//
//  RenderTableViewController.swift
//  sandbox
//
//  Created by color_box on 2017/03/04.
//  Copyright © 2017年 sonson. All rights reserved.
//

//  Second Implementation with UITableView

#if os(iOS)
import UIKit

public class RenderTableViewController: UITableViewController {
    
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
        
        tableView.register(RenderTableViewCell.self, forCellReuseIdentifier: "RenderTableViewCell")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "TextTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: renderers[indexPath.row].cellIdentifier, for: indexPath)
        switch (cell, renderers[indexPath.row]) {
        case (let cell as RenderTableViewCell, _):
            cell.renderer = renderers[indexPath.row]
        case (let cell as TextTableViewCell, let renderer as TextRenderer):
            cell.textView.attributedString = renderer.attributedString
        default:
            do {}
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
#endif
