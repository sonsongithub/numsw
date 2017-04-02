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
import QuartzCore
    
public class RenderTableViewController: UITableViewController, UZTextViewDelegate {
    
    private var renderers: [Renderer] = [] {
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
        
        self.view.backgroundColor = .black
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 84, right: 0)
        tableView.separatorStyle = .none
        
        tableView.register(RenderTableViewCell.self, forCellReuseIdentifier: "RenderTableViewCell")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "TextTableViewCell")
    }
    
    public func replace(renderers: [Renderer]) {
        self.renderers = renderers
        self.tableView.reloadData()
    }
    
    public func append(renderer: Renderer) {
        // partial update
        self.renderers.append(renderer)
        self.tableView.insertRows(at: [IndexPath(row: renderers.count, section: 0)], with: .automatic)
    }

    // some times not invoked?? on iPad playground
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateVisibleCellImagesIfNeeded()
    }
    
    // some times not invoked?? on iPad playground
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateVisibleCellImagesIfNeeded()
    }
    
    private func updateVisibleCellImagesIfNeeded() {
        // on orientation changed
        for view in tableView.visibleCells {
            (view as! RenderTableViewCell).updateImageViewIfNeeded()
        }
    }
    
    // some times not invoked?? on iPad playground
    /*public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateVisibleCellImagesIfNeeded()
        
        super.viewWillTransition(to: size, with: coordinator)
    }*/
    
    // TODO: 
    // `view*LayoutSubviews` seems to be not invoked on iPad playground
    // temporary, we use this deprecated method until the solution is found
    public override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        super.willAnimateRotation(to: toInterfaceOrientation, duration: duration)
        updateVisibleCellImagesIfNeeded()
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
            cell.textView.delegate = self
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
    
    public func textView(_ textView: UZTextView, didClickLinkAttribute attribute: Any) {
    }
    
    public func textView(_ textView: UZTextView, didLongTapLinkAttribute attribute: Any) {
    }
    
    public func selectingStringBegun(_ textView: UZTextView) {
        self.tableView.isScrollEnabled = false
    }
    
    public func selectingStringEnded(_ textView: UZTextView) {
        self.tableView.isScrollEnabled = true
    }
}
#endif
