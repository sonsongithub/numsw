//
//  TextRenderer.swift
//  sandbox
//
//  Created by sonson on 2017/04/07.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(iOS)
    import UIKit
#endif

#if SANDBOX_APP
    import numsw
#endif

#if os(iOS)
public class TextRenderer: Renderer {
    let string: String
    let attributedString: NSAttributedString
    
    public init(_ aString: String) {
        string = aString
        let font = UIFont.systemFont(ofSize: 18)
        attributedString = NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: UIColor.white])
    }
    
    public var parentViewSize = CGSize.zero {
        didSet {
            if parentViewSize.width > 0 {
                let newSize = UZTextView.size(of: attributedString, restrictedWithin: parentViewSize.width, inset: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
                height = newSize.height
                print(height)
            }
        }
    }
    
    public var cellIdentifier: String {
        return "TextTableViewCell"
    }
    
    public var height: CGFloat = 0
    
    public func update() {
    }
    
    public func render(context: CGContext, windowSize: CGSize) {
    }
    
    private var compositer: CompositeRenderer?
}
#endif
