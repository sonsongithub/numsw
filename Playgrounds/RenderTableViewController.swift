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

#if SANDBOX_APP
    //  sandbox app
#else
    //  playground
    import PlaygroundSupport
#endif
    
public class RenderTableViewController: UITableViewController, UZTextViewDelegate {
    
    private var renderers: [Renderer] = [] {
        didSet {
            for i in 0..<renderers.count {
                renderers[i].parentViewSize = self.tableView.frame.size
            }
            tableView.reloadData()
        }
    }
    
    internal class State {
        private enum Key: String {
            case tableViewScrollOffsetX = "table_view_scrolloffset_x"
            case tableViewScrollOffsetY = "table_view_scrolloffset_y"
            case rendererCount = "renderer_count"
        }
        
        var tableViewScrollOffset: CGPoint = .zero
        init() {
            let kvs = PlaygroundKeyValueStore.current
            if let xValue = kvs[Key.tableViewScrollOffsetX.rawValue],
                case .floatingPoint(let x) = xValue,
                let yValue = kvs[Key.tableViewScrollOffsetY.rawValue],
                case .floatingPoint(let y) = yValue {
                tableViewScrollOffset = CGPoint(x: x, y: y)
            } else {
                tableViewScrollOffset = .zero
            }
        }
        
        func reset() {
            tableViewScrollOffset = .zero
        }
        
        func sync() {
            let kvs = PlaygroundKeyValueStore.current
            kvs[Key.tableViewScrollOffsetX.rawValue] = .floatingPoint(Double(tableViewScrollOffset.x))
            kvs[Key.tableViewScrollOffsetY.rawValue] = .floatingPoint(Double(tableViewScrollOffset.y))
        }
    }
    
    private var state: State
    
    internal init(state: State) {
        self.state = state
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
    
    // not in use?
    /*public func replace(renderers: [Renderer]) {
        self.renderers = renderers
        self.tableView.reloadData()
    }*/
    
    public func removeAllRenderers() {
        self.renderers = []
        self.tableView.reloadData()
    }
    
    public func append(renderer: Renderer) {
        // partial update
        self.renderers.append(renderer)
        //self.tableView.insertRows(at: [IndexPath(row: renderers.count-1, section: 0)], with: .none)
        tableView.reloadData()
        
        // scroll to previous content position
        let lastRowOffset = tableView.rectForRow(at: IndexPath(row: renderers.count-1, section: 0))
        
        let viewBounds = UIEdgeInsetsInsetRect(view.bounds, tableView.contentInset)
        let maxYOffset = max(lastRowOffset.origin.y + lastRowOffset.size.height - viewBounds.size.height, 0) // 0 ~
        let offset = CGPoint(x: state.tableViewScrollOffset.x, y: min(maxYOffset, state.tableViewScrollOffset.y))
        tableView.setContentOffset(offset, animated: false)
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
            (view as? RenderTableViewCell)?.updateImageViewIfNeeded()
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
        state.reset()
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
    
    #if SANDBOX_APP
    // Tap any table view cell to dismiss
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
    #endif
    
    public override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        storeTableViewScrollOffset()
    }
    
    public override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        storeTableViewScrollOffset()
    }
    
    public override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        storeTableViewScrollOffset()
    }
    
    private func storeTableViewScrollOffset() {
        // store tableview scroll offset
        state.tableViewScrollOffset = tableView.contentOffset
        state.sync()
    }
}
#endif
