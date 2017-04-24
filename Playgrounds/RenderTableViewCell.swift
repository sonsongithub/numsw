//
//  RenderTableViewCell.swift
//  sandbox
//
//  Created by sonson on 2017/04/07.
//  Copyright © 2017年 sonson. All rights reserved.
//

#if os(iOS)
import UIKit

internal class RenderTableViewCell: UITableViewCell {
        
    private static let renderQueue = DispatchQueue(label: "Renderer-Queue")
    
    var renderer: Renderer? {
        willSet {
            self.renderImageView.image = nil
            self.renderedImageSize = .zero
        }
    }
    
    private let renderImageView = UIImageView(frame: .zero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        //print("RenderTableViewCell init")
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
        //print("RenderTableViewCell deinit")
    }
    
    private var renderedImageSize = CGSize.zero
    
    private var isImageViewDirty: Bool {
        return renderedImageSize != self.contentView.bounds.size
    }
    
    func updateImageViewIfNeeded() {
        print("rendering bounds: \(self.contentView.bounds)")
        if isImageViewDirty == false &&
            self.renderImageView.image != nil {
            // already rendered
            return
        }
        updateImageView()
    }
    
    private func updateImageView() {
        guard let renderer = self.renderer else { return }
        let withFadeAnimation = isImageViewDirty && self.renderImageView.image != nil
        
        renderedImageSize = self.contentView.bounds.size
        type(of: self).renderQueue.async {
            let image = renderer.renderToImage(size: self.contentView.bounds.size)
            DispatchQueue.main.async {
                self.renderImageView.image = image
                
                if withFadeAnimation {
                    let transition = CATransition()
                    transition.duration = 0.25
                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    transition.type = kCATransitionFade
                    self.renderImageView.layer.add(transition, forKey: nil)
                }
            }
        }
    }
}
#endif
